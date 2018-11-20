---
title: Windows 下安装 Anaconda3 产生的快捷方式
date: 2017-08-34 12:59:11
tags:
    - Anaconda
    - Windows
categories: Memos
---

部分情况下，一些 Windows 机器安装完 Anaconda 之后不会出现快捷方式，而其快捷方式较为复杂，故记录之。

 {% fa warning fw %} 用户名为 `Michael`，Anaconda3 安装目录为 `D:\Anaconda3`，若安装于其它目录，作相应修改即可。

<!-- more -->

## root / base 环境

| Shortcuts             | Commands                                                                                                                                             | Start in                                    |
| :----                 | :----                                                                                                                                                | :----                                         |
| Anaconda Cloud        | `D:\Anaconda3\pythonw.exe -m webbrowser -t "https://anaconda.org/"`                                                                                  | `C:\Users\Michael`                            |
| Anaconda Navigator    | `D:\Anaconda3\pythonw.exe D:\Anaconda3\cwp.py D:\Anaconda3 "D:/Anaconda3/pythonw.exe" "D:/Anaconda3/Scripts/anaconda-navigator-script.py"`           | `C:\Users\Michael\Documents`                  |
| Anaconda Prompt       | `%windir%\system32\cmd.exe "/K" D:\Anaconda3\Scripts\activate.bat D:\Anaconda3`                                                                      | `C:\Users\Michael`                            |
| IPython               | `D:\Anaconda3\python.exe D:\Anaconda3\cwp.py D:\Anaconda3 "D:/Anaconda3/python.exe" "D:/Anaconda3/Scripts/ipython-script.py"`                        | `C:\Users\Michael`                            |
| Jupyter Notebook      | `D:\Anaconda3\python.exe D:\Anaconda3\cwp.py D:\Anaconda3 "D:/Anaconda3/python.exe" "D:/Anaconda3/Scripts/jupyter-notebook-script.py" %USERPROFILE%` | `C:\Users\Michael`                            |
| Jupyter QTConsole     | `D:\Anaconda3\pythonw.exe D:\Anaconda3\cwp.py D:\Anaconda3 "D:/Anaconda3/pythonw.exe" "D:/Anaconda3/Scripts/jupyter-qtconsole-script.py"`            | `C:\Users\Michael`                            |
| Reset Spyder Settings | `D:\Anaconda3\python.exe D:\Anaconda3\cwp.py D:\Anaconda3 "D:/Anaconda3/python.exe" "D:/Anaconda3/Scripts/spyder-script.py" --reset`                 | `C:\Users\Michael`                            |
| Spyder                | `D:\Anaconda3\pythonw.exe D:\Anaconda3\cwp.py D:\Anaconda3 "D:/Anaconda3/pythonw.exe" "D:/Anaconda3/Scripts/spyder-script.py"`                       | `"C:\Users\Michael\Documents\Python Scripts"` |

## 其他环境（环境名：workspace）

| Shortcuts             | Commands                                                                                                                                                                                                         | Start in                                    |
| :----                 | :----                                                                                                                                                                                                            | :----                                         |
| Anaconda Cloud        | `D:\Anaconda3\pythonw.exe -m webbrowser -t "https://anaconda.org/"`                                                                                                                                              | `C:\Users\Michael`                            |
| Anaconda Navigator    | `D:\Anaconda3\envs\workspace\pythonw.exe D:\Anaconda3\cwp.py D:\Anaconda3\envs\workspace "D:/Anaconda3/envs/workspace/pythonw.exe" "D:/Anaconda3/envs/workspace/Scripts/anaconda-navigator-script.py"`           | `C:\Users\Michael\Documents`                  |
| Anaconda Prompt       | `%windir%\system32\cmd.exe "/K" D:\Anaconda3\Scripts\activate.bat D:\Anaconda3\envs\workspace`                                                                                                                   | `C:\Users\Michael`                            |
| IPython               | `D:\Anaconda3\envs\workspace\python.exe D:\Anaconda3\cwp.py D:\Anaconda3\envs\workspace "D:/Anaconda3/envs/workspace/python.exe" "D:/Anaconda3/envs/workspace/Scripts/ipython-script.py"`                        | `C:\Users\Michael`                            |
| Jupyter Notebook      | `D:\Anaconda3\envs\workspace\python.exe D:\Anaconda3\cwp.py D:\Anaconda3\envs\workspace "D:/Anaconda3/envs/workspace/python.exe" "D:/Anaconda3/envs/workspace/Scripts/jupyter-notebook-script.py" %USERPROFILE%` | `C:\Users\Michael`                            |
| Jupyter QTConsole     | `D:\Anaconda3\envs\workspace\pythonw.exe D:\Anaconda3\cwp.py D:\Anaconda3\envs\workspace "D:/Anaconda3/envs/workspace/pythonw.exe" "D:/Anaconda3/envs/workspace/Scripts/jupyter-qtconsole-script.py"`            | `C:\Users\Michael`                            |
| Reset Spyder Settings | `D:\Anaconda3\envs\workspace\python.exe D:\Anaconda3\cwp.py D:\Anaconda3\envs\workspace "D:/Anaconda3/envs/workspace/python.exe" "D:/Anaconda3/envs/workspace/Scripts/spyder-script.py" --reset`                 | `C:\Users\Michael`                            |
| Spyder                | `D:\Anaconda3\envs\workspace\pythonw.exe D:\Anaconda3\cwp.py D:\Anaconda3\envs\workspace "D:/Anaconda3/envs/workspace/pythonw.exe" "D:/Anaconda3/envs/workspace/Scripts/spyder-script.py"`                       | `"C:\Users\Michael\Documents\Python Scripts"` |


