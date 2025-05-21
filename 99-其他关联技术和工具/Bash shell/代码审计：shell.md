##  ShellCheck 介绍 


ShellCheck是一个广受欢迎的开源静态 Shell 脚本分析的工具，旨在帮助开发者发现并修正他们的shell脚本中的错误。它可以对bash、sh、ksh和dash脚本进行静态分析

##  🏠  项目信息

Github地址：https://github.com/koalaman/shellcheck
官网：https://www.shellcheck.net


可以在DEMO中，直接上传脚本进行分析

![图片](https://mmbiz.qpic.cn/mmbiz_png/kgXibFxsv0e2Be8hgqgSIETXt5UI3Q5lY1b94DSwic7aGFeaHnA62EqHWWRSciciaHeCS4ibUya7JN1BqB5QL027h5Q/640?wx_fmt=png&from=appmsg&tp=wxpic&wxfrom=5&wx_lazy=1&wx_co=1)


## 🛠 功能特性

- 广泛的检查范围：ShellCheck能识别各种常见错误和陷阱，从而帮助开发者避免一些难以察觉的问题。
- 详细的反馈：对于检测到的每个问题，ShellCheck都会提供一个详细的解释，解释为什么这会是一个问题，以及如何修正它。
- 易于使用：ShellCheck可以通过命令行直接使用，也可以集成到文本编辑器和IDE中，如VS Code、Sublime Text和Vim等，还可以作为CI/CD流程中的一部分自动运行。
- 强大的社区支持：作为一个开源项目，ShellCheck拥有活跃的社区，不断有新的功能和改进被加入。
- 多平台支持：支持在 Linux、macOS、Windows 等多种操作系统上运行。

##  ShellCheck 安装 

一、操作系统中安装  

- Cabal 的系统上：
```
cabal update
```
- Stack 的系统上：
```
stack update
```
- 基于 Debian 的发行版上：
```
sudo apt install shellcheck
```
- 基于 Arch Linux 的发行版上：
```
pacman -S shellcheck
```
- 基于 Gentoo 的发行版上：
```
emerge --ask shellcheck
```
- 基于 EPEL 的发行版上：
```
sudo yum -y install epel-release
```
- 基于 Fedora 的发行版上：
```
dnf install ShellCheck
```
- 在 FreeBSD 上：
```
pkg install hs-ShellCheck
```
- 装有 Homebrew 的 macOS (OS X) 上：
```
brew install shellcheck
```
- macOS (OS X) 使用 MacPor：
```
sudo port install shellcheck
```
- OpenBSD 上：
```
pkg_add shellcheck
```
- openSUSE 上：
```
zypper in ShellCheck
```

二、编辑器中安装

- vim：通过ALE安装ShellCheck：
```
mkdir -p ~/.vim/pack/git-plugins/start
```
通过上述两条命令安装ALE后，再用 vim 编辑脚本会发现左侧有高亮，下侧有修改提示：  

![图片](https://mmbiz.qpic.cn/mmbiz_png/kgXibFxsv0e2Be8hgqgSIETXt5UI3Q5lY4Niap1LBuP8NpIIrwGeyUSThibxLdbSibpxRypzN8SY6wPhTIZNLg8MrQ/640?wx_fmt=png&from=appmsg&tp=wxpic&wxfrom=5&wx_lazy=1&wx_co=1)

  
- VSCode：通过 vscode-shellcheck 安装。

![图片](https://mmbiz.qpic.cn/mmbiz_png/kgXibFxsv0e2Be8hgqgSIETXt5UI3Q5lYR7cjCq07gUpgt8pdwiaKN47IkB4rkKcPPfbgKAwMofkDI2iavVyPCThw/640?wx_fmt=png&from=appmsg&tp=wxpic&wxfrom=5&wx_lazy=1&wx_co=1)

  

##  ShellCheck 使用 

### 一、运行检测


ShellCheck的使用通常很直接。你可以通过命令行运行它来检查脚本文件。例如：
```
shellcheck yourscript.sh
```
这会输出脚本中发现的所有建议和警告。

ShellCheck 的使用非常简单，直接在终端中执行一些命令即可：

```
shellcheck yourscript
```

运行后，即时输出结果：

![图片](https://mmbiz.qpic.cn/mmbiz_png/kgXibFxsv0e2Be8hgqgSIETXt5UI3Q5lY22iaora62Feh51eo01G23TdAEDUXceiczeWUI2FkdIw3Pg1vR5U1fllg/640?wx_fmt=png&from=appmsg&tp=wxpic&wxfrom=5&wx_lazy=1&wx_co=1)

  

### 二、错误分析

#### 常见因为引用导致错误如下：
```
echo $1                           # Unquoted variables
```
#### 常见错误条件语句
```
[[ n != 0 ]]                      # Constant test expressions
```
#### 错误的命令使用
```
grep '*foo*' file                 # Globs in regex contexts
```
#### 初学者常见的错误
```
var = 42                          # Spaces around = in assignments
```
#### 最佳实践建议
```
[[ -z $(find /tmp | grep mpg) ]]  # Use grep -q instead
```
#### 数据输入输出错误
```
args="$@"                         # Assigning arrays to strings
```
#### 脚本健壮性建议  
```
rm -rf "$STEAMROOT/"*            # Catastrophic rm
```
#### 脚本可迁移性建议  
```
echo {1..$n}                     # Works in ksh, but not bash/dash/sh
```
#### 其他问题检测  
```
PS1='\e[0;32m\$\e[0m '            # PS1 colors not in \[..\]
```

#### 未引用的变量
```
# 错误示例   echo $userinput   
# ShellCheck建议   
# SC2086: Double quote to prevent globbing and word splitting.   
# 修改后   echo "$userinput"
```
#### 遗漏的shebang
```
# 错误示例   echo "Hello World" 
# ShellCheck建议
# SC2148: Tips depend on target shell and yours is unknown. Add a shebang.
# 修改后
#!/bin/bash   echo "Hello World"
```
#### 使用未定义的变量
```
# 错误示例   if [ $name == "John" ]; then     echo "Hello, John!"   fi
# ShellCheck建议
# SC2154: name is referenced but not assigned.
# 修改后   
name="John"   
if [ "$name" == "John" ]; then     
	echo "Hello, John!"   
fi
```

#### 使用弃用的反引号执行命令
```
# 错误示例   result=`ls`
# ShellCheck建议
# SC2006: Use $(...) notation instead of legacy backticked `...`.
# 修改后   result=$(ls)
```

#### 避免命令失败时脚本继续执行
```
# 错误示例   cd some_directory   rm *   
# ShellCheck建议   
# SC2164: Use 'cd ... || exit' or 'cd ... || return' in case cd fails.
# 修改后   cd some_directory || exit   rm *
```

#### 不正确的if语句语法
```
# 错误示例   if [$var -eq 1]   then     echo "True"   fi   
# ShellCheck建议   
# SC1045: It's not 'if' condition, you need a space after the '['.   
# SC1073: Couldn't parse this test expression.   
# 修改后
if [ $var -eq 1 ]; then
	echo "True"
fi
```
#### 不建议使用的序列表达式
```
# 错误示例   echo {1..10}  
# ShellCheck建议
# SC2035: Use ./*glob* or -- *glob* so names with dashes won't become options.
# 修改后   echo {1..10}
```

#### 在循环中不正确地读取行
```
# 错误示例   cat file.txt | while read line; do     echo $line   done
# ShellCheck建议
# SC2094: Make sure not to read and write the same file in the same pipeline.   
# 修改后   while IFS= read -r line; do     echo "$line"   done < file.txt
```
#### 错误地使用echo输出变量
```
# 错误示例   echo "Path: $PATH"
# ShellCheck建议
# SC2027: The surrounding quotes actually unquote this. Remove or escape them.
# 修改后   echo "Path: "$PATH""
```
#### 为变量赋值和检查命令的退出状态
```
# 错误示例
output=$(some_command)    
if [ $? -ne 0 ]; then
echo "Command failed"
fi    
# ShellCheck建议
# SC2181: Check exit code directly with e.g. 'if mycmd;', not indirectly with $.    
# 修改后
if ! output=$(some_command); then
echo "Command failed"
fi
```
