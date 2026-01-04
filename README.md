# TKJ Knowledge Hub

[![Built with Starlight](https://astro.badg.es/v2/built-with-starlight/tiny.svg)](https://starlight.astro.build)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.4-06B6D4?logo=tailwindcss&logoColor=white)](https://tailwindcss.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Situs referensi untuk siswa SMK jurusan Teknik Komputer dan Jaringan (TKJ). Isinya cheat sheet, catatan praktikum, dan template laporan — dikumpulkan supaya tidak perlu bolak-balik buka buku paket atau slide yang susah dicari. Live di [tkj.web.id](https://tkj.web.id).

---

## Isi Materi

**Mulai Di Sini**
- Pengenalan jurusan TKJ
- Tools wajib — VirtualBox, Cisco Packet Tracer, Wireshark

**Kelas X**
- Dasar jaringan — OSI layer, IP addressing, topologi
- Media transmisi — kabel UTP (T568A/B), fiber optic, kode warna
- Elektronika dasar — multimeter, komponen pasif, K3LH
- Komputer dasar — rakit PC, install OS, POST beep codes

**Kelas XI**
- Debian Server — DHCP, DNS (BIND9), Apache, FTP, Samba, SSH
- MikroTik — routing, NAT, firewall, hotspot, queue, PPTP VPN
- Cisco Packet Tracer — switch, router, VLAN, static routing, inter-VLAN

**Cheat Sheets**
- Perintah Linux
- Konfigurasi MikroTik CLI
- Tabel subnetting & CIDR

**Bank Laporan**
- Template laporan PKL / Prakerin

---

## Jalankan Lokal

Butuh Node.js 18+.

```bash
git clone https://github.com/Muhammad-Nur-Alamsyah-Anwar/tkj-web-id.git
cd tkj-web-id
npm install
npm run dev
```

Buka `http://localhost:4321`.

---

## Tech Stack

- [Astro](https://astro.build) v5 + [Starlight](https://starlight.astro.build)
- Tailwind CSS
- MDX + [Mermaid.js](https://mermaid.js.org) untuk diagram
- Deploy via Vercel

---

## Kontribusi

Lihat [CONTRIBUTING.md](CONTRIBUTING.md). Kalau ada materi yang salah, kurang lengkap, atau mau nambahin topik baru — pull request terbuka.

---

Dibuat oleh [Muhammad Nur Alamsyah Anwar](https://github.com/Muhammad-Nur-Alamsyah-Anwar). Capek nyari catatan yang tersebar di mana-mana. 🗂️
