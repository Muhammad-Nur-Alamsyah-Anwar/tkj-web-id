---
title: Wireshark untuk Troubleshooting
description: Dasar-dasar Wireshark untuk analisis paket dan troubleshooting jaringan kelas XI.
---

# Wireshark — Dasar Packet Analysis

Wireshark dipakai untuk capture dan analisis traffic jaringan. Berguna banget waktu troubleshooting — bisa lihat paket apa yang sebenarnya jalan di jaringan.

## Install

Di Debian/Ubuntu:

```bash
apt install wireshark
```

Waktu install akan ditanya apakah non-root user boleh capture — pilih **Yes** kalau mau capture tanpa sudo.

Tambahkan user ke group wireshark:

```bash
usermod -aG wireshark $USER
```

Logout dan login ulang biar group-nya aktif.

## Antarmuka

- **Capture bar** — pilih interface mana yang mau di-capture (eth0, wlan0, dll)
- **Filter bar** — ketik filter untuk menyaring paket
- **Packet list** — daftar paket yang tertangkap
- **Packet details** — isi detail header tiap layer
- **Packet bytes** — raw data dalam hex dan ASCII

## Mulai capture

1. Buka Wireshark
2. Pilih interface (biasanya eth0 atau enp0s3 di VM)
3. Klik tombol hiu biru (Start Capturing Packets)
4. Lakukan aktivitas jaringan yang mau di-analisis
5. Klik tombol merah (Stop) untuk berhenti
