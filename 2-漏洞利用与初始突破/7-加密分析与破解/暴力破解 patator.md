### **使用patator暴力破解SSH密码**

#### **1.下载并安装patator**

代码语言：javascript

代码运行次数：0

运行

AI代码解释

```javascript
git clone https://github.com/lanjelot/patator.gitcd patatorpython setup.py install
```

#### **2.使用参数**

执行./patator.py即可获取详细的帮助信息

> Patator v0.7(https://github.com/lanjelot/patator) Usage: patator.py module —help

可用模块:

```
ftp_login : 暴力破解FTP
ssh_login : 暴力破解 SSH
telnet_login : 暴力破解 Telnet
smtp_login : 暴力破解 SMTP
smtp_vrfy : 使用SMTP VRFY进行枚举
smtp_rcpt : 使用 SMTP RCPTTO枚举合法用户
finger_lookup : 使用Finger枚举合法用户
http_fuzz : 暴力破解 HTTP
ajp_fuzz : 暴力破解 AJP
pop_login : 暴力破解 POP3
pop_passd : 暴力破解 poppassd(http://netwinsite.com/poppassd/)
imap_login : 暴力破解 IMAP4
ldap_login : 暴力破解 LDAP
smb_login : 暴力破解 SMB
smb_lookupsid : 暴力破解 SMB SID-lookup
rlogin_login : 暴力破解 rlogin
vmauthd_login : 暴力破解 VMware Authentication Daemon
mssql_login : 暴力破解 MSSQL
oracle_login : 暴力破解 Oracle
mysql_login : 暴力破解 MySQL
mysql_query : 暴力破解 MySQLqueries
rdp_login : 暴力破解 RDP(NLA)
pgsql_login : 暴力破解PostgreSQL
vnc_login : 暴力破解 VNC
dns_forward : 正向DNS 查询
dns_reverse : 反向 DNS 查询
snmp_login : 暴力破解 SNMPv1/2/3
ike_enum : 枚举 IKE 传输
unzip_pass : 暴力破解 ZIP加密文件
keystore_pass : 暴力破解Java keystore files的密码
sqlcipher_pass : 暴力破解加密数据库SQL Cipher的密码-
umbraco_crack : Crack Umbraco HMAC-SHA1 password hashes
tcp_fuzz : Fuzz TCP services
dummy_test : 测试模块
```

#### **3.实战破解**

**（1）查看详细帮助信息**

执行“./patator.pyssh_login –help“命令后即可获取其参数的详细使用信息，如图7所示，在ssh暴力破解模块ssh_login中需要设置host，port，user，password等参数。

![](https://ask.qcloudimg.com/http-save/yehe-1268449/o7rdo7eo55.jpeg)

图7查看帮助信息

**（2）执行单一用户密码破解**

对主机192.168.157.131，用户root，密码文件为/root/newpass.txt进行破解，如图8所示，破解成功后会显示SSH登录标识“SSH-2.0-OpenSSH_7.5p1Debian-10“，破解不成功会显示” Authentication failed. “提示信息，其破解时间为2秒，速度很快！

代码语言：javascript

代码运行次数：0

运行

AI代码解释

```javascript
./patator.py ssh_login host=192.168.157.131user=root password=FILE0 0=/root/newpass.txt
```

![](https://ask.qcloudimg.com/http-save/yehe-1268449/o7rdo7eo55.jpeg)

图8破解单一用户密码

（3）破解多个用户。用户文件为/root/user.txt，密码文件为/root/newpass.txt，破解效果如图9所示。

代码语言：javascript

代码运行次数：0

运行

AI代码解释

```javascript
./patator.py ssh_login host=192.168.157.131user=FILE1 1=/root/user.txt password=FILE0 0=/root/newpass.txt
```

![](https://ask.qcloudimg.com/http-save/yehe-1268449/tzl3ie60te.jpeg)

图9使用patator破解多用户的密码