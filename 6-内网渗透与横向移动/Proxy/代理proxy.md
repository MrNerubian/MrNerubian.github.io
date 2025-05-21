## proxytunnel

proxytunnel是一款利用http connection封装技术建立隧道的工具

使用条件：

- 防火墙禁止DNS和ICMP隧道，只允许代理服务器上网的情景

常用命令：
```
-a 指定本地侦听端口 
-p 使用代理 
-r 使用第二个代理 
-d 指定访问的目标和端口
```
使用方法
```
proxytunnel -p 192.168.56.101:3128 -d 127.0.0.1:22 -a 6666

ssh john@127.0.0.1 -p 6666
```

## proxychains

1、配置proxychains 的代理配置

vi /etc/proxychains4.conf
在最下面添加一行：http   目标靶机ip  3128
【注意：间隔符合要使用tab，不能用空格，否则会无法识别】
```
echo 'http 192.168.56.101 3128' >> /etc/proxychains4.conf
```

使用代理登录目标主机
```
proxychains ssh john@192.168.65.101
```

## squid

在 CentOS 7 上部署 Squid 代理并配置用户名密码的步骤：

1. **安装 Squid**：
   `yum -y install squid httpd-tools`

2. **配置 Squid**：

`vim /etc/squid/squid.conf`，添加或修改以下配置项：

   ```
   auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd
   auth_param basic children 5
   auth_param basic realm Squid proxy authentication
   auth_param basic credentialsttl 2 hours
   require valid-user
   ```

   其中，`/etc/squid/passwd` 是存储用户名和密码的文件。

3. **创建用户名密码文件**：

   使用 `htpasswd` 命令创建包含用户名和密码的文件，例如：

   `htpasswd -c /etc/squid/passwd username`

4. **启动 Squid**：

   `systemctl start squid`

5. **设置开机启动**：

   `systemctl enable squid`


## SwitchyOmega 浏览器插件

Github 项目地址为：[https://github.com/FelisCatus/SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega)  
官网下载地址：[https://github.com/FelisCatus/SwitchyOmega/releases](https://github.com/FelisCatus/SwitchyOmega/releases)
>注意，新手使用建议下载稳定版本，即版本号后标记为 Latest 的版本。

https://www.cnblogs.com/yoyoketang/p/18033578


## V2Ray

V2Ray 是一个非常灵活和强大的代理工具，支持多种协议和多级代理配置。以下是 V2Ray 的详细部署方法，包括安装、配置和启动步骤。

### 部署 V2Ray

#### 1. 安装 V2Ray

**步骤：**

1. **下载并安装 V2Ray**：
   - 使用官方提供的安装脚本可以快速安装 V2Ray。在 Linux 系统上运行以下命令：
     ```bash
     bash <(curl -L -s https://install.direct/go.sh)
     ```

2. **验证安装**：
   - 安装完成后，验证 V2Ray 是否正确安装：
     ```bash
     /usr/bin/v2ray/v2ray -version
     ```

#### 2. 配置 V2Ray

**步骤：**

1. **编辑配置文件**：
   - V2Ray 的配置文件通常位于 `/etc/v2ray/config.json`。可以使用文本编辑器（如 `vi` 或 `vim`）编辑该文件：
     ```bash
     sudo vim /etc/v2ray/config.json
     ```

2. **配置示例**：
   - 以下是一个基本的 V2Ray 配置文件示例，配置了一个 VMess 入站协议和一个出站协议：
     ```json
     {
       "inbounds": [{
         "port": 1080,
         "listen": "127.0.0.1",
         "protocol": "socks",
         "settings": {
           "auth": "noauth",
           "udp": false,
           "ip": "127.0.0.1"
         }
       }],
       "outbounds": [{
         "protocol": "vmess",
         "settings": {
           "vnext": [{
             "address": "your_server_address",
             "port": your_server_port,
             "users": [{
               "id": "your_uuid",
               "alterId": 64
             }]
           }]
         }
       }]
     }
     ```

   - 其中：
     - `your_server_address`：V2Ray 服务器的 IP 地址或域名。
     - `your_server_port`：V2Ray 服务器的端口。
     - `your_uuid`：为用户生成的 UUID，可以使用 `uuidgen` 命令生成。

3. **生成 UUID**：
   - 可以使用 `uuidgen` 命令生成一个新的 UUID：
     ```bash
     uuidgen
     ```

#### 3. 启动和管理 V2Ray

**步骤：**

1. **启动 V2Ray 服务**：
   - 启动 V2Ray 服务：
     ```bash
     sudo systemctl start v2ray
     ```

2. **设置 V2Ray 开机自启**：
   - 设置 V2Ray 服务在系统启动时自动启动：
     ```bash
     sudo systemctl enable v2ray
     ```

3. **检查 V2Ray 服务状态**：
   - 查看 V2Ray 服务的运行状态：
     ```bash
     sudo systemctl status v2ray
     ```

#### 4. 防火墙配置

**步骤：**

1. **允许 V2Ray 端口通过防火墙**：
   - 确保防火墙允许 V2Ray 使用的端口。以 UFW 为例，假设 V2Ray 使用 1080 端口：
     ```bash
     sudo ufw allow 1080/tcp
     sudo ufw allow 1080/udp
     ```

2. **重新加载防火墙规则**：
   - 重新加载防火墙规则以应用更改：
     ```bash
     sudo ufw reload
     ```

### 客户端配置

为了使用 V2Ray 代理服务器，需要在客户端配置相应的代理设置。以下是一些常用的客户端工具：

1. **V2RayN** (Windows)
2. **V2RayX** (macOS)
3. **V2RayNG** (Android)
4. **Shadowrocket** (iOS)

**配置示例**（以 V2RayN 为例）：

1. **下载并安装 V2RayN**：
   - 从 [V2RayN 的 GitHub 页面](https://github.com/2dust/v2rayN) 下载并安装。

2. **添加服务器**：
   - 打开 V2RayN，点击“服务器” -> “添加 [VMess] 服务器”。
   - 输入服务器地址、端口、UUID 和其他相关信息。

3. **启动代理**：
   - 选择刚刚添加的服务器，点击“启动”按钮。

### 总结

通过以上步骤，你可以成功部署和配置 V2Ray 代理服务器，并在客户端上进行相应配置以使用该代理服务。V2Ray 提供了灵活的配置选项，可以根据需要进行调整和优化。如果你有任何其他问题或需要更详细的指导，请随时提问。