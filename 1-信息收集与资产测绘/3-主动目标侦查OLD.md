# 1 nmap经典四次扫描

## nmap 端口扫描（第一扫）
```
sudo nmap -sS --min-rate 10000 -p- <ip address> -oA <nmapscan_ports>

NmapPorts=`grep portid nmapscan_ports.xml|awk -F'/' '{print $1}'|paste -sd ','`
    
sudo nmap -sT --min-rate 10000 -p- <ip address>|grep open|awk -F'/' '{print $1}'|paste -sd ','
    
NmapPorts=`grep portid nmapscan/ports.xml|awk -F'"' '{print $4}'|paste -sd ','`

echo $NmapPorts
```
## nmap 详细扫描（第二扫）
```
sudo nmap -sS -sV -sC -O --version-all -p$NmapPorts <ip address> -oA <nmapscan_detail>
```
## nmap UDP扫描（第三扫）
```
sudo nmap -sU --top-ports 20  <ip address> -oA <nmapscan_udp>
```
## nmap 脚本扫描（第四扫）
```
sudo nmap --script=vuln -p$NmapPorts <ip address> -oA <nmapscan_vuln>

sudo nmap --script=vuln -sU -p$NmapPorts <ip address> -oA <nmapscan_vuln>
```

```bash
sudo nmap --script "smb-vuln*,http-vuln*,ssl-*,vulscan,vulners" -p$NmapPorts <ip address> -oA <nmapscan_vuln>
```
## nmap隐蔽扫描

隐蔽式端口扫描（无Ping扫描+随机化扫描顺序+限制扫描速率）
```bash
sudo nmap -sS -Pn --min-rate 500 --randomize-hosts -p- 10.10.11.44 -oA scan_stealth
```



|                         |                                                                                                                                |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| 随机扫描延迟                  | nmap -T2 --max-rtt-timeout 500ms --scan-delay random                                                                           |
| 通过代理扫描                  | proxychains nmap -sT -Pn 10.10.11.44                                                                                           |
| 使用随机User-Agent与冗余Header | nmap -p80 --script http-headers --script-args http.useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36..." |
| Payload编码混淆​            | sqlmap -u "http://target.com?id=1" --tamper=hexencode                                                                          |
| 禁用ICMP协议（ping）          | -Pn                                                                                                                            |
| 随机化扫描顺序                 | --randomize-hosts                                                                                                              |
| 限制扫描速率                  | --min-rate 500                                                                                                                 |

## nmap4scan.sh
```
#/bin/bash
#nmap四次一键脚本

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "# \$1: target ip"
  echo "# \$2: scan log dir"
  exit
elif [ -z "$1" ]; then
  echo "ERROR! You need to add the parameters."
  echo "# \$1: target ip"
  echo "# \$2: scan log dir"
  exit
fi

echo "|------< 创建存储目录 >------|"
mkdir -p $2
ls $2

echo "|------< 执行扫描命令 >------|"
#NO.1
echo "| Nmap Scan NO.1 ports >----------|"
nmap -sT -Pn --min-rate 5000 -p- $1 -oN $2/nmap4scan_1_ports

NmapPorts=`grep open $2/nmap4scan_1_ports|awk -F'/' '{print $1}'|paste -sd ','`

#NO.2
echo "| Nmap Scan NO.2 detail >---------|"
nmap -sT -sV -sC -O -p $NmapPorts $1 -oN $2/nmap4scan_2_detail

#NO.3
echo "| Nmap Scan NO.3 udp >------------|"
nmap -sU --top-ports 30  $1 -oN $2/nmap4scan_3_udp

#NO.4
echo "| Nmap Scan NO.4 vuln >-----------|"
nmap --script=vuln -p $NmapPorts $1 -oN $2/nmap4scan_4_vuln

echo "|------< 脚本执行完成 >------|"
echo "|------< 扫描报告目录： >------|"
echo "|nmap4scan_log_dir: $2/"
```

nerubianScan
```bash


```
更多nmap参数请查看：

[nmap命令参数详解](https://www.nerubian.cn/archives/53703b1e-4936-4c26-8e95-0d11fed69598)

https://blogs.sans.org/pen-testing/files/2013/10/NmapCheatSheetv1.1.pdf

https://www.nerubian.cn/archives/3a935015-6c6e-4452-86b7-3261902a6d99



## Template - 启发式内网扫描

https://github.com/1n7erface/Template

## 0x02 工具优势

- 所有模块皆采用生产者消费者模型,即生即消.

> 在端口扫描一组数据后将数据发送到队列中,由爆破模块和指纹模块即刻进行消费,随时结束扫描进程拿到扫描结果.摆脱传统的等待端口扫描结束进行后续的模型.

- 所有模块皆采用启发式扫描,诣在最少的发包探测目标

> 在端口扫描时,通过协议识别的方式识别TOP15协议,对其协议进行探测.漏洞探测是通过对WEB指纹进行识别后进行探测.摆脱传统的端口绑定以及漏洞探测发包量大的问题.

- 强大的WEB指纹支撑

> 感谢棱角社区对本工具WEB指纹的支撑、目前指纹900+,指纹识别快人一步.

- 极致的应用并发

> 在爆破模块以及漏洞探测、指纹识别、端口扫描所有模块采用数据原子化的方式进行极致的并发.

## 0x03 参数说明


```
❯ ./App-arm64darwin-noupx

 _____                    _       _
|_   _|                  | |     | |
  | | ___ _ __ ___  _ __ | | __ _| |_ ___
  | |/ _ \ '_'  _ \| '_ \| |/ _' | __/ _ \
  | |  __/ | | | | | |_) | | (_| | ||  __/
  \_/\___|_| |_| |_| .__/|_|\__,_|\__\___|
                   | |  by 1n7erface
                   |_|
[=] Load Success 
Usage of ./App-arm64darwin-noupx:
  -bt int
    	BruteModule threadNum (default 200)
  -c string
    	auto check 192 or 172 or 10
  -e	print error log
  -i string
    	IP address of the host you want to scan,for example: 192.168.11.11-255 or 192.168.1.1/24 or /22 /15...
  -it int
    	InfoModule threadNum (default 200)
  -nobrute
    	skip brute
  -noping
    	skip icmp alive
  -nopoc
    	skip poc
  -o string
    	output file name (default "output.txt")
  -onping
    	only ping
  -p string
    	custom port example: 80,8088,1-3000
  -pw string
    	Define a password dictionary for blasting
  -t int
    	Timeout (default 4)
  -us string
    	Define a user dictionary for blasting
[=] end...... 
```

- bt参数说明

> 此参数期望接收一个数值类型,用于爆破模块开启的协程数量,默认的数量为200

- c参数说明

> 此参数期望接收一个字符串，存在于"192、172、10"三个字符串之间,程序会自动的探测网段存活，并对其进行扫描。包括192的192.168.0.1-192.168.255.255、172的172.16.0.1-172.31.255.255、10的10.0.0.1-10.255.255.255.值得一提的是,网段探测存活的算法是从每一个c段选择1,255 以及期间的随机3个ip进行检测,如果一个存活将判定为网段存活.在一定几率下存在漏段的可能无法避免.(10段不建议使用,网段太大可能产生预期之外的错误).

- e参数说明

> 此参数不接收任何值,打印期间的错误日志,用于排查扫描的问题.

- i参数说明

> 此参数接收一个字符串,字符串用于声明要扫描的网段,例如192.168.11.11-255 or 192.168.1.1/24 or /22 /15... ,此参数支持CIDR的表达式.

- it参数说明

> 此参数期望接收一个数值类型,用于信息探测模块开启的协程数量,例如ip存活、端口扫描、web指纹.

- nobrute参数说明

> 此参数不接收任何值,不对信息探测的结果进行暴力破解模块.

- noping参数说明

> 此参数不接收任何值,在目标网段不支持ICMP协议时,通过TCP进行探测.

- nopoc参数说明

> 此参数不接收任何值,不对探测的WEB服务进行漏洞探测的模块.

- o参数说明

> 此参数接收一个字符串,用于对结果保存的文件名称,默认为output.txt.

- onping参数说明

> 此参数不接收任何值,对目标网段只进行ICMP的ip存活探测,其余一律不做.

- p参数说明

> 此参数接收一个字符串,指定端口扫描的端口.例如,80,8088,1-3000 (注:此参数一经指定则不进行程序自带端口的扫描)

- pw参数说明

> 此参数接收一个字符串,指定爆破的密码字典,例如 -pw ffnxjfl123,fgmgergn334 （注:此参数一经指定则不进行程序自带密码的扫描)

- t参数说明

> 此参数期望接收一个数值类型,用于在漏洞扫描,WEB识别时的超时时间设置.

- us参数说明

> 此参数期望接收一个字符串,指定爆破的用户名字典,例如 -us fwefwf,fwefwf (注:此参数一经指定则不进行程序自带用户名的扫描)

- 如果想指定端口、爆破的用户名和密码并且仍然使用程序自带的端口、密码、用户名进行扫描.可以在当前程序的同级目录上传名为"config.json"的文件

> 内容为: {"pass":["ffnxjfl123","fgmgergn334"],"user":["fwefwf","fwefwf"],"ports":[9999,8888]}
# 2 WEB信息收集

## 2.1 页面审计

### 技术栈识别

#### 浏览器插件：Wappalyzer

- https://chromewebstore.google.com/detail/wappalyzer-technology-pro/gppongmhjkpfnbhagpmjfkannfbllamg?utm_source=ext_app_menu

#### Whatweb

[指纹识别工具WhatWeb使用教程，图文教程（超详细）-CSDN博客](https://blog.csdn.net/wangyuxiang946/article/details/130793160)

使用命令行工具 whatweb 提取 web 服务器、支持框架和应用程序的版本

```
whatweb http://192.168.56.104/textpattern/
```

#### `wapiti` 自动化WEB漏洞扫描：

```bash
sudo wapiti -u http://192.168.223.131
```
#### enum4linux
- **功能**：枚举 Windows 网络信息（含 DNS 相关）。
- **常用参数**：
```bash
sudo enum4linux -D http://192.168.56.104/textpattern/
```

#### `builtwith`库识别框架版本：

```bash
python3 -m pip install builtwith && builtwith http://192.168.56.104/textpattern/index.php
```


### 检查页面内容

Firefox Debugger 工具（在 Web Developer 菜单中找到，或通过按 Ctrl Shift K 键）显示页面的资源和内容，这会因应用程序而异。

Debugger 工具可能会显示 JavaScript 框架、隐藏的输入字段、注释、HTML 中的客户端控件、JavaScript 等等。为了证明这一点，我们可以在浏览 www.megacorp.one 时打开 Debugger


### 查看响应标头

Firefox Web Developer菜单启动的网络工具，以查看HTTP请求和响应

curl 查看请求头
```
curl -IL https://www.RedteamNotes.com
```

### 检查网站地图

使用curl从www.google.com检索robots.txt文件
```
curl -IL https://www.RedteamNotes.com/robots.txt
```
### 证书

如果正在使用 HTTPS，SSL/TLS 证书是另一个潜在的宝贵信息来源。浏览到

https://10.10.10.10/ 并查看证书会显示详细信息，往往包括电子邮件地址和公司名称。

如果这在评估的范围内，这些信息可能被用来进行网络钓鱼攻击。
### 定位控制台

定位可登录的后台入口

### 工具审计

- 使用 NC 查看 banner
```
nc -nv <ip-address> <port>
```

- 使用Nikto 检查web敏感信息

进行对web服务器的多种检查，包括超过6700个潜在的危险文件/CGIs，查找过时的版本和版本特定问题
```
nikto -port {web ports} -host <ip address> -o <output file.txt>
```

### WEB爬取工具

#### gospider

```
gospider -d 3 -w /usr/share/wordlists/dirb/big.txt -u http://10.10.11.47
```


使用方法：
```bash
# 基础爬取（深度 3，自定义 User-Agent）
gospider -s http://startbootstrap.com -d 3 -u "Mozilla/5.0 (Windows NT 10.0; Win64; x64)..."

# 使用代理和第三方数据源
gospider -s https://example.com -p http://127.0.0.1:8080 -a -w

```

主要参数说明：

| 参数                           | 说明                                                                         |
| ---------------------------- | -------------------------------------------------------------------------- |
| `-s, --site string`          | 目标站点（例如：`http://example.com`）                                              |
| `-S, --sites string`         | 站点列表文件（每行一个站点）                                                             |
| `-p, --proxy string`         | 代理服务器（格式：`http://127.0.0.1:8080`）                                          |
| `-o, --output string`        | 输出结果的文件夹路径                                                                 |
| `-u, --user-agent`           | 用户代理设置：<br>- `web`：随机桌面浏览器 UA<br>- `mobi`：随机移动设备 UA<br>- 自定义 UA（默认值：`web`） |
| `--cookie string`            | 使用的 Cookie（格式：`testA=a; testB=b`）                                          |
| `-H, --header`               | 自定义请求头（可多次使用该参数添加多个头部）                                                     |
| `--burp string`              | 从 Burp HTTP 请求文件中加载头部和 Cookie                                              |
| `--blacklist string`         | 需要过滤的 URL 正则表达式（黑名单）                                                       |
| `-t, --threads int`          | 线程数（并行处理多个站点，默认值：`1`）                                                      |
| `-c, --concurrent int`       | 每个目标站点的最大并发请求数（默认值：`5`）                                                    |
| `-d, --depth int`            | 爬取深度（`0` 表示无限递归，默认值：`1`）                                                   |
| `-k, --delay int`            | 同站点请求间隔时间（秒）                                                               |
| `-K, --random-delay int`     | 在 `--delay` 基础上增加随机延迟（秒）                                                   |
| `-m, --timeout int`          | 请求超时时间（秒，默认值：`10`）                                                         |
| `--sitemap`                  | 尝试爬取 `sitemap.xml`                                                         |
| `--robots`                   | 尝试爬取 `robots.txt`（默认开启）                                                    |
| `-a, --other-source`         | 从第三方数据源（Archive.org/CommonCrawl/VirusTotal）发现 URL                          |
| `-w, --include-subs`         | 包含第三方数据源中的子域名（默认仅主域名）                                                      |
| `-r, --include-other-source` | 同时爬取第三方数据源的 URL（默认仅发现不请求）                                                  |
| `--debug`                    | 开启调试模式                                                                     |
| `--verbose`                  | 开启详细输出                                                                     |
| `--no-redirect`              | 禁用自动重定向                                                                    |
| `--version`                  | 查看版本信息                                                                     |
| `-h, --help`                 | 显示帮助文档                                                                     |

## 2.3 目录枚举

### dirsearch

常用预设：
```
sudo dirsearch -u http://192.168.56.104 -w /usr/share/wordlists/dirb/big.txt --full-url -o dirsearch.log
```
递归枚举
```
sudo dirsearch -t 100 -r -e php,html,txt -w /usr/share/wordlists/dirb/big.txt --max-recursion-depth 3 --random-agent -u http://10.10.11.48/ --full-url --recursion-status 301,200 -o sudo dirsearch.log

```
解释：
```
	-u http://10.10.11.48 ：指定要扫描的目标 URL
	-w /usr/share/wordlists/dirb/big.txt：指定使用的字典文件
	-r 启用递归扫描
	-e 站点文件类型列表，默认配置：php,aspx,jsp,html,js，"*"指代所有类型
		 -e zip,jpg,png,jpeg,tiff,bmp,gif
	-X 不需要扫描的站点文件类型列表
	-q --quiet-mode 静音模式
	-t 指定线程数
	--max-recursion-depth 3：设置递归扫描的最大深度为 3
	--threads 100：使用 100 个线程进行扫描
	--random-agent：使用随机的用户代理（User-Agent）发送请求
	--full-url：在输出结果中显示完整的 URL
	--recursion-status 301,200：只对状态码为 301 和 200 的页面进行递归扫描
	-i    仅现实指定的状态码，指定多个通过逗号分隔 
	-l    目标url列表文件

请求设置：
	-m METHOD，--http-method=METHOD  指定请求方式，默认GET
	-d DATA，--data=DATA  HTTP请求数据
	-H HEADERS，--header=HEADERSHTTP请求头，支持多个标志(例如：-H 'Referer: example.com')
	--header-list=FILE 文件包含HTTP请求头
	-F，--follow-redirects 遵循HTTP重定向
	--random-agent 为每个请求选择一个随机的用户代理
	--auth-type=TYPE 身份验证类型(基本，摘要，承载，ntlm)
	--auth=CREDENTIAL 身份验证凭据(用户：密码或承载令牌)
	--user-agent=USERAGENT
	--cookie=COOKIE              可以设置访问cookie
	-x（--exclude-status）        不显示指定的状态码，指定多个通过逗号分隔 
	--exclude-sizes=SIZES        不显示的响应包大小（Example: 123B,4KB）
	--exclude-texts=TEXTS        不显示的响应包关键字 (Example: "Not found", "Error"）

代理设置：
	--proxy=PROXY 支持HTTP和SOCKS(localhost:8080,socks5://localhost:8088)
	--proxy-list=FILE    文件包含代理服务器
	--replay-proxy=PROXY 用找到的路径重播的代理
 
输出保存：
	默认保存路径：/usr/lib/python3/dist-packages/sudo dirsearch/
    -o FILE, --output=FILE  指定保存扫描结果的文件名称，但只有指定了绝对路径才能改变保存路径，可以使用变量（~$HOME），但是./无效
    --format=FORMAT     输出格式指定 (Available: simple, plain, json, xml, md, csv, html)
```
### dirb
```
dirb http://192.168.56.104:80 /usr/share/wordlists/dirb/big.txt
```
选项：
```
-a "Mozilla/5.0 (iPod; U )"  
```
指定移动设备的user agent请求头爆破
```
dirb http://192.168.56.104:80 /usr/share/wordlists/rockyou.txt -a "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us)AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2Safari/6533.18.5" 
```
### gobuster

常用预设：
```
sudo gobuster dir -w /usr/share/wordlists/dirb/big.txt -u http://192.168.56.104:80 -x html,htm,zip,bak,txt,php,sql,rar,md,tar,xml,asp
```

递归枚举
```
sudo gobuster dir -u http://192.168.56.104:80 -w /usr/share/wordlists/dirb/big.txt -t 100 -e -x php -s 301 -r -o outlog.txt
```
解释
```
gobuster dir：表示使用 Gobuster 进行目录枚举操作。
-u http://10.10.11.48 :指定要扫描的目标 URL
-w /usr/share/wordlists/dirb/big.txt：指定要使用的字典文件
-t 1000：使用 1000 个线程进行扫描
-e：显示完整的 URL
-x php：仅查找后缀为 .php 的文件。
-s 301,200：仅对指定状态码的页面进行递归枚举
-r：启用递归扫描
-o outlog.txt：将扫描结果输出到 outlog.txt 文件中
```

使用方法：
```
 使用：
 gobuster [选项] [参数] <target>

 选项：
   completion 生成指定外壳的自动完成脚本
   dir        使用目录/文件枚举模式
   dns        使用DNS子域枚举模式
   fuzz       使用模糊模式。替换URL、报头和请求体中的关键词FUZZ
   gcs        使用gcs桶枚举模式
   help       帮助任何命令
   s3         使用AWS桶枚举模式
   tftp       使用TFTP枚举模式
   version    显示当前版本
   vhost      使用VHOST枚举模式(你最可能想使用IP地址作为URL参数)

参数：
   -u                    指定扫描目标地址
       --debug           启用调试输出
       --delay duration  每个线程在请求之间等待的时间(例如1500ms)
   -x                    指定寻找的文件后缀（默认不会寻找这些文件格式）
   -h, --help            gobuster帮助
       --no-color        禁用颜色输出
       --no-error        不显示错误
   -z, --no-progress     不显示进度
   -o, --output string   输出文件写入结果(默认为stdout)
   -p, --pattern string  包含替换模式的文件
   -p                    指定 HTTP 或 HTTPS 代理
   -q, --quiet           不打印横幅和其他噪声
   -t, --threads 并发线程数(默认10)
   -v, --verbose         详细输出(错误)
   -w, --wordlist        字符串 字典的路径。设置为-使用标准输入。
       --wordlist-offset 整数 从字典中给定的位置恢复(默认为0)
   -r                    启用递归模式，对每个子目录进行深度扫描
   -d, --depth           设置扫描深度(多层后缀的文件，例如。tar.gz)
   -t                    线程数
   -e                    对目标 URL 进行 URL 编码，处理包含特殊字符的 URL，例如空格、中文字符、特殊符号等。
   -k                    跳过 SSL/TLS 证书验证
   -a, --useragent       指定User-Agent
```

### Wfuzz
```
wfuzz -w /usr/share/wordlists/dirb/big.txt -u https://10.10.10.126:12380/FUZZ -H "X-Forwarded-For: http://127.0.0.1" --hc 404

	-w 字典
	-H "X-Forwarded-For: 127.0.0.1"  伪造请求地址
	--hc 过滤结果，如--hc 404 :不显示404的结果
```
### ffuf
```
ffuf -H "头信息" -w /usr/share/wordlists/dirb/big.txt -u http://10.10.10.110/FUZZ -e .php,.zip,.txt,.pdf
```
### 目录枚举字典

| SIZE    | PATH                                                                              |
| ------- | --------------------------------------------------------------------------------- |
| 10      | /usr/share/wordlists/dirb/indexes.txt                                             |
| 29      | /usr/share/wordlists/dirb/extensions_common.txt                                   |
| 49      | /usr/share/wordlists/dirb/mutations_common.txt                                    |
| 161     | /usr/share/wordlists/dirb/catala.txt                                              |
| 197     | /usr/share/wordlists/dirb/euskera.txt                                             |
| 449     | /usr/share/wordlists/dirb/spanish.txt                                             |
| 959     | /usr/share/wordlists/dirb/small.txt                                               |
| 4614    | /usr/share/wordlists/dirb/common.txt                                              |
| 8930    | /usr/share/wordlists/dirbuster/apache-user-enum-1.0.txt                           |
| 10355   | /usr/share/wordlists/dirbuster/apache-user-enum-2.0.txt                           |
| 20469   | /usr/share/wordlists/dirb/big.txt                                                 |
| 24349   | /usr/share/wordlists/dirb/all.txt                                                 |
| 58688   | /usr/share/wordlists/dirbuster/directories.jbrofuzz                               |
| 81643   | /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-small.txt             |
| 81643   | /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-small.txt  |
| 87664   | /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt                       |
| 87664   | /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-small.txt            |
| 141708  | /usr/share/wordlists/dirbuster/directory-list-1.0.txt                             |
| 141708  | /usr/share/seclists/Discovery/Web-Content/directory-list-1.0.txt                  |
| 207643  | /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt            |
| 207643  | /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-medium.txt |
| 220559  | /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt           |
| 220560  | /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt                      |
| 1185254 | /usr/share/seclists/Discovery/Web-Content/directory-list-lowercase-2.3-big.txt    |
| 1273832 | /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-big.txt              |



大佬的字典项目
```
https://github.com/Fuzzdb-project/Fuzzdb
https://github.com/danielmiessler/SecLists
```



## 2.4 DNS枚举
### DNS记录类型

```
A 记录：将域名指向一个IPv4地址。  
AAAA记录：将域名指向一个IPv6地址。  
CNAME记录：别名，用于将多个名字映射到同一台计算机。  
MX记录：邮件交换记录，用于电子邮件路由。  
TXT记录：一般用于保存关于主机的一些文本信息。  
NS记录：指定由哪些DNS服务器对该区域进行解析。
```

### DNS记录查询
#### **1. `dig`**
- **功能**：查询 DNS 记录（A、AAAA、MX、NS、TXT 等），支持高级查询。
- **常用参数**：
  ```bash
  dig example.com          # 查询 A 记录
  dig -t MX example.com   # 查询 MX 记录
  dig -x 192.168.1.1      # 反向 DNS 解析
  dig example.com +short  # 简洁输出
  ```

- **反向 DNS 解析**：
   ```bash
   for ip in 192.168.1.{1..254}; do dig -x $ip +short; done
   ```

#### **2. `nslookup`**
- **功能**：简单的 DNS 查询工具，适合交互式操作。
- **常用参数**：
  ```bash
  nslookup example.com          # 查询默认 DNS 服务器
  nslookup example.com 8.8.8.8  # 指定 DNS 服务器
  ```

#### **3. `host`**
查域名ip

```
host www.megacorpone.com
```

查邮件服务器等其他记录类型

```
host -t mx megacorpone.com
host -t txt megacorpone.com
```

批量枚举域名对应ip

```
for ip in $(cat list.txt); do host $ip.megacorpone.com; done
```

批量枚举ip对应域名

```
for ip in $(seq 200 254); do host 51.222.169.$ip; done | grep -v "not found"
```

使用工具自动枚举

```
dnsrecon -d megacorpone.com -t std
dnsrecon -d megacorpone.com -D ~/list.txt -t brt
dnsenum megacorpone.com
```

A记录枚举

```
nslookup mail.megacorptwo.com
```

指定DNS服务器枚举

```
nslookup -type=TXT info.megacorptwo.com 192.168.50.151
```
### 子域名枚举



#### **4. `dnsrecon`**
- **功能**：强大的 DNS 枚举工具，支持暴力破解、区域传输、子域名发现。
- **常用参数**：
  ```bash
  dnsrecon -d example.com -t std   # 标准扫描
  dnsrecon -d example.com -t axfr  # 尝试区域传输
  dnsrecon -d example.com -t brt   # 暴力破解子域名（需字典）
  ```

- **自动化脚本**：
   ```bash
   # 批量扫描多个域名
   cat domains.txt | while read domain; do dnsrecon -d $domain -o $domain.txt; done
   ```

- **区域传输测试**：
   ```bash
   dnsrecon -d example.com -t axfr
   ```

#### **6. `fierce`**
- **功能**：子域名发现和 DNS 信息收集。
- **常用参数**：
  ```bash
  fierce -dns example.com
  ```


#### ffuf
```
ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -u http://alert.htb -H "Host:FUZZ.alert.htb" -ac
```

#### gobuster 
##### vhost

开始扫描
```
gobuster vhost -t 50 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt --append-domain -u http://linkvortex.htb/ 
```
##### dns

将 DNS 服务器如 1.1.1.1 添加到 /etc/resolv.conf 文件中
```
echo 'nameserver 1.1.1.1' >> /etc/resolv.conf
```
开始扫描
```
gobuster dns -t 50 -w /usr/share/SecLists/Discovery/DNS/namelist.txt -u http://linkvortex.htb/ 
```

#### **5. `dnsmap` DNS 分析工具**
- **功能**：通过字典暴力破解子域名。
- **常用参数**：
  ```bash
  dnsmap example.com -w /usr/share/wordlists/dnsmap.txt
  ```


#### **7. `drone`**
- **功能**：自动化 DNS 侦察，集成多种工具。
- **常用参数**：
  ```bash
  drone -d example.com
  ```


#### **8. `dnschef` DNS 欺骗的工具**
- **功能**：DNS 欺骗（中间人攻击）。
- **常用参数**：
  ```bash
  dnschef --fakedns example.com:192.168.1.100
  ```


#### **9. `dmitry`**
- **定位**：dmitry 是一款**轻量级信息收集工具**，主要用于对目标域名或 IP 进行基础信息收集。
- **核心功能**：
    - **域名信息**：查询 Whois 信息、DNS 记录（如 A、MX、NS 记录）、子域名枚举（基础字典爆破）。
    - **端口扫描**：支持简单的端口扫描（如 TCP SYN 扫描），识别开放端口。
    - **服务探测**：初步识别端口对应的服务（如 HTTP、FTP），但功能较基础。
    - **漏洞线索**：通过检查常见服务的 banner 信息，获取可能的漏洞线索（如软件版本）。
- **常用参数**：
  ```bash
  dmitry -winse example.com
  ```


#### **10. `dnstracer` 跟踪 DNS 查询路径**
- **功能**：跟踪 DNS 查询路径。
- **常用参数**：
  ```bash
  dnstracer example.com
  ```




#### **3. `dnsenum`**
- **功能**：子域名枚举、区域传输测试、反向解析等。
- **常用参数**：
  ```bash
  dnsenum example.com                         # 基础扫描
  dnsenum --enum example.com                  # 全面枚举（子域名、MX、NS）
  dnsenum --file domains.txt --threads 5      # 批量扫描多个域名
  ```


#### wfuzz
```
wfuzz -c -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -u http://FUZZ.alert.htb/
```

#### 手动枚举

https://blog.csdn.net/weixin_63124284/article/details/126956627
### 字典
安装 SecLists字典
```
sudo apt install seclists -y
```

常用字典
```bash
986     /usr/share/seclists/Miscellaneous/dns-resolvers.txt
17576   /usr/share/wordlists/dnsmap.txt
19966 /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt
49928 /usr/share/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt
114441 /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt
100000 /usr/share/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt
102582  /usr/share/seclists/Discovery/DNS/sortedcombined-knock-dnsrecon-fierce-reconng.txt
151265 /usr/share/seclists/Discovery/DNS/namelist.txt
2171687 /usr/share/seclists/Discovery/DNS/dns-Jhaddix.txtt
```


