---
title: Arsip Laporan
description: Kumpulan contoh laporan praktek.
---

Contoh laporan praktek kerja industri (PKL), laporan tugas akhir, dan laporan praktikum harian.
**Disclaimer:** Gunakan sebagai referensi, jangan copy-paste mentah-mentah!

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
