### 什么是防火墙？

防火墙是用来控制网络访问的软件或硬件。分为以下两类：1、基于主机的防火墙；2、基于网络的防火墙。

#### 基于主机的防火墙

这是在单台主机上运行的软件，用来控制入站流量（从网络向主机）和出站流量（从主机向网络）。这些软件安装于操作系统之上，常见例子就是Linux上面的iptables和Windows上的Zone Alarm。

#### 基于网络的防火墙

这些可以是硬件设备或软件，或者硬件设备和软件相结合。用来保护来自于未受保护的入站通信。

防火墙被安装在受保护和不受保护的网络之间，它们会查看所有的通信，并通过设置规则来控制入站和出站的通信。

### 扫描防火墙

为了有效地扫描防火墙，我们必须检查所有开放端口，服务和状态。在使用[Nmap](https://so.csdn.net/so/search?q=Nmap&spm=1001.2101.3001.7020)扫描时也要采取行动，设置时间选项来确定防火墙的存在。所以你可以看到下面有关Nmap扫描结果的表格，我们可以很容易地知道防火墙是否存在。

[![1.jpg](https://i-blog.csdnimg.cn/blog_migrate/7042856cc0448723873d1843512440ae.jpeg)](http://image.3001.net/images/20160412/14604429028909.jpg)

通过谷歌搜索时候我才知道，下面的IP地址是由WAF（Web应用防火墙），以及某些IDS保护下。我们试图以某种强力攻击（SQL注入）。我们提交一些特殊字符时，它都会被显示“失败的防火墙认证”。我们才知道这个东西可以用HTTP动词篡改来绕过。我们将稍后讨论。

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/d75ef1bdb8f53fd37fff8de7c49970ff.jpeg)](http://image.3001.net/images/20160412/14604329735733.png)

首先我们使用选项-Pn进行扫描。

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/d762a2f8364828905b4db740c405cdca.jpeg)](http://image.3001.net/images/20160412/14604329895435.png)

发现有被过滤的端口，因此我们肯定服务器有防火墙保护，我们扫描指定端口获得更多的信息。

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/4de43aab6c322f6d10a91cf57363ea20.jpeg)](http://image.3001.net/images/20160412/14604329987210.png)

让我们做一个内部网络扫描。首先,我们将检查扫描版本：

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/f2740fd9137735cc02c6bf9b65e0a5e8.jpeg)](http://image.3001.net/images/20160412/14604330099496.png)

通过指定时间选项和端口选项发现了更多服务。

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/50f1c428178364bdb162199676374214.jpeg)](http://image.3001.net/images/20160412/14604330151287.png)

观察：

扫描防火墙给内部网络提供的各种服务，包括DNS，SSH，HTTPS和Web代理。这些都是在内部网络中的所有PC可以访问。它也在80端口运行透明代理，所以并不需要客户端的浏览器更改设置。

### 逃避或绕过防火墙

bypass或规避或逃避无非是进入系统的另一种方式。管理员使用防火墙或IDS / IPS阻止恶意攻击或垃圾邮件。但是从攻击者的角度来看，他会想办法绕过防火墙规则；Nmap有很多办法绕过防火墙。

#### 1、碎片化

Nmap发送8个字节的数据包绕过防火墙/IDS/IPS。这种技术已经很古老了，但是在防火墙配置不当的时候依旧有用。

```
`Nmap -f host`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/a44351305be765b15cb33e15ce19bb6c.jpeg)](http://image.3001.net/images/20160412/14604330642693.png)

MTU，最大传输单元，它是碎片化的别名，我们可以指定它的大小。

```
`Nmap --mtu 16 host`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/0ed7feee6a798a06f749eb99212726e3.jpeg)](http://image.3001.net/images/20160412/14604330804234.png)

上面的Nmap扫描使用16字节的数据包而不是8个字节。所以我们可以指定自定义数据包大小为8的倍数。

#### 2、诱饵

这种类型的扫描是非常隐蔽且无法察觉。目标由多个假冒或伪造IP地址进行扫描。这样防火墙就会认为攻击或扫描是通过多个资源或IP地址进行，于是就绕过了防火墙。

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/cdd58e04f4e59681e993c677c6159daa.jpeg)](http://image.3001.net/images/20160412/14604330981909.png)

诱饵在初始的ping扫描（使用ICMP，SYN，ACK等）使用，在实际的端口扫描阶段使用。诱饵在远程操作系统检测（-O）期间也使用。诱饵不在版本检测工作或TCP连接扫描中使用。

这实际上在目标看来是由多个系统同时扫描，这使得防火墙更难追查扫描的来源。

有两种方式来执行诱饵扫描：

1.nmap -D RND:10 TARGET

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/d8ff828a360c606e0ed6e6cd8a3049f9.jpeg)](http://image.3001.net/images/20160412/14604331108867.png)

2.nmap -D decoy1,decoy2,decoy3 target

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/775341721010474cb14e7f0f40324d88.jpeg)](http://image.3001.net/images/20160412/1460433117454.png)

以下网络抓包显示多个诱饵将欺骗防火墙。

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/49434f13b36e6fc45e27b2580e75d7d7.jpeg)](http://image.3001.net/images/20160412/14604331261973.png)

#### 3、空闲扫描

攻击者将首先利用一个空闲的系统并用它来扫描目标系统。

扫描的工作原理是利用某些系统中采用可预见的IP序列ID生成。为了使空闲扫描成功，僵尸主机的系统必须是在扫描时间处于闲置状态。对于任何疑问，请参考之前的文章。

在这种技术中会隐藏攻击者的IP地址。

```
`Nmap -P0 -sI zombie target`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/a2a87b4311c15e100cbffac0e03b5ed1.jpeg)](http://image.3001.net/images/20160412/14604331477468.png)

我们使用tcpdump来捕获所有网络流量。

```
`Tcpdump -i interface`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/58e33181d155ebcf2d276419598562fd.jpeg)](http://image.3001.net/images/20160412/14604331549284.png)

#### 4、选项-source-port

每个TCP数据包带有源端口号。默认情况下Nmap会随机选择一个可用的传出源端口来探测目标。该-source-port选项将强制Nmap使用指定的端口作为源端口。这种技术是利用了盲目地接受基于特定端口号的传入流量的防火墙的弱点。端口21（FTP），端口53（DNS）和67（DHCP）是这种扫描类型的常见端口。

```
`Nmap --source-port port target`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/f1df5fbff92edd7e8e744d35ee4ae79a.jpeg)](http://image.3001.net/images/20160412/14604331647567.png)

#### 5、随机数据长度：

附加随机数据长度，我们也可以绕过防火墙。许多防火墙通过检查数据包的大小来识别潜伏中的端口扫描。这是因为许多扫描器会发送具有特定大小的数据包。为了躲避那种检测，我们可以使用命令-data-length增加额外的数据，以便与默认大小不同。在下图中，我们通过加入25多个字节改变数据包大小。

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/21b94a45d20ebce3ec3f921ce2e1bf0c.jpeg)](http://image.3001.net/images/20160412/14604331727904.png)

```
`nmap --data-length target`
  
  




```

捕获数据流量

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/e2021c3c37664f76f159d2267428b44f.jpeg)](http://image.3001.net/images/20160412/14604331772940.png)

#### 6、随机顺序扫描目标：

选项-randomize-host用于随机 顺序扫描指定目标。-randomize-host有助于防止因连续 扫描多个目标而防火墙和入侵检测系统检测到。

```
`nmap --randomize-hosts targets`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/0a6d6e15871b288bf4a2377317686763.jpeg)](http://image.3001.net/images/20160412/14604331869437.png)

#### 7、MAC地址欺骗：

每台机器都有自己独特的mac地址。因此这也是绕过防火墙的另一种方法，因为某些防火墙是基于MAC地址启用规则的。为了获得扫描结果，您需要先了解哪些MAC地址可以使用。这可以通过手动或先进的模糊测试完成。我更喜欢模糊测试，用Python实现非常容易。我们只需要手工导入正则表达式到Python中，然后自动化执行。

特别是`-spoof-MAC`选项使您能够从一个特定的供应商选择一个MAC地址，选择一个随机的MAC地址，或者设定您所选择的特定MAC地址。 MAC地址欺骗的另一个优点是，你让你的扫描隐蔽，因为你的实际MAC地址就不会出现在防火墙的日志文件。

```
`nmap -sT -PN -spoof-mac aa:bb:cc:dd:ee:ff target`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/c0ee236fc94dd35b266b56f33d79f624.jpeg)](http://image.3001.net/images/20160412/14604331973412.png)

Mac地址欺骗需要以下参数：

[![2.jpg](https://i-blog.csdnimg.cn/blog_migrate/b714b3cc67542b1c02f17dc60c801a08.jpeg)](http://image.3001.net/images/20160412/14604429499368.jpg)  

8、发送错误校验

在某些防火墙和IDS / IPS，只会检查有正确校验包的数据包。因此，攻击者通过发送错误校验欺骗IDS / IPS。

```
`nmap --badsum target`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/4b2b046c5f9db907427a30df56194c0d.jpeg)](http://image.3001.net/images/20160412/14604332174539.png)

#### 9、Sun-RPC 扫描

什么是Sun RPC？Sun RPC（远程过程调用）是一种Unix协议，用来实现多种服务比如NFS。最初由Sun开发，但现在广泛使用在其他平台上（包括Digital Unix的）。也被称为开放式网络计算（ONC）。

Sun RPC包带有一个RPC编译器，自动生成服务端和客户端的存根。

nmap带有将近600个RPC程序的数据库。许多RPC服务使用高端口编号或者使用UDP协议，RPC程序还有严重的远程利用漏洞。所以网络管理员和安全审计人员往往希望了解更多在他们的网络内有关任何RPC程序。

我们可以通过以下命令获得RPC 的详细信息：

```
`rpcinfo/rpcinfo --p hostname`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/f23bfe584644ad69caa8b10a399306d6.jpeg)](http://image.3001.net/images/20160412/14604332282300.png)

nmap通过以下三个步骤跟开放的RPC端口直接通信，然后获取信息。

> 1)使用TCP或者UDP扫描开放的端口。
> 
> 2)-sV选项检查使用Sun RPC协议的开放端口。
> 
> 3)RPC暴力破解引擎会逐一向nmap-rpc数据库中记录的端口发送空命令，来判断RPC程序。当nmap猜测错误，会收到一条错误消息，指出请求的端口并没有运行PRC程序。当nmap耗尽了所有已知的记录，或者端口返回了非RPC的数据包，nmap才会放弃。

### SSL后处理器扫描

NMAP具有检测SSL加密协议的能力，进行版本检测时会自动启用这个功能。正如先前讨论的RPC扫描，只要检测一个适当的（SSL）端口自动执行将SSL后处理器扫描。

命令：

```
`nmap -Pn -sSV -T4 -F target`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/acfd5f305fe5011bb0907c4667aea1e5.jpeg)](http://image.3001.net/images/20160412/14604332465069.png)

### NMAP服务探针文件格式

Nmap使用本地文件来存储版本检测探针和匹配字符串。虽然nmap自带的nmap-services足以满足大多数用户，理解文件格式有助于[渗透测试](https://so.csdn.net/so/search?q=%E6%B8%97%E9%80%8F%E6%B5%8B%E8%AF%95&spm=1001.2101.3001.7020)人员添加新的规则到扫描引擎中。#号开始的行用于注释和忽略。

#### 排除指令

版本扫描中会排除指定的端口。它只能使用一次，在所有的探针指令的最上方，位于文件顶部。端口应该用逗号分隔。

语法：Exclude &lt;port specification&gt;

#### 探针指令

语法：Probe &lt;protocol&gt; &lt;probename&gt; &lt;probestring&gt;

例子：

> Probe TCP GetRequest q|GET / HTTP/1.0\\r\\n\\r\\n|
> 
> Probe UDP DNSStatusRequest q|\\x10|
> 
> Probe TCP NULL q||

探针指令告诉nmap发送指定字符串去识别服务。参数如下：

&lt;协议&gt;

这必须是TCP或UDP。 NMAP只使用匹配它试图扫描服务的协议的探针。

&lt;探测器名称&gt;

这是一个纯英文名称。

&lt;探测字符串&gt;

告诉Nmap发送什么。它必须有一个q，用分隔符标记字符串的开始和结束。它允许下列标准转义字符C或Perl的字符串：\\\\ , \\a, \\b, \\f, \\n, \\r, \\t, \\v,和\\xHH（ H是任何十六进制数字）。Nmap的探针也有空内容探针比如上面的第三个例子，这个TCP空探针用来接收服务返回的banner。如果你的分隔符（在这些例子中是|）需要在探测字符串中，你需要选择不同的分隔符。

语法：match &lt;service&gt; &lt;pattern&gt; \[&lt;versioninfo&gt;\]

Examples：

```

```

match ftp m/^220.\*Welcome to .\*Pure-?FTPd (\\d\\S+\\s\*)/ p/Pure-FTPd/ v/$1/ cpe:/a:pureftpd:pure-ftpd:$1/

match ssh m/^SSH-(\[\\d.\]+)-OpenSSH\[\_-\](\[\\w.\]+)\\r?\\n/i p/OpenSSH/ v/$2/ i/protocol $1/ cpe:/a:openbsd:openssh:$2/

match mysql m|^\\x10\\x01\\xff\\x13\\x04Bad handshake$| p/MySQL/ cpe:/a:mysql:mysql/

match chargen m|@ABCDEFGHIJKLMNOPQRSTUVWXYZ|

match uucp m|^login: login: login: $| p/NetBSD uucpd/ o/NetBSD/ cpe:/o:netbsd:netbsd/a

match printer m|^(\[\\w-\_.\]+): lpd: Illegal service request\\n$| p/lpd/ h/$1/

match afs m|^\[\\d\\D\]{28}\\s\*(OpenAFS)(\[\\d\\.\]{3}\[^\\s\]\*)| p/$1/ v/$2/

&nbsp;

#### 匹配指令

匹配指令告诉Nmap如何根据之前发送探针后服务器的响应来识别服务。每一个探针后可跟随数十或数百个匹配的语句。匹配指令包括：可选的版本说明，应用程序名称，版本号，以及Nmap报告的其他信息。该参数这个指令如下：

&lt;服务&gt;

这是简单的模式匹配的服务名称。比如ssh、smtp、http或snmp。

&lt;模式&gt;

该模式被用来确定接收到的响应是否与先前给出的服务参数相匹配。格式如Perl，使用语法为m/\[regex\]/\[opts\]。“m”告诉Nmap一个匹配的字符串开始。正斜杠（/）是一个分隔符。该正则表达式是一个Perl风格的正则表达式。目前可以配置的选项是‘i’（不区分大小写），‘s’（.也可以匹配换行符）。在Perl这两个选项具有相同的语义。用括号包围需要捕获的字符串，比如版本号。

&lt;版本信息&gt;

在&lt;VERSIONINFO&gt;部分实际上包含几个可选字段。每个字段始于一个确认字母(如h为“主机名”)。接下来是一个分隔符，优选的分隔符是斜杠（’/'），除非是在斜杠会在内容中体现。接下来是字段的值，然后是分隔符。下表描述了六个字段：

[![3.jpg](https://i-blog.csdnimg.cn/blog_migrate/1fc311aa3e623f29b0ab401a3fa119db.jpeg)](http://image.3001.net/images/20160412/14604429851325.jpg)  

软匹配指令

语法：softmatch &lt;service&gt; &lt;pattern&gt;

样例：

> softmatch ftp m/^220 \[-.\\w \]+ftp.\*\\r\\n$/i
> 
> softmatch smtp m|^220 \[-.\\w \]+SMTP.\*\\r\\n|
> 
> softmatch pop3 m|^\\+OK \[-
> 
> !,/+:<>@.\\w \]+\\r\\n$|

软匹配指令和匹配指令的格式类似，主要区别在于软匹配成功之后仍会继续扫描，但只会发送与匹配成功的服务有关的探针，这有助于获得更多信息，比如版本号。

#### 端口和SSL端口指令

语法：port &lt;portlist&gt;

样例：

```

```

ports 21,43,110,113,199,505,540,1248,5432,30444

ports 111,4045,32750\-32810,38978

这个命令告诉nmap通过哪些端口去标识服务。语法类似于nmap的-p选项。

语法：sslports &lt;portlist&gt;

样例：sslports 443

这个是用来探测ssl服务的端口。

#### totalwaitms指令

语法：totalwaitms &lt;milliseconds&gt;

样例：totalwaitms 5000

这个指令告诉nmap针对特定服务发送探针后要等待响应的时间有多久。nmap默认是5秒。

#### 稀有级指令

语法：rarity &lt;值在1和9之间&gt;

样例：rarity 6

这个指令对应这个探针能返回期望结果的程度。数值越高表示越稀有。

#### 回退指令

语法：fallback &lt;逗号分隔的探针列表&gt;

样例：fallback GetRequest,GenericLines

这个选项指定当当前探针没有匹配成功时，会使用的备用探针，顺序是从左往右。对于没有回退指令的探针，会隐藏的执行回退到空探针。

现在来讲讲nmap在web渗透中的利用。

### Nmap的HTTP方法

Web服务器根据它们的配置和软件支持不同的HTTP方法，并且其中一些请求在一定条件下是危险的。HTTP的方法有GET, HEAD, POST, TRACE, DEBUG, OPTION, DELETE, TRACK, PUT等。更多详情[请查阅这里](/Protocols/rfc2616/rfc2616-sec9.html)。

命令：

```
`nmap -p80,443 --script http-methods scanme.nmap.org`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/6fcf76878f8d65017e33e008cadd8276.jpeg)](http://image.3001.net/images/20160412/14604372512797.png)

如果需要详细的检查，那么命令：

```
`nmap -p80,443 --script http-methods -script-args http-methods.retest scanme.nmap.org`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/e3a51e28a06a1bd5ddb79f8574aeddc2.jpeg)](http://image.3001.net/images/20160412/14604372454011.png)

默认情况下，脚本http-methods使用根文件夹为基础路径（/）。如果我们要设置一个不同的基本路径，设置参数的HTTP methods.url路径：

命令：

```
`nmap -p80,443 --script http-methods --script-args http-methods.urlpath=/mypath/ scanme.nmap.org`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/8756819290039bf34cde3a95aeddf2ef.jpeg)](http://image.3001.net/images/20160412/14604372507497.png)

HTTP方法TRACE，CONNECT，PUT和DELETE可能会出现安全风险，如果一个Web服务器或应用程序的支持这些方法的话，需要进行彻底测试。 TRACE使应用程序容易受到跨站跟踪（XST）攻击，可能导致攻击者访问标记为的HttpOnly的Cookie。 CONNECT方法可能会允许Web服务器作为未经授权的Web代理。 PUT和DELETE方法具有改变文件夹的内容的能力，如果权限设置不正确可能被滥用。

你可以了解每个方法更多的风险到：

https://www.owasp.org/index.php/Test_HTTP_Methods_%28OTG-CONFIG-006%29

### HTTP User Agent:

有些防火墙会过滤Nmap的默认UserAgent，你可以设置不同的用户代理。

命令: 

```
`nmap -p80 --script http-methods --script-args http.useragent=”Mozilla 5”    <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/72d641e6047eda5171c9efe69b45d4c0.jpeg)](http://image.3001.net/images/20160412/14604372648098.png)

### HTTP管道

一些web服务器允许多个HTTP请求的封装在一个包。这可以加快脚本执行的速度，如果web服务器支持的话建议启用。默认情况下一个管道会有40个请求，并且会根据网络情况自动调节大小。

命令：

```
`nmap -p80 --script http-methods --script-args http.pipeline=25 <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/db340a244d9df69e04af1dc4ad4ad800.jpeg)](http://image.3001.net/images/20160412/14604372905690.png)

另外，我们可以设置http.max-pipeline参数来控制http管道的最大值。如果设置了该参数，nmap会自动忽略http.pipeline。

命令：

```
`nmap -p80 --script http-methods --script-args http.max-pipeline=10 <target>`
  
  




```

### 扫描HTTP代理

使用http代理是为了隐藏自己的真实ip地址。下列命令显示如何检测开放代理：

命令：

```
`nmap --script http-open-proxy -p8080 <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/e0564eac2cd6db970bd52e52f4c513d9.jpeg)](http://image.3001.net/images/20160412/14604373085305.png)

我们还可以指定用来验证的url。

命令：

```
`nmap --script http-open-proxy --script-args http-open-proxy.url=http://whatsmyip.org,http-open-.pattern=”Your IP address is” -p8080 <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/ba43c61e430be37aa07ca0913fca7432.jpeg)](http://image.3001.net/images/20160412/14604373155980.png)

### 发现有趣的文件和目录和管理员账户

这是在渗透测试中常见的任务，通常没法手动完成。经常讨论的Web应用程序的脆弱性有目录列表，用户账户枚举，配置文件等。用Nmap的NSE可以更快的帮助我们完成这个任务。

```
`nmap --script http-enum -p80 <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/4efdc0a55c066bc78ab98730bc06056d.jpeg)](http://image.3001.net/images/20160412/14604373213896.png)

查找Lua脚本

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/6f6866f625239ae969a8eb9cf3aeb652.jpeg)](http://image.3001.net/images/20160412/14604373267489.png)

进入Lua列表

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/2a4048367b7fa9e99ca63a525890a6b2.jpeg)](http://image.3001.net/images/20160412/14604373361943.png)

指纹存储在nselib/data/http-fingerprints.lua，事实上是LUA表格。若要显示所有的存在页面

```
`nmap script http-enum http-enum.displayall -p80 <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/8553d3e601f5cf3979a0a7e4274b9814.jpeg)](http://image.3001.net/images/20160412/1460437340241.png)

指定不同的User Agent来绕过某些防火墙

```
`nmap -p80 --script http-enum --script-args http.useragent=”Mozilla 5″<target>`
  
  




```

也可以指定HTTP管道数目来加快扫描

```
`nmap -p80 --script http-enum --script-args http.pipeline=25 <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/a1dc35ab9c26b60824e82a91f24d0623.jpeg)](http://image.3001.net/images/20160412/1460437349178.png)

### 暴力破解HTTP身份认证

很多家用路由器，IP网络摄像头，甚至是Web应用程序仍然依赖于HTTP认证，渗透测试人员需要尝试弱密码的单词列表，以确保系统或用户帐户是安全的。现在多亏了NSE脚本http-brute，我们可以对HTTP认证保护的资源执行强大的字典攻击。请参见下面的命令：

```
`nmap -p80 --script http-brute --script-args http-brute.path=/admin/ <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/80054e6414685e31fa1fa11deca1edb2.jpeg)](http://image.3001.net/images/20160412/14604373651200.png)

http-brute脚本默认使用的是自带的字典，如果要使用自定义的字典。

```
`nmap -p80 --script http-brute --script-args userdb=/var/usernames.txt,passdb=/var/passwords.txt <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/ad128dc6b4e96c7cbed78204961f9d5f.jpeg)](http://image.3001.net/images/20160412/14604373721048.png)

http-brute支持不同的模式进行攻击。

用户模式：该模式下，对于userdb中的每个user,会尝试passdb里面的每个password

```
`nmap --script http-brute --script-args brute.mode=user <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/4709e4ae3415586fcf22768a0e5a05db.jpeg)](http://image.3001.net/images/20160412/1460437380679.png)

密码模式：该模式下，对于passdb中的每个password,会尝试userdb里面的每个user。

```
`nmap --script http-brute --script-args brute.mode=pass <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/ee63d56138afc493ca4feab2bbdfe09f.jpeg)](http://image.3001.net/images/20160412/14604373869522.png)

fcreds：此模式需要额外的参数brute.credfile。

```
`nmap --script http-brute --script-args brute.mode=creds,brute.credfile=./creds.txt <target>`
  
  




```

### mod_userdir渗透测试

Apache的模块UserDir提供了通过使用URI语法/~username/来访问用户目录的方法。我们可以使用Nmap进行字典攻击，确定web服务器上有效的用户名列表。命令如下：nmap -p80 -script http-userdir-enum &lt;target&gt;

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/551a12e2a01139ef86ef5f35fa749f6d.jpeg)](http://image.3001.net/images/20160412/14604374044866.png)

跟上面的脚本一样，可以设置User Agent、HTTP管道参数。

### 测试默认凭据

通常情况下Web应用程序存在默认凭据，通过NSE很容易发现。

```
`nmap -p80 --script http-default-accounts <target>`
  
  




```

脚本通过查找已知路径和已知的用户密码来登陆，依赖/nselib/data/http-default-accounts.nse存放的指纹文件。

### WordPress审计

发现使用弱密码账户安装的wordpress，输入如下命令：

```
`nmap -p80 --script http-wordpress-brute <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/535af33a75f5788c7b4de6ccf297f673.jpeg)](http://image.3001.net/images/20160412/14604374389912.png)

设置线程的数量,使用脚本参数http-wordpress-brute.threads：

```
`nmap -p80 --script http-wordpress-brute --script-args http-wordpressbrute.threads=5 <target>`
  
  




```

如果服务器是虚拟主机,利用参数http-wordpressbrute设置主机字段：

```

```

nmap -p80 --script http-wordpress-brute --script-args http-

wordpressbrute.hostname=”ahostname.wordpress.com” &lt;target&gt;

设置一个不同的登陆URI,登录使用参数http-wordpress-brute.uri：

```
`nmap -p80 --script http-wordpress-brute --script-args http-wordpressbrute.uri=”/hidden-wp-login.php” <target>`
  
  




```

要改变存储的用户名和密码的POST变量的名称，设置参数http-wordpress-brute.uservar和http-wordpress-brute.passvar:

```
`nmap -p80 --script http-wordpress-brute --script-args http-wordpressbrute.uservar=usuario,http-wordpress-brute.passvar=pasguord <target>`
  
  




```

### Joomla审计

Joomla是在许多国家非常流行的cms，使用http-joomla-brute脚本来检测弱密码账户。

```
`nmap -p80 --script http-joomla-brute <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/72756a54bde60f511c8fbc0301d12de1.jpeg)](http://image.3001.net/images/20160412/1460437431598.png)

Mark：Wordpress的方法也适用于Joomla。

### 检测Web应用防火墙

要检测web应用防火墙，使用如下命令：

```
`nmap -p80 --script http-waf-detect <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/98021dfdf7a7c33ec830f0aeee8ecf2d.jpeg)](http://image.3001.net/images/20160412/14604374487519.png)

正如你所见，这里的报错信息显示有mod_security

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/3f1c73c41317289671d10a89af11c0fb.jpeg)](http://image.3001.net/images/20160412/14604374647126.png)

可以通过检测响应内容的变化来检测防火墙，推荐使用内容较少的页面。

```
`nmap -p80 --script http-waf-detect --script-args=”http-waf-detect.detectBodyChanges” <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/fa2ffcb2db1bedb4d00814f111064686.jpeg)](http://image.3001.net/images/20160412/14604374589839.png)

使用更多的攻击载荷：

```
`nmap -p80 --script http-waf-detect --script-args=”http-waf-detect.aggro” <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/0b691daf102d3c711c8fac18c66e3603.jpeg)](http://image.3001.net/images/20160412/14604374652516.png)

### 检测跨站跟踪漏洞

当Web服务器存在跨站脚本漏洞，又启用了TRACE方法，这样就可以获取启用了HttpOnly的Cookie。如下命令检测是否启用TRACE。

```
`nmap -p80 --script http-methods,http-trace --script-args http-methods.retest <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/5ef196a0726f836cfc53b03c288b0de2.jpeg)](http://image.3001.net/images/20160412/14604374922927.png)

### 检测跨站脚本漏洞

跨站脚本漏洞允许攻击者执行任意js代码。检测命令如下：

```
`nmap -p80 --script http-unsafe-output-escaping <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/8bd8e9cdd1fe32ff9a9f7733a72aacc3.jpeg)](http://image.3001.net/images/20160412/14604374994640.png)

该脚本http-unsafe-output-escaping是由Martin Holst Swende编写，它会检测基于用户输入的输出可能出现的问题，该脚本发送以下内容到它发现的所有参数：ghz%3Ehzx%22zxc%27xcv

更多详情，查阅：

http://nmap.org/nsedoc/scripts/http-phpself-xss.html

http://nmap.org/nsedoc/scripts/http-unsafe-output-escaping.html

### 检测SQL注入

使用如下命令：

```
`nmap -p80 --script http-sql-injection <target>`
  
  




```

[![Clipboard Image.png](https://i-blog.csdnimg.cn/blog_migrate/af1864068d46c65042d833515b9f4310.jpeg)](http://image.3001.net/images/20160412/14604375246579.png)

可以设置httpspider.maxpagecount来加快扫描的速度。

```
`nmap -p80 --script http-sql-injection --script-args httpspider.maxpagecount=200 <target>`
  
  




```

一个有趣的参数是httpspider.withinhost，它限制nmap只能爬取给定的主机。默认情况下是启用的，如果为了爬行相关的站点可以禁用。

```
`nmap -p80 --script http-sql-injection --script-args httpspider.withinhost=false <target>`
  
  




```

可以找到的[官方文档库](http://nmap.org/nsedoc/lib/httpspider.html)。

同样可以设置User Agent和HTTP管道的数目：

```
`nmap -p80 --script http-sql-injection --script-args http.useragent=”Mozilla 42″ <target>`
  
  




```