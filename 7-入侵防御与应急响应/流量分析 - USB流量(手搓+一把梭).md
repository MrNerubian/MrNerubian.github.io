# 流量分析 - USB流量(手搓+一把梭)

原创 xiaoliao1 

[信安一把索](javascript:void(0);)

 *2025年04月23日 18:38* *湖南*

usb.pcapng

![图片](https://minioapi.nerubian.cn/image/20250428121632053.webp)

## **第一种方法：手搓**

直接打开流量包

![图片](https://minioapi.nerubian.cn/image/20250428121632988.webp)

随便选一个看到data位置是8位的

**知识补充：**

**键盘流量**

**基本知识**

USB协议数据部分在Leftover Capture Data域中，数据长度为八个字节。

### **![图片](https://minioapi.nerubian.cn/image/20250428121632988.webp)标准8字节键盘数据格式**

|  字节位置   |        名称         |                             描述                             |
| :---------: | :-----------------: | :----------------------------------------------------------: |
|  **字节1**  | 修饰键（Modifiers） | 表示功能键（Ctrl、Shift、Alt等）的按下状态，每个二进制位对应一个按键。 |
|  **字节2**  |      保留字段       |   通常为 `0x00`，部分设备可能用于扩展功能（如多媒体键）。    |
| **字节3-8** |     普通按键码      |     最多6个同时按下的普通按键的键码（每个按键占1字节）。     |

### **字节1：Modifier Keys（功能键位掩码）**

| 位（Bit） |    对应按键    | HID Usage ID |       描述       |
| :-------: | :------------: | :----------: | :--------------: |
|   Bit 0   |     左Ctrl     |     0xE0     | 按下时值为 `1`。 |
|   Bit 1   |    左Shift     |     0xE1     |                  |
|   Bit 2   |     左Alt      |     0xE2     |                  |
|   Bit 3   | 左GUI（Win键） |     0xE3     |                  |
|   Bit 4   |     右Ctrl     |     0xE4     |                  |
|   Bit 5   |    右Shift     |     0xE5     |                  |
|   Bit 6   |     右Alt      |     0xE6     |                  |
|   Bit 7   | 右GUI（Win键） |     0xE7     |                  |

### **字节3-8：普通按键码（HID Usage ID）**

| HID键码（Hex） | 对应按键  | 字符/功能  |
| :------------: | :-------: | :--------: |
|    **0x00**    |  无按键   |     -      |
|    **0x04**    |     A     |    A/a     |
|    **0x05**    |     B     |    B/b     |
|    **0x06**    |     C     |    C/c     |
|    **0x07**    |     D     |    D/d     |
|    **0x08**    |     E     |    E/e     |
|    **0x09**    |     F     |    F/f     |
|    **0x0A**    |     G     |    G/g     |
|    **0x0B**    |     H     |    H/h     |
|    **0x0C**    |     I     |    I/i     |
|    **0x0D**    |     J     |    J/j     |
|    **0x0E**    |     K     |    K/k     |
|    **0x0F**    |     L     |    L/l     |
|    **0x10**    |     M     |    M/m     |
|    **0x11**    |     N     |    N/n     |
|    **0x12**    |     O     |    O/o     |
|    **0x13**    |     P     |    P/p     |
|    **0x14**    |     Q     |    Q/q     |
|    **0x15**    |     R     |    R/r     |
|    **0x16**    |     S     |    S/s     |
|    **0x17**    |     T     |    T/t     |
|    **0x18**    |     U     |    U/u     |
|    **0x19**    |     V     |    V/v     |
|    **0x1A**    |     W     |    W/w     |
|    **0x1B**    |     X     |    X/x     |
|    **0x1C**    |     Y     |    Y/y     |
|    **0x1D**    |     Z     |    Z/z     |
|    **0x1E**    |     1     |    1/!     |
|    **0x1F**    |     2     |    2/@     |
|    **0x20**    |     3     |    3/#     |
|    **0x21**    |     4     |    4/$     |
|    **0x22**    |     5     |    5/%     |
|    **0x23**    |     6     |    6/^     |
|    **0x24**    |     7     |    7/&     |
|    **0x25**    |     8     |    8/*     |
|    **0x26**    |     9     |    9/(     |
|    **0x27**    |     0     |    0/)     |
|    **0x28**    |   Enter   |   回车键   |
|    **0x29**    |    Esc    |   Esc键    |
|    **0x2A**    | Backspace |   退格键   |
|    **0x2B**    |    Tab    |   Tab键    |
|    **0x2C**    |   Space   |   空格键   |
|    **0x2D**    |     -     |    -/_     |
|    **0x2E**    |     =     |    =/+     |
|    **0x2F**    |     [     |    [/{     |
|    **0x30**    |     ]     |    ]/}     |
|    **0x31**    |     \     |    /\|     |
|    **0x33**    |     ;     |    ;/:     |
|    **0x34**    |     '     |    '/"     |
|    **0x35**    |     `     |    `/~     |
|    **0x36**    |     ,     |    ,/<     |
|    **0x37**    |     .     |    ./>     |
|    **0x38**    |     /     |     /?     |
|    **0x39**    | Caps Lock | 大写锁定键 |
|    **0x3A**    |    F1     |  F1功能键  |
|    **0x3B**    |    F2     |  F2功能键  |
|      ...       |    ...    |    ...     |
|    **0x52**    |     ↑     |  方向键上  |
|    **0x51**    |     ↓     |  方向键下  |
|    **0x50**    |     ←     |  方向键左  |
|    **0x4F**    |     →     |  方向键右  |

直接用data字段进行比对

![图片](https://minioapi.nerubian.cn/image/20250428121632003.webp)

这里是00.00.10.00.00.00.00.00 前面两个00.00对应的是修饰

![图片](https://minioapi.nerubian.cn/image/20250428121632385.webp)

我们从第3位10去对于上面的字符表

![图片](https://minioapi.nerubian.cn/image/20250428121632074.webp)

所以第一位就是m

知道上面这些，就可以构造脚本把所有data内容提取出来直接梭哈


```
# 导入所需库
import os
import subprocess
import json

# 定义tshark命令：从usb.pcapng文件中提取特定USB设备(2.2.1)的HID数据，输出为JSON格式
command = 'tshark -r usb.pcapng -Y usb.addr=="2.2.1"  -T json  -e usbhid.data > 1.json'

# 使用subprocess执行命令
proc = subprocess.Popen(command, shell=True,
                        stdout=subprocess.PIPE, stderr=subprocess.PIPE)
# 等待命令执行完成
proc.communicate()

# 加载生成的JSON文件
with open("1.json","r") as f:
    data=json.load(f)  # data现在包含所有匹配的USB数据包

a2=[]
for i in data:
    try:
        # 提取每个数据包的usbhid.data字段
        a1=i['_source']['layers']['usbhid.data'][0]  # [0]取第一个出现的数据
        a2.append(a1)
    except:
        continue  # 跳过没有usbhid.data字段的数据包

# 定义键盘映射表
normalKeys = {
    "04":"a", "05":"b", "06":"c", "07":"d", "08":"e", 
    # ... 其他常规按键映射 ...
    "39":"<CAP>"  # 大写锁定键
}

shiftKeys = {
    "04":"A", "05":"B", "06":"C", "07":"D", "08":"E",
    # ... 其他Shift组合键映射 ...
    "39":"<CAP>"  # 大写锁定键（实际应保持相同）
}

nums = []
for line in a2:
    if len(line)!=16:
        continue  # 过滤长度不符合要求的HID数据
    # 组合前两位（修饰键）和5-6位（实际按键代码）
    nums.append(line[0:2]+line[4:6])  

output = []
for n in nums:
    if n[2:4] == "00" :  # 00表示没有按键动作
        continue
    if n[2:4] in normalKeys:
        if n[0:2]=="02":  # 02表示Shift键按下
            output.append(shiftKeys[n[2:4]])
        else :
            output.append(normalKeys[n[2:4]])
    else:
        output += '[unknown]'  # 未识别的键值

print(output)  # 输出原始解析结果

flag = 0  # 大写锁定状态标志

# 退格键处理
for i in range(len(output)):
    try:
        a = output.index('<DEL>')  # 查找退格键位置
        del output[a]              # 删除DEL本身
        del output[a - 1]          # 删除前一个字符
    except:
        pass  # 没有DEL时跳过

# 大写锁定处理
for i in range(len(output)):
    try:
        if output[i] == "<CAP>":
            flag += 1
            output.pop(i)          # 移除CAP标记
            if flag == 2:          # 两次CAP恢复小写
                flag = 0
        if flag != 0:
            output[i] = output[i].upper()  # 转换为大写
    except:
        pass  # 处理索引越界等情况

# 最终输出
print("".join(output))
```

写完执行一下

![图片](https://minioapi.nerubian.cn/image/20250428121632082.webp)

**moectf{Learned_a6ou7_USB_tr@ffic}**

## **第二种方法：自动化工具一把梭**

打开一把梭工具

![图片](https://minioapi.nerubian.cn/image/20250428121632909.webp)

把文件导入，执行一下

![图片](https://minioapi.nerubian.cn/image/20250428121633031.webp)

秒了

**moectf{Learned_a6ou7_USB_tr@ffic}**