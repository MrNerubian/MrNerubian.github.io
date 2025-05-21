john是专注于密码破解的开源软件，kali自带

PS：任何加密文件，你都可以用john尝试爆破

官方文档：[https://www.openwall.com/john/doc/MODES.shtml](https://www.openwall.com/john/doc/MODES.shtml)
参考文档：[https://www.cnblogs.com/Junglezt/p/16048189.html](https://www.cnblogs.com/Junglezt/p/16048189.html)

## 安装
```sh
apt install -y john
```
## 命令格式:
```
john   [-功能选项]   [密码文件名] 
```
## 功能选项：

| 选项                  | 说明                                                                                                                                                                                                                                  |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| -single             | 使用单一模式进行解密。                                                                                                                                                                                                                         |
| -wordfile:<字典文件名>   | 指定解密字典文件                                                                                                                                                                                                                            |
| -rules              | 打开字典模式的词汇表切分规则。                                                                                                                                                                                                                     |
| -incremental:<模式名称> | 使用遍历模式，就是组合密码的所有可能情况。                                                                                                                                                                                                               |
| -external:<模式名称>    | 使用自定义的扩展解密模式,定义的自订破解功能。                                                                                                                                                                                                             |
| -stdout :<模式名称>     | 不进行破解，仅仅把生成的、要测试是否为口令的词汇输出到标准输出上。                                                                                                                                                                                                   |
| -restore:<文件名>      | 恢复JOHN被中断破解过程，当前解密进度情况被存放在RESTORE文件中。                                                                                                                                                                                               |
| -makechars:<文件名>    |  制作一个字符表,你所指定的文件如果存在，则将会被覆盖。                                                                                                                                                                                                        |
| -show               | 显示已经破解出的密码。                                                                                                                                                                                                                         |
| -test               | 测试当前机器运行john的解密速度。                                                                                                                                                                                                                  |
| -users:[，..]        |  只破解某类型的用户或者属于某个组的用户。                                                                                                                                                                                                               |
| -shells:[!][，..]    |  该选项可以选择对所有可以使用shell的用户进行解密，对其他他用户不予理睬。“！”就是表示不要某些类型的用户。                                                                                                                                                                            |
| -groups=[-]GID[,..] | 对指定用户组的账户进行破解，减号表示反向操作，说明对列出组之外的账户进行破解。                                                                                                                                                                                             |
| -list               |  在解密过程中在屏幕上列出所有正在尝试使用的密码。                                                                                                                                                                                                           |
| --format=NAME       | 指定哈希算法类型，如MD5、SHA-1、SHA-256等，没有指定时，会自动识别密文的hash类型进行自动选择，但是很多时候会识别错误，可以用工具hash-identifier或hashid识别密文的hash类型，kali中自带，也可以使用在线网站来识别【https://hashes.com/en/tools/hash_identifier】。<br>支持的格式包括：使用 --list=formats 和 --list=subformats 选项查看 |
| -save-memory=LEVEL  | 设置内存节省模式，当内存不多时选用这个选项。LEVEL取值在1~3之间。                                                                                                                                                                                                |
| --wordlist=<file>   | 指定密码字典文件路径，没有指定时，使用默认字典/usr/share/john/password.lst进行破解                                                                                                                                                                             |
| --fork=<n\>:        | 指定使用多少个进程进行并行破解。                                                                                                                                                                                                                    |
| --status            | 显示当前破解进度。                                                                                                                                                                                                                           |
| --pot=<file>        | 指定已破解密码的保存文件路径。                                                                                                                                                                                                                     |

## 爆破hash密文密码
```sh
用 john --list=formats 命令查询加密类型是否支持破解
john --format=[format] --wordlist=password.list hash.txt
```
## 解密ssh私钥id_rsa的passphrase密码

```
/usr/share/john/ssh2john.py id_rsa > hash.txt
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```
## 使用 john 直接破解 shadow 文件中的密文密码
```bash
cat welcome.shadow 
$1$WP/Vj663$ZRtzxrX16pybyzam5Xmdi0

john welcome.shadow --wordlist=/usr/share/wordlists/password.txt
```
## 破解7z加密压缩包
```bash
/usr/share/john/7z2john xxx.7z > hash.txt
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```
## 破解rar加密压缩包
```bash
rar2john rarfile.rar > rar_hash.txt
john --wordlist=/usr/share/wordlists/rockyou.txt rar_hash.txt
```
## 破解ZIP加密压缩包
```bash
/usr/share/john/zip2john passwd.zip > passwd.hash
john --wordlist=/usr/share/wordlists/rockyou.txt passwd.hash
```
### fcrackzip破解ZIP加密压缩包
```
apt-get update
apt-get install fcrackzip
fcrackzip -u -D -p /usr/share/wordlists/rockyou.txt myplace.zip
```
## 破解TrueCrypt加密压缩包

文件是否为TrueCrypt加密的判断方法：https://blog.csdn.net/superrenlu/article/details/103517313

```
/usr/share/john/tezos2john passwd.zip > passwd.hash
john --wordlist=/usr/share/wordlists/rockyou.txt passwd.hash
```
打开压缩包：见隐写-视频隐写



## 破解windows hash

`windows hash`的加密为`NTLM`，需要用`--format`指定
在`john`中，分别有`NT`和`LM`两种加密

## John Gpu加速
[John The Ripper Gpu加速相关命令\_john gpu-CSDN博客](https://blog.csdn.net/weixin_45013653/article/details/128116364)
