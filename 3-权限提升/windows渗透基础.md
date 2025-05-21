kali连Windows机器
```
sudo evil-winrm -i 192.168.56.110 -u username -p password
```


### 使用 `PowerShell` 命令查看端口监听情况

PowerShell 提供了更强大的命令和脚本功能，可以用来查看端口监听情况。

#### 使用 `Get-NetTCPConnection` 命令

```
Get-NetTCPConnection -State Listen
```

#### 使用 `Get-Process` 和 `Get-NetTCPConnection` 结合查看监听端口及其对应的进程名称

```
Get-NetTCPConnection -State Listen | foreach {
    $p = Get-Process -Id $_.OwningProcess
    $_ | Select-Object LocalAddress, LocalPort, @{Name="ProcessName";Expression={$p.Name}}
}


Get-NetTCPConnection | Select-Object LocalPort,OwningProcess,ProcessName | Format-Table
```

在 Windows 上，可以使用 PowerShell 查看端口监听情况以及对应的进程名称和进程 ID。以下是实现这一目标的步骤：

### 1. 使用 `Get-NetTCPConnection` 和 `Get-Process`

`Get-NetTCPConnection` 命令可以列出当前的 TCP 连接，然后通过 `Get-Process` 命令获取进程信息。

```powershell
# 获取所有监听的 TCP 连接
$tcpConnections = Get-NetTCPConnection -State Listen

# 遍历每个连接，获取对应的进程信息
$tcpConnections | ForEach-Object {
    $processId = $_.OwningProcess
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        LocalAddress = $_.LocalAddress
        LocalPort = $_.LocalPort
        ProcessId = $processId
        ProcessName = if ($process) { $process.Name } else { "N/A" }
    }
} | Format-Table -AutoSize
```

### 2. 使用 `netstat` 和 `Select-String`

你也可以使用 `netstat` 命令结合 `Select-String` 来获取监听端口和对应的进程信息：

```powershell
# 使用 netstat 获取监听端口和进程信息
$netstatOutput = netstat -ano | Select-String "LISTENING"

# 解析 netstat 输出
$netstatOutput | ForEach-Object {
    $columns = $_.ToString() -split '\s+'
    $localAddress = $columns[1]
    $processId = $columns[-1]
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        LocalAddress = $localAddress.Split(':')[0]
        LocalPort = $localAddress.Split(':')[1]
        ProcessId = $processId
        ProcessName = if ($process) { $process.Name } else { "N/A" }
    }
} | Format-Table -AutoSize
```

### 3. 使用 `Get-NetTCPConnection` 和 `Get-Process` 的简化版本

这是一个简化的脚本，直接结合了 `Get-NetTCPConnection` 和 `Get-Process`：

```powershell
# 获取所有监听的 TCP 连接
$tcpConnections = Get-NetTCPConnection -State Listen

# 获取所有进程信息
$processes = Get-Process

# 遍历每个连接，获取对应的进程信息
$tcpConnections | ForEach-Object {
    $process = $processes | Where-Object { $_.Id -eq $_.OwningProcess }
    [PSCustomObject]@{
        LocalAddress = $_.LocalAddress
        LocalPort = $_.LocalPort
        ProcessId = $_.OwningProcess
        ProcessName = if ($process) { $process.Name } else { "N/A" }
    }
} | Format-Table -AutoSize
```

通过这些命令和脚本，你可以轻松查看系统中监听端口的情况以及对应的进程名称和进程 ID。
