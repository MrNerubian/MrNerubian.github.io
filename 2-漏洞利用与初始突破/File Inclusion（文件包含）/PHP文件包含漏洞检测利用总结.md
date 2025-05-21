


漏洞原理
像PHP、JSP、ASP、.NET等脚本语言，都提供了一种包含文件的功能，通过这种方式可以达到复用代码的目的。如果包含的文件路径可控，那么就可能存在文件包含漏洞，攻击者可通过控制文件路径，达到信息泄露和代码执行的效果。

文件包含漏洞分类
文件包含漏洞可分为本地文件包含和远程文件包含。

常见漏洞函数
以下函数在进行文件包含时，包含的内容将直接当做php代码执行。可通过伪协议、相对路径、绝对路径方式进行包含。

```
include
require
include_once
require_once
```
以下函数在进行读取文件时，内容只被当做文本读取，可造成任意文件读取漏洞。支持伪协议、相对路径、绝对路径方式进行包含。通过http伪协议进行包含时，等同于服务器通过http方式访问，因此可将文件内容当做php代码执行。php://input、data://伪协议在这里不能执行命令。

```
highlight_file 
show_source 
readfile 
file_get_contents 
fopen 		//测试发现只有file和compress伪协议可用
file
```

相对路径访问
./表示当前路径
. ./表示上级路径
我想说的是(.之间没有空格，我输入的有空格):
xxx. ./这样也可以当做当前路径，xxx被解析成了一个目录，xxx目录的上级路径就是当前路径
xxx/xx. ./. ./也是当前路径。

常见伪协议及利用姿势
file://
可用于访问本地文件系统

格式file://绝对路径
限制条件：
绝对路径

allow_url_fopen:off/on

allow_url_include:off/on

利用姿势：
1.读取文件

2.在使用include、require、include_once、require_once时，可将文件当做php脚本执行（一般配合上传文件、写日志等方式getshell）。

php://filter
php://filter：是一种元封装器， 设计用于数据流打开时的筛选过滤应用。

格式：php://filter/参数/参数


字符串过滤器（通过管道符/连接，从左往右执行）

​ string.rot13 对字符串执行ROT13转换

​ string.toupper转换为大写

​ string.tolower 转换为小写

​ string.strip_tags去除html和php标记（可以用于绕过死亡EXIT）

转换过滤器

​ convert.base64-encode & convert.base64-decode ：base64编码/解码 （通过管道符/连接，从左往右执行）

​ convert.quoted-printable-encode & convert.quoted-printable-decode：将 quoted-printable 字符串转换为 8-bit 字符串

压缩过滤器（通过管道符/连接，从左往右执行）

​ mcrypt.tripledes和mdecrypt.tripledes等

限制条件：
allow_url_fopen:off/on

allow_url_include:off/on

相对路径/绝对路径

利用姿势：
1.读取文件

```
#resource为需要请求的资源：
php://filter/read=zlib.deflate/convert.base64-encode/string.toupper/resource=../index.php    将../index.php进行zlib压缩再base64再转为大写。

php://filter/read=convert.base64-encode/resource=xxx			将xxx进行base64显示	
```
2.在使用include、require、include_once、require_once时，可将文件当做php脚本执行(一般配合上传文件、写日志等方式getshell)。

php://filter/resource=xxx	
1
php://input
POST 请求的情况下，可以访问请求的原始数据的只读流。

格式: php://input，POST请求中写入脚本
限制条件：
allow_url_fopen ：off/on

allow_url_include：on

防坑指南：
hackbar中发送的POST请求进行了url编码的不行，需要直接使用burp来发送未url编码的脚本内容。





利用姿势：
直接的命令执行漏洞，可写入木马、执行系统命令等，可参考命令执行漏洞的利用和绕过方式。

#在当前路径写入一句话木马
<?fputs(fopen("shell.php","w"),"<?php eval($_post['xxx'];?>")?>	
#执行phpinfo
<?php phpinfo();?>
#执行系统命令
<?php system('whoami');?>
1
2
3
4
5
6
zip://
zip://, bzip2://, zlib:// 均属于压缩流

zip可以访问压缩文件中的子文件，更重要的是不需要指定后缀名

格式：zip://压缩包绝对路径%23压缩包内文件
限制条件：
绝对路径

allow_url_fopen ：off/on

allow_url_include：off/on

防坑指南：
#在url中代表页面中的一个位置，#后面的内容不会发送到服务器，所以必须将#编码为%23



利用姿势：
1.结合文件上传功能，可以将任意后缀的文件打包成压缩包，然后修改压缩包名为任意后缀上传。当使用include、require、include_once、require_once时，可将压缩包内的文件当做脚本执行。

compres.bzip2://
zip://, bzip2://, zlib:// 均属于压缩流，可以访问压缩文件中的子文件，更重要的是不需要指定后缀名。

compress.bzip2和compress.zlib访问的对象可以是任意后缀的文件。

格式compress.bzip2://相对路径或绝对路径
限制条件：
allow_url_fopen ：on/off

allow_url_include：on/off

相对路径/绝对路径

利用姿势：
1.读取文件

2.在使用include、require、include_once、require_once时，可将文件当做php脚本执行（一般配合上传文件getshell）。

compress.zlib://
zip://, bzip2://, zlib:// 均属于压缩流，可以访问压缩文件中的子文件，更重要的是不需要指定后缀名。

compress.bzip2和compress.zlib访问的对象可以是任意后缀的文件。

格式：compress.zlib://相对路径或绝对路径
限制条件：
allow_url_fopen ：on/off

allow_url_include：on/off

相对路径/绝对路径

利用姿势：
1.读取文件

2.在使用include、require、include_once、require_once时，可将文件当做php脚本执行（一般配合上传文件、写日志等方式getshell）。

data://
格式：data://text/plain;base64
限制条件：
allow_url_fopen ：on

allow_url_include：on

php>=5.2

利用姿势：
```
#省略text/plain
data://,<?php phpinfo();
data://,<?phpinfo();

data://text/plain,<?php phpinfo();
data://text/plain,<?phpinfo();

#PD9waHAgcGhwaW5mbygpPz4=是<?php phpinfo()?>进行base64编码
data://text/plain;base64,PD9waHAgcGhwaW5mbygpPz4=

#省略//
data:text/plain,<?php phpinfo();
data:text/plain,<?phpinfo();
data:text/plain;base64,PD9waHAgcGhwaW5mbygpPz4=
```

http://
http://可以用于本地文件包含和远程文件包含。

格式：http://xxx
限制条件：
allow_url_fopen ：on

allow_url_include：on

利用姿势：
通过http伪协议进行本地包含的文件，除了include、require、include_once、require_once函数能够将内容当做命令执行以外，highlight_file、show_source、readfile、file_get_contents、file函数在使用http伪协议时，等同于让服务器自己去访问了这个请求，所以可以通过http伪协议来达到执行php脚本的效果，可参考我的另一篇CTF文章https://blog.csdn.net/u013797594/article/details/118463622

通过http进行远程文件包含时，如果使用include、require、include_once、require_once则可以直接包含php脚本内容让服务器执行。

phar://
phar类似于JAR,主要用来给文件打包,phar://伪协议可以读打包后的文件。

格式：phar://归档文件/归档内的文件名
限制条件：
php>=5.3

phar.readonly = Off

相对路径/绝对路径

利用姿势
1.读取zip压缩包内容
phar支持zip的归档方式，可通过phar://伪协议读取zip中的内容，这里和zip的区别就是zip访问通过%23访问子文件，phar直接通过/访问子文件（一般配合文件上传getshell）。

php.xxx文件后缀任意，在里面写入php脚本语言

将phpinfo.xxx压缩成.zip文件，然后可以修改zip为任意后缀。

在文件包含漏洞处通过phar://相对路径或绝对路径zip压缩包名/压缩包中任意文件
1
2
3
4
5
2.phar反序列化漏洞
利用条件：
文件上传（不受后缀名限制）+文件包含（可用phar://伪协议，且使用了受影响函数会进行反序列化操作）+反序列化利用条件

其中反序列化的利用条件有2个：

1.上下文存在类的成员变量可控，存在魔术方法被自动调用，当魔术方法被调用时通过修改成员变量达到我们想要的目的。

2.反序列化生成的对象调用了对象的方法，如果存在内置类的方法和这个同名，那么就可以控制反序列化结果生成内置类对象，这样就能调用内置类的方法达到我们想要的目的了，可参考我的一篇CTF文章。https://blog.csdn.net/u013797594/article/details/118726467

绕过方式
%00截断
%00表示字符串结束，所以当url中出现%00时就会认为读取已结束

利用条件：
PHP<5.3.4

GPC off

当GPC开启后，%00会被转义。

大小写
利用条件：
代码正则匹配对大小写敏感，导致通过大小/小写绕过匹配规则。

绕过后缀
测试环境为windows，phpstudy，php5.2。

根据我的测试结果，文件名后面添加 空格 + . “ < > ::$DATA 这几个符号后也是可以正常进行包含的，可以用于绕过正则掉后缀名的限制。（其中&和#在url中有特殊意义，分别用于分割参数和表示页面位置，即使我通过Burp发送了这2个字符php好像也并没有当做文件名接收；+号被转义成了空格)



顺便又发现几个奇怪的姿势：

flag<.php、flag>.php、flag.<php 这样也能被成功包含。





双写
…/./被…/后会剩下…/

利用条件：
绕过过滤…/的情况

长度截断
这个我没测试出来，用的应该不多

去掉后缀
如flag，会自动拼接上后缀 flag.php

利用条件：
代码上去掉了文件后缀，自行拼接了固定文件后缀

## 工具

### # lfi-dic-creater文件包含漏洞字典生成工具

[LFI文件包含漏洞字典生成器](https://github.com/StormEyePro/lfi-dic-creater)

使用条件：
```
python3 +windows
```
安装

[](https://github.com/StormEyePro/lfi-dic-creater#%E5%AE%89%E8%A3%85)
```
pip3 install -r requirement.txt
```
直接运行
```
python3 lfi_gui.py
```
打包成exe:

这种方式打包出来运行速度比较快，-F打包的运行起来可能很慢
```
pyinstaller -c lfi_gui.py --noconsole
```
打包后把config、tmp、xuyaode 这三个文件夹放到生成的目录里面。

### 文件包含漏洞检测工具fimap

https://blog.csdn.net/QoTypescript/article/details/133542161

————————————————
原文链接：https://blog.csdn.net/u013797594/article/details/118865974