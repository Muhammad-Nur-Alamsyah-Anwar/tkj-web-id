---
title: Troubleshooting Jaringan
description: Cara troubleshooting masalah jaringan yang umum untuk kelas X TKJ.
---

# Troubleshooting Jaringan

Kumpulan masalah jaringan yang sering muncul dan cara ngatasinnya. Biasanya ini yang keluar di ujian praktek.

## Tidak bisa ping gateway

Langkah diagnosa:

1. Cek IP address: `ip a` — pastikan IP sudah diset dan di network yang benar
2. Cek subnet mask — kalau salah, bisa tidak bisa berkomunikasi walau IP mirip
3. Cek kabel fisik — lampu indikator di NIC dan switch harus nyala
4. Cek interface up: `ip link show` — kalau DOWN, aktifkan dengan `ip link set eth0 up`

## Bisa ping gateway tapi tidak bisa akses internet

1. Cek routing table: `ip route show` — harus ada default route (`0.0.0.0/0 via <gateway>`)
2. Tambah default route kalau tidak ada:
   ```bash
   ip route add default via 192.168.1.1
   ```
3. Cek DNS: `cat /etc/resolv.conf` — harus ada `nameserver`
4. Test DNS: `nslookup google.com` atau `ping 8.8.8.8` (ping IP dulu)

Kalau `ping 8.8.8.8` bisa tapi `ping google.com` tidak — masalahnya DNS, bukan routing.

## IP conflict

Gejala: ping intermittent, koneksi putus-putus.

Cara cek di Debian:

```bash
arping -I eth0 192.168.1.100
```

Kalau ada 2 reply dari MAC address berbeda, berarti ada IP conflict.

## Tidak bisa ping antar PC di lab

Kemungkinan:

1. **IP berbeda network** — cek apakah kedua PC di subnet yang sama
2. **Firewall aktif** — Windows Firewall sering blokir ICMP. Coba ping dari PC Linux ke PC Linux dulu
3. **Kabel straight/crossover salah** — PC ke switch pakai straight, PC ke PC langsung pakai crossover (kalau tidak ada auto-MDI)
4. **Switch VLAN** — kalau pakai managed switch, cek apakah port masuk VLAN yang sama

Cara cek IP cepat:

```
# Windows
ipconfig

# Linux
ip a
```

## Service tidak bisa diakses dari client

Contoh: web server Apache sudah install tapi tidak bisa dibuka dari browser client.

Cek urutan ini:

1. Apakah service running? `systemctl status apache2`
2. Apakah listening di port yang benar? `ss -tlnp | grep :80`
3. Apakah firewall blokir? `iptables -L` atau cek ufw
4. Apakah bisa diakses dari server sendiri? `curl localhost`
5. Baru cek dari client

## Urutan troubleshooting umum (OSI bottom-up)

| Layer | Cek |
|-------|-----|
| Physical (L1) | Kabel, lampu NIC/switch |
| Data Link (L2) | MAC address, ARP table |
| Network (L3) | IP, subnet, routing |
| Transport (L4) | Port, TCP/UDP, firewall |
## Perintah troubleshooting cepat

```bash
# Cek IP dan interface
ip a
ip link show

# Cek routing
ip route show

# Ping dengan limit 4 paket
ping -c 4 8.8.8.8

# Traceroute — lihat jalur paket ke tujuan
traceroute google.com     # Linux
tracert google.com        # Windows

# Cek DNS
nslookup google.com
dig google.com

# Cek port terbuka
ss -tlnp
nmap -p 80,443 192.168.1.1

# Cek log sistem
journalctl -xe
tail -f /var/log/syslog
```

## Catatan

Troubleshooting itu prosesnya sistematis dari bawah ke atas. Jangan langsung lompat ke konfigurasi aplikasi kalau kabel belum dicek.
