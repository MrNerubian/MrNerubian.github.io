https://pythonjishu.com/pumbijbhcakkaaz/

Freebsd是一款开源的类Unix操作系统，本篇文章将为你提供Freebsd的用法配置汇总。

## 安装

Freebsd的安装流程可以参见官方手册，这里不再赘述。

## 更新系统

可以通过以下命令更新操作系统：

```
freebsd-update fetch
freebsd-update install
```

## 安装软件包

Freebsd使用pkg命令来安装软件包，可以使用以下命令搜索和安装软件包：

```
pkg search software_name
sudo pkg install software_name
```

例如，在安装apache2时，可以使用以下命令：

```
pkg search apache2
sudo pkg install apache24

1.可以使用ports安装

cd /usr/ports/www/apache22

make install clean

第一次安装由于没有配置config,所以会弹出窗口让你选择模块,选择所需要的模块进行安装

2.使用编译好的包远程安装

pkg_add -rv apache22

3.配置apache

apache的主配置文件是/usr/local/etc/apache22/httpd.conf，可以根据实际情况修改，主要并且重要的参考：http://lamp.linux.gov.cn/Apache/ApacheMenu/index.html

4.启动apache

echo 'apache22_enable="YES"' >> /etc/rc.conf

/usr/local/etc/rc.d/apache22 start

```


## 配置防火墙

Freebsd默认使用Ipfw防火墙。可以通过以下命令来启用或停用Ipfw防火墙：

```
sudo service ipfw start
sudo service ipfw stop
```

也可以通过编辑`/etc/ipfw.rules`文件来修改防火墙规则。例如，以下是一个简单的防火墙规则：

```
# 允许TCP端口80和443
allow tcp from any to me 80,443 in
# 允许本地回环地址
allow ip from me to me
# 拒绝所有其他流量
deny all
```

## 配置ssl证书

可以通过openssl命令来生成ssl证书。例如：

```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/etc/apache24/server.key -out /usr/local/etc/apache24/server.crt
```

这会在`/usr/local/etc/apache24`目录下生成一个自签名的ssl证书。

## 配置ssh服务

可以通过编辑`/etc/ssh/sshd_config`文件来配置ssh服务。例如，以下是一个简单的配置示例：

```
# 允许root用户登录
PermitRootLogin yes
# 允许密码登录
PasswordAuthentication yes
# 禁止使用空密码登录
PermitEmptyPasswords no
```

## 配置网络

Freebsd使用`/etc/rc.conf`文件来配置网络。例如，在配置静态ip时，可以添加以下内容到`/etc/rc.conf`：

```
ifconfig_em0="inet 192.168.0.2 netmask 255.255.255.0"
defaultrouter="192.168.0.1"
static_routes="office1"
route_office1="-net 10.0.0.0/8 192.168.0.254"
```

这会将em0网卡的ip设为192.168.0.2，并将默认网关设置为192.168.0.1。

## 总结

本文介绍了Freebsd的用法配置汇总，包括软件包安装、防火墙配置、ssl证书生成、ssh服务配置和网络配置等。通过本文的介绍，您可以更好地了解和使用Freebsd系统。