#!/bin/bash

# 检查是否提供了IP地址作为参数
if [ $# -eq 0 ]; then
    echo "请提供要扫描的IP地址作为参数。"
    exit 1
fi

ip=$1

# 定义要尝试的nmap扫描选项
scan_options=(
    "-sS"  # TCP SYN扫描
    "-sT"  # TCP Connect扫描
    "-sF"  # FIN扫描
    "-sX"  # Xmas扫描
    "-sN"  # Null扫描
    "--data-length 128"  # 增加数据包长度
    "--scan-delay 2s"  # 增加扫描延迟
    "--scan-delay 5s"  # 增加扫描延迟
    "--scan-delay 10s"  # 增加扫描延迟
    "--badsum"  # 使用错误的校验和
    "-f"  # 分段数据包
    "--mtu 8"  # 指定最大传输单元
    "--mtu 16"  # 指定最大传输单元
    "--mtu 24"  # 指定最大传输单元
    "--mtu 32"  # 指定最大传输单元
    "--mtu 64"  # 指定最大传输单元
    "-D RND:10"  # 使用随机的诱饵IP
    "-S 192.168.1.100"  # 伪造源IP地址（需替换为合适的IP）
    "-S $ip"  # 伪造源IP地址
    "--source-port 53"  # 使用常用端口作为源端口
    "--proxies socks4://127.0.0.1:9050"  # 通过代理进行扫描（需配置好代理）
    "--spoof-mac 0"  # 伪造MAC地址
    "-n"  # 不进行DNS解析
    "--disable-arp-ping"  # 禁用ARP ping
    # 新增的扫描选项
    "--ttl 64"  # 设置IP数据包的TTL值
    "--ip-options LSR,192.168.1.100"  # 使用IP选项（需替换为合适的IP）
    "--send-eth"  # 强制使用以太网帧发送数据包
    "--send-ip"  # 强制使用原始IP数据包发送
    "--fuzzy"  # 随机化数据包内容
    "--defeat-rst-ratelimit"  # 尝试绕过RST速率限制
    "--version-intensity 0"  # 最低版本检测强度
    "--version-intensity 9"  # 最高版本检测强度
    "-sU"  # UDP扫描
    "--top-ports 100"  # 扫描前100个最常见的端口
    "--randomize-hosts"  # 随机化扫描的主机顺序
)

# 用于存储扫描结果的临时文件
temp_file="/tmp/nmap_scan_results.txt"

# 循环尝试不同的扫描选项
for option in "${scan_options[@]}"; do
    echo "正在使用扫描选项 $option 进行扫描..."
    nmap $option $ip -p- > $temp_file
    echo "扫描选项 $option 完成。"
    echo "------------------------"

    # 解析nmap输出，提取开放的端口信息
    open_ports=$(grep -E '^[0-9]+/tcp open|^[0-9]+/udp open' $temp_file | awk '{print $1}' | tr '\n' ',')
    open_ports=${open_ports%,}  # 移除最后一个逗号

    if [ -n "$open_ports" ]; then
        echo "扫描选项 $option 扫描到的端口: $open_ports"
    fi
done

# 删除临时文件
rm $temp_file