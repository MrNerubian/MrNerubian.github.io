
## 1、脚本1
```
# 导入 pwn 库，该库提供了用于远程攻击和漏洞利用的功能  
from pwn import *  
# 连接到远程主机，指定主机地址和端口号  
c = remote('192.168.56.137',1337)  
# 等待接收远程主机发送的换行符和换行符，然后将其丢弃  
c.recvuntil("\n\n", drop=True)  
  
# 循环 1001 次  
for i in range(1001):  
    # 等待接收远程主机发送的左括号，然后将其丢弃  
    c.recvuntil("(", drop=True)  
    # 等待接收远程主机发送的整数 1，直到遇到逗号，然后将其丢弃  
    int1 = c.recvuntil(",", drop=True)  
    # 等待接收远程主机发送的单引号，然后将其丢弃  
    c.recvuntil("'", drop=True)  
    # 等待接收远程主机发送的数学符号，直到遇到单引号，然后将其丢弃  
    mathsym = c.recvuntil("'", drop=True)  
    # 等待接收远程主机发送的逗号和空格，然后将其丢弃  
    c.recvuntil(", ", drop=True)  
    # 等待接收远程主机发送的整数 2，直到遇到右括号，然后将其丢弃  
    int2 = c.recvuntil(")", drop=True)  
    # 将接收到的整数 1、数学符号和整数 2 组合成一个方程  
    equation = int1+mathsym+int2  
    # 打印第 i 个方程的答案  
    print(str(i)+"th answer= "+str(equation))  
    # 在远程主机提示“>”后，发送方程的答案  
    c.sendlineafter('>',equation)  
# 进入交互模式，可以与远程主机进行交互  
c.interactive()
```

## 2、脚本2

```
from pwn import *

c = remote('192.168.56.137', 1337)
# 创建一个远程连接到IP地址192.168.56.137端口1337的socket对象

c.recvuntil("\n\n", drop=True)
# 接收直到遇到两个换行符，丢弃接收到的内容

for i in range(1001):
    # 接收数学问题的一部分，直到遇到左括号
    left_bracket = c.recvuntil("(")
    
    # 接收数字1，直到遇到逗号
    int1 = left_bracket.split(",")[0]
    
    # 接收数学符号，直到遇到单引号
    mathsym = c.recvuntil("'")
    
    # 接收空白字符（可能是逗号或空格），直到遇到右括号
    right_bracket = c.recvuntil(")")
    
    # 构建数学表达式
    equation = int1 + mathsym + right_bracket
    
    # 打印第i个答案
    print(f"{i}th answer= {equation}")
    
    # 在提示符>后发送构建的数学表达式
    c.sendlineafter('>', equation)

c.interactive()
# 进入交互模式，允许手动输入

```




