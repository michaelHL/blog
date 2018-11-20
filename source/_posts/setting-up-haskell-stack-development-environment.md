---
title: Windows 下 Haskell-stack 开发环境搭建
date: 2018-08-11 16:59:52
tags:
    - Haskell
    - Stack
    - Windows
categories: Development and Deployment
---

{% centerquote %}
   <img src="/img/haskell-logo.svg" width="45%"> <br>
   An advanced, purely functional programming language
{% endcenterquote %}

抛却「Haskell 语言能装逼」这一光环，笔者认为学习 Haskell 的另一主要动机在于尝试体验另一种编程思维，即「做什么」而非「怎么做」，Haskell 写出的程序更像是人脑的思维而不是机器的思维。当然了，装 x 也 hin 重要。

目前 [Haskell 官方下载页][haskell-downloads] 推荐三种下载方案：

- [最小安装程序][minimal-installers]
- [stack][stack]
- [Haskell 平台][haskell-platform]

总体而言，Haskell 在 *nix / OS X 操作系统下的生态优于 Windows 环境，但对于熟悉 Windows 操作、醉心于各类工具流的笔者而言，必须要在 Windows 系统下完成环境搭建。为方便后续各类包的安装更新等操作，这里采用 [Cabal][cabal] 的替代品 -- stack。以下诸多关键操作均参考 [Arvind Devarajan 的博客][arvind-devarajan-blog]。

<!-- more -->

### 预热

在 Windows 操作系统环境中，如果没有设定环境变量 `STACK_ROOT`，则通过 stack 下载的程序文件以及包快照会被存放在 `%LOCALAPPDATA%\Programs\stack` 以及 `%APPDATA%\stack` 目录下。经常变动的包安放在系统盘总会令人不安，也不便于管理。所以在首次使用 stack 之前，应设定环境变量 `STACK_ROOT`，这里笔者将其设为 `F:\HaskellStack`。另外推荐设定编译器 GHC 的下载安装目录，见后文 `config.yaml` 文件的配置。（[stack 帮助文档关于此问题的说明][stack-change-temp-dir]）

### 配置

这里有几点关于我个人在开发过程中的习惯配置。

- 提前安装好 [MSYS2][msys2] 作为 C/C++ 等工具的开发环境，并添加至环境变量 `PATH`。详细配置过程见 [MSYS2 的日常操作][daily-operations-of-msys2]
- 将一个包含常用可执行文件的目录加入环境变量 `PATH`，如 `F:\WorkingDirectory\Bin`

stack 默认使用的软件源在国外，这里换上国内的清华大学开源网站镜像。由于之前已设定了 `STACK_ROOT` 环境变量，首次运行 stack 会在此目录下生成一些文件，修改 `config.yaml` 文件：

```yaml %STACK_ROOT%\config.yaml
setup-info: "http://mirrors.tuna.tsinghua.edu.cn/stackage/stack-setup.yaml"

urls:
  latest-snapshot: http://mirrors.tuna.tsinghua.edu.cn/stackage/snapshots.json
  lts-build-plans: http://mirrors.tuna.tsinghua.edu.cn/stackage/lts-haskell/
  nightly-build-plans: http://mirrors.tuna.tsinghua.edu.cn/stackage/stackage-nightly/

package-indices:
  - name: Tsinghua
    download-prefix: http://mirrors.tuna.tsinghua.edu.cn/hackage/package/
    http: http://mirrors.tuna.tsinghua.edu.cn/hackage/00-index.tar.gz

skip-msys: true
local-programs-path: F:\HaskellStack\programs
local-bin-path: F:\WorkingDirectory\Bin
```

以上参考 [stackage 镜像使用帮助][stackage-help] 以及 [hackage 镜像使用帮助][hackage-help]。另作几点说明：

- Windows 下的 stack 会自动安装 MSYS2，由于之前已在机器中安装过，故在配置中跳过 MSYS 的安装
- 通过 `stack install` 生成的可执行文件默认在 `%APPDATA%` 目录下，这里统一放置于之前提到的可执行文件合集目录中

执行 `stack setup` 下载最新版的 GHC，目前版本为 8.4.3。

如一切顺利，`stack path` 输出如下：

```plain
stack-root: F:\HaskellStack
project-root: F:\HaskellStack\global-project
config-location: F:\HaskellStack\global-project\stack.yaml
bin-path: .;F:\HaskellStack\snapshots\55eb7f36\bin;F:\HaskellStack\compiler-tools\x86_64-windows\ghc-8.4.3\bin;F:\HaskellStack\programs\x86_64-windows\ghc-8.4.3\bin;F:\HaskellStack\programs\x86_64-windows\ghc-8.4.3\mingw\bin;C:\Windows\system32;...
programs: F:\HaskellStack\programs\x86_64-windows
compiler-exe: F:\HaskellStack\programs\x86_64-windows\ghc-8.4.3\bin\ghc.EXE
compiler-bin: F:\HaskellStack\programs\x86_64-windows\ghc-8.4.3\bin
compiler-tools-bin: F:\HaskellStack\compiler-tools\x86_64-windows\ghc-8.4.3\bin
local-bin: F:\WorkingDirectory\Bin
extra-include-dirs:
extra-library-dirs:
snapshot-pkg-db: F:\HaskellStack\snapshots\55eb7f36\pkgdb
local-pkg-db: F:\HaskellStack\global-project\.stack-work\install\620260b6\pkgdb
global-pkg-db: F:\HaskellStack\programs\x86_64-windows\ghc-8.4.3\lib\package.conf.d
ghc-package-path: F:\HaskellStack\global-project\.stack-work\install\620260b6\pkgdb;F:\HaskellStack\snapshots\55eb7f36\pkgdb;F:\HaskellStack\programs\x86_64-windows\ghc-8.4.3\lib\package.conf.d
snapshot-install-root: F:\HaskellStack\snapshots\55eb7f36
local-install-root: F:\HaskellStack\global-project\.stack-work\install\620260b6
snapshot-doc-root: F:\HaskellStack\snapshots\55eb7f36\doc
local-doc-root: F:\HaskellStack\global-project\.stack-work\install\620260b6\doc
dist-dir: .stack-work\dist\7d103d30
local-hpc-root: F:\HaskellStack\global-project\.stack-work\install\620260b6\hpc
local-bin-path: F:\WorkingDirectory\Bin
ghc-paths: F:\HaskellStack\programs\x86_64-windows
```

最后，如要修改 GHCi 的命令行提示符或在启动时加载某些包，可通过添加 / 修改 `%APPDATA%\ghc\ghci.conf` 文件为以下内容：

```conf ghci.conf
import Text.Show.Pretty (ppShow, pPrint)

:set -interactive-print pPrint
:set prompt "|> "
```


### 编辑器

考虑编辑效率和插件生态，推荐使用 VSCode 作为主力编辑器。安装插件：

- [Haskell Syntax Highlight][vsc-haskell-syntax-highlight]
- [Haskelly][vsc-haskelly]
- [hindent-format][vsc-hindent-format]
- [brittany][vsc-brittany]

后两者为代码格式化插件，任选一即可。

`hindent-format` 貌似不能正确读取配置文件，故手动修改之（当前版本 0.0.8）

{% fold "hindent-format 插件修改后代码" %}
```javascript extension.js
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const child_process = require("child_process");
const path = require("path");
class HindentFormatEditsProvider {
    constructor() {
        this.hindentAvailable = false;
        this.enable = true;
        this.command = "hindent";
        this.arguments = [];
        this.configure();
    }
    configure() {
        const config = vscode.workspace.getConfiguration('hindent-format');
        this.enable = config.get('enable', true);
        this.command = config.get('command', 'hindent');
        this.arguments = [
            "--indent-size", "4",
            "--line-length", 100
        ];
        if (this.enable) {
            let result = child_process.spawnSync(this.command, ['--version']);
            if (!result.status) {
                this.hindentAvailable = true;
                console.log("hindent-format: using executable: " + this.command);
            }
            else {
                this.hindentAvailable = false;
                vscode.window.showWarningMessage("hindent-format: cannot execute hindent command: " + this.command);
            }
        }
    }
    formatHindent(text) {
        let cwd = '.';
        // May this helps hindent pick up the .hindent.yaml file
        if (vscode.window.activeTextEditor) {
            let documentPath = vscode.window.activeTextEditor.document.uri.fsPath;
            cwd = path.dirname(documentPath);
        }
        let result = child_process.spawnSync(this.command, this.arguments, {
            'cwd': cwd,
            'input': text
        });
        if (!result.status) {
            return result.stdout.toString();
        }
        else {
            vscode.window.showWarningMessage(result.stderr.toString().split('\n')[0]);
            return '';
        }
    }
    provideDocumentFormattingEdits(document, options, token) {
        let formatted = this.formatHindent(document.getText());
        if (formatted !== '') {
            let range = document.validateRange(new vscode.Range(0, 0, Number.MAX_VALUE, Number.MAX_VALUE));
            return [vscode.TextEdit.replace(range, formatted)];
        }
        else {
            return [];
        }
    }
    provideDocumentRangeFormattingEdits(document, range, options, token) {
        let formatted = this.formatHindent(document.getText(range));
        if (formatted !== '') {
            return [vscode.TextEdit.replace(range, formatted)];
        }
        else {
            return [];
        }
    }
}
function activate(context) {
    console.log("hindent-format: active!");
    let hindentFormatProvider = new HindentFormatEditsProvider();
    if (hindentFormatProvider.hindentAvailable) {
        vscode.languages.registerDocumentFormattingEditProvider('haskell', hindentFormatProvider);
        console.log("hindent-format: registered document formatting provider");
        vscode.languages.registerDocumentRangeFormattingEditProvider('haskell', hindentFormatProvider);
        console.log("hindent-format: registered selection formatting provider");
        vscode.commands.registerTextEditorCommand('hindent-format.format', (textEditor, edit, args) => {
            let range = textEditor.selection.with();
            if (range.isEmpty) {
                range = textEditor.document.validateRange(new vscode.Range(0, 0, Number.MAX_VALUE, Number.MAX_VALUE));
            }
            let formatted = hindentFormatProvider.formatHindent(textEditor.document.getText(range));
            if (formatted !== '') {
                edit.replace(range, formatted);
            }
        });
        console.log("hindent-format: registered palette command");
    }
}
exports.activate = activate;
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map
```
{% endfold %}

个人更青睐 `brittany` 格式化的效果。 但目前 VSCode 插件 `brittany` 对未保存文档不能正确执行格式化，同样需要修改插件源代码（当前版本 0.0.1）

{% fold "brittany 插件修改后代码" %}
```javascript extension.js
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const proc = require("child_process");
const path = require("path");
const tmp = require("tmp");
const fs = require("fs");
function activate(context) {
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    if (isEnabled() === false) {
        console.log("brittany extension disabled; not registering it.");
        return;
    }
    else {
        console.log("Registering brittany extension");
    }
    context.subscriptions.push(vscode.languages.registerDocumentRangeFormattingEditProvider('haskell', {
        provideDocumentRangeFormattingEdits(document, range) {
            if (isEnabled() === false) {
                return new Promise((resolve, reject) => {
                    return reject([]);
                });
            }
            console.log('brittany asked to format');
            // If we're formatting the whole document
            // Brittany operates on files only, so we need to 
            // Improvement TODO: Instead of making a tmp file, pass the source code into STDIN.
            // Could also potentially unify this approach with the full-file approach.
            let substring = document.getText(range);
            let tmpobj = tmp.fileSync();
            console.log('brittany: Temporary file: ', tmpobj.name);
            return new Promise((resolve, reject) => {
                fs.write(tmpobj.fd, substring, (err, written, str) => {
                    if (err) {
                        return reject(err);
                    }
                    else {
                        return resolve(runBrittany(document, range, tmpobj.name, tmpobj));
                    }
                });
            });
        }
    }));
}
exports.activate = activate;
function runBrittany(document, range, inputFilename, tmpobj) {
    return new Promise((resolve, reject) => {
        const file = document.uri.fsPath;
        var cmd = brittanyCmd() + " \"" + inputFilename + "\""
        +" " + additionalFlags();
        var maybeWorkspaceFolder = vscode.workspace.getWorkspaceFolder(document.uri);
        var dir = maybeWorkspaceFolder !== undefined ? maybeWorkspaceFolder.uri.fsPath : path.dirname(document.uri.fsPath);
        console.log("brittany command is: " + cmd);
        console.log("brittany folder is: " + dir);
        var options = {
            encoding: 'utf8',
            // timeout: 0,
            // maxBuffer: 200 * 1024, // ?
            // killSignal: 'SIGTERM',
            cwd: dir,
        };
        proc.exec(cmd, options, (error, stdout, stderr) => {
            if (error) {
                if (tmpobj) {
                    tmpobj.removeCallback();
                }
                console.error("Error running brittany:");
                console.error(error);
                console.error(stdout);
                console.error(stderr);
                vscode.window.showErrorMessage("Failed to run brittany; see the developer tools console for details. " + error);
                return reject([]);
            }
            else {
                if (tmpobj) {
                    tmpobj.removeCallback();
                }
                return resolve([vscode.TextEdit.replace(range, stdout)]);
            }
        });
    });
}
// this method is called when your extension is deactivated
function deactivate() {
}
exports.deactivate = deactivate;
function brittanyCmd() {
    return vscode.workspace.getConfiguration("brittany")["path"];
}
function additionalFlags() {
    return vscode.workspace.getConfiguration("brittany")["additional-flags"];
}
function isEnabled() {
    return vscode.workspace.getConfiguration("brittany")["enable"];
}
function fullDocumentRange(document) {
    const lastLineId = document.lineCount - 1;
    return new vscode.Range(0, 0, lastLineId, document.lineAt(lastLineId).text.length);
}
//# sourceMappingURL=extension.js.map
```
{% endfold %}

另外，建议利用 `config.yaml` 文件搭配 `brittany` 进行深度配置。在控制台执行一次 `brittany` 命令，生成的配置文件位置为 `%APPDATA%\brittany\config.yaml`，示例配置如下。

{% fold "brittany 配置文件" %}
```yaml %APPDATA%\brittany\config.yaml
conf_debug:
  dconf_roundtrip_exactprint_only: false
  dconf_dump_bridoc_simpl_par: false
  dconf_dump_ast_unknown: false
  dconf_dump_bridoc_simpl_floating: false
  dconf_dump_config: false
  dconf_dump_bridoc_raw: false
  dconf_dump_bridoc_final: false
  dconf_dump_bridoc_simpl_alt: false
  dconf_dump_bridoc_simpl_indent: false
  dconf_dump_annotations: false
  dconf_dump_bridoc_simpl_columns: false
  dconf_dump_ast_full: false
conf_forward:
  options_ghc:
    - -XLambdaCase
    - -XMultiWayIf
    - -XGADTs
    - -XPatternGuards
    - -XViewPatterns
    - -XRecursiveDo
    - -XTupleSections
    - -XExplicitForAll
    - -XImplicitParams
    - -XQuasiQuotes
    - -XTemplateHaskell
    - -XBangPatterns
conf_errorHandling:
  econf_ExactPrintFallback: ExactPrintFallbackModeInline
  econf_Werror: false
  econf_omit_output_valid_check: false
  econf_produceOutputOnErrors: false
conf_preprocessor:
  ppconf_CPPMode: CPPModeAbort
  ppconf_hackAroundIncludes: false
conf_obfuscate: false
conf_roundtrip_exactprint_only: false
conf_version: 1
conf_layout:
  lconfig_reformatModulePreamble: true
  lconfig_altChooser:
    tag: AltChooserBoundedSearch
    contents: 3
  lconfig_allowSingleLineExportList: false
  lconfig_importColumn: 50
  lconfig_hangingTypeSignature: false
  lconfig_importAsColumn: 50
  lconfig_alignmentLimit: 30
  lconfig_indentListSpecial: true
  lconfig_indentAmount: 4
  lconfig_alignmentBreakOnMultiline: true
  lconfig_cols: 80
  lconfig_indentPolicy: IndentPolicyFree
  lconfig_indentWhereSpecial: true
  lconfig_columnAlignMode:
    tag: ColumnAlignModeMajority
    contents: 0.7
```
{% endfold %}


### 参考

- [Installing Haskell stack (in Windows)](https://blog.ramdoot.in/installing-haskell-stack-in-windows-7c8fd2c79f)
- [重拾Haskell](https://www.zybuluo.com/delight/note/503796)


[haskell-downloads]: https://www.haskell.org/downloads
[minimal-installers]: https://www.haskell.org/downloads#minimal
[stack]: http://docs.haskellstack.org
[haskell-platform]: https://www.haskell.org/downloads#platform
[cabal]: https://www.haskell.org/cabal
[arvind-devarajan-blog]: https://blog.ramdoot.in
[msys2]: https://www.msys2.org
[daily-operations-of-msys2]: /daily-operations-of-msys2
[stackage-help]: https://mirrors.tuna.tsinghua.edu.cn/help/stackage
[hackage-help]: https://mirrors.tuna.tsinghua.edu.cn/help/hackage
[stack-change-temp-dir]: https://docs.haskellstack.org/en/stable/faq/#can-i-change-stacks-default-temporary-directory
[vsc-haskell-syntax-highlight]: https://marketplace.visualstudio.com/items?itemName=justusadam.language-haskell
[vsc-haskelly]: https://marketplace.visualstudio.com/items?itemName=UCL.haskelly
[vsc-hindent-format]: https://marketplace.visualstudio.com/items?itemName=monofon.hindent-format
[vsc-brittany]: https://marketplace.visualstudio.com/items?itemName=MaxGabriel.brittany
