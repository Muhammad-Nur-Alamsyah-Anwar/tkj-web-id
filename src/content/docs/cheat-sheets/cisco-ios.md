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
R1(config-if)# description LAN-Interface
R1(config-if)# exit
```
