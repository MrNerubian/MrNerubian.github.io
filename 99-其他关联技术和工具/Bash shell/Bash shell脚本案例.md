
## 1、在脚本中实现进度条
在脚本中实现进度条的效果，通常有几种方法。以下是一些在 Bash 脚本中实现进度条的基本方法： 
1.使用 `echo` 和 `sleep` 命令模拟： 
```bash 
echo -n '正在下载: ' 
for i in {1..100}; 
do 
	echo -ne "$i%"'\\r' 
	sleep 0.1 # 等待0.1秒
done 
echo '完成' 
``` 
2.使用 `tput` 控制光标，并用循环来更新进度信息： 
```bash 
total=100 
for i in $(seq 1 $total); 
do 
	percent=$((i * 100 / total)) 
	# 移动光标到行首（回车），不换行输出进度信息 
	printf "\\r[%-100s] %d%%" $(printf "%-${i}s" '#') $percent
	sleep 0.1 
done 
echo -e "\ 完成" 
``` 
3.使用 `pv` 命令（Pipe Viewer），它是一个终端下的工具，可以通过管道显示数据传输的进度： 
```bash 
# 假设有一个文件需要下载，使用pv来展示进度 
curl -s https://example.com/bigfile.tar.gz | pv -s $(curl -sI https://example.com/bigfile.tar.gz | grep -i Content-Length | awk '{print $2}') | tar xzf - 
``` 
4.使用 `dialog` 或 `whiptail` 命令创建一个图形化的进度条。



## 2、将多个目录的权限信息统计并进行比对的Shell脚本

```bash
#!/bin/bash

# 彩色输出定义
RED='\033[31m'; GREEN='\033[32m'; YELLOW='\033[33m'; BLUE='\033[34m'; RESET='\033[0m'
LOG_DIR="/var/log/docker_check"
LOG_FILE="${LOG_DIR}/check_$(date +%Y%m%d%H%M%S).log"

# 初始化日志目录
mkdir -p "$LOG_DIR" && touch "$LOG_FILE"

# 交互式容器选择（支持多选）
select_containers() {
    echo -e "${BLUE}正在运行的容器列表：${RESET}" | tee -a "$LOG_FILE"
    mapfile -t containers < <(docker ps --format '{{.ID}}\t{{.Names}}')
    
    # 显示带序号的容器列表
    printf "%4s  %-15s %s\n" "序号" "容器ID" "容器名称" | tee -a "$LOG_FILE"
    for i in "${!containers[@]}"; do
        IFS=$'\t' read -r id name <<< "${containers[$i]}"
        printf "%4d) %-15s %s\n" $((i+1)) "$id" "$name" | tee -a "$LOG_FILE"
    done

    # 处理输入参数
    if [[ "$1" == "all" ]]; then
        selected=("${containers[@]}")
    else
        read -p $'\n请输入序号/ID/名称（多个用逗号分隔）: ' input
        IFS=',' read -ra selections <<< "$input"
        
        for sel in "${selections[@]}"; do
            if [[ "$sel" =~ ^[0-9]+$ ]]; then
                index=$((sel-1))
                [[ -n "${containers[$index]}" ]] && selected+=("${containers[$index]}")
            else
                matched=$(docker ps -q --filter="id=$sel" --filter="name=$sel")
                [[ -n "$matched" ]] && selected+=("$matched")
            fi
        done
    fi

    # 去重处理
    seen=()
    for container in "${selected[@]}"; do
        if [[ ! " ${seen[@]} " =~ " $container " ]]; then
            seen+=("$container")
            IFS=$'\t' read -r id name <<< "$container"
            container_ids+=("$id")
        fi
    done
}

# 主流程
if [[ "$1" == "all" ]]; then
    container_ids=($(docker ps -q))
else
    select_containers "$1"
fi

for container_id in "${container_ids[@]}"; do
    {
        echo -e "\n${BLUE}正在检查容器：${GREEN}$(docker inspect --format '{{.Name}}' "$container_id")${RESET}" | tee -a "$LOG_FILE"
        get_process_user "$container_id" | tee -a "$LOG_FILE"
        check_volume_permission "$container_id" | tee -a "$LOG_FILE"
    } 
done

echo -e "\n检测日志已保存至：${YELLOW}$LOG_FILE${RESET}"
```



**操作示例**：
```bash
# 检查单个容器
$ ./check_docker_permissions.sh

# 检查多个容器
$ ./check_docker_permissions.sh 1,3,nginx

# 检查所有容器
$ ./check_docker_permissions.sh all
```

**输出效果**：
```
正在运行的容器列表：
 序号  容器ID          容器名称
   1) 3bd36c961a9c     nginx
   2) a1b2c3d4e5f6     mysql

请输入序号/ID/名称（多个用逗号分隔）: 1,nginx

正在检查容器：/nginx
[进程用户检测]
用户: root PID: 1234 命令: nginx
容器内用户: uid=0(root) gid=0(root)

[持久化目录检测]
  [映射1]
  ├─ 宿主机路径: /opt/cloud/Web
  ├─ 容器内路径: /app/data
  └─ 访问状态: 可写入

检测日志已保存至：/var/log/docker_check/check_202302191430.log
```

