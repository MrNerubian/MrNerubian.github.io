### 工具：wfuzz

[wfuzz官方文档](http://wfuzz.readthedocs.io/)。

博客：

- https://cloud.tencent.com/developer/article/2187157
- https://blog.csdn.net/JBlock/article/details/88619117

使用方法：

```
-u： url地址
-w： 设置字典路径
-t： 线程数，默认40
-p： 请求延时： 0.1、0.2s
-ac：自动校准fuzz结果
-H： Header头，格式为 wfuzz -H "User-Agent: MyCustomUserAgent"
-X： HTTP method to use
-d： POST data
-r： 跟随重定向
-recursion "num"：递归扫描
-x： 设置代理 http 或 socks5://127.0.0.1:8080
-s： 不打印附加信息，简洁输出
-e： 设置拓展名；eg：-e .asp,.php,.html,.txt等
-o： 输出文本
-of：输出格式文件，支持html、json、md、csv、或者all
-mc: Match HTTP status codes；eg：-mc 200
--hc 过滤状态码
--sc 需要显示的状态码
-c   将响应状态码用颜色区分，windows下无法实现该效果。
-z   设置payload 【比如:字典】
-t   设置线程  默认10

-maxtime:  整个过程的最大运行时间（以秒为单位）(默认: 0)
-maxtime-job:  每个作业的最大运行时间（以秒为单位）(默认: 0)

notes:尽量使用-maxtime-job与-recursion递归扫描一起使用，用于指定每个目录递归扫描时间，避免扫描时间过长

```
#### 暴破文件和路径

使用wfuzz暴力猜测目录的命令如下：  
```
wfuzz -w /usr/share/wfuzz/wordlist/general/common.txt http://testphp.vulnweb.com/FUZZ
```
使用wfuzz暴力猜测文件的命令如下：  
```
wfuzz -w /usr/share/wfuzz/wordlist/general/common.txt http://testphp.vulnweb.com/FUZZ.php
```
#### 测试URL中的参数

通过在URL中在`？`后面设置FUZZ占位符，我们就可以使用wfuzz来测试URL传入的参数：  


```
wfuzz -u 192.168.216.142/test.php?FUZZ=/etc/passwd  -w /usr/share/wfuzz/wordlist/others/common_pass.txt --hh 80
```
--hh 80: 仅在返回代码为80x（即请求成功）时显示输出结果。
#### 测试POST请求

如果想使用wfuzz测试form-encoded的数据，比如 HTML表单那样的，只需要传入-d参数即可：

```
wfuzz -z file,/usr/share/wfuzz/wordlist/others/common_pass.txt -d "uname=FUZZ&pass=FUZZ" --hc 302 http://testphp.vulnweb.com/userinfo.php
```

```
wfuzz -w /usr/share/dirb/wordlists/common.txt -u 192.168.56.113/FUZZ  --hc 404
wfuzz -w /usr/share/dirb/wordlists/common.txt -u 192.168.56.113/secret/FUZZ --hc 404
wfuzz -w /usr/share/dirb/wordlists/common.txt -u 192.168.56.113/secret/FUZZ.php --hc 404
wfuzz -w /usr/share/dirb/wordlists/common.txt -u 192.168.56.113/secret/evil.php?FUZZ=FUZ2Z --hc 404
wfuzz -u "192.168.9.62/secret/evil.php?FUZZ=../../../../etc/passwd" -w /usr/share/dirb/wordlists/common.txt --hw 0
```


### 2. 使用FFuF（Fuzz Faster U Fool）工具
- **安装FFuF（不同操作系统安装方式有差异，以常见Linux系统为例）**：
可以通过Go语言的包管理工具来安装，比如运行 
`go get -u github.com/ffuf/ffuf`（前提是已经安装好Go环境）。

- **命令格式及示例**：
基本命令格式是 
```sh
ffuf -w <wordlist> -u <URL_with_fuzz_parameter>
```
其中：
    - `-w`：指定包含测试用的各种字符串（如各类文件路径、文件名等）的字典文件。
    - `<wordlist>`：就是字典文件的实际路径，比如 `/home/user/include_fuzz_wordlist.txt`。
    - `-u`：用于指定目标URL，且URL中要带有一个可被替换的部分（通常用 `FUZZ` 表示）用于模糊测试，例如 `http://example.com/index.php?include=FUZZ`。

例如，目标URL是 `http://example.com/index.php?include=FUZZ`，字典文件为 `/home/user/include_fuzz_wordlist.txt`，命令则写为：
`ffuf -w /home/user/include_fuzz_wordlist.txt -u http://example.com/index.php?include=FUZZ`

FFuF会把字典文件中的每个单词依次替换URL中的 `FUZZ` 部分，发送请求到目标URL，之后查看返回的响应状态码、响应内容长度等情况来判断是否可能存在文件包含漏洞，判断方式和前面wfuzz类似，根据响应的状态码以及内容长度等特征来综合分析。