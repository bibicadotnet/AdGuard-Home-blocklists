# DNS ECS Support Analysis

## Tổng Quan

ECS (EDNS Client Subnet) cho phép DNS resolver chỉ định thông tin mạng con để giúp tăng tốc độ truyền dữ liệu từ các mạng phân phối nội dung (CDN). Thay vì gửi toàn bộ IP client, chỉ một phần của nó được gửi đi gọi là subnet.

---

## DNS Hỗ Trợ ECS

| DNS | IP |
|-----|-----|
| ByteDance Public DNS Primary | 180.184.1.1 |
| ByteDance Public DNS Secondary | 180.184.2.2 |
| Cisco OpenDNS FamilyShield Primary | 208.67.222.123 |
| Cisco OpenDNS FamilyShield Secondary | 208.67.220.123 |
| Cisco OpenDNS Sandbox Primary | 208.67.222.2 |
| Cisco OpenDNS Sandbox Secondary | 208.67.220.2 |
| Cisco OpenDNS Standard Primary | 208.67.222.222 |
| Cisco OpenDNS Standard Secondary | 208.67.220.220 |
| DNSPod Public DNS+ | 119.29.29.29 |
| Google DNS Primary | 8.8.8.8 |
| Google DNS Secondary | 8.8.4.4 |
| Quad9 DNS ECS Support Primary | 9.9.9.11 |
| Quad9 DNS ECS Support Secondary | 149.112.112.11 |

---

## Xác minh ECS

- Tất cả các máy chủ ở trên đều gửi ECS khớp với địa chỉ IP của máy khách.

---

## DNS ECS thông dụng

```
8.8.8.8
8.8.4.4
9.9.9.11
149.112.112.11
208.67.222.123
208.67.220.123
208.67.222.2
208.67.220.2
208.67.222.222
208.67.220.220
```

---

## Cách Kiểm Tra ECS

```cmd
nslookup -type=TXT whoami.ds.akahelp.net 8.8.8.8
```

Kết quả sẽ hiển thị:
- `ip` - IP thực của bạn
- `ecs` - Subnet IP mà DNS gửi đi

---

## Cấu Hình AdGuard Home

1. Mở dashboard AdGuard Home
2. Vào Settings → DNS settings
3. Bật EDNS Client Subnet (ECS)
4. Đặt Upstream DNS thành một trong các server hỗ trợ ECS ở trên
