# 官方文档

更新日期：2023 年 11 月 4 日  
作者： [Re4son](https://gitlab.com/Re4son "雷4son的个人资料") 、 [yesimxev](https://gitlab.com/yesimxev "yabo88app下载 的个人资料")

Kali NetHunter 是一个基于 Kali Linux 的免费开源移动渗透测试平台，适用于 Android 设备。

官方文档：[Kali NetHunter | Kali Linux Documentation](https://www.kali.org/docs/nethunter/#80-porting-nethunter-to-new-devices)
设备支持列表：[Kali NetHunter Images](https://nethunter.kali.org/images.html)

## 概述

Kali NetHunter 适用于未 root 的设备 (NetHunter Rootless)、具有自定义恢复功能的 root 设备 (NetHunter Lite)，以及具有 NetHunter 特定内核的自定义恢复的 root 设备 (NetHunter)。

Kali NetHunter 的核心包含在所有三个版本中，包括：

- Kali Linux 容器，包含 Kali Linux 提供的所有工具和应用程序
- Kali NetHunter App Store 包含数十个专用安全应用程序
- Android客户端访问Kali NetHunter应用商店
- Kali NetHunter Desktop Experience (KeX) 可运行完整的 Kali Linux 桌面会话，并支持通过 HDMI 或无线屏幕投射进行屏幕镜像

[![](https://www.kali.org/docs/nethunter/NetHunter-Kex.png)](https://www.kali.org/docs/nethunter/NetHunter-Kex.png)
图 2：Kali NetHunter Desktop Experience (KeX) 输出到 HDMI 显示器

Kali NetHunter 应用商店可以通过专用客户端应用程序或网络界面访问。

[![](https://www.kali.org/docs/nethunter/nethunter-store-02.png)](https://www.kali.org/docs/nethunter/nethunter-store-02.png)
图 3：Kali NetHunter 应用商店

两个 root 版本都提供额外的工具和服务。自定义内核可以通过添加额外的网络和 USB 小工具驱动程序以及对选定 WiFi 芯片的 WiFi 注入支持来扩展该功能。

[![](https://www.kali.org/docs/nethunter/NetHunter-App.png)](https://www.kali.org/docs/nethunter/NetHunter-App.png)
图 3：Kali NetHunter 应用程序提供两种 root 版本（NetHunter Lite 和 NetHunter）。

除了Kali Linux 中包含的[渗透测试工具](https://www.kali.org/tools/)之外，NetHunter 还支持其他几个类别，例如HID 键盘攻击、BadUSB 攻击、邪恶 AP MANA 攻击等等。

有关构成 NetHunter 的活动部件的更多信息，请查看我们的[NetHunter 组件](https://www.kali.org/docs/nethunter/nethunter-components/)页面。Kali NetHunter 是一个由[Kali](https://www.kali.org/)和社区开发的[开源项目。](https://www.kali.org/docs/policy/kali-linux-open-source-policy/)[](https://www.kali.org/)

## 1.0 NetHunter 版本

NetHunter 可以使用以下版本之一安装在几乎所有 Android 设备上：

| 版本                 |                                       |
| ------------------ | ------------------------------------- |
| NetHunter Rootless | NetHunter 的核心，适用于未 root、未修改的设备        |
| NetHunter Lite     | 适用于没有自定义内核的 root 手机的完整 NetHunter 软件包。 |
| NetHunter          | 完整的 NetHunter 软件包，带有适用于受支持设备的自定义内核    |

下表说明了功能上的差异：

| 特征               | NetHunter Rootless | NetHunter Lite | NetHunter |
| ---------------- | ------------------ | -------------- | --------- |
| 应用商店             | 是的                 | 是的             | 是的        |
| Kali命令行          | 是的                 | 是的             | 是的        |
| 所有 Kali 包        | 是的                 | 是的             | 是的        |
| KeX              | 是的                 | 是的             | 是的        |
| Metasploit 不带数据库 | 是的                 | 是的             | 是的        |
| Metasploit 带数据库  | 不                  | 是的             | 是的        |
| NetHunter应用程序    | 不                  | 是的             | 是的        |
| 需要 TWRP          | 不                  | 是的             | 是的        |
| 需要root权限         | 不                  | 是的             | 是的        |
| WiFi注入           | 不                  | 不              | 是的        |
| HID 攻击           | 不                  | 不              | 是的        |

NetHunter Rootless 的安装记录如下： [NetHunter-Rootless](https://www.kali.org/docs/nethunter/nethunter-rootless/)

NetHunter-App 特定章节仅适用于 NetHunter 和 NetHunter Lite 版本。

内核特定章节仅适用于 NetHunter 版本。

## 2.0 NetHunter 支持的设备和 ROM

NetHunter Lite 可以安装在所有已 root 并具有自定义恢复功能的 Android 设备上。完整的 NetHunter 体验需要专门为 Kali NetHunter 构建的设备特定内核。NetHunter [GitLab 存储库](https://gitlab.com/kalilinux/nethunter/)包含适用于超过 65 种设备的超过 164 个内核。[Kali Linux 在NetHunter 下载页面](https://www.kali.org/get-kali/)上发布了超过 25 个针对最流行设备的镜像。以下实时报告由 GitLab CI 自动生成：

[每季度发布的官方 NetHunter 镜像列表](https://nethunter.kali.org/images.html) 
[非官方 NetHunter 支持的内核列表](https://nethunter.kali.org/kernels.html)
[NetHunter 内核统计信息](https://nethunter.kali.org/kernel-stats.html)


## 3.0 下载NetHunter


可以从位于以下 URL 的 Kali Linux 页面下载适用于您的特定受支持设备的正式版本 NetHunter 映像：

- [kali.org/get-kali/](https://www.kali.org/get-kali/)

下载 zip 文件后，根据下载页面上的值验证 NetHunter zip 映像的 SHA256 总和。如果 SHA256 和不匹配，请勿尝试继续安装过程。


## 4.0 构建NetHunter


想要从我们的 Gitlab 存储库构建 NetHunter 镜像的人可以使用我们的 Python 构建脚本来实现。请查看我们的[Building NetHunter](https://www.kali.org/docs/nethunter/building-nethunter/)页面以获取更多信息。[您可以在nethunter-installer](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/blob/master/nethunter-installer) git 目录中的自述[文件](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/blob/master/nethunter-installer/README.md)中找到有关使用 NetHunter 安装程序生成器或添加您自己的设备的其他说明。[](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/blob/master/nethunter-installer)

## 5.0 在 Android 上安装 NetHunter


现在您已经下载了 NetHunter 映像或自己构建了一个 NetHunter 映像，接下来的步骤是准备您的 Android 设备，然后安装该映像。“准备您的 Android 设备”包括：

- 解锁您的设备并将其更新为原厂AOSP 或 LineageOS (CM)。（检查点[2.0](https://www.kali.org/docs/nethunter/#20-nethunter-supported-devices-and-roms)是否支持 ROM）
- 安装[Team Win Recovery Project](https://twrp.me/)作为自定义恢复。
- 安装[Magisk](https://github.com/topjohnwu/Magisk)以 root 设备
- 如果 TWRP 无法访问数据分区，则可能需要禁用强制加密
- 一旦您完成自定义恢复，剩下的就是将 NetHunter 安装程序 zip 文件刷入您的 Android 设备。


## 6.0 安装后设置


- 打开 NetHunter 应用程序并启动 Kali Chroot Manager。
- 使用 NetHunter Store 应用程序从 NetHunter Store 安装黑客键盘。
- 根据需要从 NetHunter 商店安装任何其他应用程序。
- 配置 Kali 服务，例如 SSH。
- 设置自定义命令。
- 初始化漏洞利用数据库。


## 7.0 Kali NetHunter 攻击和功能

#### Kali NetHunter 应用程序

- [主屏幕](https://www.kali.org/docs/nethunter/nethunter-home-screen/)- 一般信息面板、网络接口和 HID 设备状态。
- [Kali Chroot Manager](https://www.kali.org/docs/nethunter/nethunter-chroot-manager/) - 用于管理 chroot 元包安装。
- [Kali 服务](https://www.kali.org/docs/nethunter/nethunter-kali-services/)- 启动/停止各种 chroot 服务。在启动时启用或禁用它们。
- [自定义命令](https://www.kali.org/docs/nethunter/nethunter-custom-commands/)- 将您自己的自定义命令和功能添加到启动器。
- [MAC 更改器](https://www.kali.org/docs/nethunter/nethunter-mac-changer/)- 更改您的 Wi-Fi MAC 地址（仅在某些设备上）
- [KeX Manager](https://www.kali.org/docs/nethunter/nethunter-kex-manager/) - 使用您的 Kali chroot 设置即时 VNC 会话。
- [USB Arsenal](https://www.kali.org/docs/nethunter/nethunter-usbarsenal/) - 控制 USB 小工具配置
- [HID 攻击](https://www.kali.org/docs/nethunter/nethunter-hid-attacks/)- 各种 HID 攻击，青少年风格。
- [DuckHunter HID](https://www.kali.org/docs/nethunter/nethunter-duckhunter/) - Rubber Ducky 风格的 HID 攻击
- [BadUSB MITM 攻击](https://www.kali.org/docs/nethunter/nethunter-badusb/)- Nuff 说。
- [MANA 无线工具包](https://www.kali.org/docs/nethunter/nethunter-mana-wireless/)- 单击按钮即可设置恶意接入点。
- [蓝牙军械库](https://www.kali.org/docs/nethunter/nethunter-btarsenal/)- 侦察、欺骗、监听或将音频注入各种蓝牙设备。
- [社会工程师工具包](https://www.kali.org/docs/nethunter/nethunter-set/)- 为社会工程师工具包构建您自己的网络钓鱼电子邮件模板。
- [MITM 框架](https://www.kali.org/docs/nethunter/nethunter-mitmf/)- 将二进制后门动态注入到下载的可执行文件中。
- [NMap Scan](https://www.kali.org/docs/nethunter/nethunter-nmap/) - 快速 Nmap 扫描仪界面。
- [Metasploit Payload Generator](https://www.kali.org/docs/nethunter/nethunter-mpg/) - 动态生成 Metasploit 有效负载。
- [Searchsploit](https://www.kali.org/docs/nethunter/nethunter-searchsploit/) [- 在漏洞数据库](https://www.exploit-db.com/)中轻松搜索漏洞。

#### NetHunter App Store 中的第 3 方 Android 应用程序

- [NetHunter 终端应用程序](https://www.kali.org/docs/nethunter/nethunter-terminal/)

## 8.0 将 NetHunter 移植到新设备

如果您有兴趣将 NetHunter 移植到其他 Android 设备，请查看以下链接。如果您的端口工作正常，请务必告诉我们，以便我们可以将这些内核包含在我们的版本中！

1. [手动入门](https://www.kali.org/docs/nethunter/porting-nethunter/)
2. [内核构建器入门](https://www.kali.org/docs/nethunter/porting-nethunter-kernel-builder/)
3. [修补内核](https://www.kali.org/docs/nethunter/nethunter-kernel-1-patching/)
4. [配置内核](https://www.kali.org/docs/nethunter/nethunter-kernel-2-config-1/)
5. [添加您的设备](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-devices)

## 9.0 已知工作硬件

1. [无线网卡](https://www.kali.org/docs/nethunter/wireless-cards/)
2. SDR - RTL-SDR（基于RTL2832U）
3. 蓝牙适配器 - Sena UD100 或通用 CSR4.0 适配器

## 10.0 NetHunter 应用程序

所有应用程序都可以通过 NetHunter Store 客户端安装。
## 11.0 有用的链接

1. [NetHunter Store 应用程序可在此处](https://store.nethunter.com/NetHunterStore.apk)下载[](https://store.nethunter.com/NetHunterStore.apk)
2. [NetHunter 网上商店可在此处](https://store.nethunter.com/)找到[](https://store.nethunter.com/)
3. [构建 NetHunter 应用程序的源代码可以在 GitLab上](https://gitlab.com/kalilinux/nethunter/apps/)找到：[](https://gitlab.com/kalilinux/nethunter/apps/)


# OnePlus 8T 个人记录

 OnePlus 8T 安装 NetHunter
重要提示：安装 Universal Mount SystemRW 脚本  
重要提示：刷机后更新 NetHunter 应用程序

### 安装包版本及下载连接表


| 名称             | 版本号 | 连接  |
| -------------- | --- | --- |
| 安卓11刷机包        |     |     |
| 9008驱动         |     |     |
| root工具         |     |     |
| Magisk工具       |     |     |
| TWRP工具         |     |     |
| ADB工具          |     |     |
| Kali nethunter |     |     |

安卓11刷机包：[大侠阿木-一加手机官方ROM下载](https://yun.daxiaamu.com/OnePlus_Roms/)
驱动：
root工具：[首页 - 其他文件 - 一加手机官方ROM下载](https://yun.daxiaamu.com/files/)
Magisk工具：[Magisk模块 - 其他文件 - 一加手机官方ROM下载](https://yun.daxiaamu.com/files/Magisk%E6%A8%A1%E5%9D%97/)
TWRP工具：
ADB工具：
Kali nethunter：




### 电脑准备

准备高通9008驱动并安装
打开管理 cmd 并输入：“bcdedit /set testsigning on”，重新启动Windows，此操作用于在 Windows 系统中启用测试签名模式（test mode）。重启生效，开机后右下角有测试模式的字样
打开设备管理器
关闭 OnePlus 7 电源，按 vol + & vol - 在同时，数到 5 并将手机连接到笔记本电脑，直到设备管理器中出现9008驱动的条目（win11系统出现安卓驱动条目）

### 手机准备
1、通过MsmDownloadTool工具线刷的方式，刷入完整纯净的氢系统（Android 11）【instantnoodlep_15_H.44_211208.ops】包
2、进入系统后，将完整包复制到sdcard根目录下，使用更新系统功能【设置-系统更新-本地升级】进行覆盖安装
【OnePlus8ProHydrogen_15.H.45_OTA_0450_all_2202142225_140494bd81f848bc.zip】（这个版本应该是停更前最后一个版本的氢系统）
	
系统准备完毕后就可以正式刷解bl锁、刷第三方rec、和kali NetHunter了。

### 知识准备

adb工具命令：
```
fastboot devices     在Android设备上进行快速启动模式
fastboot getvar all  在Android设备的快速启动模式下获取设备的所有变量信息的命令
fastboot flash recovery D:\TWRP-V2.0.1.img  在Android设备的快速启动模式下，将TWRP-V2.0.1.img刷入到设备的恢复分区中
fastboot reboot      在 Android 设备的快速启动模式下重新启动设备
fastboot --set-active=other  在双引导系统中切换活动的系统槽 
fastboot reboot recovery  在Android设备的快速启动模式下重新启动并进入恢复模式
adb devices          列出与计算机连接的 Android 设备
adb reboot edl       用于进入安卓设备的紧急下载模式（edl模式）
adb shell            进入设备的 shell 环境
cat /product/etc/build.prop  build.prop 文件包含了设备的各种属性和配置信息，比如设备的型号、制造商、版本号等
fastboot flash boot D:\boot.img  在Android设备上使用fastboot工具在启动分区刷入启动镜像
fastboot flash recovery D:\recovery.img 在Android设备上使用fastboot工具在恢复分区刷入恢复镜像
adb reboot bootloader  通过ADB将Android设备重新启动到引导加载程序(bootloader)模式。在这种模式下，用户可以执行诸如刷写固件、解锁引导加载程序等操作。
```
### 1.解锁bootloader

​ 开发者选项->开启adb调试模式
​ 开发者选项->ome 解锁 启用
​ 进入fastboot模式
`adb reboot bootloader`
​ fastboot模式下直接输入解锁指令
​`fastboot oem unlock`
​ 手机使用音量键选择下面的确认解锁并按电源键确认
​ 手机会自动重启并且格式化data分区，进入系统就OK了

### 2.第三方recovery 刷入TWRP

​ 开发者选项->开启adb调试模式
​ 进入fastboot模式
​`adb reboot bootloader`
​ fastboot模式下刷入TWRP镜像文件
​`fastboot flash recovery twrp-3.7.0_11-0-instantnoodle.img`
​ 刷入完成，重启至 recovery 模式，在手机用音量键选择电源键确认
​ 进入重启至system，进入系统就OK了
### 3.刷入Magisk

​ 在手机上安装 Magisk-v23.0.apk （之前安装v25.0没成功，执行下面脚本时候报错 super.img时候 报错误码 76）
​ 手机重启至 recovery模式
​`adb reboot recovery`
​ 在将Magisk-v23.0.apk 改个名 后面加入Magisk-v23.0.apk.zip传入手机
​`adb push Magisk-v23.0.apk.zip /sdcard`
​ 通过TWRP刷入 Magisk-v23.0.apk.zip

### 4.运行systemrw脚本

​ 解压缩 systemrw_1.32_flashable.zip 得到文件夹“systemrw_1.32”
​ 将已解压缩的systemrw_1.32文件夹 传入 /data/local/tmp 目录下
​`adb push C:\Users\Administrator\Desktop\adb\kali\systemrw_1.32 /data/local/tmp`
​ 然后赋予权限并执行此脚本
​`adb shell`
​`cd /data/local/tmp/systemrw_1.32`
`​ chmod +x systemrw.sh`
​`./systemrw.sh size=100`
​ 等待脚本执行完毕
​ 看到如下字样 重启进入系统
```
systemrw: Congratulations! Your image(s) should now have R/W capability
systemrw: Deleting /data/local/tmp/systemrw_1.32/img/super_fixed.bin to free up some space
systemrw: Please reboot to system...
```
​`reboot`

### 5.检查system读写权限

​ 开机后安装mt管理器或其他超级管理器
​ 检测 /system 能否有权限成功创建目录，随便创建"123"（不能创建目录从新执行第4步骤）
### 6.使用Magisk刷入NetHunter

​ 将 nethunter-oneplus8-all-eleven-kalifs-full.zip 包传入手机
​`adb push nethunter-oneplus8-all-eleven-kalifs-full.zip /sdcard`
​ 使用使用Magisk 刷入 nethunter-oneplus8-all-eleven-kalifs-full.zip

### 7.刷入NetHunter内核

​ 进入 recovery TWRP模式刷入内核
​ 注意刷入内核前做备份否则极易无法开机
​`adb push NetHunter_Kernel_for_OnePlus8_A11_old.zip /sdcard`
​ TWRP刷入NetHunter_Kernel_for_OnePlus8_A11_old.zip

### 8.重启进入系统更新应用
​ 开机后打开 F-Droid商店
​ 更新NetHunter 并安装

### 9.NetHunter启动 chroot
​ 打开 NetHunter启动 chroot查看是否成功启动

### 10.成功-完成

经过测试功能一切正常，除了官方已经说明了 内置wlan0网卡 切换monter模式 需要等待15秒暂时还没发现其他问题。



# 11111111111111111111111111111111111



## 1. 刷入最新库存（OOS）Android 10


1.05、当检测到设备 (bing) 时，MsmDownloadTool按start 
1.06、重新启动并设置设备  
1.07、在开发人员选项中，启用 OEM 解锁和 USB 调试  
	进入设置界面后，下拉最后找到关于手机，点进关于手机后，找到版本号后连续点击后面符号，即可进去开发者模式了.
1.08、sudo apt install adb  
1.09、adb Kill-server && 。 /adb start-server  
1.10、adb restart bootloader  
1.11、sudo fastboot oem unlock  
1.12、重新启动并设置手机

## 2.刷入 TWRP和Magisk

Magisk项目地址：[Releases · topjohnwu/Magisk](https://github.com/topjohnwu/Magisk/releases)

1、下载安装包
- oplus.icu 网站

2、包上传到手机根目录


2.01 复制到 Oneplus7  
2.02 下载[https://github.com/topjohnwu/Magisk/releases/download/v19.3/Magisk-v19.3.zip](https://github.com/topjohnwu/Magisk/releases/download/v19.3/Magisk-v19.3.zip)到 Oneplus7  
2.03 下载[https://dl.twrp.me/guacamoleb/twrp -3.3.1-1-guacamoleb.img.html](https://dl.twrp.me/guacamoleb/twrp-3.3.1-1-guacamoleb.img.html)到 PC 
	TWRP for 8T :https://github.com/TeamWin/android_device_oneplus_kebab
2.04 安装 Android 平台工具  
2.05 在手机的开发者选项中，启用 USB 调试  
2.06 adb Kill-server && ./adb start-server  
2.07 adb restart bootloader  
2.08 sudo fastboot boot twrp-3.3.1-1-guacamoleb.img  
2.09 设备自动重新启动进入 trwp  
2.10 在 twrp 中，安装 twrp-installer-3.3.1-1-guacamoleb.zip 和 Magisk-v19.3.zip，重新启动  
2.11 重新启动

## 3.禁用数据分区的强制加密

3.01 重新启动到恢复  
3.02 格式/数据  
3.03 重新启动到恢复  
3.04 安装 Magisk  
3.05 安装Disable_Dm-Verity_ForceEncrypt_11.02.2020.zip  
3.06 重新启动到系统  
3.07 设置手机但跳过指纹或任何其他安全性。稍后设置（不确定是否会重新加密手机）

## 4.安装NetHunter

4.01 从[我们的下载页面](https://www.kali.org/get-kali/#kali-mobile)  
4.02 当前安装程序有一个错误，需要单独安装内核，请[在此处下载](https://build.nethunter.com/contributors/re4son/guacamole/kernel-nethunter-2021.3-oneplus7-oos-ten.zip)  
4.03 重新启动进入恢复  
4.04 安装 nethunter zip  
4.06 再次安装 Magisk  
4.07 再次安装禁用强制加密器  
4.08 重新启动  
4.09 运行NetHunter 应用程序，等待初始设置完成，然后重新启动  
4.10 从商店更新 NetHunter 应用程序

## 5.禁用OnePlus更新服务


5.01 以 root 身份打开 Android 终端  
5.02 su -c pmdisable com.oneplus.opbackup  
5.03 “系统更新”服务现已禁用

### 在 OnePlus 7 上享受 Kali NetHunter

请通过提交问题和拉取请求来帮助开发。我们非常感激。

# Kali Nethunter安装指南
[Kali Nethunter安装指南](http://www.taodudu.cc/news/show-3628093.html?action=onClick)

# XDA论坛教程

主要是参照XDA论坛提供的 教程、脚本，和内核：
[Site Unreachable](https://xdaforums.com/t/rom-unofficial-nethunter-oneplus-8t-android-11-12-26-08-21.4324555/)

Kali NetHunter 是一个 Android ROM 覆盖层，可将普通手机变成终极移动渗透测试平台。  
该覆盖层包括一个自定义内核、一个 Kali Linux chroot、一个随附的 Android 应用程序（可以更轻松地与各种安全工具和攻击进行交互）以及 Kali NetHunter 应用商店的客户端。  
除了 Kali Linux 和 Kali NetHunter 应用商店中的渗透测试工具库之外，NetHunter 还支持其他几个类别，例如 HID 键盘攻击、BadUSB 攻击、邪恶 AP MANA 攻击等等。有关构成 NetHunter 的活动部件的更多信息，请查看 NetHunter 组件页面。  
NetHunter 是 Offective Security 和社区开发的开源项目。​

### 特点

- WiFi注入​
- 内部 WiFi 监控模式​
- AirSpy / HackRF (RTL-SDR)​
- 蓝牙（RFCOMM）​
- USB 阿森纳​
- NetHunter 支持列表中的外部 WiFi 适配器​
- HID 攻击​
- RFID平台支持​
- 基于 Neutrino 内核的 A11 版本，并合并了 CAF 4.19 和 linux-stable​
- 基于 crDroid 内核的 A12 版本，并合并了 CAF 4.19 和 linux-stable​
- 禁用 Android Paranoid 网络模式，以允许访问 PostgreSQL、apt、ping 和其他命令的所有网络功能​

### 先决条件

- 清洁 A11 OxygenOS 或自定义 ROM​
- 定制 A12 ROM​
- 解锁的引导加载程序​
- [TWRP](https://twrp.me/)
- [魔法师](https://github.com/topjohnwu/Magisk)
- [通用安装系统读写 R/W](https://xdaforums.com/t/script-android-10-universal-mount-system-read-write-r-w.4247311/) 

### 如何安装

剧透：OxygenOS

1. 将 twrp、magisk、System_RW_sript、NetHunter 内核和 NetHunter zip 复制到外部 USB-C 驱动器​
2. 闪存 TWRP​
3. 重新启动进入恢复，格式化数据并重新启动回到恢复
4. 重新启动系统，完成 Android 设置，启动 Magisk 应用程序并应用安装后要求​
5. 将 systemrw_1.32 文件夹复制到 /data/local/tmp 并使脚本 systemrw.sh 可执行（chmod +x）​
6. 重新启动到 TWRP，启动终端并运行命令/data/local/tmp/systemrw_1.32/systemrw.sh size= 100
7. 重新启动系统并检查写入系统文件夹的能力（例如创建空文件夹）​
8. 通过 Magisk 安装 NetHunter zip​
9. 使用内核管理器或 twrp 恢复的 刷入 NetHunter 内核​
10. 重新启动系统并运行 NetHunter 应用程序​
11. 从 NetHunter 商店更新 NetHunter 应用程序​

剧透：自定义 ROM

1. 将 twrp、magisk、NetHunter 内核和 NetHunter zip 复制到外部 USB-C 驱动器​
2. 闪存 TWRP​
3. 重新启动进入恢复，格式化数据并重新启动回到恢复
4. 安装 Magisk​
5. 重新启动系统，完成 Android 设置，启动 Magisk 应用程序并应用安装后要求​
6. 通过 Magisk 安装 NetHunter zip​
7. 使用内核管理器或 twrp 恢复的 刷入 NetHunter 内核​
8. 重新启动系统并运行 NetHunter 应用程序​
9. 从 NetHunter 商店更新 NetHunter 应用程序​

### 下载

- [A11 NetHunter Magisk 安装程序](https://www.androidfilehost.com/?fid=14655340768118441214)
- [A11 NetHunter 内核](https://www.androidfilehost.com/?fid=14655340768118441215)
- [A12 NetHunter Magisk 安装程序](https://www.androidfilehost.com/?fid=14655340768118441189)
- [A12 NetHunter 内核](https://www.androidfilehost.com/?fid=14655340768118441190)

### 已知问题

- 将内部 wlan0 切换到监控模式并返回到托管模式会使设备冻结约 15 秒（仅限 A11 内核）​
- `chown -R postgres:postgres /var/lib/postgresql/14/main`postgresql服务启动失败时运行

### 来源

官方源代码：  
[官方 NetHunter 项目](https://gitlab.com/kalilinux/nethunter/)  
OnePlus 8 系列源代码：  
[flyP@TR!0T/NetHunter 项目](https://gitlab.com/flypatriot/kali-nethunter-project)  
[FlyP@TR!0T/NetHunter 设备](https://gitlab.com/flypatriot/kali-nethunter-devices)  
内核源：  
[A11 内核](https://github.com/flypatriot/neutrino_kernel_oneplus_sm8250.git)  
[A12 内核](https://github.com/flypatriot/crdroid_12_kernel)  

