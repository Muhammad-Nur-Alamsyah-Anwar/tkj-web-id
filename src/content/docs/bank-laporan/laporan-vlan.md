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

## BAB II — DASAR TEORI

VLAN (Virtual Local Area Network) adalah teknologi yang memungkinkan pembuatan jaringan logis terpisah dalam satu infrastruktur fisik yang sama. VLAN bekerja di layer 2 (Data Link) model OSI.

Trunk port digunakan untuk membawa traffic dari beberapa VLAN sekaligus antara dua perangkat, menggunakan encapsulation 802.1Q untuk menandai paket dengan VLAN ID.

Inter-VLAN routing dilakukan oleh router menggunakan teknik router-on-a-stick: satu interface fisik router dibagi menjadi beberapa subinterface, masing-masing menangani satu VLAN.
