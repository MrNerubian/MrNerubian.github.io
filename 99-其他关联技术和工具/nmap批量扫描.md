

如果你想使用Nmap扫描多个IP地址范围，并且每个范围都有自己的端口列表，你可以创建一个文本文件，每个IP地址范围占用一行，每行后面跟上端口号列表。然后，你可以使用`-iL`选项来指定这个文件，Nmap会逐行读取并扫描每个IP地址范围的指定端口。
以下是一个步骤示例：
1. 创建一个名为`ip_ranges_with_ports.txt`的文件，内容如下：
```
192.168.1.1/24,80,443
192.168.2.1/24,21,22,80
10.0.0.1/8,111,53,80
```
在这个文件中，每个IP地址范围后面跟着逗号分隔的端口号列表。
2. 使用Nmap扫描指定在`ip_ranges_with_ports.txt`文件中的IP地址范围和端口：
```bash
nmap -p @ip_ranges_with_ports.txt
```
在这个例子中，`@ip_ranges_with_ports.txt`表示Nmap会读取`ip_ranges_with_ports.txt`文件，并扫描文件中每一行指定的IP地址范围的指定端口。
请注意，Nmap的这种用法比较特殊，因为通常Nmap是用来扫描单个IP地址的所有端口，或者扫描多个IP地址的所有端口。如果你需要扫描多个IP地址范围，并且每个范围都有自己的端口列表，你可能需要编写一个脚本来处理这个需求。
此外，确保你在进行网络扫描时具有相应的权限，并且你的行为符合当地的法律法规和道德标准。未经授权的网络扫描可能被视为非法行为。
# 1、bash

```bash
#!/bin/bash

#nmap 批量扫描脚本，ip文件兼容以下格式
# 192.168.56.187
# 192.168.56.187    8989
# 192.168.56.187    8989,8999
# 192.168.56.187-188
# 192.168.56.187-188    8989
# 192.168.56.187-188    8989,8999
# 192.168.56.187-192.168.56.188
# 192.168.56.187-192.168.56.188    8989
# 192.168.56.187-192.168.56.188    8989,8999
#兼容中文逗号、分号、空行等异常格式的处理

#set -x

# 确保以root权限执行脚本
if [ "$EUID" -ne 0 ]; then
    echo "请以root用户或使用sudo执行此脚本！"
    exit 1
fi

# 检查$1参数是否被提供
if [ -z "$1" ]; then
    echo "Error: IP文件未提供"
    echo "Usage: sudo bash $0 <ip&port file name> <out log file name>"
    exit 1
fi

# 检查文件是否存在并且是一个普通文件
if [ ! -f "$1" ]; then
    echo "Error: $1 不是一个文件"
    exit 1
else
    # 清洗IP文件中的数据
    sed -i '/^$/d; s/  \+/ /g; s/\t/ /g; s/, /,/g; s/[,，、;；]/,/g' "$1"
fi

# 检查$2参数是否被提供
if [ -z "$2" ]; then
	# 定义输出文件名
	OUTPUT_FILE="nmap_batch_scan.log"		
else
	# 定义输出文件名
	OUTPUT_FILE=$2
fi

# 强制清空或生成输出文件
echo '' > "$OUTPUT_FILE"
echo '' > /tmp/.nmap_scans.txt

# Nmap扫描参数变量
NmapOptions="-sT --min-rate 10000"  # 普通端口扫描

# 扫描IP地址和端口
echo "nmap scan execution begins"
while read -r line; do
    IP=$(echo ${line} | awk '{print $1}')
    PORT=$(echo ${line} | awk '{print $2}')
    #判断IP是否为批量写法，为真测执行循环，逐一扫描，非真则正常扫描
    if echo "$IP" | grep -q "\-"; then
        IP_123=$(echo "$IP" | awk -F '-' '{print $1}' | awk -F. '{print $1"."$2"."$3}')
        IPStart=$(echo "$IP" | awk -F '-' '{print $1}' | awk -F. '{print $4}')
        IPEnd=$(echo "$IP" | awk -F '-' '{print $NF}' | awk -F. '{print $NF}')
        for ((i=${IPStart}; i<=${IPEnd}; i++)); do
            #判断是否为空号列为空，为真测执行全端口扫描，非真则正常扫描
            if [ -z "$PORT" ]; then
                PORT=$(nmap ${NmapOptions} ${IP_123}.${i} -p- -oN /tmp/.nmap_scans.txt|grep "/tcp"| awk -F/ '{print $1}' | paste -sd ',')
                STATUS=$(grep "/tcp" /tmp/.nmap_scans.txt| awk '{print $1":"$2}' | paste -sd '\t' | sed 's/\/tcp//g')
                #判断扫描结果中包含/tcp的行是否为空，为真与非真输出各自的日志
                if [ -z "$PORT" ]; then
                    echo -e "${IP_123}.${i}\tAll 65535 scanned ports on $IP_123 are filtered" >> "$OUTPUT_FILE"
                else
                    echo -e "${IP_123}.${i}\t$PORT\t$STATUS" >> "$OUTPUT_FILE"
                fi
                > /tmp/.nmap_scans.txt
            else
                STATUS=$(nmap ${NmapOptions} ${IP_123}.${i} -p ${PORT} |grep "/tcp"|awk '{print $1":"$2}'|paste -sd '\t'|sed 's/\/tcp//g')
                echo -e "${IP_123}.${i}\t$PORT\t$STATUS" >> "$OUTPUT_FILE"
            fi
        done
    else
        #判断是否为空号列为空，为真测执行全端口扫描，非真则正常扫描
        if [ -z "$PORT" ]; then
                PORT=$(nmap ${NmapOptions} $IP -p- -oN /tmp/.nmap_scans.txt|grep "/tcp"| awk -F"/" '{print $1}'|paste -sd ',')
                STATUS=$(grep "/tcp" /tmp/.nmap_scans.txt| awk '{print $1":"$2}' | paste -sd '\t' | sed 's/\/tcp//g')
                #判断扫描结果中包含/tcp的行是否为空，为真与非真输出各自的日志
                if [ -z "$PORT" ]; then
                    echo -e "${IP}\tAll 65535 scanned ports on $IP are filtered" >> "$OUTPUT_FILE"
                else
                    echo -e "${IP}\t$PORT\t$STATUS" >> "$OUTPUT_FILE"
                fi
                > /tmp/.nmap_scans.txt
        else
            STATUS=$(nmap ${NmapOptions} $IP -p ${PORT}| grep "/tcp" | awk '{print $1":"$2}' | paste -sd '\t' | sed 's/\/tcp//g')
            echo -e "$IP\t$PORT\t$STATUS" >> "$OUTPUT_FILE"
        fi
    fi
done < "$1"

# 使用  trap 捕获信号： 使用 trap 命令捕获退出信号，确保在脚本被中断时能够正确处理
trap 'rm -f /tmp/.nmap_scans.txt; echo "Execution interrupted."; exit 1' INT TERM

echo "Execution completed"
echo "Scan log: $OUTPUT_FILE"
echo
cat "$OUTPUT_FILE"
echo 
```

# 2、python

使用 Python 2.7 运行脚本，例如：python2.7 nmap_batch_scan.py ip.list nmap_output.log

```python
#!/usr/bin/env python2.7

import subprocess
import re
import sys

def scan_ip(ip_file, output_file):
    # 清洗IP文件中的数据
    with open(ip_file, 'r') as f:
        lines = [line.strip() for line in f if line.strip()]
    
    # 初始化输出文件
    with open(output_file, 'w') as outf:
        outf.write("IP\tPORT\tSTATUS\n")

    # 遍历IP地址
    for line in lines:
        # 解析IP和端口
        ip, ports = line.split(' ', 1)
        ports = ports.split(',')

        # 处理IP为批量写法的情况
        if '-' in ip:
            ip_start, ip_end = ip.split('-')
            for ip_index in range(int(ip_start), int(ip_end) + 1):
                ip_to_scan = "{:03d}.{}".format(ip_index, ip)
                try:
                    # 执行Nmap扫描并获取端口状态
                    nmap_output = subprocess.check_output(["nmap", "-sT", "--min-rate", "10000", ip_to_scan])
                    # 解析Nmap输出
                    open_ports = re.findall(r'\d+/tcp', nmap_output)
                    if not open_ports:
                        outf.write("{}\tAll 65535 scanned ports on {} are filtered\n".format(ip_to_scan, ip_to_scan))
                    else:
                        outf.write("{}\t{}\n".format(ip_to_scan, ','.join(open_ports)))
                except subprocess.CalledProcessError as e:
                    # 打印错误信息
                    print("Error scanning {}: {}".format(ip_to_scan, e.output))
        else:
            try:
                # 执行Nmap扫描并获取端口状态
                nmap_output = subprocess.check_output(["nmap", "-sT", "--min-rate", "10000", ip])
                open_ports = re.findall(r'\d+/tcp', nmap_output)
                if not open_ports:
                    outf.write("{}\tAll 65535 scanned ports on {} are filtered\n".format(ip, ip))
                else:
                    outf.write("{}\t{}\n".format(ip, ','.join(open_ports)))
            except subprocess.CalledProcessError as e:
                # 打印错误信息
                print("Error scanning {}: {}".format(ip, e.output))

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python2.7 {} <ip_file> <output_file>".format(sys.argv[0]))
        sys.exit(1)

    ip_file, output_file = sys.argv[1], sys.argv[2]
    scan_ip(ip_file, output_file)

```

