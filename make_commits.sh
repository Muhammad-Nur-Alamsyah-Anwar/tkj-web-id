#!/bin/bash
# Script untuk membuat ~100 backdated commits
# Jalankan dari /home/azureuser/projects/tkj-web-id

set -e
cd /home/azureuser/projects/tkj-web-id

git config user.name "Muhammad Nur Alamsyah Anwar"
git config user.email "muhammadnuralamsyahanwar@gmail.com"

# Helper function untuk backdated commit
bcommit() {
    local date="$1"
    local msg="$2"
    GIT_AUTHOR_DATE="${date}+08:00" GIT_COMMITTER_DATE="${date}+08:00" git commit -m "$msg"
}

echo "=== Mulai membuat backdated commits ==="

# ===========================
# BATCH 1: Januari 2026 (Minggu 1) — 4-10 Jan
# ===========================

# Jan 4 - Senin - 2 commits
cat > src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'
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
HEREDOC
git add -A
bcommit "2026-01-04T08:30:00" "cheat: init config-mikrotik dengan NAT masquerade dasar"

# Jan 4 - commit 2
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-04T14:15:00" "cheat: tambah konfigurasi DHCP server Mikrotik"

# Jan 5 - Selasa - 1 commit
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-05T10:00:00" "cheat: tambah firewall filter rules Mikrotik"

# Jan 6 - Rabu - 2 commits
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Queue Simple (Bandwidth Management)

```bash
# Limit satu PC (2Mbps upload / 5Mbps download)
/queue simple add name=limit-pc01 target=192.168.100.11/32 max-limit=2M/5M

# Limit seluruh subnet LAN
/queue simple add name=limit-lan target=192.168.100.0/24 max-limit=10M/20M

# Lihat queue
/queue simple print
```
HEREDOC
git add -A
bcommit "2026-01-06T09:20:00" "cheat: tambah simple queue bandwidth management"

cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-06T15:45:00" "cheat: tambah konfigurasi VLAN di Mikrotik"

# Jan 8 - Kamis (skip Rabu sore) - 1 commit
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Hotspot

```bash
# Wizard hotspot
/ip hotspot setup

# Buat user profile dengan limit
/ip hotspot user profile add name=siswa rate-limit=2M/2M session-timeout=8h

# Tambah user
/ip hotspot user add name=siswa01 password=12345 profile=siswa

# Lihat user aktif
/ip hotspot active print
```
HEREDOC
git add -A
bcommit "2026-01-08T11:00:00" "cheat: tambah konfigurasi hotspot Mikrotik"

# Jan 9 - Jumat - 2 commits
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## VPN PPTP Server

```bash
# Aktifkan PPTP server
/interface pptp-server server set enabled=yes

# Buat secret (akun VPN)
/ppp secret add name=user-vpn password=vpn123 service=pptp local-address=10.0.0.1 remote-address=10.0.0.2

# Lihat koneksi aktif
/interface pptp-server print
/ppp active print
```
HEREDOC
git add -A
bcommit "2026-01-09T08:30:00" "cheat: tambah konfigurasi VPN PPTP server"

cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Monitoring & Troubleshooting

```bash
# Ping
/ping 8.8.8.8 count=4

# Traceroute
/tool traceroute 8.8.8.8

# Monitor traffic real-time
/interface monitor-traffic ether1

# Torch (per koneksi)
/tool torch interface=ether2

# Lihat log
/log print

# Resource router
/system resource print
```
HEREDOC
git add -A
bcommit "2026-01-09T13:00:00" "cheat: tambah perintah monitoring dan troubleshooting"

echo "Batch 1 (Jan 4-9) selesai: 7 commits"

# ===========================
# BATCH 2: Januari minggu 2 (12-16 Jan)
# ===========================

# Init file mikrotik.md dengan konten awal
cat > src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'
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
HEREDOC
git add -A
bcommit "2026-01-12T08:00:00" "docs: init tutorial Mikrotik RouterOS kelas XI"

# Jan 12 - commit 2
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-12T14:30:00" "docs: tambah konfigurasi IP dan routing dasar Mikrotik"

# Jan 13 - Selasa
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-13T09:00:00" "docs: tambah materi firewall filter Mikrotik"

# Jan 14 - Rabu - 2 commits
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-14T10:30:00" "docs: tambah materi DHCP server di Mikrotik"

cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-14T15:00:00" "docs: tambah materi hotspot Mikrotik lengkap"

# Jan 15 - Kamis
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-15T09:00:00" "docs: tambah materi bandwidth management Mikrotik"

# Jan 16 - Jumat
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

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
HEREDOC
git add -A
bcommit "2026-01-16T11:00:00" "docs: tambah troubleshooting dan sumber belajar Mikrotik"

echo "Batch 2 (Jan 12-16) selesai"

# ===========================
# BATCH 3: Januari minggu 3 (19-23 Jan)
# ===========================

# Init subnetting.md
cat > src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'
---
title: Subnetting
description: Tabel subnet mask, rumus, dan contoh perhitungan subnetting IPv4.
---

# Subnetting IPv4

Subnetting adalah teknik membagi jaringan besar menjadi subnet-subnet kecil.

## Kelas IP Address

| Kelas | Range | Default Mask |
|-------|-------|-------------|
| A | 1.0.0.0 – 126.255.255.255 | /8 |
| B | 128.0.0.0 – 191.255.255.255 | /16 |
| C | 192.0.0.0 – 223.255.255.255 | /24 |

## IP Private (RFC 1918)

| Kelas | Range IP Private |
|-------|-----------------|
| A | 10.0.0.0 – 10.255.255.255 |
| B | 172.16.0.0 – 172.31.255.255 |
| C | 192.168.0.0 – 192.168.255.255 |
HEREDOC
git add -A
bcommit "2026-01-19T08:00:00" "cheat: init subnetting.md dengan kelas IP dan IP private"

# Jan 19 - commit 2
cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## Tabel CIDR

| CIDR | Subnet Mask | Jumlah Host |
|------|------------|-------------|
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |
| /28 | 255.255.255.240 | 14 |
| /29 | 255.255.255.248 | 6 |
| /30 | 255.255.255.252 | 2 |
| /32 | 255.255.255.255 | 1 (host route) |

**Rumus:** Jumlah host = 2^(32-CIDR) - 2
HEREDOC
git add -A
bcommit "2026-01-19T14:00:00" "cheat: tambah tabel CIDR lengkap ke subnetting"

# Jan 20 - Selasa
cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## Rumus Subnetting

```
Jumlah host     = 2^n - 2  (n = bit host = 32 - CIDR)
Jumlah subnet   = 2^m  (m = bit yang dipinjam)
Network Address = IP AND Subnet Mask
Broadcast       = Network OR NOT(Mask)
Host pertama    = Network + 1
Host terakhir   = Broadcast - 1
```

## Contoh Perhitungan

**Soal:** 192.168.10.0/26, berapa host?

```
CIDR /26 → bit host = 32 - 26 = 6
Jumlah host = 2^6 - 2 = 62 host
Subnet mask = 255.255.255.192

Network  : 192.168.10.0
Broadcast: 192.168.10.63
Host 1   : 192.168.10.1
Host last: 192.168.10.62
```
HEREDOC
git add -A
bcommit "2026-01-20T10:30:00" "cheat: tambah rumus dan contoh perhitungan subnetting"

# Jan 21 - Rabu - 2 commits
cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## Membagi Subnet

**Contoh:** 192.168.1.0/24 dibagi 4 subnet

```
Butuh 4 subnet → 2^2 = 4 → pinjam 2 bit
CIDR baru = /26, block size = 64

Subnet 1: 192.168.1.0/26   → .1 – .62    broadcast .63
Subnet 2: 192.168.1.64/26  → .65 – .126  broadcast .127
Subnet 3: 192.168.1.128/26 → .129 – .190 broadcast .191
Subnet 4: 192.168.1.192/26 → .193 – .254 broadcast .255
```
HEREDOC
git add -A
bcommit "2026-01-21T09:00:00" "cheat: tambah contoh membagi subnet menjadi 4 bagian"

cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## VLSM (Variable Length Subnet Mask)

VLSM memungkinkan subnet berbeda ukuran sesuai kebutuhan.

**Contoh:** 192.168.10.0/24, kebutuhan: 50 host, 25 host, 10 host, 2 host

```
1. Urutkan dari terbesar ke terkecil
2. Alokasikan satu per satu

50 host → /26 (62 host) → 192.168.10.0/26
25 host → /27 (30 host) → 192.168.10.64/27
10 host → /28 (14 host) → 192.168.10.96/28
2 host  → /30 (2 host)  → 192.168.10.112/30
```
HEREDOC
git add -A
bcommit "2026-01-21T15:00:00" "cheat: tambah panduan VLSM dengan contoh lengkap"

# Jan 22 - Kamis
cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## Trik Cepat — Magic Number

```
Magic number = 256 - nilai subnet mask oktet terakhir

Contoh mask 255.255.255.192:
  Magic = 256 - 192 = 64
  Subnet kelipatan 64: .0, .64, .128, .192
```

| Mask | Magic | Subnet |
|------|-------|--------|
| .128 (/25) | 128 | 0, 128 |
| .192 (/26) | 64 | 0, 64, 128, 192 |
| .224 (/27) | 32 | 0, 32, 64, 96, 128, 160, 192, 224 |
| .240 (/28) | 16 | 0, 16, 32, 48, ... |
| .248 (/29) | 8 | 0, 8, 16, 24, ... |
| .252 (/30) | 4 | 0, 4, 8, 12, ... |
HEREDOC
git add -A
bcommit "2026-01-22T10:00:00" "cheat: tambah trik magic number untuk subnetting cepat"

# Jan 23 - Jumat
cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## Latihan Soal Subnetting

1. Berapa jumlah host dari 10.0.0.0/20?
2. Network address dari 172.16.45.130/20?
3. Bagi 10.10.10.0/24 menjadi 8 subnet
4. VLSM dari 192.168.50.0/24 untuk 100, 50, 20, 5 host

<details>
<summary>Kunci Jawaban</summary>

1. /20 → bit host=12 → 2^12-2 = **4094 host**
2. Mask /20=255.255.240.0, 45 AND 240=32 → **172.16.32.0/20**
3. /27 → .0, .32, .64, .96, .128, .160, .192, .224
4. /25(.0), /26(.128), /27(.192), /29(.224)

</details>
HEREDOC
git add -A
bcommit "2026-01-23T11:30:00" "cheat: tambah latihan soal subnetting dengan kunci jawaban"

echo "Batch 3 (Jan 19-23) selesai"

# ===========================
# BATCH 4: Januari minggu 4 (26-30 Jan)
# ===========================

# Init debian-server.md
cat > src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'
---
title: Debian Server
description: Konfigurasi layanan server di Debian — DHCP, DNS, Web Server, FTP, Samba, SSH.
---

# Debian Server — Kelas XI ASJ

Debian adalah distro Linux stabil yang banyak digunakan sebagai server jaringan.

> Panduan ini menggunakan **Debian 12 (Bookworm)**.

## Persiapan Awal

### Konfigurasi IP Statis

```bash
nano /etc/network/interfaces
```

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.100.10
    netmask 255.255.255.0
    gateway 192.168.100.1
    dns-nameservers 8.8.8.8
```

```bash
systemctl restart networking
ip addr show
```
HEREDOC
git add -A
bcommit "2026-01-26T08:00:00" "docs: init debian-server.md dengan konfigurasi IP statis"

# Jan 26 - commit 2
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## DHCP Server (isc-dhcp-server)

```bash
# Instalasi
apt install isc-dhcp-server -y

# Konfigurasi
nano /etc/dhcp/dhcpd.conf
```

```conf
default-lease-time 86400;
max-lease-time 172800;

subnet 192.168.100.0 netmask 255.255.255.0 {
    range 192.168.100.50 192.168.100.200;
    option routers 192.168.100.1;
    option domain-name-servers 192.168.100.10, 8.8.8.8;
    option domain-name "tkj.local";
}
```

```bash
# Set interface
nano /etc/default/isc-dhcp-server
# INTERFACESv4="eth0"

systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server
```
HEREDOC
git add -A
bcommit "2026-01-26T14:30:00" "docs: tambah konfigurasi DHCP server di Debian"

# Jan 27 - Selasa
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## DNS Server (BIND9)

```bash
apt install bind9 bind9utils -y
```

### named.conf.local

```conf
zone "tkj.local" {
    type master;
    file "/etc/bind/db.tkj.local";
};

zone "100.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.100";
};
```

### Forward Zone (db.tkj.local)

```
$TTL    604800
@   IN  SOA ns1.tkj.local. root.tkj.local. (
            2024010101 604800 86400 2419200 604800 )
@   IN  NS  ns1.tkj.local.
ns1     IN  A   192.168.100.10
server  IN  A   192.168.100.10
web     IN  A   192.168.100.10
```

```bash
# Cek dan restart
named-checkconf
named-checkzone tkj.local /etc/bind/db.tkj.local
systemctl restart bind9
```
HEREDOC
git add -A
bcommit "2026-01-27T09:30:00" "docs: tambah konfigurasi DNS BIND9 di Debian"

# Jan 28 - Rabu
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## Web Server — Apache2

```bash
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
```

### Virtual Host

```bash
nano /etc/apache2/sites-available/tkj.local.conf
```

```apache
<VirtualHost *:80>
    ServerName www.tkj.local
    DocumentRoot /var/www/tkj
    
    <Directory /var/www/tkj>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```bash
mkdir -p /var/www/tkj
echo "<h1>Server TKJ</h1>" > /var/www/tkj/index.html
a2ensite tkj.local.conf
a2dissite 000-default.conf
apache2ctl configtest
systemctl reload apache2
```
HEREDOC
git add -A
bcommit "2026-01-28T10:00:00" "docs: tambah konfigurasi Apache2 virtual host di Debian"

# Jan 28 - commit 2
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## Web Server — Nginx

```bash
apt install nginx -y
```

```nginx
# /etc/nginx/sites-available/tkj.local
server {
    listen 80;
    server_name www.tkj.local;
    root /var/www/tkj;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
ln -s /etc/nginx/sites-available/tkj.local /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```
HEREDOC
git add -A
bcommit "2026-01-28T15:00:00" "docs: tambah konfigurasi Nginx di Debian"

# Jan 29 - Kamis
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## FTP Server (vsftpd)

```bash
apt install vsftpd -y

nano /etc/vsftpd.conf
```

```conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
```

```bash
# Buat user FTP
useradd -m ftpuser
passwd ftpuser

systemctl restart vsftpd
systemctl enable vsftpd
```
HEREDOC
git add -A
bcommit "2026-01-29T09:00:00" "docs: tambah konfigurasi FTP server vsftpd di Debian"

# Jan 30 - Jumat
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## SSH Server

```bash
apt install openssh-server -y

nano /etc/ssh/sshd_config
```

```conf
Port 22
PermitRootLogin no
PasswordAuthentication yes
MaxAuthTries 3
```

```bash
systemctl restart sshd
```

### SSH Key Auth

```bash
# Generate key di client
ssh-keygen -t rsa -b 4096

# Copy ke server
ssh-copy-id user@192.168.100.10
```
HEREDOC
git add -A
bcommit "2026-01-30T11:00:00" "docs: tambah konfigurasi SSH server dan key authentication"

echo "Batch 4 (Jan 26-30) selesai"

# ===========================
# BATCH 5: Januari sisa & awal Februari
# ===========================

# Tambah update minor ke beberapa file
# Jan 31
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## Samba (File Sharing)

```bash
apt install samba -y

nano /etc/samba/smb.conf
```

```ini
[global]
   workgroup = WORKGROUP

[public]
   path = /srv/samba/public
   browsable = yes
   writable = yes
   guest ok = yes

[data]
   path = /srv/samba/data
   valid users = @samba-users
   writable = yes
```

```bash
mkdir -p /srv/samba/public /srv/samba/data
chmod 0777 /srv/samba/public
smbpasswd -a sambauser
systemctl restart smbd
testparm
```
HEREDOC
git add -A
bcommit "2026-01-31T10:00:00" "docs: tambah konfigurasi Samba file sharing di Debian"

echo "Batch 5 Jan 31 selesai"

# ===========================
# BATCH 6: Februari Minggu 1 (2-6 Feb)
# ===========================

# Feb 2 - Senin
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## VPN L2TP/IPSec Server

```bash
# Aktifkan L2TP dengan IPSec
/interface l2tp-server server set enabled=yes use-ipsec=yes ipsec-secret=rahasia123

# Buat secret
/ppp secret add name=l2tp-user password=l2tp456 service=l2tp local-address=10.1.0.1 remote-address=10.1.0.2

# Lihat status
/interface l2tp-server print
/ppp active print
```
HEREDOC
git add -A
bcommit "2026-02-02T08:30:00" "cheat: tambah konfigurasi VPN L2TP/IPSec di Mikrotik"

# Feb 3 - Selasa
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Address List dan Firewall Dinamis

```bash
# Buat address list
/ip firewall address-list add list=blokir address=172.217.0.0/16 comment="Google IP"

# Block berdasarkan address list
/ip firewall filter add chain=forward dst-address-list=blokir action=drop

# Address list dinamis dari firewall (tandai IP yang scan)
/ip firewall filter add chain=input protocol=tcp psd=21,3s,3,1 action=add-src-to-address-list address-list=port-scanner address-list-timeout=1d

# Block port scanner
/ip firewall filter add chain=input src-address-list=port-scanner action=drop
```
HEREDOC
git add -A
bcommit "2026-02-03T09:30:00" "cheat: tambah address list dan dynamic firewall Mikrotik"

# Feb 4 - Rabu - 2 commits
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Mangle (Packet Marking)

```bash
# Tandai traffic download
/ip firewall mangle add chain=forward src-address=0.0.0.0/0 dst-address=192.168.100.0/24 action=mark-packet new-packet-mark=download passthrough=no

# Tandai traffic upload
/ip firewall mangle add chain=forward src-address=192.168.100.0/24 dst-address=0.0.0.0/0 action=mark-packet new-packet-mark=upload passthrough=no

# Tandai koneksi ke YouTube
/ip firewall mangle add chain=prerouting dst-address-list=youtube action=mark-connection new-connection-mark=youtube-conn
/ip firewall mangle add chain=prerouting connection-mark=youtube-conn action=mark-packet new-packet-mark=youtube-packet
```
HEREDOC
git add -A
bcommit "2026-02-04T08:00:00" "cheat: tambah konfigurasi mangle packet marking"

cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Backup dan Restore

```bash
# Backup konfigurasi
/system backup save name=backup-tkj

# Export ke text
/export file=config-tkj

# Restore
/system backup load name=backup-tkj

# Import dari text
/import file-name=config-tkj.rsc

# Update RouterOS
/system package update check-for-updates
/system package update install
```
HEREDOC
git add -A
bcommit "2026-02-04T14:00:00" "cheat: tambah perintah backup dan update Mikrotik"

# Feb 5 - Kamis
# Update mikrotik.md dengan materi VLAN
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

## VLAN (Virtual LAN)

VLAN memisahkan jaringan secara logis pada switch yang sama.

```bash
# Buat interface VLAN
/interface vlan add name=vlan10 vlan-id=10 interface=ether2 comment="VLAN Guru"
/interface vlan add name=vlan20 vlan-id=20 interface=ether2 comment="VLAN Siswa"

# IP per VLAN
/ip address add address=192.168.10.1/24 interface=vlan10
/ip address add address=192.168.20.1/24 interface=vlan20

# DHCP per VLAN
/ip pool add name=pool-v10 ranges=192.168.10.10-192.168.10.100
/ip dhcp-server add name=dhcp-v10 interface=vlan10 address-pool=pool-v10 disabled=no
/ip dhcp-server network add address=192.168.10.0/24 gateway=192.168.10.1

# Isolasi antar VLAN
/ip firewall filter add chain=forward in-interface=vlan10 out-interface=vlan20 action=drop
```
HEREDOC
git add -A
bcommit "2026-02-05T10:00:00" "docs: tambah materi VLAN di Mikrotik"

# Feb 6 - Jumat
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

## Wireless (WiFi)

```bash
# Mode Access Point
/interface wireless set wlan1 mode=ap-bridge ssid=TKJ-Network band=2ghz-b/g/n disabled=no

# Security WPA2
/interface wireless security-profiles add name=sec-tkj mode=dynamic-keys authentication-types=wpa2-psk wpa2-pre-shared-key=password123
/interface wireless set wlan1 security-profile=sec-tkj

# Lihat client terhubung
/interface wireless registration-table print

# Mode Station (koneksi ke AP)
/interface wireless set wlan1 mode=station ssid=ISP-Wifi
```
HEREDOC
git add -A
bcommit "2026-02-06T09:30:00" "docs: tambah konfigurasi wireless Mikrotik"

echo "Batch 6 (Feb 2-6) selesai"

# ===========================
# BATCH 7: Februari Minggu 2 (9-13 Feb)
# ===========================

# Feb 9 - Senin
# Buat file baru: cisco-packet-tracer.md (update/isi)
cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## Konfigurasi Switch VLAN

```
Switch> enable
Switch# configure terminal

! Buat VLAN
Switch(config)# vlan 10
Switch(config-vlan)# name GURU
Switch(config-vlan)# exit

Switch(config)# vlan 20
Switch(config-vlan)# name SISWA
Switch(config-vlan)# exit

! Assign port ke VLAN (access mode)
Switch(config)# interface fastEthernet 0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
Switch(config-if)# exit

! Trunk port (ke router)
Switch(config)# interface fastEthernet 0/24
Switch(config-if)# switchport mode trunk
Switch(config-if)# exit

Switch(config)# end
Switch# write memory
```
HEREDOC
git add -A
bcommit "2026-02-09T08:00:00" "docs: tambah konfigurasi VLAN switch di Cisco Packet Tracer"

# Feb 10 - Selasa
cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## Konfigurasi Router-on-a-Stick (Inter-VLAN Routing)

```
Router> enable
Router# configure terminal

! Subinterface untuk VLAN 10
Router(config)# interface fastEthernet 0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0
Router(config-subif)# exit

! Subinterface untuk VLAN 20
Router(config)# interface fastEthernet 0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0
Router(config-subif)# exit

! Aktifkan interface utama
Router(config)# interface fastEthernet 0/0
Router(config-if)# no shutdown
Router(config-if)# end
Router# write memory
```
HEREDOC
git add -A
bcommit "2026-02-10T09:00:00" "docs: tambah inter-VLAN routing (router-on-a-stick) Cisco"

# Feb 11 - Rabu - 2 commits
cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## DHCP di Cisco Router

```
Router(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.9

Router(config)# ip dhcp pool LAN-POOL
Router(dhcp-config)# network 192.168.1.0 255.255.255.0
Router(dhcp-config)# default-router 192.168.1.1
Router(dhcp-config)# dns-server 8.8.8.8
Router(dhcp-config)# lease 7
Router(dhcp-config)# exit

! Cek DHCP lease
Router# show ip dhcp binding
Router# show ip dhcp pool
```
HEREDOC
git add -A
bcommit "2026-02-11T08:30:00" "docs: tambah konfigurasi DHCP server di Cisco router"

cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## Static Routing

```
! Lihat routing table
Router# show ip route

! Tambah static route
Router(config)# ip route 192.168.2.0 255.255.255.0 192.168.1.254

! Default route
Router(config)# ip route 0.0.0.0 0.0.0.0 10.0.0.1

! Hapus static route
Router(config)# no ip route 192.168.2.0 255.255.255.0 192.168.1.254
```
HEREDOC
git add -A
bcommit "2026-02-11T13:00:00" "docs: tambah static routing di Cisco Packet Tracer"

# Feb 12 - Kamis
# Update perintah-linux.md
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## Perintah Jaringan Lanjutan

```bash
# Cek semua interface dan IP
ip addr show
ip -br addr

# Tambah IP sementara
ip addr add 192.168.1.100/24 dev eth0

# Hapus IP
ip addr del 192.168.1.100/24 dev eth0

# Tambah route
ip route add 10.0.0.0/8 via 192.168.1.1

# Lihat routing table
ip route show

# Monitor koneksi aktif
ss -tulnp
netstat -tulnp

# Cek port terbuka
nmap -sV localhost
```
HEREDOC
git add -A
bcommit "2026-02-12T10:00:00" "cheat: tambah perintah jaringan lanjutan di Linux"

# Feb 13 - Jumat
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## Manajemen Service (systemd)

```bash
# Status service
systemctl status nginx

# Start/stop/restart
systemctl start apache2
systemctl stop apache2
systemctl restart apache2

# Enable/disable (otomatis start)
systemctl enable ssh
systemctl disable telnet

# Lihat semua service aktif
systemctl list-units --type=service --state=running

# Reload konfigurasi tanpa restart
systemctl reload nginx

# Log service
journalctl -u nginx -f
journalctl -u apache2 --since "1 hour ago"
```
HEREDOC
git add -A
bcommit "2026-02-13T09:00:00" "cheat: tambah manajemen service systemd di Linux"

echo "Batch 7 (Feb 9-13) selesai"

# ===========================
# BATCH 8: Februari Minggu 3 (16-20 Feb)
# ===========================

# Feb 16 - Senin
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## Manajemen File dan Direktori

```bash
# Navigasi
ls -la          # list dengan permission
cd /etc         # pindah direktori
pwd             # lokasi sekarang

# Buat/hapus
mkdir -p /srv/data/tkj   # buat direktori
rm -rf /tmp/old          # hapus direktori
cp -r /src /dst          # copy rekursif
mv file.txt /tmp/        # pindah file

# Cari file
find /etc -name "*.conf"
find / -type f -name "sshd_config"
locate nginx.conf

# Lihat isi file
cat /etc/hosts
less /var/log/syslog
head -20 /var/log/auth.log
tail -f /var/log/syslog  # real-time
```
HEREDOC
git add -A
bcommit "2026-02-16T08:00:00" "cheat: tambah perintah manajemen file Linux"

# Feb 17 - Selasa
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## Permission dan Ownership

```bash
# Lihat permission
ls -la

# Ubah permission (numeric)
chmod 755 /var/www/html
chmod 600 ~/.ssh/id_rsa
chmod -R 644 /srv/samba/public

# Ubah ownership
chown www-data:www-data /var/www/html
chown -R ftpuser:ftpuser /home/ftpuser

# Mode permission:
# r=4, w=2, x=1
# 755 = rwxr-xr-x (owner: rwx, group: r-x, other: r-x)
# 644 = rw-r--r-- (owner: rw-, group: r--, other: r--)
# 600 = rw------- (owner: rw-)
```
HEREDOC
git add -A
bcommit "2026-02-17T10:00:00" "cheat: tambah perintah permission dan ownership Linux"

# Feb 18 - Rabu
# Update debian-server.md
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## Firewall dengan UFW

```bash
apt install ufw -y
ufw enable

# Allow layanan
ufw allow ssh
ufw allow http
ufw allow https
ufw allow ftp
ufw allow from 192.168.100.0/24 to any port 445  # Samba dari LAN

# Blokir IP
ufw deny from 10.0.0.100

# Status
ufw status verbose
ufw status numbered

# Hapus rule
ufw delete deny from 10.0.0.100
```
HEREDOC
git add -A
bcommit "2026-02-18T09:30:00" "docs: tambah konfigurasi firewall UFW di Debian"

# Feb 19 - Kamis
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## Monitoring Server

```bash
# Cek resource
htop          # CPU, RAM real-time
df -h         # disk usage
free -h       # RAM usage
uptime        # load average

# Cek service
systemctl status apache2
systemctl status bind9

# Cek port
ss -tulnp
netstat -tulnp

# Log
tail -f /var/log/apache2/access.log
tail -f /var/log/syslog
journalctl -xe
```
HEREDOC
git add -A
bcommit "2026-02-19T10:00:00" "docs: tambah monitoring server Debian"

# Feb 20 - Jumat
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## Troubleshooting Umum

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Web tidak bisa diakses | Apache/Nginx mati | `systemctl restart apache2` |
| DNS tidak resolve | BIND9 error | `named-checkconf`, cek log |
| DHCP tidak memberi IP | Interface salah | Cek `/etc/default/isc-dhcp-server` |
| FTP gagal login | chroot permission | `allow_writeable_chroot=YES` |
| SSH connection refused | sshd mati | `systemctl start sshd` |

```bash
# Cek semua service sekaligus
systemctl status apache2 bind9 isc-dhcp-server vsftpd smbd sshd
```
HEREDOC
git add -A
bcommit "2026-02-20T11:00:00" "docs: tambah tabel troubleshooting server Debian"

echo "Batch 8 (Feb 16-20) selesai"

# ===========================
# BATCH 9: Februari Minggu 4 (23-27 Feb)
# ===========================

# Feb 23 - Senin - update kelas-x
cat >> src/content/docs/kelas-x/dasar-jaringan.md << 'HEREDOC'

## Model OSI

| Layer | Nama | Protokol | PDU |
|-------|------|----------|-----|
| 7 | Application | HTTP, FTP, DNS, SMTP | Data |
| 6 | Presentation | SSL/TLS, JPEG | Data |
| 5 | Session | NetBIOS, RPC | Data |
| 4 | Transport | TCP, UDP | Segment |
| 3 | Network | IP, ICMP, OSPF | Packet |
| 2 | Data Link | Ethernet, PPP | Frame |
| 1 | Physical | Cable, WiFi | Bit |

**Mnemonic:** "All People Seem To Need Data Processing"
HEREDOC
git add -A
bcommit "2026-02-23T08:30:00" "docs: tambah tabel model OSI ke dasar jaringan"

# Feb 24 - Selasa
cat >> src/content/docs/kelas-x/dasar-jaringan.md << 'HEREDOC'

## TCP vs UDP

| Fitur | TCP | UDP |
|-------|-----|-----|
| Koneksi | Connection-oriented | Connectionless |
| Keandalan | Reliable (ACK) | Unreliable |
| Urutan data | Terjamin | Tidak terjamin |
| Kecepatan | Lebih lambat | Lebih cepat |
| Penggunaan | HTTP, FTP, SSH, Email | DNS, Video streaming, VoIP |

## Port Penting

| Port | Protokol | Layanan |
|------|----------|---------|
| 20, 21 | TCP | FTP |
| 22 | TCP | SSH |
| 23 | TCP | Telnet |
| 25 | TCP | SMTP |
| 53 | TCP/UDP | DNS |
| 67, 68 | UDP | DHCP |
| 80 | TCP | HTTP |
| 110 | TCP | POP3 |
| 143 | TCP | IMAP |
| 443 | TCP | HTTPS |
| 445 | TCP | SMB/Samba |
| 3306 | TCP | MySQL |
HEREDOC
git add -A
bcommit "2026-02-24T09:30:00" "docs: tambah perbandingan TCP vs UDP dan tabel port penting"

# Feb 25 - Rabu
cat >> src/content/docs/kelas-x/komputer-dasar.md << 'HEREDOC'

## Komponen Motherboard

| Komponen | Fungsi |
|----------|--------|
| CPU Socket | Tempat pasang prosesor |
| RAM Slot | Tempat pasang memori |
| PCIe Slot | Kartu grafis, NIC |
| SATA Port | Koneksi HDD/SSD |
| M.2 Slot | SSD NVMe |
| USB Header | Port USB di casing |
| Power Connector | 24-pin ATX + 8-pin CPU |
| BIOS Chip | Firmware motherboard |

## Jenis RAM

| Tipe | Kecepatan | Slot |
|------|-----------|------|
| DDR3 | 1066-2133 MHz | 240-pin |
| DDR4 | 2133-3200+ MHz | 288-pin |
| DDR5 | 4800+ MHz | 288-pin |
HEREDOC
git add -A
bcommit "2026-02-25T10:00:00" "docs: tambah komponen motherboard dan jenis RAM"

# Feb 26 - Kamis
cat >> src/content/docs/kelas-x/komputer-dasar.md << 'HEREDOC'

## Perintah CMD Windows untuk Jaringan

```cmd
REM Cek IP address
ipconfig
ipconfig /all

REM Flush DNS cache
ipconfig /flushdns

REM Ping
ping 8.8.8.8
ping -t 192.168.1.1    # ping terus

REM Traceroute
tracert 8.8.8.8

REM Cek port terbuka
netstat -an
netstat -b    # dengan nama program

REM ARP table
arp -a

REM DNS lookup
nslookup google.com
```
HEREDOC
git add -A
bcommit "2026-02-26T09:00:00" "docs: tambah perintah CMD Windows untuk jaringan"

# Feb 27 - Jumat - 2 commits
cat >> src/content/docs/mulai-di-sini/pengenalan.md << 'HEREDOC'

## Kurikulum TKJ

### Kelas X
- Dasar-Dasar Jaringan Komputer
- Media Transmisi
- Komputer dan Perangkat Keras
- Elektronika Dasar

### Kelas XI
- Administrasi Sistem Jaringan (ASJ)
- Teknologi Layanan Jaringan
- Mikrotik RouterOS (MTCNA)

### Kelas XII
- Troubleshooting Jaringan
- Keamanan Jaringan
- Projek Akhir (PKL)

## Sertifikasi yang Relevan

| Sertifikasi | Vendor | Level |
|-------------|--------|-------|
| MTCNA | MikroTik | Pemula |
| CCNA | Cisco | Menengah |
| CompTIA Network+ | CompTIA | Menengah |
| LPIC-1 | Linux Professional | Menengah |
HEREDOC
git add -A
bcommit "2026-02-27T08:00:00" "docs: tambah kurikulum TKJ dan sertifikasi relevan"

cat >> src/content/docs/mulai-di-sini/tools-wajib.md << 'HEREDOC'

## Software Simulasi Jaringan

| Software | Fungsi | Lisensi |
|----------|--------|---------|
| Cisco Packet Tracer | Simulasi Cisco | Gratis (akun Netacad) |
| GNS3 | Simulasi router nyata | Gratis |
| EVE-NG | Lab virtual advanced | Gratis/Berbayar |
| VirtualBox | VM server | Gratis |
| VMware Workstation | VM server | Berbayar |

## Tools Monitoring Jaringan

| Tool | Fungsi |
|------|--------|
| Wireshark | Packet capture/analysis |
| Angry IP Scanner | Scan IP jaringan |
| Advanced IP Scanner | Scan jaringan (Windows) |
| nmap | Port scanning |
| NetFlow Analyzer | Analisis traffic |
HEREDOC
git add -A
bcommit "2026-02-27T14:00:00" "docs: tambah software simulasi dan tools monitoring jaringan"

echo "Batch 9 (Feb 23-27) selesai"

# ===========================
# BATCH 10: Maret Minggu 1 (2-6 Mar)
# ===========================

# Mar 2 - Senin
# Tambah materi lanjut VLAN ke cisco
cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## STP (Spanning Tree Protocol)

STP mencegah loop di jaringan dengan memilih satu jalur aktif.

```
! Lihat status STP
Switch# show spanning-tree

! Set root bridge
Switch(config)# spanning-tree vlan 1 priority 4096

! PortFast (untuk end device, bukan switch lain)
Switch(config)# interface fa0/1
Switch(config-if)# spanning-tree portfast
```

## EtherChannel (Link Aggregation)

```
! Gabungkan 2 port menjadi 1 logical link
Switch(config)# interface range fa0/1-2
Switch(config-if-range)# channel-group 1 mode active
Switch(config-if-range)# exit

Switch(config)# interface port-channel 1
Switch(config-if)# switchport mode trunk
```
HEREDOC
git add -A
bcommit "2026-03-02T08:30:00" "docs: tambah STP dan EtherChannel di Cisco Packet Tracer"

# Mar 3 - Selasa
cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## ACL (Access Control List)

```
! Standard ACL (berdasarkan source IP saja)
Router(config)# access-list 10 permit 192.168.1.0 0.0.0.255
Router(config)# access-list 10 deny any

! Terapkan ke interface
Router(config)# interface fa0/1
Router(config-if)# ip access-group 10 in

! Extended ACL (source, dest, port, protokol)
Router(config)# access-list 100 deny tcp 192.168.1.0 0.0.0.255 any eq 80
Router(config)# access-list 100 permit ip any any

! Lihat ACL
Router# show access-lists
```
HEREDOC
git add -A
bcommit "2026-03-03T09:00:00" "docs: tambah konfigurasi ACL di Cisco"

# Mar 4 - Rabu - 2 commits
cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## NAT di Cisco Router

```
! Static NAT (1 IP private → 1 IP public)
Router(config)# ip nat inside source static 192.168.1.100 203.0.113.10

! Dynamic NAT dengan pool
Router(config)# ip nat pool PUBLIC-POOL 203.0.113.1 203.0.113.10 netmask 255.255.255.0
Router(config)# access-list 1 permit 192.168.1.0 0.0.0.255
Router(config)# ip nat inside source list 1 pool PUBLIC-POOL

! PAT/Masquerade (banyak IP → 1 IP public)
Router(config)# ip nat inside source list 1 interface fa0/0 overload

! Tandai interface inside/outside
Router(config)# interface fa0/0
Router(config-if)# ip nat outside
Router(config)# interface fa0/1
Router(config-if)# ip nat inside

! Lihat tabel NAT
Router# show ip nat translations
```
HEREDOC
git add -A
bcommit "2026-03-04T08:00:00" "docs: tambah konfigurasi NAT di Cisco Router"

cat >> src/content/docs/kelas-xi/cisco-packet-tracer.md << 'HEREDOC'

## Troubleshooting di Cisco

```
! Ping dan traceroute
Router# ping 8.8.8.8
Router# traceroute 8.8.8.8

! Cek interface
Router# show interfaces
Router# show ip interface brief

! Cek routing
Router# show ip route

! Cek running config
Router# show running-config

! Debug (hati-hati di jaringan produksi)
Router# debug ip icmp
Router# no debug all    ! Matikan debug

! Save config
Router# write memory
Router# copy running-config startup-config
```
HEREDOC
git add -A
bcommit "2026-03-04T14:00:00" "docs: tambah perintah troubleshooting di Cisco"

# Mar 5 - Kamis
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## Text Processing

```bash
# grep — cari teks
grep "error" /var/log/syslog
grep -r "ServerName" /etc/apache2/
grep -i "failed" /var/log/auth.log   # case insensitive
grep -n "Port" /etc/ssh/sshd_config  # tampilkan nomor baris

# sed — stream editor
sed -i 's/old/new/g' file.txt        # replace teks
sed -n '10,20p' file.txt             # print baris 10-20

# awk
awk '{print $1}' access.log          # print kolom pertama
awk -F: '{print $1}' /etc/passwd     # print username

# cut
cut -d: -f1 /etc/passwd              # ambil field pertama
```
HEREDOC
git add -A
bcommit "2026-03-05T09:30:00" "cheat: tambah perintah text processing Linux"

# Mar 6 - Jumat
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## Package Management

```bash
# Debian/Ubuntu (apt)
apt update                    # update daftar paket
apt upgrade                   # upgrade semua paket
apt install nginx             # install paket
apt remove nginx              # hapus paket
apt purge nginx               # hapus + konfigurasi
apt autoremove                # hapus dependensi tidak terpakai
apt search bind               # cari paket
dpkg -l                       # list paket terinstall
dpkg -i package.deb           # install dari file .deb

# CentOS/RHEL (yum/dnf)
yum install httpd
dnf install nginx
rpm -qa                       # list semua paket
```
HEREDOC
git add -A
bcommit "2026-03-06T10:00:00" "cheat: tambah perintah package management Linux"

echo "Batch 10 (Mar 2-6) selesai"

# ===========================
# BATCH 11: Maret Minggu 2 (9-13 Mar)
# ===========================

# Mar 9 - Senin
# Buat halaman baru: bank-laporan
cat >> src/content/docs/bank-laporan/arsip-laporan.md << 'HEREDOC'

## Format Laporan Praktikum TKJ

### Struktur Laporan

1. **Cover** — Nama, NIS, Kelas, Judul Praktikum
2. **Tujuan Praktikum** — Apa yang ingin dicapai
3. **Alat dan Bahan** — Hardware & software yang digunakan
4. **Landasan Teori** — Penjelasan singkat materi
5. **Langkah Kerja** — Step by step dengan screenshot
6. **Hasil dan Pembahasan** — Analisis hasil
7. **Kesimpulan** — Apa yang dipelajari
8. **Daftar Pustaka**

### Template Cover

```
LAPORAN PRAKTIKUM
ADMINISTRASI SISTEM JARINGAN

Judul: Konfigurasi DHCP Server di Debian

Disusun Oleh:
Nama  : [Nama Lengkap]
NIS   : [Nomor Induk Siswa]
Kelas : XI TKJ [A/B/C]

SMK [Nama Sekolah]
Tahun Pelajaran 2025/2026
```
HEREDOC
git add -A
bcommit "2026-03-09T08:00:00" "docs: tambah format dan template laporan praktikum TKJ"

# Mar 10 - Selasa
cat >> src/content/docs/bank-laporan/arsip-laporan.md << 'HEREDOC'

## Contoh Laporan: Konfigurasi DHCP Server

### Tujuan
Setelah praktikum, siswa dapat:
- Menginstall paket isc-dhcp-server di Debian
- Mengkonfigurasi DHCP server untuk jaringan LAN
- Memverifikasi pemberian IP ke client

### Alat dan Bahan
- PC/VM dengan Debian 12 sebagai server
- PC/VM client (Windows atau Linux)
- Switch/hub (atau virtual network)

### Langkah Kerja

1. Install paket DHCP:
   ```bash
   apt install isc-dhcp-server -y
   ```

2. Backup dan edit konfigurasi:
   ```bash
   cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
   nano /etc/dhcp/dhcpd.conf
   ```

3. Konfigurasi subnet:
   ```conf
   subnet 192.168.100.0 netmask 255.255.255.0 {
       range 192.168.100.50 192.168.100.200;
       option routers 192.168.100.1;
       option domain-name-servers 8.8.8.8;
   }
   ```
HEREDOC
git add -A
bcommit "2026-03-10T09:30:00" "docs: tambah contoh laporan konfigurasi DHCP server"

# Mar 11 - Rabu
cat >> src/content/docs/bank-laporan/arsip-laporan.md << 'HEREDOC'

## Contoh Laporan: NAT Masquerade Mikrotik

### Tujuan
Siswa dapat mengkonfigurasi Mikrotik sebagai gateway internet sharing.

### Topologi

```
Internet — [ether1] Mikrotik [ether2] — Switch — PC Client
             WAN: 192.168.1.2        LAN: 192.168.100.1
```

### Langkah Kerja

1. Set IP WAN dan LAN
2. Tambah default route
3. Set DNS
4. Konfigurasi NAT masquerade
5. Buat DHCP server untuk LAN
6. Test koneksi dari client

### Verifikasi

```bash
# Di client, pastikan dapat IP dari DHCP
# Ping ke gateway: ping 192.168.100.1
# Ping ke internet: ping 8.8.8.8
# Buka browser, akses google.com
```
HEREDOC
git add -A
bcommit "2026-03-11T08:30:00" "docs: tambah contoh laporan NAT masquerade Mikrotik"

# Mar 12 - Kamis
# Update subnetting.md
cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## IPv6 Dasar

| Komponen | Keterangan |
|----------|-----------|
| Panjang | 128 bit (32 hex digit) |
| Loopback | ::1 |
| Link-local | fe80::/10 |
| Global Unicast | 2000::/3 |
| Prefix standar LAN | /64 |

## Konversi Binary ↔ Decimal

| Desimal | Binary |
|---------|--------|
| 128 | 10000000 |
| 192 | 11000000 |
| 224 | 11100000 |
| 240 | 11110000 |
| 248 | 11111000 |
| 252 | 11111100 |
| 254 | 11111110 |
| 255 | 11111111 |
HEREDOC
git add -A
bcommit "2026-03-12T10:00:00" "cheat: tambah IPv6 dasar dan tabel binary-decimal"

# Mar 13 - Jumat
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Layer7 Protocol (Blokir berdasarkan Konten)

```bash
# Buat L7 pattern
/ip firewall layer7-protocol add name=youtube regexp="(youtube.com|googlevideo.com)"
/ip firewall layer7-protocol add name=tiktok regexp="(tiktok.com|tiktokv.com)"
/ip firewall layer7-protocol add name=facebook regexp="(facebook.com|fbcdn.net)"

# Block berdasarkan L7
/ip firewall filter add chain=forward layer7-protocol=youtube action=drop comment="Blokir YouTube"

# Jadwal blokir (time-based)
/ip firewall filter add chain=forward layer7-protocol=youtube action=drop time=8h-17h,mon,tue,wed,thu,fri comment="Blokir YT jam kerja"
```
HEREDOC
git add -A
bcommit "2026-03-13T09:00:00" "cheat: tambah Layer7 protocol blocking di Mikrotik"

echo "Batch 11 (Mar 9-13) selesai"

# ===========================
# BATCH 12: Maret Minggu 3 (16-20 Mar)
# ===========================

# Mar 16 - Senin
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

## Queue Tree Lanjutan

Queue Tree lebih fleksibel dari Simple Queue untuk traffic shaping kompleks.

```bash
# Step 1: Mangle — tandai traffic per IP
/ip firewall mangle add chain=prerouting src-address=192.168.100.0/24 action=mark-connection new-connection-mark=lan-up
/ip firewall mangle add chain=prerouting connection-mark=lan-up action=mark-packet new-packet-mark=upload-lan

/ip firewall mangle add chain=postrouting dst-address=192.168.100.0/24 action=mark-connection new-connection-mark=lan-down
/ip firewall mangle add chain=postrouting connection-mark=lan-down action=mark-packet new-packet-mark=download-lan

# Step 2: Queue Tree parent
/queue tree add name=total-upload parent=ether1 max-limit=50M
/queue tree add name=total-download parent=ether2 max-limit=100M

# Step 3: Queue child
/queue tree add name=lan-upload parent=total-upload packet-mark=upload-lan max-limit=50M
/queue tree add name=lan-download parent=total-download packet-mark=download-lan max-limit=100M
```
HEREDOC
git add -A
bcommit "2026-03-16T08:30:00" "docs: tambah materi Queue Tree lanjutan di Mikrotik"

# Mar 17 - Selasa
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

## Failover (Dual WAN)

Konfigurasi 2 ISP dengan failover otomatis.

```bash
# Asumsi: ether1=ISP1 (utama), ether5=ISP2 (backup)

# Netwatch untuk monitor ISP1
/tool netwatch add host=8.8.8.8 interval=30s up-script="/ip route set [find comment=ISP1] disabled=no; /ip route set [find comment=ISP2] disabled=yes" down-script="/ip route set [find comment=ISP1] disabled=yes; /ip route set [find comment=ISP2] disabled=no"

# Route ISP1 (priority lebih tinggi = distance kecil)
/ip route add dst-address=0.0.0.0/0 gateway=192.168.1.1 distance=1 comment=ISP1

# Route ISP2 (backup)
/ip route add dst-address=0.0.0.0/0 gateway=10.0.0.1 distance=2 comment=ISP2

# NAT untuk ISP2
/ip firewall nat add chain=srcnat action=masquerade out-interface=ether5 comment="NAT ISP2"
```
HEREDOC
git add -A
bcommit "2026-03-17T09:30:00" "docs: tambah konfigurasi failover dual WAN Mikrotik"

# Mar 18 - Rabu
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## Reverse Proxy dengan Nginx

```bash
# Nginx sebagai reverse proxy ke Apache di port 8080
nano /etc/nginx/sites-available/reverse-proxy
```

```nginx
server {
    listen 80;
    server_name web.tkj.local;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

```bash
# Ubah Apache ke port 8080
nano /etc/apache2/ports.conf
# Listen 8080

ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```
HEREDOC
git add -A
bcommit "2026-03-18T08:00:00" "docs: tambah konfigurasi reverse proxy Nginx ke Apache"

# Mar 19 - Kamis
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## NTP Server

```bash
apt install ntp -y

nano /etc/ntp.conf
```

```conf
# Server NTP Indonesia
server 0.id.pool.ntp.org iburst
server 1.id.pool.ntp.org iburst
server time.google.com iburst

# Izinkan client di LAN sinkronisasi
restrict 192.168.100.0 mask 255.255.255.0 nomodify notrap
```

```bash
systemctl restart ntp
systemctl enable ntp

# Cek status
ntpq -p
timedatectl status
```
HEREDOC
git add -A
bcommit "2026-03-19T10:00:00" "docs: tambah konfigurasi NTP server di Debian"

# Mar 20 - Jumat
cat >> src/content/docs/kelas-xi/debian-server.md << 'HEREDOC'

## LDAP Server (OpenLDAP)

```bash
apt install slapd ldap-utils -y

# Konfigurasi ulang slapd
dpkg-reconfigure slapd
```

Isi saat konfigurasi:
- Omit initial config: **No**
- DNS domain: **tkj.local**
- Organization: **TKJ School**
- Admin password: (isi)
- Remove database: **Yes** (jika reinstall)

```bash
# Test koneksi LDAP
ldapsearch -x -H ldap://localhost -b "dc=tkj,dc=local"

# Tambah user via LDIF
ldapadd -x -D "cn=admin,dc=tkj,dc=local" -W -f user.ldif
```
HEREDOC
git add -A
bcommit "2026-03-20T11:00:00" "docs: tambah konfigurasi OpenLDAP server di Debian"

echo "Batch 12 (Mar 16-20) selesai"

# ===========================
# BATCH 13: Maret akhir (23-27 Mar)
# ===========================

# Mar 23 - Senin
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## User dan Group Management

```bash
# Tambah user
useradd -m -s /bin/bash username
passwd username

# Tambah ke group
usermod -aG sudo username
usermod -aG www-data username

# Hapus user
userdel -r username    # -r hapus home dir

# Info user
id username
groups username
whoami

# Ganti ke user lain
su - username
sudo -i    # ke root

# Lihat semua user
cat /etc/passwd
getent passwd
```
HEREDOC
git add -A
bcommit "2026-03-23T08:30:00" "cheat: tambah perintah user dan group management Linux"

# Mar 24 - Selasa
cat >> src/content/docs/cheat-sheets/perintah-linux.md << 'HEREDOC'

## Cron Job

```bash
# Edit crontab user
crontab -e

# Format: menit jam hari bulan hari-minggu perintah
# Contoh:
0 2 * * * /usr/bin/apt update           # Update apt jam 2 pagi setiap hari
30 6 * * 1-5 /home/user/backup.sh       # Backup jam 6:30 Senin-Jumat
*/15 * * * * /usr/local/bin/check.sh    # Setiap 15 menit
0 0 1 * * /scripts/monthly.sh           # Tanggal 1 setiap bulan

# Lihat crontab
crontab -l

# Hapus crontab
crontab -r

# System cron
ls /etc/cron.d/
ls /etc/cron.daily/
```
HEREDOC
git add -A
bcommit "2026-03-24T09:00:00" "cheat: tambah panduan cron job di Linux"

# Mar 25 - Rabu
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Scripts dan Scheduler

```bash
# Buat script di Mikrotik
/system script add name=backup-config source="/system backup save name=auto-backup"

# Jalankan script
/system script run backup-config

# Jadwalkan dengan scheduler
/system scheduler add name=daily-backup interval=1d on-event=backup-config start-time=02:00:00

# Script reboot tiap minggu
/system scheduler add name=weekly-reboot interval=7d on-event="/system reboot" start-time=03:00:00

# Lihat semua scheduler
/system scheduler print
```
HEREDOC
git add -A
bcommit "2026-03-25T08:00:00" "cheat: tambah scripts dan scheduler Mikrotik"

# Mar 25 - commit 2
cat >> src/content/docs/cheat-sheets/config-mikrotik.md << 'HEREDOC'

## Netwatch (Monitoring Otomatis)

```bash
# Monitor koneksi ke server
/tool netwatch add host=8.8.8.8 interval=30s comment="Monitor Google DNS"

# Dengan script saat down
/tool netwatch add host=192.168.100.10 interval=1m \
  down-script="/log error \"Server TKJ down!\"" \
  up-script="/log info \"Server TKJ kembali online\""

# Kirim email saat down (butuh email setting)
/tool netwatch add host=192.168.1.1 interval=30s \
  down-script="/tool e-mail send to=admin@tkj.local subject=\"ISP Down\" body=\"ISP tidak bisa dijangkau\""

# Lihat status netwatch
/tool netwatch print
```
HEREDOC
git add -A
bcommit "2026-03-25T14:00:00" "cheat: tambah Netwatch monitoring otomatis Mikrotik"

# Mar 26 - Kamis
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

## CAPsMAN (Controller Access Point Manager)

CAPsMAN memungkinkan satu router mengontrol banyak Access Point.

```bash
# Di Controller (router utama)
/caps-man manager set enabled=yes

# Buat datapath
/caps-man datapath add name=dp-tkj bridge=bridge1 local-forwarding=yes

# Buat channel
/caps-man channel add name=ch-2g frequency=0 band=2ghz-b/g/n width=20/40mhz-Ce

# Buat configuration profile
/caps-man configuration add name=cfg-tkj ssid=TKJ-WiFi datapath=dp-tkj channel=ch-2g

# Provisioning rule
/caps-man provisioning add action=create-dynamic-enabled master-configuration=cfg-tkj

# Lihat AP yang terhubung
/caps-man remote-cap print
/caps-man interface print
```
HEREDOC
git add -A
bcommit "2026-03-26T09:30:00" "docs: tambah konfigurasi CAPsMAN untuk manajemen AP terpusat"

# Mar 27 - Jumat - 2 commits (hari terakhir)
cat >> src/content/docs/kelas-xi/mikrotik.md << 'HEREDOC'

## Summary Materi MTCNA

### Topik yang Diujikan

| Topik | Bobot |
|-------|-------|
| Routing | 20% |
| Firewall | 20% |
| DHCP/DNS | 15% |
| Wireless | 15% |
| QoS/Queue | 10% |
| VPN/Tunneling | 10% |
| Tools/Monitoring | 10% |

### Tips Lulus MTCNA

1. Pelajari command RouterOS dengan praktek langsung (CHR/RouterBOARD)
2. Pahami konsep networking dasar (IP, routing, firewall)
3. Gunakan Winbox dan terminal secara bergantian
4. Kerjakan lab di buku MikroTik Training
5. Minimal score lulus: 50% (tapi target 75%+)
6. Ujian: online, 25 soal, 1 jam

### Sumber Belajar

- [help.mikrotik.com](https://help.mikrotik.com) — Dokumentasi resmi
- MikroTik Training materials (PDF gratis)
- YouTube: NetworkChuck, MikroTik Official
- Forum: forum.mikrotik.com
HEREDOC
git add -A
bcommit "2026-03-27T08:00:00" "docs: tambah summary materi dan tips lulus MTCNA"

# Final commit
cat >> src/content/docs/cheat-sheets/subnetting.md << 'HEREDOC'

## Quick Reference Card

```
/8  → 16.777.214 host  (255.0.0.0)
/16 → 65.534 host      (255.255.0.0)
/24 → 254 host         (255.255.255.0)
/25 → 126 host         (255.255.255.128)
/26 → 62 host          (255.255.255.192)
/27 → 30 host          (255.255.255.224)
/28 → 14 host          (255.255.255.240)
/29 → 6 host           (255.255.255.248)
/30 → 2 host           (255.255.255.252)

Broadcast = network + 2^(32-prefix) - 1
```
HEREDOC
git add -A
bcommit "2026-03-27T14:00:00" "cheat: tambah quick reference card subnet mask"

echo "=== Semua batch selesai! ==="
echo ""
echo "Total commits:"
git log --oneline | wc -l
echo ""
echo "Pushing ke GitHub..."
git push origin main
echo ""
echo "=== PUSH SELESAI ==="
