# Immunity Debugger

https://www.cnblogs.com/blacksunny/p/7238863.html
## 1、Immunity Debugger简介

　　Immunity Debugger软件专门用于加速漏洞利用程序的开发，辅助漏洞挖掘以及恶意软件分析。它具备一个完整的图形用户界面，同时还配备了迄今为止最为强的Python安全工具库。它巧妙的将动态调试功能与一个强大的静态分析引擎融合于一体，它还附带了一套高度可定制的纯pythont图形算法，可用于帮助我们绘制出直观的函数体控制流以及函数中的各个基本块。

## 2、软件介绍

### 2.1、主界面：

![](https://minioapi.nerubian.cn/image/20250227190600936.png)

调试器界面被分成5个主要的块。

左上角的CPU窗口------显示了正在处理的代码的反汇编指令。

右上角是寄存器窗口------显示所有通用寄存器。

左下角是内存窗口---------以十六进制的形式显示任何被选中的内存块。

右下角是堆栈窗口---------显示调用的堆栈和解码后的函数参数（任何原生的API调用）。

最底下白色的窗口是命令栏-----能够像windbg一样使用命令控制调试器，或者执行PyCommands。

## 2.2、PyCommands命令

　　pycomands是我们在Immunity Debugger中执行Python代码扩展的主要途径。存放在Immunity安装目录的pyCommand文件夹里。

　　是为了帮助用户在调试器内执行各种任务（如设立钩子函数、静态分析等）而特意编写的python脚本。

　　任何一个PyCommand命令都必须遵循一定结构规范：1、必须定义一个main函数，并接受一个Python列表作为参数；2、必须返回一个字符串：将被显示在调试器界面的状态栏。

　　按要求编写一个py脚本：


```
1 #!/usr/bin/python
2 #coding:utf-8
3 from immlib import *
4 def main(args):
5     #实例化一个immlib.Debugger对象
6     return "[*] PyCommand Executed!"
```

　　![](https://minioapi.nerubian.cn/image/20250227190556272.png)

PyCommand有两个必要条件：

　　一个main函数，只接受一个参数（由所有参数组成的python列表）。

　　另一个是在函数执行完成的时候必须返回一个字符串，最后更新在调试器主界面的状态栏。

　　执行命令之前在命令前加一个感叹号。`---------- ！<demo>`

## 2.3、PyHooks

　　Immunity调试器包含了13种不同类型的hook。，每一种hook都能单独实现，或者嵌入PyCommand。

BpHook/LogBpHook

　　当一个断点被触发的时候，这种hook就会被调用。两个hook很相似，除了BpHook被触发的时候，会停止被调试的进程，而LogBpHook不会停止被调试的进程。

AllExceptHook

​    所有的异常的都会触发这个Hook.

PostAnalysisHook

​    在一个模块被分析完成的时候，这种hook就会被触发。这非常有用，当你在模块分析完成后需要进一步进行静态分析的时候。

​    记住：在用immlib对一个模块进行函数和基础块的解码之前必须先分析这个模块。

AccessViolationHook

​    这个hook由访问违例触发。常用于在fuzz的时候自动化捕捉信息。

LoadDLLHook/UnloadDLLHook

​    当一个DLL被加载或者卸载的时候触发。

CreateThreadHook/ExitThreadHook

​    当一个新线程创建或者销毁的时候触发。

CreateProcessHook/ExitProcessHook

​    当目标进程开始或者结束的时候触发。

FastLogHook/STDCALLFastLogHook

​    这两种hook利用一个汇编跳转，将执行权限转移到一段hook代码用以记录特定的寄存器和内存数据。

​    当函数被频繁的调用的时候，这种hook非常有用。



例子：以下的logBpHook例子代码块能够作为PyHook的模板：


```
from immlib import *
class MyHook(LogBpHook):
    def __init__(self):
        LogBpHook.__init__(self)
    def run(regs):
        #Executed when hook gets triggered
```


 　　重载了LogBpHook类，并且必须建立了run()函数。当hook被触发的时候，所有的CPU寄存器，以及指令都将被存入regs,此时我们就可以修改它们了。regs是一个字典。如下访问相应寄存器的值：regs["ESP"]。

　　hook可以定义在PyCommand里，随时调用。也可以写成脚本放入PyHooks目录下。每次启动immunity都会自动加载这些目录。