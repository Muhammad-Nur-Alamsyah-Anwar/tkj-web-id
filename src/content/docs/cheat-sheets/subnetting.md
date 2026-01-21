---
title: Subnetting
description: Tabel subnet mask, rumus, dan contoh perhitungan subnetting IPv4.
---

# Subnetting IPv4

Subnetting adalah teknik membagi jaringan besar menjadi subnet-subnet kecil.

## Kelas IP Address

| Kelas | Range | Default Mask |
|-------|-------|-------------|
| A | 1.0.0.0 – 126.255.255.255 | /8 |
| B | 128.0.0.0 – 191.255.255.255 | /16 |
| C | 192.0.0.0 – 223.255.255.255 | /24 |

## IP Private (RFC 1918)

| Kelas | Range IP Private |
|-------|-----------------|
| A | 10.0.0.0 – 10.255.255.255 |
| B | 172.16.0.0 – 172.31.255.255 |
| C | 192.168.0.0 – 192.168.255.255 |

## Tabel CIDR

| CIDR | Subnet Mask | Jumlah Host |
|------|------------|-------------|
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |
| /28 | 255.255.255.240 | 14 |
| /29 | 255.255.255.248 | 6 |
| /30 | 255.255.255.252 | 2 |
| /32 | 255.255.255.255 | 1 (host route) |

**Rumus:** Jumlah host = 2^(32-CIDR) - 2

## Rumus Subnetting

```
Jumlah host     = 2^n - 2  (n = bit host = 32 - CIDR)
Jumlah subnet   = 2^m  (m = bit yang dipinjam)
Network Address = IP AND Subnet Mask
Broadcast       = Network OR NOT(Mask)
Host pertama    = Network + 1
Host terakhir   = Broadcast - 1
```

## Contoh Perhitungan

**Soal:** 192.168.10.0/26, berapa host?

```
CIDR /26 → bit host = 32 - 26 = 6
Jumlah host = 2^6 - 2 = 62 host
Subnet mask = 255.255.255.192

Network  : 192.168.10.0
Broadcast: 192.168.10.63
Host 1   : 192.168.10.1
Host last: 192.168.10.62
```

## Membagi Subnet

**Contoh:** 192.168.1.0/24 dibagi 4 subnet

```
Butuh 4 subnet → 2^2 = 4 → pinjam 2 bit
CIDR baru = /26, block size = 64

Subnet 1: 192.168.1.0/26   → .1 – .62    broadcast .63
Subnet 2: 192.168.1.64/26  → .65 – .126  broadcast .127
Subnet 3: 192.168.1.128/26 → .129 – .190 broadcast .191
Subnet 4: 192.168.1.192/26 → .193 – .254 broadcast .255
```

## VLSM (Variable Length Subnet Mask)

VLSM memungkinkan subnet berbeda ukuran sesuai kebutuhan.

**Contoh:** 192.168.10.0/24, kebutuhan: 50 host, 25 host, 10 host, 2 host

```
1. Urutkan dari terbesar ke terkecil
2. Alokasikan satu per satu

50 host → /26 (62 host) → 192.168.10.0/26
25 host → /27 (30 host) → 192.168.10.64/27
10 host → /28 (14 host) → 192.168.10.96/28
2 host  → /30 (2 host)  → 192.168.10.112/30
```
