---
title: Perintah Cisco IOS
description: Quick reference perintah Cisco IOS yang sering dipakai di praktek TKJ.
---

# Cisco IOS — Quick Reference

Perintah yang sering keluar di ujian dan praktek Packet Tracer.

## Mode CLI

```
Router>           ← User EXEC mode (terbatas)
Router#           ← Privileged EXEC mode
Router(config)#   ← Global Configuration mode
Router(config-if)# ← Interface mode
```

Naik mode:

```
Router> enable
Router# configure terminal
Router(config)# interface fa0/0
```

Turun / keluar:

```
Router(config-if)# exit         ← balik ke global config
Router(config)# end             ← langsung ke privileged
Router# disable                 ← ke user mode
```

## Konfigurasi dasar router

```
Router(config)# hostname R1
R1(config)# enable secret cisco123
R1(config)# service password-encryption

! Banner login
R1(config)# banner motd # Authorized access only #

! Console password
R1(config)# line console 0
R1(config-line)# password lab123
R1(config-line)# login
R1(config-line)# exit

! VTY (Telnet/SSH)
R1(config)# line vty 0 4
R1(config-line)# password lab123
R1(config-line)# login
R1(config-line)# exit
```

## IP Address

```
R1(config)# interface fastEthernet 0/0
R1(config-if)# ip address 192.168.1.1 255.255.255.0
R1(config-if)# no shutdown
## Routing

```
! Default route
R1(config)# ip route 0.0.0.0 0.0.0.0 192.168.0.1

! Static route
R1(config)# ip route 10.0.0.0 255.0.0.0 192.168.1.2

! Cek routing table
R1# show ip route
```

## Show commands

```
R1# show running-config          ← konfigurasi aktif
R1# show startup-config          ← konfigurasi tersimpan
R1# show ip interface brief      ← ringkasan IP semua interface
R1# show interfaces              ← detail semua interface
R1# show ip route                ← routing table
R1# show version                 ← info IOS dan hardware
R1# show cdp neighbors           ← perangkat Cisco yang terhubung
```

## Save konfigurasi

```
R1# copy running-config startup-config
```

Atau shortcut:

```
R1# wr
```

## Hapus konfigurasi

```
## SSH di Cisco

```
! Generate RSA key (syarat SSH)
R1(config)# crypto key generate rsa modulus 1024
R1(config)# ip domain-name tkj.local
R1(config)# username admin privilege 15 secret lab123

R1(config)# line vty 0 4
R1(config-line)# transport input ssh
R1(config-line)# login local
R1(config-line)# exit

R1(config)# ip ssh version 2
```

## Troubleshooting cepat

```
! Cek interface down/up
R1# show ip interface brief | include down

! Cek apakah paket bisa lewat
R1# ping 192.168.1.2
R1# traceroute 8.8.8.8

! Debug routing (hati-hati, heavy di produksi)
R1# debug ip routing
R1# undebug all
```

## Tips singkatan

Cisco IOS menerima perintah yang disingkat asalkan tidak ambigu:
- `sh ip int br` = `show ip interface brief`
- `conf t` = `configure terminal`
- `int fa0/0` = `interface fastEthernet 0/0`
- `no sh` = `no shutdown`

## Konfigurasi DHCP di Router Cisco

```
R1(config)# ip dhcp pool LAN
R1(dhcp-config)# network 192.168.1.0 255.255.255.0
R1(dhcp-config)# default-router 192.168.1.1
R1(dhcp-config)# dns-server 8.8.8.8
R1(dhcp-config)# exit

! Exclude IP statis (jangan dibagikan ke client)
R1(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.10
```

Cek lease DHCP:

```
R1# show ip dhcp binding
R1# show ip dhcp pool
```

## NAT di Cisco

```
! Definisikan inside dan outside interface
R1(config)# interface fa0/0
R1(config-if)# ip nat inside
R1(config-if)# exit
R1(config)# interface fa0/1
R1(config-if)# ip nat outside
R1(config-if)# exit

! Buat access-list untuk jaringan lokal
R1(config)# access-list 1 permit 192.168.1.0 0.0.0.255

! NAT overload (PAT) — banyak IP private ke satu IP public
R1(config)# ip nat inside source list 1 interface fa0/1 overload
```

Cek NAT translation:

```
R1# show ip nat translations
R1# show ip nat statistics
```

## Konfigurasi OSPF sederhana

```
R1(config)# router ospf 1
R1(config-router)# network 192.168.1.0 0.0.0.255 area 0
R1(config-router)# network 10.0.0.0 0.0.0.255 area 0
R1(config-router)# exit
```

Cek OSPF:

```
R1# show ip ospf neighbor
R1# show ip route ospf
```
