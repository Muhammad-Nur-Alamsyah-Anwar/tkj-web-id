---
title: Tools Wajib
description: Senjata tempur software yang harus ada di laptop anak TKJ.
---

Seorang teknisi jaringan tanpa tools yang tepat bagaikan tentara tanpa senjata. Berikut adalah daftar software "Wajib Install" untuk bertahan hidup di jurusan TKJ, disesuaikan dengan standar industri tahun 2026.

:::tip[Pro Tip]
Idealnya gunakan laptop dengan RAM 8GB + SSD. Tapi kalau RAM cuma 4GB (**Kaum Kentang**), jangan panik!
1. Gunakan Windows versi ringan (Ghost Spectre / LTSC).
2. Jalankan Debian Server mode CLI (tanpa GUI) biar hemat memori.
3. *Sabar adalah kunci.*
:::

## 🛠️ Virtualization & Lab

Tempat kita melakukan eksperimen tanpa takut merusak komputer asli.

| Software | Fungsi Utama | Keterangan |
| :--- | :--- | :--- |
| **VirtualBox** | Menjalankan OS di dalam OS. | Gratis, ringan, dan standar sekolah. Wajib punya ISO Debian & Windows. |
| **VMware Workstation** | Alternatif VirtualBox, lebih stabil. | Berbayar (ada versi Player gratis). Performa grafis lebih baik. |
| **Cisco Packet Tracer** | Simulasi jaringan Cisco dasar. | Wajib untuk materi Kelas X & XI. Ringan dan visual. |
| **GNS3 / EVE-NG** | Emulasi jaringan *real-device*. | Untuk simulasi tingkat lanjut (Mikrotik CHR, Cisco IOS asli). Butuh resource besar. |

## 📡 Network Configuration

Tools untuk "berbicara" dengan perangkat jaringan.

| Software | Fungsi Utama | Keterangan |
| :--- | :--- | :--- |
| **Winbox** | GUI remote Mikrotik. | "Nyawa" anak TKJ. Jangan sampai hilang. Selalu update ke versi terbaru. |
| **PuTTY** | Remote akses via SSH/Telnet. | Ringan, klasik. Bisa diganti dengan terminal modern. |
| **Termius** | SSH Client Modern (Cross-platform). | Sinkronisasi config antar device. UI cantik, fitur lengkap. |
| **Wireshark** | Packet analyzer / Sniffing. | Untuk analisis protokol jaringan dan troubleshooting mendalam. |

## 💻 Development & Text Editor

Karena network engineer modern juga harus bisa coding (sedikit).

| Software | Fungsi Utama | Keterangan |
| :--- | :--- | :--- |
| **VS Code** | Text editor sejuta umat. | Install ekstensi: *Remote - SSH*, *Python*, *YAML*, dan *Docker*. |
| **Notepad++** | Editor teks ringan. | Cepat untuk buka log file besar atau config sederhana. |
| **Git** | Version control system. | Untuk backup config dan kolaborasi tim. |

## 🔧 Utilities Tambahan

Kecil tapi sangat membantu.

*   **Ventoy**: Solusi modern untuk bootable USB. Cukup copy-paste banyak file ISO (Windows, Debian, Ubuntu) tanpa perlu format ulang.
*   **IP Scanner (Angry IP Scanner)**: Scan IP aktif dalam satu jaringan LAN dengan cepat.
*   **TeamViewer / AnyDesk**: Remote desktop jarak jauh.
*   **FileZilla**: Transfer file via FTP/SFTP ke server.

---

### 📥 Download Checklist

1.  [ ] **VirtualBox** + Extension Pack
2.  [ ] **Cisco Packet Tracer** (Login NetAcad)
3.  [ ] **Winbox** (Download dari mikrotik.com)
4.  [ ] **VS Code**
5.  [ ] **ISO Debian 12** (Bookworm)
6.  [ ] **ISO Windows 10/11** LTSC (Biar ringan)