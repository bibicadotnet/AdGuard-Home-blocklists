# DNS ECS Support Analysis

## Tổng Quan

ECS (EDNS Client Subnet) cho phép DNS resolver chỉ định thông tin mạng con để giúp tăng tốc độ truyền dữ liệu từ các mạng phân phối nội dung (CDN). Thay vì gửi toàn bộ IP client, chỉ một phần của nó được gửi đi gọi là subnet.

---

## DNS Hỗ Trợ ECS

| DNS | IP |
|-----|-----|
| OpenDNS FamilyShield | 208.67.222.123 |
| DNSPod | 119.29.29.29 |
| Quad9 Secondary | 149.112.112.11 |
| Quad9 Primary | 9.9.9.11 |
| OpenDNS Primary | 208.67.222.222 |
| Google Secondary | 8.8.4.4 |
| Google Primary | 8.8.8.8 |
| ByteDance Primary | 180.184.1.1 |
| ByteDance Secondary | 180.184.2.2 |

---

## IP DNS Hỗ Trợ ECS

```
8.8.8.8
8.8.4.4
9.9.9.11
149.112.112.11
119.29.29.29
180.184.1.1
180.184.2.2
208.67.222.222
208.67.222.123
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
