## SearchSploit

使用方法：

- [漏洞利用搜索 SearchSploit](https://www.nerubian.cn/archives/eae7f17c-7848-4bb0-bceb-b90fe28360d3)

 示例 
```
  searchsploit afd windows local
  searchsploit -t oracle windows
  searchsploit -p 39446
  searchsploit linux kernel 3.2 --exclude="(PoC)|/dos/"
  searchsploit -s Apache Struts 2.0.0
  searchsploit linux reverse password
  searchsploit -j 55555 | jq
  searchsploit --cve 2021-44228

有关更多示例，请参阅手册： https://www.exploit-db.com/searchsploit
```
 选项 
```
## 搜索项
   -c, --case     [term]      执行区分大小写的搜索（默认为不区分大小写）
   -e, --exact    [term]      对漏洞标题执行精确和顺序匹配（默认为对每个术语进行AND匹配）[意味着“-t”]
   -s, --strict               执行严格搜索，因此输入值必须存在，禁用模糊搜索的版本范围
   -t, --title    [term]      仅搜索漏洞标题（默认为标题和文件路径）
       --exclude="term"       从结果中删除值。通过使用“|”分隔，可以链接多个值
       --cve      [CVE]       搜索通用漏洞和暴露（CVE）值

## 输出
   -j, --json     [term]      以 JSON 格式显示结果
   -o, --overflow [term]      允许漏洞标题溢出其列
   -p, --path     [EDB-ID]    显示漏洞的完整路径（如可能，还会将路径复制到剪贴板）
   -v, --verbose              在输出中显示更多信息
   -w, --www      [term]      显示到 Exploit-DB.com 的 URL，而不是本地路径
       --id                   显示 EDB-ID 值而不是本地路径
       --disable-colour       在搜索结果中禁用颜色突出显示

## 非搜索项
   -m, --mirror   [EDB-ID]    将漏洞（即副本）镜像到当前工作目录
   -x, --examine  [EDB-ID]    使用 $PAGER 检查（即打开）漏洞

## 非搜索项
   -h, --help                 显示此帮助屏幕
   -u, --update               检查并安装任何 exploitdb 包更新（brew、deb 和 git）

## 自动化
       --nmap     [file.xml]  使用服务版本检查 Nmap 的 XML 输出中的所有结果
                                例如：nmap [host] -sV -oX file.xml
```
 提示 
```
"您可以使用任意数量的搜索词
默认情况下，搜索词不区分大小写，顺序不重要，并且会在版本范围内进行搜索
- 如果希望通过区分大小写来减少结果，请使用'-c'
- 如果希望通过使用精确匹配来过滤结果，请使用“-e”
- 如果希望搜索精确版本匹配，请使用“-s”
- 使用“-t”排除文件路径以过滤搜索结果
- 移除虚警（尤其是在使用数字（即版本）进行搜索时）
- 当使用“--nmap”并添加“-v”（详细），它将搜索更多的组合
- 在更新或显示帮助时，搜索词将被忽略"
```
## 在线漏洞利用数据库

https://www.exploit-db.com/

https://www.vulnerability-lab.com/

https://www.rapid7.com/db/

## 内核漏洞库

https://www.kernel-exploits.com/

漏洞来源：

https://www.securityfocus.com/vulnerabilities

### 漏洞情报平台

- [2021.04.04] - [https://www.cnvd.org.cn/flaw/list.htm](https://www.cnvd.org.cn/flaw/list.htm) - 国家信息安全漏洞共享平台
- [2021.04.04] - [https://help.aliyun.com/noticelist/9213612.html](https://help.aliyun.com/noticelist/9213612.html) - 阿里云安全公告
- [2021.04.04] - [https://cloud.tencent.com/announce?categorys=21](https://cloud.tencent.com/announce?categorys=21) - 腾讯云安全公告
- [2021.04.04] - [https://www.exploit-db.com/](https://www.exploit-db.com/) - Exploit Database
- [2021.04.04] - [https://nox.qianxin.com/vulnerability](https://nox.qianxin.com/vulnerability) - 奇安信 NOX 安全监测
- [2021.04.04] - [https://loudongyun.360.cn/#qingbao](https://loudongyun.360.cn/#qingbao) - 360漏洞云情报平台
- [2021.04.04] - [https://www.seebug.org/](https://www.seebug.org/) - 知道创宇 Seebug 漏洞平台
- [2021.04.04] - [https://vti.huaun.com/index/](https://vti.huaun.com/index/) - 华安云 漏洞情报平台
- [2021.04.04] - [https://www.venustech.com.cn/new_type/aqtg/](https://www.venustech.com.cn/new_type/aqtg/) - 启明星辰应急响应中心 漏洞预警平台
- [2021.04.04] - [https://sec.sangfor.com.cn/security-vulnerability](https://sec.sangfor.com.cn/security-vulnerability) - 深信服安全中心
- [2021.04.04] - [https://www.anquanke.com/vul](https://www.anquanke.com/vul) - 安全客 全球最新漏洞库
- [2021.04.04] - [http://www.nsfocus.net/index.php?act=sec_bug](http://www.nsfocus.net/index.php?act=sec_bug) - 绿盟科技漏洞库
- [2021.04.04] - [https://nvd.nist.gov/vuln/](https://nvd.nist.gov/vuln/full-listing) - NIST国家漏洞数据库
- [2021.04.04] - [https://www.pwnwiki.org/](https://www.pwnwiki.org/) - Pwnwiki是一个免費、自由、人人可编辑的漏洞库
- [2021.04.04] - [https://cn.0day.today/](https://cn.0day.today/) - 0day.today 漏洞数据库
- [2021.04.04] - [https://attackerkb.com/?sort=newest-created](https://attackerkb.com/?sort=newest-created) - AttackerKB
- [2021.04.04] - [https://vxug.fakedoma.in/tmp/Exploits/](https://vxug.fakedoma.in/tmp/Exploits/) - vx-underground
- [2021.04.04] - [https://www.cvebase.com/poc](https://www.cvebase.com/poc) - CVEBASE
- [2021.04.04] - [https://vul.wangan.com/](https://vul.wangan.com/) - 网安.漏洞数据库
- [2021.04.04] - [https://www.vulncode-db.com/](https://www.vulncode-db.com/) - Home - Vulncode-DB
- [2021.04.04] - [https://sploitus.com/](https://sploitus.com/) - Sploitus | Exploit Search
- [2021.04.04] - [https://poc.shuziguanxing.com/#/issueList](https://poc.shuziguanxing.com/#/issueList) - 数字观星.POC++平台
- [2021.04.29] - [http://vulhub.org.cn/index](http://vulhub.org.cn/index) - 信息安全漏洞门户 VULHUB
- [2021.06.23] - [https://github.com/mai-lang-chai/Middleware-Vulnerability-detection](https://github.com/mai-lang-chai/Middleware-Vulnerability-detection) - CVE、CMS、中间件漏洞检测利用合集
- [2021.06.23] - [https://github.com/EdgeSecurityTeam/Vulnerability](https://github.com/EdgeSecurityTeam/Vulnerability) - 此项目将不定期从棱角社区对外进行公布一些最新漏洞
- [2021.06.24] - [https://securitylab.github.com/advisories/](https://securitylab.github.com/advisories/) - Github 安全实验室披露的漏洞


[B站视频：【熟肉】关于社交媒体的（OSINT）开源网络情报 (private accounts)](https://www.bilibili.com/video/BV1kH4y1y7ri?vd_source=1bf73ce1b8dc56254a6e34e404bac68f)