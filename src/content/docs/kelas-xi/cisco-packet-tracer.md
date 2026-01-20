---
title: Cisco Packet Tracer Kelas XI
description: Panduan lengkap penggunaan Cisco Packet Tracer untuk simulasi jaringan TKJ kelas XI
---

# Cisco Packet Tracer — Kelas XI TKJ

Panduan lengkap untuk menggunakan Cisco Packet Tracer dalam simulasi dan konfigurasi jaringan komputer.

---

## 1. Instalasi Packet Tracer

### Download:
1. Daftar akun di [Cisco Networking Academy](https://www.netacad.com)
2. Login ke NetAcad
3. Pergi ke **Resources → Download Packet Tracer**
4. Pilih versi untuk OS (Windows/Linux/Mac)

### Instalasi Windows:
1. Download file `.exe` dari NetAcad
2. Double-click installer
3. Ikuti wizard instalasi
4. Saat pertama buka → login dengan akun NetAcad

### Instalasi Linux (Ubuntu/Debian):
```bash
# Install dependencies
sudo apt install -y libqt5webkit5 libqt5multimediawidgets5

# Install .deb file
sudo dpkg -i CiscoPacketTracer_*.deb

# Jalankan
PacketTracer
```

### Antarmuka Packet Tracer:

```
┌─────────────────────────────────────────────────────┐
│ Menu Bar (File, Edit, Options, View, Extensions)     │
├─────────────────────────────────────────────────────┤
│                                                       │
│           Area Kerja (Workspace)                      │
│                                                       │
├─────────────────────────────────────────────────────┤
│ Panel Perangkat (Device Panel)                        │
│ [Router][Switch][Hub][Wireless][End Device][WAN]     │
├─────────────────────────────────────────────────────┤
│ Logical/Physical | Realtime/Simulation                │
└─────────────────────────────────────────────────────┘
```

---

## 2. Konfigurasi Switch Dasar

### Topologi Sederhana:
```
PC1 ──── [Switch] ──── PC2
              |
             PC3
```

### Langkah Konfigurasi Switch:

**Klik switch → CLI → Enter**

```
Switch> enable
Switch# configure terminal
Switch(config)#
```

### Set Hostname:

```
Switch(config)# hostname SW-TKJ-01
SW-TKJ-01(config)#
```

### Set Password Konsol:

```
SW-TKJ-01(config)# line console 0
SW-TKJ-01(config-line)# password cisco123
SW-TKJ-01(config-line)# login
SW-TKJ-01(config-line)# exit
```

### Set Password Enable (Privileged):

```
SW-TKJ-01(config)# enable password cisco123
# atau lebih aman (terenkripsi):
SW-TKJ-01(config)# enable secret Cisco@2026
```

### Set Password VTY (Telnet/SSH):

```
SW-TKJ-01(config)# line vty 0 15
SW-TKJ-01(config-line)# password cisco123
SW-TKJ-01(config-line)# login
SW-TKJ-01(config-line)# exit
```

### Enkripsi Semua Password:

```
SW-TKJ-01(config)# service password-encryption
```

### Set IP Management Switch:

```
SW-TKJ-01(config)# interface vlan 1
SW-TKJ-01(config-if)# ip address 192.168.1.2 255.255.255.0
SW-TKJ-01(config-if)# no shutdown
SW-TKJ-01(config-if)# exit
SW-TKJ-01(config)# ip default-gateway 192.168.1.1
```

### VLAN Configuration:

```
# Buat VLAN
SW-TKJ-01(config)# vlan 10
SW-TKJ-01(config-vlan)# name GURU
SW-TKJ-01(config-vlan)# exit

SW-TKJ-01(config)# vlan 20
SW-TKJ-01(config-vlan)# name SISWA
SW-TKJ-01(config-vlan)# exit

# Assign port ke VLAN (access mode)
SW-TKJ-01(config)# interface fastEthernet 0/1
SW-TKJ-01(config-if)# switchport mode access
SW-TKJ-01(config-if)# switchport access vlan 10
SW-TKJ-01(config-if)# exit

SW-TKJ-01(config)# interface fastEthernet 0/2
SW-TKJ-01(config-if)# switchport mode access
SW-TKJ-01(config-if)# switchport access vlan 20
SW-TKJ-01(config-if)# exit

# Set trunk port (ke router atau switch lain)
SW-TKJ-01(config)# interface gigabitEthernet 0/1
SW-TKJ-01(config-if)# switchport mode trunk
SW-TKJ-01(config-if)# exit

# Lihat VLAN
SW-TKJ-01# show vlan brief
```

### Simpan Konfigurasi:

```
SW-TKJ-01# write memory
# atau
SW-TKJ-01# copy running-config startup-config
```

---

## 3. Konfigurasi Router Dasar

### Topologi:
```
[PC-LAN] ──── [Router] ──── [PC-WAN / Cloud Internet]
```

### Masuk ke Router CLI:

```
Router> enable
Router# configure terminal
Router(config)#
```

### Set Hostname:

```
Router(config)# hostname R-TKJ-01
R-TKJ-01(config)#
```

### Konfigurasi Interface:

```
# Interface ke LAN (GigabitEthernet 0/0)
R-TKJ-01(config)# interface gigabitEthernet 0/0
R-TKJ-01(config-if)# ip address 192.168.1.1 255.255.255.0
R-TKJ-01(config-if)# no shutdown
R-TKJ-01(config-if)# description LAN Interface
R-TKJ-01(config-if)# exit

# Interface ke WAN (GigabitEthernet 0/1)
R-TKJ-01(config)# interface gigabitEthernet 0/1
R-TKJ-01(config-if)# ip address 10.0.0.1 255.255.255.252
R-TKJ-01(config-if)# no shutdown
R-TKJ-01(config-if)# description WAN Interface
R-TKJ-01(config-if)# exit
```

### Set Password:

```
R-TKJ-01(config)# enable secret Cisco@2026
R-TKJ-01(config)# line console 0
R-TKJ-01(config-line)# password cisco123
R-TKJ-01(config-line)# login
R-TKJ-01(config-line)# exit
R-TKJ-01(config)# service password-encryption
```

### Cek Konfigurasi:

```
# Lihat semua interface dan status
R-TKJ-01# show ip interface brief

# Lihat routing table
R-TKJ-01# show ip route

# Lihat konfigurasi berjalan
R-TKJ-01# show running-config
```

---

## 4. Static Routing Antar Jaringan

### Topologi:
```
[LAN-A: 192.168.1.0/24]                [LAN-B: 192.168.2.0/24]
PC-A ── [R-A] ──────── serial link ──────── [R-B] ── PC-B
         .1    10.0.0.1 --- 10.0.0.2    .1
```

### Konfigurasi Router A:

```
R-A(config)# interface gigabitEthernet 0/0
R-A(config-if)# ip address 192.168.1.1 255.255.255.0
R-A(config-if)# no shutdown
R-A(config-if)# exit

R-A(config)# interface serial 0/0/0
R-A(config-if)# ip address 10.0.0.1 255.255.255.252
R-A(config-if)# no shutdown
R-A(config-if)# exit

# Static route ke LAN-B via Router B
R-A(config)# ip route 192.168.2.0 255.255.255.0 10.0.0.2

# Default route ke internet (jika ada)
R-A(config)# ip route 0.0.0.0 0.0.0.0 10.0.0.2
```

### Konfigurasi Router B:

```
R-B(config)# interface gigabitEthernet 0/0
R-B(config-if)# ip address 192.168.2.1 255.255.255.0
R-B(config-if)# no shutdown
R-B(config-if)# exit

R-B(config)# interface serial 0/0/0
R-B(config-if)# ip address 10.0.0.2 255.255.255.252
R-B(config-if)# no shutdown
R-B(config-if)# exit

# Static route ke LAN-A via Router A
R-B(config)# ip route 192.168.1.0 255.255.255.0 10.0.0.1
```

### Verifikasi:

```
# Cek routing table
R-A# show ip route

# Ping ke LAN B dari Router A
R-A# ping 192.168.2.1

# Ping ke LAN B dari PC-A
# (Gunakan fitur ping di PC simulator Packet Tracer)
```

---

## 5. Inter-VLAN Routing

Inter-VLAN routing memungkinkan traffic antara VLAN yang berbeda lewat router.

### Topologi Router-on-a-Stick:

```
VLAN 10 (Guru: 192.168.10.0/24)     VLAN 20 (Siswa: 192.168.20.0/24)
  PC-Guru ──┐                            ┌── PC-Siswa
            └──── [SW-AKSES] ────── [R-ROUTER]
```

### Konfigurasi Switch (Trunk ke Router):

```
SW(config)# vlan 10
SW(config-vlan)# name GURU
SW(config-vlan)# exit

SW(config)# vlan 20
SW(config-vlan)# name SISWA
SW(config-vlan)# exit

# Access port untuk PC-Guru
SW(config)# interface fastEthernet 0/1
SW(config-if)# switchport mode access
SW(config-if)# switchport access vlan 10
SW(config-if)# exit

# Access port untuk PC-Siswa
SW(config)# interface fastEthernet 0/2
SW(config-if)# switchport mode access
SW(config-if)# switchport access vlan 20
SW(config-if)# exit

# Trunk port ke Router
SW(config)# interface gigabitEthernet 0/1
SW(config-if)# switchport mode trunk
SW(config-if)# exit
```

### Konfigurasi Router (Sub-interface):

```
# Interface fisik harus no shutdown
R(config)# interface gigabitEthernet 0/0
R(config-if)# no shutdown
R(config-if)# exit

# Sub-interface untuk VLAN 10
R(config)# interface gigabitEthernet 0/0.10
R(config-subif)# encapsulation dot1Q 10
R(config-subif)# ip address 192.168.10.1 255.255.255.0
R(config-subif)# exit

# Sub-interface untuk VLAN 20
R(config)# interface gigabitEthernet 0/0.20
R(config-subif)# encapsulation dot1Q 20
R(config-subif)# ip address 192.168.20.1 255.255.255.0
R(config-subif)# exit
```

### Konfigurasi PC (default gateway):
- PC-Guru: IP 192.168.10.10, Gateway 192.168.10.1
- PC-Siswa: IP 192.168.20.10, Gateway 192.168.20.1

### Verifikasi Inter-VLAN:

```
# Dari PC-Guru ping ke PC-Siswa
ping 192.168.20.10  → seharusnya berhasil

# Dari Router
R# show ip route
R# show ip interface brief
```

---

## 6. Tips & Shortcuts Packet Tracer

### Keyboard Shortcuts:
| Shortcut | Fungsi |
|----------|--------|
| Ctrl+Z | Undo |
| Del | Hapus perangkat/kabel |
| Alt+drag | Drag area kerja |
| Ctrl+S | Simpan topologi |
| Space | Pause simulation |

### Mode Simulasi:
1. Klik **Simulation** (kanan bawah)
2. Klik **Edit Filters** → pilih protokol yang mau dipantau (ICMP, ARP, dll)
3. Gunakan **Play** atau **Next Step** untuk lihat aliran paket

### Jenis Kabel:
| Kabel | Digunakan untuk |
|-------|-----------------|
| Straight-through | PC ke Switch, Switch ke Router |
| Crossover | PC ke PC langsung, Switch ke Switch |
| Serial DTE/DCE | Router ke Router (WAN) |
| Console | PC ke Switch/Router (konfigurasi) |

> **Tip:** Gunakan **Automatically Choose Connection Type** agar Packet Tracer otomatis pilih kabel yang benar.

### Perintah Cisco IOS yang Sering Dipakai:

```
? → bantuan konteks
Tab → autocomplete
Ctrl+C → batalkan perintah
Ctrl+Z → keluar ke privileged mode
no <perintah> → hapus/batalkan konfigurasi
show running-config → lihat config aktif
show startup-config → lihat config tersimpan
show ip interface brief → ringkasan interface
show ip route → routing table
show vlan brief → daftar VLAN
ping <ip> → test konektivitas
traceroute <ip> → traceroute
```

<!-- rev: jan20 -->
