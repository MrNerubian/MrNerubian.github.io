# 1.Burp Suite 入门篇 —— 介绍与安装

本文链接：https://blog.csdn.net/YouTheFreedom/article/details/137375400

## BurpSuite 介绍

**burpsuite 是一款针对 Web 应用程序安全测试和漏洞利用的集成平台**。它由 PortSwigger 公司开发，是广泛使用的 Web 应用程序渗透测试工具之一，并且提供了多个模块和功能，用于发现和利用Web应用程序的安全漏洞。它广泛应用于渗透测试、代码审计、安全研究等领域。

## 入门必备工具

作为初学者，入门必须要掌握的第一个渗透测试工具就是 burpsuite。burpsuite 提供了直观的用户界面和易于使用的功能，使其成为新手友好的工具。**它的图形界面使得配置和使用变得相对简单，即使对于没有编程或命令行经验的人来说，也可以轻松上手**。而且 burpsuite 也是业界最受欢迎和广泛使用的渗透测试工具之一，许多安全测试专业人员和机构都使用 burpsuite 进行日常的 Web 应用程序渗透测试。

## 学习目标

本次 burpsuite 教程系列文章目的是为了**帮助初学者快速了解并熟练掌握 burpsuite 工具的使用**，包括下载安装，代理抓包，改包，重放，插件安装与使用，自动扫描等等。

除此之外，**文章还会介绍如何用 burpsuite 开展简单的渗透测试流程，初步了解一些了解常见漏洞**，让同学们在实战中循序渐进，加深理解和巩固所学知识。

## 系统配置要求

首先我们来看下 burpsuite 对操作系统的配置要求，因为**如果软件安装方式不正确，系统环境不兼容的话，也会导致软件安装失败或者不能正常使用**。

burpsuite 对操作系统配置的要求在很大程度上取决于你怎么用。比如我们通常可以在一台配置较低的机器上执行大多数任务，但如果有时候同时运行多个扫描任务，就需要更多资源，否则可能会影响操作系统正常运行。

### [CPU](https://so.csdn.net/so/search?q=CPU&spm=1001.2101.3001.7020) 核数 / 内存

> * **最低**：2x cores, 4GB RAM，系统至少有2个处理器核心和4GB的内存，适用于基本任务，如代理网页流量和简单的 Intruder 攻击。**虽然 burpsuite 在比这个配置更低的机器上也能运行，但出于性能原因，不建议这样做**。
> * **推荐**：2x cores, 16GB RAM，推荐操作系统至少有2个处理器核心和16GB的内存。
> * **高配**：4x cores, 32GB RAM，该配置适用于更多并发任务，如复杂的 Intruder 攻击或大规模自动化扫描。

### 磁盘可用空间

> * 安装占用空间：1GB
> * 项目文件占用空间：2GB

要注意的是，**这里的 2GB 硬盘空间只是保存项目文件的最小推荐**，有时一个项目文件比这个大得多，可能高达几十GB。因为项目文件保存的内容包括了代理抓包的历史记录、运行的扫描结果和打开的Repeater选项卡等等。

### 操作系统和架构

burpsuite 支持下面最新版本的操作系统：

> * Windows (Intel 64-bit)
> * Linux (Intel and ARM 64-bit)
> * OS X (Intel 64-bit and Apple M1)

### 内置浏览器

burpsuite 有内置浏览器，但不兼容以下版本的操作系统：

> * 不兼容 Windows 7、Windows 8/8.1、Windows Server 2012、Windows Server 2012 R2 等旧版本的操作系统。
> * burpsuite 不能通过 JAR 文件在基于 Apple Silicon 和 ARM 64 位的操作系统上运行，如果想使用 burpsuite 内置浏览器，必须要用本地系统架构的安装包来安装。

**提示**：如果使用安装包安装的 burpsuite，可以同时运行多个 Burp 进程。但如果是从 JAR 文件运行的 Burp 进程，数量不受限制。

## 下载和安装

如果同学们已经搭建好了 kali 或 windows10 虚拟机渗透测试工具集成环境，就不用看这部分内容了。虚拟机搭建详情可参考这两篇文章：

[[Kali linux/00.VMware虚拟机快速搭建win10渗透测试工具集成环境|00.VMware虚拟机快速搭建win10渗透测试工具集成环境]]

[[Kali linux/01.VMware 虚拟机快速搭建 kali 渗透测试工具集成环境|01.VMware 虚拟机快速搭建 kali 渗透测试工具集成环境]]

但是不排除个别同学只想安装一个 burpsuite 来入门学习，所以在此简单讲下 Burpsuite 的安装步骤。

### BurpSuite_2024.2.1.3 社区版官网安装

burpsuite 有社区版，专业版和企业版，其中社区版是免费的，虽然个别功能使用会受限，但对初学者入门足够使用，**想安装专业版的可参考下一段 BurpSuite_2022.1.1 专业版 Jar 包安装**。

#### 下载安装

社区版下载地址：
- [Burp Suite Release Notes](https://portswigger.net/burp/releases#community)

![](https://minioapi.nerubian.cn/image/20250417114300978.png)

#### 测试运行

下载安装包后默认安装即可，然后打开运行

![](https://minioapi.nerubian.cn/image/20250417121720927.png)

点击 next，下一步

![](https://minioapi.nerubian.cn/image/20250417121727484.png)

点击 start burp

![](https://minioapi.nerubian.cn/image/20250417121724558.png)

开启内置浏览器，选项卡 Proxy -> Intercept -> Open browser

![](https://minioapi.nerubian.cn/image/20250417121732040.png)

在内置浏览器地址栏输入 baidu.com，然后确认

![](https://minioapi.nerubian.cn/image/20250417121737364.png)

开启内置浏览器，选项卡 Proxy -> HTTP History，**看到成功抓包记录**

![](https://minioapi.nerubian.cn/image/20250417121742627.png)

### BurpSuite_2022.1.1 专业版 Jar 包安装

#### 工具下载

burpsuite 软件和 JDK 15 已打包上传，大家需要的话可以自取

> 链接：[百度网盘](https://pan.baidu.com/s/1O7vx6Kn2s5iFTpJMdLYjHQ?pwd=ch36 "百度网盘")
> 
> 提取码：ch36

#### 搭建 JAVA 运行环境

burpsuite 是 java 开发的，所以**要想通过 jar 包运行 burpsuite 必须要先搭建 JAVA 运行环境**，具体步骤可参考如下文章：

[JDK15的下载和安装笔记 - 知乎学习Java，其前提是安装和配置JDK（java development kit java开发工具包），然后就可以使用Java。 1.JDK的下载下载地址： Java SE Development Kit 15点击链接，根据系统需要选择合适的版本，我这里选择Windows压…![icon-default.png?t=N7T8](https://i-blog.csdnimg.cn/blog_migrate/003a2ce7eb50c2e24a8c624c260c5930.png)https://zhuanlan.zhihu.com/p/274495592](https://zhuanlan.zhihu.com/p/274495592 "JDK15的下载和安装笔记 - 知乎")

#### 注册激活

首次运行 burpsuite 需要激活，先双击 jar 包 burpsuite_loader.jar

![](https://i-blog.csdnimg.cn/blog_migrate/aecc8589aaeb0b794f7742bb63f4a848.png)

复制 License 中的内容然后点击 run 按钮

![](https://i-blog.csdnimg.cn/blog_migrate/b3155ac2948fbfec7d209fd68cb45c64.png)

弹出新的注册窗口，将 License 粘贴进文本框后，点击 next 下一步

![](https://i-blog.csdnimg.cn/blog_migrate/9cec8701313e47ea1249794f2d10b63c.png)

点击 Manual activation 进行手动激活

![](https://i-blog.csdnimg.cn/blog_migrate/94d4681cacba5fca4a7bb1440ec0291b.png)

点击下图红框中的按钮，拷贝激活请求内容

![](https://i-blog.csdnimg.cn/blog_migrate/5df5ac89ac28afc974a69911a649b360.png)

**不要关闭注册窗口**，回到最初打开的激活 jar 包程序窗口，把刚才复制的激活请求复制到第二个文本框中，也就是 Activiation Request 的位置里，最后一个文本框 Activiation Response 会自动生成并显示出激活响应，然后**复制这部分生成的内容**

![](https://i-blog.csdnimg.cn/blog_migrate/e3487011ac7907a6b7be14f0b9e3f47c.png)

点击 Paste Response 按钮或者 Ctrl + V 粘贴刚才复制的内容到最后注册窗口的第三个文本框里，点击 Next 按钮

![](https://i-blog.csdnimg.cn/blog_migrate/cf5c875b8f8f030f464b5b1975244778.png)

出现下面提示代表 burpsuite 激活成功，点击 Finish 完成

![](https://i-blog.csdnimg.cn/blog_migrate/3f871360d8d1ebc13985981c68aa22ab.png)

查看注册信息是已激活状态

![](https://i-blog.csdnimg.cn/blog_migrate/9ad42aeaae99aa42bb50cd68b1c5654d.png)

#### 脚本运行

由于运行 burpsuite 需要加载激活 jar 包，但每次打开时输入命令行的话又很繁琐，所以把命令行写入脚本，双击后自动运行命令就很方便啦

run.vbs 脚本已写好，命令内容如下：

```bash
`createobject("wscript.shell").run "javaw.exe --illegal-access=permit -Dfile.encoding=utf-8 -javaagent:burpsuite_loader.jar -noverify -jar burpsuite_pro_v2022.1.1.jar",0`
```

按照教程默认安装好 JDK 15后**双击启动脚本 run.vbs** 即可打开 burpsuite

![](https://i-blog.csdnimg.cn/blog_migrate/d2465024425b7fb227d50fd5edbddb37.png)

![](https://i-blog.csdnimg.cn/blog_migrate/40ed7a969992a45a3c9034dc047bac1e.png)

#### burpsuite 汉化

直接**双击 run_cn.vbs 脚本**即可，命令内容如下：

```bash
`createobject("wscript.shell").run "javaw.exe --illegal-access=permit -Dfile.encoding=utf-8 -javaagent:burpsuite_cn.jar -noverify -jar burpsuite_pro_v2022.1.1.jar",0`
```

![](https://i-blog.csdnimg.cn/blog_migrate/156f8c2043db073f9d365ee82a71b676.png)

打开后就能看到中文版的菜单了

![](https://i-blog.csdnimg.cn/blog_migrate/cfc094d11bae716aa21b1f2a80a384c8.png)

**注：推荐使用英文原版，因为汉化有时会打乱菜单排版，而且以后英文界面的渗透工具有很多，还是推荐大家要把英文学好呀**

# 2.Burp Suite 入门篇 —— HTTP 流量抓包

## 前言

**本篇文章会教你怎么用 Burp Proxy 拦截 HTTP 请求**，为方便学习， [burpsuite](https://so.csdn.net/so/search?q=burpsuite&spm=1001.2101.3001.7020) 官网还特意设计了有漏洞的在线网站供大家训练。

## 拦截抓包

**burpsuite 抓包的原理是通过 Burp Proxy 代理浏览器和目标服务器之间发送的 HTTP 请求和响应。**

这样就能方便观察和研究用不同方式请求时服务器的响应。原理示意图如下：

![](https://minioapi.nerubian.cn/image/20250417114433822.png)

### 启动 burp 内置浏览器

有经验的同学肯定知道用老版本 burpsuite 抓包还需要设置本地的浏览器代理， HTTPS 抓包还要导入证书，但新版本的 burpsuite 自带浏览器，不需要用户配置就能直接访问页面抓包，所以这里我们就省去那些繁琐步骤，**直接用 burp 的内置浏览器更香。**

首先，转到 Proxy > Intercept 选项卡

![](https://minioapi.nerubian.cn/image/20250417122038278.png)

单击按钮 Intercept is off，切换到 Intercept is on 状态，点击 Open Browser，打开内置浏览器

![](https://minioapi.nerubian.cn/image/20250417122041514.png)

启动 Burp 的内置浏览器后，把浏览器窗口放在一个合适的位置，方便后续同时观察 Burp 和 浏览器的内容变化

![](https://minioapi.nerubian.cn/image/20250417122045023.png)

### 拦截请求

在内置浏览器里访问 [https://portswigger.net](https://portswigger.net) ，会发现该站点无法加载，右侧浏览器页面标签上一直在转圈。

这是浏览器发出请求后等待服务端响应的状态。

**实际情况是 Burp Proxy 把浏览器请求服务器的 HTTP 报文给拦截了。**

在 Proxy > Intercept 选项卡上就能看到被截获的请求报文，这就是我们要抓的请求包。

**有了请求包，我们就可以在将其转发到目标服务器之前研究它，甚至修改它。**

![](https://minioapi.nerubian.cn/image/20250417122051509.png)

### 转发请求

多次单击 Forward 按钮来转发被截获的请求和任何后续请求，直到页面在 Burp 的浏览器中都加载完。

![](https://minioapi.nerubian.cn/image/20250417122056755.png)

### 关闭拦截

访问网站时浏览器通常会发送很多请求，但大部分不一定是我们想要拦截抓包的。

这时候可以点击 `Intercept is on`，切换成 `Intercept is off`。

然后再去内置浏览器里点击页面按钮，就会发现 Burp Proxy 不再拦截请求，页面也不会卡，能正常访问了。

![](https://minioapi.nerubian.cn/image/20250417122104453.png)

### 查看 [HTTP 抓包]记录

切换到 burpsuite 的 Proxy > HTTP History 选项卡。

在选项卡里可以看到经过 Burp Proxy 代理的所有 HTTP 流量的历史记录，即使在关闭拦截的情况下也能捕捉到。

单击历史记录中的任意一条，然后在选项卡下面查看原始的 HTTP 请求和对应的服务器响应

通过 burpsuite 的抓包功能，我们**既可以有针对性地拦截捕捉某些网络请求的流量，**

**也能先正常访问网站，然后再去历史记录里面查看客户端和服务器之间的通讯过程和内容**，非常灵活方便。

![](https://minioapi.nerubian.cn/image/20250417122125327.png)

# 3.Burp Suite 入门篇 —— 修改请求

## 前言

**本篇文章会教你如何用 Burp Proxy 修改截获的请求。**

修改请求包是为了通过网站程序规定之外的方式请求，然后对比查看响应内容的变化，判断是否有漏洞存在。[burpsuite](https://so.csdn.net/so/search?q=burpsuite&spm=1001.2101.3001.7020) 官网提供了配套的学习靶场 labs（实验室），方便我们在实战模拟环境里识别和利用漏洞。

## 官网注册

要访问靶场的话，需要先在 burpsuite 官网 [https://portswigger.net](https://portswigger.net/ "https://portswigger.net ") 上免费注册帐户。

进入官网后点击页面右上角登录按钮 login

![](https://i-blog.csdnimg.cn/blog_migrate/ac5949627165e4a68e76c0d5a92c0534.png)

点击右下角 Create account 注册按钮

![](https://i-blog.csdnimg.cn/blog_migrate/bbe57ac7fa44488060f62b979b536056.png)

按提示写好自己的邮箱地址

![](https://i-blog.csdnimg.cn/blog_migrate/2978afde0123880d1cc0eb2ae88114e2.png)

然后按提示到自己邮箱查看注册邮件，

![](https://i-blog.csdnimg.cn/blog_migrate/a70bbb8430ddbee641e3b988027f5618.png)

点击右键中的 Click here 链接

![](https://i-blog.csdnimg.cn/blog_migrate/db15d28286e726847da5c175e0d2ff4e.png)

然后进入新页面，按提示输入自己的昵称，点击 Register 注册

![](https://i-blog.csdnimg.cn/blog_migrate/64093fc759682d3c092926ccb2f3f93a.png)

**进入到密码页面，该页面无法再次打开，所以一定要记好密码哦**

也可以点击右侧的 COPY PASSWORD 按钮一键复制密码，保存好密码后退出页面

![](https://i-blog.csdnimg.cn/blog_migrate/6824c679c65b95b57ef8f81ad832c37e.png)

最后到登陆页面，填写自己的账号密码确认，就可以进入个人主页了

![](https://i-blog.csdnimg.cn/blog_migrate/83207bc4f7a15ee8772c990b118f5e23.png)

## Burp 浏览器访问漏洞页面

打开 burpsuite，转到 Proxy > Intercept 选项卡，确保拦截按钮已关闭

启动 Burp 浏览器并访问下面网址：

[Lab: Excessive trust in client-side controls | Web Security Academy](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-excessive-trust-in-client-side-controls "Lab: Excessive trust in client-side controls | Web Security Academy")

点击页面按钮 ACCESS THE LAB，进入靶场

![](https://i-blog.csdnimg.cn/blog_migrate/88992d01257bf37d318fb2af6663359d.png)

如果提示登陆，就先登陆之前注册好的 Burp 官网账号，等页面加载几秒钟后，就能看到靶场的虚拟[购物网站](https://so.csdn.net/so/search?q=%E8%B4%AD%E7%89%A9%E7%BD%91%E7%AB%99&spm=1001.2101.3001.7020)了。

![](https://i-blog.csdnimg.cn/blog_migrate/addce42bfd1d02f8edb57053e71f8438.png)

![](https://i-blog.csdnimg.cn/blog_migrate/1a6a6cf7b5bc753725cc595c265cc596.png)

## 登陆购物网站账号

点击购物网站靶场页面的 My account，使用以下凭据登录：

> Username: wiener
> 
> Password: peter

![](https://i-blog.csdnimg.cn/blog_migrate/a441e40eacdf2b2c1f5444f7bdd36a29.png)

登陆后账户有 $100 的商店积分

![](https://i-blog.csdnimg.cn/blog_migrate/d4950ffe0a7729ba5b1e1f18c0e54886.png)

点击右上方 Home，返回商场主页，选择商品 Lightweight "l33t" Leather Jacket，点击下方 View details 查看商品详情

![](https://i-blog.csdnimg.cn/blog_migrate/cfe6d9100aaf964a1ea1a914e69f8cfa.png)

burpsuite 切换到 Proxy > Intercept 选项卡，打开拦截功能

返回浏览器页面，点击商品详情页面底部的 Add to cart 添加到购物车

Burp 会自动拦截生成的 POST /cart 请求。

> **注意：**
> 
> 如果浏览器正在后台执行其他请求操作，开始可能会在 Proxy > Intercept 选项卡上看到不同的请求。
> 
> **这时候只需点击 Forward，直到看到报文内容第一行是 POST /cart 请求**，如下面的截图所示。

![](https://i-blog.csdnimg.cn/blog_migrate/c0d48b57f3d763d4f786e5032aeca9f8.png)

## 修改请求包

修改报文里的 price 参数值为1，然后单击 Forward 把修改后的请求转发给服务器。

![](https://i-blog.csdnimg.cn/blog_migrate/f73cfc73ed45c73fbb275367c366e2de.png)

再次关闭拦截功能，以便任何后续请求都可以直接通过 Burp Proxy，不影响页面的正常访问。

## [漏洞挖掘](https://so.csdn.net/so/search?q=%E6%BC%8F%E6%B4%9E%E6%8C%96%E6%8E%98&spm=1001.2101.3001.7020)

回到 Burp 浏览器页面，单击右上角的购物篮图标

![](https://i-blog.csdnimg.cn/blog_migrate/e5a9c153b74a38a95b4bbd8c65df7990.png)

这件夹克在购物篮里的价格被我们修改到了只有一美分

![](https://i-blog.csdnimg.cn/blog_migrate/fcddac7e3667bf053100b0e5f9953cc0.png)

在日常的网上购物中，我们很难通过页面修改价格

但是**通过 burp 能轻易地修改请求里的价格参数，从而发现隐藏的漏洞**

# 4.Burp Suite 入门篇 —— 设置抓包范围 target scope

## 前言

**本篇文章主要讲如何在使用 burpsuite 时设置 target scope，也就是抓包的目标范围**。

目标范围限制了 burp 只捕获要测试的 URL 地址或域名。

这样就能够**过滤掉浏览器和其他网站产生的无关流量，只保留我们需要的流量记录**。

## 启动内置浏览器

启动 burp 内置浏览器，访问下面的靶场网址：

[Lab: Information disclosure in error messages | Web Security Academy](https://portswigger.net/web-security/information-disclosure/exploiting/lab-infoleak-in-error-messages "Lab: Information disclosure in error messages | Web Security Academy")

点击页面按钮 ACCESS THE LAB，进入靶场

如果有提示，登陆之前注册好的 Burp 官网账号，等页面加载几秒钟后，就能看到靶场的虚拟购物网站了。

![](https://i-blog.csdnimg.cn/blog_migrate/e73e05fe2448f6e0a2193bdecf9a33b8.png)

## 浏览目标网站

在浏览器里点击商品页面来访问目标网站

![](https://i-blog.csdnimg.cn/blog_migrate/e4b1ee1e559feb2bf11279d8f50fc75a.png)

## 查看 [HTTP](https://so.csdn.net/so/search?q=HTTP&spm=1001.2101.3001.7020) 记录

burp 切换到 Proxy > HTTP history 打开历史记录选项卡。

单击最左边列的标题(#)，流量记录会按降序进行排序。

**这样就能很方便的从顶部查看最近的请求**。

![](https://i-blog.csdnimg.cn/blog_migrate/f82b24dc07efd906721cf000f39ea01a.png)

细心的同学会发现，上图的 HTTP 历史记录里有浏览器发出的每个请求的详细信息

还包括了与本次访问的目标网站不相关的第三方网站流量，如 YouTube 和 Google Analytics 等。

**虽然第三方网站流量不是我们关注的重点，但太多的话会严重影响我们研究目标网站流量**，

所以我们需要过滤掉这些干扰流量。

## 设置目标范围 target scope

切换到 Target > Site map 标签，左侧面板记录了浏览器访问过的的域名列表。

**右键点击列表中的目标网站，选择 Add to scope**。

![](https://i-blog.csdnimg.cn/blog_migrate/49a5149038181f941fd929f1b38164fd.png)

弹出提示窗口，单击 “yes” 以过滤目标网站范围外的流量记录。

![](https://i-blog.csdnimg.cn/blog_migrate/671bf274f3771b6662d06e6cd8f6dda8.png)

## 过滤 HTTP 流量记录

点击 HTTP history 标签下方的筛选器

弹出过滤选项窗口，**勾选 Show only in-scope items，仅显示目标范围内的历史记录**。点击 Apply 确认退出

![](https://i-blog.csdnimg.cn/blog_migrate/bd88ec037e89614f7b5d791f65878642.png)

重新查看 HTTP 历史记录，就只剩下目标网站流量记录了，其他网站都会被隐藏。

**接下来浏览目标站点时，目标范围之外的流量也不再被记录到 site map（站点地图） 或流量历史记录中**。

![](https://i-blog.csdnimg.cn/blog_migrate/994ff485e593e6cfec85a2c6deac43c8.png)

到此我们已经成功地学会如何设置 target scope，有效地过滤和简化了 HTTP 流量记录

# 5.Burp Suite 入门篇 —— Burp Repeater 重放请求


**本篇文章会教你如何使用 Burp Repeater 重放特定请求。**

挖掘漏洞时，重放请求可以帮助我们**研究用户输入不同参数时对目标网站的影响**。

重放请求时，我们也不需要每次都靠点击页面拦截请求实现。

重放请求也使得 Burp Scanner 扫描漏洞变得更加简单，有关 Burp Scanner 我们会在后面的课程中详解。

## 添加请求到 Burp Repeater

Burp Repeater 通常从 burpsuite 的其他组件里加载请求报文。

比如我们可以从 Burp Proxy 的 HTTP 历史记录里发送请求给 Burp Repeater。

### 选择请求记录

继续上一篇文章，我们打开 burp 官网提供的购物网站当作漏洞靶场。

每次访问产品页面时，浏览器都会发送一个 HTTP 协议的 GET /product 请求，并带有查询参数 productId 。

为进一步研究请求过程，我们可以把它发送到 Burp Repeater 里面进行重放

![](https://i-blog.csdnimg.cn/blog_migrate/780e6d476e998cb89801e3e5bd254543.png)

### 添加请求到 Burp Repeater

如下图所示，右键点击 GET /product?productId=\[…\] 请求记录，并选择 Send to Repeater。

也可以直接用快捷键 Ctrl + R 发送给 Repeater。

![](https://i-blog.csdnimg.cn/blog_migrate/d4e20ff83970327f9d7e063b307bfc7f.png)

然后切换到 Repeater 标签查看是否有刚才新添加的请求报文页

![](https://i-blog.csdnimg.cn/blog_migrate/c924363d7429bcb4bd4dafba3104f513.png)

### 发送请求并观察响应

点击 Send 按钮并查看服务器的响应。

可以多次发送，重放该请求，每次服务器都会返回新的响应。

![](https://i-blog.csdnimg.cn/blog_migrate/01561bfcdce821a3b533e1612805e0b2.png)

## Burp Repeater 发送[不同的](https://so.csdn.net/so/search?q=%E4%B8%8D%E5%90%8C%E7%9A%84&spm=1001.2101.3001.7020)请求参数

渗透用 [Burp Suite](https://so.csdn.net/so/search?q=Burp%20Suite&spm=1001.2101.3001.7020) 进行手动测试时会经常**把同一个请求，修改成不同的参数值后发送**。

通过这种方式可以发现很多基于用户输入导致的漏洞。

### 修改参数后重新发送

修改 productId 参数值并重新发送请求。

修改参数值可以用一些任意数字，包括一些较大的数字，比如把 productId 值修改为 100。

![](https://i-blog.csdnimg.cn/blog_migrate/c2e2bf0af61d3c277be3ef6ed36321e6.png)

### 查看请求历史

如下图所示，点击 &lt; 和 &gt; 箭头可以切换请求历史记录，查看发送过的请求和响应内容。

每个箭头旁边的下拉菜单还能列出所有请求记录，点击后直接跳转到指定的请求记录。

![](https://i-blog.csdnimg.cn/blog_migrate/ed50b310b96c29fc281b6f4cb782c2ca.png)

**为进一步研究请求参数值变化对服务器响应的影响，有时需要把请求内容和响应结果跟上一次的记录做比对**

所以 Burp Repeater 能够快速调出之前的请求和响应结果就非常方便有效

对比之前的请求和响应结果，会发现**输入不同的产品参数 productId 能返回不同产品的详情页面**。

但是如果产品 ID 不存在，服务器就会返回 Not Found。

到这一步我们已经知道了这个页面的响应规律，然后试着用 Burp Repeater 发送不规范的输入看看会发生什么。

### 发送不规范输入

从业务逻辑上分析，服务器应该希望收到的 productId 参数是一个整数值。

如果我们发送不同的数据类型会发生什么呢？

把 productId 值修改成字符串 test 然后发送

![](https://i-blog.csdnimg.cn/blog_migrate/3d6bd383ef3b1fc15300583bd383795d.png)

### 查看响应

如下图所示，productId 值修改成字符串发送后会导致服务器异常。

而且服务器响应里还有详细的堆栈跟踪信息

![](https://i-blog.csdnimg.cn/blog_migrate/6908fdd8a11307d739aceed15992522b.png)

从服务器响应里可以看出网站使用的是 Apache Struts 框架，甚至暴露了具体版本。

![](https://i-blog.csdnimg.cn/blog_migrate/140a298f45f5b05c5f812c30509f0b3f.png)

在现实情况中，组件版本信息可能对攻击者非常有用，特别是在组件版本有公开声明的漏洞的情况下。

回到靶场页面，点击页面顶部的 Submit solutions 按钮提交解决方案

然后输入响应里发现的 Apache Struts 版本号 (2 2.3.31)

![](https://i-blog.csdnimg.cn/blog_migrate/7eda573e14b205870ef51ccdff49de1a.png)

点击确定，如果页面有如下提示，就代表提交的漏洞信息有效

![](https://i-blog.csdnimg.cn/blog_migrate/87258af7618edbdb26913e9cf2632f69.png)

到此为止，你已经能用 Burp Repeater 对网站的进行最简单的渗透测试了，还成功发现了一个**信息泄露漏洞**。

# 6.Burp Suite 入门篇 —— Burp Scanner 漏洞扫描


## 前言

**Burp Scanner 既可以是独立的全自动扫描器，也可以在手动测试中当作强大的辅助手段。**

而且随着技术改进，Burp Scanner 能检测到的漏洞数量也在不断增加。

Burp Scanner 扫描网站分两个阶段：

* **爬取网站内容和功能**：Burp Scanner 首先会模仿用户的一些日常行为，通过多种方式对目标网站进行访问和交互，然后对站点的结构和内容进行记录，构建出简洁明了的树状站点地图。
* **漏洞审计**：扫描的审计阶段主要是分析网站行为，以识别各种安全漏洞和其他问题。

**Burp Scanner 功能只在 burpsuite 专业版和企业版中里有，本篇教程讲的是专业版的 Burp Scanner 用法。**

## 扫描网站

接下来介绍怎么用 Burp Scanner [自动扫描](https://so.csdn.net/so/search?q=%E8%87%AA%E5%8A%A8%E6%89%AB%E6%8F%8F&spm=1001.2101.3001.7020)漏洞。

### 打开扫描启动页面

打开 Dashboard 标签页选择 New scan，新建扫描任务

![](https://i-blog.csdnimg.cn/blog_migrate/48b007e7378dbdbd1f7d5883ad01d4a4.png)

打开扫描启动对话框后，可以看到有各种参数用来制定扫描任务

### 填写目标网站地址

找到 URLs to scan 文本框，填写 ginandjuice.shop。

**记得取消之前学习 [设置目标范围 target scope](https://blog.csdn.net/YouTheFreedom/article/details/137541758 "设置目标范围 target scope") 时添加的过滤条件**，其他选项保持默认，不然就没法捕捉到访问新域名的网络流量啦

![](https://i-blog.csdnimg.cn/blog_migrate/b9297c254a6552cf12d649aa34c73cb8.png)

**Burp Scanner 扫描漏洞时可能会导致某些应用程序异常甚至崩溃，除非你对 Burp Scanner 各项配置和功能都很熟悉，而且得到被扫描系统管理员的授权，否则不要扫描线上的生产系统和第三方网站。**

### 配置扫描参数

选择 Scan configuration 对 Burp Scanner 的各方面参数进行微调，以适应不同的测试用例和目标站点。

初次学习我们先尝试 Use a preset scan mode （预设扫描模式），然后单击 Lightweight。

**轻量级扫描模式旨在尽可能快地对目标进行大致扫描，用时最多运行15分钟。**

![](https://i-blog.csdnimg.cn/blog_migrate/741faa9a65e669d0c2673d9e47d7123a.png)

### 开始扫描

点击 OK，Burp Scanner 开始扫描你上一步填写的 URL 地址所在的网站。

然后仪表板下面会出现一个当前漏洞扫描任务的进度条。

**点击任务部分，直接查看任务状态和的其他详细信息。**

![](https://i-blog.csdnimg.cn/blog_migrate/e99849bb47f6dbf11bfaa52a6b9cf012.png)

### 查看网站结构

Burp Scanner 扫描时切换到 Target > Site map 站点地图标签页。

双击 ginandjuice.shop 展开该网站节点，**burpsuite 会把爬取到的网站页面和目录结构用树状图的方式展示出来**。

如果再等一会儿，就会发现站点地图还在不断实时更新。

![](https://i-blog.csdnimg.cn/blog_migrate/59c4bc874ec7ab41bd01b2ece7b978b9.png)

### 查看扫描结果

在 Dashboard 标签页里可以实时查看扫描状态。

爬取网站结束后，Burp Scanner 开始审计漏洞。

如下图所示，点击左侧任务进度部分，右侧会展开任务相关信息。

切换到任务详情的 issues 标签，就能查看扫描出的所有安全事件了

![](https://i-blog.csdnimg.cn/blog_migrate/fabfdc3d3f9ae9c5a94a96a42b2a8f77.png)

右侧 issues 标签随机选择一条安全事件记录，下面会出现 Advisory，也就是安全建议选项卡。

**选项卡内容包含有关事件类型的关键信息，包括安全事件的详细描述和一些补救建议。**

右侧几个选项卡是 Burp Scanner 发现此次安全事件的记录证据，通常是一个请求和响应。

除了请求和响应外，有时也会需要其他选项卡的信息做参考。

## 生成[漏洞扫描报告](https://so.csdn.net/so/search?q=%E6%BC%8F%E6%B4%9E%E6%89%AB%E6%8F%8F%E6%8A%A5%E5%91%8A&spm=1001.2101.3001.7020)

### 选择扫描结果

打开 Target > Site map 标签页，找到要生成漏洞扫描报告的站点入口，例如  
[https://ginandjuice.shop](https://ginandjuice.shop/ "https://ginandjuice.shop")

点击右键，选择菜单项 Issues > Report issues。

![](https://i-blog.csdnimg.cn/blog_migrate/39a618efe53dea25daa777246555d177.png)

### 配置报告选项

打开扫描报告的导出向导，然后自定义报告的格式和内容。

不过目前我们只需要默认点击下一步

直到弹出下图对话框，选好扫描报告的保存位置确认即可

![](https://i-blog.csdnimg.cn/blog_migrate/3a6e4a9c65a1f7f7cb3c47a1c3a2d2d8.png)

### 生成并保存报告

点击 Select file 选择保存报告的位置，输入保存文件名

**一定要确保后缀是 .html，不然就无法正常打开了。**

### 查看或分享报告

导出扫描报告后可以直接在 Burp 浏览器查看。

![](https://i-blog.csdnimg.cn/blog_migrate/b0e11e66e98c18ce724390038aef82d4.png)