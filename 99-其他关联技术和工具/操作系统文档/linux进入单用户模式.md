# 进入方法

进入单用户模式后，您可以执行`exec /sbin/init`命令退出该模式。
## CentOS系统

本节以 CentOS 7.6 64位操作系统为例。

1. 使用VNC方式[登录云服务器](https://www.volcengine.com/docs/6396/67747)。
   使用ECS Terminal方式登录的实例，在通过命令重启时不能直接进入启动系统页面，因此 **不建议** 使用该登录方式。
   
2. 在登录页面左侧单击 ![](https://minioapi.nerubian.cn/image/20250120133933748.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120133936596.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120133938627.png) 图标重启实例，并在重启中出现内核选项页面时快速按下`e`键，进入内核编辑页面。
   
    内核选项页面如下：  
    ![alt](https://minioapi.nerubian.cn/image/20250120133942259.png)内核编辑页面如下：  
    ![alt](https://minioapi.nerubian.cn/image/20250120133945614.png)
    
3. 在内核编辑页面，使用键盘的方向键定位至`linuxefi`开头行：将本行中`ro`至末尾的内容替换为`rw init=/bin/bash`。
   
    替换前：  
    ![alt](https://minioapi.nerubian.cn/image/20250120133948758.png)替换后：  
    ![alt](https://minioapi.nerubian.cn/image/20250120133951672.png)
    
4. 按下`F10`键或`ctrl+x`组合键，系统进入单用户模式。  
    ![image.png](https://minioapi.nerubian.cn/image/20250120133954196.png)

## Ubuntu系统

本节以 Ubuntu 20.04 64位操作系统为例。

1. 使用VNC方式[登录云服务器](https://www.volcengine.com/docs/6396/67747)。
   
    > 使用ECS Terminal方式登录的实例，在通过命令重启时不能直接进入启动系统页面，因此 **不建议** 使用该登录方式。
    
2. 在登录页面左侧单击 ![](https://minioapi.nerubian.cn/image/20250120133958351.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120134000528.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120134002484.png) 图标重启实例，并在重启时长按`shift`键，进入GRUB界面。在某些计算机上，也可以使用`esc`键来进入GRUB界面。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134004424.png)
    
3. 使用键盘的方向键定位至该页面中的高级选项（Advanced options for Ubuntu），并按`enter`键。
   
4. 进入跳转页面，按`e`键进入内核编辑页面。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134007875.jpeg)
    
5. 使用键盘方向键将光标移至`linux`行：将本行中`ro`至末尾的内容替换为`rw single init=/bin/bash`。
   
    替换前：  
    ![alt](https://minioapi.nerubian.cn/image/20250120134010602.png)替换后：  
    ![alt](https://minioapi.nerubian.cn/image/20250120134012926.jpeg)
    
6. 按下`F10`键或`ctrl+x`组合键，系统进入单用户模式。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134015501.png)

### Ubuntu 18

步骤：

1. 开机重启,常按ESC，

2. 进入 Grub选择页面，选择【advanced options for ubuntu】也就是高级选项，按e进入编辑模式
3. 找到 linux /boot/vmlinuz-*那行，将此行的内容截图或拍照保存下来
4. 将它的ro recovery nomodestset及之后的东西替换为rw single init=/bin/bash，
5. 然后按 ctrl+x或者F10 进入单用户模式，此时用户即为root用户

### Ubuntu 19





### Ubuntu 20

1. 开机重启

2. 常按ESC，此时会进入BIOS选项，直接回车就行

3. 回车后按一下ESC即可进入Grub启动菜单，如果按多了进入Grub命令行，那么重新来一遍。

4. 选择Ubuntu 的高级选项

5. 选择 recovery mode那行按e进入编辑模式

6. 找到 linux /boot/vmlinuz-* 那行，将它的ro recovery nomodestset及之后的东西替换为rw single init=/bin/bash，然后按 ctrl+x或者F10 进入单用户模式，此时用户即为root用户



Linux系统的单用户模式是一种维护模式，适用于排查系统故障、修改用户名或密码、维护硬盘分区等。本文介绍Linux实例如何通过系统引导器（GRUB）进入单用户模式。


## Debian系统

本节以 Debian 10 64位操作系统为例。

1. 使用VNC方式[登录云服务器](https://www.volcengine.com/docs/6396/67747)。
   
    > 使用ECS Terminal方式登录的实例，在通过命令重启时不能直接进入启动系统页面，因此 **不建议** 使用该登录方式。
    
2. 在登录页面左侧单击 ![](https://minioapi.nerubian.cn/image/20250120134019924.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120134021900.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120134023717.png) 图标重启实例，实例重启时进入系统选择页面后快速按下`e`键，进入内核编辑页面。  
    系统选择界面如下图所示。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134027881.jpeg)内核编辑界面如下图所示。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134030901.png)
    
3. 使用键盘方向键将光标移至`linux`行：在本行末尾添加`quiet single`。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134033502.png)
    
4. 按下`F10`键或`ctrl+x`组合键启动系统，按提示输入root密码，进入单用户模式。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134037020.png)

## OpenSUSE系统

本节以 OpenSUSE 15.2 64位操作系统为例。

1. 使用VNC方式[登录云服务器](https://www.volcengine.com/docs/6396/67747)。
   
    > 使用ECS Terminal方式登录的实例，在通过命令重启时不能直接进入启动系统页面，因此 **不建议** 使用该登录方式。
    
2. 在登录页面左侧单击 ![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_dfefbb5ce089e5fb40c950bd1a578eb2.jpg) > ![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_cfef8d9bfee5a30b55cf0d08dfe86d78.jpg) > ![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_e39abf27456271e1274a9f6c40033038.png) 图标重启实例，实例重启时进入系统选择页面后快速按下`e`键，进入内核编辑页面。  
    系统选择页面如下图所示。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134039663.jpeg)内核编辑页面如下图所示。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134042073.png)
    
3. 使用键盘方向键将光标移至`linux`行：在本行中`splash`前添加`rw`，在`silent`后添加`1`。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134044882.png)
    
4. 按下`F10`键或`ctrl+x`组合键启动系统，按提示输入root密码，进入单用户模式。  
    ![image.png](https://minioapi.nerubian.cn/image/20250120134049555.png)

## Fedora系统

本节以Fedora 33 64位操作系统为例。

1. 使用VNC方式[登录云服务器](https://www.volcengine.com/docs/6396/67747)。
   
    > 使用ECS Terminal方式登录的实例，在通过命令重启时不能直接进入启动系统页面，因此 **不建议** 使用该登录方式。
    
2. 在登录页面左侧单击 ![](https://minioapi.nerubian.cn/image/20250120134053762.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120134052029.jpeg) > ![](https://minioapi.nerubian.cn/image/20250120134057800.png) 图标重启实例，实例重启时进入系统选择页面后快速按下`e`键，进入内核编辑页面。  
    系统选择页面如下图所示。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134059969.jpeg)内核编辑页面如下图所示。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134102248.png)
    
3. 使用键盘方向键将光标移至`linux`行：将本行中`ro`至末尾的内容替换为`rw single init=/bin/bash`。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134104042.png)
    
4. 按下`F10`键或`ctrl+x`组合键启动系统，系统进入单用户模式。  
    ![alt](https://minioapi.nerubian.cn/image/20250120134108858.png)
    


# 网络修改方法：

## Debian

通过修改 `/etc/network/interfaces` 文件来配置Debian系统的IP地址

```
sudo vim /etc/network/interfaces

auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
PS：eth0 是你的网络接口名称
	static 代表静态IP地址,动态IP设置为dhcp
	address 是你想要设置的IP地址
	netmask 是子网掩码
	gateway 是网关地址
	
重启网络服务激活新的网络设置：
sudo systemctl restart networking

```

