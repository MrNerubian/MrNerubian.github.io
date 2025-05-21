
### Windows 敏感文件列表  
| 绝对路径                              | 说明                       |
| --------------------------------- | ------------------------ |
| C:\Windows\System32\Config\SAM    | 存储用户账户密码哈希，可提取破解。        |
| C:\Windows\System32\Config\SYSTEM | 系统安全设置，配合SAM破解密码。        |
| C:\Users\<用户名>\NTUSER.DAT         | 用户配置文件，可注入恶意启动项。         |
| C:\PAGEFILE.SYS                   | 虚拟内存文件，含内存敏感数据（如密码哈希）。   |
| C:\Windows\System32\*.ini         | 系统/应用配置，含密码、数据库连接等信息。    |
| C:\Program Files\*\*.cfg          | 应用配置文件，含敏感参数（如API密钥）。    |
| *.lnk                             | 快捷方式文件，篡改后执行恶意程序。        |
| C:\HIBERFIL.SYS                   | 休眠文件，含系统状态数据，可提取敏感信息。    |
| C:\boot.ini                       | 启动参数配置，篡改后导致系统异常或执行恶意代码。 |
| C:\Windows\win.ini                | 系统配置文件，可注入恶意启动项。         |
| C:\Windows\msdos.sys              | 旧系统启动配置，篡改干扰启动流程。        |
| C:\Users\<用户名>\user.dat           | 用户个性化配置，可注入恶意启动项。        |
| C:\Windows\explorer.exe           | 系统文件管理器，漏洞/篡改可执行恶意代码。    |
| C:\Windows\cmd.exe                | 命令行工具，篡改后静默执行恶意命令。       |
| C:\Windows\regedit.exe            | 注册表编辑器，篡改后破坏系统配置或注入恶意项。  |
| C:\Windows\notepad.exe            | 文本编辑器，漏洞利用执行恶意代码。        |
| C:\Windows\winver.exe             | 系统版本工具，漏洞可执行任意代码。        |
| C:\Windows\rundll32.exe           | 动态链接库加载器，加载恶意DLL执行代码。    |


### Linux 敏感文件列表  
| 绝对路径                               | 说明               |
| ---------------------------------- | ---------------- |
| /etc/shadow                        | 用户加密密码           |
| /etc/passwd                        | 用户账户信息           |
| /etc/group                         | 用户组信息            |
| /etc/hosts                         | 域名解析配置           |
| /etc/crontab                       | 定时任务配置           |
| /etc/fstab                         | 文件系统挂载配置         |
| /etc/sudoers                       | sudo权限配置         |
| /etc/shells                        | 合法shell列表        |
| /etc/sysctl.conf                   | 内核参数配置           |
| /etc/ld.so.preload                 | 预加载动态库列表         |
| /etc/ssh/sshd_config               | SSH服务配置          |
| ~/.ssh/id_rsa                      | 用户SSH私钥          |
| ~/.ssh/authorized_keys             | 允许SSH登录的公钥列表     |
| /etc/httpd/conf/httpd.conf         | Apache全局配置       |
| /etc/apache2/apache2.conf          | Apache全局配置       |
| /etc/apache2/sites-available/*     | Apache虚拟主机配置     |
| /etc/apache2/.htpasswd             | Apache存储用户名密码的文件 |
| /etc/nginx/nginx.conf              | Nginx全局配置        |
| /etc/nginx/sites-enabled/default   | Nginx站点配置        |
| /etc/my.cnf                        | MySQL/MariaDB配置  |
| /var/lib/pgsql/data/pg_hba.conf    | PostgreSQL认证文件   |
| /var/log/syslog                    | 系统综合日志           |
| /var/log/messages                  | 系统消息日志           |
| /var/log/apache2/access.log        | Apache访问日。       |
| /var/log/apache2/error.log         | Apache错误日情。      |
| /var/log/nginx/access.log          | Nginx访问日。        |
| /var/log/nginx/error.log           | Nginx错误日。        |
| /var/log/auth.log                  | 认证日志（Ubuntu）     |
| /var/log/secure                    | 安全日志（CentOS）     |
| ~/.bash_history                    | 用户命令历史           |
| /var/log/sudo.log                  | sudo执行日志         |
| /etc/php.ini                       | PHP配置            |
| /var/www/phpmyadmin/config.inc.php | phpMyAdmin配置     |
| /etc/hostname                      | 主机名              |
| /proc/net/arp                      |                  |
| /proc/mounts                       | 挂载信息             |
| /proc/self/cmdline                 | 命令行信息            |
