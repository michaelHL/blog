---
title: Matlab 程序设计之编程基础
date: 2018-07-06 01:10:39
tags:
    - Matlab
categories: Memos
mathjax: true
---


本系列试图将笔者在研究过程中认为比较重要、容易遗忘以及富有创新性或启发性的程序代码及思想一一记录，一来节省遇见同类问题时耗费在检索资料上的时间，二来也能见证自己构建知识体系框架的历程。

<!-- more -->

新版本的马特来布添加了诸多与时俱进的特性和工具箱，一直为人诟病的画图也自带抗锯齿了，R2016b 后的版本也支持脚本中函数了。MathWorks 始终坚持半年一新地迭代着 Matlab 的版本，可见其非常地用心。花了三天时间分别在 Windows 10 及 Ubuntu 16.04 x64 下安装好 Matlab，~~因个人感觉 2017 以后的版本在 Windows 上卡顿明显，所以~~ Win 和 Linux 下的版本均为 R2017b。当然后者是面向终端的命令行版的：

```bash
/usr/local/MATLAB/R2017b/bin/matlab -nodisplay
```

目前参考的书籍有：

- 《MATLAB 语言常用算法程序集》（电子版）
- 《MATLAB 之父：编程实践》（电子版）
- 《高等应用数学问题的 MATLAB 求解》（电子版）
- 《MATLAB 数值计算》（电子版）
- 《大学数学实验》（电子版）
- 《MATLAB 统计分析与应用：40 个案例分析》
- 《MATLAB 数学建模》
- 《MATLAB 数值计算实战》

说实话，有点贪心，但也是种挑战。若能在短时间内去其糟粕取其精华，相比也是种奇妙的学习体验。

一般社会哥人狠话不多，闲话至此，下面进入没有主题的正题。

Linux 下安装的时候出现了点小插曲，在其中一台 Ubuntu 16.04.4 的机器上安装完 Matlab 2017b 后，无法使用数学符号工具箱，出现如下错误：

```Matlab
>> syms a b c;
Error using mupadmex
Error in MuPAD command: .
Error in symengine
Error in sym (line 189)
        symengine;
Error in syms (line 197)
toDefine = sym(zeros(1, 0));
```

搜寻所有可能与该问题相关的途径后， 无论是更新、回滚 `fontconfig`，`libfreetype` 版本还是重新安装其他版本 Matlab for Linux 后均无效，说明 Linux 下操作系统状态对 Matlab 有一定影响，遂放弃此台服务器。

由于笔者的系统为英文系统，而 Windows 下区分系统 Locale 的方式在于「格式」而非「地区」（具体设置为 Control Panel - Clock, Language, and Region - Region - Formats），所以会出现两个显著问题：程序界面为英文、编辑器里中文乱码。界面为英文倒不能说是问题，但乱码就很令人头疼了。查阅资料后得到的比较一劳永逸的方法是改动「格式」为中国。其他方法如修改文件 `lcdata.xml` 经亲测并不考谱。另，若仍坚持在英文系统下使用 Matlab，并需输出中文，务必运行语句
```matlab
feature('DefaultCharacterSet', 'UTF-8');
```

-----------------------------------

## Vim 插件

在 `.vimrc` 中添加：

```vim .vimrc
Plugin 'michaelHL/matlab-screen'
Plugin 'tdehaeze/matlab-vim'

map <F8> :call CompileRun()<CR>
func! CompileRun()
    exec "w"
    if &filetype == 'c'
       :!clear; gcc -std=c11 -Wall % -o %<; time ./%<
    elseif &filetype == 'matlab'
       :call RunMatlabCurrentFile()
    endif
endfunc
```

在 Vim 中打开 `.m` 文件，`F8` 即可运行。



## 基本命令及快捷键

| 命令                   | 功能                                                           | 命令              | 功能                                           |
| :---                   | :----                                                          | :---              | :----                                          |
| `clc`                  | 清屏（甚至清除了缓冲区）                                       | `clear`           | 清除工作空间所有变量                           |
| `clear all`            | 从工作空间清除所有变量和函数                                   | `clear <变量名>`  | 清除指定变量                                   |
| `clf`                  | 清除图形窗口内容（注意该命令会弹出新的画布，相当于 `figure` ） | `delete <文件名>` | 从**磁盘**中删除文件                           |
| `cla`                  | 清空当前坐标系                                                 | `type`            | 显示 m 文件的内容                              |
| `help <命令名>`        | 获取所列命令的帮助信息                                         | `which <文件名>`  | 查找指定文件路径                               |
| `who`                  | 显示当前工作空间所有变量的一个**简单列表**                     | `whos`            | 列出变量大小、数据格式等**详细信息**           |
| `what`                 | 列出当前目录下的 `.m` 文件和 `.mat` 文件                       | `load name`       | 下载 `name` 文件中的所有变量到工作空间         |
| `load name x y`        | 下载 `name` 文件的变量 `x`, `y` 到工作空间                     | `importdata name` | 将 `name` 文件中的数据以结构体方式导入工作空间 |
| `save name`            | 保存工作空间变量到文件 `name.mat` 中                           | `save name x y`   | 保存工作空间变量 `x`, `y` 到文件 `name.mat` 中 |
| `↑` 或 `<C-p>`         | 调用上一行命令                                                 | `↓` 或 `<C-n>`    | 调用下一行命令                                 |
| `←` 或 `<C-b>`         | 退后一格                                                       | `→` 或 `<C-f>`    | 前移一格                                       |
| `Home` 或 `<C-a>`      | 光标移至行首                                                   | `Home` 或 `<C-e>` | 光标移至行尾                                   |
| `Esc` 或 `<C-u>`       | 清除一行                                                       | `Del` 或 `<C-d>`  | 清除光标后字符                                 |
| `Backspace` 或 `<C-h>` | 清除光标前一个字符                                             | `<C-k>`           | 清除光标至行尾字符                             |
| `<C-0>`                | 激活命令窗口                                                   | `<C-S-0>`         | 激活编辑器窗口                                 |
| `<C-1>`                | 激活命令历史窗口                                               | `<C-2>`           | 激活「当前目录」窗口                           |
| `<C-3>`                | 激活工作空间窗口                                               |                   |                                                |

如果以上键盘快捷键部分无效，说明是时候把键盘主题改为 Emacs-Style 了：Preference - MATLAB - Keyboard - Shortcuts - Active settings: Emacs Default Set。

## 常用的帮助命令

| 命令 | 功能 | 命令 | 功能 |
| :--  | :--  | :--  | :--  |
| `help matfun` | 矩阵函数 - 数值线性代数 | `help datafun` | 数据分析和傅立叶变换函数 |
| `help general` | 通用命令 | `help ops` | 操作符和特殊字符 |
| `help graphics` | 通用图形函数 | `help polyfun` | 多项式和内插函数 |
| `help elfun` | 基本的数学函数 | `help lang` | 语言结构和调试 |
| `help elmat` | 基本的矩阵和矩阵操作 | `help strfun` | 字符串函数 |
| `help control` | 控制系统工具和工具箱函数 | | |

## 部分预定义变量

| 变量或函数 | 说明 | 变量或函数 | 说明 |
| :--  | :--  | :--  | :--  |
| `ans` | 默认变量名，以应答最近一次操作运算结果 | `eps` | 浮点数的相对误差 |
| `i`, `j` | 虚数单数 | `pi` | 圆周率 |
| `intmax` | 本计算机能表示的 8 位、16 位、32 位、64 位的最大整数 | `intmin` | 本计算机能表示的 8 位、16 位、32 位、64 位的最小整数 |
| `realmax` | 本计算机能表达的最大浮点数 | `realmin` | 本计算机能表达的最小浮点数 |
| `Inf` 或 `inf` | 无穷大 | `NaN` 或`nan` | 非数 |
| `computer` | MATLAB 运行平台 | `version` | MATLAB 版本字符串 |

## 数据显示格式

摘自 [MathWorks 文档 - 设置命令行窗口输出显示格式](https://ww2.mathworks.cn/help/matlab/ref/format.html)：

|   风格   |   结果  |   示例  |
|   :-- |   :-- |   :-- |
|   `short (default)` |   固定十进制短格式，小数点后包含 4 位数   |   3.1416  |
|   `long`    |   长固定小数格式，double 值的小数点后包含 15 位数，single 值的小数点后包含 7 位数 |   3.141592654 |
|   `shortE`  |   短科学记数法，小数点后包含 4 位数 |   3.14E+00    |
|   `longE`   |   长科学记数法，double 值的小数点后包含 15 位数，single 值的小数点后包含 7 位数  |   3.14E+00    |
|   `shortG`  |   短固定小数格式或科学记数法（取更紧凑的一个），总共 5 位  |   3.1416  |
|   `longG`   |   长固定小数格式或科学记数法（取更紧凑的一个），对于 double 值，总共 15 位；对于 single 值，总共 7 位  |   3.141592654 |
|   `shortEng`    |   短工程记数法，小数点后包含 4 位数，3 的倍数   |   3.14E+00    |
|   `longEng` |   长工程记数法，包含 15 位有效位数，指数为 3 的倍数   |   3.14E+00    |
|   `+`   |   正/负格式，对正、负和零元素分别显示 +、- 和空白字符   |   +   |
|   `bank`    |   货币格式，小数点后包含 2 位数   |   3.14    |
|   `hex` |   二进制双精度数字的十六进制表示形式  |   400921fb54442d18    |
|   `rat` |   小整数的比率 |   355/113 |
|   `compact` |    隐藏过多的空白行以便在一个屏幕上显示更多输出 | theta = pi/2 <br> theta =<br> &nbsp; &nbsp; 1.5708 |
|   `loose` |   添加空白行以使输出更易于阅读 | theta = pi/2 <br><br> theta = <br><br> &nbsp; &nbsp; 1.5708

## 数值型数据

关于整型数据相关的操作函数（操作数可以是浮点数，也就是默认的数值类型）

| 函数 | 说明 | 函数 | 说明 |
| :--- | :--- | :--- | :--- |
| `ceil` | 向正无穷大方向取整 | `fix` | 向 0 取整 |
| `floor` | 向负无穷大方向取整 | `round` | 四舍五入取整 |
| `isinteger` | 判断是否为整数 | `mod` / `rem` | 求模 / 余数 |

关于虚数的一些操作函数

| 函数 | 说明 | 函数 | 说明 |
| :--- | :--- | :--- | :--- |
| `isreal` | 检查是否为实数 | `abs` | 求复数幅值 |
| `real` | 返回复数实部 | `angle` | 求复数相位 |
| `imag` | 返回复数虚部 | `conj` | 返回复数的共轭复数 |

## 字符向量及字符串

类似于 C 语言里的「字符数组」， Matlab 中的字符向量也是以字符数组形式存在的。如 `size('abc\nabc')` 返回 8。字符向量可由 `[...]` 以及 `char` 来创建。常见的字符向量操作函数如下表：

| 函数 | 说明 | 函数 | 说明 |
| :--- | :--- | :--- | :--- |
| `ischar` | 检查是否为字符数组 | `isletter` | 检查数组元素是否为字母 |
| `isspace` | 检查数组元素是否为空格 | `isstrprop` | 判断字符串是否属于某种特定类型 |
| `strcat` | 横向连接字符数组 | `strvcat` | 纵向连接字符数组，建议用 `char` |
| `blanks` | 创建空字符串 | `strjust` | 调整字符串的对齐方式 |
| `strtrim` | 去掉字符串首尾的空格 | `deblank` | 去掉字符串尾部的空格 |
| `strfind` | 在长字符串中搜索短字符串 | `strtok` | 找出字符串中第一个分隔符前面的部分 |
| `strrep` | 字符串查找与替换 | `strmatch` | 查找匹配的字符串 |
| `lower` | 将字符串中所包含的字母转换为小写 | `upper` | 将字符串中所包含的字母转换为大写 |
| `strcmp` <br> `strcmpi` | 字符串比较，后者忽略大小写 | `strncmp` <br> `strncmpi` | 比较字符串前 n 个字符，后者忽略大小写 |
| `strjoin` | 将字符串元胞连接成一个字符串 | `strsplit` | 将字符串分割成字符串元胞数组 |
| `sprintf` | 格式化输出数据至字符串 | `sscanf` | 从字符串中读取格式化数据 |
| `regexp` <br> `regexpi` | 匹配正则表达式，后者忽略大小写 | `regexprep` | 使用正则表达式替换文本 |
| `regexptranslate` | 将文本转换为正则表达式 | | |

令人吃驚的是，**R2017a** 以前的版本都不可用「双引号」括住字符以表示字符串。摘自 [MathWorks 文档 - 字符串数组](https://ww2.mathworks.cn/help/matlab/ref/string.html)：

> 从 R2016b 开始，您可以使用字符串数组而不是字符数组来表示文本。字符串数组的每个元素存储一个字符序列。序列可以具有不同长度，无需填充，例如 "yes" 和 "no"。只有一个元素的字符串数组也称为字符串标量。  
> 您可以通过用双引号括起一段文本来创建字符串。从 R2017a 开始引入双引号。

针对字符数组 / 向量和字符串，有必要做一系列探究。

最基本的 `char(A)` 或 `char(A1, ... , An)` 将数组 A 转为字符数组，相当于 Perl / Python 中的 `chr`，当然这里是向量版：

```matlab
char(65:90, 97:122)
strcat(65:90, 97:122)

%  2x26 char array
%    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
%    'abcdefghijklmnopqrstuvwxyz'
%
%  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
```

字符向量可由 `disp` 直接输出：

```matlab
disp(['Euler''s Formula: ', latex(sym('exp(i*pi)+1=0'))]);
% Euler's Formula: {\mathrm{e}}^{\pi \,i}+1=0
```

当然上面这个例子会跳出将来会弃用字符向量的警告，这里仅说明 `char` 的功效，无视即可。更多关于 `char` 的说明：

- 如果 A 是数值数组，则 char 将数值转换为字符。有效数值范围从 0 到 65535，并且对应于 Unicode® 代码单元。值 0 到 127 还对应于 7 位 ASCII 字符。char 函数：
  - 将非整数值向零舍入。
  - 将小于 0 的值视为 0。
  - 将大于 65535 的值视为 65535。
- 如果 A 是字符数组，则 char 返回未改变的 A。
- 如果 A 是字符数组元胞数组，则 char 将该元胞数组转换为字符数组。元胞数组中每个字符数组的每一行将变成 C 中的一行，并根据需要自动用空格填充。
- 如果 A 是分类数组，则 char 按列顺序将 A 的每个元素转换为字符数组的一行。
- 如果 A 是字符串数组，则 char 会将字符串数组转换为字符数组。char 会将 A 中的每个字符串元素转换为字符向量，然后将这些字符向量串联成字符数组，并根据需要自动用空格填充。

除此之外，`char` 还可以格式化时间：

```matlab
char(datetime, 'yyyy-M-d hh:mm')
% '2018-7-7 11:44'
```

而 `string` 函数显得更为「高阶」一些，下面的例子可以明显看出区别：

```matlab
matlabcode = [109 97 116 108 97 98];
disp(char(matlabcode));
disp(string(matlabcode));

% matlab
%    "109"    "97"    "116"    "108"    "97"    "98"
```

`string` 将数据看成一个整体进行操作（利用 `size` 可以看出），而不像 `char` 一样需要对齐数据以纳入矩阵。

另外，对于 `strsplit` 和 `split`，大体可认为互为转置的关系：

```matlab
carray = 'm a t l a b';
str = string(carray);
strsplit(carray)          % {'m'} {'a'} {'t'} {'l'} {'a'} {'b'}
split(carray)             % strsplit(carray)'
strsplit(str)             % "m" "a" "t" "l" "a" "b"
split(str)                % strsplit(str)'
```

## 元胞数组、结构体以及表数组

对于元胞数组，注意索引 `C(m, n)` 返回 C 在 `(m, n)` 位置上的元胞，而花括号 `C{m, n}` 返回数据。

对于结构体的创建，一般有两种方法：

- 使用 `.` 创建：
  {% codeblock sync.sh lang:matlab %}
  patient1.name = 'John Doe';
  patient1.billing = 127;
  patient1.test = magic(3);
  {% endcodeblock %}
  当然多维数组也是类似：`patient2(1, 1).name = 'John Doe; ...`
- 使用 `struct` 函数创建：
  {% codeblock sync.sh lang:matlab %}
  patient1 = struct('name', 'John Doe', 'billing', 127, 'test', magic(3));
  {% endcodeblock %}

对于 Matlab R2013b 开始引入的表数组类型，一般有两种创建方式：

```matlab
Gender = {'M'; 'F'; 'M'; 'M'; 'F'};
Age = [23; 24; 24; 22; 23];
Grades = [78 86 80; 67 90 81; 66 70 76; 82 95 85; 64 78 75];
Leader = logical([0; 1; 0; 0; 1]);
ID = strcat('2017SC', ['003'; '006'; '024'; '005'; '056']);
T1 = table(ID, Gender, Age, Grades, Leader, 'RowNames', ...
           {'Smith', 'Jones', 'Brown', 'Jim', 'Lily'});
T2 = table;
T2.ID = ID;
T2.Gender = Gender;
T2.Age = Age;
T2.Grades = Grades;
T2.Leader = Leader;
T2.Properties.RowNames = {'Smith', 'Jones', 'Brown', 'Jim', 'Lily'};

%   5x5 table
%                 ID        Gender    Age        Grades        Leader
%              _________    ______    ___    ______________    ______
%     Smith    2017SC003    'M'       23     78    86    80    false
%     Jones    2017SC006    'F'       24     67    90    81    true
%     Brown    2017SC024    'M'       24     66    70    76    false
%     Jim      2017SC005    'M'       22     82    95    85    false
%     Lily     2017SC056    'F'       23     64    78    75    true
```

当然了，笔者不偏好后面这种方法，而是尽量从其他格式转换过来。

表数组索引方式比较丰富：

<table>
  <tr>
    <th>索引类型</th>
    <th>语法格式</th>
    <th>结果类型</th>
    <th>备注</th>
  </tr>
  <tr>
    <td>小括号</td>
    <td><code>T(rows, vars)</code></td>
    <td>表格型数据类型</td>
    <td rowspan="2"><code>rows / vars</code> 可以是数值向量、逻辑向量以及行/列名组成的元胞数组</td>
  </tr>
  <tr>
    <td>大括号</td>
    <td><code>T{rows, vars}</code></td>
    <td>提取的数据</td>
  </tr>
  <tr>
    <td>点号索引</td>
    <td><code>T.var</code><br><code>T.(varindex)</code></td>
    <td>提取的数据</td>
    <td>可以提取表格的一列，还可以进一步对其提取的数据进行索引，如 <code>T.var(index)</code> 或 <code>T.var{index}</code></td>
  </tr>
</table>

下面罗列元胞数组、结构体以及表数组的常用操作：

| 函数 | 说明 | 函数 | 说明 |
| :--  | :--  | :--  | :--  |
| `iscell` | 判断数组是否为元胞数组 | `iscellstr` | 判断数组是否为字符串元胞数组 |
| `cellstr` | 创建字符串元胞数组 | `cellfun` | 将函数应用于元胞数组的每一个元素 |
| `celldisp` | 显示元胞的内容 | `cellplot` | 显示元胞的图形描述 |
| `isstruct` | 判断是否为结构数组 | `isfield` | 判断某字段是否为结构数组中的字段 |
| `getfield` | 获取结构数组中指定字段的值 | `setfield` | 设置结构数组中指定字段的值 |
| `rmfield` | 移除结构数据中的指定字段 | `orderfields` | 对结构数组中的字段按指定顺序排序 |
| `fieldnames` | 获得结构数组的字段名或对象的属性值 | `strcfun` | 将函数应用于结构数组的每一个字段 |
| `istable` | 判断输入是否为表格型类型 | `summary` | 打印表格型数据的综述 |
| `readtable` | 从文件中创建表格型数据 | `writetable` | 将表格型数据写入文件中 |
| `height` | 表格型数据的行数 | `width` | 表格型数据的列数 |
| `join` | 使用关键变量合并两个表格型数据 |  `innerjoin` | 以交集的形式合并两个表格型数据 |
| `outerjoin` | 以并集的形式合并两个表格型数据 | `ismissing` | 查找表格型数据中的非正常量，如 `NaN`, `NaT`, `<undefined>`, 空字符向量以及空格向量 |
| `varfun` | 将函数应用于表格型数据的每一个变量中 | `rowfun` | 将函数应用于表格型数据的每一行 |

Matlab 提供丰富的类型转换函数，眼花缭乱，摘录如下：

<table>
  <tr>
    <th>转换形式</th>
    <th>转换函数</th>
    <th>说明<br></th>
  </tr>
  <tr>
    <td rowspan="3">数值 ➠ 字符数组</td>
    <td><code>num2str</code></td>
    <td>数值转换为字符数组</td>
  </tr>
  <tr>
    <td><code>mat2str</code></td>
    <td>矩阵转换为字符数组</td>
  </tr>
  <tr>
    <td><code>int2str</code></td>
    <td>整数转换为字符数组</td>
  </tr>
  <tr>
    <td rowspan="2">字符数组 ➠ 数值</td>
    <td><code>str2num</code></td>
    <td>将字符数组转为数值，使用 <code>eval</code> 函数进行转换</td>
  </tr>
  <tr>
    <td><code>str2double</code></td>
    <td>将字符数组或字符串元胞数组转换为数值</td>
  </tr>
  <tr>
    <td rowspan="2">数值 ➠ 元胞数组</td>
    <td><code>num2cell</code></td>
    <td>将数值转换为元胞数组</td>
  </tr>
  <tr>
    <td><code>mat2cell</code></td>
    <td>将矩阵转换为元胞数组</td>
  </tr>
  <tr>
    <td>元胞数组 ➠ 数值</td>
    <td><code>cell2mat</code></td>
    <td>将元胞数组转换为矩阵</td>
  </tr>
  <tr>
    <td>字符串/数组 ➠ 元胞数组</td>
    <td><code>cellstr</code></td>
    <td>将字符串转换为字符串元胞数组</td>
  </tr>
  <tr>
    <td>元胞数组 ➠ 字符串</td>
    <td><code>char</code></td>
    <td>将元胞数组转换为字符串，替换以前版本的 <code>str2mat</code> 函数</td>
  </tr>
  <tr>
    <td>字符串 ➠ 函数句柄</td>
    <td><code>str2func</code></td>
    <td>由函数名或字符串表达式构造函数句柄</td>
  </tr>
  <tr>
    <td>函数句柄 ➠ 字符串</td>
    <td><code>func2str</code></td>
    <td>由函数句柄构造函数名或字符串表达式，也可用 <code>char</code> 函数</td>
  </tr>
  <tr>
    <td>元胞数组 ➠ 结构数组</td>
    <td><code>cell2struct</code></td>
    <td>将元胞数组转换为结构数组</td>
  </tr>
  <tr>
    <td>结构数组 ➠ 元胞数组</td>
    <td><code>struct2cell</code></td>
    <td>将结构数组转换为元胞数组</td>
  </tr>
  <tr>
    <td>数组 ➠ 表格</td>
    <td><code>array2table</code></td>
    <td>将同类二维数组转换为表格</td>
  </tr>
  <tr>
    <td>表格 ➠ 数组</td>
    <td><code>table2array</code></td>
    <td>将表格转换为同类数组</td>
  </tr>
  <tr>
    <td>元胞数组 ➠ 表格</td>
    <td><code>cell2table</code></td>
    <td>将元胞数组转换为表格</td>
  </tr>
  <tr>
    <td>表格 ➠ 元胞数组</td>
    <td><code>table2cell</code></td>
    <td>将表格转换为元胞数组</td>
  </tr>
  <tr>
    <td>结构数组 ➠ 表格</td>
    <td><code>struct2table</code></td>
    <td>将结构数组转换为表格</td>
  </tr>
  <tr>
    <td>表格 ➠ 结构数组</td>
    <td><code>table2struct</code></td>
    <td>将表格转换为结构数组</td>
  </tr>
</table>

----------------

关于基本的算术运算符，有几处备忘：

- `/` 表示矩阵右除，$C=A/B$ 表示 $C$ 是方程 $XB=A$ 的解 $C=AB^{-1}$
- `\` 表示矩阵左除，$C=A\backslash B$ 表示 $C$ 是方程 $AX=B$ 的解 $C=A^{-1}B$
- 关于转置，`'` 或者函数 `ctranspose` 表 Hermit 转置或共轭转置，`.'` 或 `transpose` 为非共轭转置

<br>

Matlab 数组元素的索引主要有 $3$ 种方式，即全下标方式、单下标方式和逻辑 $1$ 方式。在单下标方式中，存在这样的换算：

- 对于 $m\times n$ 的矩阵 $A$，元素 $A(i, j)$ 对应的单下标为 $s = m(j-1) + i$
- 对于 $m \times n \times t$ 的数组 $B$，元素 $B(i, j, k)$ 对应的单下标为
  $s=mn(k-1) + m(j-1) + i$
- 对于维度为 $n_1 \times n_2 \times \cdots \times n_k$ 的多维数组 $C$，元素 $C(i_1, i_2, \cdots, i_k)$ 对应的单下标为 $s = \sum\limits_{i=1}^{k-1} (i_{k+1} - 1)\prod\limits_{j=1}^i n_j + i_1$

Matlab 自带函数 `sub2ind` 可对上述第三条结论进行验证：

```matlab
A = randi([1 10], 2, 7, 17, 3, 101);
disp(my_sub2ind(size(A), 1, 4, 2, 2, 20));
disp(sub2ind(size(A), 1, 4, 2, 2, 20));
disp(my_sub2ind(size(A), 2, 7, 13, 3, 52));
disp(sub2ind(size(A), 2, 7, 13, 3, 52));

function ind = my_sub2ind(dims, varargin)
    indx = cell2mat(varargin);
    ind = indx(1) + dot(indx(2:end)-1, cumprod(dims(1:end-1)));
end

% 13825
% 37072
```
