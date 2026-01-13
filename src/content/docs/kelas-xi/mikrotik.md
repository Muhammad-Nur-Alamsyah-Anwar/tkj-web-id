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

## Firewall Filter

Chain yang tersedia di Mikrotik:
- **input** — traffic yang masuk ke router
- **forward** — traffic yang melewati router
- **output** — traffic yang keluar dari router

```bash
# Accept established/related
/ip firewall filter add chain=input connection-state=established,related action=accept

# Drop invalid
/ip firewall filter add chain=input connection-state=invalid action=drop

# Accept dari LAN
/ip firewall filter add chain=input in-interface=ether2 action=accept

# Accept ICMP
/ip firewall filter add chain=input protocol=icmp action=accept

# Drop dari WAN
/ip firewall filter add chain=input in-interface=ether1 action=drop
```
