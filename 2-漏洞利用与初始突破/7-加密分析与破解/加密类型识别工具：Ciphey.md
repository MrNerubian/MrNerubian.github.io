
[项目地址](https://github.com/Ciphey/Ciphey)
[安装指南](https://github.com/Ciphey/Ciphey/wiki/Installation)
[官方文档](https://github.com/Ciphey/Ciphey/wiki)

## 安装：

## 安装python3.9

1.更新 Kali Linux 软件包列表：

```
sudo apt update
```

2.安装依赖项：

```
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget libbz2-dev
```

6.下载 Python 3.9源代码：

```
wget https://www.python.org/ftp/python/3.9.12/Python-3.9.12.tgz
```

7.解压缩源代码：
```
tar -xf Python-3.9.12.tgz
```
8.进入源代码目录：
```
cd Python-3.9.12
```
9.配置源代码：
```
./configure --enable-optimizations
```
10.编译 Python 3.9源代码：
```
make -j$(nproc)
```
11.安装 Python 3.9：
```
sudo make altinstall
```

## 安装ciphey

```
python3.9 -m pip install ciphey --upgrade
```

# 使用

有 3 种方式运行 Ciphey。

## 1.文件输入
```
ciphey -f encrypted.txt
```
## 3.输入不合格
```
ciphey -- "Encrypted input"
```
## 4.正常方式
```
ciphey -t "Encrypted input"
```
## 5.安静模式
要摆脱进度条、概率表和所有噪音，请使用安静模式。

```
ciphey -t "encrypted text here" -q
```

获取完整的参数列表，请运行`ciphey --help`.