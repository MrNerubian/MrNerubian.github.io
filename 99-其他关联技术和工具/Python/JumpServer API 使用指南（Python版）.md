### JumpServer API 使用指南（Python版）

#### 一、API核心功能模块概览
根据API文档，主要功能模块包括：认证授权、资产管理、工单管理、作业中心、用户管理、审计日志、通知设置等。以下是各模块典型接口说明及Python调用示例：

---

### 二、快速入门：认证与基础调用
#### 1. 获取Token（核心前置步骤）
```python
import requests

auth_url = "http://jumpserver.carizon.work/api/v1/authentication/auth/"
headers = {"Content-Type": "application/json"}
data = {"username": "admin", "password": "your_password"}

response = requests.post(auth_url, json=data, headers=headers)
token = response.json().get('token')
print(f"Bearer Token: {token}")  # 后续请求需携带此Token
```

#### 2. 调用示例：查询当前用户信息
```python
profile_url = "http://jumpserver.carizon.work/api/v1/users/profile/"
headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

response = requests.get(profile_url, headers=headers)
print(response.json())  # 输出用户详细信息
```

---

### 三、核心功能接口详解
#### 1. 资产管理模块
| 接口功能     | API端点                     | 方法 | Python调用示例                                             |
| ------------ | --------------------------- | ---- | ---------------------------------------------------------- |
| 获取资产列表 | `/assets/assets/`           | GET  | `requests.get(url, headers=headers)`                       |
| 收藏资产     | `/assets/favorite-assets/`  | POST | `requests.post(url, json={"asset_id":1}, headers=headers)` |
| 查询资产类型 | `/assets/categories/types/` | GET  | `requests.get(url, headers=headers)`                       |

#### 2. 工单管理模块
```python
# 创建资产申请工单
ticket_url = "http://jumpserver.carizon.work/api/v1/tickets/apply-asset-tickets/"
data = {
    "apply_assets": [1,2],  # 资产ID列表
    "apply_nodes": [], 
    "reason": "运维调试需要"
}
response = requests.post(ticket_url, json=data, headers=headers)

# 审批工单（需管理员权限）
approve_url = f"{ticket_url}{ticket_id}/approve/"
requests.put(approve_url, headers=headers, json={"action": "approve"})
```

#### 3. 作业中心模块
```python
# 创建Ansible作业
job_url = "http://jumpserver.carizon.work/api/v1/ops/jobs/"
data = {
    "name": "批量更新服务",
    "playbook": "update_service.yml",
    "assets": [101, 102]
}
response = requests.post(job_url, json=data, headers=headers)

# 查看作业执行日志
log_url = f"/ops/ansible/job-execution/{job_id}/log/"
requests.get(log_url, headers=headers)
```

---

### 四、进阶功能参考
#### 1. 会话管理
```python
# 获取在线会话列表
sessions_url = "http://jumpserver.carizon.work/api/v1/terminal/sessions/online-info/"
response = requests.get(sessions_url, headers=headers)

# 强制终止会话
kill_url = "http://jumpserver.carizon.work/api/v1/terminal/tasks/kill-session-for-ticket/"
requests.post(kill_url, json={"session_id": "abcd1234"}, headers=headers)
```

#### 2. 审计日志
```python
# 查询登录日志
audit_url = "http://jumpserver.carizon.work/api/v1/audits/my-login-logs/"
params = {"date_from": "2025-02-20"}
response = requests.get(audit_url, headers=headers, params=params)
```

---

### 五、注意事项
1. **Token有效期**：默认12小时，过期需重新获取
2. **权限控制**：普通用户只能访问被授权的接口（RBAC模型）
3. **批量操作**：使用`bulk_update`等批量接口时注意事务处理
4. **错误处理**：建议添加try-except块：
```python
try:
    response = requests.get(url, headers=headers)
    response.raise_for_status()
except requests.exceptions.HTTPError as err:
    print(f"HTTP错误: {err}")
```

---

### 六、常见问题排查
| 现象               | 可能原因         | 解决方案            |
| ------------------ | ---------------- | ------------------- |
| 401 Unauthorized   | Token过期/无效   | 重新获取Token       |
| 403 Forbidden      | 权限不足         | 检查用户角色权限    |
| 404 Not Found      | 接口路径错误     | 核对Swagger文档路径 |
| 500 Internal Error | 请求参数格式错误 | 检查JSON数据结构    |

---

### 七、推荐学习路径
1. 从`/authentication/auth/`接口开始练习基础认证
2. 尝试资产管理相关接口（GET/POST操作）
3. 进阶使用作业中心实现自动化运维
4. 结合工单系统实现审批流程（需管理员账号）

> 更多详细参数说明建议直接查阅Swagger文档：`https://jumpserver.carizon.work/api/docs/`

---

### 附：安全建议
1. 敏感操作（如密码修改）建议启用MFA认证
2. Token需加密存储，避免泄露
3. 遵循最小权限原则分配API访问权限

通过结合上述示例和官方文档，即可快速实现JumpServer的自动化运维管理。建议从简单查询类接口入手，逐步过渡到工单审批、作业执行等复杂场景。