---
title: Dasar Jaringan
description: Konsep fundamental jaringan komputer (OSI Layer, IP Address, Topologi).
---

Sebelum terjun ke konfigurasi router yang rumit, kita harus paham dulu "bahasa" yang digunakan oleh komputer untuk saling berkomunikasi.

## 🧅 OSI Layer (The Holy Grail)

Model OSI (Open Systems Interconnection) adalah standar komunikasi data yang terdiri dari 7 lapisan. Wajib hafal urutannya dari bawah (Physical) ke atas (Application) atau sebaliknya!

| No | Layer | Fungsi Utama | Perangkat/Protokol |
| :--- | :--- | :--- | :--- |
| 7 | **Application** | Antarmuka aplikasi dengan jaringan. | HTTP, FTP, SMTP, Browser |
| 6 | **Presentation** | Enkripsi, kompresi, dan format data. | SSL/TLS, JPEG, MP3 |
| 5 | **Session** | Mengelola sesi koneksi antar host. | NetBIOS, RPC |
| 4 | **Transport** | Pengiriman data reliable/unreliable. | **TCP**, **UDP**, Port Number |
| 3 | **Network** | Routing dan pengalamatan logis (IP). | **Router**, IP Address, ICMP |
| 2 | **Data Link** | Pengalamatan fisik (MAC) & error checking. | **Switch**, MAC Address, Ethernet |
| 1 | **Physical** | Transmisi bit data (0 & 1) via media fisik. | **Kabel UTP**, Hub, Sinyal Wifi |

:::note[Hapalan Cepat]
**A**nak **P**ak **S**oleh **T**idak **N**akal **D**alam **P**elajaran.
(Application, Presentation, Session, Transport, Network, Data Link, Physical)
:::

## 📬 IP Address (IPv4)

IP Address adalah alamat identitas komputer di jaringan. IPv4 terdiri dari 32-bit yang dibagi menjadi 4 oktet.

Contoh: `192.168.1.1`

### Kelas IP Address
Meskipun sekarang lebih sering pakai CIDR (Subnetting), konsep kelas ini tetap perlu diketahui.

*   **Kelas A**: `1.0.0.0` - `126.255.255.255` (Jaringan Skala Besar)
*   **Kelas B**: `128.0.0.0` - `191.255.255.255` (Jaringan Menengah)
*   **Kelas C**: `192.0.0.0` - `223.255.255.255` (Jaringan Kecil / LAN)

### IP Private vs IP Public
*   **IP Public**: Bisa diakses dari internet global. (Bayar ke ISP).
*   **IP Private**: Hanya berlaku di jaringan lokal (LAN). Gratis.
    *   `10.0.0.0/8`
    *   `172.16.0.0/12`
    *   `192.168.0.0/16` (Paling sering kamu pakai di lab)

## 🕸️ Topologi Jaringan

Cara menghubungkan komputer secara fisik.

1.  **Star**: Semua komputer terhubung ke satu perangkat pusat (Switch/Hub). Paling populer saat ini karena jika satu kabel putus, yang lain tidak terganggu.
2.  **Bus**: Menggunakan satu kabel backbone. (Jadul, rawan tabrakan data/collision).
3.  **Ring**: Berbentuk lingkaran cincin. Data berputar satu arah.
4.  **Mesh**: Setiap komputer terhubung ke semua komputer lain. Paling handal tapi paling boros kabel.

---

### 🧠 Cek Pemahaman
1.  Di layer berapa **Router** bekerja?
2.  Di layer berapa **Switch** bekerja?
3.  Kabel UTP ada di layer berapa?

*Jawaban: Layer 3 (Network), Layer 2 (Data Link), Layer 1 (Physical).*