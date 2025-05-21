## Port Knocking

端口敲门：knock ip port1 port2 port3.

### 安装一下
```sh
sudo apt install -y knockd
```
### 配置 knockd 服务
```
cat /etc/knockd.conf
[options]
    UseSyslog
[openSSH]
    sequence    = 7000,8000,9000
    seq_timeout = 5
    command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
    tcpflags    = syn
[closeSSH]
    sequence    = 9000,8000,7000
    seq_timeout = 5
    command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
    tcpflags    = syn


配置文件里有两个参数:
	sequence 按照顺序依次访问端口，command执行的条件。默认使用TCP访问。
	command 当knockd监测到sequence端口访问完成，然后执行此处command，这里为通过iptables开启关闭ssh外部访问。

```

### knock碰撞
```sh
┌──(nerubian㉿kali)-[~/vulnhub]
└─$ sudo knock 192.168.56.104 10000 4444 65535

┌──(nerubian㉿kali)-[~/vulnhub]
└─$ knock -h
usage: knock [options] <host> <port[:proto]> [port[:proto]] ...
options:
  -u, --udp            make all ports hits use UDP (default is TCP)
  -d, --delay <t>      wait <t> milliseconds between port hits
  -4, --ipv4           Force usage of IPv4
  -6, --ipv6           Force usage of IPv6
  -v, --verbose        be verbose
  -V, --version        display version
  -h, --help           this help

example:  knock myserver.example.com 123:tcp 456:udp 789:tcp
```
### 手工循环碰撞

```
for x in  7000 8000 9000;do;nmap -Pn --host_timeout 201 --max-retries 0 -p $x  <target IP>;done
```

### bash碰撞脚本
```
#!/bin/bash

# 定义要进行 port knocking 的目标主机
target_host="your_target_host"

# 定义要进行 port knocking 的目标端口
target_ports=(4444:udp 8331:tcp 7331:tcp 31337:tcp 31338:tcp)

# 逐个测试端口组合
for ports in $(eval echo "{${target_ports[*]}}")
do
    IFS=':' read -r port protocol <<< "$ports"
    echo "Knocking port $port using protocol $protocol"
    nc -z -w 1 $target_host $port
done
```

### python碰撞脚本
```
pip install python-nmap
```
```
import itertools
import nmap

# 定义要进行 port knocking 的目标主机
target_host = "your_target_host"

# 定义要进行 port knocking 的目标端口
target_ports = [(4444, 'udp'), (8331, 'tcp'), (7331, 'tcp'), (31337, 'tcp'), (31338, 'tcp')]

# 生成所有可能的端口顺序组合
possible_port_combinations = list(itertools.permutations(target_ports))

# 初始化 nmap 扫描器
nm = nmap.PortScanner()

# 逐个测试端口组合
for ports in possible_port_combinations:
    print("Testing port knocking sequence:", ports)

    # 构建要扫描的端口字符串
    port_string = ','.join(str(port[0]) for port in ports)
    scan_results = nm.scan(target_host, arguments=f"-p{port_string}")

    # 检查端口是否处于打开状态
    open_ports = [f"{port[0]} ({port[1]})" for port in ports if str(port[0]) in nm[target_host]['tcp']]

    # 如果找到了正确的 knocking 顺序
    if len(open_ports) == 5:
        print("Port knocking successful! Open ports:", open_ports)
        break
```
