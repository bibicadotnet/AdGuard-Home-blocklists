# DNS ECS Support Analysis

## Tổng Quan

ECS (EDNS Client Subnet) cho phép DNS resolver chỉ định thông tin mạng con để giúp tăng tốc độ truyền dữ liệu từ các mạng phân phối nội dung (CDN). Thay vì gửi toàn bộ IP client, chỉ một phần của nó được gửi đi gọi là subnet.

---

## Máy chủ DNS hỗ trợ ECS

- Danh sách này phân loại các máy chủ DNS công cộng dựa trên mức độ hỗ trợ **EDNS Client Subnet (ECS)**.

### HỖ TRỢ ECS ĐẦY ĐỦ  (Đạt cả 3: Google, Akamai, Cloudflare)

| DNS                                 | IP             | Hỗ trợ ECS                     |
|-------------------------------------|----------------|--------------------------------|
| DNSPod Public DNS+                  | 119.29.29.29   | Google, Akamai, Cloudflare     |
| Quad9 DNS ECS Support Secondary     | 149.112.112.11 | Google, Akamai, Cloudflare     |
| Quad9 DNS ECS Support Primary       | 9.9.9.11       | Google, Akamai, Cloudflare     |
| Google DNS Secondary                | 8.8.4.4        | Google, Akamai, Cloudflare     |
| Google DNS Primary                  | 8.8.8.8        | Google, Akamai, Cloudflare     |
| ByteDance Public DNS Primary        | 180.184.1.1    | Google, Akamai, Cloudflare     |
| ByteDance Public DNS Secondary      | 180.184.2.2    | Google, Akamai, Cloudflare     |

### HỖ TRỢ ECS MỘT PHẦN  (Chỉ đạt 1–2 trong số các nhà cung cấp trên)

| DNS                                  | IP             | Hỗ trợ ECS |
|--------------------------------------|----------------|------------|
| Cisco OpenDNS Standard Secondary     | 208.67.220.220 | Akamai     |
| Cisco OpenDNS Sandbox Secondary      | 208.67.220.2   | Akamai     |
| Cisco OpenDNS FamilyShield Primary   | 208.67.222.123 | Akamai     |
| Cisco OpenDNS FamilyShield Secondary | 208.67.220.123 | Akamai     |
| Cisco OpenDNS Sandbox Primary        | 208.67.222.2   | Akamai     |
| Cisco OpenDNS Standard Primary       | 208.67.222.222 | Akamai     |

## Xác minh ECS

- Tất cả các máy chủ gửi ECS khớp với địa chỉ IP của máy khách.

## Cách Kiểm Tra ECS

```cmd
nslookup -type=TXT o-o.myaddr.l.google.com 8.8.8.8
nslookup -type=TXT whoami.ds.akahelp.net 8.8.8.8
nslookup -type=TXT whoami.cloudflare.com 8.8.8.8
```

- Kết quả sẽ hiển thị:
  - `ip` - IP thực của bạn
  - `ecs` - Subnet IP mà DNS gửi đi phải là địa chỉ IP hiện tại mới là gửi ECS chính xác

## Lựa chọn DNS ECS tối ưu

- Chạy script PowerShell
```powershell
irm https://go.bibica.net/WhoSupportsECS | iex
```
---

## Cấu Hình AdGuard Home

1. Mở dashboard AdGuard Home
2. Vào Settings → DNS settings
3. Bật EDNS Client Subnet (ECS)
4. Đặt Upstream DNS thành một trong các server hỗ trợ ECS ở trên
