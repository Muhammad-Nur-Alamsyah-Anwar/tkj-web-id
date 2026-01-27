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

> Catatan: native VLAN di kedua ujung trunk harus sama, kalau beda bakal muncul CDP warning.
