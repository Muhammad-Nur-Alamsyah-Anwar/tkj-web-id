---
title: Subnetting
description: Panduan lengkap subnetting IPv4, tabel subnet mask, VLSM, dan contoh perhitungan.
---

# Subnetting IPv4

Subnetting adalah teknik membagi satu jaringan besar menjadi beberapa jaringan kecil (subnet). Wajib dikuasai untuk ujian MTCNA, CCNA, dan UKK TKJ.

---

## Konsep Dasar

### Kelas IP Address

| Kelas | Range | Default Mask | Bit Network | Bit Host |
|-------|-------|-------------|-------------|----------|
| A | 1.0.0.0 – 126.255.255.255 | /8 (255.0.0.0) | 8 bit | 24 bit |
| B | 128.0.0.0 – 191.255.255.255 | /16 (255.255.0.0) | 16 bit | 16 bit |
| C | 192.0.0.0 – 223.255.255.255 | /24 (255.255.255.0) | 24 bit | 8 bit |

### IP Private (RFC 1918)

| Kelas | Range IP Private |
|-------|-----------------|
| A | 10.0.0.0 – 10.255.255.255 |
| B | 172.16.0.0 – 172.31.255.255 |
| C | 192.168.0.0 – 192.168.255.255 |

---

## Tabel Subnet Mask Lengkap (CIDR)

| CIDR | Subnet Mask | Jumlah Host | Jumlah Subnet (dari /24) |
|------|------------|-------------|--------------------------|
| /24 | 255.255.255.0 | 254 | 1 |
| /25 | 255.255.255.128 | 126 | 2 |
| /26 | 255.255.255.192 | 62 | 4 |
| /27 | 255.255.255.224 | 30 | 8 |
| /28 | 255.255.255.240 | 14 | 16 |
| /29 | 255.255.255.248 | 6 | 32 |
| /30 | 255.255.255.252 | 2 | 64 |
| /31 | 255.255.255.254 | 0* | 128 |
| /32 | 255.255.255.255 | 1 (host route) | 256 |

> **/31** digunakan untuk point-to-point link (RFC 3021).  
> **Rumus host:** 2^n - 2 (n = jumlah bit host)

---

## Rumus Subnetting

```
Jumlah host per subnet  = 2^(32 - CIDR) - 2
Jumlah subnet           = 2^(bit yang dipinjam)
Network Address         = IP AND Subnet Mask
Broadcast Address       = Network Address OR NOT(Subnet Mask)
Host pertama            = Network Address + 1
Host terakhir           = Broadcast Address - 1
```

---

## Contoh Perhitungan

### Soal 1: Berapa host dari 192.168.10.0/26?

```
CIDR = /26 → bit host = 32 - 26 = 6
Jumlah host = 2^6 - 2 = 64 - 2 = 62 host
Subnet mask = 255.255.255.192

Network  : 192.168.10.0
Broadcast: 192.168.10.63
Host 1   : 192.168.10.1
Host last: 192.168.10.62
```

### Soal 2: 192.168.1.0/24 dibagi 4 subnet

```
Butuh 4 subnet → 2^2 = 4 → pinjam 2 bit
CIDR baru = /24 + 2 = /26
Subnet mask = 255.255.255.192
Block size = 256 - 192 = 64

Subnet 1: 192.168.1.0/26   → host: .1 – .62   → broadcast: .63
Subnet 2: 192.168.1.64/26  → host: .65 – .126  → broadcast: .127
Subnet 3: 192.168.1.128/26 → host: .129 – .190 → broadcast: .191
Subnet 4: 192.168.1.192/26 → host: .193 – .254 → broadcast: .255
```

---

## VLSM (Variable Length Subnet Mask)

VLSM memungkinkan kita membagi subnet dengan ukuran berbeda-beda sesuai kebutuhan. Ini lebih efisien dari subnetting biasa.

### Langkah VLSM

1. **Urutkan kebutuhan host dari terbesar ke terkecil**
2. **Alokasikan subnet terbesar pertama**
3. **Lanjutkan ke subnet berikutnya dari sisa space**

### Contoh VLSM

**Jaringan:** 192.168.10.0/24  
**Kebutuhan:**
- Ruang A: 50 host
- Ruang B: 25 host
- Ruang C: 10 host
- Link Router: 2 host

**Langkah:**

```
Ruang A — 50 host → butuh /26 (62 host)
  Subnet: 192.168.10.0/26
  Range:  192.168.10.1 – 192.168.10.62
  Broadcast: 192.168.10.63

Ruang B — 25 host → butuh /27 (30 host)
  Subnet: 192.168.10.64/27
  Range:  192.168.10.65 – 192.168.10.94
  Broadcast: 192.168.10.95

Ruang C — 10 host → butuh /28 (14 host)
  Subnet: 192.168.10.96/28
  Range:  192.168.10.97 – 192.168.10.110
  Broadcast: 192.168.10.111

Link Router — 2 host → butuh /30 (2 host)
  Subnet: 192.168.10.112/30
  Range:  192.168.10.113 – 192.168.10.114
  Broadcast: 192.168.10.115
```

---

## Trik Cepat Menghitung Subnet

### Magic Number Method

```
Magic number = 256 - nilai oktet subnet mask

Contoh: subnet mask 255.255.255.192
  Magic number = 256 - 192 = 64

Subnet kelipatan 64:
  .0, .64, .128, .192
```

### Tabel Oktet Terakhir untuk /25 – /30

| Mask | Magic | Subnet (kelipatan) |
|------|-------|-------------------|
| .128 (/25) | 128 | 0, 128 |
| .192 (/26) | 64 | 0, 64, 128, 192 |
| .224 (/27) | 32 | 0, 32, 64, 96, 128, 160, 192, 224 |
| .240 (/28) | 16 | 0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240 |
| .248 (/29) | 8 | 0, 8, 16, 24, ... |
| .252 (/30) | 4 | 0, 4, 8, 12, ... |

---

## IPv6 Dasar

| Komponen | Keterangan |
|----------|-----------|
| Panjang | 128 bit (32 hex digit) |
| Notasi | 2001:0db8:85a3:0000:0000:8a2e:0370:7334 |
| Loopback | ::1 |
| Link-local | fe80::/10 |
| Global Unicast | 2000::/3 |
| Prefix standar LAN | /64 |

---

## Latihan Soal

1. Berapa jumlah host dari 10.0.0.0/20?
2. Tentukan network address dari IP 172.16.45.130/20
3. Bagi 10.10.10.0/24 menjadi 8 subnet sama besar
4. Hitung VLSM untuk: 100 host, 50 host, 20 host, 5 host dari 192.168.50.0/24

<details>
<summary>Kunci Jawaban</summary>

1. /20 → bit host = 12 → 2^12 - 2 = **4094 host**
2. Mask /20 = 255.255.240.0 → 45 AND 240 = 32 → **Network: 172.16.32.0/20**
3. 8 subnet → /27 → block 32 → subnet: .0/27, .32/27, .64/27, .96/27, .128/27, .160/27, .192/27, .224/27
4. 100 host→/25 (192.168.50.0), 50 host→/26 (192.168.50.128), 20 host→/27 (192.168.50.192), 5 host→/29 (192.168.50.224)

</details>
