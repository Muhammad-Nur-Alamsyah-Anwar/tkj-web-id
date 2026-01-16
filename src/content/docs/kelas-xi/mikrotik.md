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

## DHCP Server

```bash
# Buat pool IP
/ip pool add name=pool-lan ranges=192.168.100.10-192.168.100.200

# Buat DHCP server
/ip dhcp-server add name=dhcp-lan interface=ether2 address-pool=pool-lan disabled=no

# Konfigurasi network DHCP
/ip dhcp-server network add address=192.168.100.0/24 gateway=192.168.100.1 dns-server=8.8.8.8

# Lihat lease
/ip dhcp-server lease print

# Bind IP ke MAC (lease statis)
/ip dhcp-server lease add mac-address=AA:BB:CC:DD:EE:FF address=192.168.100.50
```

## Hotspot

Hotspot digunakan untuk autentikasi pengguna WiFi sebelum bisa akses internet.

```bash
# Jalankan wizard
/ip hotspot setup

# Buat profile user
/ip hotspot user profile add name=siswa rate-limit=2M/2M session-timeout=8h
/ip hotspot user profile add name=guru rate-limit=5M/10M

# Tambah user
/ip hotspot user add name=siswa01 password=12345 profile=siswa
/ip hotspot user add name=guru01 password=abcde profile=guru

# Monitor user aktif
/ip hotspot active print
```

## Bandwidth Management

### Simple Queue

```bash
# Limit per IP
/queue simple add name=pc01 target=192.168.100.11 max-limit=2M/5M

# Limit subnet
/queue simple add name=all-lan target=192.168.100.0/24 max-limit=20M/50M
```

### PCQ (Per Connection Queue)

PCQ membagi bandwidth merata untuk semua user.

```bash
# Buat queue type PCQ
/queue type add name=pcq-download kind=pcq pcq-classifier=dst-address
/queue type add name=pcq-upload kind=pcq pcq-classifier=src-address

# Terapkan
/queue simple add name=pcq-lan target=192.168.100.0/24 queue=pcq-upload/pcq-download max-limit=50M/100M
```

## Troubleshooting

```bash
# Ping & traceroute
/ping 8.8.8.8
/tool traceroute 8.8.8.8

# Monitor traffic
/interface monitor-traffic ether1
/tool torch interface=ether2

# Cek resource
/system resource print

# Log
/log print follow
```

## Sumber Belajar

- [Dokumentasi resmi MikroTik](https://help.mikrotik.com)
- [Forum MikroTik Indonesia](https://mikrotik.co.id/forum)
