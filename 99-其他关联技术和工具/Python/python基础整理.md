# 一、认识python

人生苦短，我用python ----- life is short ,you need python

python为创始人荷兰人Guido von Rossum（吉多·范·罗苏姆）于1989年圣诞节期间，在阿姆斯特丹开发。

python官网：<https://www.python.org> 

## python的优缺点

**胶水语言**

**python优点:**

1. **==简单,易学,易懂,开发效率高==**：Python容易上手,语法较简单。在linux上和写shell一样，拿着vi都可以写，直接就可以运行。
2. **==免费、开源==**：我们运维用的大部分软件都是开源啊,亲！
3. **==可移植性,跨平台==**：Python已经被移植在许多不同的平台上,Python程序无需修改就可以在Linux,Windows,mac等平台上运行。
4. **==可扩展性==**：如果你需要你的一段关键代码运行得更快或者希望某些算法不公开，你可以把你的部分程序用C或C++编写，然后在你的Python程序中使用它们（讲完编译型语言和解释型语言区别就容易理解了)。
5. **==丰富的库==**： 想产生个随机数? 调库啊。想操作os? 调库啊。想操作mysql? 调库啊调库君。。。。。。Python的库太丰富宠大了，它可以帮助你处理及应对各种场景应用。
6. ==**规范的代码**==：Python采用强制缩进的方式使得代码具有极佳的可读性。



**python缺点：**

1. ==**执行效率较慢**== : 这是解释型语言(下面的解释器会讲解说明)所通有的，同时这个缺点也被计算机越来越强性能所弥补。有些场景慢个几微秒几毫秒,一般也感觉不到。

## Python应用场景

2. **操作系统管理、服务器运维的自动化脚本**

一般说来，Python编写的系统管理脚本在可读性、性能、代码重用度、扩展性几方面都优于普通的shell脚本。

1. **Web开发**

Python经常被用于Web开发。比如，通过mod_wsgi模块，Apache可以运行用Python编写的Web程序。Python定义了WSGI标准应用接口来协调Http服务器与基于Python的Web程序之间的通信。一些Web框架，如Django,TurboGears,web2py,Zope等，可以让程序员轻松地开发和管理复杂的Web程序。

2. **服务器软件（网络软件）**

Python对于各种网络协议的支持很完善，因此经常被用于编写服务器软件、网络爬虫。第三方库Twisted支持异步网络编程和多数标准的网络协议(包含客户端和服务器)，并且提供了多种工具，被广泛用于编写高性能的服务器软件。

3. **游戏**

很多游戏使用C++编写图形显示等高性能模块，而使用Python或者Lua编写游戏的逻辑、服务器。相较于Python，Lua的功能更简单、体积更小；而Python则支持更多的特性和数据类型。

4. **科学计算**

NumPy,SciPy,Matplotlib可以让Python程序员编写科学计算程序。

5. **其它领域**

无人驾驶，人工智能等。

## 解释型语言与编译型语言 

计算机只能识别机器语言（如:01010101001这种）, 程序员不能直接去写01这种代码，所以要程序员所编写的程序语言翻译成机器语言。将其他语言翻译成机器语言的工具，称之为**编译器或解释器**。

 如：中国人 ---（翻译）----外国人

编译器翻译的方式有两种，一种是**编译**，一种是**解释**。区别如下:

- CPU

  - OS

    - 最终可执行文件 <= 编译器 <= 编译型语言源代码

    - 解释器 <= 解释型语言源代码


正因为这样的区别，所以解释型语言开发效率高，但执行慢。

## python版本

- python2.x：2020年终止维护

- python3.x：目前主流版本

## python脚本的执行方法

Python脚本可以在多种操作系统中执行，包括Windows、macOS和Linux。

- **Windows**: 使用CMD/PowerShell、IDLE或双击脚本文件。
- **macOS/Linux**: 使用终端、IDLE或Shebang行。
- **跨平台工具**: Jupyter Notebook、VS Code、PyCharm等。

### 1. **Windows**
在Windows系统中，可以通过以下几种方式执行Python脚本：

#### 方法1：使用命令行（CMD或PowerShell）
6. 打开命令提示符（CMD）或PowerShell。
7. 使用`cd`命令切换到脚本所在的目录。
8. 执行脚本：
   ```python
   python script.py
   ```
   如果系统中安装了多个Python版本，可以使用`python3`来指定Python 3：
   ```python
   python3 script.py
   ```

#### 方法2：使用Python IDLE
9. 打开Python IDLE。
10. 点击`File` -> `Open`，选择你的Python脚本。
11. 点击`Run` -> `Run Module`（或按`F5`）来执行脚本。

#### 方法3：双击脚本文件
12. 确保`.py`文件关联到Python解释器。
13. 双击脚本文件即可执行。注意，如果脚本中没有`input()`等暂停语句，脚本执行完毕后窗口会立即关闭。

### 2. **macOS**
在macOS系统中，可以通过以下几种方式执行Python脚本：

#### 方法1：使用终端（Terminal）
14. 打开终端。
15. 使用`cd`命令切换到脚本所在的目录。
16. 执行脚本：
   ```python
   python3 script.py
   ```
   macOS默认安装了Python 2.x，但通常使用`python3`来执行Python 3.x脚本。

#### 方法2：使用Python IDLE
17. 打开Python IDLE。
18. 点击`File` -> `Open`，选择你的Python脚本。
19. 点击`Run` -> `Run Module`（或按`F5`）来执行脚本。

#### 方法3：使用Shebang行
20. 在脚本的第一行添加Shebang行：
   ```python
   #!/usr/bin/env python3
   ```
21. 赋予脚本执行权限：
   ```python
   chmod +x script.py
   ```
22. 直接在终端中执行脚本：
   ```python
   ./script.py
   ```

### 3. **Linux**
在Linux系统中，可以通过以下几种方式执行Python脚本：

#### 方法1：使用终端
23. 打开终端。
24. 使用`cd`命令切换到脚本所在的目录。
25. 执行脚本：
   ```python
   python3 script.py
   ```
   Linux系统通常默认安装了Python 2.x和Python 3.x，使用`python3`来执行Python 3.x脚本。

#### 方法2：使用Shebang行
26. 在脚本的第一行添加Shebang行：
   ```python
   #!/usr/bin/env python3
   ```
27. 赋予脚本执行权限：
   ```python
   chmod +x script.py
   ```
28. 直接在终端中执行脚本：
   ```python
   ./script.py
   ```

#### 方法3：使用Python IDLE
29. 打开Python IDLE。
30. 点击`File` -> `Open`，选择你的Python脚本。
31. 点击`Run` -> `Run Module`（或按`F5`）来执行脚本。

### 4. **跨平台工具**
- **Jupyter Notebook**: 可以在浏览器中运行Python代码，适合交互式编程。
- **VS Code**: 支持多种操作系统，内置终端可以直接运行Python脚本。
- **PyCharm**: 专业的Python IDE，支持跨平台开发。

### 5. **虚拟环境**
为了隔离项目依赖，建议使用虚拟环境（如`venv`或`virtualenv`）来执行Python脚本：
```python
# 创建虚拟环境
python3 -m venv myenv

# 激活虚拟环境
# Windows
myenv\Scripts\activate
# macOS/Linux
source myenv/bin/activate

# 在虚拟环境中执行脚本
python script.py

# 退出虚拟环境
deactivate
```

# 二、python相关软件安装与使用

## python3.x解释器

- 勾选：Add Python 3.xx to PATH
- 勾选：Install launcher for all users

在linux上(如果是虚拟机上安装，请把内存调大，建议内存调整为3G或以上)安装python3.x(我这里为3.6.6版本)

第1步: 安装编译需要的依赖包

```python
cenots7系统如果gnome图形界面和开发工具都安装了,那么就还需要安装zlib-devel,openssl,openssl-devel这几个依赖包
# yum install zlib-devel openssl openssl-devel
```

第2步: 将下载的安装包拷贝到centos7系统上(此步骤请自行完成)，然后解压安装

```python
# tar xf Python-3.6.6.tar.xz -C /usr/src/
# cd /usr/src/Python-3.6.6/
```

第3步: 编译安装

```python
# ./configure  --enable-optimizations
关于--enable-optimizations参数的说明:可能因不同的同学电脑的兼容问题，有些同学会在make步骤卡住，可以尝试去掉此参数重新编译
# make					
这一步时间较长(20-30分钟，视机器速度而定)
# make install
编译第三步几乎不会报错，除非你的安装路径空间不够了
```

第4步: 确认安装后的命令

```python
# ls /usr/local/bin/python3.6
确认此命令,此为python的主命令(也就是解释器)，并且要与默认的python2区分开
# ls /usr/local/bin/pip3.6			
确认此命令,pip为python安装模块的命令,后面课程会用得到
```



## pycharm（IDE集成开发环境）

PyCharm是一种Python **==IDE==**（Integrated Development Environment, 集成开发环境）。它带有一整套可以帮助用户在使用Python语言开发时提高其效率的工具，比如调试、语法高亮、Project管理、代码跳转、智能提示、自动完成、单元测试、版本控制。

pycharm官网下载地址:

http://www.jetbrains.com/pycharm/download/#section=linux

专业版: 功能全，需要收费，但可以试用30天

社区版: 免费版，学习基础够用了

### 快捷键：

快速注释选中行： `Ctrl + /`

## pyenv（多版本管理工具）

**pyenv**是一个**==python多版本管理工具==**，当服务器上存在不同版本的python项目时，使用pyenv可以做到多版本的隔离使用(类似虚拟化)，每个项目使用不同版本互不影响。

pyenv文档及安装地址:

https://github.com/pyenv/pyenv

```python
1,使用git clone下载安装到家目录的.pyenv目录
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv

2,设置环境变量,并使之生效,这样才能直接使用pyenv命令
# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /etc/profile
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/profile
# source ~/.bash_profile

# pyenv help
# pyenv install -l		--或者使用pyenv install --list列出所有的python当前可用版本

3,先解决常见依赖包的问题，否则下一步安装会报错
# yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel libpcap-devel xz-devel -y

4,安装3.6.6版本,需要下载并安装,速度较慢。它会安装到~/.pyenv/versions/下对应的版本号
# pyenv install 3.6.6

5,查看当前安装的版本,前面带*号的是默认使用的版本
# pyenv versions		
* system (set by /root/.pyenv/version)
  3.6.6
```

**pyenv-virtualenv**是pyenv的插件，为pyenv设置的python版本提供隔离的虚拟环境。不同版本的python在不同的虚拟环境里使用互不影响。

pyenv-virtualenv文档及安装地址:

https://github.com/pyenv/pyenv-virtualenv

```python
1，将pyenv-virtualenv这个plugin下载安装到pyenv根目录的plugins/下叫pyenv-virtualenv
# git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

2，把安装的3.6.6版本做一个隔离的虚拟化环境，取名为python3.6.6(这个取名是自定义的)
# pyenv virtualenv 3.6.6  python3.6.6

3，active激活使用，但报错
# pyenv activate python3.6.6		
Failed to activate virtualenv.

Perhaps pyenv-virtualenv has not been loaded into your shell properly.
Please restart current shell and try again.
解决方法:
# echo 'eval "$(pyenv init -)"' >> /etc/profile
# echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/profile
# source /etc/profile

4,再次激活，成功
# pyenv activate python3.6.6
pyenv-virtualenv: prompt changing will be removed from future release. configure `export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.
(python3.6.6) [root@daniel ~]# pip install ipython		--安装一个ipython测试

5,使用ipython测试完后退出虚拟环境
(python3.6.6) [root@daniel ~]# ipython
In [1]: print ("hello word")                                                    
hello word

In [2]: exit          		                                                          
(python3.6.6) [root@daniel ~]# pyenv deactivate	 --这里exit就退出终端了，用此命令退出虚拟环境
[root@daniel ~]# 

这样的话，你可以在linux安装多个版本的python,使用不同的隔离环境来开发不同版本的python程序.

删除隔离环境的方法:
# pyenv uninstall python3.6.6
```



### 辅助工具

#### Flake8（代码质量工具）

Flake8 是一个集成了多个工具的Python代码质量工具，包括PyFlakes、pycodestyle和McCabe等。它能够迅速发现代码中的风格问题、潜在错误以及代码复杂度过高等问题，并提供简洁的配置和快速的性能。

#### Bandit（安全漏洞扫描工具）

Bandit 是Python安全漏洞扫描工具，由PyCQA组织开发。它专注于发现代码中的安全漏洞，如SQL注入、命令注入、敏感数据泄露等，并提供详细的报告和建议的修复措施。



#### Pylint（代码分析工具）

Pylint 是一个广泛使用的Python代码分析工具，它通过静态代码分析来检测编码标准、潜在错误和样式问题。Pylint遵循PEP 8编码规范，并提供超过100种配置选项，允许开发者根据项目需求自定义检查规则







# 三、编程前置知识

### 字符串编码常用种类

| 编码    | 制定时间 | 作用                                         | 字节数      |
| ------- | -------- | -------------------------------------------- | ----------- |
| ASCII   | 1967年   | 表示英语及西欧语言                           | 8bit/1bytes |
| GB2312  | 1980年   | 国家简体中午呢字符集，兼容ASCII              | 2bytes      |
| Unicode | 1991年   | 国际标准组织统一标准字符集                   | 2bytes      |
| GBK     | 1995年   | GB2312的拓展字符集，支持繁体中文，兼容GB2312 | 2bytes      |
| UTF-8   | 1992年   | 不定长编码                                   | 1-3bytes    |



# 四、注释

## 注释(comment)的作用与方法

 注释的作用：在程序中对某些代码进行标注说明 ，增强程序的可读性。

**1.单行注释**： # 被注释内容

在# 后面建议添加一个空格  ,然后在写注释的内容



![1540885321182](https://minioapi.nerubian.cn/image/20250208104709972.png)

在代码的后面添加注释 ：注释和代码之间要至少有两个空格

![1540885700072](https://minioapi.nerubian.cn/image/20250208104706813.png)

**2.多行注释** :   三引号（三个双引或三个单引)里包含注释内容

![1541148380640](https://minioapi.nerubian.cn/image/20250208104703542.png)

小技巧:在pycharm里可以用**==ctrl+/==**来给多行加#注释或去掉注释。



## 代码规范PEP

Python 官方提供有一系列 PEP（Python Enhancement Proposals） 文档，其中第 8 篇文档专门针对 Python 的代码格式 给出了建议，也就是俗称的 PEP 8

- PEP 8 英文文档（官方）：<https://www.python.org/dev/peps/pep-0008/>

- PEP 8 中文文档（谷歌）：<https://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/>



# 五、变量 (重点)

## 什么是变量

变量：在内存中开辟一块空间，临时保存数据。通俗的说**变量名就是存储空间的名字**，通过这个名字来访问和存储空间中的数据。

### 变量的特点

* 可以反复存储数据

* 可以反复取出数据

* 可以反复更改数据

### 变量的命名规则

* 变量名只能是**字母**、**数字**或**下划线**的任意组合
* 变量名的第一个字符不能是数字
* 变量名要有见名知义的效果, 如UserName,user_name

* 变量名区分大小写
* 以下关键字不能声明为变量名(关键字是python内部使用或有特殊含义的字符)
  ['False', 'None', 'True', 'and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']

```python
import keyword			# 导入keyword模块
print(keyword.kwlist)  	# 打印上面的关键字列表
```

##### 见名知意

变量一定要易懂，看到立刻就知道含义

##### 下划线分割命名法

当用多个单词组合作为变量名，要使用下划线作为分隔，例如 first_name = ‘li’

##### 大驼峰命名法

每个单词的首字母都大写，其余字母小写

##### 小驼峰命名法

第二及以后的单词，首字母都大写，其余字母小写

## 变量的创建(定义)

在python中,每一个变量在使用前都必须**赋值**，变量赋值后，变量就创建成功了。

**==变量名 = 值==** 

**示例**:

```python
num = 100     			# num第一次出现是表示创建(定义)这个变量    
num = num-10		
print(num)
```



**示例**:

```python
name1 = "daniel"
print(id(name1))
name2 = "daniel"
print(id(name2))   # id()函数用于获取对象内存地址编号;name1和name2得到的id相同,说明指向同一个内存空间
```

**示例:**

```python
a = 1
print(id(a))
b = 2
a = 3
print(id(a))
c = 1
print(id(c))

1413311520
1413311584
1413311520
第1次打印和第2次打印的id结果不一样,说明a=3是重新开辟了一个内存空间存放3这个值
第1次打印和第3次打印的id结果一样,说明c=1相当于是把存放1这个值的内存空间名由a换成了c
```

**示例:**

```python
a = 1
b = 2
c = 1

print(id(a))
print(id(b))
print(id(c))
结果: id(a)与id(c)得到的结果一样，因为它们的值一样。
```

**示例:**

```python
a = 1
b = 2
c = 1
a = 2

print(id(a))
print(id(b))
print(id(c))
结果: id(a)与id(b)得到的结果一样，因为它们的值一样。
```

**小结:** 变量名可以不一样，**只要值一样**，通过id()函数得到的内存地址编号就一样。(目前仅限讨论**==数字这种不可变数据类型==**)



这里引出两个概念:**可变数据类型**和**不可变数据类型**（有个印象先,讲数据类型时再细讲)



## 两个变量值的交换

其它语言中可以借助于第三个变量来交换变量 a 和b 的值

python中可以直接交换，两个变量的值

**示例**:

```python
a, b = 1, 2				# 可以像这样一次定义多个变量
print(a, b)

a, b = b, a
print(a, b)
```



## 变量的类型

在程序中，为了更好的区分变量的功能和更有效的管理内存，变量也分为不同的类型。

Python是**==强类型==**的**==动态==**解释型语言。

强类型: 不允许不同类型相加。如整型+字符串会报错。

动态：不用显示声明数据类型，确定一个变量的类型是在第一次给它赋值的时候，也就是说: **==变量的数据类型是由值决定的==**。



**示例**:

```python
name = "zhangsan"		# str类型
age = 25				# 25没有加引号，则为int类型；加了引号，则为str类型;
height = 1.8			# float类型
marry = True			# bool类型

print(type(name))			# 通过type()内置函数得知变量的类型
print(type(age))
print(type(height))
print(type(marry))
```





# 六、输入输出(重点)

## 输入:input()

还记得shell里的read吗？

用python3中可以使用input()函数等待用户的输入（python2中为raw_input()函数)

**示例**:

```python
name = input("what is your name: ")
age = input("what is your age: ")		# input输入的直接就为str类型，不需要再str()转换了

print(name, "你" + age + "岁了")
```

**小结:**  用单引号，双引号，三引号和input()函数输入的都为字符串类型。



## 输出:print()

### 基本的打印规则

Python程序由多个逻辑行构成，一个逻辑行不一定为一个物理行(人眼看到的行)

显示行连接: \
​        在物理行后跟反斜杠， 代表此行连接下一行代码

隐式行连接: () [] {}
   	在括号里换行会自动行连接

字符串需要用引号引起来，单引双引三引都可以。

### 占位符（格式化输出）

#### %

- 生成一定格式的字符串
- 占位符只是占据位置，并不会输出

| 占位符 | 作用                         |
| ------ | ---------------------------- |
| %%     | 占位输出                     |
| %s     | 字符串                       |
| %d     | 整数                         |
| %c     | 字符及ASCII码                |
| %u     | 无符号整型                   |
| %o     | 无符号8进制数                |
| %x     | 无符号16进制数               |
| %X     | 无符号16进制数（大写）       |
| %f     | 浮点数，可指定小数点后的精度 |
| %e     | 用科学计数法格式化浮点数     |
| %E     | 作用同%e                     |
| %g     | %f 和 %e的简写               |
| %G     | %F 和 %E的简写               |
| %p     | 用16进制数格式化变量的地址   |

例子：

```python
print("我是%%的1%%"%())
输出：我是%的%

name = 'xiaoming'
age = 18
print("名字：%s" %name)
print("名字：%s,年龄：%d" %(name,age))

# 设置显示整数的位数，不足用空白补全
a = 123
print("%015d") # 表示输出的15位数，不足用0补全，超出当前设置位数则原样输出

# 设置显示整数的位数，不足用空白补全
# 默认小数点后显示6位，遵循四舍五入原则
num = 1.212121
print("%f" %num)
print("%3f" %num) # 设置小数点后显示3位，超出当前设置位数则原样输出
```
#### format()





#### 格式化 f

```python
# 格式：f"{表达式}"

name = 'xiaoming'
age = 18
print(f"我的名字是{name},我今年{age}岁了")
```

### 转义字符

#### 制表符：`\t`

```python
print('12345\t6789')
输出：12345	6789
```

#### 换行符：`\n`

```python
print('第一行\n第二行')
输出：
第一行
第二行
```

#### 回车符：`\r`

将当前位置移到本行开头

```python
print('12345\r6789')
输出：6789
```

#### 反斜杠转义符：`\\`

```python
print('12345\\6789')
输出：12345\6789
```

r原生字符串，取消默认转义

```python
pring(r"123\\\456")
输出：123\\\456
```


# 七、文件IO操作

io(input and output): 磁盘读写

## 回顾下shell里的文件操作

shell里主要就是调用awk,sed命令来处理文件，特别是sed命令可以使用`sed -i`命令直接操作文件的增,删,改。

## python文件操作的步骤

python文件的操作就**三个**步骤：

32. 先**==open打开==**一个要操作的文件
33. **==操作==**此文件(读，写，追加等) 
34. **==close关闭==**此文件

## python文件的打开与关闭

```python
f = open("文件路径","文件访问模式")		# 打开文件简单格式，需要赋值给一个变量


f.close()							   # 关闭的方法
```

```python
with open("文件路径", '文件访问模式') as f:	# 此方法打开文件不用后面再使用close关闭了	
```

## python文件访问模式

| 访问模式             | 说明                                                         |
| -------------------- | ------------------------------------------------------------ |
| ==r==       (read)   | 只读模式,不能写（文件必须存在，不存在会报错）                |
| ==w==      (write)   | 只写模式,不能读（文件存在则会被覆盖内容（要千万注意），文件不存在则创建） |
| ==a==       (append) | 追加模式,不能读                                              |
| r+                   | 读写模式                                                     |
| w+                   | 写读模式                                                     |
| a+                   | 追加读模式                                                   |
| rb                   | 二进制读模式                                                 |
| wb                   | 二进制写模式                                                 |
| ab                   | 二进制追加模式                                               |
| rb+                  | 二进制读写模式                                               |
| wb+                  | 二进制写读模式                                               |
| ab+                  | 二进制追加读模式                                             |



## python主要的访问模式示例

### 只读模式(r)

**示例: **

先在linux操作系统上使用`head -5 /etc/passwd > /tmp/1.txt`准备一个文件

```python
f = open('/tmp/1.txt", encoding="utf-8")		# 默认就是只读模式
# 如果不同平台,可能会字符集编码不一致,不一致的需要指定;一致的不用指定。

data1 = f.read()
data2 = f.read()				# 读第二遍

f.close()

print(data1)
print("="*50)
print(data2)	# 发现读第二遍没有结果;类似从上往下读了一遍，第二次读从最后开始了，所以就没结果了
```



### tell与seek的理解

```python
f = open("/tmp/1.txt", "r")
print(f.tell())			# 结果为0 (告诉你光标在哪,刚打开文件，光标在0位置)
f.seek(5)				# 移你的光标到整个文件的第6个字符那(因为0为第一个)
print(f.tell())			# 结果为5
f.seek(2)				# 移你的光标到整个文件的第3个字符那，从0开始算，而不是从上面的位置开始算
print(f.tell())			# 结果为2

f.close()
```



### 深入理解只读模式

**示例:**

```python
f = open("/tmp/1.txt", mode="r")

data1 = f.read()		# 读了第一次后，光标在最后的位置
f.seek(0)				# 通过seek(0)将光标又重置回开始的位置
data2 = f.read()		# 再次读的话，就可以又重头读一遍了,data2变量的内容与data1的内容就一致了

f.close()

print(data1)
print("="*20)
print(data2)
```



**示例: **

```python
f = open("/tmp/1.txt", "r")

f.seek(5)					# 光标移到第6个字符那里
data1 = f.read()			# read是读整个文件在光标后面的所有字符(包括光标所在的那个字符)，读完后，会把光标移到你读完的位置

f.seek(5)					# 光标重置到第6个字符那里
data2 = f.readline()		# readline是读光标所在这一行的在光标后面的所有字符(包括光标所在的那个字符)，读完后，会把光标移到你读完的位置

f.seek(5)					# 光标重置到第6个字符那里
data3 = f.readlines()		# readlines和read类似，但把读的字符按行来区分做成了列表

f.close()
print(data1)
print("="*30)
print(data2)
print("="*30)
print(data3)
```

**示例: 打印文件的第3行**

```python
f = open("/tmp/1.txt", mode="r")

data = f.readlines()			# 把文件从第1行到最后1行全读取，并转成列表

f.close()
print(data[2].strip())		# 通过列表的下标2取第3行，取出来的行是字符串，使用strip()去掉换行符
```



### 文件读的循环方法

**示例: **

```python
f = open("/tmp/1.txt", "r")

#循环方法一:
for index, line in enumerate(f.readlines()):
     print(index, line.strip())		# 需要strip处理，否则会有换行
        
# 循环方法二:这样效率较高，相当于是一行一行的读，而不是一次性全读（如果文件很大，那么一次性全读会速度很慢)
for index, line in enumerate(f):
     print(index, line.strip())

f.close()
```

**示例: 打印文件的第3行**

```python
f = open("/tmp/1.txt", mode="r")

for index, line in enumerate(f):		# 边读边循环
    if index == 2:						# 通过enumerate产生的下标来取第3行
        print(line.strip())				# 每一行的内容为字符串类型，使用strip()处理换行符

f.close()
```



**示例: 通过/proc/meminfo得到可用内存的值**

```python
f = open("/proc/meminfo", "r")

for line in f:
    if line.startswith("MemAvailable"):
        print(line.split()[1])

f.close()
```




### 只写模式(w) 

**示例: **

```python
f = open("/tmp/1.txt",'w')      # 只写模式(不能读),文件不存在则创建新文件，如果文件存在，则会复盖原内容(千W要小心)
data = f.read()  				# 只写模式,读会报错

f.close()
```

**示例: 创建新文件,并写入内容**

```python
f = open("/tmp/2.txt", 'w')	# 文件不存在,会帮你创建(类似shell里的 > 符号)

f.write("hello\n")			# 不加\n,默认不换行写
f.write("world\n")
f.truncate()				# 截断，括号里没有数字，那么就是不删除
f.truncate(3)				# 截断，数字为3，就是保留前3个字节
f.truncate(0)				# 截断，数字为0，就是全删除
 
f.close()
```



**练习: 把九九乘法表直接写到一个文件里**

```python
f = open("/tmp/3.txt", "w")

for i in range(1, 10):
    for j in range(1, i+1):
        f.write("{}*{}={} ".format(i, j, i*j))
    f.write("\n")

f.close()
```



### 追加模式(a)

**示例:**

```python
f = open("/tmp/2.txt", 'a')	# 类似shell里的>>符

f.write("hello\n")	
f.write("world\n")
f.truncate(0)				# 追加模式也可以使用truncate截取前面的数据

f.close()
```

**小结:**

r: 只读模式		文件必须要存在; 

w: 只写模式		文件存在则会清空原文件内容再写，不存在则会创建文件再写

a: 追加模式	        与w模式的区别为a模式不清空原文件内容，在最后追加写





### 比较r+,w+,a+三种模式(拓展)

```python
r+文件必须要存在，相当于在只读模式的基础上加了写权限;

w+会清空原文件的数据，相当于在只写模式的基础上加了读权限；(可以在任意位置写，但要用seek定位光标，还要区分读光标和写光标)

a+不会改变原文件的数据，相当于在只追加模式的基础上加了读权限;（写是在最后写，即使用seek把光标移到前面，仍然会写在最后)
```



### r+,w+,a+混合读写深入理解(拓展)

**示例: **

```python
f = open("/tmp/2.txt", "w+")

f.write("11111\n")
f.write("22222\n")
f.write("33333\n")

print(f.tell())			# 打印结果为18,表示光标在文件最后

f.write("aaa")			# 这样写aaa,相当于在文件最后追加了aaa三个字符

f.seek(0)				# 表示把光标移到0(也就是第1个字符)
f.write("bbb")			# f.seek(0)之后再写bbb,就是把第一行前3个字符替换成了bbb

f.seek(0)				# 把光标再次移到0
f.readline()			# 把光标移到第1行最后
f.seek(f.tell())		# f.seek到第1行最后(如果这里理解为两个光标的话，你可以看作是把写光标同步到读光标的位置)
f.write("ccc")			# 这样写ccc，就会把第二行的前3个字符替换成ccc

f.close()
```



**练习: 往一个新文件里写九九乘法表，并直接读出结果**

```python
f = open("/tmp/4.txt", "w+")

for i in range(1, 10):
    for j in range(1, i+1):
        f.write("{}*{}={} ".format(i, j, i*j))
    f.write("\n")

f.seek(0)						# 这里需要seek(0),否则读不出来
data1 = f.read()

f.close()
print(data1)
```



**总结:**

 r+,w+,a+这三种模式因为涉及到读与写两个操作,你可以使用两个光标来理解,但这样的话读光标与写光标会容易混乱，所以我们总结下面几条:

35. f.seek(0)是将读写光标都移到第1个字符的位置

36. 如果做了f.read()操作,甚至是做了f.readline()操作,写光标都会跑到最后

37. 如果做了f.write()操作,也会影响读光标

**==所以建议在做读写切换时使用类似f.seek(0)和类似f.seek(f.tell())这种来确认一下位置，再做切换操作==**




### 二进制相关模式（拓展）

二进制模式用于网络传输等相关的情况

**示例: 二进制读模式**

```python
f = open("/tmp/2.txt", "rb")

print(f.readline())
print(f.readline())

f.close()
```

**示例: 二进制写模式**

```python
f = open("/tmp/2.txt", "wb")
f.write("hello word".encode())	# 需要encode才能成功写进去

f.close()
```



## 课后示例与练习

**示例: 文件的字符串全替换(拓展)**  

两个文件, 一个读，另一个替换完后写,最后再覆盖回来

```python
import os
f1 = open("/tmp/1.txt", 'r')
f2 = open("/tmp/2.txt", 'w')

oldstr = input('old string:')
newstr = input('new string:')

for i in f1:
	if oldstr in i:
        i = i.replace(oldstr,newstr)
    f2.write(i)

os.remove("/tmp/1.txt")
os.rename("/tmp/2.txt","/tmp/1.txt")

f1.close()
f2.close()
```

**练习:（有难度，想挑战的可以尝试) **

以下面字典中的数据，评选最佳group,最佳class和teacher

```python
info={
    "group1":{
        "class1":["李老师","班级平均成绩85"],
        "class2":["张老师","班级平均成绩89"],
    },
    "group2": {
        "class3": ["王老师", "班级平均成绩78"],
        "class4": ["赵老师", "班级平均成绩91"],
    },
    "group3": {
        "class5": ["马老师", "班级平均成绩82"],
        "class6": ["陈老师", "班级平均成绩79"],
    },
    "group4": {
        "class7": ["钱老师", "班级平均成绩90"],
        "class8": ["孙老师", "班级平均成绩80"],
    },
}
```

```python
答案:
```



**练习: (有难度，想挑战的可以尝试)** 

 找出同时选修了任意1种课程的人,任意2种课程的人,任意3种课程的人,任意4种课程的人

```python
math = ["张三", "田七", "李四", "马六"]
english = ["李四", "王五", "田七", "陈八"]
art = ["陈八", "张三", "田七", "赵九"]
music = ["李四", "田七", "马六", "赵九"]


```



**示例: 打印一个文件的前5行，并打印行号（不是下标）**

```python
f = open("/tmp/1.txt", "r")

for index, line in enumerate(f):
    if index < 5:
        print(index+1, line.strip())
 
f.close()
```


### 只写模式(w) 

**示例: **

```python
f = open("/tmp/1.txt",'w')      # 只写模式(不能读),文件不存在则创建新文件，如果文件存在，则会复盖原内容(千W要小心)
data = f.read()  				# 只写模式,读会报错

f.close()
```

**示例: 创建新文件,并写入内容**

```python
f = open("/tmp/2.txt", 'w')	# 文件不存在,会帮你创建(类似shell里的 > 符号)

f.write("hello\n")			# 不加\n,默认不换行写
f.write("world\n")
f.truncate()				# 截断，括号里没有数字，那么就是不删除
f.truncate(3)				# 截断，数字为3，就是保留前3个字节
f.truncate(0)				# 截断，数字为0，就是全删除
 
f.close()
```

**练习: 配置本地yum**

```python
f = open("/etc/yum.repos.d/local.repo", mode="w")

f.write("[local]\n")
f.write("name=local\n")
f.write("baseurl=file:///mnt\n")
f.write("enabled=1\n")
f.write("gpgcheck=0\n")

f.close()
```

```python
f = open("/etc/yum.repos.d/local.repo", mode="w")

f.write('''[enable]
name=local
baseurl=file:///mnt
gpgcheck=0
enabled=1
''')

f.close()
```

```python
f = open("/etc/yum.repos.d/local.repo", mode="w")

f.write("[enable]\n"
        "name=local\n"
        "baseurl=file:///mnt\n"
        "gpgcheck=0\n"
        "enabled=1\n")

f.close()
```

```python
f = open("/etc/yum.repos.d/local.repo", mode="w")

f.write("[enable]\nname=local\nbaseurl=file:///mnt\ngpgcheck=0\nenabled=1\n")

f.close()
```



**练习: 把九九乘法表直接写到一个文件里**

```python
f = open("/tmp/3.txt", mode="w")

for i in range(1, 10):
    for j in range(1, i+1):
        f.write("{}*{}={}\t".format(j, i, i*j))
    f.write("\n")

f.close()
```



### 追加模式(a)

**示例:**

```python
f = open("/tmp/2.txt", 'a')	# 类似shell里的>>符

f.write("hello\n")	
f.write("world\n")
f.truncate(0)				# 追加模式也可以使用truncate截取前面的数据

f.close()
```

**小结:**

r: 只读模式		文件必须要存在; 

w: 只写模式		文件存在则会清空原文件内容再写，不存在则会创建文件再写

a: 追加模式	        与w模式的区别为a模式不清空原文件内容，在最后追加写





### 比较r+,w+,a+三种模式(拓展)

```python
r+文件必须要存在，相当于在只读模式的基础上加了写权限;

w+会清空原文件的数据，相当于在只写模式的基础上加了读权限；(可以在任意位置写，但要用seek定位光标，还要区分读光标和写光标)

a+不会改变原文件的数据，相当于在只追加模式的基础上加了读权限;（写是在最后写，即使用seek把光标移到前面，仍然会写在最后)
```



### r+,w+,a+混合读写深入理解(拓展)

**示例: **

```python
f = open("/tmp/2.txt", "w+")

f.write("11111\n")
f.write("22222\n")
f.write("33333\n")

print(f.tell())			# 打印结果为18,表示光标在文件最后

f.write("aaa")			# 这样写aaa,相当于在文件最后追加了aaa三个字符

f.seek(0)				# 表示把光标移到0(也就是第1个字符)
f.write("bbb")			# f.seek(0)之后再写bbb,就是把第一行前3个字符替换成了bbb

f.seek(0)				# 把光标再次移到0
f.readline()			# 把光标移到第1行最后
f.seek(f.tell())		# f.seek到第1行最后(如果这里理解为两个光标的话，你可以看作是把写光标同步到读光标的位置)
f.write("ccc")			# 这样写ccc，就会把第二行的前3个字符替换成ccc

f.close()
```



**练习: 往一个新文件里写九九乘法表，并直接读出结果**

```python
f = open("/tmp/4.txt", "w+")

for i in range(1, 10):
    for j in range(1, i+1):
        f.write("{}*{}={} ".format(i, j, i*j))
    f.write("\n")

f.seek(0)						# 这里需要seek(0),否则读不出来
data1 = f.read()

f.close()
print(data1)
```



**总结:**

 r+,w+,a+这三种模式因为涉及到读与写两个操作,你可以使用两个光标来理解,但这样的话读光标与写光标会容易混乱，所以我们总结下面几条:

38. f.seek(0)是将读写光标都移到第1个字符的位置

39. 如果做了f.read()操作,甚至是做了f.readline()操作,写光标都会跑到最后

40. 如果做了f.write()操作,也会影响读光标

**==所以建议在做读写切换时使用类似f.seek(0)和类似f.seek(f.tell())这种来确认一下位置，再做切换操作==**




### 二进制相关模式（拓展）

二进制模式用于网络传输等相关的情况

**示例: 二进制读模式**

```python
f = open("/tmp/2.txt", "rb")

print(f.readline())
print(f.readline())

f.close()
```

**示例: 二进制写模式**

```python
f = open("/tmp/2.txt", "wb")
f.write("hello word".encode())	# 需要encode才能成功写进去

f.close()
```



# 八、运算符

## 算术运算符(常用)

| 算术运算符 | 描述         | 实例                              |
| ---------- | ------------ | --------------------------------- |
| +          | 加法         | 1+2=3                             |
| -          | 减法         | 5-1=4                             |
| *          | 乘法         | 3*5=15                            |
| /          | 除法         | 10/2=5                            |
| //         | 整除         | 10//3=3  不能整除的只保留整数部分 |
| **         | 求幂         | 2**3=8                            |
| %          | 取余（取模） | 10%3=1  得到除法的余数            |

```python
a = 9
b = 2
print(a+b)
print(a-b)
print(a*b)
print(a/b)  # 注意：算数运算符/过后，商一定是浮点数，并且除数不能为0
print(a//b) # 其中的值如果有浮点数，结果为浮点数型
print(a%b)	
print(a**b)
```

## 赋值运算符(常用)

- 赋值运算符中间不能有空格
- 变量必须被提前定义，否则会报错
- 纯数字不能使用赋值运算符，纯数字不能作为变量

| 赋值运算符 | 描述                                     | 实例                              |
| ---------- | ---------------------------------------- | --------------------------------- |
| =          | 简单的赋值运算符，下面的全部为复合运算符 | c =a + b 将a + b的运算结果赋值给c |
| +=         | 加法赋值运算符                           | a += b 等同于 a = a + b           |
| -=         | 减法赋值运算符                           | a -= b 等同于 a = a - b           |
| *=         | 乘法赋值运算符                           | a *= b 等同于 a = a * b           |
| /=         | 除法赋值运算符                           | a /= b 等同于 a = a / b           |
| //=        | 整除赋值运算符                           | a //= b 等同于 a = a // b         |
| **=        | 求幂赋值运算符                           | a ** = b 等同于 a = a ** b        |
| %=         | 取余（取模)赋值运算符                    | a %= b 等同于 a = a % b           |



## 比较运算符(常用)

| 比较运算符 | 描述                                            | 实例                     |
| ---------- | ----------------------------------------------- | ------------------------ |
| ==         | 等等于，判断是否相等，相等为True，不等于为False | print(1==1)   返回True   |
| !=         | 不等于,类似shell里的-ne                         | print(2!=1)    返回True  |
| <>         | 不等于（同 != )                                 | print(2<>1)   返回True   |
| >          | 大于, 类似shell里的-gt                          | print(2>1)     返回True  |
| <          | 小于, 类似shell里的-lt                          | print(2<1)     返回False |
| >=         | 大于等于 类似shell里的-ge                       | print(2>=1)   返回True   |
| <=         | 小于等于 类似shell里的-le                       | print(2<=1)  返回False   |

```python
print(type(2<=1)) 		# 结果为bool类型，所以返回值要么为True,要么为False.
```



## 逻辑运算符(常用)

| 逻辑运算符 | 逻辑表达式 | 描述                                                         |
| ---------- | ---------- | ------------------------------------------------------------ |
| and        | x and y    | x与y都为True,则返回True;x与y任一个或两个都为False，则返回False |
| or         | x or y     | x与y任一个条件为True，则返回True                             |
| not        | not x      | x为True，返回False; x为False，返回True                       |



## 成员运算符(比较常用)

在后面讲解和使用序列(str,list,tuple) 时，还会用到以下的运算符。

| 成员运算符 | 描述                                                         |
| ---------- | ------------------------------------------------------------ |
| in         | x 在 y 序列中 , 如果 x 在 y 序列中返回 True; 反之，返回False |
| not in     | x 不在 y 序列中 , 如果 x 不在 y 序列中返回 True; 反之，返回False |

```python
在SQL语句里也有in和not in运算符;如(没有学习mysql的话，后面会学习了就知道了)
mysql > select * from xxx where name in ('tom','john');
```



## 身份运算符(拓展)

| 身份运算符 | 描述                                        | 实例                                                         |
| ---------- | ------------------------------------------- | ------------------------------------------------------------ |
| is         | is 是判断两个标识符是不是引用自一个对象     | **x is y**, 类似 **id(x) == id(y)** , 如果是同一个对象则返回 True，否则返回 False |
| is not     | is not 是判断两个标识符是不是引用自不同对象 | **x is not y** ,类似 **id(a) != id(b)**。如果不是同一个对象则返回结果 True，否则返回 False。 |

**is 与 == 区别**：

is 用于判断两个变量引用对象是否为同一个(同一个内存空间)， == 用于判断引用变量的值是否相等。

```python
a = [1,2,3]			# 后面会学到，这是列表
b = a[:]			# 后面会学到，这是列表的切片
c = a
print(b is a)		# False
print(b == a)		# True

print(c is a)		# True
print(c == a)		# True
```



## 位运算符 (拓展)

大家还记得IP地址与子网掩码的二进制算法吗？

这里的python位运算符也是用于操作二进制的。

| 位运算符 | 说明                                             |
| -------- | ------------------------------------------------ |
| &        | 对应二进制位两个都为1，结果为1                   |
| \|       | 对应二进制位两个有一个1, 结果为1, 两个都为0才为0 |
| ^        | 对应二进制位两个不一样才为1,否则为0              |
| >>       | 去除二进制位最右边的位，正数上面补0, 负数上面补1 |
| <<       | 去除二进制位最左边的位，右边补0                  |
| ~        | 二进制位，原为1的变成0, 原为0变成1               |



## 运算符的优先级

常用的运算符中:  算术  >  比较  >  逻辑  > 赋值 

示例: 请问下面的结果是什么?

```python
result = 3-4 >= 0 and 4 * (6 - 2) > 15
print(result)

result = -1 >= 0 and 16 > 15     # 算术运算后
result = False and True			 # 比较运算后
result = False  				 # 逻辑运算后
```



# 九、判断语句(重点)

## shell判断语句格式

**shell单分支判断语句**:

```shell
if 条件;then
	执行动作一
fi
```

**shell双分支判断语句**:

```shell
if 条件;then
	执行动作一
else
	执行动作二
fi
```

**shell多分支判断语句**:

```shell
if 条件一;then
	执行动作一
elif 条件二;then
	执行动作二
elif 条件三;then
	执行动作三
else
	执行动作四
fi
```

shell里的case语句

```python
case "变量" in 
	值1 )
		  执行动作一
		  ;;
	值2 )
		 执行动作二
		  ;;
	值3 )
		 执行动作三
		  ;;
	* )
		 执行动作四
esac
```

## python判断语句格式

**python单分支判断语句**:

```python
if 条件:					# 条件结束要加:号(不是;号)
	执行动作一			# 这里一定要缩进（tab键或四个空格)，否则报错
                        # 没有fi结束符了，就是看缩进
```

**python双分支判断语句**:

```python
if 条件:
	执行动作一			
else:					# else后面也要加:
	执行动作二
```

**python多分支判断语句**:

```python
if 条件一:
	执行动作一
elif 条件二:			  # elif 条件后面都要记得加:
	执行动作二
elif 条件三:
	执行动作三
else:
	执行动作四
```

shell里有个case语句, 也可以实现多分支判断。但是**python里没有case语句**.

**示例: 基本格式练习**

```python
# 单分支判断
if True:
    print("真")				# 前面一定要缩进(tab键或4个空格)

# 双分支判断
if True:
    print("真")				# 前面一定要缩进(tab键或4个空格)
else:
    print("假")				# 前面一定要缩进(tab键或4个空格)

# 多分支判断
num = 34
gnum = int(input("你猜:"))
if gnum > num:
    print("大了")				# 前面一定要缩进(tab键或4个空格)
elif gnum < num:
    print("小了")				# 前面一定要缩进(tab键或4个空格)
else:
    print("对了")				# 前面一定要缩进(tab键或4个空格)
```

**示例:看看下面语句有什么错误**:

```python
if 1 > 0:
    print("yes")
else:
    print("no")
print("haha")
    print("hehe")
```

## if嵌套

示例格式:

```python
if 条件一:
    if 条件二:
		执行动作一		# 条件一，二都为True，则执行动作一
    else:
        执行动作二		# 条件一True，条件二False，则执行动作二
    执行动作三			# 条件一True，条件二无所谓，则执行动作三
else:
    if 条件三:
        执行动作四		# 条件一False，条件三True，则执行动作四
    else:
        执行动作五		# 条件一False,条件三False,则执行动作五
	执行动作六			# 条件一False,条件二，三无所谓，则执行动作六
执行动作七				# 与if里的条件无关，执行动作七
```

**示例:**

```python
name = input("输入你的名字:")
sex = input("输入你的性别:")
age = int(input("输入你的年龄:"))

if sex == "男":
    if age >= 18:
        print("{},sir".format(name))
    else:
        print("{},boy".format(name))
elif sex == "女":
    if age >= 18:
        print("{},lady".format(name))
    else:
        print("{},girl".format(name))
else:
    print("性别有误")
```


# 十、循环语句(重点)

## while循环

**只要满足while指定的条件，就循环**。

基本格式

```python
while 条件:
      条件满足时候:执行动作一
	  条件满足时候:执行动作二
      ......
```

**注意:** 没有像shell里的do..done来界定**循环体**，所以要看缩进。

**示例:打印1-100的奇数**

```python
i = 1
while i < 101:
    if i % 2 == 1:
        print(i, end=" ")
    i += 1
```

## for循环

- for循环遍历一个对象（比如数据序列，字符串，列表，元组等）,根据遍历的个数来确定循环次数。
- for循环可以看作为定循环
- while循环可以看作为不定循环

基本格式

```python
for 变量  in  数据:
    重复执行的代码
```

**示例:**

```python
for i in 1, 2, 3, 4, 5:
    print(i, end=" ")
print()

for i in range(1, 6):	# range()函数，这里是表示1，2，3，4，5（不包括6）
    print(i)
    
for i in range(6):		# range()函数，这里是表示0，1，2，3，4，5（不包括6，默认从0开始）
    print(i)    

for i in range(1, 100, 2):	# 循环1-100的奇数
    print(i, end=" ")
print()

for i in range(100, 1, -2):
    print(i, end=" ")
```


## 循环控制语句

```python
continue		# 跳出本次循环，直接执行下一次循环    
break			# 退出循环，执行循环外的代码　
exit()			# 退出python程序，可以指定返回值
```

**示例: 猜数字小游戏**

```python
import random				# 导入随机数模块(后面会专门讲模块的使用，这里先拿来用用)

num = random.randint(1, 100)	# 取1-100的随机数（包括1和100)

while True:
    gnum = int(input("你猜:"))
    if gnum > num:
        print("猜大了")
    elif gnum < num:
        print("猜小了")
    else:
        print("猜对了")
        break              # 退出死循环
print("领奖")
```

## **循环嵌套(了解)**

- if,while,for都可以互相嵌套

**示例: 打印九九乘法表**

```python
1*1=1 
1*2=2 2*2=4 
1*3=3 2*3=6 3*3=9 
1*4=4 2*4=8 3*4=12 4*4=16 
1*5=5 2*5=10 3*5=15 4*5=20 5*5=25 
1*6=6 2*6=12 3*6=18 4*6=24 5*6=30 6*6=36 
1*7=7 2*7=14 3*7=21 4*7=28 5*7=35 6*7=42 7*7=49 
1*8=8 2*8=16 3*8=24 4*8=32 5*8=40 6*8=48 7*8=56 8*8=64 
1*9=9 2*9=18 3*9=27 4*9=36 5*9=45 6*9=54 7*9=63 8*9=72 9*9=81 
```

思路: 先简单化成下面的图形

```python
* 
* * 
* * * 
* * * * 
* * * * * 
* * * * * * 
* * * * * * * 
* * * * * * * * 
* * * * * * * * * 
```

再简单化成下面的图形

```python
* 
* * 
* * * 
```

打印1:

```python
for line in range(1, 4):
    for field in range(1, 4):
        print("*", end=" ")
    print()
    
* * * 
* * * 
* * * 
```

打印2:

```python
for line in range(1, 4):
    for field in range(1, line+1):
        print("*", end=" ")
    print()
    
* 
* * 
* * * 
```

打印3:

```python
for line in range(1, 10):
    for field in range(1, line+1):
        print("*", end=" ")
    print()
* 
* * 
* * * 
* * * * 
* * * * * 
* * * * * * 
* * * * * * * 
* * * * * * * * 
* * * * * * * * * 
```

打印4:

```python
for line in range(1, 10):
    for field in range(1, line+1):
        print("{}*{}={}".format(field, line, field*line), end="\t")
    print()
```

```python
1*1=1	
1*2=2	2*2=4	
1*3=3	2*3=6	3*3=9	
1*4=4	2*4=8	3*4=12	4*4=16	
1*5=5	2*5=10	3*5=15	4*5=20	5*5=25	
1*6=6	2*6=12	3*6=18	4*6=24	5*6=30	6*6=36	
1*7=7	2*7=14	3*7=21	4*7=28	5*7=35	6*7=42	7*7=49	
1*8=8	2*8=16	3*8=24	4*8=32	5*8=40	6*8=48	7*8=56	8*8=64	
1*9=9	2*9=18	3*9=27	4*9=36	5*9=45	6*9=54	7*9=63	8*9=72	9*9=81	
```


**扩展语法:**

for也可以结合else使用，如下面判断质数(**只能被1和自己整除的数**)的例子

```python
num = int(input("输入一个大于2的整数"))

for i in range(2, num):
    if num % i == 0:
        print("不是质数")
        break
else:						# 这里的else是与for在同一列上,不与if在同一列。
   	 print("是质数")
```



# 十一、数据类型


| 类型  | 类型      | 类型描述                   | 示例                    |     |       |
| --- | ------- | ---------------------- | --------------------- | --- | ----- |
| 数字  | int     | 整型，整数                  | 1, 2, -1, -2          |     | 不可变类型 |
| 数字  | float   | 浮点型，小数                 | 34.67                 |     | 不可变类型 |
| 数字  | bool    | 布尔型，真和假                | True/False            |     | 不可变类型 |
| 数字  | complex | 复数                     | (4+3J                 |     | 不可变类型 |
| 字符串 | str     | 单引号，双引号和三引号内的内容        | "12345"               | 序列  | 不可变类型 |
| 列表  | list    | 使用中括号定义                | [1, 2, 3, 4]          | 序列  | 可变类型  |
| 元组  | tuple   | 使用小括号定义                | (1, 2, 3, 4)          | 序列  | 不可变类型 |
| 字典  | dict    | 使用大括号定义，存放key-value键值对 | {"a":1, "b":2, "c":3} |     | 可变类型  |
| 集合  | set     | 也使用大括号定义，但与字典有所不同      | {1, 2, 3, 4}          |     | 可变类型  |


## 数据类型的判断

```
a = 1
print(type(a))
```

## 数据类型的转换

| 转换函数   | 说明                           |
| :--------- | :----------------------------- |
| int(xxx)   | 将xxx转换为整数                |
| float(xxx) | 将xxx转换为浮点型              |
| str(xxx)   | 将xxx转换为字符串              |
| list(xxx)  | 将xxx转换为列表                |
| tuple(xxx) | 将xxx转换为元组                |
| dict(xxx)  | 将xxx转换为字典                |
| set(xxx)   | 将xxx转换为集合                |
| chr(xxx)   | 把整数[0-255]转成对应的ASCII码 |
| ord(xxx)   | 把ASCII码转成对应的整数[0-255] |

**示例**:

```python
age = 25					
print(type(age))	# int类型
age = str(25)
print(type(age))	# str类型
```

**示例**:

```python
name = "zhangsan"
age = 25				

print(name, "你" + age + "岁了")    # str+int，字符串拼接报错;age=str(25),这一句就可以成功。
```
## 数值类型（Number）


### 1.整数型：int

任意大小的整数

```python
num1 = 1
num1 = -1
```

### 2.浮点型：float

小数

```python
num2 = 1.5
```

### 3.布尔型：bool

固定写法，必须严格区分大小写：

1. True：真
2. False：假

```python
错误写法：print(type(true))
```

布尔值可以当作整数对待，True相当于1，False相当于0：

```python
print(True+False) # 结果为1
```

### 4.复数型：complex

固定写法：
```python
z = a + bj   #a是实部，b是虚部，j是虚数单位（虚数单位只能是j，不能更改）
```

示例：
```python
print(type(2+3j))
ma1 = 1 + 2j
ma2 = 2 + 3j
print(ma1+ma2)
输出：(3+5j)
```


## 字符串-str(重点)

### **字符串的定义与输入**

在python中,用引号引起来的都是字符串。还有input函数输入的， str()函数转换的等。

```python
string1 = "hello"
string2 = 'hello'
string3 = """hello
python"""
string4 = '''hello
world'''
string5 = input("input anything: ")
string6 = str(18)

print(isinstance(string3,str))	# isinstance函数可以用来判断数据是否为某一个数据类型，返回值为True或False
```



### 字符串的拼接与格式化输出

```python
name = "daniel"

str1 = "===" + name + "==="
str2 = "===%s===" % (name)
str3 = "==={}===".format(name)

print(str1)
print(str2)
print(str3)				# 三种方法结果一样
```

```python
name = "张三"

print("你好,", name)		# 这种打印的结果与后三种稍有不同
print("你好," + name)
print("你好,%s" % (name))
print("你好,{}".format(name))
```

**小结:** 变量在引号里得不到值，只能得到变量名，要得到变量的**==值==**，就格式化输出(使用上面三种方法之一即可)





### 字符串的下标(重点)

**字符串，列表，元组都属于==序列==**(sequence)，所以都会有下标。

什么是下标(index)？

![1541171710101](https://minioapi.nerubian.cn/image/20250208104511329.png)

**示例: 将字符串遍历打印**

```python
str1 = "hello,python"

for i in str1:					# 直接用for循环遍历字符串
    print(i, end=" ")
```

**示例: 将字符串遍历打印,并对应打印出下标**

```python
str1 = "hello,python"

for i, j in enumerate(str1):	# 枚举
    print(i, j)
```

**示例: 将字符串遍历打印,并对应打印出顺序号(从1开始，不是像下标那样从0开始)**

```python
str1 = "hello,python"

# 方法一
for i, j in enumerate(str1):	
    print(i+1, j)
# 方法二
num = 1
for i in str1:
    print(num, i)
    num += 1
```



### 字符串的切片,倒序

问题: 打印字符串的第3-5个字节

```python
shell里的方法:
# echo abcdefg  | cut -c3-5
cde

# echo abcdefg  | awk '{print substr($0,3,3)}'		# substr()是awk里的截取函数
cde

# echo abcdefg  | sed -r 's/(..)(...)(.*)/\2/'		# sed的分域操作
cde
```

```python
python里循环的方法(但不建议):
str1 = "abcdefg"

for index, i in enumerate(str1):
    if 5 > index > 1:
        print(i, end="")
```

上面的方法仅作拓宽思路用，python里实现字符串的截取操作首先就应该想到**==切片==**的方法。

**字符串，列表，元组都属于序列**，所以都可以**==切片==**(也就是我们shell里所说的**==截取==**)。

```python
a = "abcdefg"
print(a[0:3])		# 取第1个到第3个字符（注意，不包含第4个）
print(a[2:5])		# 取第3个到第5个字符（注意，不包含第6个）

print(a[0:-1])		# 取第1个到倒数第2个（注意:不包含最后一个)
print(a[1:])		# 取第2个到最后一个
print(a[:])			# 全取
print(a[0:5:2])		# 取第1个到第5个，但步长为2（结果为ace)
print(a[::-1])		# 字符串的倒序（类似shell里的rev命令)
```

扩展比较难理解的切片方法(仅作了解):

```python
str1 = "abcdefghijk"

print(str1[2:0:-1])
print(str1[:3:-1])
```



### 字符串的常见操作

```python
abc = "hello,nice to meet you"

print(len(abc))					# 调用len()函数来算长度						      (常用)
print(abc.__len__())			# 使用字符串的__len__()方法来算字符串的长度

print(abc.capitalize())			# 整个字符串的首字母大写
print(abc.title())			    # 每个单词的首字母大写
print(abc.upper())			    # 全大写
print(abc.lower())			    # 全小写
print("HAHAhehe".swapcase())	# 字符串里大小写互换

print(abc.center(50,"*"))		# 一共50个字符,字符串放中间，不够的两边补*
print(abc.ljust(50,"*"))		# 一共50个字符,字符串放左边，不够的右边补*	       （常用)
print(abc.rjust(50,"*"))		# 一共50个字符,字符串放右边，不够的左边补*

print(" haha\n".strip())		# 删除字符串左边和右边的空格或换行	(常用,处理文件的换行符很有用)
print(" haha\n".lstrip())		# 删除字符串左边的空格或换行
print(" haha\n".rstrip())		# 删除字符串右边的空格或换行

print(abc.endswith("you"))		# 判断字符串是否以you结尾	    类似于正则里的$		(常用)
print(abc.startswith("hello"))	# 判断字符串是否以hello开始	类似于正则里的^		(常用)

print(abc.count("e"))			# 统计字符串里e出现了多少次						   (常用)

print(abc.find("nice"))		# 找出nice在字符串的第1个下标，找不到会返回-1
print(abc.rfind("e"))		# 找出最后一个e字符在字符串的下标，找不到会返回-1
print(abc.index("nice"))	# 与find类似，区别是找不到会有异常（报错）
print(abc.rindex("e"))		# 与rfind类似，区别是找不到会有异常（报错）

print(abc.isalnum())		# 判断是否为数字字母混合(可以有大写字母，小写字母，数字任意混合)
print(abc.isalpha())		# 判断是否全为字母(分为纯大写，纯小写，大小写混合三种情况)
print(abc.isdigit())		# 判断是否为纯数字
print(abc.islower())		# 判断是否为纯小写字母
print(abc.isspace())		# 判断是否为全空格

print(abc.upper().isupper())	# 先把abc字符串全转为大写，再判断是否为全大写字母，结果为True
```

**小建议:** 字符串的方法非常多，新手第一次容易晕，但请不要一个一个去记忆，在我们的基础课程里主要会用到后面几个标为常用的方法，可以先记住这几个就好。其它的要用的话再查。



**示例:** 使用input输入字符，判断输入是数字，纯大写字母，纯小写字母，大小写混合字母，还是其它

```python
char = input("输入: ")

if char.isdigit():
    print("输入的是数字")
elif char.isalpha():
    if char.isupper():
        print("输入的是纯大写字母")
    elif char.islower():
        print("输入的是纯小写字母")
    else:
        print("输入是大小写混合字母")
else:
    print("输入的是其它")
```



### 字符串的其它操作(了解)

**数字,字符串,元组是==不可变数据类型==**（**改变值的话是在内存里开辟新的空间来存放新值，原内存地址里的值不变**）.下面的操作可以替换字符串的值，但原字符串没有改变。

**列表,字典,集合**是**==可变数据类型==**(**在内存地址不变的基础上可以改变值**)

```python
aaa = "hello world,itcast"
bbb = aaa.replace('l','L',2)	# 从左到右，把小写l替换成大写L，并且最多只替换2个
print(aaa)			# 原值不变
print(bbb)			# 改变的值赋值给了bbb变量，所以这里看到的是替换后的值
```

```python
print("root:x:0:0".split(":"))			# 以:为分隔号,分隔成列表
print("root:x\n:0:0".splitlines())		# 以\n为分隔号，分隔成列表
```

字符串的join操作

```python
print(" ".join(['df', '-h']))	# 把列表里的元素以前面引号里的分隔符合成字符串
```



**小结:** 

* 引号引起来的,input()函数输入的,str()转换的都为字符串类型
* 多个字符串可以做拼接和格式化输出
* 字符串属于**==序列==**,属于序列的数据类型都有**下标**，**可以循环遍历**，**可以切片**，**可以拼接**

* 字符串属于**==不可变数据类型==**,不可变数据类型没有增，删，改这种操作



## 列表-list(重点)

列表是一种基本的**==序列==**数据结构（字符串和元组也属于序列)

列表是一种**==可变数据类型==**（再次强调数字,字符串,元组是不可变类型）



### 列表的创建

使用**==中括号==**括起来，里面的数据称为**==元素==**。可以放同类型数据，也可以放不同类型数据，但通常是同类型。

```python
os_list = ["rhel", "centos", "suse", "ubuntu"]

print(os_list)
```



### 列表的下标

**和字符串一样**，见字符串的下标章节

**示例:**

```python
os_list = ["rhel", "centos", "suse", "ubuntu"]

for i, j in enumerate(os_list):
    print(i, j)
```





### 列表的切片,倒序

**和字符串一样**，见字符串的切片,倒序章节

示例:

```python
os_list = ["rhel", "centos", "suse", "ubuntu"]

print(os_list[1:3])
print(os_list[1:-1])		
print(os_list[::2])			# 打印第1个和第3个元素
print(os_list[::-1])		# 通过切片来倒序
```

**示例: 验证列表为可变数据类型**

```python
os_list = ["rhel", "centos", "suse", "ubuntu"]

print(id(os_list))
os_list.reverse()		# 通过reverse操作来倒序，并且是直接改变原数据
print(os_list)			# 列表的元素倒序了
print(id(os_list))		# 在倒序前后id()函数得到的值一样，说明内存地址不变，但值变了(可变数据类型)
```



### 列表的常见操作

```python
os_list = ["rhel", "centos", "suse"]
# 增
os_list.append("ubuntu")			# 在列表最后增加一个元素
print(os_list)
os_list.insert(2, "windowsxp")	# 插入到列表，变为第三个
print(os_list)
# 改
os_list[2] = "windows10"			# 修改第三个
print(os_list)
# 删
os_list.remove("windows10") 		# 删除操作，还可以使用del os_list[2]和os_list.pop[2];它们的区别del os_list是删除整个列表，os_list.pop()是默认删除列表最后一个元素；如果都用下标的话，则一样
print(os_list)
# 查
print(os_list[0])				# 通过下标就可以
```

```python
# 其它操作
print(os_list.count("centos"))	# 统计元素出现的次数
print(os_list.index("centos"))	# 找出centos在os列表里的位置
os_list.reverse()				# 反转列表
print(os_list)
os_list.sort()					# 排序列表，按ASCII编码来排序
print(os_list)
os_list.clear()					# 清除列表所有元素，成为空列表,不是删除列表
print(os_list)
```

**小建议: 重点记住列表的增,删,改,查这几种操作.**



### **列表合并,拼接**

```python
list1 = ["haha", "hehe", "heihei"]
list2 = ["xixi", "hoho"]

list1.extend(list2)    		# list1 += list2也可以，类似字符串拼接
print(list1)
```

**练习:** 下面是四个选修课报名的列表,请问张三报名了几门选修课?

```python
math = ["张三", "田七", "李四", "马六"]
english = ["李四", "王五", "田七", "陈八"]
art = ["陈八", "张三", "田七", "赵九"]
music = ["李四", "田七", "马六", "赵九"]

list1 = math + english + art + music			
print(list1.count("张三"))
```



### 双列表(拓展)

```python
name_list = ["zhangsan", "lisi", "wangwu", "maliu"]
salary = [18000, 16000, 20000, 15000]

for i in range(len(name_list)):
    print("{}的月收入为{}元".format(name_list[i].ljust(10," "),salary[i]))
    
for index, name in enumerate(name_list):
    print("{}的月薪为{}元".format(name,salary[index]))
```

```python
问题:找出工资最高的人叫啥?
print(name_list[salary.index(max(salary))])
```



### 列表嵌套(拓展)

**列表里可以嵌套列表，也可以嵌套其它数据类型**。

```python
emp = [["zhangsan", 18000], ["lisi", 16000], ["wangwu", 20000], ["maliu", 15000]]


for i in range(len(emp)):
    print("{}的月收入为{}元".format(emp[i][0].ljust(10," "),emp[i][1]))
    
for index, i in enumerate(emp):
    print("%s的月薪为%d元" % (i[0],i[1]))    
```

```python
问题:找出最高工资的人叫啥?
emp = [["zhangsan", 18000], ["lisi", 16000], ["wangwu", 20000], ["maliu", 15000]]

emp2 = []
for i in emp:
    emp2.append(i[1])

print(emp[emp2.index((max(emp2)))][0])
```





## 元组-tuple

元组就相当于是**==只读的列表==**;因为只读,所以没有append,remove,修改等操作方法.

它只有两个操作方法:count,index

元组,字符串,列表都属于序列.所以元组也可以切片,也可以使用for来遍历.

### 元组的创建与操作

列表使用中括号，元组使用小括号。

示例:

```python
tuple1 = (1, 2, 3, 4, 5, 1, 7)

print(type(tuple1))

print(tuple1.index(3))		# 打印3这个元素在元组里的下标	
print(tuple1.count(1))		# 统计1这个元素在元组里共出现几次
print(tuple1[2:5])			# 切片

tuple1[5] = 6					# 修改元组会报错
```

元组是只读的，不代表元组里任何数据不可变。如果元组里有列表，那么列表里是可变的。

```python
emp2 = (["zhangsan", 18000], ["lisi", 16000], ["wangwu", 20000], ["maliu", 15000])

emp2[0].append("haha")	# 元组里面的列表可以修改

print(emp2)
```



### 课后练习

**示例:使用getpass模块使用密码隐藏输入(拓展)**

隐藏输入密码(类似shell里的read -s )，但**在pycharm执行会有小bug,会卡住** (卡住后，用ps -ef |grep pycharm，然后kill -9 杀掉所有pycharm相关进程)；在bash下用python命令执行就没问题

```python
import getpass					# 这是一个用于隐藏密码输入的模块
			
username = input("username:")
password = getpass.getpass("password:")

if username == "daniel" and password == "123":
    print("login success")		
else:
    print("login failed")
```

bash下执行方法

```python
# /usr/local/bin/python3.6 /项目路径/xxx.py
```



**练习: 一个袋子里有3个红球，3个绿球，6个黄球，一次从袋子里取6个球，列出所有可能组合**

```python

```

**练习: 改写猜数字游戏，最多只能猜5次，5次到了没猜对就退出**

```python

```

**练习: 打印1-1000的质数（只能被1和自己整除的数)**

```python

```

**练习:(有难度，想挑战的可以尝试)**

 **使用input输入一个字符串，判断是否为强密码:  长度至少8位,包含大写字母,小写字母,数字和下划线这四类字符则为强密码**

```python
提示:因为没有学python的正则，你可以使用这样来判断  if 字符 in "abcdefghijklmnopqrstuvwxyz":

答:
```



**练习:（有难度，想挑战的可以尝试）:**

```python
tvlist = [
    "戏说西游记:讲述了西游路上的三角恋.",[
        "孙悟空:悟空爱上了白骨精......",
        "唐三藏:唐僧只想取经......",
        "白骨精:她爱上了唐僧......",
        ],
    "穿越三国:王二狗打怪升级修仙史",[
        "王二狗:开局一把刀,一条狗......",
        "吕布:看我方天画鸡......",
        "貂蝉:油腻的师姐,充值998就送!",
        ],
    "金瓶梅:你懂的",[
        "西门大官人:你懂的......",
        "潘金莲:你懂的......",
        "武大郎:你懂的......",
        "武松:你懂的......",
        ],
    "大明湖畔:我编不下去了......",[
        "夏雨荷:xxxxxx",
        "乾隆:xxxxxx",
        "容么么:xxxxxx",
    ],
]
```

请写python程序实现类似下面的结果:

![1541220544911](https://minioapi.nerubian.cn/image/20250208104506976.png)

```python
提示部分代码
import random							# 导入random模块(后面会具体讲模块)
    
tv_name_num = random.randrange(0,len(tvlist),2)   # len(tvlist)长度为8,这是0,2,4,6四个数的随机
tv_role_num = tv_name_num + 1
print("今日的通告: ")
print(tvlist[tv_name_num])
print("可接的角色有: ")
```



**练习:（有难度，想挑战的可以尝试）**

小购物车程序
1, 双十一来了，你的卡里有一定金额(自定义)
2, 买东西，会出现一个商品列表(商品名，价格)
3, 选择你要买的商品,卡里的钱够就扣钱成功，并加入到购物车;卡里钱不够则报余额不足
（或者做成把要买的商品都先加入到购物车，最后可以查看购物车，并可以删除购物车里的商品；确定后，一次性付款）
4, 买完后退出，会最后显示你一共买了哪些商品和显示你的余额

```python
提示部分代码:

money=20000

goods_list=[
    ["iphoneX",8000],
    ["laptop",5000],
    ["book",30],
    ["earphone",100],
    ["share_girlfriend",2000],
]

cart_list=[]
```


## 字典-dict(重点)

字典:是一种key:value(键值对)类型的数据，它是**==无序的==（没有像列表那样的索引,下标)**. (**备:**现在也有特殊方法实现的**有序字典**，有兴趣课后可以搜索了解一下)

它是通过key来找value,查找速度快;

如果key相等, 会**==自动去重==**(去掉重复值), 也就是说dict中**==没有重复的key==**。但是**==值是可以相等的==**。

**==字符串,列表,元组属于序列,所以有下标,可以切片. 字典和集合是无序的,没有下标,不能切片==**。

### 字典的创建

```python
dict1 = {
    'stu01': "zhangsan",
    'stu02': "lisi",
    'stu03': "wangwu",
    'stu04': "maliu",
}

print(type(dict1))
print(len(dict1))
print(dict1)
```

### 字典的常见操作

字典是**==可变数据类型==**，所以可以做增删改操作

```python
# 增
dict1["stu05"] = "tianqi"		# 类似修改,如果key值不存在,则就增加
print(dict1)

# 改
dict1["stu04"] = "马六"		   # 类似增加,如果key值存在,则就修改
print(dict1)
# 字典的增加与修改的写法是一样的，区别就在于key是否已经存在

# 查
print(dict1["stu01"])   	# 如果key值不存在,会返回keyerror错误
print(dict1.get("stu01"))  	# 这种取值方法如果key值不存在,会返回none,不会返回错误

# 删
dict1.pop("stu05")  		# 删除这条；也可以del dict1["stu05"]来删除
dict1.popitem()  			# 删除显示的最后一条
dict1.clear()  				# 清空字典
print(dict1)
# del dict1					# 删除整个字典
```



### 字典的循环遍历

前面的学习中我们知道可以使用for来遍历字符串,列表,元组.字典虽然不属于序列，但也可以使用for来遍历

```python
print(dict1.keys())   		# 打印所有的keys
print(dict1.values()) 		# 打印所有的values
print(dict1.items())  		# 字典转成列表套元组
# 上面这三种可以使用for来循环遍历

for key in dict1.keys():
    print(key)

for value in dict1.values():
    print(value)

for line in dict1.items():
    print(line)
```

**练习:**打印出所有value为2的key

```python
dict1 = {
    '张三': 2,
    '田七': 4,
    '李四': 3,
    '马六': 2,
    '王五': 1,
    '陈八': 2,
    '赵九': 2,
}
```

```python
答:
for i in dict1.items():
    if i[1] == 2:
        print(i[0])
```



**字典练习:**

```python
city = {
    "北京": {
        "东城": "景点",
        "朝阳": "娱乐",
        "海淀": "大学",
    },
    "深圳": {
        "罗湖": "老城区",
        "南山": "IT男聚集",
        "福田": "华强北",
    },
    "上海": {
        "黄埔": "xxxx",
        "徐汇": "xxxx",
        "静安": "xxxx",
    },
}
```

3. 打印北京东城区的说明（也就是打印出"景点")
4. 修改北京东城区的说明，改为"故宫在这"
5. 增加北京昌平区及其说明
6. 修改北京海淀区的说明，将"大学"改为"清华","北大","北邮"三个学校的列表
7. 在大学列表里再加一个"北影"
8. 循环打印出北京的区名,并在前面显示序号(以1开始)
9. 循环打印出北京海淀区的大学,并在前面显示序号(以1开始)

```python
print(city["北京"]["东城"])
city["北京"]["东城"]="故宫在这"
print(city["北京"]["东城"])
city["北京"]["昌平"]="我们在这"
print(city)
city["北京"]["海淀"]=["清华","北大","北邮"]
print(city["北京"]["海淀"])
city["北京"]["海淀"].append("北影")
print(city["北京"]["海淀"])

for index, i in enumerate(city["北京"].keys()):
    print(index+1, i)

for index, i in enumerate(city["北京"]["海淀"]):
    print(index+1, i)
```

**小结:**

字典是否属于序列?   不属于

字典能否切片? 	不能切

"我要打印字典的第2个到第5个键值对"，这种说法是否正确?   不对

字典是属于可变数据类型还是不可变数据类型?    可变

"字典里面可以嵌套字典，也可以嵌套列表或元组等其它数据类型"，这种说法是否正确? 





## 集合-set(了解)

- 集合和字典一样都是使用==大括号==。但集合没有value，相当于只有字典的key。
- 字符串,列表和元组属于序列，是有序的，但集合是**无序的**，所以不能通过下标来查询和修改元素。

再总结一下：

- **整数，字符串，元组**是==不可变==数据类型(整数和字符串改变值的话是在内存里开辟新的空间来存放新值，原内存地址里的值不变)
- **列表，字典，集合**是**==可变==**数据类型(在内存地址不变的基础上可以改变值)
- 还有一种**不可变集合**我们这里不做讨论

集合的特点:

10. 天生去重特性
11. 可以增，删（准确来说,**集合可以增加删除元素，但不能修改元素的值)**
12. 求交集，并集，补集很方便

### 集合的创建

```python
set1 = {1, 2, 3, 4, 5, 1, 2}
set2 = {2, 3, 6, 8, 8}

print(type(set1))
print(set1)
print(set2)				# 打印的结果，没有重复值
```

### 集合的增删
```python
# 集合的增加操作
set1.add(88)
print(set1)
set1.update([168, 998])                  # 添加多个
print(set1)

# 集合的删除操作
set1.remove(88)                         # 删除一个不存在的元素会报错
print(set1)
set1.discard(666)                       # 删除一个不存在的元素不会报错，存在则删除
print(set1)
```
### 交集、并集、补集、对称差集、子集

```python
set1 = {1, 4, 7, 5, 9, 6}
set2 = set([2, 4, 5, 9, 8])

# 交集
print(set1.intersection(set2))
print(set1 & set2)

print(set1.isdisjoint(set2))  			# 判断两个集合是否有交集,类型为bool(有交集为False,没交集为True)

# 并集
print(set1.union(set2))
print(set1 | set2)

# 差集(补集)
print(set1.difference(set2)) 			# set1里有,set2里没有
print(set1-set2)
print(set2.difference(set1)) 			# set2里有,set1里没有
print(set2-set1)

# 对称差集
print(set1.symmetric_difference(set2))  # 我有你没有的  加上 你有我没有的
print(set1^set2)

# 子集
set3=set([4, 5])
print(set3.issubset(set1))              # 判断set3是否为set1的子集
print(set1.issuperset(set3))            # 判断set1是否包含set3

```


# 十二、函数

使用函数的优点: **功能模块化,代码重用**(编写的代码可以重复调用)
**函数的功能要专一, 一个函数只完成一个功能。**
## 回顾下shell里的函数

```python
# service sshd start
# /etc/init.d/sshd start
在centos6里，上面两条命令里的start都是最终调用/etc/init.d/sshd服务脚本里的start()函数
```

```shell
function start() {							# 定义函数名start，前面可以加function也可以不加
	/usr/sbin/sshd
}

stop() {
	kill -15 `cat /var/run/sshd/sshd.pid`
}

reload() {
	kill -1 `cat /var/run/sshd/sshd.pid`
}

restart() {
    stop
    start									# 函数里调函数就是函数的嵌套	
}

case "$1" in
	start )
		start								# 调用start函数
		;;
	stop )
		stop
		;;
	restart )
		restart
		;;
	reload )
		reload
		;;
	* )
		echo "参数错误"
esac
```

## python里的函数

python里函数分为**内置函数**与**自定义函数**

**内置函数**: 如int(), str(), len(), range(), id(), max(), print()等,所有的内置函数参考

| 首字母 | 内置函数                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A   | [`abs()`](https://docs.python.org/3/library/functions.html#abs)[`aiter()`](https://docs.python.org/3/library/functions.html#aiter)[`all()`](https://docs.python.org/3/library/functions.html#all)[`anext()`](https://docs.python.org/3/library/functions.html#anext)[`any()`](https://docs.python.org/3/library/functions.html#any)[`ascii()`](https://docs.python.org/3/library/functions.html#ascii)                                                                                                                                                                     |
| B   | [`bin()`](https://docs.python.org/3/library/functions.html#bin)[`bool()`](https://docs.python.org/3/library/functions.html#bool)[`breakpoint()`](https://docs.python.org/3/library/functions.html#breakpoint)[`bytearray()`](https://docs.python.org/3/library/functions.html#func-bytearray)[`bytes()`](https://docs.python.org/3/library/functions.html#func-bytes)                                                                                                                                                                                                      |
| C   | [`callable()`](https://docs.python.org/3/library/functions.html#callable)[`chr()`](https://docs.python.org/3/library/functions.html#chr)[`classmethod()`](https://docs.python.org/3/library/functions.html#classmethod)[`compile()`](https://docs.python.org/3/library/functions.html#compile)[`complex()`](https://docs.python.org/3/library/functions.html#complex)                                                                                                                                                                                                      |
| D   | [`delattr()`](https://docs.python.org/3/library/functions.html#delattr)[`dict()`](https://docs.python.org/3/library/functions.html#func-dict)[`dir()`](https://docs.python.org/3/library/functions.html#dir)[`divmod()`](https://docs.python.org/3/library/functions.html#divmod)                                                                                                                                                                                                                                                                                          |
| E   | [`enumerate()`](https://docs.python.org/3/library/functions.html#enumerate)[`eval()`](https://docs.python.org/3/library/functions.html#eval)[`exec()`](https://docs.python.org/3/library/functions.html#exec)                                                                                                                                                                                                                                                                                                                                                              |
| F   | [`filter()`](https://docs.python.org/3/library/functions.html#filter)[`float()`](https://docs.python.org/3/library/functions.html#float)[`format()`](https://docs.python.org/3/library/functions.html#format)[`frozenset()`](https://docs.python.org/3/library/functions.html#func-frozenset)                                                                                                                                                                                                                                                                              |
| G   | [`getattr()`](https://docs.python.org/3/library/functions.html#getattr)[`globals()`](https://docs.python.org/3/library/functions.html#globals)                                                                                                                                                                                                                                                                                                                                                                                                                             |
| H   | [`hasattr()`](https://docs.python.org/3/library/functions.html#hasattr)[`hash()`](https://docs.python.org/3/library/functions.html#hash)[`help()`](https://docs.python.org/3/library/functions.html#help)[`hex()`](https://docs.python.org/3/library/functions.html#hex)                                                                                                                                                                                                                                                                                                   |
| I   | [`id()`](https://docs.python.org/3/library/functions.html#id)[`input()`](https://docs.python.org/3/library/functions.html#input)[`int()`](https://docs.python.org/3/library/functions.html#int)[`isinstance()`](https://docs.python.org/3/library/functions.html#isinstance)[`issubclass()`](https://docs.python.org/3/library/functions.html#issubclass)[`iter()`](https://docs.python.org/3/library/functions.html#iter)                                                                                                                                                 |
| L   | [`len()`](https://docs.python.org/3/library/functions.html#len)[`list()`](https://docs.python.org/3/library/functions.html#func-list)[`locals()`](https://docs.python.org/3/library/functions.html#locals)                                                                                                                                                                                                                                                                                                                                                                 |
| M   | [`map()`](https://docs.python.org/3/library/functions.html#map)[`max()`](https://docs.python.org/3/library/functions.html#max)[`memoryview()`](https://docs.python.org/3/library/functions.html#func-memoryview)[`min()`](https://docs.python.org/3/library/functions.html#min)                                                                                                                                                                                                                                                                                            |
| N   | [`next()`](https://docs.python.org/3/library/functions.html#next)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| O   | [`object()`](https://docs.python.org/3/library/functions.html#object)[`oct()`](https://docs.python.org/3/library/functions.html#oct)[`open()`](https://docs.python.org/3/library/functions.html#open)[`ord()`](https://docs.python.org/3/library/functions.html#ord)                                                                                                                                                                                                                                                                                                       |
| P   | [`pow()`](https://docs.python.org/3/library/functions.html#pow)[`print()`](https://docs.python.org/3/library/functions.html#print)[`property()`](https://docs.python.org/3/library/functions.html#property)                                                                                                                                                                                                                                                                                                                                                                |
| R   | [`range()`](https://docs.python.org/3/library/functions.html#func-range)[`repr()`](https://docs.python.org/3/library/functions.html#repr)[`reversed()`](https://docs.python.org/3/library/functions.html#reversed)[`round()`](https://docs.python.org/3/library/functions.html#round)                                                                                                                                                                                                                                                                                      |
| S   | [`set()`](https://docs.python.org/3/library/functions.html#func-set)[`setattr()`](https://docs.python.org/3/library/functions.html#setattr)[`slice()`](https://docs.python.org/3/library/functions.html#slice)[`sorted()`](https://docs.python.org/3/library/functions.html#sorted)[`staticmethod()`](https://docs.python.org/3/library/functions.html#staticmethod)[`str()`](https://docs.python.org/3/library/functions.html#func-str)[`sum()`](https://docs.python.org/3/library/functions.html#sum)[`super()`](https://docs.python.org/3/library/functions.html#super) |
| T   | [`tuple()`](https://docs.python.org/3/library/functions.html#func-tuple)[`type()`](https://docs.python.org/3/library/functions.html#type)                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| V   | [`vars()`](https://docs.python.org/3/library/functions.html#vars)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Z   | [`zip()`](https://docs.python.org/3/library/functions.html#zip)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| _   | [`__import__()`](https://docs.python.org/3/library/functions.html#import__)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |

### **自定义函数的定义与调用(重点)**

Python 使用 `def` 开始函数定义，紧接着是函数名，括号内部为函数的参数，内部为函数的 具体功能实现代码，如果想要函数有返回值, 在 `expressions` 中的逻辑代码中用 `return` 返回

```python
def funct1():				  # 函数名(),括号里可以写参数，也可以不写
    """函数说明或注释"""		 # 说明可以不写，大型程序为了程序可读性最好写
    print("进水")				# 函数代码主体
    print("洗衣服")		   # 函数代码主体
    print("脱水")				# 函数代码主体
    return 0				  # 函数返回值,可有可无

funct1()				 	# 调用函数的方式(调用函数也就是执行函数内部的代码)
```


### 函数传参数(重点)
#### 参数设计最佳实践

1. 参数顺序原则：必填参数 → 可选参数 → `*args` → 关键字参数 →`**kwargs`
2. 类型提示增强
   ```python
   def calculate(
       values: list[float],  # 明确要求输入为浮点数列表,防止非数值类型数据混入
       precision: int = 2    # 类型标注int确保参数为整数，默认值2简化调用（calculate([1.2, 3.4])等价于calculate([1.2, 3.4], 2)）
   ) -> float: ...  # 返回值类型标注,明确输出类型
   ```
3. 防御性编程：对关键参数进行有效性校验
4. 文档规范：使用`docstring`说明参数用途和类型
5. 工具链整合：结合`mypy` + `Pylint` + `IDE`实现全流程类型安全

#### 形参,实参,位置参数,关键字参数

```python
def test(a, b):		# a,b是形参(形式上的参数,就是占位置用的)
    print(a + b)

test(1, 2)			# 1,2在这里是实参(实际的参数),实参也可以传变量,个数要与形参个数对应,也会按顺序来传参（位置参数);
# test(1)			# 执行的话会报错,位置参数要与形参一一对应,个数不能少
# test(1, 2, 3)		# 执行的话会报错,位置参数要与形参一一对应,个数也不能多
test(b=4, a=3)		# 这里是关键字调用,那么就与顺序无关了(关键字参数)

# test(5, b=6)		# 混用的话，就比较怪了，结果可以自行测试一下(结论:位置参数必须写在关键字参数的前面)
```

#### 默认参数

```python
def connect_mysql(host, user, password, port=3306):	# port=3306为默认参数
    pass		            # pass就类似一个占位符，保证函数完整，没有语法错误

host = input("input host:")
user = input("input user:")
password = input("password")

connect_mysql(host, user, password)	# 不传port的值,默认是3306;也可以传一个新的值替代3306
```

#### 动态位置参数`（*args）`

```python
def funct1(*args):		# 参数名前面加*(变量名可以自定义)就可以定义为可变长参数
    for i in args:
        print(i, end=" ")
    print()

    
funct1(1, 2, 3, 4, 5, 6, 7, 8)
```


#### 动态关键字参数`（**kwargs）`

```python
def test(**kwargs):			# **两个后面加变量(变量名可以自定义)，这样后面传多个值(需要传关键字参数)，并且结果为字典
    print(kwargs)

test(name="zhangsan", age=18, gender="M")
```

合并使用
```python
def people(name, *args, age=18, **kwargs):
    print(name)
    print(args)
    print(age)
    print(kwargs)

people("zhangsan", "man", 25, salary=20000, department="IT")
people("zhangsan", "man", 180, age=25, salary=20000, department="IT")
people("zhangsan", "man", 180, 25, salary=20000, department="IT")
```

使用字典解包动态传参
```python
config = {"host": "db.example.com"}
if debug_mode:
    config["port"] = 5432
connect(**config)
```

### 函数返回值(重点)

>理解函数返回值的作用: **==把函数的执行结果返回给需要调用的地方==**。
>函数return返回的是一个==值==，所以要赋值给一个变量,然后通过调用变量得到返回值。
>函数返回值写在函数体的最后，因为函数返回值意味着函数的结束。

**示例:**

```python
def test(a, b):
    c = a + b
    return c
	print("haha")	# 返回值后面的代码不执行,也就是说函数执行到return就结束了

test(1, 2)		# 再回顾一下，这是函数的调用，执行函数体内的代码，但这样得不到函数返回值

d = test(1, 2)
print(d)			# 这样终于得到函数的返回值了

print(test(1,2))	# 不赋值给变量，直接打印也是可以得到函数的返回值
```

### 函数的变量作用域: 全局变量，局部变量

**示例:**

```python
name = "zhangsan"   	# 全局变量

def change_name():
    name = "lisi"	# 这个变量只能在函数内生效，也就是局部变量(可以说这个函数就是这个变量的作用域)
    gender = "male"

    
change_name()		
print(name)			# 结果为zhangsan
print(gender)		# 这句会报错，因为它是局部变量，在外面调用不了
```

**示例:**

```python
name = "zhangsan"   	# 全局变量

def change_name():
    global name,gender     # 这句可以把name改为全局变量，但不建议这样用，如果多次调用函数，这样很容易混乱，容易与外部的变量冲突
    name = "lisi"
    gender = "male"
    print(name)

    
change_name()		# 这句结果为lisi，调用函数内部的print(name)得到的结果
print(name)			# 这句结果为lisi
print(gender)		# 可以调用gender变量了，能打印出结果
```


### 递归函数(拓展)

函数可以调用其它函数，也可以调用自己；如果**一个函数自己调用自己，就是递归函数**,但递归也有次数上限（保护机制），所以递归需要有一个结束条件

在计算机中，函数调用是通过栈（stack）这种数据结构实现的，每当进入一个函数调用，栈就会加一层栈帧，每当函数返回，栈就会减一层栈帧。由于栈的大小不是无限的，所以，递归调用的次数过多，会导致栈溢出

**示例: 下面代码就可以看到最高可以递归近1000次**

```python
def plus_one(n):
    print(n)
    return plus_one(n+1)


plus_one(0)
```

**示例:**

```python
def abc(n):
    print(n)
    if n//2 > 0:
        return abc(n//2)

    
abc(100)
```

### 匿名函数(拓展)

python 使用 lambda 来创建匿名函数。

所谓匿名，意即不再使用 def 语句这样标准的形式定义一个函数。
- lambda 只是一个表达式，函数体比 def 简单很多。
- lambda的主体是一个表达式，而不是一个代码块。仅仅能在lambda表达式中封装有限的逻辑进去。
- lambda 函数拥有自己的命名空间，且不能访问自有参数列表之外或全局命名空间里的参数。

**示例: 比较下面的两段**

```python
# 自定义函数
def caclulate(a, b):
	print(a + b)

    
caclulate(2, 5)

# 匿名函数
caclulate = lambda a,b:a+b

print(caclulate(2, 5))
```


### 列表推导式(拓展)

匿名函数常用于写有行为的列表或字典,按照要求执行相应的动作

**示例:把一个列表的值x2**

```python
# 方法一:
list1=[1,2,3,4,5]

list2=[]
for i in list1:
    i*=2
    list2.append(i)

print(list2)

# 方法二:
list1=[1,2,3,4,5]

for i,j in enumerate(list1):
    j=j*2
    list1[i]=j

print(list1)

# 方法三:列表推导式
list1=[i*2 for i in range(1,6)]
print(list1)

list2=list(map(lambda i:i+1,list1))
print(list2)
```



### 高阶函数(拓展)

高阶函数特点:

* 把函数名当做实参传给另外一个函数(变量可以传参，函数就是变量，所以函数也可以传参)
* 返回值中包含函数名

**示例：普通的函数，里面会用到abs这种内置函数来做运算**

```python
def higher_funct1(a,b):
        print(abs(a)+abs(b))

higher_funct1(-3,-5)
```

**示例: 高阶函数，像abs(),len(),sum()这些函数都当做了实参传给了另外一个函数**

```python
def higher_funct1(a,b,c):
        print(c(a)+c(b))

higher_funct1(-3,-5,abs)
higher_funct1("hello","world",len)
higher_funct1([1,2,3],[4,5,6],sum)

def higher_funct1(a,b,c):
		return c(a)+c(b)

print(higher_funct1(-3,-5,abs))
print(higher_funct1("hello","world",len))
print(higher_funct1([1,2,3],[4,5,6],sum))
```



### 装饰器(拓展)

装饰器(语法糖) 用于装饰其他函数（相当于是为其他函数提供附加功能)

不能去修改被装饰的函数的源代码和调用方式（如果业务已经线上运行，现在想新加一个功能，改源代码就会产生影响）

**示例:**

假设我的程序假设有三个复杂函数逻辑

```python
import time

def complex_funct1():
    time.sleep(2)
    print("哈哈，我不复杂!")

def complex_funct2():
    time.sleep(3)
    print("哈哈，我也不复杂!")

def complex_funct3():
    time.sleep(4)
    print("哈哈，我还是不复杂!")

complex_funct1()
complex_funct2()
complex_funct3()
```

假设我现在想加一个计算复杂函数时间的功能，下面的做法太麻烦，一个个的加，并且还修改了原函数的代码

```python
import time

def complex_funct1():
    start_time=time.time()
    time.sleep(2)
    print("哈哈，我不复杂!")
    end_time=time.time()
    print("此函数一共费时{}".format(end_time-start_time))

def complex_funct2():
    start_time=time.time()
    time.sleep(3)
    print("哈哈，我也不复杂!")
    end_time=time.time()
    print("此函数一共费时{}".format(end_time-start_time))

def complex_funct3():
    start_time = time.time()
    time.sleep(4)
    print("哈哈，我还是不复杂!")
    end_time=time.time()
    print("此函数一共费时{}".format(end_time-start_time))

complex_funct1()
complex_funct2()
complex_funct3()
```

我这里把计算时间的功能定义成一个函数，把被计算的复杂函数当做参数传进来进行计算（高阶函数），但后面的函数调用方式却需要改变

```python
import time

def timer(funct):
    start_time=time.time()
    funct()				# 这里funct后面不接()也可以，但下面的调用里就要写，比如timer(complex_funct1())
    end_time=time.time()
    print("此函数一共费时{}".format(end_time - start_time))

def complex_funct1():
    time.sleep(2)
    print("哈哈，我不复杂!")

def complex_funct2():
    time.sleep(3)
    print("哈哈，我也不复杂!")

def complex_funct3():
    time.sleep(4)
    print("哈哈，我还是不复杂!")
timer(complex_funct1)
timer(complex_funct2)
timer(complex_funct3)			# 这里改变了原有的调用方式
```

高阶函数+嵌套函数=装饰器，实现不修改原函数代码，也不改变原函数调用方式，就可以加上新功能

```python
def timer(funct):			# 把下面的多个复杂函数当做参数传给这个timer计时函数（高阶函数）
    def timer_proc():			# 函数里调函数（嵌套函数）
        start_time=time.time()
        funct()				# 执行调用的复杂函数(如complex_funct1()等)，函数的过程会消耗一定的时间
        end_time=time.time()
        print("此函数一共费时{}".format(end_time - start_time))	# 算出时间，也就是我们最终需要的结果，但写在里面这样并不能打印出来，需要在外函数作为返回值
    return timer_proc			# 把嵌套内部函数的值在外面作为返回值，这样就可以被显示

@timer							# 相当于timer(complex_funct1)
def complex_funct1():
    time.sleep(2)
    print("哈哈，我不复杂!")

@timer							# 相当于timer(complex_funct2)
def complex_funct2():
    time.sleep(3)
    print("哈哈，我也不复杂!")

@timer							# 相当于timer(complex_funct3)
def complex_funct3():
    time.sleep(4)
    print("哈哈，我还是不复杂!")


complex_funct1()
complex_funct2()
complex_funct3()			# 没有改变最原始的函数调用方式就能实现需求
```



# 十三、模块

## 模块的定义,分类,存放路径

**==模块就是一个.py结尾的python代码文件==**（文件名为hello.py,则模块名为hello), 用于实现一个或多个功能（变量，函数，类等）

模块分为

- **标准库**（python自带的模块，可以直接调用）
- **开源模块**（第三方模块,需要先pip安装,再调用）
- **自定义模块**（自己定义的模块）

模块主要存放在/usr/local/lib/python3.6/目录下,还有其它目录下。使用sys.path查看。

```python
# python3.6
>>> import sys
>>> print(sys.path)		# 模块路径列表,第一个值为空代码当前目录
['', '/usr/local/lib/python36.zip', '/usr/local/lib/python3.6', '/usr/local/lib/python3.6/lib-dynload', '/root/.local/lib/python3.6/site-packages', '/usr/local/lib/python3.6/site-packages']
# sys.path和linux上的$PATH很类似，如果两个目录里分别有同名模块，则按顺序来调用目录靠前的。
# sys.path的结果是一个列表，所以你可以使用sys.path.append()或sys.path.insert()增加新的模块目录。
```

## 模块的基本导入语法

- import导入方法相当于是直接解释模块文件

import导入**单模块**

```python
import hello
```

import导入**多模块**

```python
import module1,module2,module3

import module1
import module2
import module3
```

from导入模块里所有的变量，函数

```python
from hello import *
```

from导入模块文件里的部分函数

```python
from hello import funct1,funct2
```

**import语法导入与from语法导入的区别**：

import导入方法相当于是直接解释模块文件

像from这样的语法导入，相当于是把hello.py里的文件直接复制过来，调用hello.py里的funct1()的话，就不需要hello.funct1()了，而是直接funct1()调用了，如果你本地代码里也有funct1()，就会冲突，后面的会overwrite前面的

```python
# 代码一:
import hello
hello.funct1()			# 前面要接模块名

# 代码二:
from hello import *
funct1()				# 前面不用模块名了

# 代码三:
import hello
def funct1():
    print("local funct1")	
    
hello.funct1()			# 调用模块里的funct1
funct1()				# 调用本地的funct1

# 代码四:
from hello import *
def funct1():
    print("local funct1")
    
#hello.funct1()			# hello模块里的funct1与本地的funct1冲突了
funct1()				# 得到的是本地的funct1结果
```

为了区分本地funct1和导入的hello模块里的funct1，可以导入时做别名

```python
from hello import funct1 as funct1_hello
```

**示例: 利用别名来解决模块与本地函数冲突的问题**

```python
from hello import funct1 as funct1_hello

def funct1():
   print("local funct1")

funct1_hello()		# 用别名来调用hello模块里的funct1
funct1()			# 本地的funct1
```

**问题**: 比较了半天，import又方便也没使用问题，为什么还要有from这种导入方式呢? 因为是: **为了优化**

```python
import hello
hello.funct1()    # 如果本文件有大量的地方需要这样调用，那么也就是说需要大量重复找hello模块里的funct1函数

from hello import funct1
funct1()      	  # 如果本文件有大量的地方需要这样调用，这样就不用大量重复查找hello模块了，因为上面的导入就相当于把funct1的函数代码定义到本文件了;而且这样导入方式可以选择性的导入部分函数。
```



## 包(拓展)

#### 一、包的核心概念
包是通过目录结构组织多个模块的代码管理方式，其核心特征是包含`__init__.py`文件。该文件的作用包括：
- 标识目录为Python包
- 执行包初始化代码（如全局变量声明、子模块导入）
- 控制包的导入行为（通过`__all__`变量）

---

#### 二、创建Python包的完整流程

##### 1. 基础目录结构
```bash
my_package/             # 主目录（建议全小写+下划线命名）
├── __init__.py         # 包标识文件
├── utils.py            # 工具模块
├── data_processing/    # 子包目录
│   ├── __init__.py
│   └── cleaner.py
└── tests/              # 测试目录（非必须）
```

##### 2. `__init__.py`编写规范
- **空文件**：仅作为包标识时保留空文件
- **显式导入**（推荐）：
  ```python
  # 预加载常用模块
  from .utils import *
  from .data_processing.cleaner import DataCleaner  # 
  __all__ = ['DataCleaner']  # 控制from package import *的行为
  ```

##### 3. 模块开发示例
```python
# utils.py
def format_name(user: str) -> str:
    """标准化用户名"""
    return user.strip().title()

# data_processing/cleaner.py
class DataCleaner:
    def remove_duplicates(self, data: list) -> list:
        return list(set(data))
```

---

#### 三、包的使用方法

##### 1. 基础导入方式
```python
# 导入整个包（执行__init__.py）
import my_package  # 

# 导入子模块
from my_package import utils
print(utils.format_name(" john "))  # 输出"John"

# 导入特定类/函数
from my_package.data_processing.cleaner import DataCleaner  # 
cleaner = DataCleaner()
```

##### 2. 高级导入技巧
- **别名简化**：
  ```python
  import my_package.data_processing.cleaner as cl
  cl.DataCleaner()
  ```
- **动态导入**：
  ```python
  module = __import__('my_package.utils')
  print(module.format_name("alice"))
  ```

##### 3. 包路径管理
当包不在默认搜索路径时：
```python
import sys
sys.path.append("/path/to/parent_dir")  # 
import my_package
```

---

#### 四、进阶功能实现

##### 1. 子包管理
通过嵌套目录创建层级结构：
```bash
my_package/
└── ml/
    ├── __init__.py
    ├── preprocessing.py
    └── models/
        ├── __init__.py
        └── neural_net.py
```
导入方式：
```python
from my_package.ml.models.neural_net import DeepModel  # 
```

##### 2. 包发布流程（PyPI）
1. 编写`setup.py`：
   ```python
   from setuptools import setup, find_packages
   setup(
       name="my_package",
       version="0.1.2",
       packages=find_packages(),
       install_requires=["numpy>=1.21"]  # 
   )
   ```
2. 构建与上传：
   ```bash
   python -m build
   twine upload dist/*  # 
   ```



# 十四、代码混淆

### **1. 代码转换（Code Transformation）**
**原理**：通过重写代码结构、重命名标识符、插入冗余代码等方式，使代码逻辑难以阅读，但功能保持不变。

#### **常用方法**：
- **变量/函数/类名混淆**：将有意义的名称替换为随机字符（如 `a`, `b`, `x0`）。
- **删除注释和空格**：减少代码可读性。
- **代码扁平化**：将嵌套逻辑转换为线性结构。
- **插入无效代码**：添加不影响功能的冗余代码。

#### **常用工具**：
- **PyArmor**：支持重命名标识符、插入冗余代码、加密字符串等。
- **Oxyry Python Obfuscator**：在线工具，自动混淆变量名和删除注释。
- **pyminifier**：可压缩代码并重命名变量。

```python
# 原始代码
def calculate_sum(a, b):
    return a + b

# 混淆后
def x0(y1, z2):
    return y1 + z2
```

---

### **2. 控制流混淆（Control Flow Obfuscation）**
**原理**：修改代码的执行流程（如添加无意义的条件分支、循环），使反编译后的逻辑难以理解。

#### **常用方法**：
- **虚假分支**：插入永远为真/假的条件语句。
- **循环展开**：将循环转换为重复的线性代码。
- **逻辑拆分**：将简单逻辑拆分为多个步骤。

#### **常用工具**：
- **Pyobfuscate**：支持控制流混淆和变量名替换。
- **PyArmor**：提供控制流混淆功能。

```python
# 混淆前
if x > 0:
    print("Positive")

# 混淆后（插入虚假分支）
if x > 0 or (lambda: False)():
    print("Positive")
```

---

### **3. 字符串加密（String Encryption）**
**原理**：对代码中的字符串进行加密，运行时动态解密，防止直接搜索关键字符串。

#### **常用方法**：
- **Base64 编码**：简单但可逆。
- **XOR 加密**：轻量级加密。
- **AES 加密**：高强度加密（需结合运行时解密逻辑）。

#### **常用工具**：
- **PyArmor**：内置字符串加密功能。
- **自定义脚本**：手动实现加密逻辑。

```python
# 原始代码
password = "secret123"

# 混淆后（Base64加密）
import base64
password = base64.b64decode("c2VjcmV0MTIz").decode()
```

---

### **4. 代码打包与二进制化**
**原理**：将Python代码编译为二进制文件（如 `.exe`、`.so`），隐藏原始代码。

#### **常用方法**：
- **打包为可执行文件**：生成独立二进制文件。
- **编译为字节码（`.pyc`）**：直接运行 `.pyc` 文件（但可被反编译）。
- **Cython 编译**：将Python代码转换为C扩展模块（`.so`/`.pyd`）。

#### **常用工具**：
- **PyInstaller**：打包为独立的可执行文件。
- **Nuitka**：将Python代码编译为C二进制。
- **Cython**：生成C扩展模块，保护核心逻辑。

```python
# 使用PyInstaller打包
pyinstaller --onefile script.py
```

---

### **5. 字节码混淆（Bytecode Obfuscation）**
**原理**：直接修改Python字节码（`.pyc` 文件），干扰反编译工具。

#### **常用工具**：
- **PyArmor**：通过修改字节码增加逆向难度。
- **自定义字节码工具**：手动操作（需深入理解Python字节码）。

---

### **6. 反调试与反逆向（Anti-Debugging）**
**原理**：检测调试环境或反编译工具，阻止逆向分析。

#### **常用方法**：
- **检查运行环境**：检测是否在虚拟机或调试器中运行。
- **代码自检**：检查自身代码是否被修改。

#### **实现示例**：
```python
import sys

# 检测是否在PyCharm调试模式下
if "pydevd" in sys.modules:
    sys.exit("Debugging is not allowed!")
```

---

### **常用工具总结**
| **混淆类型**       | **常用工具**                | **特点**                         |
| ------------------ | --------------------------- | -------------------------------- |
| 代码转换           | PyArmor, pyminifier, Oxyry  | 简单易用，适合轻度保护           |
| 控制流混淆         | PyArmor, Pyobfuscate        | 增加逻辑复杂性，但可能影响性能   |
| 字符串加密         | PyArmor, 自定义脚本         | 防止字符串泄露，需结合运行时解密 |
| 代码打包与二进制化 | PyInstaller, Nuitka, Cython | 隐藏源码，但仍有被反编译的风险   |
| 字节码混淆         | PyArmor                     | 直接操作字节码，保护力度较高     |
| 反调试             | 自定义代码                  | 增加逆向成本，但可能被绕过       |

| **工具**          | **支持的混淆方式**            | **适用场景**        |
| --------------- | ---------------------- | --------------- |
| **PyArmor**     | 代码转换、控制流混淆、字符串加密、字节码混淆 | 中高强度保护，支持多种混淆组合 |
| **Oxyry**       | 变量名混淆、删除注释和空格          | 轻度保护，在线工具       |
| **Pyobfuscate** | 变量名混淆、控制流混淆            | 轻度到中度保护         |
| **Cython**      | 代码二进制化                 | 保护核心算法          |
| **PyInstaller** | 打包为可执行文件               | 分发独立应用          |
| **Nuitka**      | 代码二进制化                 | 高性能和高安全性需求      |


