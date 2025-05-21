
 2024-07-17 https://blog.csdn.net/kalis_/article/details/140494199
 2024-09-01 https://blog.csdn.net/qq_41095608/article/details/141504335

#  准备工作
## 准备可以用的救砖包

## 搞机助手

## 9008驱动



# 开始刷机
## 氧12.1的系统升级包

## 刷入兼容的twrp
- 3.6.2_12-27082022
## 用twrp安装crDroid-12.1-20220728-kebab-v8.7.zip
- install
- Swipe to conflrm Flash
	- 安装期间不要让机器锁屏
	- 如果出现红色报错字体，需要格式化后重新安装
- 安装完成后，重启机器
	- 如果进入红色字体的恢复模式，选择“Factory data reset”格式化一下，再重启启动手机，出现不一样的开机动画即为成功
- 格式化方法：
	- 回到主页
	- Wipe
	- 勾选Dalvik / ART Cache 和 Data 目录
	- Swipe to Wipe
## 给crDroid打开root权限

### 教程和工具下载：https://magiskcn.com

#### 在镜像包中提取boot.img

- 在电脑上，打开镜像提取boot工具：“payload-dumper-go-64”
- 删除目录中的 img 目录和 payload.bin 文件，如果有的话
- 打开crDroid-12.1-20220728-kebab-v8.7.zip，将其中的 payload.bin 文件复制到 payload-dumper-go-64 目录中
- 打开“打开CMD命令行.bat”，选择 提取boot 的选项，目录中会生成 img 目录，其中就是要提取的boot.img

#### 给手机安装面具，然后刷入boot.img，获取root权限
- 教程：https://magiskcn.com
- 如果提示需要修复环境，点击安装


## 给手机安装EX内核管理app
- APP下载地址：https://wwp.lanzoup.com/iXU130whigba
- 内核下载地址：https://wwog.lanzouo.com/ip0sN0l60xcd

- 打开APP，获取root权限
- 将内核文件传到手机
- 拍照记录内核版本号，用于对比
- 刷写
- 内核备份
- 回到刷写中心
- 选择“刷入boot镜像、。。。。”
- 选择内核文件，点击刷写
- 成功后点击重启
- 核对版本号是否有变化
## 安装nethunter
- 在kali官方下载nethunter包
- 打开面具
- 模块
- 从本地安装
- 选择nethunter包
- 安装时间较长，完成后即可 使用



https://www.bilibili.com/opus/296919606092889626