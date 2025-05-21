# 基于nmap扫描结果的端口爆破工具:BrutesPray
[![http://p2.qhimg.com/t01364a0c5c7f271e70.png](http://p2.qhimg.com/t01364a0c5c7f271e70.png "t01364a0c5c7f271e70.png")](http://p2.qhimg.com/t01364a0c5c7f271e70.png)

BruteSpray是一款基于nmap扫描输出的gnmap/XML文件.自动调用Medusa对服务进行爆破(Medusa美杜莎 是一款端口爆破工具,速度比Hydra九头蛇快)。

BruteSpray甚至可以通过Nmap –sV参数的扫描找到非标准端口。

官方地址：
```
https://github.com/x90skysn3k/brutespray
```

支持爆破的服务：
```
ssh,ftp,telnet,vnc,mssql,mysql,postgresql,rsh,imap,nntp,pcanywhere,pop3,rexec,rlogin,smbnt,smtp,svn,vmauthd
```

#### **1.安装**

BruteSpray默认没有集成到kali Linux中，需要手动安装，有的需要先在kali中执行更新，apt-get update 后才能执行安装命令：

```sh
apt-getinstall brutespray
```

kali Linux默认安装其用户和密码字典文件位置：/usr/share/brutespray/wordlist。

#### **2.BrutesPray使用参数**

用法: 
```
brutespray [-h] -f FILE [-o OUTPUT] [-sSERVICE] [-t THREADS] [-T HOSTS] [-U USERLIST] [-P PASSLIST] [-u USERNAME] [-pPASSWORD] [-c] [-i]
```

菜单选项:

```
-f FILE, —file FILE 参数后跟一个文件名, 解析nmap输出的GNMAP或者XML文件
-o OUTPUT, —output OUTPUT 包含成功尝试的目录
-s SERVICE, —service SERVICE 参数后跟一个服务名, 指定要攻击的服务
-t THREADS, —threads THREADS 参数后跟一数值,指定medusa线程数
-T HOSTS, —hosts HOSTS 参数后跟一数值,指定同时测试的主机数
-U USERLIST, —userlist USERLIST 参数后跟用户字典文件
-P PASSLIST, —passlist PASSLIST 参数后跟密码字典文件
-u USERNAME, —username USERNAME 参数后跟用户名,指定一个用户名进行爆破
-p PASSWORD, —password PASSWORD 参数后跟密码,指定一个密码进行爆破
-c, —continuous 成功之后继续爆破
-i, —interactive 交互模式
```

#### **3.使用nmap进行端口扫描**

**（1）扫描整个内网C段**

```sh
nmap -sV 192.168.17.0/24 -oX nmap.xml
```

**（2）扫描开放22端口的主机**

```sh
nmap -A -p 22 -v 192.168.17.0/24 -oX 22.xml
```

**（3）扫描存活主机**

```sh
nmap –sP 192.168.17.0/24-oX nmaplive.xml
```

**(4)扫描应用程序以及版本号**

```sh
nmap  -sV –O 192.168.17.0/24 -oX nmap.xml
```
#### **4.暴力破解SSH密码**

**（1）交互模式破解**

```sh
brutespray --file nmap.xml –i
```

执行后，程序会自动识别nmap扫描结果中的服务，根据提示选择需要破解的服务，线程数、同时暴力破解的主机数，指定用户和密码文件，如图 10所示。Brutespray破解成功后在屏幕上会显示“SUCCESS ”信息。

![](https://ask.qcloudimg.com/http-save/yehe-1268449/7aybwpx8yy.jpeg)

图10交互模式破解密码

**（2）通过指定字典文件爆破SSH**

```sh
brutespray --file 22.xml -U /usr/share/brutespray/wordlist/ssh/user -P/usr/share/brutespray/wordlist/ssh/password --threads 5 --hosts 5
```

注意:

brutespray新版本的wordlist地址为/usr/share/brutespray/wordlist，其下包含了多个协议的用户名和密码，可以到该目录完善这些用户文件和密码文件。

**（3）暴力破解指定的服务**

```sh
brutespray --file nmap.xml --service ftp,ssh,telnet --threads 5 --hosts 5
```

**（4）指定用户名和密码进行暴力破解**

当在内网已经获取了一个密码后，可以用来验证nmap扫描中的开放22端口的服务器，如图11所示，对192.168.17.144和192.168.17.147进行root密码暴力破解，192.168.17.144密码成功破解。

```sh
brutespray -f 22.xml -u root -p toor --threads 5 --hosts 5
```

![](https://ask.qcloudimg.com/http-save/yehe-1268449/4apx9ye2ew.jpeg)

图11 对已知口令进行密码破解

**（5）破解成功后继续暴力破解**

```sh
brutespray --file nmap.xml--threads 5 --hosts 5 –c
```

前面的命令是默认破解成功一个帐号后，就不再继续暴力破解了,此命令是对所有账号进行暴力破解，其时间稍长。

**（6）使用Nmap扫描生成的nmap.xml进行暴力破解**

```sh
brutespray --file nmap.xml --threads 5 --hosts 5
```

#### **5.查看破解结果**

Brutespray这一点做的非常好，默认会在程序目录/brutespray-output/目录下生成ssh-success.txt文件，使用cat ssh-success.txt命令即可查看破解成功的结果，如图12所示。

![](https://ask.qcloudimg.com/http-save/yehe-1268449/ikhrc2n19g.jpeg)

图12查看破解成功的记录文件

也可以通过命令搜索ssh-success 文件的具体位置：find / -name ssh-success.txt






