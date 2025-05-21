![[[85c2461334c84adaa2a29a97dfa0fabf.png](https://img-blog.csdnimg.cn/85c2461334c84adaa2a29a97dfa0fabf.png#pic_center)]

Ncrack是一个网络认证破解的开源工具。它是专为高速平行开裂使用动态引擎，可以适应不同的网络情况。对于特殊情况，Ncrack也可以进行广泛的微调，尽管默认参数通用性足以涵盖几乎所有情况。它建立在模块化架构上，可以轻松扩展以支持其他协议。Ncrack专为企业和安全专业人员以快速可靠的方式审核大型网络的默认或弱密码。它也可以用来对个别服务进行相当复杂和强烈的暴力攻击。

Ncrack的输出是为每个指定的目标找到的证书列表（如果有的话）。Ncrack还可以打印到目前为止的交互式状态报告，如果用户选择了该选项，可能还会附加一些调试信息来帮助跟踪问题。

## 用法：

ncrack [Options] {target and service specification}

ncrack [选项] {目标和服务规格}

**目标规格：**

可以通过主机名，IP地址，网络等

例如：scanme.nmap.org，microsoft.com/24,192.168.0.1; 10.0.0-255.1-254

-iX <输入文件名>：从Nmap的-oX XML输出格式输入

-iN <输入文件名>：从Nmap的-oN正常输出格式输入

-iL <输入文件名>：从主机/网络列表中输入

--exclude<host1 [，host2] [，host3]，...>：排除主机/网络

--excludefile <exclude_file>：从文件中排除列表

**服务规格：**

可以通过<service>：// target（标准）表示法或者使用-p将以非标准符号应用于所有主机。

可以将服务参数指定为主机特定的，特定于服务的类型（-m）或全局（-g）。

例如：ssh：//10.0.0.10,at=10,cl=30 -m ssh：at = 50 -g cd = 3000

例2：ncrack -p ssh，ftp：3500,25 10.0.0.10 scanme.nmap.org google.com:80,ssl

-p <服务列表>：服务将被应用于所有非标准的符号主机

-m <服务>：<选项>：选项将应用于此类型的所有服务

-g <选项>：选项将应用于全局的每个服务

**其他选项：**

ssl：通过此服务启用SSL

path <name>：用于模块像HTTP（'='需要转义，如果使用）

**时间和性能：**

采取<time>的选项是以秒为单位的，除非你附加'ms'  （毫秒），“m”（分钟）或“h”（小时）的值（例如30m）。

特定于服务的选项：

cl（最小连接限制）：最小并发并行连接数

CL（最大连接限制）：并行并行连接的最大数量

at（身份验证尝试）：每个连接的身份验证尝试

cd（连接延迟）：每个连接启动之间的延迟<time>

cr（连接重试）：服务连接尝试次数上限

to（超时）：服务的最大开发<时间>，不管迄今为止成功

-T <0-5>：设定时间模板（越快越快）

--connection-limit <number>：总并发连接的阈值

**认证：**

-U <文件名>：用户名文件

-P <文件名>：密码文件

--user <username_list>：逗号分隔的用户名单

--pass <password_list>：逗号分隔的密码列表

--passwords-first：迭代每个用户名的密码列表。默认是相反的。

--pairwise：成对选择用户名和密码。

**OUTPUT：**

-oN / -oX <文件>：分别以正常和XML格式输出扫描到给定的文件名。

-oA <basename>：一次输出两种主要格式

-v：增加详细程度（使用两次或更多效果更好）

-d [级别]：设置或增加调试级别（最多10个有意义）

--nsock-trace <level>：设置nsock跟踪级别（有效范围：0 - 10）

--log-errors：将错误/警告记录到正常格式的输出文件

--append-output：附加到指定的输出文件而不是clobber

**MISC：**

--resume <file>：继续先前保存的会话

--save<file>：保存具有特定文件名的恢复文件

-f：在找到一个证书后退出服务

-6：启用IPv6破解

-sL或--list：只列出主机和服务

--datadir <dirname>：指定自定义Ncrack数据文件位置

--proxy <type：// proxy：port>：通过socks4，4a，http进行连接。

-V：打印版本号

-h：打印此帮助摘要页面。

**模块：**

FTP，SSH，Telnet，HTTP（S），POP3（S），SMB，RDP，VNC，SIP，Redis，PostgreSQL，MySQL

## 例子

1. ncrack -v --user root localhost：22  

1. ncrack -v -T5 https://192.168.0.1  

1. ncrack -v -iX〜/ nmap.xml -g CL = 5，to = 1h  

1. ncrack -v https://www.fujieace.com  

[![ncrack -v https://www.fujieace.com](https://www.fujieace.com/wp-content/uploads/2017/11/300.png?x61917)](https://www.fujieace.com/wp-content/uploads/2017/11/300.png?x61917)

**一个有代表性的Ncrack扫描**

1. ncrack 10.0.0.130:21 192.168.1.2:22  

> 在2016-01-03 22:10开始Ncrack 0.6（http://ncrack.org）EEST
> 
> 发现10.0.0.130上的ftp证书21 / tcp：
> 
> 10.0.0.130 21 / tcp ftp：admin hello1
> 
> 在192.168.1.2 22 / tcp上发现了ssh的证书：
> 
> 192.168.1.2 22 / tcp ssh：guest 12345
> 
> 192.168.1.2 22 / tcp ssh：admin money $
> 
> Ncrack完成：在156.03秒扫描了2个服务。
> 
> Ncrack完成了。

### ncrack效果与评价：

此软件可以说是非常的不错，从上面最后一个示例就可以看出来。此软件并不是万能的，只要你的网站做了一定的安全措施，此工具对你扫描是没有什么太大的效果。

更多内容：https://nmap.org/ncrack/man.html