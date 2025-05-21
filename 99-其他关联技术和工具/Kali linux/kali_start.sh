#!/bin/bash

# 备份原始的源列表文件
cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 添加国内镜像源
echo "# 阿里云" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
echo "deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
echo "# 清华大学" >> /etc/apt/sources.list
echo "deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list


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
apt-get install -y openssh-server wget curl
apt-get install -y whois 
apt-get install -y nmap gobuster dirsearch dirb whatweb  ncat nikto ffuf fping netdiscover arp-scan arping masscan traceroute mtr hping3
 
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
# 下载fscan 6.1MB
mkdir -p ~/SecTools && wget https://github.com/shadow1ng/fscan/releases/download/2.0.0-build1/fscan -O ~/SecTools/fscan

#下载字典 665MB
apt install -y wordlists
wget https://github.com/danielmiessler/SecLists/archive/refs/tags/2024.4.zip -O /usr/share/wordlists/2024.4.zip
gzip -d /usr/share/wordlists/rockyou.txt.gz
unzip /usr/share/wordlists/2024.4.zip	# SecLists-2024.4
tree /usr/share/wordlists/*


# 重启系统
reboot