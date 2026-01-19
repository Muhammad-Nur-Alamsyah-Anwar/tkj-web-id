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
