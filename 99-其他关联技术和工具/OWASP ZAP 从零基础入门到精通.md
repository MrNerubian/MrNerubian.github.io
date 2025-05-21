# Web漏扫工具OWASP ZAP安装与使用（非常详细）从零基础入门到精通，看完这一篇就够了。


本文链接：https://blog.csdn.net/yy1715713348/article/details/137930126

### 一、OWASP ZAP简介

开放式[Web应用程序](https://so.csdn.net/so/search?q=Web%E5%BA%94%E7%94%A8%E7%A8%8B%E5%BA%8F&spm=1001.2101.3001.7020)安全项目（OWASP，Open Web Application Security Project）是一个组织，它提供有关计算机和互联网应用程序的公正、实际、有成本效益的信息。ZAP则是OWASP里的工具类项目，也是旗舰项目，全称是OWASP Zed attack proxy，是一款web application 集成渗透测试和漏洞工具，同样是免费开源跨平台的。  
ZAP是一个中间人代理，浏览器与服务器的任何交互都将经过ZAP，ZAP则可以通过对其抓包进行分析、扫描。  
ZAP官方网站：

```
https://www.zaproxy.org/download/
```

官方文档：
```
https://www.zaproxy.org/docs/
```
### 二、OWASP ZAP安装

① ZAP支持在Windows、Linux、MacOS等平台上运行，可以在官网直接下载数据包，Windows和Linux版本需要运行Java 8或更高版本。  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/9dc1f3090220badfd893587174a98412.png)

② Kali Linux系统中，内置了ZAP软件，可直接使用：  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/93826c947a72a911273d84ee5c277e09.png)

## 三、OWASP ZAP使用

### 保持会话

保存会话会将会话结果记录到数据库中，不保存则会在退出ZAP时被删除。  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/5090bf033e88f72dfe5ce45dd859f54c.png)

### 用户界面

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/9ab53df43d0edd4a42f20c3ef39cde01.png)
    
### 自动扫描

点击“快速开始”–>“`Automated Scan`”，输入要攻击的完整URL，可以选择勾选spider，ZAP提供spider进行Web的页面扫描，发现所有的页面。对于AJAX应用程序，可使用AJAX spider。点击“攻击”开始扫描。  
    ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/ca50bc2aa057d878091f3b02eb44e526.png)
    
### 扫描结果  

点击攻击后，ZAP便开始爬取Web应用程序，展示扫描的进度与每个页面的请求和响应：  
    ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/2e0298dcfe1f2ebc68788e38a9188d4d.png)
    

扫描完成后，可在“警报”TAB中查看潜在安全漏洞与详情：  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/7a6947e55ca63fb9d03cce20a5628990.png)

### 手动探索  

在快速开始界面，点击“`Manual Explore`”手动探索，输入要探索的Web应用程序的URL，选择需要使用的浏览器，点击启动浏览器：  
    ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/5204a68983b5ca8d78ba276b7bc41e26.png)

ZAP提供了HUD功能，是一种可以直接在浏览器中访问ZAP的 功能，可以在访问Web时，提供关键的安全信息和功能：  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/ff5587dd4f3b73c4234853deb5ebd470.png)

此时便可与浏览器交互登录等操作的同时，ZAP进行同步探索：  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/1fa1783aa9e769021027556677203573.png)

点击不同的页面，右下角会弹出已扫描出的漏洞告警。  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/f26bbaa4e07dde8c5866bd6c19625f3a.png)

将页面尽可能遍历后，查看站点树，会将有警报的站点标识出来：  
![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/2cd5c93e3bd185f68b33cd447db4cb1f.png)

### 单目标攻击

右键站点树的某个子路径，可对单个目标进行“攻击”：  
    ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/6d4e449ac52216379f6397490602b384.png)

使用“爬行”、“强制浏览网站”、“强制浏览目录”、“强制浏览目录和子页面”将页面路径记录的更全，然后再使用“主动扫描”等其他方式进行进一步的测试。

### 生成报告  

所有扫描完成后，点击“报告”，生成HTML报告：  
    ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/6ede663b44c52c5f4406b72a2cabc779.png)  
    ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/9afdbce488e2ed1fc973a98d54e1522e.png)
