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
## Display filters yang sering dipakai

| Filter | Keterangan |
|--------|------------|
| `ip.addr == 192.168.1.1` | Traffic dari/ke IP tertentu |
| `ip.src == 192.168.1.1` | Traffic dari IP tertentu |
| `ip.dst == 192.168.1.1` | Traffic ke IP tertentu |
| `tcp.port == 80` | Traffic HTTP |
| `tcp.port == 443` | Traffic HTTPS |
| `dns` | Semua traffic DNS |
| `icmp` | Semua ping (ICMP) |
| `dhcp` | Traffic DHCP |
| `arp` | Traffic ARP |
| `http` | Traffic HTTP (unencrypted) |

Contoh kombinasi:

```
ip.addr == 192.168.1.100 && tcp.port == 80
```

## Follow TCP Stream

Kalau mau lihat isi percakapan HTTP:

1. Klik kanan paket HTTP
2. Pilih **Follow → TCP Stream**
## Capture filters

Berbeda dari display filter, capture filter dibuat sebelum mulai capture dan lebih efisien karena hanya menyimpan paket yang sesuai filter.

Format pakai BPF syntax:

```
host 192.168.1.1           # hanya traffic ke/dari IP ini
port 80                     # hanya port 80
tcp                         # hanya TCP
not arp                     # exclude ARP
host 10.0.0.1 and port 22  # SSH ke server tertentu
```

## Skenario troubleshooting

### Cek apakah DHCP bekerja

Filter: `dhcp`

Harusnya ada 4 paket: DHCP Discover → Offer → Request → ACK. Kalau Offer tidak muncul, DHCP server tidak merespons.

### Cek koneksi DNS

Filter: `dns`

Harusnya ada DNS Query diikuti DNS Response. Kalau tidak ada Response, DNS server tidak bisa dijangkau.

### Diagnosa packet loss

Pakai filter `tcp.analysis.flags` — ini akan tampilkan paket yang Wireshark deteksi ada masalah seperti retransmisi, out-of-order, dll.

## Export hasil capture

Simpan file capture untuk dianalisis nanti atau dikirim ke guru:

```
File → Save As → pilih format .pcapng
```

Atau export hanya paket yang sudah difilter:

```
File → Export Specified Packets → check "Displayed" → Save
```

## Tips

- Wireshark menampilkan semua traffic di interface, termasuk yang tidak diminta. Pakai filter biar tidak pusing
- Kalau mau capture di VM, pastikan interface VM dalam mode **Bridged** atau **Host-only** tergantung kebutuhan
- Di Windows, Wireshark butuh **Npcap** untuk capture — biasanya sudah include di installer Wireshark

## Statistics

Wireshark punya menu Statistics yang berguna:

- **Statistics → Conversations** — lihat siapa ngobrol sama siapa, berapa bytes yang dikirim
- **Statistics → Protocol Hierarchy** — distribusi protokol dalam capture, berguna buat lihat anomali (misal banyak banget ARP)
- **Statistics → IO Graph** — grafik throughput vs waktu
