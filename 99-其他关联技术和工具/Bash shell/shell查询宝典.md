# shell判断语句

# 一、变量

## 1.变量的赋值与调用

``` shell
基本规则
1，赋值符号为：=
2，调取变量时，变量前加:$
3，变量是命令时需要用执行符$()或``
```

``` shell
示例1：
name="123" ;echo $name 
123
```

``` shell
示例2：
name=$(date +%F) ;echo $name
2019-04-16
```

```shell
示例3：
read -p "输入你的性别(man/woman):" sex
```

注意事项

``` shell
1，变量名和等号之间不能有空格
2，首个字符必须为字母（区分大小写）
3，中间不能有空格，不能用标点符号，只可以用下划线
4，不可使用bash中的系统变量
5，同名变量多次赋值，后面会覆盖前面的值
6，需要将变量与其他字符区分边界时，可使用{}或""
```

## 变量的数组用法

```bash
#!/bin/bash
processes=("nginx" "rabbitmq")

# 获取第一个参数
first_param="${processes[0]}"
# 获取第二个参数
second_param="${processes[1]}"

echo "第一个参数：$first_param"
echo "第二个参数：$second_param"
```

## 2.删除变量

``` shell
命令：unset
语法：unset 变量

栗子：
赋值：name=10
删除：unset name

注意事项：
1，unset不能删除只读变量
```

3.变量替换

变量替换可以根据变量的状态（是否为空、是否定义等）来改变它的值

| 写法            | 说明                                                         |
| --------------- | ------------------------------------------------------------ |
| ${var}          | 变量本来的值                                                 |
| ${var:-word}    | 如果变量  var  为空或已被删除(unset) ，那么返回 word ，但不改变 var  的值。 |
| ${var:=word}    | 如果变量  var  为空或已被删除(unset) ，那么返回  word ，并将var  的值设置为  word 。 |
| ${var:+word}    | 如果变量  var  被定义，那么返回  word ，但不改变  var  的值  |
| ${var:?message} | 如果变量  var  为空或已被删除(unset) ，那么将消息  message  送到标准错误输出，可以用来检测变量  var  是否可以被正常赋值。               若此替换出现在Shell 脚本中，那么脚本将停止运行。 |



## 4.特殊变量

| 特殊变量 | 含义                                                |
| ---- | ------------------------------------------------- |
| $?   | 上个命令的退出状态，或函数的返回值                                 |
| $0   | 当前脚本的文件名                                          |
| $n   | 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。 |
| $#   | 传递给脚本或函数的参数个数。                                    |
| $*   | 传递给脚本或函数的所有参数。                                    |
| $@   | 传递给脚本或函数的所有参数。被双引号(" ")包含时，与 $* 稍有不同，下面将会讲到。      |
| $$   | 当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。            |

## 5.echo转义字符

（使用换行、制表符号的方法）

``` shell
echo选项
-e 使用转义字符
-E 禁止转义字符，默认就是不转义
```

| 转义字符 | 含义                             |
| -------- | -------------------------------- |
| \\\      | 反斜杠                           |
| \a       | 警报，响铃                       |
| \b       | 退格（删除键）                   |
| \f       | 换页(FF)，将当前位置移到下页开头 |
| \n       | 换行                             |
| \r       | 回车                             |
| \t       | 水平制表符（tab键）              |
| \v       | 垂直制表符                       |

# 二、运算符

## 1.算术运算

| 四则运算符 | 说明   |
| ---------- | ------ |
| +          | 加     |
| -          | 减     |
| *          | 乘     |
| /          | 除     |
| %          | 取余数 |
| **         | 幂     |

## 2.算术运算的格式

``` shell
1. 使用$[ ]   (建议主用这种就可以了，其它可以看懂即可)
2. 使用 $(( ))   
3. 使用expr外部程式
4. 使用let命令
5. 借助bc命令

栗子
#!/bin/bash
a=1
let a++                     使用let执行运算,后面变量前不用加$
b=$[$a-1]
c=$(($a**3))
d=`expr $a + 3`             + 号两边要有空格

借助bc命令实现小数运算
# echo 1.1+2.2 | bc
3.3

# echo "sqrt(100)" | bc				
10							 求平方根

算术操作高级运算bc命令它可以执行浮点运算和一些高级函数：
[root@node1 ~]# area=`echo "scale=2;r=3;3.1415*r*r"|bc`

[root@xuexi ~]# echo $area
28.2735

echo "1.212*3" | bc 
3.636
设定小数精度（数值范围）

echo "scale=2;3/8" | bc
0.37
参数scale=2是将bc输出结果的小数位设置为2位。
```



# 三、判断符号

## 3.1、判断语句格式

- 格式1： ==**test**==  条件表达式
- 格式2： **[** 条件表达式 ]
- 格式3： **[[** 条件表达式 ]]  支持正则 =~
- **==F==**: false 假  **==T==**: true 真

```shell
格式示范

test -e /etc/fstab				判断文件是否存在
[ -d /etc ]		 				判断目录是否存在，存在条件为真   （中括号里面左边两边有空格)
[ ! -d /etc ]					判断目录是否存在,不存在条件为真  （中括号里面左边两边有空格)
[[ -f /etc/fstab ]]				判断文件是否存在，并且是普通文件 （中括号里面左边两边有空格)

# aaa=aaa123
# [[ $aaa =~ ^aaa ]]
# echo $?
0								返回值为0表示上面判断的aaa变量是以aaa开头
```

**说明: man test去查看，很多的参数都用来进行条件判断**

## 3.2、判断命令选项

### 1.文件类型的判断

| 判断参数                 | 说明                    |
| -------------------- | --------------------- |
| -e （常用)  exist       | 判断文件(任何类型文件)是否存在（ 为真） |
| -f    (常用)  file     | 判断是否为普通文件             |
| -d   (常用)  directory | 判断是否为目录               |
| -S                   | 判断是否为socket文件         |
| -p                   | 判断是否为pipe管道文件         |
| -c                   | 判断是否为character字符设备文件  |
| -b                   | 判断是否为block块设备         |
| -L        link       | 判断是否为软链接              |
| -s                   | 判断文件是否存在并且为非空文件       |

### 2.文件权限相关的判断

| 判断参数 | 说明                                  |
| -------- | ------------------------------------- |
| -r       | 当前用户对其是否可读                  |
| -w       | 当前用户对其是否可写                  |
| -x       | 当前用户对其是否可执行                |
| -u       | 是否有suid(权限9位的前3位里是否有s位) |
| -g       | 是否sgid(权限9位的中间3位里是否有s位) |
| -k       | 是否有t位(权限9位的后3位里是否有t位)  |

### 3.两个文件的比较判断

| 判断表达式       | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| file1 -nt  file2 | 比较file1是否比file2新                                       |
| file1 -ot  file2 | 比较file1是否比file2旧                                       |
| file1 -ef  file2 | 比较是否为同一个文件，或者用于判断硬连接，是否指向同一个inode |

### 4.整数之间的判断

| 判断参数 | 说明   |
| ---- | ---- |
| -eq  | 相等   |
| -ne  | 不等   |
| -gt  | 大于   |
| -lt  | 小于   |
| -ge  | 大于等于 |
| -le  | 小于等于 |

### 5.字符串之间的判断

| 判断参数或表达式           | 说明                  |
| ------------------ | ------------------- |
| -z                 | 是否为空字符串,字符串长度为0则为真  |
| -n                 | 是否为非空字符串,只要字符串非空则为真 |
| string1 = string2  | 两个字符串是否相等           |
| string1 != string2 | 两个字符串是否不等           |

### 6.多重条件判断

| 判断参数                                        |                                      |
| ----------------------------------------------- | ------------------------------------ |
| 条件1 -a 条件2   (and)       条件1 && 条件2     | 两个条件同时满足，整个大条件为真     |
| 条件1 -o 条件2    (or)         条件1 \|\| 条件2 | 两个条件满足任意一个，整个大条件为真 |

示例:

```shell
[ 1 -eq 1 -a 1 -ne 0 ]				整个表达式为真
[ 1 -eq 1 ] && [ 1 -ne 0 ]	
```

```shell
[ 1 -eq 1 -o 1 -ne 1 ]				整个表达式为真
[ 1 -eq 1 ] || [ 1 -ne 1 ]
```



### 7.使用&&与||符号实现判断语句

| 符号 | 说明                               |
| ---- | ---------------------------------- |
| ;    | 不管前面执行是否正确，都会执行后面 |
| &&   | 前面执行正确，才会执行后面         |
| \|\| | 前面执行失败，才会执行后面         |

```shell
条件 && 动作			 # 前面条件满足则执行动作
条件 || 动作        	 # 前面条件失败则执行动作
条件 && 动作1 || 动作2    # 如果条件满足，则执行动作1，否则则执行动作2
```

**示例:** 

```shell
# [ -e /etc/fstab ] && echo "文件存在" || echo "文件不存在"
文件存在
# [ -e /etc/sdfdsfdsa ] && echo "文件存在" || echo "文件不存在"
文件不存在
```

# 四、流程控制

## 循环控制语句（参数）

| 参数       | 说明                              |
| -------- | ------------------------------- |
| continue | 跳过；表示==循环体==内下面的代码不执行，重新开始下一次循环 |
| break    | 打断；马上停止循环，执行==循环体==后面的代码        |
| exit     | 结束；表示直接结束程序，以下全部不执行             |
| set -x   | 显示脚本执行的全部详细过程                   |

## 4.1、if

### 1.单分支结构

```shell
实现：满足条件1，执行命令1

写法1：
if [ 条件1 ];then
	命令1
fi

写法2：
[ 条件1 ] && 命令1
```

### 2.双分支结构

```shell
实现：满足条件1，执行命令1，不满足执行命令2

写法1：
if [ 条件1 ];then
	命令1
else
	命令2
fi

写法2：
[ 条件 ] && 命令1 || 命令2
```

### 3.多分支结构

```shell
实现：如果条件1满足，执行命令1后结束；
     如果条件1不满足，再看条件2，如果条件2满足执行命令2后结束；
	 如果条件1和条件2都不满足执行命令3结束.

写法：
if [ 条件1 ];then
	命令1
elif [ 条件2 ];then					# 可以有多个elif
	命令2  
else
	命令3
fi
```

实例：

```shell
#!/bin/bash

read -p "输入你的性别(man/woman):" sex

if [ $sex = man ];then
        echo "帅哥"
elif [ $sex = woman ];then
        echo "美女"
elif [ $sex = boy ];then
        echo "小帅哥"
elif [ $sex = girl ];then
        echo "小美女"
else
        echo "性别输入有误"
fi
```



### 4. if嵌套

上面的三种分支结构可以互相嵌套,嵌套后的逻辑会比较复杂，实际写程序不宜嵌套过多(如果嵌套过多则说明你的逻辑不太好)


```shell
if [ 条件1 ];then
		命令1		
	if [ 条件2 ];then
		命令2
	fi
else
	if [ 条件3 ];then
		命令3
	elif [ 条件4 ];then
		命令4
	else
		命令5
	fi
fi

如果条件1满足，执行命令1；如果条件2也满足执行命令2，如果不满足就只执行命令1结束；
如果条件1不满足，不看条件2；直接看条件3，如果条件3满足执行命令3；如果不满足则看条件4，如果条件4满足执行命令4；否则执行命令5
```

## 4.2、for

### 1.循环语法结构

- 特点**: 多用于已知次数的循环(**定循环)

- 循环体： ==do....done==之间的内容

``` shell
循环语法结构，可循环字母或数字
for num in 1 2 3 4 5    字母写法：for sex in a b c d e
do
	echo $num
done

可使用通配符写作
for num in {1..5}		字母写法：for sex in {a..e}

类c风格写法
for(( expr1;expr2;expr3 ))				# 类C风格的for循环
do
	command
done

expr1：定义变量并赋初值
expr2：决定是否进行循环（条件），留空表示一直满足条件（死循环）
expr3：决定循环变量如何改变，决定循环什么时候退出
```


### 3.循环文件

``` shell
可用命令：
find cat head tail ...

举个栗子：
1，列出目录中文件名单
for file in /etc/*  
do
	echo $file
done
2，列出目录中所有文件名单
for file in $(find /etc)
do
	echo $file
done
```

### 4.其他写法示例

``` shell
# for i in `seq 10`;do echo $i;done
# for i in $(seq 10);do echo $i;done
# for i in `seq 10 -2 1`;do echo $i;done

# for i in {1..10};do echo $i;done
# for i in {0..10..2};do echo $i;done			# 大括号中第3个数字2为一步的长度
# for i in {10..1};do echo $i;done
# for i in {10..1..-2};do echo $i;done

# for ((i=1;i<=5;i++));do echo $i;done
# for ((i=1;i<=10;i+=2));do echo $i;done
# for ((i=10;i>=1;i-=2));do echo $i;done

# for i in {a..z}; do echo $i; done
```



## 4.3、while

### 1.循环语法结构

- 特点：条件为真就进入循环；条件为假就退出循环.多用于不定次数的循环

``` shell
用for循环与while循环做比较打印1-5
1,while写法
while [ $i -le 5 ]			
do
	echo $i
	let i++
done
----------------------------------------
2，for写法
for ((i=1;i<=5;i++))			
do
	echo $i
done
----------------------------------------
3，类C写法
while ((i=1;i<=5;i++))
do
	echo $i
done
----------------------------------------
4，引用变量写法
for i in $(seq $IP1 $IP2)
do
	echo $i
done
```

### 2.死循环

``` shell
while true			条件永远为true,所以会一直循环下去
do
	command
done
```

``` shell
其它的死循环写法，会上面一种即可
while :
do
	command
done
----------------------------------------
for (( ;1; ))
do
	command
done
----------------------------------------
for ((i=1;;i++))
do
	command
done
```

## 4.4、until循环(了解)

- 特点：直到满足条件就退出循环

``` shell
1，until实现
a=1
until [ $a -gt 5 ]	
do					
        echo $a		
        let a++		
done
----------------------------------
2,for实现
a=1
until [ $a -gt 5 ]	
do					
        echo $a		
        let a++		
done
```

## 4.5、随机数

bash默认有一个$RANDOM的变量, 默认范围是0~32767.

使用`set |grep RANDOM`查看上一次产生的随机数

```shell
# echo $RANDOM
19862
# set |grep RANDOM
RANDOM=19862
```

### **除法与余数**

```shell
7除以3，商为2,余数为1
6除以2，商为3,余数为0

可通过除以2，判断余数是否为1来判断是否为奇数(单数)，如1,3,5,7,9
可通过除以2，判断余数是否为0来判断是否为偶数(双数)，如2,4,6,8,10
```

**示例:**

```shell
#!/bin/bash

read -p "输入一个数字:" num

if [ $[$num%2] -eq 1 ];then			# if双分支判断$num除以2的余数是否为1来确认是奇数还是偶数
	echo "$num是奇数"
else
	echo "$num是偶数"
fi
```

### 产生自定义范围的随机数

产生0~1之间的随机数

```shell
# echo $[$RANDOM%2]				  # 除以2，余数只可能是0或1
```

产生0~2之间的随机数

```shell
# echo $[$RANDOM%3]				  # 除以3，余数只可能是0或1或2
```

产生1-2之内的随机数

```shell
# echo $[$RANDOM%2+1]			  # 除以2，余数只可能是0或1，但都加1后，就只可能是1或2
```

产生50-100之内的随机数

```shell
# echo $[$RANDOM%51+50]			  # 除以51，余数只可能是0到50，但都加50后，就只可能是50到100
```

产生三位数的随机数

```shell
# echo $[$RANDOM%900+100]		  # 除以900,余数只可能是0到899,但都加100后，就只可能是100到999
```



**示例:** **写一个猜数字的小游戏**

```shell
#!/bin/bash

echo "猜一个1-100的整数,猜对砸蛋:" 		# 通过echo输出游戏规则

num=$[$RANDOM%100+1]		# 产生1-100的随机数,赋值给num变量(余数为0-99，加1后余数为1-100)

while true								# 死循环，条件true表示永远为真
do										# 循环体开始
	read -p "请猜:" gnum				   # 交互模式让用户猜一个数字,将此数字赋值给gnum变量
    if [ $gnum -gt $num ];then			# 多分支判断开始
		echo "大了"					   # 如果猜的数字大于随机数则报大了
	elif [ $gnum -lt $num ];then	
		echo "小了"					   # 如果猜的数字小于随机数则报小了
	else	
		echo "对了"					   # 如果猜的数字不大也不小，那么肯定就对了
		break							# 猜对了就不要继续猜了,跳出循环
	fi									# 多分支判断结束
done									# 循环体结束(do与done之间的代码会循环)

echo "砸蛋"							  # 猜对了，跳出循环后则执行循环体外的代码
```



## 4.6、嵌套循环

一个==循环体==内又包含另一个**完整**的循环结构，称为循环的嵌套。

在外部循环的每次执行过程中都会触发内部循环，直至内部完成一次循环，才接着执行下一次的外部循环。

for循环、while循环和until循环可以**相互**嵌套。

如: 我们一天中上午，下午，晚上都在学习，然后连续学习三天

|       | 上午 | 下午 | 晚上 |
| ----- | ---- | ---- | ---- |
| 第1天 | 学习 | 学习 | 学习 |
| 第2天 | 学习 | 学习 | 学习 |
| 第3天 | 学习 | 学习 | 学习 |



**示例:**

```shell
for i in {a..c}						# 外层循环a,b,c三个字母
do									# 外循环体开始
        for j in {1..3}				# 内存循环1,2,3三个字母
        do							# 内循环体开始
                echo $i$j			# 一共循环3*3=9次，分别打印a1,a2,a3,b1,b2,b3,c1,c2,c3
        done						# 内循环体结束
done								# 外循环体结束
```

### 示例

```shell
先回顾echo命令:
echo默认打印会换行
echo -n打印不换行
echo -e会让\n为换行号,\t为制表符(tab键)

# echo -e "你\n好\t吗"
你
好      吗
```

**示例:** 打印出如下结果

```shell
*
**
***
****
*****
******

分析: 
1,一共5行，所以可以外部循环5次
2,每行不换行打印与行数相等次数的*号(第1行循环1次，第2行循环2次......第5行循环5次)
  内部循环次数与行数一致
3,每行打印完*号会换行
```

```shell
#!/bin/bash

for i in $(seq 5)					# 外循环1-5，代表5行
do
        for j in $(seq $i)	# 内循环，每行循环次数和行数保持一致(第1行循环1次，第2行循环2次...)
        do
                echo -n "*"		# 内循环每次不换行打印*
        done					
        echo		# 每次打完一行的*号后使用echo换行(比如第3行，循环打完3个*号后换行)
done
```

**示例:**打印出如下结果

```shell
1
12
123
1234
12345
```

```shell
#!/bin/bash

for i in $(seq 5)
do
       	for j in $(seq $i)
        do
                echo -n $j
        done
        echo
done
```



### 练习

1, 建立a1, a2, a3, a4, a5, b1, b2, b3, b4, b5。。。。。。。以此类推,一直到e1,e2, e3, e4, e5一共25个用户, 每个用户密码为随机三位数字(100-999), 并将用户名与密码保存到/root/.passwd文件中

```shell

```



## 4.7、case语句

case语句为多选择语句(**==其实就是类似if多分支结构==**), 主要用于centos6的服务脚本里用于判断服务是start还是stop还是status等。 

**说明:** **python里没有case语句,python里用if多分支来实现**. 但case语句也需要看懂结构, 不仅是shell里用，在数据库的SQL语句里也有case语句。

### **case语法结构**

```shell
case var in            			# 定义变量;var代表是变量名
	pattern 1)              	# 模式1;用 | 分割多个模式，相当于or
    		command1            # 需要执行的语句
    		;;                  # 两个分号代表命令结束
	pattern 2)
   			command2
    		;;
	pattern 3)
    		command3
    		;;
	*)              			# 不满足以上模式，默认执行*)下面的语句
    		command4			# 这里可以不加;;符号
esac							# esac表示case语句结束
```

### **case与if多分支对比**

```shell
case $sex in								if [ $sex = 男 -o $sex = man ];then
	男|man )										echo "帅哥"
		echo "帅哥"						   elif [ $sex = 女 -o $sex = woman];then
		;;										 echo "美女"
	女|woman )								else 
		echo "美女"								echo "性别有误"
		;;									 fi
	* )
		echo "性别有误"
esac
```

# 五、函数

通俗地说，将**一组命令集合**或**语句**形成一个整体, 给这段代码起个名字称为函数名。可以通过函数名来调用函数内的代码，达到代码重复利用的目的。

### 函数的定义

```shell
函数名() {
  函数体（一堆命令的集合，来实现某个功能）   
}

function 函数名() {
   函数体（一堆命令的集合，来实现某个功能）  
}
```

```shell
function_name() {
		代码
		代码
}

function function_name() {
		代码
		代码
}

建议用第一种,不用写function，简单方便
```

### 函数的调用

**直接用函数名来调用函数**

```shell
funct1() {				# 函数名加()来定义函数，小括号是固定写法，大括号里面为函数体
    echo 1
    echo 2
    echo 3				# 大括号里的三条命令就是函数主体
}

funct1					# 直接使用函数名字调用函数，将会执行函数主体内的内容
```

### **函数的嵌套**

**函数里可以调函数**

```shell
funct1() {				
    echo 1
    echo 2
    echo 3
}

funct2() {
    funct1				# funct2里调用funct1,相当于是把funct1函数主体内的内容放到这个位置
    echo 4
    echo 5
}

funct2				    # 调用funct2
```

等同于下面的代码

```shell
funct2() {
    echo 1
    echo 2
    echo 3
    echo 4
    echo 5
}

funct2
```

![1555389899476](shell查询宝典.assets/函数的嵌套.png)



## **九、case与函数综合实例**

**要求:**

无视系统上已有的/etc/init.d/sshd服务脚本，自己写一个服务脚本/etc/init.d/new_sshd,也能实现ssh服务的start,stop,restart,reload等功能.

### **知识准备与回顾**

* 服务脚本写在哪里?

```shell
需要放在/etc/init.d/目录下，并给执行权限，才能被service命令调用
```

* 服务怎么启动?

```shell
大家初期太依赖于service xxx restart这样的命令
服务启动三要素:
1.启动命令 (如sshd服务的启动命令就是/usr/sbin/sshd;vsftpd服务的启动命令就是/usr/sbin/vsftpd)
2,启动用户 (没特定指定一般就是root用户)
3,启动参数 (有些服务没有启动参数,如/usr/sbin/sshd直接可启动;有些服务有启动参数,如mysqld_safe --defaults-file=/usr/local/mysql/etc/my.cnf &)
```

* 服务怎么关闭?

```shell
找到pid，然后kill -15 pid关闭即可
如kill -15 $(cat /var/run/sshd.pid)
```

* 服务怎么reload刷新

```shell
找到pid，然后kill -1 pid即可
如kill -1 $(cat /var/run/sshd.pid)
```

* 服务怎么支持chkconfig开机自启动

```shell
两个条件:
1, 服务脚本里要有以下这句

# chkconfig: 2345 55 25
第1个数字2345代表2345级别
第2个数字55代表启动的顺序编号(不能超过99)
第3个数字25代表关闭的顺序编号(不能超过99)

2, chkconfig --add 服务名
```



### 脚本实例

```shell
[root@server ~]# vim /etc/init.d/new_sshd		# 要创建到/etc/init.d/目录下

#!/bin/bash

# chkconfig: 2345 64 36

start() {										# start函数
	/usr/sbin/sshd								# 调用/usr/sbin/sshd命令启动sshd服务
}
stop () {										# stop函数
	kill -15 $(cat /var/run/sshd.pid)			# 通过pid文件查找pid，然后kill -15停进程
}
reload() {										# reload函数
	kill -1 $(cat /var/run/sshd.pid)			# 通过pid文件查找pid,然后kill -1刷新
}
status() {										# status函数
	if [ -e /var/run/sshd.pid ];then		# 通过判断pid文件是否存在，从而得知服务是否启动
		echo "sshd正在运行"
	else
		echo "sshd是停止状态"
	fi
}

case "$1" in			# $1变量回顾(shell第1天有讲)，指执行脚本接的第一个参数
	start )				# 如果$1的值为start，则调用start函数主体内的代码
		start
		;;
	stop  )
		stop
		;;
	restart )			# 如果$1的值为restart
		stop			# 先调用stop函数，再调用start函数来实现restart
		start
		;;
	reload )
		reload
		;;
	status )
		status
		;;
	* )		   # 如果$1的值不为start,stop,restart,reload,status其中之一，则执行下面的echo语句
		echo "只支持(start|stop|restart|reload|status)"
esac
```

给执行权限，并加入chkconfig管理

```shell
# chmod 755 /etc/init.d/new_sshd					# 给执行权限
# chkconfig --add /etc/init.d/new_sshd				# 加入chkconfig管理
```

测试

```shell
先停止系统自带的sshd服务
# /etc/init.d/sshd stop								# 把系统自带的sshd服务停止
# chkconfig sshd off								# 把系统自带的sshd服务做成开机不自启

再测试自己写的new_sshd服务脚本
# /etc/init.d/new_sshd start						# start就是对应$1
# chkconfig new_sshd on								# 做成开机自动启动
```



# 六、 正则表达式

### 正则表达式介绍

**正则表达式**（Regular Expression、regex或regexp，缩写为RE），也译为正规表示法、常规表示法，是一种字符模式，用于在查找过程中匹配指定的字符。

几乎所有开发语言都支持正则表达式，后面学习的python语言里也有正则表达式.

linux里主要支持正则表达式的命令有 **grep**, **sed**, **awk**

### 正则一

| 表达式 | 说明                                                 | 示例                            |
| ------ | ---------------------------------------------------- | ------------------------------- |
| []     | 括号里的字符任选其一                                 | [abc]\[0-9]\[a-z]               |
| [^]    | 不匹配括号里的任意字符(括号里面的^号为"非",不是开头) | [^abc]表示不为a开头,b开头,c开头 |
| ^[]    | 以括号里的任意单个字符开头(这里的^是开头的意思)      | ^[abc]:以a或b或c开头            |
| ^[^]   | 不以括号里的任意单个字符开头                         |                                 |
| ^      | 行的开头                                             | ^root                           |
| $      | 行的结尾                                             | bash$                           |
| ^$     | 空行                                                 |                                 |

**示例: 准备一个文件**

```shell
# vim 1.txt
boot
boat
rat
rot
root
Root
brot.
```

```shell
查找有rat或rot字符的行
# grep r[oa]t 1.txt						
rat
rot
brot.

```

```shell
查看非r字符开头，但2-4个字符为oot的行
# grep [^r]oot 1.txt
boot
Root
```

```shell
查找有非大写字母与一个o字符连接的行
# grep '[^A-Z]o' 1.txt
boot
boat
rot
root				
Root			# 这个也可以查出来，因为第2-3个字符符合要求
brot.
```

```shell
查找不以r和b开头的行
# grep ^[^rb] 1.txt
Root
```

```shell
查找以rot开头以rot结尾的行(也就是这一行只有rot三个字符)
# grep ^rot$ 1.txt
rot
```



```shell
查找.号结尾的字符，需要转义并引号引起来(比较特殊，因为下面就要讲到.号是特殊的元字符)
# grep "\."$  1.txt
brot.
```

问题: 使用grep输出`/etc/vsftpd/vsftpd.conf`配置文件里的配置(去掉注释与空行)

```shell
提示: grep -v取反
别忘了grep -E扩展模式可以实现或
如: grep -E "root|ftp" /etc/passwd

答:
```



### 正则二

| 表达式                                         | 功能                             |
| ---------------------------------------------- | -------------------------------- |
| [[:alnum:]]                                    | 字母与数字字符                   |
| [[:alpha:]]                                    | 字母字符(包括大小写字母)         |
| [[:blank:]]                                    | 空格与制表符                     |
| **[[:digit:]]或[0-9]**          (**==常用==**) | 数字                             |
| **[[:lower:]]或[a-z]**        (**==常用==**)   | 小写字母                         |
| **[[:upper:]]或[A-Z] **      (**==常用==**)    | 大写字母                         |
| [[:punct:]]                                    | 标点符号                         |
| [[:space:]]                                    | 包括换行符，回车等在内的所有空白 |

```shell
查找不以大写字母开头
# grep '^[^[:upper:]]' 1.txt 			# 这个取反的写法很特殊,^符在两个中括号中间(了解即可)
# grep  '^[^A-Z]' 1.txt 
# grep -v '^[A-Z]' 1.txt 
```

```shell
查找有数字的行
# grep '[0-9]' 1.txt
# grep [[:digit:]] 1.txt
```

```shell
查找一个数字和一个字母连起来的行
# grep -E '[0-9][a-Z]|[a-Z][0-9]' grep.txt 			# grep -E是扩展模式，中间|符号代表"或者"
```



**问题:** 请问汉语描述`grep [^a-z] 1.txt`是查找什么?

```shell

```



### 正则三

名词解释：

**元字符**: 指那些在正则表达式中具有**特殊意义的专用字符**,如:点(.) 星(*) 问号(?)等 

**前导字符**：即位于元字符前面的字符		ab**==c==***   aoo**==o==.**

**==注意:==** 元字符如果想表达字符本身需要转义，如.号就想匹配"."号本身则需要使用\\.

| 字符  | 字符说明                                                     | 示例           |
| ----- | ------------------------------------------------------------ | -------------- |
| *     | 前导字符出现0次或者连续多次                                  | ab*  abbbb     |
| .     | 除了换行符以外，任意单个字符                                 | ab.   ab8 abu  |
| .*    | 任意长度的字符                                               | ab.*  abdfdfdf |
| {n}   | 前导字符连续出现n次             （**需要配合grep -E或egrep使用**) | [0-9]{3}       |
| {n,}  | 前导字符至少出现n次             （**需要配合grep -E或egrep使用**) | [a-z]{4,}      |
| {n,m} | 前导字符连续出现n到m次      （**需要配合grep -E或egrep使用**) | o{2,4}         |
| \^[^] | 不匹配以括号里的任意单个字符开头                             |                |
| +     | 前导字符出现1次或者多次   （**需要配合grep -E或egrep使用**)  | [0-9]+         |
| ?     | 前导字符出现0次或者1次     （**需要配合grep -E或egrep使用**) | go?            |
| ( )   | 组字符                                                       |                |

示例文本：

```shell
# vim 2.txt
ggle
gogle
google
gooogle
gagle
gaagle
gaaagle
abcgef
abcdef
goagle
aagoog
wrqsg
```

问题:一起来看看下面能查出哪些字符,通过结果理解记忆

```shell
# grep g.  2.txt
# grep g*  2.txt  				# 结果比较怪
# grep g.g 2.txt
# grep g*g 2.txt
# grep go.g 2.txt
# grep go.*g 2.txt
# grep -E go{2}g 2.txt
# grep -E 'go{1,2}g' 2.txt		# 需要引号引起来，单引双引都可以
# grep -E 'go{1,}g' 2.txt		# 需要引号引起来，单引双引都可以
# grep -E go+g 2.txt
# grep -E go?g 2.txt
```



**示例:** 查出eth0网卡的IP,广播地址,子网掩码

![1555429788701](shell查询宝典.assets/正则截取IP.png)

```shell
# ifconfig eth0|grep Bcast| grep -E -o '([0-9]{1,3}.){3}[0-9]{1,3}'
10.1.1.11
10.1.1.255
255.255.255.0
解析:
[0-9]{1,3}\.  	  代表3个数字接一个.号
([0-9]{1,3}\.){3}  前面用小括号做成一个组，后面{3}代表重重复3次
[0-9]{1,3}		  最后一个数字后不需要.号
```



**示例:** 匹配邮箱地址

```shell
# echo "daniel@126.com" | grep -E '^[0-9a-zA-Z]+@[a-z0-9]+\.[a-z]+$'
解析:
^[0-9a-zA-Z]+@      	代表@符号前面有1个或多个字符开头(大小写字母或数字)
@[a-z0-9]+\.[a-z]+$	 	代表@符号和.号(注意.号要转义)中间有1个或多个字符(小写字母或数字)
						.号后面有1个或多个字符(小写字母)结尾
```

# 七、sed

### sed介绍

```shell
# man sed
sed  - stream editor for filtering and trans-forming text
```

Windows下的编辑器:

![1555508121170](shell查询宝典.assets/edit.png)

linux下的编辑器:

* **==vi或vim==**
* gedit
* emacs等



![sed](shell查询宝典.assets/sed.png)

- 首先sed把当前正在处理的行保存在一个临时缓存区中（也称为模式空间），然后处理临时缓冲区中的行，完成后把该行发送到屏幕上。
- sed把每一行都存在临时缓冲区中，对这个**副本**进行编辑，所以不会修改原文件。当然你也可以选择修改源文件，需要`sed -i 操作的文件`

学习sed的关键是要搞清楚,它是一个**流**==编辑器==,编辑器常见的功能有: 

* 删除**行**
* 打印**行**
* 增加**行**
* 替换(修改）

#### ==sed参数==

```shell
sed参数
-e	进行多项编辑，即对输入行应用多条sed命令时使用
-n	取消默认的输出
-r  使用扩展正则表达式
-i inplace，原地编辑（修改源文件）

sed操作
d  删除行
p  打印行
a  后面加行
i  前面加行
s  替换修改
```

### 删除行操作

**==d(delete)代表删除==**

#### 使用行数匹配行

指定删除第2行

```shell
# head  -5 /etc/passwd |cat -n |sed  2d

变量引用需要双引号
a=2					
# head -5 /etc/passwd |cat -n |sed "$a"d	
```

删除第2行到第3行，中间的逗号表示范围

```shell
# head -5 /etc/passwd |cat -n |sed  2,3d
```

删除第1行和第5行，中间为分号，表示单独的操作

```shell
错误，需要引号引起来
# head -5 /etc/passwd |cat -n |sed 1d;5d
正确
# head -5 /etc/passwd |cat -n |sed  '1d;5d'
```

删除第1,2,4行, -e参数是把不同的多种操作可以衔接起来

```shell
head -5 /etc/passwd |cat -n |sed -e '2d;4d' -e '1d'
```



问题:下面操作代表什么

```shell
# head -n 5 /etc/passwd |cat -n |sed  '1d;3d;5d'

# head -n 5 /etc/passwd |cat -n |sed  '1,3d;5d'
```

#### 使用正则+关键字匹配行

如果不知道行号,但知道行里的某个单词或相关字符,我们可以使用正则表达式进行匹配

删除匹配oo的行

```shell
# head -n 5 /etc/passwd |cat -n |sed  '/oo/d'
```

删除以root开头的行

```shell
# head -n 5 /etc/passwd |sed  '/^root/d'
```

删除以bash结尾的行

```shell
# head -n 5 /etc/passwd |sed  '/bash$/d'
```

其它任意正则表达式都可以匹配

**练习:(注意: -i参数会直接操作源文件,所以请先不加-i测试，测试OK后再加-i参数)**

`sed -i`删除/etc/vsftpd/vsftpd.conf里所有的注释和空行

```shell

```

`sed -i`删除/etc/samba/smb.conf里所有的注释和空行

```shell

```

### 打印行操作

打印行(删除的反义)

**==p(print)代表打印==**

#### 使用行数匹配行

打印第1行

```shell
# head  -5 /etc/passwd |cat -n | sed  1p
     1  root:x:0:0:root:/root:/bin/bash				# 会在原来5行的基础上再打印第1行
     1  root:x:0:0:root:/root:/bin/bash
     2  bin:x:1:1:bin:/bin:/sbin/nologin
     3  daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4  adm:x:3:4:adm:/var/adm:/sbin/nologin
     5  lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

# head  -5 /etc/passwd |cat -n | sed -n 1p			# 正确做法加一个-n参数
     1  root:x:0:0:root:/root:/bin/bash
```

打印第1行和第4行

```shell
# head  -5 /etc/passwd |sed -ne '1p;4p'
```

打印1-4行

```shell
# head  -5 /etc/passwd |sed -ne '1,4p'
```

#### 使用正则+关键字匹配行

打印有root关键字的行

```shell
# head -5 /etc/passwd |sed -n '/root/p'
```

打印以root开头的行

```shell
# head -5 /etc/passwd |sed -n '/^root/p'
```

找出var/log/secure日志里成功登录的ssh信息

```shell
方法1:
# sed -n '/Accepted/p' /var/log/secure
方法2:
# grep Accepted /var/log/secure
方法3:(awk还没学，先了解一下)
# awk '$0~"Accepted" {print $0}' /var/log/secure
```

### 增加行操作

**==a(append)代表后面加行==**

**==i(insert)代表前面插入行==**

准备一个文件

```shell
# cat 1.txt
11111
22222
44444
55555
```

在第2行后加上33333这一行

```shell
# sed -i '2a33333' 1.txt
# cat 1.txt
11111
22222
33333
44444
55555
```

在第1行插入00000这一行

```shell
# sed -i '1i00000' 1.txt
# cat 1.txt
00000
11111
22222
33333
44444
55555
```

也可以用**正则**匹配行,这里表示在4开头的行的后一行加上ccccc这一行

```shell
# sed -i '/^4/accccc' 1.txt	

# cat 1.txt
00000
11111
22222
33333
44444
ccccc
55555
```

### 修改替换操作

**sed的修改替换格式与vi里的修改替换格式一样**

#### 使用数字匹配行

替换每行里的第1个匹配字符

```shell
# head  -5 /etc/passwd |sed 's/:/===/'
root===x:0:0:root:/root:/bin/bash
bin===x:1:1:bin:/bin:/sbin/nologin
daemon===x:2:2:daemon:/sbin:/sbin/nologin
adm===x:3:4:adm:/var/adm:/sbin/nologin
lp===x:4:7:lp:/var/spool/lpd:/sbin/nologin
```

全替换

```shell
# head  -5 /etc/passwd |sed 's/:/===/g'
root===x===0===0===root===/root===/bin/bash
bin===x===1===1===bin===/bin===/sbin/nologin
daemon===x===2===2===daemon===/sbin===/sbin/nologin
adm===x===3===4===adm===/var/adm===/sbin/nologin
lp===x===4===7===lp===/var/spool/lpd===/sbin/nologin
```

替换2-4行

```shell
# head  -5 /etc/passwd |sed '2,4s/:/===/g'
root:x:0:0:root:/root:/bin/bash
bin===x===1===1===bin===/bin===/sbin/nologin
daemon===x===2===2===daemon===/sbin===/sbin/nologin
adm===x===3===4===adm===/var/adm===/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
```

替换2行和4行

```shell
# head  -5 /etc/passwd |sed '2s/:/===/g;4s/:/===/g'
root:x:0:0:root:/root:/bin/bash
bin===x===1===1===bin===/bin===/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm===x===3===4===adm===/var/adm===/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
```

替换第2行的第1个和第3个匹配字符

```shell
注意后面的数字是2，前面替换了1个，剩下的里面替换第2个也就是原来的第3个
# head  -5 /etc/passwd |sed '2s/:/===/;2s/:/===/2'
root:x:0:0:root:/root:/bin/bash
bin===x:1===1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
```

#### 使用正则匹配行

替换以daemon开头的那一行

```shell
# head -5 /etc/passwd |sed '/^daemon/s/:/===/g'
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon===x===2===2===daemon===/sbin===/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
```





**&符号在sed替换里代表前面被替换的字符**

```shell
理解下面两句的不同:
s/[0-9]/ &/
s/[0-9]/ [0-9]/
```



练习: 使用脚本实现修改主机名(假设改为a.b.com)

```shell
sed -i '/^HOSTNAME=/s/localhost.localdomain/a.b.com/' /etc/sysconfig/network

```

练习: 修改/etc/selinx/config配置文件,将selinux关闭

```shell

```

### sed分域操作(拓展)

将()之间的字符串(**==一般为正则表达式==**)定义为组,并且将匹配这个表达式的保存到一个区域（一个正则表达式最多可以保存9个）,它们使用\1到\9来表示。然后进行替换操作

**注意:** sed分域操作的格式就是替换修改.

**示例:** 把`hello,world.sed`变成`world,sed.hello`(注意: 1个逗号1个点号)

```shell
方法1:
# echo "hello,world.sed" | sed 's/\(.*\),\(.*\)\.\(.*\)/\2,\3.\1/'
world,sed.hello
此方法\符太多了，建议使用-r扩展模式，就不用加\转义括号了

方法2:
# echo "hello,world.sed" | sed -r 's/(.*),(.*)\.(.*)/\2,\3.\1/'
world,sed.hello

方法3:
# echo "hello,world.sed" | sed -r 's/(....)(.)(....)(.)(......)/\3\2\5\4\1/'
hello,world.sed

方法4:
# echo "hello,world.sed" | sed -r 's/(.{4})(.)(.{4})(.)(.{6})/\3\2\5\4\1/'
hello,world.sed
```



**示例:** 以/etc/passwd文件前5行为例,进行如下处理

删除每行的第一个字符

```shell
# head -5 /etc/passwd |cut -c2-
# head -5 /etc/passwd |sed -r 's/(.)(.*)/\2/'
# head -5 /etc/passwd |sed -r 's/.//1'
# head -5 /etc/passwd |sed -r 's/^.//'
```

删除每行的第九个字符

```shell
# head -5 /etc/passwd |cut -c1-8,10-
# head -5 /etc/passwd |sed -r 's/(.{8})(.)(.*)/\1\3/'
# head -5 /etc/passwd |sed -r 's/.//9'
```

删除倒数第5个字符

```shell
# head -5 /etc/passwd |rev |cut -c1-4,6- |rev
# head -5 /etc/passwd |sed -r 's/(.*)(.)(....)/\1\3/'
```

把每行的第5个字符和第8个字符互换，并删除第10个字符

```shell
# head -5 /etc/passwd | sed -r 's/(....)(.)(..)(.)(.)(.)(.*)/\1\4\3\2\5\7/'
```

# 八、AWK

grep:更适合单纯的==查找==(通过要查找的关键字)或匹配(通过正则)==行==

sed:更适合==编辑==文本(行删除,行打印,行增加,替换与修改等)

awk:更适合==格式化文本，对文本进行较复杂格式处理==

今天主要讨论awk,格式化文本是很专业的说法，通俗来说就是可以**把文本变成你想要的样子**

**比如:** 将/etc/passwd文件的前三行处理成下面的样子(先不要管它是怎么得到的，我们慢慢来讲解)

```shell
# head -3 /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
```

```shell
# head -3 /etc/passwd |awk -F: 'BEGIN{print"用户名\tUID"}{print $1"\t"$3}'
用户名  UID
root    0
bin     1
daemon  2
```

有的同学会说, 我可以用cut截取这三行的用户名和UID,然后echo打印出来也可以啊。那么如果不是3行，而是300行呢?

又有的同学会说,我可以循环300行截取每行的用户名和UID,然后循环打印出来啊。

能想到这点非常好，因为awk就是逐行扫描文件，默认从第一行到最后一行来循环处理文件的，比以前学的`cat /etc/passwd |while read line`这种结构会方便很多。

**小结:** awk是一个能对文本进行较复杂格式处理的工具，能对文本做**截取**，**匹配**，**运算统计**等操作。



**awk小知识**

- awk分别代表其作者姓氏的第一个字母。因为它的作者是三个人，分别是Alfred Aho、Peter Weinberger, Brian Kernighan。
- gawk是awk的GNU版本，它提供了Bell实验室和GNU的一些扩展。


- 下面介绍的awk是以GNU的gawk为例的，在linux系统中已把awk链接到gawk，所以下面全部以awk进行介绍。

### awk使用格式

```shell
# awk -F"分隔符" "命令动作" 被处理的文件
也可以通过管道传给awk处理
# cat 被处理的文件 | awk -F"分隔符" "命令动作"
```

### awk做截取

awk内部变量，可以直接拿来用，不用再定义

#### awk内部相关变量

| awk内部变量                   | 说明                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| $0       (**==常用==**)       | 当前处理行的所有记录(所有列数之和) 包含分隔符                |
| \$ 1  到  \$n  (**==常用==**) | 文件中每行以间隔符号分割的不同字段($1代表第1列。。。。。。以此类推) |
| NF     (**==常用==**)         | 当前记录的字段数（列数）                                     |
| $NF   (**==常用==**)          | 最后一列                                                     |
| NR    (**==常用==**)          | 行号                                                         |
| FS      (**==常用==**)        | 定义间隔符，等同于-F 参                                      |

**注意:** awk里的打印不是echo,是**==print==**

```shell
# head -3 /etc/passwd |awk -F: '{print $1}'
root
bin
daemon
```

```shell
# head -3 /etc/passwd |awk -F: '{print $3}'
0
1
2
```







#### cut与awk截取比较

##### **比较1**

cut默认以**1个空格**为分隔符,awk默认**以1个或多个空格**为分隔符

从下面的信息中截取到IP

```shell
# ifconfig eth0 |sed -n 2p
          inet addr:10.1.1.11  Bcast:10.1.1.255  Mask:255.255.255.0
```

使用cut截取,有多个空格的话，每个空格都算一个分隔符，所以-f12(第12列)才找到有ip地址的那部分

```shell
# ifconfig eth0 |sed -n 2p |cut -d" " -f12 |cut -d":" -f2
10.1.1.11
```

使用awk截取,多个空格也只算一个分隔符(并且是默认的，不用-F指定分隔符),所以$2(第2列)就找到了额ip地址的那部分

```shell
# ifconfig eth0 |sed -n 2p |awk '{print $2}' |awk -F: '{print $2}'
10.1.1.11
```





![1555640557181](shell查询宝典.assets/awk2.png)

##### **比较2 **

cut只能以**单个字符**为分隔符,而awk可以以**多个字符**为分隔符

cut以"ab"这两个字符为分隔符会报错

```shell
# echo 123ab456ab789 |cut -d"ab" -f2
cut: the delimiter must be a single character	# 报错信息,告诉我们分隔符必须为单个字符
Try `cut --help' for more information.
```

awk以"ab"这两个字符为分隔符OK

```shell
# echo 123ab456ab789 |awk -F"ab" '{print $2}'
456
```

##### **比较3**

 awk可以将文本截取多段后自由拼接,并可以额外加字符进行粘合，而cut会比较麻烦

 ```shell
# head -3 /etc/passwd |awk -F":" '{print $1"用户的uid是"$3}'
root用户的uid是0
bin用户的uid是1
daemon用户的uid是2
 ```

而cut要实现同类效果会比较麻烦，cut命令无法在截取的两列中间直接加字符进行粘合

```shell
# head -3 /etc/passwd | cut -d: -f1"用户的uid是"3
cut: invalid byte, character or field list
Try `cut --help' for more information.
```

cut需要使用下面的脚本来实现

```shell
#!/bin/bash

head -3 /etc/passwd | cut -d: -f1,3 |while read a
do
        head=`echo $a|cut -d: -f1`
        tail=`echo $a|cut -d: -f2`
        echo  "$head的uid是$tail"
done
```

##### **比较4**

awk还可以**使用正则表达式为分隔符**,而cut就不行

以逗号或点号为分隔符(再次回顾正则表达式里中括号里的字符任选其一),截取第2列

```shell
# echo hello,world.sed |awk -F[,.] '{print $2}'
world
```

以逗号或点号为分隔符,将三列重新排序

```shell
# echo hello,world.sed |awk -F[,.] '{print $2","$3"."$1}'
world,sed.hello
```

下面这样的字符串,以点为分隔符可以做,但是点号太多,不好数.所以可以用正则表达式,以连续的多个点来为分隔符

```shell
# echo "haha,hehe..............................heihei......" |awk -F"[.]*" '{print $2}'
heihei
```

### awk做匹配

**我们知道grep命令可以用来做行匹配(通过关键字或正则查找行),awk也可以做行匹配,相对于grep也有优势**

#### 做匹配比较:

下面三条命令结果一样

```shell
# grep root /etc/passwd
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin
```

```shell
# sed -n /root/p /etc/passwd
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin
```

```shell
# awk '$0~"root" {print $0}' /etc/passwd
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin
```

| awk行匹配符 | 说明              |
| ----------- | ----------------- |
| ==          | 等于,完全匹配     |
| ~           | 匹配              |
| !=          | 不等于,不完全匹配 |
| !~          | 不匹配            |

#### 完全匹配

查找/etc/passwd文件里用户名为root的行

```shell
# awk -F: '$1=="root" {print $0}' /etc/passwd
root:x:0:0:root:/root:/bin/bash
```

#### 匹配

查找/etc/passwd文件里用户名里有oo这两个字符的行

```shell
# awk -F: '$1~"oo" {print $0}' /etc/passwd
```

#### 不完全匹配

查找/etc/passwd文件里用户名不为root的行

```shell
# awk -F: '$1!="root" {print $0}' /etc/passwd
```

#### 不匹配

查找/etc/passwd文件里用户名里不包含oo这两个字符的行

```shell
# awk -F: '$1!~"oo" {print $0}' /etc/passwd

```

#### awk行匹配练习

1. 从/etc/passwd里查找出daemon用户的uid

```shell
 awk -F: '$1=="daemon" {print $1$3}' /etc/passwd
 daemon:x:2:2:daemon:/sbin:/sbin/nologin
```

2. 使用awk命令截取/dev/sda1的挂载点(提示: `df -h`)

```
df -h|awk '$1=="/dev/sda1" {print $1"的挂载点是"$NF}'
/dev/sda1的挂载点是/boot
```

潜意识和主观意识做出的逻辑解释及判断是相反的，但是按照各自执行后的结果却是相同的

潜意识和主观意识在执行过程中，一方被另一方蒙蔽的现象。

并且被蒙蔽的一方出于自我无错辩解原理来对结果进行强行合理化解释麻醉自我









### awk中BEGIN...END结构

在前面我们有提过awk在处理文件时是逐行处理的,那么有可能要在处理第一行前做一些事情(比如定义变量),在处理完最后一行后做一些事情(比如打印统计信息等)。这就要用到BEGIN...END结构了。

#### 语法结构

| 结构关键字 |                                                              |
| ---------- | ------------------------------------------------------------ |
| BEGIN { }  | 在awk处理文件第一行之**==前==**,大括号里写处理前的代码       |
| { }        | 前面没有BEGIN或END的大括号，都表示逐行处理文件过程**==中==**要做的事,**==会根据行数来循环==** |
| END { }    | 在awk处理完了后一行之**==后==**,大括号里写处理前的代码       |

#### 理解BEGIN

先猜一下,下面的命令答案是多少?

提示:`one=1;two=2`是在程序开始前定义两个变量，$(one+two)括号里就是两个变量相加(**注意:awk也是一个编程语言,有自己的四则语法,所以不需要使用shell里的运算符,这里的小括号只是单纯的四则运算里的小括号**)

```shell
# echo a b c |awk 'BEGIN {one=1;two=2} {print $(one+two)}'
```





**问题:** 比较这两句, 结果有什么区别?（请先根据理解在脑海里想一个答案的样子,再执行命令比较一下)

```shell
# head -3 /etc/passwd | awk -F: '{print "用户名\tUID"}{print $1"\t"$3}'

# head -3 /etc/passwd | awk -F: 'BEGIN {print "用户名\tUID"}{print $1"\t"$3}'
```





#### 理解END

前,中,后的理解中"后"会有一点特殊的地方,如:

下面两行都是打印最后一行,所以可以使用awk里的END实现最后一行打印

```shell
# awk 'END {print $0}' /etc/passwd
apache:x:48:48:Apache:/var/www:/sbin/nologin
# tail -1 /etc/passwd
apache:x:48:48:Apache:/var/www:/sbin/nologin
```

但BEGIN不能打印第一行,如下面这句就没有结果

```shell
# awk 'BEGIN {print $0}' /etc/passwd
```



#### 总体结构理解

```shell
# cat /etc/sysconfig/network |wc -l
2									此文件有2行

# awk -F: 'BEGIN {print "aaa"} {print "bbb"} END {print "ccc"}' /etc/sysconfig/network
aaa
bbb
bbb
ccc
```

![1555656631087](shell查询宝典.assets/awk3.png)

**问题:** 下面的命令是什么样的结果? （请先根据理解在脑海里想一个答案的样子,再执行命令比较一下)

```shell
# awk -F: 'BEGIN {print "aaa"} {print $0} END {print "ccc"}' /etc/sysconfig/network
```





**示例:** 请计算下面文件以":"号为分隔符的总列数

```shell
# cat 1.txt
aaa:bbb:ccc:111
aaa:bbb
aaa:bbb:ccc
111:222:333:444:555
```

思路:

* 一定要牢记awk是会逐行处理文件,所以直接看作是按行数来处理的循环
* 在循环前定义一个变量表示要计算的总列数,如sum=0
* 每行循环处理时,sum=sum+每行的列数(再次强调,awk里的运算不需要运算符)
* 循环处理完文件后，打印出sum的值就是想要求的总列数了
* 也就是说awk的处理方式就是类似下面的这个循环结构

```shell
sum=0
for i in 行数
do
	sum=sum+每一行的列数
done
echo 总列数



awk -F: 'BEGIN {nu=0;print "用户名\tuid"} $3~0 {print $1"\t"$3;nu=nu+1} END{print nu}' /etc/passwd

```



**答案:**

```shell
# awk -F: 'BEGIN {sum=0} {sum=sum+NF} END {print sum}' 1.txt
14
```



### awk的运算符

再次强调,awk是一门语言,所以有自己的运算符(**注意:有些地方与shell不一样**)

| 运算符 | 说明                                                         |
| ------ | ------------------------------------------------------------ |
| ==     | 等于                   和shell里不一样,shell里字符串比较是=    ;数字比较是-eq |
| !=     | 不等于               shell里数字比较是-ne代表不等于          |
| >      | 大于                   shell里数字比较是(-gt)代表大于        |
| <      | 小于                   shell里数字比较是(-lt)代表小于        |
| >=     | 大于等于           shell里数字比较是(-ge)代表大于等于        |
| <=     | 小于等于           shell里数字比较是(-le)代表小于等于        |
| &&     | 逻辑与(和)                                                   |
| \|\|   | 逻辑或                                                       |
| +      | 加法                                                         |
| -      | 减法                                                         |
| *      | 乘法                                                         |
| /      | 除法                                                         |
| %      | 求余数                                                       |
| NR     | 行号， NR=1  即第一行，NR>=5 && NR<=10即第五到十行           |

**通过运算符和NR内部变量的结合可以控制处理文本的行**

打印/etc/passwd第五行（**可以把NR==5看作是一个判断的条件,满足此条件才执行print $0**)

```shell
# awk 'NR==5 {print $0}' /etc/passwd
```

打印/etc/passwd第五到十行，并在前面加上行号

```shell
# awk 'NR>=5 && NR<=10 {print NR,$0}' /etc/passwd
```

打印第五行和第六行

```shell
# awk -F: 'NR==5 || NR==6 {print $0}' /etc/passwd
```

打印/etc/passwd奇数行 (删除偶数行)

```shell
# awk 'NR%2==1 {print NR,$0}' /etc/passwd
```

打印/etc/passwd偶数行 (删除奇数行)

```shell
# awk 'NR%2==0 {print NR,$0}' /etc/passwd
```

对/etc/passwd里的用户做分类，分成管理员，系统用户，普通用户

```shell
# awk -F: '$3==0 {print $1}' /etc/passwd

# awk -F: '$3<500 && $3>0 || $3==65534  {print $1}' /etc/passwd

# awk -F: '$3>499 && $3!=65534 {print $1}' /etc/passwd
```



**练习:** 

对/etc/passwd里的用户做分类

```shell
# awk -F: '$3==0{print $1"\t是管理员";next;}$3>=1 && $3<=499{print $1"\t是程序用户";next;}$3>499{print $1"\t是普通用户"}' /etc/passwd

```

找出磁盘使用率高于80%的找出来（提示: df -P)

```shell
df -P|sed 1d|awk -F"[ %]+" '$5>80 {print $1"的磁盘使用率已达到"$5"%"}'

df -P|sed 1d|awk '$3/$2>=0.8{print $1"的磁盘使用率已达到"$5"%"}'
```


# 九、函数收集

### 1.获取当前正在执行脚本的绝对路径

```shell
basepath=$(cd `dirname $0`; pwd)

// 详解
dirname $0  //取得当前执行的脚本文件的父目录

cd `dirname $0`  //进入这个目录(切换当前工作目录)

pwd   //显示当前工作目录(cd执行后的)
```

### 2.获取本机的网卡名称

```shell
# 获取本机的网卡名称    
ls /sys/class/net|grep -v "lo"|grep -v "vir"
 
# 或者
ifconfig | grep  "mtu" | awk -F: '{print $1}'|grep -v "lo"|grep -v "vir"
 
# 当前网卡的IP地址
ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
 
# 用 shell 获取当前IP的C类地址 sed 's/\.[0-9]*$/\.0\/24/' /tmp/ip.txt
# 用 shell 获取当前IP的B类地址 sed 's/\.[0-9]\.[0-9]*$/\.0\.0\/16/' /tmp/ip.txt
# 举例
 
IP=107.172.3.211
echo $IP>/tmp/ip.txt
IP=`sed 's/\.[0-9]\.[0-9]*$/\.0\.0\/16/' /tmp/ip.txt`
echo $IP
```

### 3.expect非交互式

```shell
/usr/bin/expect <<EOF
spawn passwd $i

expect "password:"
send "$i\n"

expect "password:"
send "$i\n"

expect eof
EOF

#初始化root密码 删除匿名用户
echo '#!/usr/bin/expect
set timeout 60
spawn mysql_secure_installation
expect {
"enter for none" { send "\r"; exp_continue}
"Y/n" { send "Y\r" ; exp_continue}
"password" { send "123456\r"; exp_continue}
"Cleaning up" { send "\r"}
}
interact ' > mysql_secure_installation.exp
chmod +x mysql_secure_installation.exp
./mysql_secure_installation.exp

 \n是换行,英文是New line。\r是回车,
```

### 4.端口检查函数

```shell
sshd_port () {
    local ssh_port=$(netstat -ntulp | grep sshd | awk '{print $4}' | awk -F ':' '{print $2}')
    green_echo "SSH INFO:"
    {
    if [ $ssh_port == 22 ];then
        red_echo "\t[WARNING] 远程登陆不建议开启22端口,请及时修改!"
    else
       echo -e "\t[INFO] 远程登陆非22端口"
    fi
    }
   echo     
}
```



### 5.用户检测

```shell
system_user () {
    user_list=(adm lp sync shutdown halt mail uucp operator games gopher dbus rpc vcsa abrt saslauth haldaemon)
    local  user_dir="/etc/passwd"
    green_echo "System Default User:" 
    {
    cat $user_dir |awk -F : '{print $1}'  | while read user
    do
    
        for system_user in ${user_list[@]}
        do
           if [ $user == $system_user ];then
               nologin=$(grep -E $system_user $user_dir | awk -F : '{print $NF}')
                if [ "$nologin" != "/sbin/nologin" ];then
                       echo -e "\t$system_user 为系统默认用户未禁用,为预防被利用,请将其禁用"
                fi
           fi
        done
    done
    }
    echo
}	
```
### 6.代码混淆加密
```
gzexe monitor_v1.3.sh
```
执行后会生成一个1.sh~的文件，和一个原名文件
	原名文件为加密后的文件
	~结尾的文件为原始文件
相关博客：https://blog.csdn.net/whatday/article/details/102758898

### 7.多系统下载判断
```shell
function install_soft() {
    if command -v dnf > /dev/null; then
      dnf -q -y install "$1"
    elif command -v yum > /dev/null; then
      yum -q -y install "$1"
    elif command -v apt > /dev/null; then
      apt-get -qqy install "$1"
    elif command -v zypper > /dev/null; then
      zypper -q -n install "$1"
    elif command -v apk > /dev/null; then
      apk add -q "$1"
      command -v gettext >/dev/null || {
      apk add -q gettext-dev python3
    }
    else
      echo -e "[\033[31m ERROR \033[0m] $1 command not found, Please install it first"
      exit 1
    fi
}

function prepare_install() {
  for i in curl wget tar iptables; do
    command -v $i &>/dev/null || install_soft $i
  done
}
```
# 十、疑难报错与解决办法

## 1、too many arguments

在您的脚本中，出现了一个错误。错误发生在以下这行代码中：

```bash
if [ -z $STATUS ];then
```

根据您提供的信息，`$STATUS` 包含了端口状态的字符串，但在 `if [ -z $STATUS ];then` 这个条件判断中，参数没有被正确引用，因此导致了错误信息 "[: too many arguments"。

为了避免这个问题，您需要在变量引用时加上双引号，以避免参数分割问题。正确的写法应该是：

```bash
if [ -z "$STATUS" ]; then
```

这样可以确保脚本在判断变量是否为空时不会因为参数拆分而出错。

