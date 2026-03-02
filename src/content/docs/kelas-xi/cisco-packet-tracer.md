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

## Konfigurasi Router-on-a-Stick (Inter-VLAN Routing)

```
Router> enable
Router# configure terminal

! Subinterface untuk VLAN 10
Router(config)# interface fastEthernet 0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0
Router(config-subif)# exit

! Subinterface untuk VLAN 20
Router(config)# interface fastEthernet 0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0
Router(config-subif)# exit

! Aktifkan interface utama
Router(config)# interface fastEthernet 0/0
Router(config-if)# no shutdown
Router(config-if)# end
Router# write memory
```

## DHCP di Cisco Router

```
Router(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.9

Router(config)# ip dhcp pool LAN-POOL
Router(dhcp-config)# network 192.168.1.0 255.255.255.0
Router(dhcp-config)# default-router 192.168.1.1
Router(dhcp-config)# dns-server 8.8.8.8
Router(dhcp-config)# lease 7
Router(dhcp-config)# exit

! Cek DHCP lease
Router# show ip dhcp binding
Router# show ip dhcp pool
```

## Static Routing

```
! Lihat routing table
Router# show ip route

! Tambah static route
Router(config)# ip route 192.168.2.0 255.255.255.0 192.168.1.254

! Default route
Router(config)# ip route 0.0.0.0 0.0.0.0 10.0.0.1

! Hapus static route
Router(config)# no ip route 192.168.2.0 255.255.255.0 192.168.1.254
```

## STP (Spanning Tree Protocol)

STP mencegah loop di jaringan dengan memilih satu jalur aktif.

```
! Lihat status STP
Switch# show spanning-tree

! Set root bridge
Switch(config)# spanning-tree vlan 1 priority 4096

! PortFast (untuk end device, bukan switch lain)
Switch(config)# interface fa0/1
Switch(config-if)# spanning-tree portfast
```

## EtherChannel (Link Aggregation)

```
! Gabungkan 2 port menjadi 1 logical link
Switch(config)# interface range fa0/1-2
Switch(config-if-range)# channel-group 1 mode active
Switch(config-if-range)# exit

Switch(config)# interface port-channel 1
Switch(config-if)# switchport mode trunk
```
