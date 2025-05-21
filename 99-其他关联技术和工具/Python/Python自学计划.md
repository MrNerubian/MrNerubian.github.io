# Python自学计划

### 1、编程环境准备



## 编译器安装：

下载地址：www.python.org

- 下载长期支持版即可

安装

- 勾选：Add Python 3.xx to PATH
- 勾选：Install launcher for all users

### 配置环境变量



## Pycharm

下载地址：https://www.jetbrains.com/pycharm/download


报错：
- SyntaxError: xxx  语法错误



# 基础知识

## 变量

- 相当于一个容器，是计算机内存中的存储空间，用于保存数据

- 变量被赋值后才会被创建
- 变量首次使用时，会在内存中划分存储空间，存储初始化值，对同一个变量再次赋值，则不会再次划分空间，而是修改原空间的值

```python
格式：变量名 = 值	
PS:=赋值运算符，空格是为了美观

num = 3
print(num)
```

#### 变量的命名规范

##### 见名知意

变量一定要易懂，看到立刻就知道含义

##### 下划线分割命名法

当用多个单词组合作为变量名，要使用下划线作为分隔，例如 first_name = ‘li’

##### 大驼峰命名法

每个单词的首字母都大写，其余字母小写

##### 小驼峰命名法

第二及以后的单词，首字母都大写，其余字母小写

## 标识符

- 只能由数字、字母、下划线 (_)组成
- python3版本支持中文作为变量，但是不推荐使用
- 不能以数字开头
- 不能是关键字（被系统已经使用的）
- 严格区分大小写
- 标识符被括号包含不影响使用
- 
标识符就程序员定义的变量名和函数名、模块名
  ```python
  False      await      else       import     pass
  None       break      except     in         raise
  True       class      finally    is         return
  and        continue   for        lambda     try
  as         def        from       nonlocal   while
  assert     del        global     not        with
  async      elif       if         or         yield
  ```


## 占位符

#### %

- 生成一定格式的字符串

- 占位符只是占据位置，并不会输出

| 占位符 | 作用             |
| --- | -------------- |
| %%  | 占位输出           |
| %s  | 字符串            |
| %d  | 整数             |
| %c  | 字符及ASCII码      |
| %u  | 无符号整型          |
| %o  | 无符号8进制数        |
| %x  | 无符号16进制数       |
| %X  | 无符号16进制数（大写）   |
| %f  | 浮点数，可指定小数点后的精度 |
| %e  | 用科学计数法格式化浮点数   |
| %E  | 作用同%e          |
| %g  | %f 和 %e的简写     |
| %G  | %F 和 %E的简写     |
| %p  | 用16进制数格式化变量的地址 |

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



## 运算符

### 算数运算符

算数运算符的优先级：幂（最高优先级）> 乘、除、取余、取整和 > 加、减

| 运算符 | 功能说明 | 示例                                                         |
| ------ | -------- | ------------------------------------------------------------ |
| +      | 加       | 10+20=30                                                     |
| -      | 减       | 10-20=-10                                                    |
| *      | 乘       | 10*20=200                                                    |
| /      | 除       | 10/20=0.5                                                    |
| //     | 取整数   | 返回除法的商的整数部分：9//2=4，忽略小数部分，不进行四舍五入 |
| %      | 取余数   | 返回除法的余数，又称取模：9%2=1                              |
| **     | 幂       | 又称次方、乘方：2**3=8                                       |

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



### 赋值运算符

- 赋值运算符中间不能有空格
- 变量必须被提前定义，否则会报错
- 纯数字不能使用赋值运算符，纯数字不能作为变量

| 运算符 | 功能说明   | 示例                            |
| ------ | ---------- | ------------------------------- |
| =      | 简单的赋值 | `c=a+b`：将a+b的结果赋值给变量c |
| +=     | 加法赋值   | `c+=a` 等效于`c=c+a`            |
| -=     | 减法赋值   | `c-=a` 等效于`c=c-a`            |
| *=     | 乘法赋值   | `c*=a` 等效于`c=c*a`            |
| /=     | 除法赋值   | `c/=a` 等效于`c=c/a`            |
| //=    | 取整赋值   | `c//=a` 等效于`c=c//a`          |
| %=     | 取模赋值   | `c%=a` 等效于`c=c%a`            |
| **=    | 幂赋值     | `c**=a` 等效于`c=c**a`          |

```python
num1 = 5
num2 = 8
num3 = num1
num4 = num2

total = num1 + num2
num3 += 1
print(num3)
```

### 比较运算符



| 运算符 | 功能说明                                          |
| ------ | ------------------------------------------------- |
| ==     | 等等于，判断是否相等，相等为True，不等于为False   |
| !=     | 不等于，判断是否不相等，不等于为True，否则为False |
| <      | 小于                                              |
| >      | 大于                                              |
| <=     | 小于等于                                          |
| >=     | 大于等于                                          |



### 逻辑运算符

| 运算符 | 功能说明                                        |
| ------ | ----------------------------------------------- |
| and    | 与，左右两边都符合为True，否则为False           |
| or     | 或，左右两边任意一边符合为True，都不符合为False |
| not    | 非，表示相反的结果                              |


## 转义字符

### 制表符：`\t`

```python
print('12345\t6789')
输出：12345	6789
```

### 换行符：`\n`

```python
print('第一行\n第二行')
输出：
第一行
第二行
```

### 回车符：`\r`

将当前位置移到本行开头

```python
print('12345\r6789')
输出：6789
```

### 反斜杠转义符：`\\`

```python
print('12345\\6789')
输出：12345\6789
```

r原生字符串，取消默认转义

```python
pring(r"123\\\456")
输出：123\\\456
```



## 输入:`input()`

```
input(prompt) #prompt表示提示，会在控制台中显示
name = input("请输入姓名")
print(name)
print(type(name))
```

- input输入的字符类型默认为字符串
- 

## 输出:`print()`

```
print(name)
print("xiaoming")
```



# 3、数据类型

### 判断数据的数据类型

```
a = 1
print(type(a))
```


### 数值类型（Number）

1. 整数型：int

   1. 任意大小的整数

      ```python
      num1 = 1
      num1 = -1
      ```

      

2. 浮点型：float

   1. 小数

      ```python
      num2 = 1.5
      ```

      

3. 布尔型：bool

   1. 固定写法，必须严格区分大小写：

      1. True：真
      2. False：假

      ```python
      错误写法：print(type(true))
      ```

   2. 布尔值可以当作整数对待，True相当于1，False相当于0：

      ```python
      print(True+False) # 结果为1
      ```

      

4. 复数型：complex

   1. 固定写法

      1. z = a + bj  #a是实部，b是虚部，j是虚数单位（虚数单位只能是j，不能更改）

         ```python
         print(type(2+3j))
         ma1 = 1 + 2j
         ma2 = 2 + 3j
         print(ma1+ma2)
         输出：(3+5j)
         ```

         



### 字符串str

特点：被引号包含起来的都是字符串类型，单引号、双引号、三引号（多行内容）都可以

PS：没有引号是变量，三引号代表注释时是单独存在的

```python
name = '小明'
name = "小明"
name = '''小
明'''
```



# 判断

## if

### if单分支判断语句:

```python
if 条件:					# 条件结束要加:号(不是;号)
	条件成立执行动作一		# 这里一定要缩进（tab键或四个空格)，否则报错
    					    # 没有fi结束符了，就是看缩进
```

### if双分支判断语句:

```python
if 条件:
	条件成立执行动作一			
else:					# else后面也要加:
	执行动作二
```

### if多分支判断语句:

```python
if 条件一:
	条件成立执行动作一
elif 条件二:			  # elif 条件后面都要记得加:
	条件成立执行动作二
elif 条件三:
	条件成立执行动作三
else:
	执行动作四
```
### if嵌套

**if嵌套**也就是if里还有if，你可以无限嵌套下去，但层次不宜过多（嵌套层次过多的话程序逻辑很难读，也说明你的程序思路不太好，应该有很好的流程思路来实现）

比如下面的格式:

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

```python
year = int(input("输入一个年份:"))

if year % 4 == 0:
    if year % 100 != 0:
#    and year % 100 != 0:
        print("{}是闰年".format(year))
    if year % 400 == 0:
        print("{}是闰年".format(year))
else:
    print("{}是平年".format(year))
```


# 循环

## while循环

**只要满足while指定的条件，就循环**。

### while 循环的基本格式

```python
while 条件:
      条件满足时候:执行动作一
	  条件满足时候:执行动作二
      ......
```

**注意:** 没有像shell里的do..done来界定**循环体**，所以要看缩进。



**示例: 打印1-10**

 ```python
i = 1
while i < 11:
    print(i, end=" ")
    i += 1
 ```

**示例:打印1-100的奇数**

```python
i = 1
while i < 101:
    if i % 2 == 1:
        print(i, end=" ")
    i += 1
```



### 循环控制语句

```python
continue		跳出本次循环，直接执行下一次循环    
break			退出循环，执行循环外的代码　
exit()			退出python程序，可以指定返回值
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
        break
        
print("领奖")
```

**练习: 用while循环实现1-100中的所有偶数之和**

```python
i = 2
sum = 0

# 方法一
while i <= 100:
    sum += i
    i += 2
print(sum)

# 方法二
while i <= 100:
    if i % 2 == 0:
        sum += i
    i += 1
print(sum)

# 方法三(了解)
while i <= 100:
    if i % 2 == 1:
        i += 1
        continue
    else:
        sum += i
        i += 1
print(sum)
```



## for循环

**for循环遍历一个对象（比如数据序列，字符串，列表，元组等）,根据遍历的个数来确定循环次数。**

for循环可以看作为**定循环**，while循环可以看作为**不定循环**。 

如:  

6点-18点，每个小时整点循环（定了次数，每天都会有6点-18点） 

当有太阳，每个小时整点循环（不定次数，天气和季节都会影响是否有太阳）

### for循环的基本格式

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



**练习**: **用for循环来实现1-100之间能被5整除,同时为奇数的和**

```python
sum = 0
for i in range(1, 101):
    if i % 5 == 0 and i % 2 == 1:
        sum += i
print(sum)
```



## 循环嵌套


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



是的，有一些专用的Python代码混淆工具支持多种混淆方式的自由选择和组合。以下是几款功能强大且灵活的Python代码混淆工具，它们允许用户根据需求选择不同的混淆方式，并支持多种混淆技术的组合使用。

---

### **1. PyArmor**
**特点**：
- 支持多种混淆方式，包括代码转换、控制流混淆、字符串加密、字节码混淆等。
- 提供命令行工具和API，方便集成到构建流程中。
- 支持跨平台（Windows、macOS、Linux）。
- 提供反调试和反逆向功能。

**支持的混淆方式**：
- 变量/函数/类名混淆
- 控制流混淆
- 字符串加密
- 字节码混淆
- 打包为独立可执行文件
- 反调试和反逆向

**使用示例**：
```bash
# 安装PyArmor
pip install pyarmor

# 混淆脚本
pyarmor obfuscate script.py

# 组合多种混淆方式
pyarmor obfuscate --advanced 2 --restrict 1 script.py
```

**官网**：[PyArmor](https://pyarmor.readthedocs.io/)

---

### **2. Oxyry Python Obfuscator**
**特点**：
- 在线工具，简单易用。
- 支持变量名混淆、删除注释和空格。
- 适合轻度保护需求。

**支持的混淆方式**：
- 变量/函数/类名混淆
- 删除注释和空格

**使用示例**：
1. 访问 [Oxyry Python Obfuscator](https://pyob.oxyry.com/)。
2. 粘贴代码并点击“Obfuscate”按钮。

---

### **3. Pyobfuscate**
**特点**：
- 开源工具，支持变量名混淆和控制流混淆。
- 适合轻度到中度保护需求。

**支持的混淆方式**：
- 变量/函数/类名混淆
- 控制流混淆

**使用示例**：
```bash
# 克隆项目
git clone https://github.com/astrand/pyobfuscate.git

# 运行混淆工具
python pyobfuscate.py script.py > obfuscated_script.py
```

---

### **4. Cython**
**特点**：
- 将Python代码编译为C扩展模块（`.so`/`.pyd`），隐藏源码。
- 适合保护核心算法。

**支持的混淆方式**：
- 代码二进制化

**使用示例**：
1. 安装Cython：
   ```bash
   pip install cython
   ```
2. 编写 `setup.py`：
   ```python
   from setuptools import setup
   from Cython.Build import cythonize
   
   setup(ext_modules=cythonize("script.py"))
   ```
3. 编译代码：
   ```bash
   python setup.py build_ext --inplace
   ```

---

### **5. PyInstaller + PyArmor**
**特点**：
- 结合PyInstaller打包和PyArmor混淆，提供更强的保护。
- 适合需要分发独立可执行文件的场景。

**使用示例**：
1. 使用PyArmor混淆代码：
   ```bash
   pyarmor obfuscate script.py
   ```
2. 使用PyInstaller打包混淆后的代码：
   ```bash
   pyinstaller --onefile obfuscated_script.py
   ```

---

### **6. Nuitka**
**特点**：
- 将Python代码编译为C二进制文件，提供高性能和高安全性。
- 支持跨平台。

**支持的混淆方式**：
- 代码二进制化

**使用示例**：
```bash
# 安装Nuitka
pip install nuitka

# 编译代码
nuitka --standalone --onefile script.py
```

---

### **7. 自定义混淆工具**
如果需要更灵活的混淆策略，可以结合多种工具或编写自定义脚本。例如：
- 使用 `pyminifier` 压缩代码。
- 使用 `base64` 或 `XOR` 加密字符串。
- 使用 `ast` 模块解析和修改代码结构。

**示例**：
```python
import base64

# 加密字符串
def encrypt_string(s):
    return base64.b64encode(s.encode()).decode()

# 解密字符串
def decrypt_string(s):
    return base64.b64decode(s.encode()).decode()

# 使用加密字符串
password = decrypt_string("c2VjcmV0MTIz")
```

---

### **总结**
| **工具**        | **支持的混淆方式**                           | **适用场景**                   |
| --------------- | -------------------------------------------- | ------------------------------ |
| **PyArmor**     | 代码转换、控制流混淆、字符串加密、字节码混淆 | 中高强度保护，支持多种混淆组合 |
| **Oxyry**       | 变量名混淆、删除注释和空格                   | 轻度保护，在线工具             |
| **Pyobfuscate** | 变量名混淆、控制流混淆                       | 轻度到中度保护                 |
| **Cython**      | 代码二进制化                                 | 保护核心算法                   |
| **PyInstaller** | 打包为可执行文件                             | 分发独立应用                   |
| **Nuitka**      | 代码二进制化                                 | 高性能和高安全性需求           |

如果需要自由选择和组合混淆方式，**PyArmor** 是最推荐的工具，它功能全面且灵活，适合大多数场景。对于特定需求（如核心算法保护），可以结合 **Cython** 或 **Nuitka** 使用。
