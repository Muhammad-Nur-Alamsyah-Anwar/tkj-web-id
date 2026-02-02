---
title: STP (Spanning Tree Protocol)
description: Materi STP kelas XI — cara kerja dan konfigurasi di Cisco Packet Tracer.
---

# STP — Spanning Tree Protocol

STP dipakai untuk mencegah loop di jaringan yang punya lebih dari satu path antar switch. Tanpa STP, broadcast storm bisa melumpuhkan jaringan.

## Cara kerja STP

1. Semua switch pilih satu **Root Bridge** — switch dengan Bridge ID (BID) paling kecil
2. Switch bukan Root Bridge tentukan **Root Port** — port menuju Root Bridge lewat jalur terpendek
3. Tiap segmen jaringan pilih **Designated Port** — port yang forward traffic di segmen itu
4. Port yang tersisa masuk state **Blocking** — tidak forward, tapi tetap dengerin BPDU

## Bridge ID (BID)

BID = Priority (2 byte) + MAC Address (6 byte)

Default priority = 32768. Switch dengan priority paling rendah jadi Root Bridge. Kalau priority sama, MAC address paling kecil yang menang.

## Port states

| State | Keterangan |
|-------|------------|
| Blocking | Tidak forward frame, hanya terima BPDU |
| Listening | Tidak forward, tidak belajar MAC |
| Learning | Tidak forward, sudah belajar MAC |
| Forwarding | Forward frame normal |
| Disabled | Port dimatikan admin |
