---
title: Tutorial MikroTik MTCNA Kelas XI
description: Panduan lengkap konfigurasi MikroTik RouterOS untuk siswa TKJ kelas XI - materi MTCNA
---

# Tutorial MikroTik RouterOS — Materi MTCNA Kelas XI

Panduan lengkap untuk memahami dan mengkonfigurasi MikroTik RouterOS sesuai kurikulum TKJ kelas XI dan silabus MTCNA.

---

## 1. Pengenalan RouterOS

### Apa itu MikroTik?
MikroTik adalah perusahaan dari Latvia yang memproduksi perangkat jaringan dan software RouterOS. RouterOS adalah sistem operasi berbasis Linux yang dirancang khusus untuk router.

### Fitur utama RouterOS:
- **Routing** — Static, OSPF, BGP, RIP
- **Switching** — VLAN, STP, Bonding
- **Wireless** — AP, Station, Bridge
- **Firewall** — Filter, NAT, Mangle
- **QoS** — Simple Queue, Queue Tree
- **VPN** — PPTP, L2TP, SSTP, OpenVPN, IPSec
- **Hotspot** — Portal login untuk WiFi publik

### Cara Akses RouterOS:
1. **Winbox** — GUI aplikasi Windows (paling mudah)
2. **WebFig** — GUI via browser (port 80/443)
3. **SSH** — Terminal via SSH (port 22)
4. **Telnet** — Terminal via Telnet (port 23, tidak aman)
5. **Console** — Kabel serial langsung ke router

### Level Lisensi:
| Level | Fitur | Harga |
|-------|-------|-------|
| 0 | Trial 24 jam | Gratis |
| 1 | Unlimited (fitur terbatas) | Gratis |
| 3 | ISP/WISP | Berbayar |
| 4 | Standar | Berbayar |
| 5 | Enterprise | Berbayar |
| 6 | Controller | Berbayar |

---

## 2. Interface dan IP Address

### Jenis Interface di MikroTik:
- **Ether** — Port Ethernet fisik (ether1, ether2, dst)
- **Wlan** — Wireless interface (wlan1, wlan2)
- **Bridge** — Interface virtual gabungan beberapa port
- **VLAN** — Virtual LAN interface
- **Loopback** — Interface loopback (lo)
- **PPPoE** — Interface DSL/PPPoE

### Konfigurasi IP Address:

```bash
# Lihat semua interface
/interface print

# Tambah IP ke ether1 (WAN)
/ip address add address=192.168.0.2/24 interface=ether1

# Tambah IP ke ether2 (LAN)
/ip address add address=192.168.1.1/24 interface=ether2

# Lihat IP yang sudah dikonfigurasi
/ip address print

# Ubah IP
/ip address set [find interface=ether2] address=192.168.10.1/24

# Hapus IP
/ip address remove [find interface=ether1]
```

### Tip Penting:
> Interface **ether1** biasanya digunakan sebagai **WAN** (ke internet/ISP)
> Interface **ether2** dan seterusnya sebagai **LAN** (ke client/switch)

---

## 3. Routing

### Jenis Routing:
1. **Connected Routes** — Otomatis saat IP dikonfigurasi
2. **Static Routes** — Dikonfigurasi manual oleh admin
3. **Dynamic Routes** — Dipelajari lewat protokol routing (OSPF, BGP)

### Static Route:

```bash
# Default route (0.0.0.0/0) ke gateway ISP
/ip route add dst-address=0.0.0.0/0 gateway=192.168.0.1

# Static route ke network lain lewat next-hop
/ip route add dst-address=10.0.0.0/24 gateway=192.168.1.2

# Lihat semua route
/ip route print

# Lihat hanya route aktif
/ip route print where active=yes
```

### Contoh Topologi Static Routing:

```
Internet
   |
[Router A] ether1: 192.168.0.2/24 (ke ISP, gateway: 192.168.0.1)
           ether2: 192.168.1.1/24 (ke LAN A)
           ether3: 10.0.0.1/30 (ke Router B)
               |
           [Router B] ether1: 10.0.0.2/30
                      ether2: 192.168.2.1/24 (ke LAN B)
```

Konfigurasi Router A:
```bash
/ip address add address=192.168.0.2/24 interface=ether1
/ip address add address=192.168.1.1/24 interface=ether2
/ip address add address=10.0.0.1/30 interface=ether3
/ip route add dst-address=0.0.0.0/0 gateway=192.168.0.1
/ip route add dst-address=192.168.2.0/24 gateway=10.0.0.2
```

Konfigurasi Router B:
```bash
/ip address add address=10.0.0.2/30 interface=ether1
/ip address add address=192.168.2.1/24 interface=ether2
/ip route add dst-address=0.0.0.0/0 gateway=10.0.0.1
/ip route add dst-address=192.168.1.0/24 gateway=10.0.0.1
```

---

## 4. NAT dan Firewall

### NAT (Network Address Translation)

NAT digunakan untuk menerjemahkan IP private ke IP public agar client di LAN bisa akses internet.

**Jenis NAT:**
- **Masquerade** — SNAT dinamis, IP source diganti IP interface WAN
- **Src-NAT** — SNAT dengan IP tujuan tetap
- **Dst-NAT** — Port forwarding dari WAN ke server internal

```bash
# Masquerade (paling umum digunakan)
/ip firewall nat add chain=srcnat action=masquerade out-interface=ether1

# Port forwarding (dst-nat) — forward port 80 ke web server internal
/ip firewall nat add chain=dstnat dst-port=80 protocol=tcp action=dst-nat to-addresses=192.168.1.10 to-ports=80

# Lihat NAT rules
/ip firewall nat print
```

### Firewall Filter

Firewall filter mengontrol paket yang melewati atau masuk ke router.

**Chain (rantai) firewall:**
- **input** — Paket yang **masuk ke router** sendiri
- **output** — Paket yang **keluar dari router** sendiri
- **forward** — Paket yang **melewati router** (dari client ke internet)

```bash
# Allow established & related connections
/ip firewall filter add chain=forward connection-state=established,related action=accept

# Allow new connections dari LAN ke WAN
/ip firewall filter add chain=forward src-address=192.168.1.0/24 out-interface=ether1 action=accept

# Drop invalid packets
/ip firewall filter add chain=forward connection-state=invalid action=drop

# Drop semua yang tidak diizinkan
/ip firewall filter add chain=forward action=drop

# Block akses ke situs tertentu
/ip firewall filter add chain=forward dst-address=xxx.xxx.xxx.xxx action=drop comment="block site"
```

### Firewall Mangle (Advanced)

```bash
# Mark connection untuk QoS
/ip firewall mangle add chain=prerouting src-address=192.168.1.0/24 action=mark-connection new-connection-mark=lan-conn

# Mark packet berdasarkan connection mark
/ip firewall mangle add chain=prerouting connection-mark=lan-conn action=mark-packet new-packet-mark=lan-pkt
```

---

## 5. DHCP Server

DHCP (Dynamic Host Configuration Protocol) memberikan IP address otomatis ke client.

### Komponen DHCP Server:
1. **IP Pool** — Range IP yang akan dibagikan
2. **DHCP Network** — Konfigurasi network (gateway, DNS, netmask)
3. **DHCP Server** — Service yang berjalan di interface

```bash
# Langkah 1: Buat IP Pool
/ip pool add name=pool-lan ranges=192.168.1.100-192.168.1.200

# Langkah 2: Konfigurasi DHCP Network
/ip dhcp-server network add \
  address=192.168.1.0/24 \
  gateway=192.168.1.1 \
  dns-server=8.8.8.8,8.8.4.4 \
  ntp-server=103.16.102.80

# Langkah 3: Aktifkan DHCP Server di interface
/ip dhcp-server add \
  name=dhcp-lan \
  interface=ether2 \
  address-pool=pool-lan \
  lease-time=1d \
  disabled=no

# Lihat DHCP leases (client yang sudah dapat IP)
/ip dhcp-server lease print

# Static lease (IP tetap untuk MAC tertentu)
/ip dhcp-server lease add \
  mac-address=AA:BB:CC:DD:EE:FF \
  address=192.168.1.50 \
  server=dhcp-lan
```

---

## 6. Hotspot Portal

Hotspot digunakan untuk membuat portal login WiFi (seperti di cafe atau sekolah).

### Cara Setup Hotspot:

```bash
# Cara mudah: gunakan wizard
/ip hotspot setup

# Ikuti prompt:
# - Pilih interface (misal: wlan1)
# - Local address of network: 192.168.2.1/24
# - Masquerade network: yes
# - Address pool: 192.168.2.2-192.168.2.100
# - Select certificate: none
# - SMTP server: 0.0.0.0
# - DNS servers: 8.8.8.8
# - DNS name: hotspot.tkj.local
# - Name of local hotspot user: admin
# - Password: admin123
```

### Manajemen User Hotspot:

```bash
# Tambah user
/ip hotspot user add name=siswa1 password=pass123

# Tambah user dengan limit
/ip hotspot user add name=guru1 password=guru123 limit-uptime=8h limit-bytes-total=1G

# Buat profile user
/ip hotspot user profile add name=siswa rate-limit=1M/2M shared-users=1
/ip hotspot user profile add name=guru rate-limit=5M/10M shared-users=1

# Tambah user dengan profile
/ip hotspot user add name=siswa2 password=tkj2026 profile=siswa

# Lihat user aktif
/ip hotspot active print

# Disconnect user
/ip hotspot active remove [find user=siswa1]
```

---

## 7. Bandwidth Management

### Simple Queue

Simple Queue adalah cara termudah membatasi bandwidth per IP atau subnet.

```bash
# Limit 1 IP address (2 Mbps download, 1 Mbps upload)
/queue simple add name=pc-01 target=192.168.1.10/32 max-limit=2M/1M

# Limit seluruh subnet
/queue simple add name=lan-limit target=192.168.1.0/24 max-limit=20M/10M

# Burst (boleh melebihi limit untuk waktu singkat)
/queue simple add \
  name=burst-test \
  target=192.168.1.10/32 \
  max-limit=2M/1M \
  burst-limit=4M/2M \
  burst-threshold=1M/512k \
  burst-time=10s/10s

# Lihat queue dan statistik
/queue simple print stats
```

### Queue Tree (Advanced)

Queue Tree lebih fleksibel, biasa digunakan untuk membagi bandwidth bersama (shared bandwidth).

```bash
# Buat parent queue (total bandwidth)
/queue tree add name=total-download parent=global max-limit=100M packet-mark=download-pkt
/queue tree add name=total-upload parent=global max-limit=50M packet-mark=upload-pkt

# Child queue untuk masing-masing client
/queue tree add name=client-download parent=total-download packet-mark=client1-download max-limit=10M
```

---

## 8. VPN Dasar (PPTP)

PPTP (Point-to-Point Tunneling Protocol) adalah protokol VPN yang mudah dikonfigurasi.

### PPTP Server:

```bash
# Aktifkan PPTP server
/interface pptp-server server set enabled=yes

# Buat user VPN
/ppp secret add name=vpnuser password=vpnpass service=pptp local-address=10.0.0.1 remote-address=10.0.0.2

# Tambah user kedua
/ppp secret add name=vpnuser2 password=vpnpass2 service=pptp local-address=10.0.0.1 remote-address=10.0.0.3

# Lihat koneksi PPTP aktif
/interface pptp-server print
```

### PPTP Client:

```bash
# Tambah PPTP client (untuk koneksi ke server VPN)
/interface pptp-client add \
  name=vpn-ke-kantor \
  connect-to=1.2.3.4 \
  user=vpnuser \
  password=vpnpass \
  disabled=no

# Lihat status koneksi
/interface pptp-client print
```

---

## 9. Tips Troubleshooting

### Cek Konektivitas:
```bash
# Ping dari router
/tool ping 8.8.8.8 count=4

# Traceroute
/tool traceroute 8.8.8.8 count=3

# Test DNS
/ip dns cache print
```

### Lihat Log:
```bash
# Semua log
/log print

# Filter log berdasarkan topic
/log print where topics~"dhcp"
/log print where topics~"firewall"

# Log real-time
/log print follow
```

### Monitor Traffic:
```bash
# Torch — monitor traffic real-time di interface
/tool torch interface=ether1

# Monitor interface stats
/interface monitor-traffic ether1 once
```

---

## 10. Rangkuman & Tips Ujian MTCNA

### Poin Penting MTCNA:
1. **Routing** — Pahami cara kerja routing table dan connected routes
2. **Firewall** — Bedakan chain input vs forward
3. **NAT** — Masquerade untuk internet sharing, dst-nat untuk port forward
4. **DHCP** — 3 komponen: pool, network, server
5. **Wireless** — Mode AP Bridge vs Station
6. **QoS** — Simple Queue lebih mudah, Queue Tree lebih fleksibel

### Urutan Konfigurasi yang Benar:
1. Set IP address di semua interface
2. Tambah default route ke ISP gateway
3. Aktifkan NAT masquerade
4. Setup DHCP server untuk LAN
5. Konfigurasi firewall filter
6. Test konektivitas

### Shortcut Penting:
- `Ctrl+Z` — Batalkan perubahan yang belum diapply
- `Tab` — Autocomplete perintah
- `?` — Bantuan perintah
- `..` — Kembali ke level sebelumnya
- `/` — Kembali ke root prompt

<!-- rev: jan7 -->

<!-- update: 2026-01-08 -->

<!-- update: 2026-01-14 -->

<!-- update: 2026-01-17 -->

<!-- rev: jan26 -->

<!-- rev: jan29 -->

<!-- rev: jan31 -->

<!-- rev: feb16 -->

<!-- update: 2026-02-21 -->

<!-- rev: feb26 -->
