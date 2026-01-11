---
title: Config Mikrotik
description: Snippet konfigurasi CLI Mikrotik untuk NAT, Firewall, DHCP, dan lebih banyak lagi.
---

# Cheat Sheet Konfigurasi Mikrotik

Kumpulan perintah CLI Mikrotik RouterOS yang sering dipakai di lapangan dan ujian.

## Konfigurasi Dasar

```bash
# Ganti nama router
/system identity set name=Router-TKJ

# Set IP address di interface LAN
/ip address add address=192.168.100.1/24 interface=ether2

# Default route ke ISP
/ip route add dst-address=0.0.0.0/0 gateway=192.168.1.1

# DNS
/ip dns set servers=8.8.8.8,1.1.1.1 allow-remote-requests=yes
```

## NAT Masquerade

```bash
# Internet sharing — semua traffic LAN keluar via ether1
/ip firewall nat add chain=srcnat action=masquerade out-interface=ether1 comment="NAT Internet"

# Verifikasi
/ip firewall nat print
```
