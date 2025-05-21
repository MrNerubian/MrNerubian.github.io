## kali环境准备

### kali官方链接

https://www.kali.org/docs/
https://www.kali.org/docs/tools/kali-tools/
https://www.kali.org/tools/

### kali 更换镜像源

```
sudo vim /etc/apt/sources.list

#中科大
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
#阿里云
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
#清华大学
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
#东软大学
deb http://mirrors.neusoft.edu.cn/kali kali-rolling/main non-free contrib
deb-src http://mirrors.neusoft.edu.cn/kali kali-rolling/main non-free contrib

# 更新缓存
apt-get update
```

### kali 软件更新

```
sudo apt update -y && sudo apt full-upgrade -y

sudo apt-get clean 				# 清理旧软件缓存；
sudo apt -f install 			# 修复损坏的软件包；
sudo apt update 				# 更新自带软件库；
sudo apt-get update 			# 更新软件；
sudo apt-get dist-upgrade 		# 更新系统；
sudo apt --fix-broken install 	# 解决依赖关系缺少问题；
sudo reboot 					# 重启系统。
```
### Kali Linux上安装SSH服务

```
sudo apt update
sudo apt -y install openssh-server
```

**启动 SSH 服务**：  

```
sudo service ssh start
sudo systemctl start ssh
```

**启用SSH服务开机自启：**  

```
sudo update-rc.d ssh enable
sudo systemctl enable --now ssh
```

### kali 离线数据库更新

#### MSF更新漏洞数据

```
【https://www.python100.com/html/80496.html】
	独立安装：
		msfupdate
		msfvenom –list payloads
	kali中：
		apt update; apt install metasploit-framework
```

#### searchsploit

```
searchsploit -u
searchsploit --update
```

#### wpscan
```shell
wpscan --update
```
## 安装BurpSuite pro 并破解

[Kali 安装BurpSuite pro](https://blog.csdn.net/weixin_70036935/article/details/131277280)


# Man tools

[网络安全（黑客）工具篇\_netscantools-CSDN博客](https://blog.csdn.net/youshowkm/article/details/132171802)

# 字典
## 安装 SecLists字典
```
sudo apt install seclists -y
```
## rockyou.txt.gz解压
```
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz
```
# **安装中文语言包**
 
 执行命令`apt install -y language - pack - zh - hans`来安装简体中文语言包。如果需要安装繁体中文语言包，可以使用`apt install -y language - pack - zh - hant`。
  安装过程中，系统会自动下载并安装相关的语言文件、字体等组件。

**配置系统语言环境**
- 安装完成后，需要配置系统语言环境。可以通过编辑`/etc/default/locale`文件来实现。使用文本编辑器（如 nano 或 vim）打开该文件：
- `nano /etc/default/locale`
- 在文件中添加或修改以下内容：
 - `LANG="zh_CN.UTF - 8"`（如果安装的是简体中文）或`LANG="zh_TW.UTF - 8"`（如果安装的是繁体中文）
- 保存文件并退出编辑器。然后，重新登录系统或者执行`source /etc/default/locale`命令使配置生效。

# **安装中文输入法（以安装 Fcitx 输入法为例）**


1.安装 Fcitx 框架和相关输入法引擎
```
 apt install -y fcitx
```
- 接着安装常用的中文输入法引擎，如搜狗拼音输入法（如果有官方安装包的话），或者安装 Fcitx - googlepinyin 输入法：
```
apt install -y fcitx-googlepinyin
```
2.配置输入法
- 打开系统设置（在 Kali Linux 的应用菜单中可以找到）。
- 在 “区域和语言” 或类似选项中，找到 “输入法” 部分。
- 将 Fcitx 设置为默认输入法。
- 注销并重新登录系统后，就可以通过 Ctrl + Space（默认快捷键）等方式切换出中文输入法并使用了

# KALI伪装模式

kali桌面变成windows桌面

启动：
- 在终端中输入`kali-undercover`
- 从桌面菜单中查找`Kali Undercover Mode`并启动它

退出:
- 在终端再次输入`kali-undercover`
- 从桌面菜单中查找`Kali Undercover Mode`并执行

# KALI初始化脚本
```
#!/bin/bash

# 备份原始的源列表文件
cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 添加国内镜像源
echo "# 阿里云" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list

# 更新缓存
apt-get update

# 清理旧软件缓存
apt-get clean

# 更新镜像软件列表
apt-get upgrade -y

# 修复损坏的软件包
apt-get --fix-broken install -y

# 解决依赖关系缺少问题
apt-get -f install -y

# 安装 openssh-server，并设置开机启动，启动服务
apt-get install -y openssh-server lrzsz nmap gobuster dirsearch dirb gospider
systemctl enable openssh-server
systemctl start openssh-server

# 测试是否有互联网连接
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    # 更新 MSF 漏洞数据
    msfupdate
    # 更新 searchsploit 漏洞数据
    searchsploit -u
fi

# 重启系统
reboot
```


# 安装启用ssh服务




# WSL

## 启用GUI


https://www.bilibili.com/opus/769244302370930712