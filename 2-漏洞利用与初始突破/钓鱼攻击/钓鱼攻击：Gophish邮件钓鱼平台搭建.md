 Gophish 是一个专为企业和渗透测试者设计的开源钓鱼工具套件。

https://cloud.tencent.com/developer/article/1796781

### 前言

目前越来越多的红蓝对抗中，钓鱼邮件攻击使用的越来越频繁，也是比较高效打点的一种方式，常见的钓鱼邮件攻击一种是直接通过二维码，内嵌链接、直接索要敏感信息等方式钓[运维](https://cloud.tencent.com/solution/operation?from_column=20065&from=20065)人员、内部人员相关的管理账号密码，另一种通过携带exe、execl、word等附件（附件中要么包含恶意代码、宏代码、要么是远控exe）的方式，诱导运维人员、内部员工点击相关的附件，以达到控制运维人员或者内部员工电脑的权限。但是一般项目中实施周期较短，并且需要进行数据统计等，因此本次主要介绍如何通过Gophish快速搭建邮件钓鱼平台。

### Gophish 平台搭建

Gophish官网地址：https://getgophish.com/

Gophish项目地址：

- https://github.com/gophish/gophish
- https://github.com/gophish/gophish/releases/

（1）首先，我们将适合自己系统的Gophish包下载到我们的vps上：

代码语言：javascript

复制

1. `mkdir gophish`
2. `cd gophish`
3. `wget https://github.com/gophish/gophish/releases/download/v0.11.0/gophish-v0.11.0-linux-64bit.zip`
4. `unzip gophish-v0.11.0-linux-64bit.zip`

![](https://ask.qcloudimg.com/http-save/yehe-5957324/n27r2c5aj2.png?imageView2/2/w/660)

（2）然后修改配置文件config.json：

- admin_server 是后台管理页面，我们要将 127.0.0.1 改为 0.0.0.0，默认开放的端口为3333。
- phishserver是钓鱼网站，默认开放80端口。listenurl 也要是 0.0.0.0，如果 80 端口被占用了可以改为其他端口比如 81。
- contact_address 不是一定要加上的，可以加一个。

![](https://ask.qcloudimg.com/http-save/yehe-5957324/jf1h1zjjes.png?imageView2/2/w/660)

（3）现在，我们就可以启动gophish了：

代码语言：javascript

复制

1. `chmod 777 gophish`
2. `nohup ./gophish &`

成功启动后，在命令行输出的初始账户密码可以用来登录控制台：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/iogqc1fcvk.png?imageView2/2/w/660)

（4）然后，访问 https://your-ip:3333/ 即可登录管理后台（注意使用https协议）：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/d8lnh67ioi.png?imageView2/2/w/660)

首次登录会强制你修改密码，要求八位以上字符，登陆进入页面如下：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/wltixe8zw8.png?imageView2/2/w/660)

至此，Gophish平台搭建完成。

### Gophish 平台相关配置及功能

该Gophish平台具有如下几个功能，均需要进行配置。

|功能|简述|
|---|---|
|Dashboard|仪表板，查看整体测试情况|
|Campaigns|每次攻击前需要配置一次|
|Users & Groups|用户和用户组（添加需要进行钓鱼的邮箱和相关基础信息）|
|Email Templates|电子邮件模板|
|Landing Pages|需要伪造的钓鱼页面|
|Sending Profiles|钓鱼邮箱发送配置|

#### Sending Profiles（钓鱼邮箱发送配置）

Sending Profiles的主要作用是将用来发送钓鱼邮件的邮箱配置到Gophish。点击 “New Profile” 新建一个策略，依次来填写各个字段：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/51vq9vwm27.png?imageView2/2/w/660)

- **Name：**Name字段是为新建的发件策略进行命名，不会影响到钓鱼的实施，建议以发件邮箱为名字，例如使用qq邮箱来发送钓鱼邮件，则Name字段可以写 `xxxxxx@qq.com` 。
- **Interface Type：**Interface Type 是接口类型，默认为 SMTP类型 且不可修改，因此需要发件邮箱开启SMTP服务
- **From：**From 是发件人，即钓鱼邮件所显示的发件人。（在实际使用中，一般需要进行近似域名伪造）这里为了容易理解，就暂时以qq邮箱为例，所以From字段可以写： `test<xxxxxx@qq.com>`。
- **Host：**Host 是SMTP[服务器](https://cloud.tencent.com/act/pro/promotion-cvm?from_column=20065&from=20065)的地址，格式是 `smtp.example.com:25`，例如qq邮箱的smtp服务器地址为 `smtp.qq.com`。但这里要注意，如果搭建Gophish平台用的vps是阿里云的话，是不能使用25端口的，因为阿里云禁用25端口，你可以通过提工单解封，但申请通过的难度很大。所以，我们这里可以把25端口改为465端口，即填写 `smtp.qq.com:465`，这样就可以成功发送邮件了。
- **Username：**Username 是SMTP服务认证的用户名，如果是qq邮箱，Username则是自己的qq邮箱号 `xxxx@qq.com`。
- **Password：**Password 是SMTP服务认证的密码，例如qq邮箱，需要在登录qq邮箱后，依次点击 “设置”—>“账户”—>“开启SMPT服务”—>“生成授权码”来获取SMTP服务授权码，Password的值则填写我们收到的授权码。

![](https://ask.qcloudimg.com/http-save/yehe-5957324/9q592700kn.png?imageView2/2/w/660)

- **Email Headers（选填）：**Email Headers 是自定义邮件头字段，例如邮件头的 `X-Mailer` 字段，若不修改此字段的值，通过gophish发出的邮件，其邮件头的X-Mailer的值默认为gophish。

设置好以上字段，可以点击 “Send Test Email” 来给自己发送一个测试邮件，以检测SMTP服务器是否认证通过。如下，成功收到测试邮件，说明SMTP服务器是否认证通过：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/dcvaxlz4fh.png?imageView2/2/w/660)

![](https://ask.qcloudimg.com/http-save/yehe-5957324/pbkmn02qh2.png?imageView2/2/w/660)

至此，发件邮箱的配置已经完成。当然，在实际钓鱼中，不可能使用自己的qq邮箱去发送钓鱼邮件。一是因为很容易暴露自身身份，而且邮件真实性低，二是qq邮箱这类第三方邮箱对每个用户每日发件数存在限制，对钓鱼有检测、会被封的，所以我们还是得自己搭建邮件服务器，这个我们后文会讲到。

**因此，如果需要大批量去发送钓鱼邮件，最好的方式是使用自己搭建的邮件服务器，申请近似域名，搭建邮件服务器来发件。**

#### Email Templates（钓鱼邮件模板）

完成了邮箱配置之后，就可以使用gophish发送邮件了。所以，接下来需要去“Email Templates”中编写钓鱼邮件的内容。点击“New Template”新建钓鱼邮件模板，依次介绍填写各个字段：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/vyxz2kvmdi.png?imageView2/2/w/660)

- **Name：**这个字段是对当前新建的钓鱼邮件模板进行命名，可以简单的命名为 “邮件模板一”。
- **Import Email：**Gophish为编辑邮件内容提供了两种方式，第一种就是 “Import Email”。用户可以先在自己的邮箱系统中设计好钓鱼邮件，然后发送给自己或其他伙伴，收到设计好的邮件后，打开并选择“导出为eml文件”或者“显示邮件原文”，然后将内容复制到gophish的“Import Email”中，即可将设计好的钓鱼邮件的导入。 需要注意的是，在点击“Import”之前需要勾选上“Change Links to Point to Landing Page”，该功能实现了当创建钓鱼事件后，会将邮件中的超链接自动转变为钓鱼网站的URL。
- **Subject：**Subject 是邮件的主题，通常为了提高邮件的真实性，需要自己去编造一个吸引人的主题。这里简单填写成 “第一次钓鱼测试”。
- **内容编辑框：**内容编辑框是编写邮件内容的第二种模式，内容编辑框提供了 `Text`和 `HTML`两种模式来编写邮件内容，使用方式与正常的编辑器无异。其中HTML模式下的“预览”功能比较常用到，在编辑好内容后，点击预览，就可以清晰看到邮件呈现的具体内容以及格式。
- **Add Tracking Image：**Add Tracking Image 是在钓鱼邮件末添加一个“跟踪图像”，用来跟踪受害用户是否打开了收到的钓鱼邮件。默认情况下是勾选的，如果不勾选就无法跟踪到受害用户是否打开了钓鱼邮件。
- **Add Files：**Add Files 是在发送的邮件中“添加附件”，一是可以添加相关文件提高邮件真实性，二是可以配合免杀木马诱导受害用户下载并打开。这里我添加了一个带有office宏病毒的word文档。

当填写完以上字段后，点击“Save Template”，就能保存当前编辑好的钓鱼邮件模板。如下图，我们创建了一个带有office宏病毒的word附件的邮件模板：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/rhkwo2cj0s.png?imageView2/2/w/660)

#### Landing Pages（伪造钓鱼页面）

完成钓鱼邮件的编写后，下一步则需要在Landing Pages中设计由邮件中超链接指向的钓鱼网页，点击 “New Page” 新建页面：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/mz328q0icu.png?imageView2/2/w/660)

- **Name：**Name 是用于为当前新建的钓鱼页面命名，可以简单命名为 “钓鱼页面一”。
- **Import Site：**与钓鱼邮件模板的编辑一样，gophish为钓鱼页面的设计也提供了两种方式，第一种就是 “Import Site”，即克隆目标网站。点击“Import Site”后，填写 被伪造网站的URL，再点击Import，即可通过互联网自动爬取被伪造网站的前端代码。这里以伪造XX集团公司的管理后台登录界面为例，在 “Import Site” 中填写目标网址 `https://www.xxxxxxx.com/backend/account/login.html`：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/cxwg1cy3dd.png?imageView2/2/w/660)

然后点击 Import即可，如下图所示，成功伪造目标网站：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/76892ow5mg.png?imageView2/2/w/660)

- **内容编辑框：**内容编辑框是编辑钓鱼页面的第二种方法，但是绝大多数情况下，它更偏向于用来辅助第一种方法，即对导入的页面进行源码修改以及预览。由于编码的不同，通常直接通过“Import Site”导入的网站，其中文部分多少存在乱码现象，这时候就需要查看源码并手动修改过来。
- **Capture Submitted Data（重点）：**通常，进行钓鱼的目的往往是捕获受害用户的用户名及密码，因此，在点击Save Page之前，记得一定要勾选左下方的 “Capture Submitted Data” 当勾选了“Capture Submitted Data”后，页面会多出一个“Capture Passwords”的选项，显然是捕获密码，通常可以选择勾选上以验证账号的可用性。如果仅仅是测试并统计受害用户是否提交数据而不泄露账号隐私，则可以不勾选。另外，当勾选了 “Capture Submitted Data” 后，页面还会多出一个 “Redirect to”，其作用就是当受害用户点击提交表单后，将页面重定向到指定的URL。可以填写被伪造网站的URL，营造出一种受害用户第一次填写账号密码填错的感觉。（一般来说，当一个登录页面提交的表单数据与[数据库](https://cloud.tencent.com/solution/database?from_column=20065&from=20065)中不一致时，登录页面的URL会被添加上一个出错参数，以提示用户账号或密码出错，所以在 `Redirectto`中，最好根据目标网站情况填写带出错参数的URL，以显得更真实）因此，令此处的Redirect to的值可以为 `https://www.xxxxxxx.com/backend/account/login.html?class=form-validation&name=loginform`：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/4i5mcqjga8.png?imageView2/2/w/660)

填写好以上参数，点击 “Save Page”，即可保存编辑好的钓鱼页面。

#### Users & Groups（用户和组）

当完成上面三个功能的内容编辑，钓鱼准备工作就已经完成了80%， `Users&Groups` 的作用是将钓鱼的目标邮箱导入Gophish中准备发送。点击“New Group”新建一个钓鱼的目标用户组：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/g49ko6uqp6.png?imageView2/2/w/660)

- **Name：**Name 是为当前新建的用户组命名，这里可以简单命名为 “目标1组”。
- **Bulk Import Users：**Bulk Import Users是批量导入用户邮箱，它通过上传符合特定模板的CSV文件来批量导入目标用户邮箱 点击旁边灰色字体的“Download CSV Template”可以下载特定的CSV模板文件。其中，模板文件的“Email”是必填项，其余的“Frist Name” 、“Last Name”、“Position”皆可选填。
- **Add：**除了批量导入目标用户的邮箱，Gophish也提供了单个邮箱的导入方法，这对于开始钓鱼前，钓鱼组内部测试十分方便，不需要繁琐的文件上传，直接填写“Email”即可，其余的“Frist Name” 、“Last Name”、“Position”皆可选填。

编辑好目标用户的邮箱后，点击“Save Changes”即可保存编辑好的一组目标邮箱保存在Gophish中。

#### Campaigns（钓鱼事件）

Campaigns 的作用是将上述四个功能Sending Profiles 、Email Templates 、Landing Pages 、Users & Groups联系起来，并创建钓鱼事件。在Campaigns中，可以新建钓鱼事件，并选择编辑好的钓鱼邮件模板，钓鱼页面，通过配置好的发件邮箱，将钓鱼邮件发送给目标用户组内的所有用户。点击“New Campaign”新建一个钓鱼事件：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/4iun8o34vg.png?imageView2/2/w/660)

- **Name：**Name 是为新建的钓鱼事件进行命名，可以简单命名为”第一次钓鱼“。
- **Email Template：**Email Template 即钓鱼邮件模板，这里选择刚刚上面编辑好的钓鱼邮件模板”邮件模板一“。
- **Landing Page：**Landing Page 即钓鱼页面，这里选择刚刚上面编辑好的“钓鱼页面一”。
- **URL（重点）：**URL 是用来替换选定钓鱼邮件模板中超链接的值，该值指向部署了选定钓鱼页面的url地址。简单来说，这里的URL需要填写当前运行Gophish脚本主机的IP。因为启动Gophish后，Gophish默认监听了3333端口和80端口（我们这配置的是81端口），其中3333端口是后台管理系统，而81端口就是用来部署钓鱼页面的。当URL填写了http://主机IP/，并成功创建了当前的钓鱼事件后，Gophish会在主机的81端口部署当前钓鱼事件所选定的钓鱼页面，并在发送的钓鱼邮件里，将其中所有的超链接都替换成部署在81端口的钓鱼页面的url。所以，这里的URL填写我本地当前运行Gophish的vps主机IP和端口，即我这里是 http://47.xxx.xxx.72:81/。
- **Launch Date：**Launch Date 即钓鱼事件的实施日期，通常如果仅发送少量的邮箱，该项不需要修改。如果需要发送大量的邮箱，则配合旁边的“Send Emails By”效果更佳。
- **Send Emails By（可选）：**Send Emails By 配合Launch Date使用，可以理解为当前钓鱼事件下所有钓鱼邮件发送完成的时间。Launch Date作为起始发件时间，Send Emails By 作为完成发件时间，而它们之间的时间将被所有邮件以分钟为单位平分。例如，Launch Date的值为 `2020.07.22,09:00`，Send Emails By的值为 `2020.07.22,09:04`，该钓鱼事件需要发送50封钓鱼邮件。那么经过以上设定，从9:00到9:04共有5个发件点，这5个发件点被50封邮件平分，即每个发件点将发送10封，也就是每分钟仅发送10封。这样的好处在于，当需要发送大量的钓鱼邮件，而发件邮箱服务器并未限制每分钟的发件数，那么通过该设定可以限制钓鱼邮件不受约束的发出，从而防止因短时间大量邮件抵达目标邮箱而导致的垃圾邮件检测，甚至发件邮箱服务器IP被目标邮箱服务器封禁。
- **Sending Profile：**Sending Profile 即上文中我们配置的发件邮箱策略，这里选择刚刚编辑好的名为 `xxxxxx@qq.com` 的发件策略。
- **Groups：**Groups 即接收钓鱼邮件的目标用户组，这里选择刚刚编辑好的名为“目标1组”的目标用户组。

填写完以上字段，点击“Launch Campaign”后将会创建本次钓鱼事件（注意：如果未修改“Launch Date”，则默认在创建钓鱼事件后就立即开始发送钓鱼邮件）：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/djx1wb8k62.png?imageView2/2/w/660)

#### Dashboard（仪表板）

当创建了钓鱼事件后，Dashboard 会自动开始统计数据。统计的数据项包括邮件发送成功的数量及比率，邮件被打开的数量及比率，钓鱼链接被点击的数量及比率，账密数据被提交的数量和比率，以及收到电子邮件报告的数量和比率。另外，还有时间轴记录了每个行为发生的时间点：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/tm551dqsjy.png?imageView2/2/w/660)

需要注意的是，Dashboard 统计的是所有钓鱼事件的数据，而非单个钓鱼事件的数据，如果仅需要查看单个钓鱼事件的统计数据，可以在Campaigns中找到该钓鱼事件，点击View Results按钮查看：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/p37ocu8czh.png?imageView2/2/w/660)

![](https://ask.qcloudimg.com/http-save/yehe-5957324/ay1ijr45np.png?imageView2/2/w/660)

至此，一次在gophish发起的钓鱼事件所需实施步骤就已经全部完成，接下来就等着鱼儿上钩了。

![](https://ask.qcloudimg.com/http-save/yehe-5957324/qoy8xlxx3y.jpeg?imageView2/2/w/660)

#### 查看捕获的数据

此时，受害者已经收到了我们发送的钓鱼邮件：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/o8yrz38dhy.png?imageView2/2/w/660)

受害人点击超链接即可跳转到部署好的钓鱼页面，如下图发现与真实的XX大学邮箱登录界面无差别：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/tr4e02vmui.png?imageView2/2/w/660)

但是在网站的URL处可以看到钓鱼邮件中的超链接指向的就是之前在新建 `Campaigns` 的表单中填写的 `URL`，只不过后面多了一个 `rid` 参数。这里的 `?rid=eVtEBmB`具有唯一性，即唯一指向打开的这封钓鱼邮件，换句话说 `eVtEBmB` 是为这封邮件的收件人唯一分配的，以此来区别不同的收件人。

当受害人输入用户名和密码并提交后，部署的钓鱼页面重定向到了真实的网站登录页面，且添加上了出错参数 `?class=form-validation&name=loginform`，使账号或密码错误的提示显示出来，达到迷惑受害用户的作用：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/wkgvc2hhhe.png?imageView2/2/w/660)

在仪表板的Details中可以查看Gophish捕获的数据：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/g9qwwraqhq.png?imageView2/2/w/660)

![](https://ask.qcloudimg.com/http-save/yehe-5957324/ri9trf3cx4.png?imageView2/2/w/660)

如上图，可以展开查看到每个人在钓鱼页面提交的账密信息。

当受害人下载钓鱼邮件中的附件并打开时，受害人的主机成功上线cobalt strike：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/uzno3yz0aw.png?imageView2/2/w/660)

### 申请近似域名

在实际使用中，钓鱼邮件的发送一般需要进行近似域名伪造，以增强钓鱼右键的真实性。比如说我想对一个叫 whoami 的公司钓鱼，他们公司的邮件格式是：xxx@whoami.com。那么为了发钓鱼邮件，我们就得门去购买了一个近似域名 whoaml.com，这样的话后面我们就可以以 admin@whoaml.com 为发件人去发送一些钓鱼邮件。

这里可以去 GoDaddy 去申请购买近似域名：

- https://sg.godaddy.com/
- https://sg.godaddy.com/zh/

![](https://ask.qcloudimg.com/http-save/yehe-5957324/suq579p2gr.png?imageView2/2/w/660)

然后在此近似域名的DNS管理页面里增加两条记录即可：

![](https://ask.qcloudimg.com/http-save/yehe-5957324/ilifkwqkl7.jpeg?imageView2/2/w/660)

### 邮件服务器的搭建

在实际钓鱼中，我们不可能使用自己的qq邮箱去发送钓鱼邮件。一是因为很容易暴露自身身份，而且邮件真实性低，二是qq邮箱这类第三方邮箱对每个用户每日发件数存在限制，对钓鱼有检测、会被封的，所以我们还是得自己搭建邮件服务器，常见的邮件服务器软件有：

- sendmail：性能好，设置复杂，适合老手
- qmail：体积小260+k ，模块化。需要做二次开发，适合对邮件性能有要求的
- postfix：前身是sendmail，postfix原本是sendmail里面的一个模块
- zmailer：近几年才出来的邮件
- coremail：国内做的最好的商业平台，运行在linux上

下面，我们使用 postfix+mailutils 在搭建 Gophish 的同一台 VPS 上开始搭建邮件服务器：

#### （1）安装Postfix
```
apt-get install postfix
```

![](https://ask.qcloudimg.com/http-save/yehe-5957324/qww6bufx32.png?imageView2/2/w/660)

#### （2）修改设置配置文件
```
vim /etc/postfix/main.cf
```

主要由以下几个配置：
```
# 设置myhostname
 
myhostname = mail.whoaml.com
 
# 设置域名
 
mydomain = whoaml.com
 
# 设置myorigin
 
myorigin = $mydomain
 
# 默认是localhost，修改成all
 
inet_interfaces = all
 
# 推荐ipv4，如果支持ipv6，则可以为all
 
inet_protocols = ipv4
 
# 设置mydestination
 
mydestination =  
m
y
h
o
s
t
n
a
m
e
,
l
o
c
a
l
h
o
s
t
.
 mydomain, localhost, 
# 指定内网和本地的IP地址范围
 
mynetworks = 192.168.0.0/16，127.0.0.0/8
 
# 邮件保存目录
 
home_mailbox = Maildir/ 
 
# 设置banner
 
smtpd_banner = $myhostname ESMTP

```

#### （4）安装mailx软件包
```
apt-get install mailutils
```
#### （5）启动postfix服务
```
systemctl start postfix
```
#### （6）发送测试邮件
```
echo "email content" | mail -s "title" 6572*****@qq.com
```

邮件服务器搭建完成后，我们便可以用自己的邮件服务器来发送钓鱼邮件了，即在Sending Profiles的钓鱼邮箱发送配置的host里面将smtp服务器的地址为指定为 127.0.0.1:25 即可。

> 参考： https://blog.csdn.net/qq_42939527/article/details/107485116 http://blog.leanote.com/post/snowming/a6b66097bccd https://www.jianshu.com/p/8f5c5ef25db9

原创投稿作者：Mr.Anonymous

博客:whoamianony.top
