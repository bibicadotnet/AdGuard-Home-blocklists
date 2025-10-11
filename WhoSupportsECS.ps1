$ErrorActionPreference = 'SilentlyContinue'

Write-Host ""
Write-Host "DNS ECS Support Checker" -ForegroundColor Cyan
Write-Host "=======================" -ForegroundColor Cyan

# Get public IP
Write-Host "`n[1] Getting your public IP..." -ForegroundColor Yellow
$ip = (Invoke-WebRequest -Uri 'https://api.ipify.org' -UseBasicParsing).Content.Trim()
Write-Host "Your IP: $ip" -ForegroundColor Green
$prefix = $ip -replace '\.\d+$', ''

# DNS list: "Name,IP"
$dnsList = @(
    "BebasDNS Default,103.87.68.194"
    "BebasDNS Family,103.87.68.196"
    "ByteDance Public DNS Primary,180.184.1.1"
    "ByteDance Public DNS Secondary,180.184.2.2"
    "Cisco OpenDNS FamilyShield Primary,208.67.222.123"
    "Cisco OpenDNS FamilyShield Secondary,208.67.220.123"
    "Cisco OpenDNS Sandbox Primary,208.67.222.2"
    "Cisco OpenDNS Sandbox Secondary,208.67.220.2"
    "Cisco OpenDNS Standard Primary,208.67.222.222"
    "Cisco OpenDNS Standard Secondary,208.67.220.220"
    "Cloudflare DNS Malware + Adult Primary,1.1.1.3"
    "Cloudflare DNS Malware + Adult Secondary,1.0.0.3"
    "Cloudflare DNS Standard Primary,1.1.1.1"
    "Cloudflare DNS Standard Secondary,1.0.0.1"
    "Comodo Secure DNS Primary,8.26.56.26"
    "Comodo Secure DNS Secondary,8.20.247.20"
    "ControlD Block Malware,76.76.2.1"
    "ControlD Non-filtering Primary,76.76.2.0"
    "ControlD Non-filtering Secondary,76.76.10.0"
    "DNSForge Primary,176.9.93.198"
    "DNSPod Public DNS+,119.29.29.29"
    "LibreDNS,88.198.92.222"
    "Google DNS Primary,8.8.8.8"
    "Google DNS Secondary,8.8.4.4"
    "Quad9 DNS ECS Support Primary,9.9.9.11"
    "Quad9 DNS ECS Support Secondary,149.112.112.11"
    "Quad9 DNS Standard Primary,9.9.9.9"
    "Quad9 DNS Standard Secondary,149.112.112.112"
    "Quad9 DNS Unsecured Primary,9.9.9.10"
    "Quad9 DNS Unsecured Secondary,149.112.112.10"
    "Safe Surfer Secondary,104.197.28.121"
    "Surfshark DNS,194.169.169.169"
    "Verisign Public DNS Primary,64.6.64.6"
)

Write-Host "`n[2] Testing DNS servers..." -ForegroundColor Yellow
Write-Host ""

$fullSupport = @()
$semiSupport = @()
$noSupport = @()

foreach ($dns in $dnsList) {
    $parts = $dns -split ','
    $name = $parts[0]
    $server = $parts[1]

    Write-Host "Testing: $name ($server)" -ForegroundColor Gray

    # Quick ping check
    $null = ping.exe $server -n 1 -w 300 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [PING FAILED - Skipping]" -ForegroundColor Red
        $noSupport += @{ Name = $name; Server = $server }
        continue
    }

    # ECS tests
    $test1 = nslookup -type=TXT o-o.myaddr.l.google.com $server 2>$null | Out-String
    $pass1 = ($test1 -match 'edns0-client-subnet' -or $test1 -match '\becs\b') -and $test1 -match $prefix

    $test2 = nslookup -type=TXT whoami.ds.akahelp.net $server 2>$null | Out-String
    $pass2 = ($test2 -match '\becs\b' -or $test2 -match 'edns0-client-subnet') -and $test2 -match $prefix

    $test3 = nslookup -type=TXT whoami.cloudflare.com $server 2>$null | Out-String
    $pass3 = $test3 -match 'ecs_subnet' -and $test3 -match $prefix

    $passCount = @($pass1, $pass2, $pass3).Where({ $_ }).Count

    $t1 = if ($pass1) { "Google: OK" } else { "Google: NO" }
    $t2 = if ($pass2) { "Akamai: OK" } else { "Akamai: NO" }
    $t3 = if ($pass3) { "Cloudflare: OK" } else { "Cloudflare: NO" }
    Write-Host "  $t1 | $t2 | $t3" -ForegroundColor DarkGray

    if ($passCount -eq 3) {
        Write-Host "  Full ECS Support (3/3)" -ForegroundColor Green
        $fullSupport += @{ Name = $name; Server = $server }
    }
    elseif ($passCount -ge 1) {
        $providers = @()
        if ($pass1) { $providers += "Google" }
        if ($pass2) { $providers += "Akamai" }
        if ($pass3) { $providers += "Cloudflare" }
        $providerStr = $providers -join ", "
        Write-Host "  Partial ECS Support ($passCount/3: $providerStr)" -ForegroundColor Yellow
        $semiSupport += @{ Name = $name; Server = $server; Providers = $providerStr }
    }
    else {
        Write-Host "  No ECS Support (0/3)" -ForegroundColor Red
        $noSupport += @{ Name = $name; Server = $server }
    }
}

# Measure speed for ECS-capable DNS
Write-Host "`n[3] Measuring speed..." -ForegroundColor Yellow
$allECS = $fullSupport + $semiSupport
$pingResults = @()

foreach ($dns in $allECS) {
    $pings = Test-Connection -ComputerName $dns.Server -Count 3 -ErrorAction SilentlyContinue
    if ($pings) {
        $speed = [int](($pings | Measure-Object -Property ResponseTime -Average).Average)
        $isFull = $fullSupport | Where-Object { $_.Name -eq $dns.Name -and $_.Server -eq $dns.Server }
        $type = if ($isFull) { "Full" } else { "Partial" }
        $ecsSupport = if ($dns.Providers) {
            $dns.Providers
        } else {
            "Google, Akamai, Cloudflare"
        }
        $pingResults += [PSCustomObject]@{
            DNS        = $dns.Name
            IP         = $dns.Server
            Speed      = $speed
            Type       = $type
            ECSSupport = $ecsSupport
        }
    }
}

# ==============================
# DISPLAY FULL & PARTIAL ECS LISTS
# ==============================

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "ALL DNS WITH ECS SUPPORT" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Full ECS list
$fullResults = $pingResults | Where-Object { $_.Type -eq "Full" }
if ($fullResults) {
    Write-Host "`n[FULL ECS SUPPORT] (passes all 3):" -ForegroundColor Green
    $fullResults | Sort-Object Speed | Format-Table -Property `
        @{Name='DNS'; Expression={$_.DNS}},
        @{Name='IP'; Expression={$_.IP}},
        @{Name='Speed'; Expression={$_.Speed}},
        @{Name='ECS Support'; Expression={$_.ECSSupport}} -AutoSize
} else {
    Write-Host "`nNo DNS with Full ECS support." -ForegroundColor Gray
}

# Partial ECS list
$semiResults = $pingResults | Where-Object { $_.Type -eq "Partial" }
if ($semiResults) {
    Write-Host "`n[PARTIAL ECS SUPPORT] (passes 1-2):" -ForegroundColor Yellow
    $semiResults | Sort-Object Speed | Format-Table -Property `
        @{Name='DNS'; Expression={$_.DNS}},
        @{Name='IP'; Expression={$_.IP}},
        @{Name='Speed'; Expression={$_.Speed}},
        @{Name='ECS Support'; Expression={$_.ECSSupport}} -AutoSize
} else {
    Write-Host "`nNo DNS with Partial ECS support." -ForegroundColor Gray
}

# ==============================
# AUTOMATIC RANKING (Score-Based)
# ==============================

$trustedList = @(
    "Cloudflare", "Google", "Quad9", "OpenDNS", "AdGuard", "ControlD", "NextDNS"
)

$ranked = foreach ($dns in $pingResults) {
    # Skip untrusted brands
    $isTrusted = $trustedList | Where-Object { $dns.DNS -like "*$_*" }
    if (-not $isTrusted) { continue }

    # Only Full ECS qualifies
    if ($dns.Type -ne "Full") { continue }

    # Scoring: max 19 points
    $score = 7  # Trusted brand
    $score += 7 # Full ECS

    # Speed score
    if ($dns.Speed -le 20) { $score += 5 }
    elseif ($dns.Speed -le 50) { $score += 3 }
    elseif ($dns.Speed -le 100) { $score += 1 }

    [PSCustomObject]@{
        DNS   = $dns.DNS
        IP    = $dns.IP
        Score = $score
        Speed = $dns.Speed
    }
}

# Sort: highest score first, then lowest speed
$top = $ranked | Sort-Object -Property @{Expression='Score'; Descending=$true}, 'Speed' | Select-Object -First 3

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "TOP RECOMMENDED DNS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

if ($top) {
    for ($i = 0; $i -lt $top.Count; $i++) {
        $rank = $i + 1
        $item = $top[$i]
        Write-Host "  [$rank] $($item.DNS) ($($item.IP)) - $($item.Speed) ms (Score: $($item.Score)/19)" -ForegroundColor Green
    }
} else {
    Write-Host "  No trusted DNS with Full ECS support found." -ForegroundColor Red
}

Read-Host "`nPress Enter to exit"
