# 服务原理

RUDY的全名叫R-U-Dead-Yet，是一种基于HTTP协议的攻击方式。攻击者向服务器发送大量的POST请求，占用服务器资源，使得服务器无法正常处理请求。

它有2种模式，一种是互动菜单模式，另一种是配置模式。

我使用的是互动菜单模式。先看慢速拒绝服务原理，这是华为的企业安全论坛给出的解释[1]。

> HTTP慢速攻击是利用HTTP现有合法机制，在建立了与HTTP服务器的连接后，尽量长时间保持该连接，不释放，达到对HTTP服务器的攻击。

Slow POST:

> 攻击者发送Post报文向服务器请求提交数据，将总报文长度设置为一个很大的数值，但是在随后的数据发送中，每次只发送很小的报文，这样导致服务器端一直等待攻击者发送数据。

Slow headers:

> 攻击者通过GET或者POST向服务器建立连接，但是HTTP头字段不发送结束符，之后发送其他字段进行保活。服务器会一直等待头信息中结束符而导致连接始终被占用。


# 攻击演示

这是我的蜜罐，现在用来示范rudy慢速http拒绝服务，经过一些列的倒腾，终于实验成功了。

![](https://pic2.zhimg.com/v2-1ba133dcf1df04281a58b4e5757630cd_b.webp?consumer=ZHI_MENG)

这是还没有进行rudy慢速拒绝服务的时延，187ms。

![](https://pic1.zhimg.com/v2-ad646f347d64230b9c17b76eca738a50_b.webp?consumer=ZHI_MENG)

开启rudy，大约10分钟后，再看时延188ms，犹如蚍蜉撼大树。

![](https://pic3.zhimg.com/v2-5e6aad29c10b2a11f49004b4388b88f6_b.webp?consumer=ZHI_MENG)

实验验证rudy的步骤如下：

**第一步：直接对我的蜜罐服务器进行慢速http攻击**

![](https://pic1.zhimg.com/v2-5a5dc32fc58b5416f0196e1c6aafc8ac_b.webp?consumer=ZHI_MENG)

**第二步：选择给予http 慢速拒绝服务的post表单**

![](https://pic1.zhimg.com/v2-e0e246be411fa92cbc286c3119e19a78_b.webp?consumer=ZHI_MENG)

**第三步：连接数直接用默认的50、代理也是默认的没有**

![](https://pic3.zhimg.com/v2-f547184661f8c60883cc4c5c81901d92_b.webp?consumer=ZHI_MENG)

通过wireshark抓包，我们可以看到全程只发送了2个http请求，还都是get请求，貌似看不出来有什么问题。

![](https://pic4.zhimg.com/v2-446671a69f6635f03ebb3c4c229bb2eb_b.webp?consumer=ZHI_MENG)

再仔细看看出现了大量的TCP交互报文，却都是只有1个字节，这就是Slow headers模式的慢速拒绝服务啦。

![](https://pic4.zhimg.com/v2-f993912871783e6dcc5ac9f3427c114f_b.webp?consumer=ZHI_MENG)

最后，我终止了rudy慢速http攻击，出现了大量的500服务端错误。

![](https://pic2.zhimg.com/v2-e01e1b75aa49b9cd651488a1263acc11_b.webp?consumer=ZHI_MENG)

编辑于 2022-01-20 · 著作权归作者所有