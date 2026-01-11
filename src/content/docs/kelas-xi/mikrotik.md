---
title: Mikrotik RouterOS
description: Tutorial lengkap Mikrotik untuk materi MTCNA — routing, firewall, hotspot, dan manajemen bandwidth.
---

# Mikrotik RouterOS — Materi Kelas XI TKJ

Mikrotik RouterOS adalah sistem operasi berbasis Linux yang digunakan sebagai router jaringan. Sangat populer di Indonesia untuk keperluan ISP, warnet, sekolah, dan jaringan enterprise.

---

## Pengenalan Mikrotik

### Apa itu Mikrotik?

Mikrotik adalah perusahaan Latvia yang mengembangkan **RouterOS** dan perangkat keras jaringan **RouterBOARD**. Di Indonesia, Mikrotik sangat umum digunakan karena:

- Harga terjangkau dibanding Cisco
- Fitur lengkap (routing, firewall, VPN, hotspot, dll)
- Banyak dokumentasi dan komunitas lokal
- Ada sertifikasi resmi: **MTCNA**, **MTCRE**, **MTCWE**, dll

### Cara Akses Mikrotik

| Metode | Port | Keterangan |
|--------|------|-----------|
| **Winbox** | 8291 | GUI tool (Windows/Wine) |
| **WebFig** | 80/443 | Web browser |
| **SSH** | 22 | Terminal remote |
| **Telnet** | 23 | Terminal (tidak aman) |
| **Serial** | - | Kabel console langsung |

### Default Login

```
Username: admin
Password: (kosong) atau admin
IP default: 192.168.88.1
```

---

## Topologi Dasar

```
ISP
 |
[ether1] — WAN (IP dari ISP)
 ROUTER
[ether2] — LAN (192.168.100.1/24)
 |
Switch
 |________|________|
PC1    PC2    PC3
```

---

## 1. Konfigurasi IP dan Routing

### Langkah Setup Internet Sharing

```bash
# 1. Set IP WAN (dari ISP, atau DHCP)
/ip address add address=192.168.1.2/24 interface=ether1

# 2. Set IP LAN
/ip address add address=192.168.100.1/24 interface=ether2

# 3. Default route ke gateway ISP
/ip route add dst-address=0.0.0.0/0 gateway=192.168.1.1

# 4. DNS server
/ip dns set servers=8.8.8.8,1.1.1.1 allow-remote-requests=yes

# 5. NAT masquerade
/ip firewall nat add chain=srcnat action=masquerade out-interface=ether1

# 6. DHCP untuk LAN
/ip pool add name=pool-lan ranges=192.168.100.10-192.168.100.200
/ip dhcp-server add name=dhcp-lan interface=ether2 address-pool=pool-lan disabled=no
/ip dhcp-server network add address=192.168.100.0/24 gateway=192.168.100.1 dns-server=8.8.8.8
```

### Routing Statis

```bash
# Route ke jaringan tertentu via gateway lain
/ip route add dst-address=10.10.0.0/16 gateway=192.168.100.254

# Cek routing table
/ip route print

# Cek jika routing berjalan
/ping 8.8.8.8
```

---

## 2. Firewall Filter

Firewall di Mikrotik memiliki 3 chain utama:

| Chain | Fungsi |
|-------|--------|
| **input** | Traffic yang MASUK ke router |
| **forward** | Traffic yang LEWAT router (antar jaringan) |
| **output** | Traffic yang KELUAR dari router |

### Best Practice Firewall

```bash
# 1. Accept established/related connections
/ip firewall filter add chain=input connection-state=established,related action=accept comment="accept established"

# 2. Drop invalid connections
/ip firewall filter add chain=input connection-state=invalid action=drop comment="drop invalid"

# 3. Accept dari LAN ke router
/ip firewall filter add chain=input in-interface=ether2 action=accept comment="accept from LAN"

# 4. Accept ICMP (ping)
/ip firewall filter add chain=input protocol=icmp action=accept comment="accept ICMP"

# 5. Drop semua yang lain dari WAN
/ip firewall filter add chain=input in-interface=ether1 action=drop comment="drop from WAN"
```

### Blokir Situs / Konten

```bash
# Blokir berdasarkan IP address
/ip firewall filter add chain=forward dst-address=8.8.8.8 action=drop comment="blokir 8.8.8.8"

# Blokir berdasarkan address-list
/ip firewall address-list add list=situs-blokir address=social.example.com
/ip firewall filter add chain=forward dst-address-list=situs-blokir action=drop

# Blokir berdasarkan Layer7 (konten URL)
/ip firewall layer7-protocol add name=youtube regexp="youtube.com"
/ip firewall filter add chain=forward layer7-protocol=youtube action=drop comment="Blokir YouTube"
```

---

## 3. Hotspot

Hotspot Mikrotik memungkinkan autentikasi pengguna sebelum bisa mengakses internet.

### Setup Hotspot

```bash
# Jalankan wizard hotspot
/ip hotspot setup

# Jawab pertanyaan:
# - Interface hotspot: wlan1 (atau ether2)
# - IP lokal: 192.168.200.1/24
# - Pool DHCP: 192.168.200.2-192.168.200.254
# - DNS name: hotspot.tkj.local
# - Hotspot user: admin / admin
```

### Manajemen User Hotspot

```bash
# Buat user profile dengan limit
/ip hotspot user profile add name=siswa rate-limit=2M/2M session-timeout=8h

# Tambah user
/ip hotspot user add name=siswa01 password=12345 profile=siswa

# Import user dari file
# (buat file users.txt, lalu import)

# Lihat user aktif
/ip hotspot active print

# Kick user tertentu
/ip hotspot active remove [find where user=siswa01]
```

### Customize Halaman Login

File halaman login hotspot disimpan di `/flash/hotspot/`. Bisa dimodifikasi melalui:
- Winbox → Files → hotspot folder
- FTP ke router
- SFTP (jika diaktifkan)

---

## 4. Bandwidth Management

### Simple Queue

Cara paling mudah membatasi bandwidth per IP atau subnet.

```bash
# Limit satu PC
/queue simple add name=pc01 target=192.168.100.11 max-limit=5M/10M

# Limit seluruh jaringan
/queue simple add name=all-lan target=192.168.100.0/24 max-limit=20M/50M

# Prioritas (1=tertinggi, 8=terendah)
/queue simple add name=priority-server target=192.168.100.10 priority=1/1 max-limit=0/0
```

### PCQ (Per Connection Queue)

PCQ membagi bandwidth secara merata untuk semua pengguna.

```bash
# Buat tipe queue PCQ
/queue type add name=pcq-download kind=pcq pcq-classifier=dst-address
/queue type add name=pcq-upload kind=pcq pcq-classifier=src-address

# Terapkan ke simple queue
/queue simple add name=pcq-all target=192.168.100.0/24 queue=pcq-upload/pcq-download max-limit=50M/100M
```

### Queue Tree + Mangle

Lebih fleksibel, cocok untuk jaringan besar.

```bash
# Step 1: Tandai paket dengan mangle
/ip firewall mangle add chain=prerouting in-interface=ether1 action=mark-connection new-connection-mark=download-conn passthrough=yes
/ip firewall mangle add chain=prerouting connection-mark=download-conn action=mark-packet new-packet-mark=download passthrough=no

# Step 2: Parent queue
/queue tree add name=download parent=ether2 max-limit=50M

# Step 3: Child queue
/queue tree add name=download-bulk parent=download packet-mark=download max-limit=50M priority=8
```

---

## 5. VPN

### PPTP (Point-to-Point Tunneling Protocol)

```bash
# Server PPTP
/interface pptp-server server set enabled=yes

# Profile
/ppp profile add name=vpn-profile local-address=10.0.0.1 remote-address=10.0.0.2 dns-server=8.8.8.8

# Secret (akun VPN)
/ppp secret add name=vpn-user password=vpnpass service=pptp profile=vpn-profile

# Client PPTP (dari Mikrotik lain)
/interface pptp-client add name=pptp1 connect-to=SERVER_IP user=vpn-user password=vpnpass disabled=no
```

---

## 6. Wireless

```bash
# Mode Access Point
/interface wireless set wlan1 mode=ap-bridge ssid=TKJ-Wifi band=2ghz-b/g/n disabled=no

# Security Profile WPA2
/interface wireless security-profiles add name=wpa2 mode=dynamic-keys authentication-types=wpa2-psk wpa2-pre-shared-key=password2024

/interface wireless set wlan1 security-profile=wpa2

# Mode Station (koneksi ke AP lain)
/interface wireless set wlan1 mode=station ssid=ISP-Wifi

# Lihat station yang terkoneksi
/interface wireless registration-table print
```

---

## 7. Troubleshooting & Monitoring

```bash
# Ping untuk cek konektivitas
/ping 8.8.8.8

# Traceroute
/tool traceroute 8.8.8.8

# Monitor traffic interface secara real-time
/interface monitor-traffic ether1

# Torch — lihat traffic per koneksi
/tool torch interface=ether2

# Cek log sistem
/log print follow

# Cek resource (CPU, RAM, uptime)
/system resource print

# Cek temperature (jika support)
/system health print

# Netwatch — monitoring otomatis
/tool netwatch add host=8.8.8.8 interval=30s

# Profile — cek penggunaan CPU per proses
/tool profile
```

---

## 8. Backup dan Update

```bash
# Backup konfigurasi
/system backup save name=backup-$(date)

# Export ke text (bisa dibaca/diedit)
/export file=config-export

# Update RouterOS
/system package update check-for-updates
/system package update install

# Downgrade (jika update bermasalah)
/system package downgrade
```

---

## Soal Latihan

1. Buat konfigurasi NAT masquerade untuk jaringan 192.168.10.0/24 keluar lewat ether1
2. Buat 3 user hotspot dengan limit berbeda: VIP (unlimited), Guru (5Mbps), Siswa (2Mbps)
3. Blokir akses YouTube untuk semua user di subnet 192.168.100.0/24 antara jam 08:00-17:00
4. Bagi bandwidth 100Mbps untuk 50 user secara merata menggunakan PCQ

---

## Sumber Belajar

- [Dokumentasi resmi MikroTik](https://help.mikrotik.com)
- [Forum MikroTik Indonesia](https://mikrotik.co.id/forum)
- [RouterOS CHR (free trial)](https://mikrotik.com/download)
- Video tutorial: YouTube — MikroTik Indonesia
