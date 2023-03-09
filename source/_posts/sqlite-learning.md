---
title: SQLite 学习
date: 2020-04-11 22:04:36
tags:
    - SQLite
categories: Development
toc: true
---

电脑里 SumatraPDF 打开文件列表中的《SQLite 权威指南》已经躺了很久了，一直愁于无暇去看，工作一年至今读完的书籍更是屈指可数。由于工作需要也因为兴趣所在，数据库成了绕不过的坎。SQLite 数据库将数据以文件形式存于硬盘中（当然也支持内存数据库），区别于其他需要安装、部署的数据库，SQLite 在与其他程序集成方面显得更加的灵活轻便，如 Python、Autohotkey ，Python 甚至内置标准库 `sqlite3`；SQLite 也能被各种数据库软件支持，如 Navicat、Dbeaver、DbVisualizer 等。

本篇文章以《SQLite 权威指南》为主要参考，记录 SQLite 常用用法，也能作为日后的参考使用文档。

<!-- more -->

## 入门

- 程序/运行库下载：[SQLite 官网][sqlite-official]
- 仅包含 dll / def：`sqlite-dll-win32-xxx`
- 包含 `sqldiff.exe`、`sqlite3.exe`、`sqlite3_analyzer.exe`：`sqlite-tools-win32-xxx`

注：后文用到的 CLP 工具即为 `sqlite3.exe`。

### CLP

- 在命令行键入 `sqlite3`，进入的是交互的 CLP 界面，类似于 Oracle 命令行工具 `sqlplus.exe` 或 MySQL 的 `mysql.exe`。在交互 CLP 界面键入 `.help` 查看帮助：
  ```dos
  $ sqlite3
  SQLite version 3.30.1 2019-10-10 20:19:45
  Enter ".help" for usage hints.
  Connected to a transient in-memory database.
  Use ".open FILENAME" to reopen on a persistent database.
  sqlite>
  ```
  另外命令行模式的 CLP 可以有如下参数：
  ```dos
  $ sqlite3 -help
  Usage: sqlite3 [OPTIONS] FILENAME [SQL]
  FILENAME is the name of an SQLite database. A new database is created
  if the file does not previously exist.
  OPTIONS include:
     -append              append the database to the end of the file
     -ascii               set output mode to 'ascii'
     -bail                stop after hitting an error
     -batch               force batch I/O
     -column              set output mode to 'column'
     -cmd COMMAND         run "COMMAND" before reading stdin
     -csv                 set output mode to 'csv'
     -echo                print commands before execution
     -init FILENAME       read/process named file
     -[no]header          turn headers on or off
     -help                show this message
     -html                set output mode to HTML
     -interactive         force interactive I/O
     -line                set output mode to 'line'
     -list                set output mode to 'list'
     -lookaside SIZE N    use N entries of SZ bytes for lookaside memory
     -memtrace            trace all memory allocations and deallocations
     -mmap N              default mmap size set to N
     -newline SEP         set output row separator. Default: '\n'
     -nullvalue TEXT      set text string for NULL values. Default ''
     -pagecache SIZE N    use N slots of SZ bytes each for page cache memory
     -quote               set output mode to 'quote'
     -readonly            open the database read-only
     -separator SEP       set output column separator. Default: '|'
     -stats               print memory stats before each finalize
     -version             show SQLite version
     -vfs NAME            use NAME as the default VFS
  ```
- `.prompt [value]` 设置当前命令行提示符
- `.show` 查看当前配置，如字段分隔符、记录分隔符、是否显示列名、数据库文件目录等
- `.mode` 查看 / 设置显示格式，一般有：`ascii`、`csv`、`column`、`html`、`insert`、`line`、`list`、`quote`、`tabs`、`tcl` 几种格式
- `.headers on|off` 显示 / 关闭字段名
- `.tables` 显示当前数据库所有表名
- `.indices [table_name]` 显示指定表索引
- `.schema [table_name]` 显示所有 / 指定表或视图的 DDL 语句
- `.output [file_name]` 指定输出文件，默认为标准输出 `stdout`
- `.dump [table_name]` 将整个数据库（或某些表，`table_name` 支持 `LIKE` 风格）导出成 SQL 语句

## 数据导入导出

### 导出数据

**导出为 SQL 语句**

```dos
sqlite> .output file.sql
sqlite> .dump
sqlite> .output stdout
```

**导出为分隔符分隔文件**

```dos
sqlite> .mode csv
sqlite> .output data.csv
sqlite> select * from <table>
sqlite> .output stdout
```

注：如需从该导出文件重新进行导入，应使用如上所示逗号分隔的格式。

### 导入数据

**通过执行包含 SQL 语句的文件导入**

```dos
sqlite> .read <data.sql>
```

**通过导入分隔符分隔文件**

如果 `<datafile>` 为逗号分隔格式文件，则可通过 `.import` 语句导入：

```dos
sqlite> .import <datafile> <table>
```


## 非交互命令处理

- `sqlite3 test.db .dump`
- `sqlite3 test.db .dump > data.sql`
- `sqlite3 test.db "select * from test"`
- `sqlite3 test.db < opt.sql`
- `sqlite3 -init opt.sql test.db .exit`：首先新建 / 打开 `test.db`，再执行 `opt.sql` 中的命令，最后执行 `.exit`


## 函数

- `last_insert_rowid()`：最后插入的自动增量值


[sqlite-official]: https://www.sqlite.org
