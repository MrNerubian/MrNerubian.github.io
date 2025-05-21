BurpSuite Pro版本才能正常使用爆破功能，社区版本，速度极慢

- https://blog.csdn.net/xf555er/article/details/130452476

## 1、暴力破解

1、浏览器设置代理到本机的某个端口，常用的是8080

- 根据浏览器不同方法不一样
- FireFox
  - 设置-常规页的网络设置（在最下面）-再点设置
  - 勾选手动配置代理，地址写127.0.0.1 端口常用的是8080
    - SOCKS协议一般选v4，有一些也支持v5

2、BurpSuite中要设置接收

- proxy页-点proxy settings
- 在tools-proxy页面，第一个框，点击add添加一条，IP写127.0.0.1 端口和上面保持一致,这里用8080

3、在BurpSuite打开监听

- 到proxy-intercept页面，点击intercept is off，让按钮变成intercept is on

4、在浏览器打开需要爆破的页面

- 回到登陆页面，输入登陆一次，BurpSuite会通过代理拦截到你的登陆页面的操作，弹出信息

5、BurpSuite配置爆破设置

- 此时，点击上方action按钮或右键空白区域，选择send to intruder
- 切换到intruder页面，选择增加点标签页
- 进入positions标签，点击右侧auto，为自动识别变量
- 进入payloads标签，
  - 在payloads set 选择第几个变量
  - 在payload settings[simple list]设置密码字典，点击load是导入本机中的字典文件，点击add是手动添加字符串

6、点击右侧start attack，则会弹出爆破窗口，开始爆破

7、爆破结束后会在爆破窗口下半部分弹出两个标签页，在response页，pertty标签的代码中，找到登陆成功的密码


## 2、攻击模式(Attack type)详解
### 2.1 Sniper(狙击手模式)

狙击手模式：一个一个爆破， 会把【Payload Options】中的字典，一次传入两个参数进行爆破。

### 2.2 Battering ram（攻城锤模式）

一炮双响：会将字典中每一个字串设置到所有参数，发起攻击的次数也是字典的长度。

### 2.3 Cluster bomb （集束炸弹模式）

多个参数交叉匹配发起请求，比如下面为2个参数分别字典，那么要发起的数据就是这两个字典长度的乘积

### 2.4 Pitchfork（草叉模式）

每个参数字典中的第n行进行组合，发起请求，请求次数为最小的字典的长度


## 常见 User Agent


PC端的UserAgent
```
safari 5.1 – MAC

User-Agent:Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us)AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50

safari 5.1 – Windows

User-Agent:Mozilla/5.0 (Windows; U; Windows NT 6.1; en-us) AppleWebKit/534.50(KHTML, like Gecko) Version/5.1 Safari/534.50

Firefox 38esr

User-Agent:Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101Firefox/38.0

IE 11

User-Agent:Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C;.NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729;InfoPath.3; rv:11.0) like Gecko

IE 9.0

User-Agent:Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0;

IE 8.0

User-Agent:Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)

IE 7.0

User-Agent:Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)

IE 6.0

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)

Firefox 4.0.1 – MAC

User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1)Gecko/20100101 Firefox/4.0.1

Firefox 4.0.1 – Windows

User-Agent:Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1

Opera 11.11 – MAC

User-Agent:Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; en) Presto/2.8.131Version/11.11

Opera 11.11 – Windows

User-Agent:Opera/9.80 (Windows NT 6.1; U; en) Presto/2.8.131 Version/11.11

Chrome 17.0 – MAC

User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11(KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11

傲游（Maxthon）

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Maxthon 2.0)

腾讯TT

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; TencentTraveler4.0)

世界之窗（The World） 2.x

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)

世界之窗（The World） 3.x

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; The World)

搜狗浏览器 1.x

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; SE2.X MetaSr 1.0; SE 2.X MetaSr 1.0; .NET CLR 2.0.50727; SE 2.X MetaSr 1.0)

360浏览器

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; 360SE)

Avant

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Avant Browser)

Green Browser

User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)

```
移动端UserAgent
```

safari iOS 4.33 – iPhone

User-Agent:Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us)AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2Safari/6533.18.5

safari iOS 4.33 – iPod Touch

User-Agent:Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us)AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2Safari/6533.18.5

safari iOS 4.33 – iPad

User-Agent:Mozilla/5.0 (iPad; U; CPU OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9(KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5

Android N1

User-Agent: Mozilla/5.0 (Linux; U; Android 2.3.7; en-us; Nexus One Build/FRF91)AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1

Android QQ浏览器 For android

User-Agent: MQQBrowser/26 Mozilla/5.0 (Linux; U; Android 2.3.7; zh-cn; MB200Build/GRJ22; CyanogenMod-7) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0Mobile Safari/533.1

Android Opera Mobile

User-Agent: Opera/9.80 (Android 2.3.4; Linux; Opera Mobi/build-1107180945; U;en-GB) Presto/2.8.149 Version/11.10

Android Pad Moto Xoom

User-Agent: Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39)AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13

BlackBerry

User-Agent: Mozilla/5.0 (BlackBerry; U; BlackBerry 9800; en) AppleWebKit/534.1+(KHTML, like Gecko) Version/6.0.0.337 Mobile Safari/534.1+

WebOS HP Touchpad

User-Agent: Mozilla/5.0 (hp-tablet; Linux; hpwOS/3.0.0; U; en-US)AppleWebKit/534.6 (KHTML, like Gecko) wOSBrowser/233.70 Safari/534.6TouchPad/1.0

Nokia N97

User-Agent: Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaN97-1/20.0.019;Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebKit/525 (KHTML, like Gecko)BrowserNG/7.1.18124

Windows Phone Mango

User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5;Trident/5.0; IEMobile/9.0; HTC; Titan)

UC无

User-Agent: UCWEB7.0.2.37/28/999

UC标准

User-Agent: NOKIA5700/ UCWEB7.0.2.37/28/999

UCOpenwave

User-Agent: Openwave/ UCWEB7.0.2.37/28/999

UC Opera

User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; ) Opera/UCWEB7.0.2.37/28/999
```