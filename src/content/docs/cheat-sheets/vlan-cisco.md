---
title: Cheat Sheet VLAN Cisco
description: Perintah-perintah konfigurasi VLAN di Cisco IOS untuk praktek TKJ.
---

# VLAN — Cisco IOS

VLAN (Virtual LAN) dipakai untuk memisahkan jaringan secara logis dalam satu switch fisik.

## Buat dan beri nama VLAN

```
Switch> enable
Switch# configure terminal
Switch(config)# vlan 10
Switch(config-vlan)# name Guru
Switch(config-vlan)# exit

Switch(config)# vlan 20
Switch(config-vlan)# name Siswa
Switch(config-vlan)# exit
```

## Assign port ke VLAN (access mode)

```
Switch(config)# interface fastEthernet 0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
Switch(config-if)# exit
```

## Konfigurasi trunk port

```
Switch(config)# interface fastEthernet 0/24
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20
Switch(config-if)# exit
```

## Verifikasi

```
Switch# show vlan brief
Switch# show interfaces trunk
Switch# show interfaces fastEthernet 0/1 switchport
```

## Inter-VLAN routing (Router-on-a-Stick)

Di router, buat subinterface untuk tiap VLAN:

```
Router(config)# interface fastEthernet 0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0
Router(config-subif)# exit

Router(config)# interface fastEthernet 0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0
Router(config-subif)# exit
```

## Hapus VLAN dari switch

```
Switch(config)# no vlan 20
```

Atau hapus assignment port dari VLAN:

```
Switch(config)# interface fastEthernet 0/2
Switch(config-if)# no switchport access vlan
```

## Native VLAN

Native VLAN dipakai untuk traffic untagged di trunk port. Default-nya VLAN 1, tapi sebaiknya diubah:

```
Switch(config-if)# switchport trunk native vlan 99
```

## Troubleshooting VLAN

Kalau dua host beda VLAN tidak bisa saling ping padahal sudah pakai router:

1. Cek trunk port aktif: `show interfaces trunk`
2. Pastikan VLAN allowed di trunk: `show interfaces fa0/24 trunk`
3. Cek subinterface router sudah up: `show ip interface brief`
4. Cek IP gateway client sudah benar

Kalau dua host sesama VLAN tidak bisa ping:

1. Cek port assignment: `show interfaces fa0/1 switchport`
2. Cek kabel fisik
3. Coba `ping` dari switch ke host, bukan antar host langsung

## VLAN di beberapa switch

Kalau ada lebih dari satu switch, VLAN perlu dibuat di semua switch. VLAN tidak otomatis terbagi via trunk — harus dikonfigurasi manual di tiap switch.

Atau pakai VTP (VLAN Trunking Protocol) untuk sinkronisasi otomatis:

```
! Mode server (satu switch utama)
Switch1(config)# vtp mode server
Switch1(config)# vtp domain TKJLAB
Switch1(config)# vtp password tkj123

! Mode client (switch lain)
Switch2(config)# vtp mode client
Switch2(config)# vtp domain TKJLAB
Switch2(config)# vtp password tkj123
```

Cek status VTP:

```
Switch# show vtp status
```

> Catatan: VTP mode transparent tidak ikut sinkronisasi tapi mau forward VTP advertisement.
