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
## Konfigurasi STP di Cisco

Cek status STP:

```
Switch# show spanning-tree
Switch# show spanning-tree vlan 10
```

Set priority (untuk jadikan switch sebagai Root Bridge):

```
Switch(config)# spanning-tree vlan 10 priority 4096
```

Atau pakai shortcut:

```
Switch(config)# spanning-tree vlan 10 root primary
Switch(config)# spanning-tree vlan 10 root secondary
```

Cek Root Bridge terpilih:

```
Switch# show spanning-tree | include Root
```

## PortFast dan BPDU Guard

PortFast untuk port yang langsung terhubung ke end device (PC, printer), bukan ke switch lain. Ini membuat port langsung masuk Forwarding tanpa nunggu proses STP normal (50 detik).

```
Switch(config-if)# spanning-tree portfast
Switch(config-if)# spanning-tree bpduguard enable
```

BPDU Guard akan matikan port kalau tiba-tiba menerima BPDU (misalnya ada switch tidak sah disambungkan ke port itu).
