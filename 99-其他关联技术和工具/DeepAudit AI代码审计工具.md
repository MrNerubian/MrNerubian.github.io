## 简介

DeepAudit 一款基于deepseek的智能化代码审计工具，支持多语言代码安全分析，自动对项目中的代码文件进行深度分析，帮助开发者快速定位潜在漏洞。

- https://github.com/lizhianyuguangming/DeepAudit
## 📌 核心功能

### 代码审计

- **多语言支持**：支持 PHP/Java文件分析
- **智能分块处理**：自动拆分大文件进行分段分析
- **漏洞类型检测**：SQL注入、XSS、代码执行等常见漏洞
- **风险等级评估**：高危/中危/低危三级分类

## 🛠️ 环境安装


```shell
pip install -r requirements.txt
```

## 🚀 快速使用

config.ini配置API密钥

API申请：[https://platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys)

```shell
python DeepAudit.py
```

[![image](https://private-user-images.githubusercontent.com/81677104/428257567-15f017c3-e855-4e5c-85b9-f3edbe55dc4e.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDQ2MDEyOTUsIm5iZiI6MTc0NDYwMDk5NSwicGF0aCI6Ii84MTY3NzEwNC80MjgyNTc1NjctMTVmMDE3YzMtZTg1NS00ZTVjLTg1YjktZjNlZGJlNTVkYzRlLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MTQlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDE0VDAzMjMxNVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTU4ZGY0NmNjMTcxZDMzNmViNTRkYmIwNGZlMzcyYWQ3OTJkZWViMjNjMmYwMjZkZTU1MWFiNWNjMGRiOThiNTQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.VzwMf7ArqXG39mv0_qZmHjOYIMTh-lO5gxkshWXSwcA)](https://private-user-images.githubusercontent.com/81677104/428257567-15f017c3-e855-4e5c-85b9-f3edbe55dc4e.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDQ2MDEyOTUsIm5iZiI6MTc0NDYwMDk5NSwicGF0aCI6Ii84MTY3NzEwNC80MjgyNTc1NjctMTVmMDE3YzMtZTg1NS00ZTVjLTg1YjktZjNlZGJlNTVkYzRlLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MTQlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDE0VDAzMjMxNVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTU4ZGY0NmNjMTcxZDMzNmViNTRkYmIwNGZlMzcyYWQ3OTJkZWViMjNjMmYwMjZkZTU1MWFiNWNjMGRiOThiNTQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.VzwMf7ArqXG39mv0_qZmHjOYIMTh-lO5gxkshWXSwcA)

📂 未完成模块

- 逆向追踪代码链
- 漏洞自动复现
- ......

欢迎在 issue 提交描述问题或提出建议

```
  如果您觉得这个项目对您有帮助，别忘了点亮 Star ⭐！
  您的支持是我们继续优化和改进这个项目的动力！ 😊
```