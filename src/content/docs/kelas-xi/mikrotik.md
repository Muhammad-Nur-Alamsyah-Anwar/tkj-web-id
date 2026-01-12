---
title: Mikrotik RouterOS
description: Tutorial lengkap Mikrotik untuk materi MTCNA — routing, firewall, hotspot, dan manajemen bandwidth.
---

# Mikrotik RouterOS — Kelas XI TKJ

Mikrotik RouterOS adalah sistem operasi berbasis Linux yang digunakan sebagai router. Sangat populer di Indonesia untuk ISP, warnet, dan sekolah.

## Pengenalan

### Cara Akses Mikrotik

| Metode | Port | Keterangan |
|--------|------|-----------|
| **Winbox** | 8291 | GUI tool Windows |
| **WebFig** | 80 | Web browser |
| **SSH** | 22 | Terminal remote |
| **Telnet** | 23 | Terminal (tidak aman) |

### Default Login

```
Username: admin
Password: (kosong)
IP default: 192.168.88.1
```

## Konfigurasi IP dan Routing

### Setup Internet Sharing

```bash
# Set IP WAN
/ip address add address=192.168.1.2/24 interface=ether1

# Set IP LAN
/ip address add address=192.168.100.1/24 interface=ether2

# Default route
/ip route add dst-address=0.0.0.0/0 gateway=192.168.1.1

# DNS
/ip dns set servers=8.8.8.8,1.1.1.1 allow-remote-requests=yes

# NAT masquerade
/ip firewall nat add chain=srcnat action=masquerade out-interface=ether1
```
