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

Solusi: ubah IP salah satu device ke IP yang belum dipakai.
