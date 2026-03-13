---
title: Cheat Sheet Konfigurasi MikroTik
description: Referensi cepat perintah CLI MikroTik RouterOS untuk konfigurasi jaringan TKJ
---

# Cheat Sheet Konfigurasi MikroTik RouterOS

Referensi cepat perintah CLI MikroTik RouterOS yang sering digunakan dalam praktik jaringan TKJ.

---

## Reset Konfigurasi

```bash
# Reset ke default (tanpa no-defaults akan load factory config)
/system reset-configuration no-defaults=yes

# Reset dan langsung keep-user
/system reset-configuration no-defaults=yes keep-users=yes
```

---

## Identity & Hostname

```bash
# Set nama router
/system identity set name=Router-TKJ

# Cek identity
/system identity print
```

---

## IP Address

```bash
# Tambah IP address
/ip address add address=192.168.1.1/24 interface=ether1

# Tambah IP di interface lain
/ip address add address=10.10.10.1/24 interface=ether2

# Lihat semua IP
/ip address print

# Hapus IP
/ip address remove [find address="192.168.1.1/24"]
```

---

## Default Gateway & Static Route

```bash
# Tambah default gateway
/ip route add gateway=192.168.0.1

# Static route ke network tertentu
/ip route add dst-address=172.16.0.0/24 gateway=192.168.1.2

# Lihat routing table
/ip route print
```

---

## NAT Masquerade (Internet Sharing)

```bash
# Masquerade untuk semua traffic keluar lewat ether1
/ip firewall nat add chain=srcnat action=masquerade out-interface=ether1

# Masquerade dengan src-address tertentu
/ip firewall nat add chain=srcnat src-address=192.168.1.0/24 action=masquerade out-interface=ether1

# Lihat NAT rules
/ip firewall nat print
```

---

## DHCP Server

```bash
# Step 1: Buat IP Pool
/ip pool add name=dhcp-pool ranges=192.168.1.100-192.168.1.200

# Step 2: Tambah DHCP Network
/ip dhcp-server network add address=192.168.1.0/24 gateway=192.168.1.1 dns-server=8.8.8.8,8.8.4.4

# Step 3: Buat DHCP Server
/ip dhcp-server add name=dhcp-ether2 interface=ether2 address-pool=dhcp-pool disabled=no

# Lihat DHCP leases
/ip dhcp-server lease print

# Hapus semua lease
/ip dhcp-server lease remove [find]
```

---

## DNS

```bash
# Set DNS server
/ip dns set servers=8.8.8.8,8.8.4.4

# Allow remote DNS requests
/ip dns set allow-remote-requests=yes

# Cek DNS settings
/ip dns print

# Static DNS entry
/ip dns static add name=server.local address=192.168.1.10
```

---

## Firewall Filter

```bash
# Drop invalid connections
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="drop invalid"

# Allow established & related
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="allow established"

# Allow traffic dari LAN ke internet
/ip firewall filter add chain=forward src-address=192.168.1.0/24 action=accept comment="allow LAN"

# Drop semua yang tidak diizinkan
/ip firewall filter add chain=forward action=drop comment="drop all"

# Protect router (input chain)
/ip firewall filter add chain=input connection-state=invalid action=drop
/ip firewall filter add chain=input connection-state=established,related action=accept
/ip firewall filter add chain=input in-interface=ether1 action=drop comment="block WAN input"

# Lihat firewall rules
/ip firewall filter print
```

---

## Hotspot

```bash
# Setup Hotspot wizard di interface
/ip hotspot setup

# Atau manual:
# Step 1: Set IP di interface hotspot
/ip address add address=192.168.2.1/24 interface=ether3

# Step 2: Buat DHCP untuk hotspot
/ip pool add name=hs-pool ranges=192.168.2.2-192.168.2.254
/ip dhcp-server add name=hs-dhcp interface=ether3 address-pool=hs-pool disabled=no
/ip dhcp-server network add address=192.168.2.0/24 gateway=192.168.2.1

# Step 3: Buat Hotspot
/ip hotspot add name=hotspot1 interface=ether3 address-pool=hs-pool disabled=no

# Tambah user hotspot
/ip hotspot user add name=siswa password=tkj2026 profile=default

# Lihat user aktif
/ip hotspot active print
```

---

## Bandwidth Management (Simple Queue)

```bash
# Limit bandwidth per IP
/queue simple add name=limit-pc1 target=192.168.1.10/32 max-limit=2M/2M

# Limit bandwidth per subnet
/queue simple add name=limit-lan target=192.168.1.0/24 max-limit=10M/10M

# Prioritas berbeda
/queue simple add name=guru target=192.168.1.20/32 max-limit=5M/5M priority=1/1
/queue simple add name=siswa target=192.168.1.0/24 max-limit=2M/2M priority=8/8

# Lihat queue
/queue simple print

# Lihat statistik
/queue simple print stats
```

---

## VLAN

```bash
# Tambah VLAN interface di ether1
/interface vlan add name=vlan10 vlan-id=10 interface=ether1
/interface vlan add name=vlan20 vlan-id=20 interface=ether1

# Tambah IP ke VLAN
/ip address add address=192.168.10.1/24 interface=vlan10
/ip address add address=192.168.20.1/24 interface=vlan20

# Lihat VLAN
/interface vlan print
```

---

## NTP Client

```bash
# Aktifkan NTP client
/system ntp client set enabled=yes primary-ntp=103.16.102.80 secondary-ntp=0.id.pool.ntp.org

# Cek NTP status
/system ntp client print

# Set timezone
/system clock set time-zone-name=Asia/Makassar
```

---

## Backup & Restore Konfigurasi

```bash
# Backup binary (tidak bisa dibaca)
/system backup save name=backup-tkj-2026

# Export konfigurasi ke file teks (bisa dibaca/edit)
/export file=config-tkj-2026

# Export ke terminal (tampil di layar)
/export

# Restore dari backup binary
/system backup load name=backup-tkj-2026.backup

# Import dari file teks
/import file=config-tkj-2026.rsc
```

---

## Tools & Diagnostics

```bash
# Ping
/tool ping 8.8.8.8 count=4

# Traceroute
/tool traceroute 8.8.8.8

# Bandwidth test antar router
/tool bandwidth-test address=192.168.1.2 direction=both

# Torch (monitor traffic real-time)
/tool torch interface=ether1

# Lihat resource penggunaan
/system resource print

# Lihat uptime
/system resource print | grep uptime
```

---

## Wireless (jika ada)

```bash
# Set mode dan SSID
/interface wireless set wlan1 mode=ap-bridge ssid=TKJ-WiFi band=2ghz-b/g/n

# Set security
/interface wireless security-profiles add name=secure authentication-types=wpa2-psk wpa2-pre-shared-key=password123

# Apply security ke interface
/interface wireless set wlan1 security-profile=secure

# Lihat wireless client
/interface wireless registration-table print
```

---

## Quick Reference

| Perintah | Fungsi |
|----------|--------|
| `/system identity print` | Lihat nama router |
| `/ip address print` | Lihat semua IP |
| `/ip route print` | Lihat routing table |
| `/ip firewall nat print` | Lihat NAT rules |
| `/ip dhcp-server lease print` | Lihat DHCP clients |
| `/interface print` | Lihat semua interface |
| `/system resource print` | Lihat resource CPU/RAM |
| `/log print` | Lihat log sistem |

<!-- rev: jan6 -->

<!-- rev: jan15 -->

<!-- rev: jan27 -->

<!-- update: 2026-01-30 -->

<!-- update: 2026-02-07 -->

<!-- rev: feb9 -->

<!-- update: 2026-02-18 -->

<!-- rev: feb19 -->

<!-- rev: feb27 -->

<!-- rev: mar6 -->

<!-- rev: mar13 -->
