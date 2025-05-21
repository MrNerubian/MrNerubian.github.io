## hashcat常用命令
```sh
hashcat -a 0 -m 0 f9ef2c539bad8a6d2f3432b6d49ab51a /usr/share/wordlists/rockyou.txt --show
```
## hashcat常用选项
```sh
--show  直接显示爆破结果
-m    指定哈希类型
-a    指定攻击模式，有5种模式
      0 Straight（字典破解）
      1 Combination（组合破解）
      3 Brute-force（掩码暴力破解）
      6 Hybrid dict + mask（混合字典+掩码）
      7 Hybrid mask + dict（混合掩码+字典）
-o    将输出结果储存到指定文件
-stdout  指定基础文件
-r    指定规则文件
-b    测试计算机破解速度和相关硬件信息
-O    限制密码长度
-T    设置线程数
-i    启用增量破解模式
--increment-min   设置密码最小长度
--increment-max   设置密码最大长度
--force     忽略警告，强制进行破解
--show      仅显示破解的hash密码和对应的明文
--remove    从源文件中删除破解成功的hash
--username  忽略hash表中的用户名
	-1 自定义字符集   -1 0123asd ?1={0123asd}
	-2 自定义字符集   -2 0123asd ?2={0123asd}
	-3 自定义字符集   -3 0123asd ?3={0123asd}
-V    查看版本信息
-h    查看帮助
```
## 用 -a 指定破解模式
```css
0 straight                    字典破解
1 combination                 将字典中密码进行组合（1 2>11 22 12 21）
3 brute-force                 使用指定掩码破解
6 Hybrid Wordlist + Mask      字典+掩码破解
7 Hybrid Mask + Wordlist      掩码+字典破解
```
## 用 -m 指定加密类型
```bash
 -m 900           MD4 
 -m 0             MD5
 -m 100           SHA1
 -m 1300          SHA2-224
 -m 1400          SHA2-256
 -m 10800         SHA2-384
 -m 1700          SHA2-512
 -m 10            MD5($pass.$salt)
 -m 20            MD5($salt.$pass)
 -m 3800          MD5($saIt.$pass.$salt)
 -m 3000          LM
 -m 1000          NTLM
```
#### hashcat集成的字符集
```ruby
?l 代表小写字母
?u 代表大写字母
?d 代表数字
?s 代表特殊字符
?a 代表大小写字母、数字以及特殊字符
?b 0x00-0xff
```
#### 字符集使用实例
```css
八位数字密码：?d?d?d?d?d?d?d?d
八位未知密码：?a?a?a?a?a?a?a?a
前四位为大写字母， 后四位为数字：?u?u?u?u?d?d?d?d
前三个字符未知，中间为admin, 后三位未知：?a?a?aadmin?a?a?a
6-8 位数字密码：--increment --increment-min 6 --increment-max 8
6-8 位数字+小写字母密码：--increment --increment-min 6 --increment-max 8 ?h?h?h?h?h?h?h?h
```
## 实例演示-暴力破解MD5值

### 1.使用字典进行破解
```css
hashcat -a 0 0192023a7bbd73250516f069df18b500 password.txt --show 

组合破解（ -a 1 ）

使用2个字典对一个经过SHA1算法运算过后的Hash值进行破解：

hashcat -a 1 -m 100 7Ce0359f12857f2a90C7de465f40a95f01Cb5da9 /usr/p1.txt /usr/p2.txt --show 
```

### 2.使用指定字符集进行破解

```css
hashcat -a 3 63a9f0ea7bb98050796b649e85481845 ?l?l?l?l --show 
```

### 3.使用字典+掩码进行破解

```css
hashcat -a 6 1844156d4166d94387f1a4ad031ca5fa /usr/share/wordlists/rockyou.txt ?d?d?d --show 
```

### 4.使用掩码+字典进行破解

```css
hashcat -a 7 f8def8bcecb2e7925a2b42d60d202deb ?d?d /usr/share/wordlists/rockyou.txt --show 
```

**如果破解时间太长，我们可以按s键查看破解进度，p键暂停，r键继续破解，q键退出破解**

https://www.cnblogs.com/Junglezt/p/16044372.html

