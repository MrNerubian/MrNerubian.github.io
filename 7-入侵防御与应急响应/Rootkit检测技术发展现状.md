# Rootkit检测技术发展现状

Rootkit 这一概念最早出现于上个世纪九十年代初期，CERT Coordination Center(CERT/CC) 于1994年在 CA-1994-01 这篇安全咨询报告中使用了 Rootkit 这个词汇。在这之后 Rootkit 技术发展迅速，这种快速发展的态势在 2000 年达到了顶峰。2000年后，Rootkit 技术的发展也进入了低潮期，但是对于 Rootkit 技术的研究却并未停滞。在 APT 攻击日益流行的趋势下，Rootkit 攻击和检测技术也同样会迎来新的发展高潮。

在往期的Rootkit系列文章里面，我们分别介绍了 [Rootkit 技术的发展历程](https://link.zhihu.com/?target=http%3A//mp.weixin.qq.com/s%3F__biz%3DMzI4NjE2NjgxMQ%3D%3D%26mid%3D2650258900%26idx%3D1%26sn%3D437577e4a99cb0e5b69eb6e05564e999%26chksm%3Df3e207a0c4958eb64f35a055762f2c827e2c0908e2ca446d4ffde97f734c66799009f623bc24%26scene%3D21%23wechat_redirect)和[Windows](https://link.zhihu.com/?target=http%3A//mp.weixin.qq.com/s%3F__biz%3DMzI4NjE2NjgxMQ%3D%3D%26mid%3D2650258988%26idx%3D1%26sn%3D09d23fe267f04fd6f30d8c5608507cae%26chksm%3Df3e20458c4958d4e51b404cbb186fe621fe634b8bccd56228e11ef385e637ebe8ebad939a242%26scene%3D21%23wechat_redirect)、[Linux](https://link.zhihu.com/?target=http%3A//mp.weixin.qq.com/s%3F__biz%3DMzI4NjE2NjgxMQ%3D%3D%26mid%3D2650259263%26idx%3D1%26sn%3Dea5a3383451045d226ec81619360f505%26chksm%3Df3e2054bc4958c5df24ddf9fc81cea4f1e0377419b4e7ee60a191d4017d892dfb2ee705b8605%26scene%3D21%23wechat_redirect) 平台下的 Rootkit 攻击技术。本期 Rootkit 系列文章将会给大家介绍当前主流的 Rootkit 防御技术以及一些非常规 Rootkit 的可实施检测方案。

## 被滥用的Rootkit技术

长期以来，Rootkit 检测一直是一个非常大的痛点，这些具有高度定制化的恶意程序集合隐藏在服务器上，以高权限访问计算机和网络。虽然 Rootkit 并没有成为大新闻中的主角，但是它们一直都过得很安逸，并且持续性的造成损害。对于安全从业者而言，这不应该是一个被忽视的地方。

APT 通常和 Rootkit 齐头并进。从西方 APT 组织的攻击历史及已经泄露的网络武器看，高隐匿、高持久化(Low&Slow)是其关键特征，而 Rootkit 则是达成此目的的重要技术之一，因此 Rootkit 一直以来和 APT 配合的很好。

让人遗憾的是，几乎任何脚本小子都可以轻易在被攻击成功的目标主机上植入 Rootkit。比起这个，更让人痛心的是，一些挖矿木马和广告木马都开始使用 Rootkit 技术了，黑产都卷成这个样子了吗？H2Miner 挖矿家族开始使用新的 Rootkit 样本，该Rootkit 使用 LD_PRELOAD 技术劫持动态链接过程。LD_PRELOAD 是一个非常古老的C 库技巧，但它今天仍然被成功使用和滥用。

## 当前主流Rookit检测技术分析

当前主要的 Rootkit 检测的方法包括但不限于以下几种类型。

### 1.基于 Rootkit 运行的效果进行检测

如: 发现隐藏的端口、进程、内核模块、网络连接、被篡改的内核代码。

缺陷: 该检测方案对预设的检测场景的依赖程度较高，一旦恶意软件出现检测场景之外的行为，则难以做到有效检测。

### 2.静态文件特征检测

例如: 扫描磁盘上的文件，将文件与特征库进行匹配，通过该方式检测可能存在的Rootkit。

缺陷: 该检测方案对特征库依赖程度较高，能够有效发现已知特征的 Rootkit，难以发现未知特征的 Rootkit。

### 3. 动态行为分析检测

例如: 对系统运行过程中的行为进行审计，通过行为规则匹配的方式发现系统中的异常行为，通过该方式发现可能存在的 Rootkit。

缺陷: 对行为规则的依赖程度较高，只能匹配已知行为特征的 Rootkit，难以匹配未知行为特征的 Rootkit。

### 4.数据完整性检测

例如: 对系统关键的数据结构进行监控，通过监控关键数据结构的异常篡改，以发现系统中的恶意行为。

缺陷: 完整性检测依赖于受信任的源数据，如果源数据被篡改或者不可信的情况下，则完整性检测也很难奏效。

当前的开源社区的 Rootkit 检测技术主要以 Rootkit 运行效果检测和静态文件特征检测为主，动态行为分析和数据完整性保护的 Rootkit 检测项目相对较少。

## 当前主流Rookit检测项目分析

Chkrootkit: 检测 /proc/kallsyms 的内容并匹配相对应的文件名和目录来检测是否存在Rootkit，通过该方式，chkrootkit 能够在一定程度上发现 Rootkit 执行的恶意行为，诸如文件隐藏，网络连接隐藏，进程信息隐藏。但是该检测方案对 Rootkit 指纹库依赖度较高，并且严重依赖于 /proc/ 目录下的文件，一旦该文件不可信任，则很容易被绕过。

Rkhunter: 这个 Rootkit 检测工具会扫描相应的文件目录、文件、符号表，通过该方式检测是否存在 Rootkit 恶意家族。同样的，该检测方案对特征库的依赖度较高，且难以发现指纹没有覆盖到的 Rootkit。

Kjackal: 该 Rootkit 检测工具通过遍历内核中的系统调用表 syscall_table，注意检查例程的入口是否存在内核空间，如果不存在，就意味着发生了 syscall 劫持。发现了存在syscall_table 的劫持之后，该工具会进行反向追踪，以确定劫持系统调用的是哪一个恶意LKM模块。Kjackal 会枚举 /proc/net/tcp 的读写句柄是否存在于内核态中，如果不存在，则发生了劫持。该工具还会枚举 modules kset 以检测隐藏的内核模块。该检测方案也同样存在被绕过的可能性，一旦 Rootkit 通过删除 kobject 数据结构的方式隐藏Rootkit，那么这将很难检测，不过这种删除 kobject 数据结构的方式也同样会影响 Rootkit 正常使用。

Tyton: 该项目检测 Rootkit 的方式和 kjackal 非常相似，通过枚举内核空间的module_list，中断向量表、网络连接读写句柄、系统调用表、netfilter hook 等方式发现可能存在的Rootkit，发现Rootkit之后，通过 get_module_from_addr 函数反向溯源恶意的内核模块。

Elkeid: 该项目是字节跳动的一个开源的 HIDS 项目，该 hids 检测 Rootkit 的方式继承自 tyton 的检测方案。除了这个之外，elkeid 还在行为检测方面做出了突破，使用kprobe 对关键的系统调用进行 hook，持续监控系统运行过程中的进程行为，网络行为、文件行为等相关信息并保存到日志中，再使用字节跳动于近期开源的 Hlkeid Hub的行为日志检测引擎和规则集，能够对系统运行过程中的日志进行自动化分析，以发现可能存在的未知威胁。不得不说这是一个非常勇敢的突破，业界普遍都对 kprobe 持保留态度，敢于直接上车的并不多见。不过这种日志采集方式也存在一个缺陷，一旦攻击者控制了 /sys/kernel/debug/kprobes/enabled 文件，就可以使这种日志采集功能失效。再补充一句，该项目更新频率较高，并且社区支持非常友好。

stmichael-lkm: 该项目能够为内核提供一定的完整性保护，能够在一定程度上发现针对内核的篡改，通过这种方式发现可能存在的 Rootkit。一旦检测到 Rootkit 篡改内核，StMichael 尝试通过将所做的更改回滚到先前已知的良好状态来恢复内核的完整性。不得不说这是一个非常大胆的尝试，比使用 kprobe 更加激进，这种方案的致命缺陷就是很容易为系统引入未知的问题，导致系统的不稳定。

Qiling: 该项目是一个高级二进制仿真框架，能够模拟多平台，多架构的运行环境，通过类似于沙箱的环境运行 Rootkit，并且记录 Rootkit 运行过程中的行为。这为恶意Rootkit 的检测和分析提供了一种全新的思路。传统沙箱对恶意软件的检测很难达到这种细粒度的监控效果。

## 非常规Rookit以及检测方案

### 1. 使用了命名空间技术的 HorsePILL

在讲述该 Rootkit 之前，有必要简单介绍一下命名空间的含义。命名空间是Linux的一个非常重要的系统特性，Linux 的命名空间机制提供了一种资源隔离的解决方案。PID,IPC,Network 等系统资源不再是全局性的，而是属于特定的Namespace，不同命名空间的资源是互相隔离的，在一个命名空间所做的事情不会影响另一个命名空间。各命名空间在 Linux 的引入版本如下:

![](https://minioapi.nerubian.cn/image/20250329181312240.webp)

由于命名空间的隔离特性，这给恶意文件的隐藏提供了新的思路。将恶意文件和恶意文件运行过程中的进程、网络置于一个与系统不同命名空间的环境中，可以非常有效的隐藏自身，在一定程度上来说，难以发现。

HorsePILL 这个 Rootkit 就利用了这种命名空间的特性，该 Rootkit 会感染系统的initramfs，被感染的系统在启动过程中加载 initramfs 就会执行 Rootkit 的恶意代码。恶意代码执行之后，会将整个系统置于一个新创建的子命名空间之中，而恶意代码本身运行于更上级的命名空间。这种 Rootkit 隐藏方式可谓是别具一格，对系统的性能影响可以说忽略不计，是一个非常棒的 Rootkit，美中不足的是该 Rootkit 需要重启系统才能够执行其恶意代码。

这种 Rootkit 也是非常有效的运行时检测方案，首先，该 Rootkit 需要感染initramfs，基于这一点可以修改 grub，给 grub 新增一个启动过程中校验 initramfs 和vmlinuz 文件完整性的功能，避免启动不受信任的系统。当系统不幸感染了这种

基于命名空间的 Rootkit，整个系统用户空间的数据已经不在可信的情况下，可以从内核态中测绘各个命名空间的信息，并且从中发现异常的命名空间数据。

感染 horsepill，攻击者拿到了设备的 shell，攻击者视角下真实的1号进程的命名空间数据如下:



![](https://minioapi.nerubian.cn/image/20250209230709242.webp)



感染 horsepill之后设备管理员视角下，可以非常直观的看到命名空间信息已经出现了异常，而这种异常信息通常是被人忽略的。

![](https://minioapi.nerubian.cn/image/20250329181009869.webp)

对于这种 Rootkit，受害主机运行时可以通过命名空间测绘的方式发现 Rootkit 的存在。

### 2. 使用kprobe技术的Rootkit

在上文中讲 Elkeid 的时候提到了 kprobe 这个机制，这个机制可以用来采集系统的行为信息，当然也可以用来编写 Rootkit。Kprobe、jprobe 以及 kretprobe 可以在内核符号的函数序言和函数尾声插桩，一旦内核符号注册了 kprobe，就会修改函数序言，被修改的函数序言会执行一个跳转指令，跳转到一个新的内核符号trace_spurious_interrupt，然后由 trace 机制跳转到中断处理函数，中断处理函数再调用 kprobe 的回调函数，使用 kprobe 技术可以篡改部分内核符号的入参和返回值，这能够非常容易的达到隐藏恶意程序相关信息的目的，并且这种 Rootkit 隐蔽性也同样很强。

这类Rootkit的检测方法也是同样不同于前面的方案的。最简单的判断方法就是查看 /sys/kernel/debug/kprobes/list 这个文件的内容。  

![](https://minioapi.nerubian.cn/image/20250329181024547.webp)

但是该方案有一个非常致命的缺陷，系统感染了 kprobe 的 Rootkit 之后，/sys/kernel/debug/kprobes/list 文件的内容已经是不可信的了，因此需要从其他途径获取 Rootkit 检测的线索。

内核中有这么一个数据结构 kprobe_table，该数据结构维护了所有注册的 kprobe 的表，遍历这张表，可以发现感染这类 Rootkit 的 kprobe 数据结构。

内核符号在 vmlinuz、挂载 kprobe 之前和挂载 kprobe 之后其数据都是存在非常明显的差异性的。例如: 内核符号 SyS_ptrace 经过 kprobe 挂载前后的内存数据对比如下图:

![](https://minioapi.nerubian.cn/image/20250329181039516.webp)

左边是挂载 kprobe 之后的内存数据，右边是挂载 kprobe 之前的内存数据，根据两者对比，可以发现前4个字节存在差异。同样也是这个内核符号，在 /boot/vmlinuz 文件中的二进制数据也和上面两者不同，相关数据如下图所示:

![](https://minioapi.nerubian.cn/image/20250209230756337.webp)

其差异同样体现在符号的前4个字节。这三者之间的差异主要由两方面因素所导致。首先是vmlinuz 加载到内存时，会动态的修改其代码内容，这种修改主要通过 .altinstructions 这个段中的数据完成的。

加载到内存之后，再对其挂载 kprobe，修改的同样是前4个字节，将这部分差异性较强的代码进行反汇编，可以得出其汇编代码。

反汇编这部分数据，可以看到其具体的操作码也有较强差异。首先，符号 SyS_ptrace 的内存地址为 0xffffffff8108a1b0，挂载 kprobe 之后，其执行的第一个指令为 call 0x5bd300。因此可以计算，其跳转地址为: '0xffffffff816474b0' 。查询该地址对应的符号如下:

![](https://minioapi.nerubian.cn/image/20250209230844483.webp)

根据上述分析内容，kprobe Rootkit 会在执行过程中修改内核符号的函数序言，因此要检测这种类型的 Rootkit，还可以对运行时的内核代码进行完整性检测。

### 3. 基于ebpf的Rootkit

基于 bpf 的 Rootkit 并不是什么新鲜事物，bpf 技术于1993年就被提出，bpf 的指令集并非是一种图灵完全的指令集，因此使用 bpf 指令开发 Rootkit 似乎是一种天方夜谭。但是 APT 组织 Equation Group 做到了，在 shadow brokers 于2016年公开方程式的工具包中，有这么一个不太引人瞩目的 Rootkit DewDrops。这么长时间以来，大多数人眼里看到的可能只有永恒系列漏洞利用和 doublepulsar 后门，而对于其中的Dewdrops Rootkit，却是很少有人关注。尽管他的知名度并不高，但并不影响我对这个 Rootkit 设计者的佩服。

但是 DewDrops 并非此次的主要内容，这一段的主角 Rootkit 是 ebpfkit，这个 Rootkit于2021年在多个世界顶级安全会议上亮相。该 Rootkit 可以 hook 内核态函数，篡改内核态返回用户态缓冲区数据，达到用户态欺骗的目的。用户态进程拿到被篡改的数据，从而被骗通过认证。在此过程，不改变任何文件、进程、网络行为，不产生日志。常规 HIDS、HIPS 产品无法感知。eBPF还支持kprobe/kretprobe、uprobe/uretprobe、XDP、TC、socket、cgroup等程序类型，覆盖文件、网络、socket、syscall等事件，都是可以被黑客利用的地方。

面对这么复杂的威胁，从安全防御的视角，该怎样处理这种类型的威胁呢？这个 Rootkit的作者给出了这么一份答卷(业界良心啊)。作者开源了针对这种 Rootkit 的检测工具ebpfkit-monitor。该工具可用于静态分析 eBPF 字节码或在运行时监控可疑的eBPF 活动，尽管当前该检测工具仅仅针对 ebpfkit，但是这无疑给研究基于 ebpf 技术的 Rootkit 检测工具的人提供了良好的思路。

## 结语

在攻防对抗愈加激烈的时代，在 APT 攻击逐渐进入大众视野的当下，Rootkit 的攻防也将会愈加激烈，而安全从业者乃至安全企业，也需要重新审视一下，是否已经具备了针对未知威胁的检测能力，是否已经具备了针对新型攻击技术的检测防御能力。

## 参考项目链接

1、[https://github.com/Gui774ume/ebpfkit-monitor](https://link.zhihu.com/?target=https%3A//github.com/Gui774ume/ebpfkit-monitor)  

2、 [https://github.com/Gui774ume/ebpfkit](https://link.zhihu.com/?target=https%3A//github.com/Gui774ume/ebpfkit)  

`ebpfkit` 是一个rootkit，它利用多个eBPF功能来实现攻击性安全技术。我们实现了您期望从rootkit中获得的大部分功能：混淆技术，容器突破，持久访问，命令和控制，旋转，网络扫描，远程应用程序自我保护（RASP）绕过等。

系统要求

- golang 1.13+
- 这个项目是在Ubuntu Focal机器（Linux Kernel 5.4）上开发的
- 内核头文件预计安装在 `lib/modules/$(uname -r)` 中（参见 `Makefile` ）
- clang（& llvm）（11.0.1）
- Graphviz（生成图形）
- go-bindata（ `go get -u github.com/shuLhan/go-bindata/...` ）



3、 [https://github.com/qilingframework/qiling](https://link.zhihu.com/?target=https%3A//github.com/qilingframework/qiling)  

qiling是一个可模拟多种架构和平台的模拟执行框架，基于**Unicorn**
框架开发而来，可支持的平台有：Windows, MacOS, Linux, BSD, UEFI, DOS，可支持的架构有： X86,
X86_64, Arm, Arm64, MIPS,
8086，同时还提供跨架构的调试能力，多种层次的hook方法，qiling基于python开发，上手使用起来也非常方便，学习成本低



4、 [https://defcon.org/html/defcon-29/dc-29-speakers.html#fournier](https://link.zhihu.com/?target=https%3A//defcon.org/html/defcon-29/dc-29-speakers.html%23fournier)  


5、 [https://github.com/bytedance/Elkeid](https://link.zhihu.com/?target=https%3A//github.com/bytedance/Elkeid)  


6、 [https://github.com/bytedance/Elkeid-HUB](https://link.zhihu.com/?target=https%3A//github.com/bytedance/Elkeid-HUB)  

Elkeid HUB 是一款由 Elkeid Team 维护的规则/事件处理引擎，支持流式/离线(社区版尚未支持)数据处理。 初衷是通过标准化的抽象语法/规则来解决复杂的数据/事件处理与外部系统联动需求。


8、 [https://www.cnxct.com/container-escape-in-linux-kernel-space-by-ebpf/](https://link.zhihu.com/?target=https%3A//www.cnxct.com/container-escape-in-linux-kernel-space-by-ebpf/)  

内核态eBPF程序实现容器逃逸与隐藏账号rootkit


9、[https://reverse.put.as/2021/12/17/knock-knock-whos-there/](https://link.zhihu.com/?target=https%3A//reverse.put.as/2021/12/17/knock-knock-whos-there/)



文章来源于深信服科技旗下安全实验室——深信服千里目安全实验室，致力于网络安全攻防技术的研究和积累，深度洞察未知网络安全威胁，解读前沿安全技术。

发布于 2022-02-15 14:13

# 学习博客：

[Rookit系列一 【隐藏网络端口】【支持Win7 x32/x64 \~ Win10 x32/x64】-CSDN博客](https://blog.csdn.net/qq_41252520/article/details/132113204)

[Rookit系列二【文件隐藏】【支持Win7 x32/x64 \~ Win10 x32/x64平台的NTFS文件系统】\_ntfs驱动-CSDN博客](https://blog.csdn.net/qq_41252520/article/details/134064943)

[Linux Rootkit 系列一：LKM的基础编写及隐藏\_km\_init-CSDN博客](https://blog.csdn.net/whatday/article/details/96986296)

[Linux Rootkit 系列二：基于修改 sys\_call\_table 的系统调用挂钩-CSDN博客](https://blog.csdn.net/whatday/article/details/96989214)

[Linux Rootkit 系列三：实例详解 Rootkit 必备的基本功能\_linux+rootkit+编写-CSDN博客](https://blog.csdn.net/whatday/article/details/96989578)

[Linux Rootkit 系列四：对于系统调用挂钩方法的补充\_基于系统调用hook技术控制linux系统刻录的方法-CSDN博客](https://blog.csdn.net/whatday/article/details/96990710)

[Linux Rootkit 系列五：感染系统关键内核模块实现持久化-CSDN博客](https://blog.csdn.net/whatday/article/details/96991699)

