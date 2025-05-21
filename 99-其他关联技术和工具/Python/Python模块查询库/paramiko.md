## 第三方库之paramiko

paramiko库支持以加密和认证的方式连接远程服务器。可以实现远程文件的上传,下载或通过**==ssh==**远程执行命令。

**PS:** 后面课程学习的配置自动化工具ansible底层就是使用paramiko库。

### paramiko库安装

python使用paramiko库来实现远程ssh操作(或者使用pycharm图形安装方式)

```shell
# pip3.6 install paramiko
```



### paramiko库远程上传下载文件

**示例: paramiko库实现文件的上传下载(要传密码的做法)**

```python
import paramiko								# 导入import库

trans = paramiko.Transport(("10.1.1.12",22))	# 产生连接10.1.1.12的22的传输,赋值给trans

trans.connect(username="root",password="123456") # 指定连接用户名与密码

sftp = paramiko.SFTPClient.from_transport(trans) # 指定为sftp传输方式

sftp.get("/etc/fstab","/tmp/fstab")	    # 把对方机器的/etc/fstab下载到本地为/tmp/fstab(注意不能只写/tmp,必须要命名)
sftp.put("/etc/inittab","/tmp/inittab") # 本地的上传,也一样要命令

trans.close()
```

**问题:**

因为paramiko当前版本为2.4.2，而它的依赖包Cryptography版本过新,造成兼容问题。执行代码时会有如下信息:

![1556457026497](https://minioapi.nerubian.cn/image/20250214160353928.png)

**解决方法:**

pycharm里点File-->Settings-->再按如下图所示操作

![1556457345947](https://minioapi.nerubian.cn/image/20250214160357964.png)

![1556457548011](https://minioapi.nerubian.cn/image/20250214160401323.png)

![1556457697508](https://minioapi.nerubian.cn/image/20250214160404618.png)



**示例:paramiko库实现文件的上传下载(免密登录)**

**先提前做好免密登录**

```python
# ssh-keygen				# 三次回车在本机产生空密码密钥对
# ssh-copy-id -i 10.1.1.12   # 将公钥传给对方目标机器

# ssh 10.1.1.12				# 验证是否空密码登录OK
```



```python
import paramiko						# 导入paramiko库

trans = paramiko.Transport(("10.1.1.12",22))	# 产生连接10.1.1.12的22的传输,赋值给trans

private_key = paramiko.RSAKey.from_private_key_file("/root/.ssh/id_rsa") # 指定本机私钥路径

trans.connect(username="root",pkey=private_key)		# 提前使用ssh-keygen做好免密登录

sftp = paramiko.SFTPClient.from_transport(trans)

sftp.get("/etc/fstab","/tmp/fstab2")
sftp.put("/etc/inittab","/tmp/inittab2") 

trans.close()
```






### paramiko库远程命令操作

**示例: 使用paramiko传密码远程操作**

**PS:** 前面做过密码登录，测试先可以先删除密钥, 使其登录需要密码(自行操作)

```python
import paramiko

ssh = paramiko.SSHClient()			# 创建一个客户端连接实例
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)  # 加了这一句,如果第一次ssh连接要你输入yes,也不用输入了
ssh.connect(hostname="10.1.1.12", port=22, username="root", password="123456")  # 指定连接的ip,port,username,password

stdin,stdout,stderr = ssh.exec_command("touch /tmp/123")   # 执行一个命令,有标准输入,输出和错误输出


cor_res = stdout.read()		# 标准输出赋值
err_res = stderr.read()		# 错误输出赋值

print(cor_res.decode())	# 网络传输是二进制需要decode(我们没有讨论socket编程，所以你就直接这样做)
print(err_res.decode())	# 不管正确的还是错误的输出,都打印出来

ssh.close()				# 关闭此连接实例
```





**示例: 通过函数封装paramiko的远程操作**

```python
import paramiko

def paramiko_ssh(hostname, password, command, port=22, username="root"):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
    ssh.connect(hostname=hostname, password=password, port=port, username=username)
    stdin, stdout, stderr = ssh.exec_command(command)
    print(stdout.read().decode())
    print(stderr.read().decode())
    ssh.close()


paramiko_ssh("10.1.1.12", "123456", "df -h")
```



**示例: 使用paramiko空密码密钥远程登录操作**

```shell
# ssh-keygen
# ssh-copy-id -i 10.1.1.12
```

```python
import paramiko

ssh = paramiko.SSHClient()			# 创建一个客户端连接实例

private_key = paramiko.RSAKey.from_private_key_file("/root/.ssh/id_rsa")  # 指定本机私钥路径

ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)  # 加了这一句,如果第一次ssh连接要你输入yes,也不用输入了

ssh.connect(hostname="10.1.1.12",port=22,username="root",pkey=private_key)	# 把password=123456换成pkey=private_key

stdin,stdout,stderr = ssh.exec_command("touch /tmp/321")

cor_res = stdout.read()
err_res = stderr.read()

print(cor_res.decode())
print(err_res.decode())

ssh.close()
```

**示例: 将上例用函数封装**

```python
import paramiko

def paramiko_ssh(hostname, command, port=22, username="root"):
    ssh = paramiko.SSHClient()
    private_key = paramiko.RSAKey.from_private_key_file("/root/.ssh/id_rsa")
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
    ssh.connect(hostname=hostname, port=port, username=username, pkey=private_key)
    stdin, stdout, stderr = ssh.exec_command(command)
    print(stdout.read().decode())
    print(stderr.read().decode())
    ssh.close()


paramiko_ssh("10.1.1.12",  "df -h")
```



