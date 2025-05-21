# 标准库

## 标准库之os库

```
os.remove() 删除文件 
os.unlink() 删除文件 
os.rename() 重命名文件 
os.listdir() 列出指定目录下所有文件 
os.chdir() 改变当前工作目录
	os.chdir("/path/to/your/directory")
os.getcwd() 获取当前文件路径
os.mkdir() 新建目录
os.rmdir() 删除空目录(删除非空目录, 使用shutil.rmtree())
os.makedirs() 创建多级目录
os.removedirs() 删除多级目录
os.stat(file) 获取文件属性
os.chmod(file) 修改文件权限
os.utime(file) 修改文件时间戳
os.name(file) 获取操作系统标识
os.system() 执行操作系统命令
os.execvp() 启动一个新进程
os.fork() 获取父进程ID，在子进程返回中返回0
os.execvp() 执行外部程序脚本（Uinx）
os.spawn() 执行外部程序脚本（Windows）
os.access(path, mode) 判断文件权限(详细参考cnblogs)
os.wait() 暂时未知
```
### os.path库：
```
os.path.split(filename) 将文件路径和文件名分割(会将最后一个目录作为文件名而分离)
os.path.splitext(filename) 将文件路径和文件扩展名分割成一个元组
os.path.dirname(filename) 返回文件路径的目录部分
os.path.basename(filename) 返回文件路径的文件名部分
os.path.join(dirname,basename) 将文件路径和文件名凑成完整文件路径
os.path.abspath(name) 获得绝对路径
os.path.splitunc(path) 把路径分割为挂载点和文件名
os.path.normpath(path) 规范path字符串形式
os.path.exists() 判断文件或目录是否存在
os.path.isabs() 如果path是绝对路径，返回True
os.path.realpath(path) #返回path的真实路径
os.path.relpath(path[, start]) #从start开始计算相对路径 
os.path.normcase(path) #转换path的大小写和斜杠
os.path.isdir() 判断name是不是一个目录，name不是目录就返回false
os.path.isfile() 判断name是不是一个文件，不存在返回false
os.path.islink() 判断文件是否连接文件,返回boolean
os.path.ismount() 指定路径是否存在且为一个挂载点，返回boolean
os.path.samefile() 是否相同路径的文件，返回boolean
os.path.getatime() 返回最近访问时间 浮点型
os.path.getmtime() 返回上一次修改时间 浮点型
os.path.getctime() 返回文件创建时间 浮点型
os.path.getsize() 返回文件大小 字节单位
os.path.commonprefix(list) #返回list(多个路径)中，所有path共有的最长的路径
os.path.lexists #路径存在则返回True,路径损坏也返回True
os.path.expanduser(path) #把path中包含的”~”和”~user”转换成用户目录
os.path.expandvars(path) #根据环境变量的值替换path中包含的”$name”和”${name}”
os.path.sameopenfile(fp1, fp2) #判断fp1和fp2是否指向同一文件
os.path.samestat(stat1, stat2) #判断stat tuple stat1和stat2是否指向同一个文件
os.path.splitdrive(path) #一般用在windows下，返回驱动器名和路径组成的元组
os.path.walk(path, visit, arg) #遍历path，给每个path执行一个函数详细见手册
os.path.supports_unicode_filenames() 设置是否支持unicode路径名

```

在学此库前,告诫大家不要去死记硬背,首先能够看懂,然后需要用的时候就查。

**示例: 查看目录与切换目录等**

```python
import os

print(os.getcwd())						# 查看当前目录
os.chdir("/tmp")						# 改变当前目录
					
print(os.curdir)						# 打印当前目录.
print(os.pardir)						# 打印上级目录..
os.chdir(os.pardir)						# 切换到上级目录
print(os.listdir("/"))					# 列出目录里的文件,结果是相对路径，并且为list类型
```

**示例: 查看文件状态**

```python
import os

print(os.stat("/etc/fstab"))			# 得到文件的状态信息，结果为一个tuple类型
print(os.stat("/etc/fstab")[6])			# 得到状态信息(tuple)的第7个元素,也就是得到大小
print(os.stat("/etc/fstab")[-4])		# 得到状态信息(tuple)的倒数第4个元素,也就是得到大小
print(os.stat("/etc/fstab").st_size)	# 用这个方法也可以得到文件的大小

print(os.path.getsize(__file__))		# 得到文件的大小,__file__是特殊变量，代表程序文件自己
print(os.path.getsize("/etc/fstab"))	# 也可以指定想得到大小的任意文件
```

**示例: 文件路径相关操作**

```python
import os

print(os.path.abspath(__file__))		# 得到文件的绝对路径
print(os.path.dirname("/etc/fstab"))	# 得到文件的绝对路径的目录名，不包括文件
print(os.path.basename("/etc/fstab"))	# 得到文件的文件名，不包括目录
print(os.path.split("/etc/fstab"))		# 把dirname和basename分开，结果为tuple类型
print(os.path.join("/etc","fstab"))		# 把dirname和basename合并
```

**示例: 判断相关操作**

```python
import os

print(os.path.isfile("/tmp/1.txt"))		# 判断是否为文件,结果为bool类型
print(os.path.isabs("1.txt"))			# 判断是否为绝对路径,结果为bool类型
print(os.path.exists("/tmp/11.txt"))	# 判断是否存在,结果为bool类型
print(os.path.isdir("/tmp/"))			# 判断是否为目录,结果为bool类型
print(os.path.islink("/etc/rc.local"))	# 判断是否为链接文件,结果为bool类型
```

**示例: 文件改名与删除，目录创建与删除等**

```python
import os

os.rename("/tmp/1.txt","/tmp/11.txt")	# 改名
os.remove("/tmp/11.txt")				# 删除

os.mkdir("/tmp/aaa")					# 创建目录
os.rmdir("/tmp/aaa")					# 删除目录　
os.makedirs("/tmp/a/b/c/d")				# 连续创建多级目录
os.removedirs("/tmp/a/b/c/d")			# 从内到外一级一级的删除空目录，目录非空则不删除
```



**os.popen()**和**os.system()**可以直接调用linux里的命令，二者有一点小区别:

```python
# 下面这两句执行操作都可以成功
os.popen("touch /tmp/222")
os.system("touch /tmp/333")

print(os.popen("cat /etc/fstab").read())	# 通过read得到命令的内容，可直接打印出内容，也可以赋值给变量
print(os.system("cat /etc/fstab"))	# 除了执行命令外，还会显示返回值(0,非0，类似shell里$?判断用的返回值)

如果执行命令没有结果输出，两个都可以
所以如果是为了得到命令的结果输出，并想对结果赋值进行后续操作的话，就使用os.popen(cmd).read();
如果直接得到命令结果就可以了，那么直接使用os.system(cmd)就OK
```

**问题**: 感觉我就只要会os.popen()和os.system()就够了啊，因为我是搞linux运维的，命令熟悉啊。为啥还去记上面那些方法?

答: os.popen()与os.system()主要用于linux运维，在windows或MAC平台上就不能命令通用了。而os库的其它方法都是跨平台通用的.



**示例: 判断linux上的文件是否为block类型**

```python
import os

file_path = input("input a file path:")

file_type = os.popen("ls -l {} |cut -c1".format(file_path)).read().strip()

if file_type == "b":
     print("block file")
```



## 标准库之sys库

```
sys.argv 命令行参数List，第一个元素是程序本身路径 
sys.path 返回库的搜索路径，初始化时使用PYTHONPATH环境变量的值 
sys.modules.keys() 返回所有已经导入的库列表
sys.modules 返回系统导入的库字段，key是库名，value是库 
sys.exc_info() 获取当前正在处理的异常类,exc_type、exc_value、exc_traceback当前处理的异常详细信息
sys.exit(n) 退出程序，正常退出时exit(0)
sys.hexversion 获取Python解释程序的版本值，16进制格式如：0x020403F0
sys.version 获取Python解释程序的版本信息
sys.platform 返回操作系统平台名称
sys.stdout 标准输出
sys.stdout.write(‘aaa‘) 标准输出内容
sys.stdout.writelines() 无换行输出
sys.stdin 标准输入
sys.stdin.read() 输入一行
sys.stderr 错误输出
sys.exc_clear() 用来清除当前线程所出现的当前的或最近的错误信息 
sys.exec_prefix 返回平台独立的python文件安装的位置 
sys.byteorder 本地字节规则的指示器，big-endian平台的值是‘big‘,little-endian平台的值是‘little‘ 
sys.copyright 记录python版权相关的东西 
sys.api_version 解释器的C的API版本 
sys.version_info ‘final‘表示最终,也有‘candidate‘表示候选，表示版本级别，是否有后继的发行 
sys.getdefaultencoding() 返回当前你所用的默认的字符编码格式 
sys.getfilesystemencoding() 返回将Unicode文件名转换成系统文件名的编码的名字 
sys.builtin_module_names Python解释器导入的内建库列表 
sys.executable Python解释程序路径 
sys.getwindowsversion() 获取Windows的版本 
sys.stdin.readline() 从标准输入读一行，sys.stdout.write(“a”) 屏幕输出a
sys.setdefaultencoding(name) 用来设置当前默认的字符编码(详细使用参考文档) 
sys.displayhook(value) 如果value非空，这个函数会把他输出到sys.stdout(详细使用参考文档)

```

```python
sys.argv[n]         # sys.argv[0]等同于shell里的$0, sys.argv[1]等同于shell里的$1，以此类推 
```

**示例:**

```python
# vim 1.py

import sys,os

command = " ".join(sys.argv[1:])  	# df -h取出来会变为['df', '-h']，所以需要join成字符串

print(command)

print(os.popen(command).read())		# 这一句加上，就可以直接得到df -h命令的结果

# python3.6 1.py df -h        		# 这样可以把df -h命令取出来（在bash环境这样执行，不要使用pycharm直接执行)
```



## 标准库之random库

```python
import random

print(random.random())  				# 0-1之间的浮点数随机
print(random.uniform(1,3)) 				# 1-3间的浮点数随机

print(random.randint(1,3))  			# 1-3整数随机							(常用)
print(random.randrange(1,3))  			# 1-2整数随机
print(random.randrange(1,9,2))			# 随机1,3,5,7这四个数,后面的2为步长		   (常用)	

print(random.choice("hello,world"))   	# 字符串里随机一位，包含中间的逗号
print(random.sample("hello,world", 3))   # 从前面的字符串中随机取3位,并做成列表

list = [1, 2, 3, 4, 5]
random.shuffle(list)       				# 把上面的列表洗牌，重新随机
print(list)
```

**示例: 随机打印四位小写字母，做一个简单的验证码**

```python
import random
# 方法一:
code = ""
for i in range(4):
     code += random.choice("abcdefghijklmnopqrstuvwxyz")

print(code)

# 方法二:
code = random.sample("abcdefghijklmnopqrstuvwxyz", 4)

code2=""
for i in code:
    code2+=i
print(code2)

# 方法三:
code = ""
for i in range(4):
    for j in chr(random.randint(97,122)):		# chr()在变量的数据类型转换的表格里有写，这里97-122使用chr()转换后对应的就是a-z
        code += j
print(code)
```

**示例: 验证码要求混合大写字母,小写字母,数字**

```python
import random

code = ""
for i in range(4):
    a = random.randint(1,3)
    if a == 1:
        code += chr(random.randrange(65,91))		# 大写的A-Z随机
    elif a == 2:
        code += chr(random.randrange(97,123))		# 小写的a-z随机
    else:
        code += chr(random.randrange(48,58))		# 0-9随机

print(code)
```

## 标准库之re库

re是regex的缩写,也就是正则表达式

re.search()与re.findall()

* 都不是开头匹配

* re.search()只匹配一行里第一个,而re.findall()会把一行内匹配的多个都匹配出来

* re.search()可以通过group()打印匹配的结果, re.findall()没有group()方法，直接把匹配的所有结果以列表的形式展示

| 表达式或符号 | 描述                                   |
| ------------ | -------------------------------------- |
| ^            | 开头                                   |
| $            | 结尾                                   |
| [abc]        | 代表一个字符（a,b,c任取其一）          |
| [^abc]       | 代表一个字符（但不能为a,b,c其一)       |
| [0-9]        | 代表一个字符（0-9任取其一)  [:digit:]  |
| [a-z]        | 代表一个字符（a-z任取其一)   [:lower:] |
| [A-Z]        | 代表一个字符（A-Z任取其一)  [:upper:]  |
| .            | 一个任意字符                           |
| *            | 0个或多个前字符                        |
| .*           | 代表任意字符                           |
| +            | 1个或多个前字符                        |
| ?            | 代表0个或1个前字符                     |
| \d           | 匹配数字0-9                            |
| \D           | 匹配非数字                             |
| \w           | 匹配[A-Za-z0-9]                        |
| \W           | 匹配非[A-Za-z0-9]                      |
| \s           | 匹配空格,制表符                        |
| \S           | 匹配非空格，非制表符                   |
| {n}          | 匹配n次前字符                          |
| {n,m}        | 匹配n到m次前字符                       |

| 库+函数（方法） | 描述                                           |
| --------------- | ---------------------------------------------- |
| re.match()      | 开头匹配,类似shell里的^符号                    |
| re.search()     | 整行匹配，但只匹配第一个                       |
| re.findall()    | 全匹配并把所有匹配的字符串做成列表             |
| re.split()      | 以匹配的字符串做分隔符，并将分隔的转为list类型 |
| re.sub()        | 匹配并替换                                     |

**示例: re.match**

```python
import re

print(re.match("aaa","sdfaaasd"))  	 	# 结果为none，表示匹配未成功
print(re.match("aaa","aaasd"))    	 	# 有结果输出，表示匹配成功

abc = re.match("aaa\d+","aaa234324bbbbccc")
print(abc.group())  					# 结果为aaa234324，表示打印出匹配那部分字符串
```

**示例: re.search**				

```python
import re

print(re.search("aaa","sdfaaasdaaawwsdf"))  # 有结果输出，表示匹配成功;re.search就是全匹配，而不是开头(但只返回一个匹配的结果)；想开头匹配的话可以使用^aaa
print(re.search("aaa\d+","aaa111222bbbbcccaaaa333444").group())  # 验证,确实只返回一个匹配的结果,并使用group方法将其匹配结果打印出来
```

**示例: re.findall**

```python
import re

print(re.findall("aaa\d+","aaa111222bbbbcccaaaa333444")) # 没有group()方法了,结果为['aaa111222', 'aaa333444']
print(re.findall("aaa\d+|ddd[0-9]+","aaa111222bbbbddd333444"))  # 结果为['aaa111222', 'ddd333444']
```


**示例: re.split**

```python
import re

print(re.split(":","root:x:0:0:root:/root:/bin/bash"))	  # 以:分隔后面字符串,并转为列表
```

**示例: re.sub**

```python
import re

print(re.sub(":","-","root:x:0:0:root:/root:/bin/bash"))			# 全替换:成-
print(re.sub(":","-","root:x:0:0:root:/root:/bin/bash",count=3))	# 只替换3次
```





## stat库：

```
描述os.stat()返回的文件属性列表中各值的意义
fileStats = os.stat(path) 获取到的文件属性列表
fileStats[stat.ST_MODE] 获取文件的模式
fileStats[stat.ST_SIZE] 文件大小
fileStats[stat.ST_MTIME] 文件最后修改时间
fileStats[stat.ST_ATIME] 文件最后访问时间
fileStats[stat.ST_CTIME] 文件创建时间
stat.S_ISDIR(fileStats[stat.ST_MODE]) 是否目录
stat.S_ISREG(fileStats[stat.ST_MODE]) 是否一般文件
stat.S_ISLNK(fileStats[stat.ST_MODE]) 是否连接文件
stat.S_ISSOCK(fileStats[stat.ST_MODE]) 是否COCK文件
stat.S_ISFIFO(fileStats[stat.ST_MODE]) 是否命名管道
stat.S_ISBLK(fileStats[stat.ST_MODE]) 是否块设备
stat.S_ISCHR(fileStats[stat.ST_MODE]) 是否字符设置
```



## hashlib,md5库：
```
hashlib.md5(‘md5_str‘).hexdigest() 对指定字符串md5加密
md5.md5(‘md5_str‘).hexdigest() 对指定字符串md5加密
```
## random库：
```
random.random() 产生0-1的随机浮点数
random.uniform(a, b) 产生指定范围内的随机浮点数
random.randint(a, b) 产生指定范围内的随机整数
random.randrange([start], stop[, step]) 从一个指定步长的集合中产生随机数
random.choice(sequence) 从序列中产生一个随机数
random.shuffle(x[, random]) 将一个列表中的元素打乱
random.sample(sequence, k) 从序列中随机获取指定长度的片断
```



## 标准库之time,datetime,calendar库

**python中有三种时间类型**

| 时间类型                             | 描述                                  |
| ------------------------------------ | ------------------------------------- |
| struct_time(**==时间元组==**)        | 记录时间的年,月,日,时,分等            |
| timestamp**==时间戳==**（epoch时间） | 记录离1970-01-01 00:00:00有多少秒     |
| **==格式化的时间字符串==**           | 如2018-01-01 12:00:00(格式可以自定义) |

**三种类型之间的转换图**:

![1541313363756](https://minioapi.nerubian.cn/image/20250214152418650.png)



```
datetime.date.today() 本地日期对象,(用str函数可得到它的字面表示(2014-03-24))
datetime.date.isoformat(obj) 当前[年-月-日]字符串表示(2014-03-24)
datetime.date.fromtimestamp() 返回一个日期对象，参数是时间戳,返回 [年-月-日]
datetime.date.weekday(obj) 返回一个日期对象的星期数,周一是0
datetime.date.isoweekday(obj) 返回一个日期对象的星期数,周一是1
datetime.date.isocalendar(obj) 把日期对象返回一个带有年月日的元组
datetime对象：
datetime.datetime.today() 返回一个包含本地时间(含微秒数)的datetime对象 2014-03-24 23:31:50.419000
datetime.datetime.now([tz]) 返回指定时区的datetime对象 2014-03-24 23:31:50.419000
datetime.datetime.utcnow() 返回一个零时区的datetime对象
datetime.fromtimestamp(timestamp[,tz]) 按时间戳返回一个datetime对象，可指定时区,可用于strftime转换为日期表示 
datetime.utcfromtimestamp(timestamp) 按时间戳返回一个UTC-datetime对象
datetime.datetime.strptime(‘2014-03-16 12:21:21‘,”%Y-%m-%d %H:%M:%S”) 将字符串转为datetime对象
datetime.datetime.strftime(datetime.datetime.now(), ‘%Y%m%d %H%M%S‘) 将datetime对象转换为str表示形式
datetime.date.today().timetuple() 转换为时间戳datetime元组对象，可用于转换时间戳
datetime.datetime.now().timetuple()
time.mktime(timetupleobj) 将datetime元组对象转为时间戳
time.time() 当前时间戳
time.localtime
time.gmtime
```



**示例: 三种基本格式的打印**

```python
import time

time.sleep(1)					# 延迟1秒

print(time.localtime())		 	# 打印当前时间的年,月,日,时,分等等，本地时区（时间元组）
print(time.gmtime()) 			# 与localtime类似，但是为格林威治时间（时间元组）

print(time.strftime("%Y-%m-%d %H:%M:%S"))  # 打印当前时间（格式化字符串）
print(time.strftime("%F %T"))			   # 打印当前时间（格式化字符串）
print(time.asctime())					   # 打印当前时间（常规字符串格式）

print(time.time())  			# 打印当前时间，离1970年1月1号0点的秒数(时间戳)
```

**示例: 三种格式间的转换**

```python
import time

abc = time.localtime()							# 当前时间（本地时区）的时间元组赋值给abc
print(time.mktime(abc))  						# 时间元组转时间戳
print(time.strftime("%Y-%m-%d %H:%M:%S",abc)) 	# 时间元组转格式化字符串（自定义格式)
print(time.asctime(abc)) 						# 时间元组转格式化字符串(常规格式)

print(time.strptime("2018-01-01 10:30:25","%Y-%m-%d %H:%M:%S")) # 格式化字符串转时间元组

print(time.localtime(86400)) 	# 打印离1970年86400秒的时间，本地时区(时间戳转时间元组)
print(time.gmtime(86400)) 		# 打印离1970年86400秒的时间，格林威治时间（时间戳转时间元组）

print(time.ctime(335235))		# 时间戳转格式化字符串
```

**示例: datetime,calendar库**

```python
import datetime,calendar

print(datetime.datetime.now())
print(datetime.datetime.now()+datetime.timedelta(+3)) 			# 三天后
# shell里也有类似的用法，如: date '+%F %T' -d "+3 days"
print(datetime.datetime.now()+datetime.timedelta(days=-3)) 		# 三天前
print(datetime.datetime.now()+datetime.timedelta(hours=5)) 		# 五小时后
print(datetime.datetime.now()+datetime.timedelta(minutes=-10)) 	# 十分钟前
print(datetime.datetime.now()+datetime.timedelta(weeks=1)) 		# 一星期后

print(calendar.calendar(2018))
print(calendar.isleap(2016))
```

**示例: 打印昨天的时间(格式为YYYY-mm-dd HH:MM:SS)**

```python
import datetime,time

# 字符串来计算时间
print(str(datetime.datetime.now()+datetime.timedelta(days=-1)).split(".")[0])

# 转成时间戳来计算时间
print(time.strftime("%F %T",time.localtime(time.time()-86400)))
```

**示例:写一个2019-01-01的倒计时**

```python
import time

goal_seconds=int(time.mktime(time.strptime("2019-01-01 00:00:00","%Y-%m-%d %H:%M:%S")))

while True:
     s = int(goal_seconds-int(time.time()))
     if s == 0:
         break
     else:
        print("离2019年还有{}天{}时{}分{}秒".format(int(s/86400),int(s%86400/3600),int(s%3600/60),int(s%60)))
        time.sleep(1)

print("2019年到了")
```

**示例: 每隔1秒循环打印2018年的日期（从2018-01-01至2018-12-31)**

```python
import time,datetime

start_time = datetime.datetime.strptime("2018-01-01","%Y-%m-%d")
delta = datetime.timedelta(days=1)

while True:
    print(str(start_time).split()[0])
    start_time = start_time+delta
    time.sleep(1)
```

**示例: 简单的定时程序**

```python
import time

goal_time = input("输入定时的时间(年-月-日 时:分:秒):")

while True:
    now = time.strftime("%Y-%m-%d %H:%M:%S")
    print(now)
    time.sleep(1)
    if now == goal_time:
        print("时间到了!")
        break
```





# 第三方库


## 第三方库之psutil

psutil是一个跨平台库，能够轻松实现获取系统运行的进程和系统利用率（包括CPU、内存、磁盘、网络等）信息。它主要应用于系统监控，分析和限制系统资源及进程的管理。



### psutil.cpu_percent() 获取CPU使用率

```
cpu_percent(,[percpu],[interval])
```

- interval：指定的是计算cpu使用率的时间间隔，interval不为0时,则阻塞时显示interval执行的时间内的平均利用率

- percpu：指定是选择总的使用率或者每个cpu的使用率,percpu为True时显示所有物理核心的利用率

```
😍1.计算cpu使用率，每秒刷新1次，累计5次：
>>> for x in range(5):
...     psutil.cpu_percent(interval=1)
... 
2.4
2.5
2.7
2.3
2.5

🎶2.显示所有物理核心的利用率，每秒刷新1次，累计5次：
>>> for x in range(5):
...     psutil.cpu_percent(interval=1,percpu=True)
... 
[1.0, 3.1, 5.0, 4.0, 0.0, 4.0, 3.0, 2.0]
...
[1.0, 1.0, 6.1, 3.1, 2.0, 2.1, 0.0, 0.0]
[2.0, 1.0, 6.0, 4.9, 1.0, 5.1, 1.0, 1.0]
```





### psutil库常用操作

**linux下top,vmstat,sar,free,mpstat等命令可以查，而python程序员可以不用关心linux的命令直接使用psutil库就能得到相应的信息**

```python
import psutil
# cpu
print(psutil.cpu_times())			# 查看cpu状态,类型为tuple
print(psutil.cpu_count())			# 查看cpu核数,类型为int

# memory(内存)
print(psutil.virtual_memory())		# 查看内存状态,类型为tuple
print(psutil.swap_memory())			# 查看swap状态,类型为tuple

# partition(分区)
print(psutil.disk_partitions())		# 查看所有分区的信息,类型为list,内部为tuple
print(psutil.disk_usage("/"))		# 查看/分区的信息，类型为tuple
print(psutil.disk_usage("/boot"))	# 查看/boot分区的信息，类型为tuple

# io(磁盘读写)
print(psutil.disk_io_counters())	# 查看所有的io信息（read,write等)，类型为tuple
print(psutil.disk_io_counters(perdisk=True)) # 查看每一个分区的io信息，类型为dict,内部为tuple

# network(网络)
print(psutil.net_io_counters())		# 查看所有网卡的总信息(发包，收包等)，类型为tuple
print(psutil.net_io_counters(pernic=True))	# 查看每一个网卡的信息，类型为dict,内部为tuple

# process(进程)
print(psutil.pids())				# 查看系统上所有进程pid，类型为list
print(psutil.pid_exists(1))			# 判断pid是否存在，类型为bool
print(psutil.Process(1))			# 查看进程的相关信息,类型为tuple

# user(用户)
print(psutil.users())				# 查看当前登录用户相关信息，类型为list
```



**示例:监控/分区的磁盘使用率,超过90%(阈值，也就是临界值)就发给微信好友**  

```shell
# pip3.6 install itchat	   # 先安装itchat,或者用pycharm图形安装（可以连接微信的一个库)
```

```python
import psutil,itchat

itchat.auto_login(hotReload=True)	# 第一次登陆会扫描二维码登陆(hotreload=True会缓存，不用每次都登录)
user_info = itchat.search_friends("Candy")	# Candy为你的好友名，这是一个list类型,里面是dict
user_id = user_info[0]['UserName']	# 通过上面获取的信息得到Candy的好友id

# 下面这句是算出磁盘使用率并赋值给root_disk_use_percent变量
root_disk_use_percent = psutil.disk_usage("/")[1]/psutil.disk_usage("/")[0]

if root_disk_use_percent > 0.9:			# 如果/分区没有使用超过90%，为了方便测试可以把0.9改小
    itchat.send("/ is overload", toUserName=user_id)	# 发送信息给好友id
```








## 第三库之pymysql(拓展)

```python
# yum install mariadb* 
# systemctl restart mariadb

# pip3.6 install pymysql
```

**示例:** 

```python
import pymysql

db = pymysql.connect(host="localhost",user="root",password="",port=3306)	# 指定数据的连接host,user,password,port,schema

cursor = db.cursor()				# 创建游标,就类似操作的光标

cursor.execute("show databases;")

print(cursor.fetchone())    	# 显示结果的一行
print(cursor.fetchmany(2))    	# 显示结果的N行(接着前面的显示2行)

print(cursor.fetchall())    	# 显示结果的所有行(接着前面的显示剩余的所有行)

cursor.close()
db.close()
```

**示例:**

```python
import pymysql

db = pymysql.connect(host="localhost",user="root",password="",port=3306,db="mysql")  # 多指定了db="mysql"，表示登录后会直接use mysql

cursor = db.cursor()
# cursor.execute("use mysql;")	　# 前面连接时指定了连接的库，这里不用再执行use mysql;
cursor.execute("show tables;")

print(cursor.fetchall())

cursor.close()
db.close()
```

**示例: 操作数据库(建库，建表等)**

```python
import pymysql

db = pymysql.connect(host="localhost",user="root",password="",port=3306)

cursor = db.cursor()

cursor.execute("create database aaa;")
cursor.execute("use aaa;")
cursor.execute("create table emp(ename varchar(20),sex char(1),sal int)")
cursor.execute("desc emp")

print(cursor.fetchall())

cursor.close()
db.close()
```

**示例: 远程数据库dba先建一个库，再授权一个普通用户给远程开发的连接**

```shell
# 比如在10.1.1.12(测试服务器)上安装数据库，然后对10.1.1.11(开发人员)授权
# mysql
MariaDB [mysql]> create database aaadb;

MariaDB [mysql]> grant all on aaadb.* to 'aaa'@'10.1.1.11' identified by '123';

MariaDB [mysql]> flush privileges;
```

```python
# 下面开发代码是在10.1.1.11(开发人员)上执行的
import pymysql

db = pymysql.connect(host="10.1.1.12",user="aaa",password="123",port=3306,db="aaadb")

cursor = db.cursor()

cursor.execute("create table hosts(ip varchar(15),password varchar(10),hostgroup tinyint)")
# 插入数据方法一
cursor.execute("insert into hosts(ip,password,hostgroup) values('10.1.1.22','123456',1)")

# 插入数据方法二
insertsql = '''
    insert into hosts
    (ip,password,hostgroup)
    values
    ('10.1.1.23','123456',1),
    ('10.1.1.24','123456',1),
    ('10.1.1.25','123',2),
    ('10.1.1.26','1234',2),
    ('10.1.1.27','12345',2);
'''
cursor.execute(insertsql)

# 插入数据方法三
data = [
    ('10.1.1.28','12345',2),
    ('10.1.1.29','12345',3),
    ('10.1.1.30','12345',3),
    ('10.1.1.31','12345',3),
    ('10.1.1.32','12345',3),
    ('10.1.1.33','12345',3),
    ('10.1.1.34','12345',3),
]
cursor.executemany("insert into hosts(ip,password,hostgroup) values(%s,%s,%s);",data)

db.commit()					# 这里做完DML需要commit提交，否则数据库没有实际插入数据

cursor.execute("select * from hosts;")

print(cursor.fetchall())	# 上面不提交，这里也可以看得到

cursor.close()
db.close()
```



## 第三方库Twisted



支持异步网络编程和多数标准的网络协议(包含客户端和服务器)




## types库：
```
保存了所有数据类型名称。
if type(‘1111‘) == types.StringType:
MySQLdb库：
MySQLdb.get_client_info() 获取API版本
MySQLdb.Binary(‘string‘) 转为二进制数据形式
MySQLdb.escape_string(‘str‘) 针对mysql的字符转义函数
MySQLdb.DateFromTicks(1395842548) 把时间戳转为datetime.date对象实例
MySQLdb.TimestampFromTicks(1395842548) 把时间戳转为datetime.datetime对象实例
MySQLdb.string_literal(‘str‘) 字符转义
MySQLdb.cursor()游标对象上的方法：《python核心编程》P624
```
## atexit库：
```
atexit.register(fun,args,args2..) 注册函数func，在解析器退出前调用该函数
```
## string库
```
str.capitalize() 把字符串的第一个字符大写
str.center(width) 返回一个原字符串居中，并使用空格填充到width长度的新字符串
str.ljust(width) 返回一个原字符串左对齐，用空格填充到指定长度的新字符串
str.rjust(width) 返回一个原字符串右对齐，用空格填充到指定长度的新字符串
str.zfill(width) 返回字符串右对齐，前面用0填充到指定长度的新字符串
str.count(str,[beg,len]) 返回子字符串在原字符串出现次数，beg,len是范围
str.decode(encodeing[,replace]) 解码string,出错引发ValueError异常
str.encode(encodeing[,replace]) 解码string
str.endswith(substr[,beg,end]) 字符串是否以substr结束，beg,end是范围
str.startswith(substr[,beg,end]) 字符串是否以substr开头，beg,end是范围
str.expandtabs(tabsize = 8) 把字符串的tab转为空格，默认为8个
str.find(str,[stat,end]) 查找子字符串在字符串第一次出现的位置，否则返回-1
str.index(str,[beg,end]) 查找子字符串在指定字符中的位置，不存在报异常
str.isalnum() 检查字符串是否以字母和数字组成，是返回true否则False
str.isalpha() 检查字符串是否以纯字母组成，是返回true,否则false
str.isdecimal() 检查字符串是否以纯十进制数字组成，返回布尔值
str.isdigit() 检查字符串是否以纯数字组成，返回布尔值
str.islower() 检查字符串是否全是小写，返回布尔值
str.isupper() 检查字符串是否全是大写，返回布尔值
str.isnumeric() 检查字符串是否只包含数字字符，返回布尔值
str.isspace() 如果str中只包含空格，则返回true,否则FALSE
str.title() 返回标题化的字符串（所有单词首字母大写，其余小写）
str.istitle() 如果字符串是标题化的(参见title())则返回true,否则false
str.join(seq) 以str作为连接符，将一个序列中的元素连接成字符串
str.split(str=‘‘,num) 以str作为分隔符，将一个字符串分隔成一个序列，num是被分隔的字符串
str.splitlines(num) 以行分隔，返回各行内容作为元素的列表
str.lower() 将大写转为小写
str.upper() 转换字符串的小写为大写
str.swapcase() 翻换字符串的大小写
str.lstrip() 去掉字符左边的空格和回车换行符
str.rstrip() 去掉字符右边的空格和回车换行符
str.strip() 去掉字符两边的空格和回车换行符
str.partition(substr) 从substr出现的第一个位置起，将str分割成一个3元组。
str.replace(str1,str2,num) 查找str1替换成str2，num是替换次数
str.rfind(str[,beg,end]) 从右边开始查询子字符串
str.rindex(str,[beg,end]) 从右边开始查找子字符串位置 
str.rpartition(str) 类似partition函数，不过从右边开始查找
str.translate(str,del=‘‘) 按str给出的表转换string的字符，del是要过虑的字符

```
## urllib库：
```
urllib.quote(string[,safe]) 对字符串进行编码。参数safe指定了不需要编码的字符
urllib.unquote(string) 对字符串进行解码
urllib.quote_plus(string[,safe]) 与urllib.quote类似，但这个方法用‘+‘来替换‘ ‘，而quote用‘%20‘来代替‘ ‘
urllib.unquote_plus(string ) 对字符串进行解码
urllib.urlencode(query[,doseq]) 将dict或者包含两个元素的元组列表转换成url参数。
例如 字典{‘name‘:‘wklken‘,‘pwd‘:‘123‘}将被转换为”name=wklken&pwd=123″
urllib.pathname2url(path) 将本地路径转换成url路径
urllib.url2pathname(path) 将url路径转换成本地路径
urllib.urlretrieve(url[,filename[,reporthook[,data]]]) 下载远程数据到本地
filename：指定保存到本地的路径（若未指定该，urllib生成一个临时文件保存数据）
reporthook：回调函数，当连接上服务器、以及相应的数据块传输完毕的时候会触发该回调
data：指post到服务器的数据
rulrs = urllib.urlopen(url[,data[,proxies]]) 抓取网页信息，[data]post数据到Url,proxies设置的代理
urlrs.readline() 跟文件对象使用一样
urlrs.readlines() 跟文件对象使用一样
urlrs.fileno() 跟文件对象使用一样
urlrs.close() 跟文件对象使用一样
urlrs.info() 返回一个httplib.HTTPMessage对象，表示远程服务器返回的头信息
urlrs.getcode() 获取请求返回状态HTTP状态码
urlrs.geturl() 返回请求的URL
```
## re库：

一. 常用正则表达式符号和语法：
```
'.' 匹配所有字符串，除\n以外
‘-’ 表示范围[0-9]
'*' 匹配前面的子表达式零次或多次。要匹配 * 字符，请使用 \*。
'+' 匹配前面的子表达式一次或多次。要匹配 + 字符，请使用 \+
'^' 匹配字符串开头
‘$’ 匹配字符串结尾 re
'\' 转义字符， 使后一个字符改变原来的意思，如果字符串中有字符*需要匹配，可以\*或者字符集[*] re.findall(r'3\*','3*ds')结['3*']
'*' 匹配前面的字符0次或多次 re.findall("ab*","cabc3abcbbac")结果：['ab', 'ab', 'a']
‘?’ 匹配前一个字符串0次或1次 re.findall('ab?','abcabcabcadf')结果['ab', 'ab', 'ab', 'a']
'{m}' 匹配前一个字符m次 re.findall('cb{1}','bchbchcbfbcbb')结果['cb', 'cb']
'{n,m}' 匹配前一个字符n到m次 re.findall('cb{2,3}','bchbchcbfbcbb')结果['cbb']
'\d' 匹配数字，等于[0-9] re.findall('\d','电话:10086')结果['1', '0', '0', '8', '6']
'\D' 匹配非数字，等于[^0-9] re.findall('\D','电话:10086')结果['电', '话', ':']
'\w' 匹配字母和数字，等于[A-Za-z0-9] re.findall('\w','alex123,./;;;')结果['a', 'l', 'e', 'x', '1', '2', '3']
'\W' 匹配非英文字母和数字,等于[^A-Za-z0-9] re.findall('\W','alex123,./;;;')结果[',', '.', '/', ';', ';', ';']
'\s' 匹配空白字符 re.findall('\s','3*ds \t\n')结果[' ', '\t', '\n']
'\S' 匹配非空白字符 re.findall('\s','3*ds \t\n')结果['3', '*', 'd', 's']
'\A' 匹配字符串开头
'\Z' 匹配字符串结尾
'\b' 匹配单词的词首和词尾，单词被定义为一个字母数字序列，因此词尾是用空白符或非字母数字符来表示的
'\B' 与\b相反，只在当前位置不在单词边界时匹配
'(?P<name>...)' 分组，除了原有编号外在指定一个额外的别名 re.search("(?P<province>[0-9]{4})(?P<city>[0-9]{2})(?P<birthday>[0-9]{8})","371481199306143242").groupdict("city") 结果{'province': '3714', 'city': '81', 'birthday': '19930614'}
[] 是定义匹配的字符范围。比如 [a-zA-Z0-9] 表示相应位置的字符要匹配英文字符和数字。[\s*]表示空格或者*号。
```
二.常用的re函数：

| 方法/属性 | 作用 |
| ---- | ---- |
| re.match(pattern, string, flags=0) | 从字符串的起始位置匹配，如果起始位置匹配不成功的话，match()就返回none |
| re.search(pattern, string, flags=0) | 扫描整个字符串并返回第一个成功的匹配 |
| re.findall(pattern, string, flags=0) | 找到RE匹配的所有字符串，并把他们作为一个列表返回 |
| re.finditer(pattern, string, flags=0) | 找到RE匹配的所有字符串，并把他们作为一个迭代器返回 |
| re.sub(pattern, repl, string, count=0, flags=0) | 替换匹配到的字符串 |
## math库
```
ceil:取大于等于x的最小的整数值，如果x是一个整数，则返回x
copysign:把y的正负号加到x前面，可以使用0
cos:求x的余弦，x必须是弧度
degrees:把x从弧度转换成角度
e:表示一个常量
exp:返回math.e,也就是2.71828的x次方
expm1:返回math.e的x(其值为2.71828)次方的值减１
fabs:返回x的绝对值
factorial:取x的阶乘的值
floor:取小于等于x的最大的整数值，如果x是一个整数，则返回自身
fmod:得到x/y的余数，其值是一个浮点数
frexp:返回一个元组(m,e),其计算方式为：x分别除0.5和1,得到一个值的范围
fsum:对迭代器里的每个元素进行求和操作
gcd:返回x和y的最大公约数
hypot:如果x是不是无穷大的数字,则返回True,否则返回False
isfinite:如果x是正无穷大或负无穷大，则返回True,否则返回False
isinf:如果x是正无穷大或负无穷大，则返回True,否则返回False
isnan:如果x不是数字True,否则返回False
ldexp:返回x*(2**i)的值
log:返回x的自然对数，默认以e为基数，base参数给定时，将x的对数返回给定的base,计算式为：log(x)/log(base)
log10:返回x的以10为底的对数
log1p:返回x+1的自然对数(基数为e)的值
log2:返回x的基2对数
modf:返回由x的小数部分和整数部分组成的元组
pi:数字常量，圆周率
pow:返回x的y次方，即x**y
radians:把角度x转换成弧度
sin:求x(x为弧度)的正弦值
sqrt:求x的平方根
tan:返回x(x为弧度)的正切值
trunc:返回x的整数部分
```

