$ErrorActionPreference = 'SilentlyContinue'
Write-Host ""
Write-Host "DNS ECS Support Checker (3-Test Verified)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`n[1] Getting your IP address..." -ForegroundColor Yellow
$ip = (Invoke-WebRequest -Uri 'https://api.ipify.org' -UseBasicParsing).Content.Trim()
Write-Host "Your IP: $ip" -ForegroundColor Green
$prefix = $ip -replace '\.\d+$', ''

$dnsList = @(
"114DNS Family Primary,114.114.114.110"
"114DNS Family Secondary,114.114.115.110"
"114DNS Normal Primary,114.114.114.114"
"114DNS Normal Secondary,114.114.115.115"
"114DNS Safe Primary,114.114.114.119"
"114DNS Safe Secondary,114.114.115.119"
"360 Secure DNS 1,101.226.4.6"
"360 Secure DNS 2,218.30.118.6"
"360 Secure DNS 3,123.125.81.6"
"360 Secure DNS 4,140.207.198.6"
"AhaDNS Los Angeles,45.67.219.208"
"AhaDNS Netherlands,5.2.75.75"
"Ali DNS Primary,223.5.5.5"
"Ali DNS Secondary,223.6.6.6"
"Arapurayil,3.7.156.128"
"ASTRACAT DNS,85.209.2.112"
"BebasDNS Default,103.87.68.194"
"BebasDNS Family,103.87.68.196"
"BlackMagicc DNS,103.70.12.129"
"ByteDance Public DNS Primary,180.184.1.1"
"ByteDance Public DNS Secondary,180.184.2.2"
"Caliph DNS,160.19.167.150"
"CIRA Canadian Shield Family Primary,149.112.121.30"
"CIRA Canadian Shield Family Secondary,149.112.122.30"
"CIRA Canadian Shield Private Primary,149.112.121.10"
"CIRA Canadian Shield Private Secondary,149.112.122.10"
"CIRA Canadian Shield Protected Primary,149.112.121.20"
"CIRA Canadian Shield Protected Secondary,149.112.122.20"
"Cisco OpenDNS FamilyShield Primary,208.67.222.123"
"Cisco OpenDNS FamilyShield Secondary,208.67.220.123"
"Cisco OpenDNS Sandbox Primary,208.67.222.2"
"Cisco OpenDNS Sandbox Secondary,208.67.220.2"
"Cisco OpenDNS Standard Primary,208.67.222.222"
"Cisco OpenDNS Standard Secondary,208.67.220.220"
"CleanBrowsing Adult Filter Primary,185.228.168.10"
"CleanBrowsing Adult Filter Secondary,185.228.169.11"
"CleanBrowsing Family Filter Primary,185.228.168.168"
"CleanBrowsing Family Filter Secondary,185.228.169.168"
"CleanBrowsing Security Filter Primary,185.228.168.9"
"CleanBrowsing Security Filter Secondary,185.228.169.9"
"Cloudflare DNS Malware + Adult Primary,1.1.1.3"
"Cloudflare DNS Malware + Adult Secondary,1.0.0.3"
"Cloudflare DNS Malware Only Primary,1.1.1.2"
"Cloudflare DNS Malware Only Secondary,1.0.0.2"
"Cloudflare DNS Standard Primary,1.1.1.1"
"Cloudflare DNS Standard Secondary,1.0.0.1"
"Comodo Secure DNS Primary,8.26.56.26"
"Comodo Secure DNS Secondary,8.20.247.20"
"Comss.one DNS Geo-bypass + Ads,195.133.25.16"
"Comss.one DNS Geo-bypass Primary,83.220.169.155"
"Comss.one DNS Geo-bypass Secondary,212.109.195.93"
"ControlD Block Malware + Ads + Social,76.76.2.3"
"ControlD Block Malware + Ads,76.76.2.2"
"ControlD Block Malware,76.76.2.1"
"ControlD Non-filtering Primary,76.76.2.0"
"ControlD Non-filtering Secondary,76.76.10.0"
"CZ.NIC ODVR Primary,193.17.47.1"
"CZ.NIC ODVR Secondary,185.43.135.1"
"DNS for Family Primary,94.130.180.225"
"DNS for Family Secondary,78.47.64.161"
"DNS.SB Primary,185.222.222.222"
"DNS.SB Secondary,45.11.45.11"
"DNS4EU Ad Blocking Primary,86.54.11.13"
"DNS4EU Ad Blocking Secondary,86.54.11.213"
"DNS4EU Child + Ads Primary,86.54.11.11"
"DNS4EU Child + Ads Secondary,86.54.11.211"
"DNS4EU Child Protection Primary,86.54.11.12"
"DNS4EU Child Protection Secondary,86.54.11.212"
"DNS4EU Protective Primary,86.54.11.1"
"DNS4EU Protective Secondary,86.54.11.201"
"DNS4EU Unfiltered Primary,86.54.11.100"
"DNS4EU Unfiltered Secondary,86.54.11.200"
"DNSForge Primary,176.9.93.198"
"DNSForge Secondary,176.9.1.117"
"DNSPod Public DNS+,119.29.29.29"
"DNSWatchGO Primary,54.174.40.213"
"DNSWatchGO Secondary,52.3.100.184"
"dns0.eu Primary,193.110.81.0"
"dns0.eu Secondary,185.253.5.0"
"DNSGuard Primary,179.61.253.223"
"DNSGuard Secondary,181.214.231.96"
"Dyn DNS Primary,216.146.35.35"
"Dyn DNS Secondary,216.146.36.36"
"Freenom World Primary,80.80.80.80"
"Freenom World Secondary,80.80.81.81"
"FutureDNS Germany,162.55.52.228"
"FutureDNS United States,5.161.67.176"
"Google DNS Primary,8.8.8.8"
"Google DNS Secondary,8.8.4.4"
"Hurricane Electric Public Recursor,74.82.42.42"
"ibksturm DNS,213.196.191.96"
"JupitrDNS,155.248.232.226"
"LibreDNS,88.198.92.222"
"Nawala Childprotection DNS Primary,180.131.144.144"
"Nawala Childprotection DNS Secondary,180.131.145.145"
"Neustar Business Secure Primary,156.154.70.4"
"Neustar Business Secure Secondary,156.154.71.4"
"Neustar Family Secure Primary,156.154.70.3"
"Neustar Family Secure Secondary,156.154.71.3"
"Neustar Reliability & Performance 1 Primary,156.154.70.1"
"Neustar Reliability & Performance 1 Secondary,156.154.71.1"
"Neustar Reliability & Performance 2 Primary,156.154.70.5"
"Neustar Reliability & Performance 2 Secondary,156.154.71.5"
"Neustar Threat Protection Primary,156.154.70.2"
"Neustar Threat Protection Secondary,156.154.71.2"
"OneDNS Block Primary,52.80.66.66"
"OneDNS Block Secondary,117.50.22.22"
"OneDNS Family Primary,117.50.60.30"
"OneDNS Family Secondary,52.80.60.30"
"OneDNS Pure Primary,117.50.10.10"
"OneDNS Pure Secondary,52.80.52.52"
"OpenNIC DNS,217.160.70.42"
"OSZX DNS,51.38.83.141"
"Privacy-First DNS Japan,172.104.93.80"
"Privacy-First DNS Singapore,174.138.21.128"
"PumpleX,51.38.82.198"
"Quad101 Primary,101.101.101.101"
"Quad101 Secondary,101.102.103.104"
"Quad9 DNS ECS Support Primary,9.9.9.11"
"Quad9 DNS ECS Support Secondary,149.112.112.11"
"Quad9 DNS Standard Primary,9.9.9.9"
"Quad9 DNS Standard Secondary,149.112.112.112"
"Quad9 DNS Unsecured Primary,9.9.9.10"
"Quad9 DNS Unsecured Secondary,149.112.112.10"
"Safe DNS Primary,195.46.39.39"
"Safe DNS Secondary,195.46.39.40"
"Safe Surfer Primary,104.155.237.225"
"Safe Surfer Secondary,104.197.28.121"
"Seby DNS,45.76.113.31"
"SkyDNS RU,193.58.251.251"
"Surfshark DNS,194.169.169.169"
"SWITCH DNS,130.59.31.248"
"UK DNS Privacy Project Primary,209.250.227.42"
"UK DNS Privacy Project Secondary,64.176.190.82"
"Verisign Public DNS Primary,64.6.64.6"
"Verisign Public DNS Secondary,64.6.65.6"
"Yandex DNS Basic Primary,77.88.8.8"
"Yandex DNS Basic Secondary,77.88.8.1"
"Yandex DNS Family Primary,77.88.8.3"
"Yandex DNS Family Secondary,77.88.8.7"
"Yandex DNS Safe Primary,77.88.8.88"
"Yandex DNS Safe Secondary,77.88.8.2"
)

Write-Host "`n[2] Testing DNS servers for ECS support (3 tests)..." -ForegroundColor Yellow
Write-Host "Total DNS to test: $($dnsList.Count)" -ForegroundColor Cyan
Write-Host ""

$fullSupport = @()
$semiSupport = @()
$noSupport = @()

foreach ($dns in $dnsList) {
    $parts = $dns -split ','
    $name = $parts[0]
    $server = $parts[1]
    
    Write-Host "Testing: $name ($server)" -ForegroundColor Gray
    
    # Test 1: Google ECS
    $test1 = nslookup -type=TXT o-o.myaddr.l.google.com $server 2>$null | Out-String
    $pass1 = ($test1 -match 'edns0-client-subnet' -or $test1 -match '\becs\b') -and $test1 -match $prefix
    
    # Test 2: Akamai ECS
    $test2 = nslookup -type=TXT whoami.ds.akahelp.net $server 2>$null | Out-String
    $pass2 = ($test2 -match '\becs\b' -or $test2 -match 'edns0-client-subnet') -and $test2 -match $prefix
    
    # Test 3: Cloudflare ECS
    $test3 = nslookup -type=TXT whoami.cloudflare.com $server 2>$null | Out-String
    $pass3 = $test3 -match 'ecs_subnet' -and $test3 -match $prefix
    
    # Count passed tests
    $passedTests = @($pass1, $pass2, $pass3) | Where-Object { $_ -eq $true }
    $passCount = $passedTests.Count
    
    # Show individual test results
    $t1 = if ($pass1) { "[OK]" } else { "[NO]" }
    $t2 = if ($pass2) { "[OK]" } else { "[NO]" }
    $t3 = if ($pass3) { "[OK]" } else { "[NO]" }
    
    Write-Host "  Google: $t1 | Akamai: $t2 | Cloudflare: $t3" -ForegroundColor DarkGray
    
    # Categorize based on passed tests
    if ($passCount -eq 3) {
        Write-Host "  >>> Full ECS Support (3/3 tests passed)" -ForegroundColor Green
        $fullSupport += @{ 
            Name = $name
            Server = $server
            PassCount = $passCount
        }
    }
    elseif ($passCount -ge 1) {
        $providers = @()
        if ($pass1) { $providers += "Google" }
        if ($pass2) { $providers += "Akamai" }
        if ($pass3) { $providers += "Cloudflare" }
        $providerStr = $providers -join ", "
        
        Write-Host "  >>> Semi ECS Support ($passCount/3 tests: $providerStr)" -ForegroundColor Yellow
        $semiSupport += @{ 
            Name = $name
            Server = $server
            PassCount = $passCount
            Providers = $providerStr
        }
    }
    else {
        Write-Host "  >>> No ECS Support (0/3 tests passed)" -ForegroundColor Red
        $noSupport += @{ 
            Name = $name
            Server = $server
            PassCount = 0
        }
    }
    Write-Host ""
}

# Summary
Write-Host "========================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host "Full ECS Support (3/3 tests): $($fullSupport.Count)" -ForegroundColor Green
Write-Host "Semi ECS Support (1-2/3 tests): $($semiSupport.Count)" -ForegroundColor Yellow
Write-Host "No ECS Support (0/3 tests): $($noSupport.Count)" -ForegroundColor Red
Write-Host ""

if ($fullSupport.Count -eq 0 -and $semiSupport.Count -eq 0) {
    Write-Host "No DNS servers with ECS support found!" -ForegroundColor Red
    Read-Host "`nPress Enter to exit"
    exit
}

# Combine Full and Semi for latency testing
$allECS = $fullSupport + $semiSupport

Write-Host "[3] Measuring latency for ECS-enabled DNS..." -ForegroundColor Yellow
Write-Host ""

$pingResults = @()
foreach ($dns in $allECS) {
    $ping = Test-Connection -ComputerName $dns.Server -Count 3 -ErrorAction SilentlyContinue
    if ($ping) {
        $avgMs = [int](($ping | Measure-Object -Property ResponseTime -Average).Average)
        $type = if ($fullSupport -contains $dns) { "Full" } else { "Semi" }
        $providers = if ($dns.Providers) { $dns.Providers } else { "All" }
        
        $pingResults += @{ 
            Ms = $avgMs
            Name = $dns.Name
            Server = $dns.Server
            Type = $type
            PassCount = $dns.PassCount
            Providers = $providers
        }
        Write-Host "Ping: $($dns.Name) - ${avgMs}ms [$type - $($dns.PassCount)/3]" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DNS with ECS Support (sorted by latency)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Full Support table
if ($pingResults | Where-Object { $_.Type -eq "Full" }) {
    Write-Host "FULL ECS SUPPORT (3/3 tests passed):" -ForegroundColor Green
    $fullTable = $pingResults | Where-Object { $_.Type -eq "Full" } | 
        Sort-Object -Property Ms | 
        Select-Object @{Name="DNS";Expression={$_.Name}}, 
                      @{Name="IP";Expression={$_.Server}}, 
                      @{Name="Avg Ping (ms)";Expression={$_.Ms}},
                      @{Name="Providers";Expression={$_.Providers}}
    $fullTable | Format-Table -AutoSize
}

# Semi Support table
if ($pingResults | Where-Object { $_.Type -eq "Semi" }) {
    Write-Host "SEMI ECS SUPPORT (1-2/3 tests passed):" -ForegroundColor Yellow
    $semiTable = $pingResults | Where-Object { $_.Type -eq "Semi" } | 
        Sort-Object -Property Ms | 
        Select-Object @{Name="DNS";Expression={$_.Name}}, 
                      @{Name="IP";Expression={$_.Server}}, 
                      @{Name="Avg Ping (ms)";Expression={$_.Ms}},
                      @{Name="Providers";Expression={$_.Providers}}
    $semiTable | Format-Table -AutoSize
}

Write-Host ""
Write-Host "Legend:" -ForegroundColor Cyan
Write-Host "  Google: o-o.myaddr.l.google.com" -ForegroundColor Gray
Write-Host "  Akamai: whoami.ds.akahelp.net" -ForegroundColor Gray
Write-Host "  Cloudflare: whoami.cloudflare.com" -ForegroundColor Gray
Write-Host ""
Write-Host "Recommendation: Use DNS with 3/3 tests passed for best ECS coverage" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
