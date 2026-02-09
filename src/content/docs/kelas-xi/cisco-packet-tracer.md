---
title: Cisco Packet Tracer
description: Tutorial dan lab Packet Tracer.
---

Kumpulan topologi dan konfigurasi routing/switching Cisco dasar hingga menengah.

## Konfigurasi Switch VLAN

```
Switch> enable
Switch# configure terminal

! Buat VLAN
Switch(config)# vlan 10
Switch(config-vlan)# name GURU
Switch(config-vlan)# exit

Switch(config)# vlan 20
Switch(config-vlan)# name SISWA
Switch(config-vlan)# exit

! Assign port ke VLAN (access mode)
Switch(config)# interface fastEthernet 0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
Switch(config-if)# exit

! Trunk port (ke router)
Switch(config)# interface fastEthernet 0/24
Switch(config-if)# switchport mode trunk
Switch(config-if)# exit

Switch(config)# end
Switch# write memory
```
