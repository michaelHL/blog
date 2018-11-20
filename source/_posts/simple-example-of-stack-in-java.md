---
title: Java 关于栈的简单应用
date: 2018-07-08 22:59:46
categories: Algorithms
tags:
    - Java
    - Stack
---


此篇为「[算法][algorithms]」一书 §1.3 中关于栈的应用部分的学习记录。
<!-- more -->

这本算法书在很多例子中使用作者开发的库 [algs4.jar][algs4.jar]。目前以 [Idea][idea] 作为 Java 开发环境，那么为什么不用 Eclipse？IDE 颜值 + [Vim 插件][ideavim] 是王道。这里提下将 `algs4.jar` 加入 `classpath` 的操作：`C-S-A-s` 或选中工程目录按 `F4`，在弹出的项目结构 (Project Structure) 中依次定位：`Modules` -`xxx`（需要操作的项目）- `Dependencies` - `{% fa plus fw %}` - `JARs or directories...`，定位至 `algs4.jar` 即可。这样就可以直接在 Java 代码中引入 jar 包了，调试运行时的命令显示如下：

```plain
D:\Java\jdk-10\bin\java -javaagent:D:\Idea\lib\idea_rt.jar=xxxxx:D:\Idea\bin \
-Dfile.encoding=UTF-8 \
-classpath E:\WorkingDirectory\Projects\Java\Algorithms\out\production\Algorithms;\
E:\WorkingDirectory\Projects\Java\Algorithms\lib\algs4.jar ch_01.Test
```

### Dijkstra 双栈算术表达式求值算法

这里的代码适用范围较窄，仅支持如下格式的算术表达式：

```plain
( 1 + ( 2 + 3 ) * ( 4 * 5 ) ) )
( ( 1 + sqrt ( 5.0 ) ) / 2.0 )
```

即运算符、左右括号、操作数之间必须存在空格，且每个 `+-*/` 需要一对括号，即类似 `( 2 + 5 ) / ( 4 * 7 )` 这种情况是会出错的，且不能有多余的括号。对于符合条件的算式，想法和采取的手段很简单：逐个读取字符，读到数字或运算符，则将其压入相应的操作数栈或运算符栈；读到右括号，则说明与其最近配对的左括号内的算式结果可以算出来，并将结果压入操作数栈，继续读取后面的字符。

由于符合条件的算式中的括号是成对出现的，于是右括号就相当于一个「弹栈」的标志；而 `+-*/` 对应两个操作数，所以弹栈时若从运算符栈弹出一个运算符，则需从操作数栈弹出两个操作数，并将运算的结果压入操作数栈；遇到 `sqrt` 这种「单目」操作符（这里姑且称之为操作符），则两个栈各弹一个，运算结果压入操作数栈。下面为具体实现。（将原书中的 `if-else` 分支语句改为了 `switch-case` 语句以提高可读性）

```java
import edu.princeton.cs.algs4.*;

public class DijkstraExpressionValue {
    public static void main(String[] args) {
        Stack<String> ops = new Stack<>();
        Stack<Double> val = new Stack<>();
        while (!StdIn.isEmpty()) {
            String s = StdIn.readString();
            switch (s) {
                case "(": break;
                case "+": case "-": case "*": case "/": case "sqrt":
                    ops.push(s); break;
                case ")": {
                    String op = ops.pop();
                    double v = val.pop();
                    switch (op) {
                        case "+": v = val.pop() + v; break;
                        case "-": v = val.pop() - v; break;
                        case "*": v = val.pop() * v; break;
                        case "/": v = val.pop() / v; break;
                        case "sqrt": v = Math.sqrt(v); break;
                    }
                    val.push(v);
                    break;
                }
                default:
                    val.push(Double.parseDouble(s));
                    break;
            }
        }
        System.out.printf("%.6f\n", val.pop());
    }
}
```

测试：

```plain
( 1 + ( 2 + 3 ) * ( 4 * 5 ) ) )                    : 101.000000
( ( 1 + sqrt ( 5.0 ) ) / 2.0 )                     : 1.618034
sqrt ( ( 1 * ( 2 * ( 3 * ( 4 * ( 5 * 6 ) ) ) ) ) ) : 26.832816
```

----------------

如果这个例子高级了点，下这个手动实现栈的例子就比较简单而有趣了。

- **TODO**

[algorithms]: https://algs4.cs.princeton.edu
[algs4.jar]: https://algs4.cs.princeton.edu/code/algs4.jar
[idea]: https://www.jetbrains.com/idea
[ideavim]: https://github.com/JetBrains/ideavim
