---
title: Laporan Konfigurasi VLAN
description: Contoh laporan konfigurasi VLAN di Cisco Packet Tracer untuk bank laporan TKJ.
---

# Contoh Laporan: Konfigurasi VLAN

Ini contoh laporan praktek konfigurasi VLAN. Sesuaikan dengan topologi yang kamu kerjakan.

---

## BAB I — PENDAHULUAN

### 1.1 Latar Belakang

Jaringan di sekolah menggunakan satu switch untuk semua pengguna. Ini membuat broadcast domain terlalu besar dan tidak ada pemisahan traffic antara jaringan guru dan siswa. Untuk mengatasi masalah ini, dikonfigurasi VLAN untuk memisahkan kedua kelompok secara logis.

### 1.2 Tujuan

- Membuat VLAN 10 untuk jaringan guru
- Membuat VLAN 20 untuk jaringan siswa
- Mengkonfigurasi inter-VLAN routing agar kedua VLAN bisa berkomunikasi jika diizinkan

### 1.3 Alat dan Bahan

| No | Alat/Bahan | Jumlah |
|----|-----------|--------|
| 1 | Cisco Packet Tracer | 1 (software) |
| 2 | Router Cisco 2911 (simulasi) | 1 |
| 3 | Switch Cisco 2960 (simulasi) | 2 |
| 4 | PC simulasi | 4 |

---

## BAB III — LANGKAH KERJA

### 3.1 Topologi

```
[PC Guru 1]──[fa0/1]                    [fa0/1]──[PC Siswa 1]
[PC Guru 2]──[fa0/2]  [Switch 1]──trunk──[Switch 2]  [fa0/2]──[PC Siswa 2]
                         [fa0/24]──────────[fa0/24]
                            |
                         [fa0/0]
                          Router
```

### 3.2 Tabel pengalamatan IP

| Device | Interface | VLAN | IP Address | Subnet Mask |
|--------|-----------|------|------------|-------------|
| Router | fa0/0.10 | 10 | 192.168.10.1 | 255.255.255.0 |
| Router | fa0/0.20 | 20 | 192.168.20.1 | 255.255.255.0 |
| PC Guru 1 | NIC | 10 | 192.168.10.2 | 255.255.255.0 |
| PC Guru 2 | NIC | 10 | 192.168.10.3 | 255.255.255.0 |
| PC Siswa 1 | NIC | 20 | 192.168.20.2 | 255.255.255.0 |
| PC Siswa 2 | NIC | 20 | 192.168.20.3 | 255.255.255.0 |

### 3.3 Konfigurasi Switch 1

```
Switch1> enable
Switch1# configure terminal
Switch1(config)# vlan 10
Switch1(config-vlan)# name Guru
Switch1(config-vlan)# exit
Switch1(config)# vlan 20
Switch1(config-vlan)# name Siswa
Switch1(config-vlan)# exit

! Assign access port
Switch1(config)# interface fa0/1
Switch1(config-if)# switchport mode access
Switch1(config-if)# switchport access vlan 10
Switch1(config-if)# exit
Switch1(config)# interface fa0/2
Switch1(config-if)# switchport mode access
Switch1(config-if)# switchport access vlan 10
Switch1(config-if)# exit

! Trunk ke Switch 2
Switch1(config)# interface fa0/24
Switch1(config-if)# switchport mode trunk
Switch1(config-if)# exit

! Trunk ke Router
Switch1(config)# interface fa0/23
Switch1(config-if)# switchport mode trunk
Switch1(config-if)# exit
```

VLAN (Virtual Local Area Network) adalah teknologi yang memungkinkan pembuatan jaringan logis terpisah dalam satu infrastruktur fisik yang sama. VLAN bekerja di layer 2 (Data Link) model OSI.

Trunk port digunakan untuk membawa traffic dari beberapa VLAN sekaligus antara dua perangkat, menggunakan encapsulation 802.1Q untuk menandai paket dengan VLAN ID.

### 3.4 Konfigurasi Router

```
Router> enable
Router# configure terminal

Router(config)# interface fa0/0
Router(config-if)# no shutdown
Router(config-if)# exit

Router(config)# interface fa0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0
Router(config-subif)# exit

Router(config)# interface fa0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0
Router(config-subif)# exit
```

---

## BAB IV — HASIL DAN ANALISIS

### 4.1 Hasil pengujian

| Pengujian | Sumber | Tujuan | Hasil |
|-----------|--------|--------|-------|
| Ping sesama VLAN 10 | 192.168.10.2 | 192.168.10.3 | Berhasil |
| Ping sesama VLAN 20 | 192.168.20.2 | 192.168.20.3 | Berhasil |
| Ping beda VLAN (via router) | 192.168.10.2 | 192.168.20.2 | Berhasil |

### 4.2 Analisis

Pemisahan VLAN berhasil. PC di VLAN 10 tidak bisa berkomunikasi langsung dengan VLAN 20 tanpa melalui router. Ini sesuai tujuan keamanan jaringan.

---

## BAB V — KESIMPULAN

VLAN berhasil dikonfigurasi untuk memisahkan traffic guru dan siswa. Inter-VLAN routing via router-on-a-stick berfungsi baik. Teknik ini dapat diterapkan di jaringan sekolah nyata untuk meningkatkan keamanan dan manajemen bandwidth.

---

## Lampiran: Perintah verifikasi

```
! Di switch
Switch# show vlan brief
Switch# show interfaces trunk
Switch# show mac address-table

! Di router
Router# show ip interface brief
Router# show running-config | section interface
```

## Catatan

Template laporan ini menggunakan format standar yang umumnya diminta guru. Sesuaikan bagian topologi dan tabel IP dengan jaringan yang kamu kerjakan. Jangan copy-paste hasil begitu saja — minimal ubah nama device dan IP-nya.

## Daftar referensi (opsional)

Kalau guru minta daftar referensi:

1. Cisco Networking Academy. *Introduction to Networks*. Cisco Press.
2. Odom, W. (2019). *CCNA 200-301 Official Cert Guide*. Cisco Press.
3. Dokumentasi Cisco IOS: https://www.cisco.com/c/en/us/support/

---

*Format laporan ini disesuaikan dengan format umum laporan praktek SMK. Periksa lagi persyaratan format dari sekolah masing-masing, karena bisa berbeda.*
