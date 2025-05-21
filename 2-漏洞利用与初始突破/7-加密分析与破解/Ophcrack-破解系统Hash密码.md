[使用Ophcrack破解系统Hash密码 - 知乎](https://zhuanlan.zhihu.com/p/656930825)

# 1、通过已有信息再次进行搜索和整理

通过查看他人的blog以及发表的文章我们对其进行分析和整理，最终获取了以下一些信息和资料：

1、工具下载：[http://sourceforge.net/project/showfiles.php?group_id=133599](https://link.zhihu.com/?target=http%3A//sourceforge.net/project/showfiles.php%3Fgroup_id%3D133599)
2、Ophcrack主页：[http://ophcrack.sourceforge.net/](https://link.zhihu.com/?target=http%3A//ophcrack.sourceforge.net/)
3、英文维克关于彩虹表的定义和解释：[http://en.wikipedia.org/wiki/Rainbow_table](https://link.zhihu.com/?target=http%3A//en.wikipedia.org/wiki/Rainbow_table)
4、国内对彩虹表的研究：[http://www.antsight.com/zsl/rainbowcrack/](https://link.zhihu.com/?target=http%3A//www.antsight.com/zsl/rainbowcrack/)
5、目前有关研究Ophcrack与彩虹表的相关资料。

通过以上三个步骤，我再次进行资料的分类，工具软件的下载，再此过程中分别下载了Ophcrack软件以及源代码，以及Ophcrack提供的彩虹表[http://ophcrack.sourceforge.net/tables.php]，通过查看我们知道Ophcrack提供了三个免费的彩虹表：

### 1、XP free small (380MB)

标识：SSTIC04-10k
破解成功率： 99.9%
字母数字表：
123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ

一句话该表有大小写字母加数字生成，大小为388MB，包含所有字母数字混合密码中99.9%的LanManager表。这些都是用大小写字母和数字组成的密码（大约800亿组合）。

由于LanManager哈希表将密码截成每份7个字符的两份，我们就可以用该表破解长度在1到14之间的密码。由于LanManager哈希表也是不区分大小写的，该表中的800亿的组合就相当于12*10的11次方（或者2的83次方）个密码，因此也被称为“字母数字表10K”。

### 2、XP free fast (703MB)

标识：SSTIC04-5k
成功率： 99.9%
字母数字表：
0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ

字母数字表5k大小为703MB 包含所有字母数字组合的密码中99.9%的LanManager表。但是，由于表变成2倍大，如果你的计算机有1GB以上的RAM空间的话，它的破解速度是前一个的4倍。

### 3、XP special (7.5GB)

标识：WS-20k
成功率：96%
XP special扩展表 7.5GB，包含最长14个大小写字母、数字以及下列33个特殊字符
```
（!"#$%&'()*+,-./:;<=>?@[\]^_`{|} ~）组成的密码中96%的LanManager表。该表中大约有7兆的组合，5*10的12次方（或者2的92次方）密码，该表需要花钱购买。
```
### 4、破解Vista的彩虹表

Vista free (461MB) 是免费用来破解Vista的hash密码，而Vista special (8.0GB)需要购买。

小知识：

LM又叫LanManager，它是Windows古老而脆弱的密码加密方式。任何大于7位的密码都被分成以7为单位的几个部分，最后不足7位的密码以0补足7位，然后通过加密运算最终组合成一个hash。所以实际上通过破解软件分解后，LM密码破解的上限就是7位，这使得以今天的PC运算速度在短时间内暴力破解LM加密的密码成为可能（上限是两周），如果使用Rainbow tables，那么这个时间数量级可能被下降到小时。

# 2、安装Ophcrack软件

Ophcrack软件的安装过程非常简单，按照提示安装即可，在安装过程需要特别注意，不要选择下载彩虹表，安装设置中会提供三个下载选项，分别下载WinXP （380MB）、Winxp （703MB）和Vista （461MB）彩虹表，如图2所示，笔者在安装过程中选择它后下载了数个小时，这个表可以在程序安装完成后再下载。否则安装Ophcrack软件要等彩虹表下载完成后才能使用。

![](https://pic1.zhimg.com/80/v2-e68f76405cd12351deaafdc7800dcf8c_720w.webp)

图2 安装时建议不下载彩虹表

# 3.使用Ophcrack软件

从程序菜单中直接运行Ophcrack软件，如图3所示，该软件主要有“Load”、“Delete”、“Save”、“Table”、“Crack”、“Help”以及“Exit”七大主要模块，“Load”主要负责装载Hash或者sam文件。“Delete”主要用来删除破解条目，“Save”主要保存破解结果或者破解session，“Table”主要用来设置彩虹表，“Crack”是开始执行破解，“Help”是查看帮助文件，呵呵，“Exit”俺就不说了。

![](https://pic2.zhimg.com/80/v2-dd3df29e4a2fa39aee5b64533957d37d_720w.webp)

图3 Ophcrack软件主界面

# 4.下载彩虹表

可以到Ophcrack提供的彩虹表下载地址（[http://ophcrack.sourceforge.net/tables.php](https://link.zhihu.com/?target=http%3A//ophcrack.sourceforge.net/tables.php)）去下载，在本案例中分别下载了三个免费的彩虹表。

# 5.设置彩虹表

在Ophcrack软件主界面中单击“Table”，接着就会出来如图4所示的Table Selection界面，在缺省状态下，所有表都没有安装，通过该界面我们了解到一共有8个彩虹表，其中有三个是免费的。

![](https://pic1.zhimg.com/80/v2-ec7f8b068c22abb6856549510a81d250_720w.webp)

图4 选择彩虹表

然后单击并选中其中的一个条目，例如在本例中选择“Xp free fast”，然后单击“Install”按钮，系统会自动到Ophcrack软件的安装目录，不过本例是将三个压缩文件解压到F盘，如图5所示，选择“Tables”即可，然后一次安装所获取的其它二个彩虹表。

![](https://pic2.zhimg.com/80/v2-3d4d175320fd4d9f31c2fe8b80ae8f2d_720w.webp)

图5 选择要安装的彩虹表

注意：

（1）在Ophcrack软件中其彩虹表的上级目录名称必须为“tables”，否则彩虹表安装不会成功。

（2）彩虹表安装成功后，其条目会变成绿色，且可以查看一共有多少个表，如图6所示。

![](https://pic2.zhimg.com/80/v2-978f7ea408753ed1a16c12f86474793d_720w.webp)

图6 彩虹表安装成功

# 6.准备破解材料

这里的破解材料主要是指通过GetHashes、Pwdump等软件获取的系统Hash密码值。如果没有，就自己想办法获取一个吧。

# 7.开始破解

（1）加载sam文件

单击“Load”按钮，选择“PWDUMP file”，如图7所示，一共有6个选项，第一个主要用于对单个Hash的破解，第二个是对获取的Pwdump文件进行破解，第三个是对加密的sam文件进行破解，第四个和第五个主要用来审计或者破解本地和远程Hash密码。

![](https://pic2.zhimg.com/80/v2-9ca103b76d6b9a361350167720c80651_720w.webp)

图7 选择破解类型

（2）查看HASH密码值

在本例中选择一个已经Pwdump的文件，如果pwdump系统的hash密码没有错误，则会在Ophcrack软件主界面中正确显示，如图8所示，在主界面中分别显示“User”、“LM Hash”、“NT Hash”、“LM Pwd1 ”、“LM Pwd2”以及“NT pwd”等信息。

![](https://pic2.zhimg.com/80/v2-7663f5ec843ceb658f31cf3c40b8ca99_720w.webp)

图 8显示获取的Hash密码值

（3）清理无用Hash值

在本例中“IUSR_XFFZD-R1”、“TWWM_XFZD-SER1”和“TsInternetUser”这三个用户是系统自身的，在口令破解中基本没有用处，除非有人对该账号进行了克隆，因此可以分别选中需要删除的账号，然后单击主界面“Delete”按钮，删除这三个无用的账号以及我添加的“king$”账号，仅仅留下并破解管理员账号，清理完毕后如图9所示。

![](https://pic3.zhimg.com/80/v2-947e1f76dbe744322934dc0a99e76446_720w.webp)

图9 清理无用用户的Hash密码值

（4）执行破解

单击“Crack”案例开始破解，很快就破解出来了密码为“www119”，其“LM Pwd1”值跟“NT pwd”相同，破解密码的时间仅仅“37s”。

![](https://pic4.zhimg.com/80/v2-90c0f28d4e8bfb7cc4cce4fdecbb23bf_720w.webp)

图10 破解系统密码成功

（5）查看破解统计信息

在主界面中单击“statistics”，可以查看关于破解hash密码值的普通和详细信息，如图11所示。

![](https://pic2.zhimg.com/80/v2-fcaef11e794009d9ecb12c3613b27371_720w.webp)

图11查看所破解密码的有关统计信息

（6）破解参数设置

单击“Preferences”打开破解参数设置窗口，如图12所示，可以设置破解的线程，破解方式，是否隐藏用户名等。

![](https://pic2.zhimg.com/80/v2-6550ff73ee62ff9c45fa2972d3b90149_720w.webp)

图12 设置破解参数

# 8.彩虹表破解密码防范策略

通过彩虹表来破解密码使得入侵者可以很方便的获取系统的口令，从而“正常”登录系统，让管理员或者计算机的主人不太容易发现。通过研究，发现可以通过两种方式来加强系统口令的安全。

（1）通过设置超过一定位数的密码来加固口令安全

使用彩虹表破解14位以下的密码相对容易，对于普通入侵者来说仅仅有三个免费表，因此破解的强度相对要弱一些，因此可以通过增加密码设置的位数来加固系统口令安全。笔者建议设置超过32位的密码来加固系统的口令安全。关于口令的设置技巧有很多，在我们研究的专题中曾经提到过，在此为了照顾新朋友，可以再提一次密码设置的技巧：

通过一句话来设置密码，例如“2008-8月我国举办了奥运会，我去北京鸟巢观看了比赛，感觉很爽！”。可以这样设置“2008-8ywgjblayh,wqbjlcgklbs,gjhs!”，关于时间全取，标点符号全取，其他汉字取第一个字母，该密码长度为33位，如果再想长一点，还可以增加。其本质就是选择一句话或者诗词中的某一段来设置，容易记住，且安全强度高。

（2）使用NTLM方式加密

LM这种脆弱的加密方式在Windows2003还在使用，可以通过更改加密方式为NTLM，从而提高系统口令的安全，笔者在很多案例中也曾经发现通过pwdump以及GetHashes软件获取了hash值，但LC5以及Ophcrack软件均不能破解。

可以通过设定注册表参数禁用LM加密，代之以NTLM方式加密方法如下：

（1）打开注册表编辑器；

（2）定位到 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa；

（3）选择菜单“编辑”，“添加数值”；

（4）数值名称中输入：LMCompatibilityLevel，数值类型为：DWORD，单击“确定”；

（5）双击新建的数据，并根据具体情况设置以下值：

0 - 发送 LM 和 NTLM响应；

1 - 发送 LM 和 NTLM响应；

2 - 仅发送 NTLM响应；

3 - 仅发送 NTLMv2响应；(Windows 2000有效)

4 - 仅发送 NTLMv2响应，拒绝 LM；(Windows 2000有效)

5 - 仅发送 NTLMv2响应，拒绝 LM 和 NTLM；(Windows 2000有效)

（6）关闭注册表编辑器；

（7）重新启动机器

在Windows NT SP3引入了NTLM加密，在Windows 2000以后逐步引入的NTLM 2.0加密。但是LM加密方式默认还是开启的，除非通过上面的方法刻意关闭它。