
### **1. VirusTotal**
#### 简介：
- VirusTotal 是一个在线服务，可以扫描文件或 URL，使用几十种杀毒引擎进行检测。
- 是测试免杀效果的常用工具，但请注意，它会将上传的样本共享给其合作伙伴，因此不适合上传敏感或未公开的样本。

#### 用途：
- 检查 payload 是否被主流杀毒引擎检测到。
- 分析恶意文件的行为和特征。

#### 地址：
[https://www.virustotal.com](https://www.virustotal.com)

#### 注意事项：
- **不要上传敏感或未公开的样本**，因为 VirusTotal 会共享样本，可能导致样本被杀毒引擎更新规则检测。

---

### **2. AntiScan.me**
#### 简介：
- AntiScan.me 是一个专注于免杀测试的在线平台，与 VirusTotal 类似，但不会与杀毒引擎共享样本。
- 适合测试未公开的样本或敏感 payload。

#### 用途：
- 检测 payload 是否被杀毒引擎识别。
- 提供更隐私友好的免杀测试环境。

#### 地址：
[https://antiscan.me](https://antiscan.me)

#### 注意事项：
- 平台会限制免费用户的上传次数。
- 适合测试开发中的免杀 payload。

---

### **3. NoDistribute**
#### 简介：
- NoDistribute 是另一个在线免杀测试平台，与 VirusTotal 不同，它不会将样本共享给杀毒引擎。
- 支持多种杀毒引擎检测。

#### 用途：
- 测试 payload 的免杀效果。
- 确保样本不会被共享。

#### 地址：
[https://nodistribute.com](https://nodistribute.com)

#### 注意事项：
- 平台可能会限制免费用户的功能。
- 请确保合法使用。

---

### **4. Hybrid Analysis**
#### 简介：
- Hybrid Analysis 是一个在线沙箱分析平台，可以运行并分析恶意样本的行为。
- 提供详细的动态分析报告，包括文件操作、网络活动和内存使用等。

#### 用途：
- 测试 payload 的动态行为是否被检测到。
- 分析样本的运行时行为。

#### 地址：
[https://www.hybrid-analysis.com](https://www.hybrid-analysis.com)

#### 注意事项：
- 上传的样本可能会被共享，因此不适合敏感样本。

---

### **5. Any.Run**
#### 简介：
- Any.Run 是一个交互式在线沙箱，允许用户手动操作恶意样本并观察其行为。
- 提供实时的动态分析。

#### 用途：
- 测试 payload 的运行行为。
- 分析样本是否触发检测规则。

#### 地址：
[https://any.run](https://any.run)

#### 注意事项：
- 免费版功能有限，可能需要付费订阅以获得更多服务。

---

### **6. AVET (Antivirus Evasion Tool)**
#### 简介：
- AVET 是一个开源工具，用于生成免杀 payload。
- 它通过修改和混淆恶意代码来绕过杀毒软件的检测。

#### 用途：
- 生成和测试免杀 payload。
- 用于红队和渗透测试。

#### 项目地址：
[https://github.com/govolution/avet](https://github.com/govolution/avet)

#### 注意事项：
- 需要一定的开发技能和代码理解能力。
- 请确保合法使用。

---

### **7. Veil Framework**
#### 简介：
- Veil Framework 是一个专门用于生成免杀 payload 的工具，支持多种编程语言和 payload 类型。
- 常用于渗透测试和红队活动。

#### 用途：
- 创建免杀的反向 shell 或其他恶意 payload。
- 测试 payload 是否能够绕过杀毒引擎。

#### 项目地址：
[https://github.com/Veil-Framework/Veil](https://github.com/Veil-Framework/Veil)

#### 注意事项：
- Veil 需要在 Kali Linux 或其他支持的操作系统上运行。
- 仅限合法用途。

---

### **8. Shellter**
#### 简介：
- Shellter 是一个动态 PE 文件注入工具，用于创建免杀的恶意可执行文件。
- 支持混淆和多种免杀技术。

#### 用途：
- 测试免杀效果。
- 创建免杀的恶意可执行文件。

#### 项目地址：
[https://www.shellterproject.com](https://www.shellterproject.com)

#### 注意事项：
- 需要对 PE 文件结构有一定了解。
- 请确保合法使用。

---

### **9. Metasploit Framework**
#### 简介：
- Metasploit 是一个渗透测试框架，支持生成和测试 payload。
- 配合编码器和混淆技术，可以生成免杀的 payload。

#### 用途：
- 创建和测试免杀 payload。
- 用于渗透测试和红队活动。

#### 项目地址：
[https://www.metasploit.com](https://www.metasploit.com)

---

### **10. Cobalt Strike**
#### 简介：
- Cobalt Strike 是一个商业化的红队工具，提供强大的免杀 payload 生成和测试功能。
- 支持多种混淆和绕过技术。

#### 用途：
- 创建免杀的 payload。
- 用于红队活动和高级渗透测试。

#### 注意事项：
- Cobalt Strike 是商业软件，需要合法授权才能使用。


### **3. Triage**
#### 简介：
- Triage 是一个在线恶意软件分析平台，可以分析文件和代码的行为。
- 支持上传脚本文件（如 PHP、Python 等）并检测其恶意性。

#### 功能：
- 动态分析 Web Shell 的行为。
- 检测是否触发安全规则。

#### 地址：
[https://tria.ge](https://tria.ge)

#### 使用方法：
1. 注册并登录 Triage 平台。
2. 上传文本 Shell 文件。
3. 查看分析报告，了解其行为和检测结果。

#### 注意事项：
- 平台适合动态行为分析。
- 可能需要一定的技术背景来解读分析结果。

---


### **5. CyberChef**
#### 简介：
- CyberChef 是一个强大的在线工具箱，可以对文本或代码进行混淆、加密和解码。
- 虽然不是直接的免杀检测工具，但可以用于对 Web Shell 进行混淆处理，从而提高免杀效果。

#### 功能：
- 支持多种混淆和编码技术（如 Base64、URL 编码等）。
- 帮助生成更隐匿的 Web Shell。

#### 地址：
[https://gchq.github.io/CyberChef/](https://gchq.github.io/CyberChef/)

#### 使用方法：
1. 将 Web Shell 代码粘贴到 CyberChef。
2. 选择混淆或编码操作（如 Base64 编码）。
3. 测试混淆后的代码是否能够绕过检测。

#### 注意事项：
- CyberChef 不会直接检测免杀效果，但可以配合其他平台使用。
- 可用于对代码进行预处理。

---

### **6. PHP Sandbox**
#### 简介：
- PHP Sandbox 是一个在线运行 PHP 代码的平台，可以用于测试 Web Shell 的功能和隐匿性。
- 适合检查代码是否会触发安全规则。

#### 功能：
- 在线运行 PHP 代码。
- 检测代码是否会被安全机制阻止。

#### 地址：
[https://phpsandbox.io/](https://phpsandbox.io/)

#### 使用方法：
1. 将 Web Shell 代码粘贴到 PHP Sandbox。
2. 运行代码并观察结果。
3. 检查是否触发安全规则或被拦截。

#### 注意事项：
- 不适合上传高度恶意的代码。
- 平台可能会限制某些功能。

---

### **7. Local Testing with Antivirus**
#### 简介：
- 如果不希望将 Web Shell 上传到在线平台，可以在本地测试代码是否被本地杀毒软件检测。
- 适合在离线环境中测试。

#### 方法：
1. 将 Web Shell 代码保存为文件（如 `.php`）。
2. 在本地运行杀毒软件扫描该文件。
3. 检查是否被检测为恶意文件。

#### 注意事项：
- 确保测试环境隔离，避免意外感染。
- 本地测试不会泄露样本，但结果可能不如在线平台全面。

---

### **8. Manual Analysis with Regex/IDS Rules**
#### 简介：
- 如果你熟悉入侵检测系统（如 Snort、Suricata）的规则，可以手动分析 Web Shell 是否会被检测。

#### 方法：
1. 使用 Web Shell 代码和已知的检测规则（如 OWASP 的规则集）。
2. 在本地环境中运行代码并观察是否触发规则。
3. 调整代码，规避检测规则。

#### 工具：
- Snort: [https://www.snort.org/](https://www.snort.org/)
- Suricata: [https://suricata.io/](https://suricata.io/)
