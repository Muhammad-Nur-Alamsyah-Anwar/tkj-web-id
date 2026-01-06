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

## DHCP Server

```bash
# Buat pool IP
/ip pool add name=dhcp-pool ranges=192.168.100.10-192.168.100.200

# Buat DHCP server
/ip dhcp-server add name=dhcp-lan interface=ether2 address-pool=dhcp-pool lease-time=1d disabled=no

# Konfigurasi network
/ip dhcp-server network add address=192.168.100.0/24 gateway=192.168.100.1 dns-server=8.8.8.8

# Lihat lease aktif
/ip dhcp-server lease print
```

## Firewall Filter

```bash
# Accept established connections
/ip firewall filter add chain=input connection-state=established,related action=accept

# Drop invalid
/ip firewall filter add chain=input connection-state=invalid action=drop

# Accept dari LAN
/ip firewall filter add chain=input in-interface=ether2 action=accept

# Drop dari WAN
/ip firewall filter add chain=input in-interface=ether1 action=drop comment="Drop dari WAN"

# Lihat semua rule
/ip firewall filter print
```

## Queue Simple (Bandwidth Management)

```bash
# Limit satu PC (2Mbps upload / 5Mbps download)
/queue simple add name=limit-pc01 target=192.168.100.11/32 max-limit=2M/5M

# Limit seluruh subnet LAN
/queue simple add name=limit-lan target=192.168.100.0/24 max-limit=10M/20M

# Lihat queue
/queue simple print
```

## VLAN

```bash
# Buat interface VLAN di ether2
/interface vlan add name=vlan10 vlan-id=10 interface=ether2 comment="VLAN Guru"
/interface vlan add name=vlan20 vlan-id=20 interface=ether2 comment="VLAN Siswa"

# Tambah IP di tiap VLAN
/ip address add address=192.168.10.1/24 interface=vlan10
/ip address add address=192.168.20.1/24 interface=vlan20

# DHCP per VLAN
/ip pool add name=pool-vlan10 ranges=192.168.10.10-192.168.10.100
/ip dhcp-server add name=dhcp-vlan10 interface=vlan10 address-pool=pool-vlan10 disabled=no
/ip dhcp-server network add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=8.8.8.8
```
