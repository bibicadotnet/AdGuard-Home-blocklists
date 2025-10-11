# --------------------
# Vietnam ECS Optimizer and Update Adguard Home ECS
# --------------------

# ===== CONFIGURATION SECTION =====
# Modify these variables to customize script behavior

# IP Configuration
$prefixList = @(24)
$testDomain = "drive.usercontent.google.com"
$dnsProvider = "https://dns.google/resolve"

# Performance Configuration
$dnsBatchSize = 10
$pingBatchSize = 10
$dnsTimeoutSec = 5
$pingCountPerServer = 2

# Adguard Home Configuration
$adguardUrl = "https://dns.bibica.net/control/dns_config"
$adguardUsername = "xxxxxxx"
$adguardPassword = 'xxxxxxxxxxxxxxxxxxxxx'

# Display Configuration
$showDetailedOutput = $true
$logToFile = $true
$logFilePath = "$PSScriptRoot\ecs_optimizer.log"

# ===== END OF CONFIGURATION SECTION =====

# Require Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& {`$PSCommandPath}`"" -Verb RunAs
    exit
}

Clear-Host
Write-Host "`nVietnam ECS Optimizer (Optimized)`n" -ForegroundColor Cyan

# Function để log output
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $output = "[$timestamp] [$Level] $Message"
    
    Write-Host $output
    
    if ($logToFile) {
        Add-Content -Path $logFilePath -Value $output
    }
}

# --------------------
# LẤY PUBLIC IP
# --------------------
try {
    $MyIP = (Invoke-RestMethod -Uri "https://api.ipify.org" -TimeoutSec $dnsTimeoutSec).Trim()
    Write-Log "Your IP: $MyIP" "INFO"
}
catch {
    $MyIP = "1.1.1.1"
    Write-Log "Using default IP: $MyIP" "WARNING"
}

# Combine public IP with custom IPs
$customIPsText = @"
$MyIP
38.60.253.0
103.186.65.0
218.100.14.0
218.100.10.0
218.100.60.0
103.252.0.0
115.146.120.0
115.165.160.0
119.82.128.0
202.134.16.0
203.171.16.0
103.21.148.0
124.158.0.0
101.99.0.0
103.9.196.0
113.20.96.0
183.91.0.0
203.205.0.0
45.122.232.0
103.216.72.0
1.52.0.0
103.35.64.0
103.39.92.0
113.22.0.0
113.23.0.0
118.68.0.0
144.48.20.0
183.80.0.0
183.81.0.0
203.191.8.0
210.245.0.0
42.112.0.0
43.239.148.0
58.186.0.0
113.52.32.0
49.246.128.0
49.246.192.0
103.238.68.0
203.128.240.0
103.238.72.0
202.60.104.0
101.96.12.0
113.61.108.0
111.91.232.0
103.19.164.0
45.125.208.0
103.53.252.0
45.121.24.0
103.235.208.0
112.109.88.0
182.237.20.0
119.17.192.0
202.151.160.0
210.86.224.0
101.53.0.0
119.15.176.0
119.17.224.0
202.151.168.0
210.86.232.0
101.96.64.0
119.15.160.0
103.249.100.0
112.78.0.0
125.253.112.0
45.117.164.0
112.197.0.0
27.2.0.0
103.200.60.0
116.118.0.0
180.93.0.0
203.196.24.0
221.121.0.0
221.133.0.0
103.141.176.0
103.205.96.0
61.14.236.0
103.84.76.0
115.72.0.0
117.0.0.0
125.234.0.0
171.224.0.0
203.113.128.0
220.231.64.0
27.64.0.0
116.96.0.0
125.212.128.0
125.214.0.0
203.190.160.0
203.162.0.0
203.210.128.0
221.132.0.0
113.160.0.0
123.16.0.0
203.160.0.0
222.252.0.0
14.160.0.0
14.224.0.0
221.132.30.0
221.132.32.0
103.17.88.0
180.148.0.0
45.118.136.0
117.103.192.0
103.233.48.0
45.124.88.0
103.196.236.0
45.127.252.0
61.28.224.0
202.74.58.0
202.59.252.0
103.9.80.0
103.37.32.0
103.109.36.0
202.55.132.0
175.106.0.0
103.246.104.0
103.109.28.0
103.53.228.0
202.124.204.0
202.130.36.0
103.57.104.0
103.216.112.0
103.104.116.0
103.221.220.0
45.252.248.0
103.106.224.0
103.252.252.0
45.251.112.0
103.9.4.0
103.56.168.0
203.201.56.0
103.108.100.0
103.39.96.0
103.238.212.0
45.117.76.0
103.237.96.0
103.48.80.0
45.124.84.0
103.121.88.0
103.30.36.0
103.7.172.0
103.75.180.0
103.219.180.0
103.48.188.0
103.221.228.0
45.252.240.0
103.232.52.0
103.79.140.0
103.3.248.0
45.120.228.0
103.81.80.0
103.102.20.0
103.98.160.0
103.129.88.0
103.10.44.0
203.160.132.0
103.238.80.0
47.117.156.0
103.243.104.0
103.63.104.0
45.122.248.0
103.63.108.0
45.122.252.0
103.63.112.0
45.122.244.0
103.63.116.0
45.122.240.0
103.63.120.0
45.122.236.0
103.68.252.0
103.74.120.0
103.104.24.0
103.221.224.0
45.252.244.0
103.1.200.0
203.79.28.0
103.255.84.0
45.119.76.0
103.192.236.0
203.77.178.0
103.216.128.0
103.238.208.0
27.0.240.0
103.119.84.0
103.23.144.0
45.118.140.0
103.18.176.0
103.254.12.0
45.117.172.0
103.109.40.0
103.101.76.0
49.156.52.0
103.196.248.0
103.20.144.0
202.43.108.0
103.195.236.0
103.115.166.0
103.213.122.0
103.7.177.0
103.95.196.0
103.242.52.0
103.82.196.0
103.63.212.0
45.123.96.0
103.52.92.0
103.45.228.0
103.89.88.0
103.100.160.0
202.4.168.0
103.79.144.0
103.205.104.0
103.130.220.0
111.65.240.0
180.148.128.0
103.227.216.0
103.47.192.0
45.125.236.0
103.99.252.0
103.78.84.0
103.226.248.0
103.9.200.0
103.74.100.0
223.27.104.0
103.199.8.0
59.153.216.0
103.199.16.0
183.91.160.0
110.35.72.0
103.116.104.0
103.245.148.0
27.118.16.0
45.126.92.0
202.4.176.0
103.254.16.0
103.205.100.0
103.9.212.0
103.60.16.0
45.119.216.0
202.52.39.0
103.206.216.0
103.103.116.0
103.111.244.0
103.81.84.0
103.98.152.0
103.88.112.0
103.88.116.0
103.45.236.0
103.24.244.0
202.191.56.0
202.94.88.0
103.254.216.0
45.119.108.0
103.107.200.0
103.211.212.0
103.70.28.0
103.8.13.0
103.3.252.0
45.121.160.0
103.77.168.0
103.82.20.0
103.82.24.0
103.75.184.0
103.17.236.0
103.220.68.0
103.38.136.0
103.68.72.0
103.108.132.0
120.50.184.0
182.161.80.0
203.176.160.0
202.9.79.0
103.92.16.0
202.87.212.0
103.5.30.0
103.124.56.0
103.225.236.0
103.206.212.0
137.59.116.0
103.221.86.0
202.9.80.0
103.56.160.0
103.245.248.0
58.84.0.0
103.255.236.0
61.14.232.0
103.97.124.0
103.66.152.0
103.48.192.0
45.119.212.0
103.237.144.0
45.118.144.0
103.27.236.0
45.119.80.0
103.15.48.0
103.235.212.0
103.237.148.0
103.238.76.0
203.167.12.0
103.98.148.0
103.68.68.0
103.88.108.0
103.12.104.0
103.95.168.0
103.16.0.0
103.99.228.0
103.53.88.0
103.199.76.0
137.59.44.0
103.199.64.0
137.59.28.0
103.199.20.0
59.153.220.0
103.199.24.0
59.153.224.0
103.199.28.0
59.153.228.0
103.199.32.0
59.153.232.0
103.199.36.0
59.153.240.0
103.199.44.0
59.153.244.0
103.199.52.0
59.153.248.0
103.199.48.0
59.153.252.0
103.199.56.0
137.59.32.0
103.199.60.0
137.59.36.0
103.199.68.0
137.59.24.0
103.199.72.0
137.59.40.0
202.6.2.0
103.9.84.0
103.13.76.0
182.236.112.0
103.89.120.0
103.207.32.0
103.94.176.0
103.109.32.0
103.245.252.0
103.28.36.0
45.117.80.0
103.57.208.0
45.117.176.0
103.112.124.0
103.248.164.0
103.54.248.0
116.212.32.0
103.82.28.0
103.28.136.0
103.31.120.0
103.90.228.0
103.200.120.0
121.50.172.0
103.62.8.0
45.121.152.0
202.9.84.0
103.77.160.0
103.129.84.0
103.196.244.0
103.107.180.0
103.100.228.0
202.0.79.0
103.68.248.0
103.101.32.0
103.7.196.0
103.10.88.0
103.26.252.0
103.250.24.0
103.21.120.0
116.193.64.0
120.72.96.0
202.78.224.0
120.72.80.0
210.2.64.0
103.18.4.0
137.59.104.0
150.95.104.0
150.95.112.0
150.95.16.0
163.44.192.0
163.44.200.0
163.44.204.0
103.253.88.0
103.117.244.0
116.68.128.0
103.237.60.0
103.140.40.0
202.58.245.0
103.61.48.0
103.99.244.0
103.241.248.0
203.99.248.0
103.231.148.0
122.102.112.0
103.5.204.0
103.117.240.0
103.223.4.0
45.254.32.0
103.239.116.0
103.69.192.0
103.228.20.0
202.59.238.0
103.77.164.0
103.131.72.0
110.44.184.0
103.106.220.0
103.114.104.0
103.82.36.0
103.9.204.0
103.82.32.0
203.161.178.0
103.1.236.0
103.7.40.0
112.213.80.0
27.0.12.0
45.117.168.0
103.74.116.0
103.226.108.0
103.248.160.0
103.4.128.0
103.9.0.0
103.48.76.0
103.42.56.0
202.143.108.0
103.214.8.0
103.5.208.0
103.37.28.0
103.56.164.0
202.37.86.0
103.92.24.0
103.108.136.0
103.199.4.0
103.113.80.0
203.8.127.0
103.195.240.0
103.232.56.0
103.89.84.0
103.129.80.0
103.2.220.0
103.237.64.0
45.125.204.0
202.134.54.0
103.243.216.0
203.34.144.0
103.221.212.0
103.56.156.0
45.124.92.0
103.53.168.0
43.239.220.0
103.3.244.0
103.216.120.0
157.119.244.0
103.74.112.0
103.27.60.0
45.122.220.0
103.232.120.0
103.92.28.0
103.10.212.0
103.68.80.0
103.11.172.0
103.234.36.0
43.239.224.0
103.113.88.0
202.44.137.0
103.68.76.0
103.239.120.0
45.119.240.0
103.229.192.0
103.232.60.0
103.7.36.0
202.172.4.0
203.170.26.0
45.126.96.0
103.129.188.0
103.200.20.0
103.207.36.0
103.216.124.0
157.119.248.0
103.239.32.0
103.9.76.0
146.196.64.0
110.35.64.0
119.18.128.0
203.191.48.0
103.31.124.0
103.68.240.0
202.6.96.0
183.90.160.0
103.75.176.0
103.28.172.0
103.104.120.0
103.90.220.0
103.220.84.0
103.196.16.0
103.111.236.0
103.9.156.0
112.137.128.0
103.88.120.0
103.90.224.0
103.20.148.0
45.118.148.0
202.74.56.0
103.110.84.0
103.254.40.0
103.99.0.0
103.68.244.0
103.57.112.0
103.199.12.0
103.227.112.0
118.107.64.0
119.18.184.0
43.239.188.0
103.116.100.0
112.72.64.0
45.125.200.0
103.27.64.0
103.1.208.0
115.84.176.0
210.211.96.0
45.117.160.0
203.189.28.0
118.102.0.0
120.138.64.0
122.201.8.0
49.213.64.0
202.160.124.0
103.101.160.0
103.90.232.0
103.92.32.0
103.97.132.0
103.57.220.0
202.92.4.0
"@

$allIPs = $customIPsText -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Select-Object -Unique

Write-Log "Total IPs to test: $($allIPs.Count)" "INFO"

# --------------------
# BƯỚC 1: COLLECT IPS FROM DNS ECS QUERIES (BATCH)
# --------------------
Write-Log "Step 1: Collecting all server IPs (batch DNS: $dnsBatchSize)..." "INFO"

$dnsQueries = @()
foreach ($ip in $allIPs) {
    $octets = $ip -split '\.'
    $subnet = "$($octets[0]).$($octets[1]).$($octets[2]).0"
    
    foreach ($prefix in $prefixList) {
        $dnsQueries += @{
            subnet = $subnet
            prefix = $prefix
        }
    }
}

Write-Log "Total DNS queries: $($dnsQueries.Count)" "INFO"

$batchCount = [Math]::Ceiling($dnsQueries.Count / $dnsBatchSize)
Write-Log "Total batches: $batchCount" "INFO"

$ecsMap = @{}
$uniqueServers = @()

for ($batchIdx = 0; $batchIdx -lt $batchCount; $batchIdx++) {
    $startIdx = $batchIdx * $dnsBatchSize
    $endIdx = [Math]::Min($startIdx + $dnsBatchSize - 1, $dnsQueries.Count - 1)
    $batch = $dnsQueries[$startIdx..$endIdx]
    
    Write-Host "Batch $($batchIdx + 1)/$batchCount (queries $($startIdx + 1)-$($endIdx + 1)):" -ForegroundColor Cyan
    
    $jobs = @()
    foreach ($query in $batch) {
        $jobs += Start-Job -ScriptBlock {
            param($subnet, $prefix, $testDomain, $dnsProvider, $dnsTimeoutSec)
            try {
                $queryUrl = "$dnsProvider`?name=$testDomain&type=A&edns_client_subnet=$subnet/$prefix"
                $dns = Invoke-RestMethod $queryUrl -TimeoutSec $dnsTimeoutSec -ErrorAction Stop
                if ($dns.Answer) {
                    return @{
                        subnet = $subnet
                        prefix = $prefix
                        serverIP = $dns.Answer[0].data
                        status = "success"
                    }
                }
            }
            catch {
                return @{
                    subnet = $subnet
                    prefix = $prefix
                    status = "error"
                }
            }
        } -ArgumentList $query.subnet, $query.prefix, $testDomain, $dnsProvider, $dnsTimeoutSec
    }
    
    $jobs | Wait-Job | Out-Null
    
    foreach ($job in $jobs) {
        $result = Receive-Job $job
        if ($result.status -eq "success") {
            Write-Host "  + $($result.subnet)/$($result.prefix) -> $($result.serverIP)" -ForegroundColor Green
            
            if (-not $ecsMap.ContainsKey($result.serverIP)) {
                $ecsMap[$result.serverIP] = @()
                $uniqueServers += $result.serverIP
            }
            if ($ecsMap[$result.serverIP] -notcontains $result.subnet) {
                $ecsMap[$result.serverIP] += $result.subnet
            }
        }
        else {
            Write-Host "  - $($result.subnet)/$($result.prefix) -> Error" -ForegroundColor Red
        }
    }
    $jobs | Remove-Job
}

Write-Log "Found $($uniqueServers.Count) unique servers" "INFO"
Write-Host ""

# --------------------
# BƯỚC 2: PING ALL SERVERS (BATCH)
# --------------------
Write-Log "Step 2: Ping all servers (batch ping: $pingBatchSize)..." "INFO"

$pingBatchCount = [Math]::Ceiling($uniqueServers.Count / $pingBatchSize)
Write-Log "Total batches: $pingBatchCount" "INFO"

$serverLatencies = @{}

for ($batchIdx = 0; $batchIdx -lt $pingBatchCount; $batchIdx++) {
    $startIdx = $batchIdx * $pingBatchSize
    $endIdx = [Math]::Min($startIdx + $pingBatchSize - 1, $uniqueServers.Count - 1)
    $batch = $uniqueServers[$startIdx..$endIdx]
    
    Write-Host "Batch $($batchIdx + 1)/$pingBatchCount (servers $($startIdx + 1)-$($endIdx + 1)):" -ForegroundColor Cyan
    
    $pingJobs = @()
    foreach ($server in $batch) {
        $pingJobs += Start-Job -ScriptBlock {
            param($server, $pingCountPerServer)
            try {
                $ping = Test-Connection $server -Count $pingCountPerServer -ErrorAction Stop
                $latency = [math]::Round(($ping.ResponseTime | Measure-Object -Average).Average, 1)
                return @{
                    IP = $server
                    Latency = $latency
                    status = "success"
                }
            }
            catch {
                return @{
                    IP = $server
                    Latency = 9999
                    status = "timeout"
                }
            }
        } -ArgumentList $server, $pingCountPerServer
    }
    
    $pingJobs | Wait-Job | Out-Null
    
    foreach ($job in $pingJobs) {
        $result = Receive-Job $job
        if ($result.status -eq "success") {
            Write-Host "  + $($result.IP) -> $($result.Latency)ms" -ForegroundColor Green
        }
        else {
            Write-Host "  - $($result.IP) -> Timeout" -ForegroundColor Red
        }
        $serverLatencies[$result.IP] = $result.Latency
    }
    $pingJobs | Remove-Job
}

Write-Host ""

# --------------------
# BƯỚC 3: TÌM SERVER NHANH NHẤT
# --------------------
Write-Log "Step 3: Finding fastest server..." "INFO"

$fastestServer = $serverLatencies.GetEnumerator() |
    Where-Object { $_.Value -lt 9999 } |
    Sort-Object Value |
    Select-Object -First 1

if ($fastestServer) {
    $bestServerIP = $fastestServer.Name
    $bestLatency = $fastestServer.Value
    $bestSubnets = $ecsMap[$bestServerIP]
    $bestSubnet = Get-Random -InputObject $bestSubnets
    
    Write-Log "Fastest Server: $bestServerIP ($($bestLatency)ms)" "INFO"
    Write-Log "Associated Subnets: $($bestSubnets -join ', ')" "INFO"
    Write-Log "Selected Subnet: $bestSubnet" "INFO"
    
    Write-Host "  Fastest Server: $bestServerIP" -ForegroundColor Green
    Write-Host "  Latency: $($bestLatency)ms" -ForegroundColor Green
    Write-Host "  Selected Subnet: $bestSubnet`n" -ForegroundColor Cyan
    
    # --------------------
    # BƯỚC 4: UPDATE ADGUARD HOME ECS
    # --------------------
    Write-Log "Step 4: Updating Adguard Home ECS..." "INFO"
    
    $userpass = "$($adguardUsername):$($adguardPassword)"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($userpass)
    $base64 = [Convert]::ToBase64String($bytes)

    $headers = @{
        Authorization = "Basic $base64"
        "Content-Type" = "application/json"
    }

    $body = @{
        edns_cs_enabled = $true
        edns_cs_use_custom = $true
        edns_cs_custom_ip = $bestSubnet
    } | ConvertTo-Json -Compress

    try {
        Invoke-RestMethod -Uri $adguardUrl `
            -Method POST `
            -Headers $headers `
            -Body $body

        Write-Log "Updated Adguard Home ECS with $bestSubnet" "INFO"
        Write-Host "Updated Adguard Home ECS with $bestSubnet" -ForegroundColor Green
    }
    catch {
        Write-Log "Failed to update: $($_.Exception.Message)" "ERROR"
        Write-Host "Failed to update: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Log "No reachable servers found!" "ERROR"
    Write-Host "No reachable servers found!" -ForegroundColor Red
    exit
}

Write-Log "Script completed successfully" "INFO"
Write-Host "`nDone!`n" -ForegroundColor Green
