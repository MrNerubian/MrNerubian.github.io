原文链接：
https://www.cnblogs.com/M0urn/articles/17761218.html
参考文章：  
[https://www.freebuf.com/articles/database/266738.html](https://www.freebuf.com/articles/database/266738.html)  
[https://blog.csdn.net/qq_43431158/article/details/108904536](https://blog.csdn.net/qq_43431158/article/details/108904536)
https://mp.weixin.qq.com/s/iwmt5vwiksrtW-4oYaHUUQ

在kali Linux2020之前的版本中都自带该工具，其他版本安装该工具都存在各种难以言喻的bug，所以我直接装了一个kali2019的虚拟机

# 使用方法

### 命令格式

```powershell
volatility -f [image] ‐-profile=[profile][plugin] 命令

其中 -f 后面加的是要取证的文件， --profile 后加的是工具识别出的系统版本， [plugin] 是指使用的插件，其中默认存在一些插件，另外还可以自己下载一些插件扩充
```

常用的命令

```powershell
volatility -f xxx imageinfo
#使用imageinfo插件来猜测dump文件的profile值，一般是取证分析的第一步
volatility -f xxx --profile=xxx pslist
#指定profile值,使用pslist去列举系统进程
volatility cmdscan -f xxx --profile=xxx
#查看历史命令
volatility iehistory -f xxx --profile=xxx
#查看IE历史信息
volatility -f mem.raw --profile=Win7SP0x86 screenshot --dump-dir=./
#查看截图
```

### 关于volatility的一些常用命令：

**imageinfo**

识别操作系统：

```powershell
volatility -f example.raw imageinfo
```

**pslist/pstree/psscan**

扫描进程：

```powershell
volatility -f example.raw --profile=Win7SP1x64 pslist  #win7SP1x64为操作系统
```

**filescan**

扫描文件：

```perl
volatility -f example.raw --profile=Win7SP1x64 filescan | grep -E 'txt|png|jpg|gif|zip|rar|7z|pdf|doc'
volatility -f example.raw --profile=Win7SP1x64 filescan | grep TMP_User   #搜索指定文件夹下的文件
```

**Dumpfiles**

```haskell
volatility -f wuliao.data --profile=Win7SP1x64 dumpfiles -Q 0x000000007f142f20 -D ./ -u
```

**cmdscan**

#查看终端输入历史

**dumpfile/memdump**

导出文件：

```powershell
volatility -f example.raw --profile=Win7SP1x64 memdump -p [PID] -D ./   # -D ./  导出到当前目录

or

volatility -f example.raw --profile=Win7SP1x64 dumpfiles -Q [Offset] -D ./
```

**调用插件**

```lua
volatility [plugins] -f example.raw --profile=Win7SP1x64
```

##### 提取内存中保留的 cmd 命令使用情况

```lua
volatility -f mem.vmem --profile=WinXPSP2x86 cmdscan
```

##### 获取到当时的网络连接情况

```haskell
volatility -f mem.vmem --profile=WinXPSP2x86 netscan
#分析计算机内存镜像，以下哪个远程地址与本地地址建立过 TCP 连接  一般不使用插件而使用本命令
```

##### 获取 IE 浏览器的使用情况。

```lua
volatility -f mem.vmem --profile=WinXPSP2x86 iehistory
```

##### hivelist：查看缓存在内存的注册表

```lua
volatility -f bb.raw --profile=Win7SP1x86 hivelist
```

##### userassist:提取出内存中记录的 当时正在运行的程序有哪些，运行过多少次，最后一次运行的时间等信息

```lua
volatility -f bb.raw --profile=Win7SP1x86 userassist
```

##### 获取内存中的系统密码，我们可以使用 hashdump 将它提取出来

```cpp
volatility -f mem.vmem --profile=WinXPSP2x86 hashdump -y （注册表 system 的 virtual 地址 ）-s （SAM 的 virtual 地址）

volatility -f mem.vmem --profile=WinXPSP2x86 hashdump -y 0xe1035b60 -s 0xe16aab60
```

##### printkey: 获取SAM表中的用户

```powershell
比如：volatility -f mem.vmem –-profile=WinXPSP2x86  printkey  -K  “SAM\Domains\Account\Users\Names” 
发现账户四个用户，分别为：
Administrator 
Guest 
HelpAssistant
SUPPORT_388945a0
```

##### hashdump:获取内存中的系统密码

```lua
volatility -f bb.raw --profile=Win7SP1x86 hashdump
```

##### 最大程度上将内存中的信息提取出来，那么你可以使用 timeliner 这个插件。它会从多个位置来收集系统的活动信息

```powershell
volatility -f mem.vmem --profile=Win7SP1x86 timeliner
volatility -f mem.vmem --profile=Win7SP1x86 timeliner | grep Company_Files #查找指定文件夹下的文件的访问详细情况，可以导出 > 文件
```

#这个可以看到谁谁谁在什么时候做了什么 ，一般导出的数据很多，可以导入进文件中，之后搜索查找

#若无法找到此文件夹下某些文件或文件夹的访问记录，我们可以通过dump访问此文件夹的进程，然后使用strings语句进行查找关键字

#例如 strings 3484.dmp | grep 'Stephen'

##### getsids：查看SID

```lua
volatility -f bb.raw --profile=Win7SP1x86_23418 getsids
```

#查看到的用户sid 可能分散在四处，仔细找

### 常见的插件

##### 查看当前展示的 notepad 文本

```vhdl
volatility notepad -f file.raw --profile=WinXPSP2x86
```

##### 查看当前操作系统中的 password hash，例如 Windows 的 SAM 文件内容

```vhdl
volatility hashdump -f file.raw --profile=WinXPSP2x86
```

##### 查看所有进程

```vhdl
volatility psscan -f file.raw --profile=WinXPSP2x86
```

##### 扫描所有的文件列表

```vhdl
volatility filescan -f file.raw --profile=WinXPSP2x86
```

##### 扫描 Windows 的服务

```vhdl
volatility svcscan -f file.raw --profile=WinXPSP2x86
```

##### 查看网络连接

```vhdl
volatility connscan -f file.raw --profile=WinXPSP2x86
```

##### 查看命令行上的操作

```vhdl
volatility cmdscan -f file.raw --profile=WinXPSP2x86
```

##### 根据进程的 pid dump出指定进程到指定的文件夹dump_dir

```vhdl
volatility memdump -p 120 -f file.raw --profile=WinXPSP2x86 --dump-dir=dump_dir
```

dump 出来的进程文件，可以使用 foremost 来分离里面的文件，用 binwak -e 经常会有问题，需要重新修复文件

##### 对当前的窗口界面，生成屏幕截图

```mipsasm
volatility screenshot -f file.raw --profile=WinXPSP2x86 --dump-dir=out
```

### 一些思路

#### 1.计算机安装windows的时间

在Microsoft路径下寻找系统信息。

```x86asm
volatility -f  memdump.mem --profile=Win7SP1x86_23418 -o 0x8bd898e8 printkey -K "WOW6432Nod\Microsoft"
```

printkey: 打印注册表项及其子项和值

`-o` 指定注册表的virtual地址

一般系统信息存在于

我们可以指定`-o virtual`地址去printkey 获取key

之后一步一步来即可

InstalledDate对应的键值，但是可以通过Last updated进行大致判断。正常的系统信息会记录在如下路径：(HKEY_LOCAL_MACHINESOFTWAREMicrosoftWindows NTCurrentVersionInstallDate）。

#### 2.计算机名称

在注册表SYSTEM里面存在计算机名称

具体位置：ControlSet001\Control\ComputerName\ComputerName

我们可以使用命令：

```x86asm
volatility -f memdump.mem  --profile=Win7SP1x86_23418 -o 0x8bc1a1c0 printkey -K "ControlSet001\Control\ComputerName\ComputerName"
```

#### 3.查看tcp

```lua
volatility -f memdump.mem  --profile=Win7SP1x86_23418  timeliner | grep TCP
```

#### 4.外接存储设备的取证 -USB

1.首先使用命令volatility -h | grep service查找与设备相关的命令。

```perl
volatility -h | grep service
```

2.然后使用设备扫描命令查询是否有USB使用痕迹。

```lua
volatility -f memdump.mem --profile=Win7SP1x86_23418 svscan | grep usb
```

3.在虚拟地址内存中查找key，在注册表中查询USB设备使用情况（注册表中与USB设备相关的路径为：ControlSet001\Enum\USBSTOR

路径：ControlSet001\Enum\USBSTOR

使用命令：

```x86asm
volatility -f memdump.mem --profile=Win7SP1x86_23418  -o 0x8bc1a1c0 printkey -K "ControlSet001\Enum\USBSTOR"
```

### 了解几个文件后缀

```bash
vmem文件
#表示虚拟内存文件，与pagefile.sys相同
raw文件
#raw文件是内存取证工具Dumpit提取内存生成的内存转储文件
```

# 实验一:Vmem文件分析

使用了https://blog.csdn.net/m0_68012373/article/details/127394375这个博客提供的题目文件

题目要求：

你作为 A 公司的应急响应人员，请分析提供的内存文件按照下面的要求找到 相关关键信息，完成应急响应事件。

> 1、从内存中获取到用户admin的密码并且破解密码，以Flag{admin,password} 形式提交(密码为 6 位)；  
> 2、获取当前系统 ip 地址及主机名，以 Flag{ip:主机名}形式提交；  
> 3、获取当前系统浏览器搜索过的关键词，作为 Flag 提交；  
> 4、当前系统中存在挖矿进程，请获取指向的矿池地址，以 Flag{ip:端口}形式 提交；  
> 5、恶意进程在系统中注册了服务，请将服务名以 Flag{服务名}形式提交。

拿到以后首先看一下镜像信息，不管什么题内存取证的第一步肯定是去判断当前的镜像信息，分析出是哪个操作系统

```powershell
volatility -f worldskills3.vmem imageinfo
```

![](https://minioapi.nerubian.cn/image/20250408144657143.png)

获取到操作系统，就可以用这个profile参数来进行后续操作

## 任务1.获取admin用户明文密码

根据题目要求，首先获取用户信息，这里可以直接查询注册表来获取信息

```powershell
volatility -f worldskills3.vmem --profile=Win7SP1x64 printkey -K "SAM\Domains\Account\Users\Names"
```

![](https://minioapi.nerubian.cn/image/20250408144713322.png)

然后可以使用lsadump模块来查看密码

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 lsadump
```

![](https://minioapi.nerubian.cn/image/20250408144715760.png)

里面的是password，解一下md5

![](https://minioapi.nerubian.cn/image/20250408144719558.png)

所以第一个flag为`flag{admin,dfsddew}`

## 任务2.获取当前系统 ip 地址及主机名

第二题可以使用netscan模块获取

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 netscan
```

![](https://minioapi.nerubian.cn/image/20250408144722344.png)

本机ip为`192.168.85.129`

主机名可以通过查看注册表信息获取，先列出注册表

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 hivelist
```

![](https://minioapi.nerubian.cn/image/20250408144725708.png)

然后需要一步一步去找键名

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 -o 0xfffff8a000024010 printkey
```

![](https://minioapi.nerubian.cn/image/20250408144728479.png)

```x86asm
volatility -f worldskills3.vmem --profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001"
```

![](https://minioapi.nerubian.cn/image/20250408144735131.png)

```x86asm
volatility -f 1.vmem --profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001\Control"
```

![](https://minioapi.nerubian.cn/image/20250408144731224.png)

```x86asm
volatility -f worldskills3.vmem --profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001\Control\ComputerName"
```

![](https://minioapi.nerubian.cn/image/20250408144737834.png)

```x86asm
volatility -f worldskills3.vmem --profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001\Control\ComputerName\ComputerName"
```

![](https://minioapi.nerubian.cn/image/20250408144740487.png)

获得主机名，得到第二个flag：`flag{192.168.85.129:WIN-9FBAEH4UV8C}`

## 任务3.获取当前系统浏览器搜索过的关键词

可以用iehistory模块

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 iehistory
```

![](https://minioapi.nerubian.cn/image/20250408144742821.png)

第三个flag：`flag{admin@file:///C:/Users/admin/Desktop/flag.txt}`

## 任务4.获取挖矿进程指向的矿池地址

依旧是使用netscan模块，看一下外连的进程即可

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 netscan
```

![](https://minioapi.nerubian.cn/image/20250408144745046.png)

正在外连的进程，可以看到ip为`54.36.109.161:2222`

所以第四个flag为`flag{54.36.109.161:2222}`

## 任务5.获取恶意进程在系统中注册的服务名

进程pid上一个任务中已经得知，是2588，所以我们pslist模块中查一下

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 pslist -p 2588
```

![](https://minioapi.nerubian.cn/image/20250408144747566.png)

得知父进程pid为3036，再看看

![](https://minioapi.nerubian.cn/image/20250408144749784.png)

再上一级就是系统的进程了。这里我们再使用svcscan去查询服务名称，找到对应服务名

```lua
volatility -f worldskills3.vmem --profile=Win7SP1x64 svcscan
```


![](https://minioapi.nerubian.cn/image/20250408144751488.png)

服务名为VMnetDHCP，所以最后一个flag为`flag{VMnetDHCP}`
