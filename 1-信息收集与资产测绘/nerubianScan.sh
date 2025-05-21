#!/bin/bash
#set -x

# 定义装饰宽度
DECOR_WIDTH=120

# 打印脚本标题
print_title() {
    echo '╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗'
    echo '║  ██████   █████                               █████      ███                        █████████                                ║'
    echo '║ ░░██████ ░░███                               ░░███      ░░░                        ███░░░░░███                               ║'
    echo '║  ░███░███ ░███   ██████  ████████  █████ ████ ░███████  ████   ██████   ████████  ░███    ░░░   ██████   ██████   ████████   ║'
    echo '║  ░███░░███░███  ███░░███░░███░░███░░███ ░███  ░███░░███░░███  ░░░░░███ ░░███░░███ ░░█████████  ███░░███ ░░░░░███ ░░███░░███  ║'
    echo '║  ░███ ░░██████ ░███████  ░███ ░░░  ░███ ░███  ░███ ░███ ░███   ███████  ░███ ░███  ░░░░░░░░███░███ ░░░   ███████  ░███ ░███  ║'
    echo '║  ░███  ░░█████ ░███░░░   ░███      ░███ ░███  ░███ ░███ ░███  ███░░███  ░███ ░███  ███    ░███░███  ███ ███░░███  ░███ ░███  ║'
    echo '║  █████  ░░█████░░██████  █████     ░░████████ ████████  █████░░████████ ████ █████░░█████████ ░░██████ ░░████████ ████ █████ ║'
    echo '║ ░░░░░    ░░░░░  ░░░░░░  ░░░░░       ░░░░░░░░ ░░░░░░░░  ░░░░░  ░░░░░░░░ ░░░░ ░░░░░  ░░░░░░░░░   ░░░░░░   ░░░░░░░░ ░░░░ ░░░░░  ║'
    echo '╠══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
}

# 权限检查
check_permissions() {
    if [ "$(id -u)" != "0" ]; then
        echo "---- 当前脚本没有以 sudo 执行, 请用sudo或root用户执行当前脚本  -----------------------------------------------------------------------"
	    echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
        exit 1
    else
        echo "----------------< 当前脚本以 sudo 执行 >------------------------------------------------------------------------------------------"
    fi
}

# 帮助信息
HELP_MESSAGE() {
    echo "---------------------< 帮助信息 >------------------------------------------------------------------------------------------------" 
    echo "# 使用方法1: kali初始化设置"
    echo "sudo sh NerubianScan.sh first"    
    echo "# 使用方法2: 渗透测试主动侦察"
    echo "sudo sh NerubianScan.sh <eth0> <target ip/netmask> <scan log dir>"
    echo "-- \$1: eth0"
    echo "-- \$2: target ip/netmask"
    echo "-- \$3: scan log dir"
	echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
}

# 检查是否为 IP 地址
is_ip() {
    ip=$1
    set -- $(echo "$ip" | tr '.' ' ')
    if [ $# -ne 4 ]; then
        return 1
    fi
    for part in "$@"; do
        if ! expr "$part" : '[0-9]\+$' > /dev/null || [ "$part" -lt 0 ] || [ "$part" -gt 255 ]; then
            return 1
        fi
    done
    return 0
}

# 检查是否为网段
is_network() {
    network=$1
    set -- $(echo "$network" | tr '/' ' ')
    if [ $# -ne 2 ]; then
        return 1
    fi
    ip="$1"
    mask="$2"
    if ! is_ip "$ip" || ! expr "$mask" : '[0-9]\+$' > /dev/null || [ "$mask" -lt 0 ] || [ "$mask" -gt 32 ]; then
        return 1
    fi
    return 0
}

# 检查是否为 CIDR 表示法
is_cidr() {
    if echo "$1" | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$'; then
        IFS='/' read -r ip prefix <<< "$1"
        IFS=. read -r i1 i2 i3 i4 <<< "$ip"
        if [[ $i1 -ge 0 && $i1 -le 255 && $i2 -ge 0 && $i2 -le 255 && $i3 -ge 0 && $i3 -le 255 && $i4 -ge 0 && $i4 -le 255 && $prefix -ge 0 && $prefix -le 32 ]]; then
            return 0
        fi
    fi
    return 1
}

# 检查是否为子网掩码表示法
is_subnet_mask() {
    if echo "$1" | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3} ([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
        IFS=' ' read -r ip mask <<< "$1"
        IFS=. read -r i1 i2 i3 i4 <<< "$ip"
        IFS=. read -r m1 m2 m3 m4 <<< "$mask"
        if [[ $i1 -ge 0 && $i1 -le 255 && $i2 -ge 0 && $i2 -le 255 && $i3 -ge 0 && $i3 -le 255 && $i4 -ge 0 && $i4 -le 255 &&
              $m1 -ge 0 && $m1 -le 255 && $m2 -ge 0 && $m2 -le 255 && $m3 -ge 0 && $m3 -le 255 && $m4 -ge 0 && $m4 -le 255 ]]; then
            return 0
        fi
    fi
    return 1
}

# 检查是否为范围表示法
is_range() {
    if echo "$1" | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3} - ([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
        IFS=' - ' read -r start end <<< "$1"
        IFS=. read -r s1 s2 s3 s4 <<< "$start"
        IFS=. read -r e1 e2 e3 e4 <<< "$end"
        if [[ $s1 -ge 0 && $s1 -le 255 && $s2 -ge 0 && $s2 -le 255 && $s3 -ge 0 && $s3 -le 255 && $s4 -ge 0 && $s4 -le 255 &&
              $e1 -ge 0 && $e1 -le 255 && $e2 -ge 0 && $e2 -le 255 && $e3 -ge 0 && $e3 -le 255 && $e4 -ge 0 && $e4 -le 255 ]]; then
            return 0
        fi
    fi
    return 1
}

# 主函数
main() {
    print_title
    check_permissions

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "" ]; then
        HELP_MESSAGE
        exit 0
    elif [ "$1" = "first" ]; then
        # 修改镜像源
        echo "---------------------< 修改镜像源 >----------------------------------------------------------------------------------------------"
		
        KALI_ORG_NU=$(grep -v "kali.org" /etc/apt/sources.list|grep -c ^deb)
        if [ "$KALI_ORG_NU" -eq 0 ]; then
            cat << EOF > /etc/apt/sources.list
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
EOF
            echo "----------------< /etc/apt/sources.list 已更新 >---------------------------------------------------------------------------------"
        fi

        # 镜像源外网测试
        echo "---------------------< 镜像源外网测试 >-------------------------------------------------------------------------------------------"
        if ! apt -y install vim > /dev/null 2>&1 ; then
            echo "----------------< 镜像源网络异常，请修复网络后重试 >---------------------------------------------------------------------------------"
            exit 1
        fi

        # 安装必备工具【离线】
        echo "---------------------< 安装必备工具 >---------------------------------------------------------------------------------------------"
        tools=("gobuster" "enum4linux" "whatweb" "wpscan" "nmap" "showmount" "medusa" "smtp-user-enum" "smbclient" "smbmap" "nikto" "dirsearch" "ipcalc" "brutespray" "medusa")
        for tool in "${tools[@]}"; do
            echo "正在安装 $tool ..."
            if apt install -y $tool > /dev/null 2>&1; then
                echo "# $tool 安装成功 "
            else
                echo "# $tool 安装失败 "
            fi
        done

        # 字典安装与解压
        echo "---------------------< 字典安装与解压 >-------------------------------------------------------------------------------------------"
        if [ -e "/usr/share/wordlists/rockyou.txt.gz" ]; then
            [ -e "/usr/share/wordlists/rockyou.txt" ] || gunzip -k /usr/share/wordlists/rockyou.txt.gz  # -k 保留原压缩文件
            echo "# rockyou.txt 已解压"
        fi
        echo "正在安装 seclists ..."
        apt install seclists -y
        echo "# seclists 安装完成"

        echo "# Kali Linux first setup execution completed"
		echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
        exit 0
    fi

    if is_ip "$2"; then
        echo "# \$2输入的是有效的IP地址"
    elif is_network "$2"; then
        echo "# \$2输入的是有效的网段"
    else
        echo "# 没有扫描到合法的IP地址或网段参数，请检查修正后重试"
        echo "# \$2:$2"
        HELP_MESSAGE
        exit 1
    fi

    if is_cidr "$2" || is_subnet_mask "$2" || is_range "$2"; then
        echo "# \$2参数是合法的 IPv4 网段表示法:$2"
        ip_local=$(ip a |grep "$(echo "$2" | awk -F'.' '{print $1"."$2"."$3}')"| awk '{print $2}'| awk -F/ '{print $1}')
        echo "----------------< \$2合法,开始主机发现 >-------------------------------------------------------------------------------------------"
        while true
        do
            echo "fping -agq $2"
            nmap_result=$(fping -agq "$2")
            echo "$nmap_result" > .ip_list.txt
            ip_list_wc=$(wc -l .ip_list.txt|awk '{print $1}')
            if [ "$ip_list_wc" -eq 0 ]; then
                echo "ERROR! 没有扫描到合法IP地址，退出"
                echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
                exit 2
            fi
            echo "当前网卡$1对应的IP为: $ip_local"
            echo " PS：输入任意字母将重新执行IP扫描, 输入其他字符将导致脚本错误"    
            echo " 序号   IP地址"
            echo "     0    退出当前脚本"
            cat -n .ip_list.txt
            read -rp "║ 请输入序号: " selected_index
            if [[ "$selected_index" =~ [a-zA-Z] ]]; then
                echo "ERROR! 你输入的值[$selected_index]包含字母，将重新执行IP扫描"
                echo '-------------------------------------------------------------------------------------------------------------------------------'
            elif [ "$selected_index" -eq 0 ]; then
                echo "EXIT! 你输入的值为 0 ,退出脚本"
                echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
                exit 1
            elif ! [[ "$selected_index" =~ ^[0-9]+$ ]]; then
                echo "ERROR! 你输入的值[$selected_index]不是整数，请重新输入。"
                echo '-------------------------------------------------------------------------------------------------------------------------------'   
            elif [ "$selected_index" -gt "$ip_list_wc" ] || [ "$selected_index" -lt "1" ];then
                echo "ERROR! 你输入的值[$selected_index]不是一个介于 1 至 $ip_list_wc 之间的整数，请重新输入。"
                echo '-------------------------------------------------------------------------------------------------------------------------------'
            else
                selected_ip=$(head -n "$selected_index" .ip_list.txt | tail -n 1)
                if [ "$selected_ip" = "$ip_local" ]; then
                    echo "你选择的IP是：$selected_ip 是本机IP，请重新选择"
                else
                    echo "你选择的IP是：$selected_ip ，开始执行扫描指令"
                    break
                fi
            fi
        done
    else
        selected_ip="$2"
        ip_local=$(ip a |grep "$(echo "$selected_ip" | awk -F'.' '{print $1"."$2"."$3}')"| awk '{print $2}'| awk -F/ '{print $1}')
        if [ "$selected_ip" = "$ip_local" ]; then
            echo "你输入的IP是：$selected_ip 是本机IP，请重新输入合法的目标IP。"
            exit 1
        fi
        echo "你输入的IP是：$selected_ip ，开始执行扫描指令"
    fi

    echo "----------------< 创建存储目录 >--------------------------------------------------------------------------------------------------"
    rm -rf "$3"
    echo "执行命令: su kali -c \"mkdir -p $3\""
    if ! su kali -c "mkdir -p $3"; then
        echo "ERROR! 无法创建存储目录 $3"
        echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
        exit 1
    fi
    echo "存储目录内容:"
    while IFS= read -r line; do
        echo "    $line"
    done < <(ls "$3")
    echo "# \$3:$3"


    echo "---------------------< IP 可达性测试 >--------------------------------------------------------------------------------------------"
    echo "执行命令: ping -c 1 $selected_ip"
    if ping -c 1 "$selected_ip" > /dev/null 2>&1; then
        echo "# OK！IP 可达"
    else
        echo "# ERROR! IP 不可达"
        echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
        exit 1
    fi
    # 二、nmap扫描
    echo '═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════'
    echo "---------------------< nmap 端口扫描 >-------------------------------------------------------------------------------------------"
    # NO.1
    echo "---------------------< nmap 第1次扫描 >------------------------------------------------------------------------------------------"
    echo "执行命令: nmap -sS -sV --min-rate 5000 -p 0-65535 $selected_ip -oN $3/nmapscan_1_ports"
    nmap -sS -Pn --min-rate 5000 -p 0-65535 "$selected_ip" -o"N" "$3"/nmapscan_1_ports
    NmapPorts=$(grep open "$3"/nmapscan_1_ports*|awk -F'/' '{print $1}'|paste -sd ',')

    # NO.2
    echo "---------------------< nmap 第2次扫描 >------------------------------------------------------------------------------------------"
    echo "执行命令: nmap -sS -sV -sC -O -Pn --min-rate 5000 --script=vuln -p $NmapPorts $selected_ip -o N $3/nmapscan_2_detail"
    nmap -sS -sV -sC -O -Pn --min-rate 5000 --script=vuln -p $NmapPorts $selected_ip -oN $3/nmapscan_2_detail

    # NO.3
    echo "---------------------< nmap 第3次扫描 >------------------------------------------------------------------------------------------"
    echo "执行命令: nmap -sU --top-ports 20  $selected_ip -oN $3/nmapscan_3_udp"
    nmap -sU --top-ports 20 -Pn "$selected_ip" -o"N" "$3"/nmapscan_3_udp

    # NO.4
    echo "---------------------< nmap 第4次扫描 >------------------------------------------------------------------------------------------"
    echo "执行命令: nmap -v -p $NmapPorts $selected_ip -oX $3/nmapscan_4_service.xml"
    nmap -v -p $NmapPorts $selected_ip -oX $3/nmapscan_4_service.xml

    # web服务测试
    echo "---------------------< 提取 web 服务的开放端口 >----------------------------------------------------------------------------------"
    if [ -f "$3/nmapscan_2_detail" ]; then
        grep open "$3"/nmapscan_2_detail|grep '/tcp'|grep -i "http"|grep -v Warning|awk '{print $1}'|awk -F/ '{print $1}' > "$3"/.http_port.txt
        if [ `wc -l "$3"/.http_port.txt|awk '{print $1}'` -eq 0 ]; then
            echo "Error: nmapscan_2_detail file not found in $3"
        else
            while read -r port; do
                if [ -n "$port" ]; then
                    # 技术栈扫描
                    echo "-------------< Web 技术栈扫描 (端口 $port) >--------------------------------------------------------------------------------------"
                    echo "执行命令: whatweb \"http://$selected_ip:$port\" --log-verbose=\"$3/whatweb_${port}.log\""
                    whatweb "http://$selected_ip:$port" --log-verbose="$3/whatweb_${port}.log"
                    
                    # 漏洞扫描
                    echo "-------------< Web Nikto 扫描 (端口 $port) >-------------------------------------------------------------------------------------"
                    echo "执行命令: nikto -h \"http://$selected_ip:$port\" -output \"$3/nikto_${port}.txt\""
                    nikto -h "http://$selected_ip:$port" -output "$3/nikto_${port}.txt"
                    
                    # 目录扫描（示例，可根据需要调整后缀）
                    echo "----------------< Web 目录扫描 (端口 $port) >-------------------------------------------------------------------------------------"
                    echo "执行命令: feroxbuster -u \"http://$selected_ip:$port\" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -s 200,301,302 -x php,html -o \"$3/feroxbuster_out_${port}.log\""
                    feroxbuster -u "http://$selected_ip:$port" \
                        -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt \
                        -s 200,301,302 \
                        -x php,html \
                        -o "$3/feroxbuster_out_${port}.log"
                fi
            done < "$3"/.http_port.txt        
        fi
    else
        echo "Error: nmapscan_2_detail file not found in $3"
    fi

    # 自动判断可爆破服务并进行爆破
    username_list="/usr/share/seclists/Usernames/top-usernames-shortlist.txt"
    password_list="/usr/share/metasploit-framework/data/wordlists/piata_ssh_userpass.txt"	
    echo "---------------------< 使用 brutespray 弱密码检测服务 >--------------------------------------------------------------------------"
    echo "执行命令: brutespray -f "$3/nmapscan_4_service.xml"  -u "$username_list" -p "$password_list" -o "$3/brutespray_$selected_ip.log""
    brutespray -f "$3/nmapscan_4_service.xml"  -u "$username_list" -p "$password_list" -o "$3/brutespray_$selected_ip.log" &

    echo '╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝'
}

main "$@"