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

## RSTP (Rapid STP)

RSTP (802.1w) versi lebih cepat dari STP klasik. Convergence time turun dari ~50 detik ke beberapa detik.

Di Cisco IOS modern RSTP sudah default (PVST+ atau Rapid-PVST+):

```
Switch(config)# spanning-tree mode rapid-pvst
```

Cek mode yang sedang berjalan:

```
Switch# show spanning-tree | include mode
```

## Tips ujian

- Root Bridge = BID paling kecil = priority paling kecil (atau MAC terkecil kalau priority sama)
- Default priority 32768 + VLAN ID
- Port ke Root Bridge = Root Port
- Satu Designated Port per segmen
- Sisanya Blocking

## Contoh perhitungan Root Bridge

Misal ada 3 switch dengan priority sama (32768):

| Switch | MAC Address |
|--------|------------|
| SW1 | 0001.0000.0001 |
| SW2 | 0001.0000.0003 |
| SW3 | 0001.0000.0002 |

Root Bridge = SW1 karena MAC paling kecil.

Kalau mau paksa SW2 jadi Root Bridge:

```
SW2(config)# spanning-tree vlan 1 priority 4096
```

Sekarang SW2 punya BID = 4096 + MAC, lebih kecil dari SW1 (32768 + MAC).

## STP timers

| Timer | Default | Keterangan |
|-------|---------|------------|
| Hello Time | 2 detik | Interval pengiriman BPDU dari Root Bridge |
| Forward Delay | 15 detik | Waktu di state Listening dan Learning |
| Max Age | 20 detik | Berapa lama BPDU tersimpan sebelum dianggap stale |

Total convergence STP klasik = 2 × Forward Delay = 30 detik (belum termasuk deteksi failure).

Tidak disarankan mengubah timer ini kecuali kamu tahu apa yang dilakukan.

## Troubleshooting STP

Kalau jaringan tiba-tiba lambat atau broadcast storm:

1. Cek apakah ada loop: `show spanning-tree` — lihat port mana yang Blocking
2. Kalau ada port seharusnya Blocking tapi Forwarding, mungkin STP tidak jalan
3. Aktifkan STP: `spanning-tree vlan 1` (seharusnya sudah default aktif)

Kalau konvergensi terlalu lambat setelah topologi berubah:
- Pertimbangkan RSTP: `spanning-tree mode rapid-pvst`
- Aktifkan PortFast di port end device

## Kenapa STP penting

Di lab sering dikira tidak penting karena topologi sederhana. Tapi di jaringan nyata dengan banyak switch dan link redundan, tanpa STP satu kabel yang salah sambung bisa bikin seluruh jaringan down karena broadcast storm.

## Latihan soal

1. Ada 3 switch dengan priority default. MAC address: SW1=0001, SW2=0003, SW3=0002. Switch mana yang jadi Root Bridge?
2. Sebutkan 5 port state STP
3. Apa bedanya PortFast dan BPDU Guard?
4. Kenapa STP memakai Forward Delay 15 detik di dua state (Listening dan Learning)?

Jawaban no 1: SW1 (MAC address paling kecil)
