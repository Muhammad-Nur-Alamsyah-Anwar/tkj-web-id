---
title: Cheat Sheet Subnetting
description: Panduan lengkap subnetting, VLSM, dan CIDR untuk praktik jaringan TKJ
---

# Cheat Sheet Subnetting

Referensi cepat untuk menghitung subnet, VLSM, dan memahami notasi CIDR dalam jaringan komputer.

---

## 1. Pengertian Subnet Mask

**Subnet mask** adalah angka 32-bit yang digunakan untuk membagi jaringan IP menjadi segmen-segmen lebih kecil (subnet).

Subnet mask terdiri dari:
- **Bagian Network (1)** — menentukan alamat jaringan
- **Bagian Host (0)** — menentukan alamat host dalam jaringan

### Contoh:
```
IP Address    : 192.168.1.10
Subnet Mask   : 255.255.255.0  =  /24
               (11111111.11111111.11111111.00000000)

Network bits  : 24 (semua 1)
Host bits     : 8  (semua 0)
```

### Kelas IP Address:

| Kelas | Range | Default Mask | Penggunaan |
|-------|-------|--------------|------------|
| A | 1.0.0.0 – 126.255.255.255 | /8 (255.0.0.0) | Jaringan besar |
| B | 128.0.0.0 – 191.255.255.255 | /16 (255.255.0.0) | Jaringan menengah |
| C | 192.0.0.0 – 223.255.255.255 | /24 (255.255.255.0) | Jaringan kecil |
| D | 224.0.0.0 – 239.255.255.255 | — | Multicast |
| E | 240.0.0.0 – 255.255.255.255 | — | Riset/Eksperimental |

### IP Private (RFC 1918):
| Range | CIDR | Penggunaan |
|-------|------|------------|
| 10.0.0.0 – 10.255.255.255 | 10.0.0.0/8 | LAN besar |
| 172.16.0.0 – 172.31.255.255 | 172.16.0.0/12 | LAN menengah |
| 192.168.0.0 – 192.168.255.255 | 192.168.0.0/16 | LAN rumah/kantor |

---

## 2. Tabel Subnet Lengkap (/24 sampai /30)

### Class C (/24 – /30)

| CIDR | Subnet Mask | Jumlah Host | Jumlah Subnet* | Blok |
|------|-------------|-------------|----------------|------|
| /24 | 255.255.255.0 | 254 | 1 | 256 |
| /25 | 255.255.255.128 | 126 | 2 | 128 |
| /26 | 255.255.255.192 | 62 | 4 | 64 |
| /27 | 255.255.255.224 | 30 | 8 | 32 |
| /28 | 255.255.255.240 | 14 | 16 | 16 |
| /29 | 255.255.255.248 | 6 | 32 | 8 |
| /30 | 255.255.255.252 | 2 | 64 | 4 |

> *Jumlah subnet dari network /24

### Rumus Penting:
- **Jumlah Host** = 2^(host bits) - 2
- **Jumlah Subnet** = 2^(subnet bits)
- **Blok Size** = 256 - nilai oktet terakhir subnet mask

---

## 3. Cara Menghitung Network Address, Broadcast, Host Range

### Langkah-langkah:

**Contoh:** IP = `192.168.1.130`, Subnet Mask = `255.255.255.192` (/26)

**Langkah 1:** Temukan blok size
```
Oktet terakhir subnet mask = 192
Blok size = 256 - 192 = 64
Blok-blok: 0, 64, 128, 192, 256...
```

**Langkah 2:** Temukan network address
```
130 berada di antara 128 dan 192
→ Network Address = 192.168.1.128
```

**Langkah 3:** Hitung broadcast
```
Broadcast = Network Address + Blok Size - 1
           = 128 + 64 - 1 = 191
→ Broadcast = 192.168.1.191
```

**Langkah 4:** Tentukan host range
```
Host pertama = Network Address + 1 = 192.168.1.129
Host terakhir = Broadcast - 1     = 192.168.1.190
Host range: 192.168.1.129 – 192.168.1.190
```

**Ringkasan:**
| Info | Nilai |
|------|-------|
| Network Address | 192.168.1.128 |
| Subnet Mask | 255.255.255.192 (/26) |
| Host Pertama | 192.168.1.129 |
| Host Terakhir | 192.168.1.190 |
| Broadcast | 192.168.1.191 |
| Jumlah Host | 62 |

---

## 4. Tabel Subnet Visual /24

Network: 192.168.1.0/24 dibagi menjadi beberapa subnet:

### Dibagi jadi 2 subnet (/25):
| Subnet | Network | Host Range | Broadcast |
|--------|---------|------------|-----------|
| Subnet 1 | 192.168.1.0 | .1 – .126 | 192.168.1.127 |
| Subnet 2 | 192.168.1.128 | .129 – .254 | 192.168.1.255 |

### Dibagi jadi 4 subnet (/26):
| Subnet | Network | Host Range | Broadcast |
|--------|---------|------------|-----------|
| Subnet 1 | 192.168.1.0 | .1 – .62 | 192.168.1.63 |
| Subnet 2 | 192.168.1.64 | .65 – .126 | 192.168.1.127 |
| Subnet 3 | 192.168.1.128 | .129 – .190 | 192.168.1.191 |
| Subnet 4 | 192.168.1.192 | .193 – .254 | 192.168.1.255 |

### Dibagi jadi 8 subnet (/27):
| Subnet | Network | Host Range | Broadcast |
|--------|---------|------------|-----------|
| 1 | 192.168.1.0 | .1 – .30 | .31 |
| 2 | 192.168.1.32 | .33 – .62 | .63 |
| 3 | 192.168.1.64 | .65 – .94 | .95 |
| 4 | 192.168.1.96 | .97 – .126 | .127 |
| 5 | 192.168.1.128 | .129 – .158 | .159 |
| 6 | 192.168.1.160 | .161 – .190 | .191 |
| 7 | 192.168.1.192 | .193 – .222 | .223 |
| 8 | 192.168.1.224 | .225 – .254 | .255 |

---

## 5. Contoh Soal VLSM

**VLSM (Variable Length Subnet Mask)** adalah teknik subnetting yang menggunakan subnet mask berbeda-beda sesuai kebutuhan host.

### Soal:
Sebuah SMK memiliki network 192.168.10.0/24. Bagi menjadi subnet untuk:
- Lab Komputer: 50 host
- Ruang Guru: 25 host
- Ruang TU: 10 host
- Link WAN Router-ISP: 2 host

### Penyelesaian VLSM:

**Urutkan dari kebutuhan host TERBESAR:**
1. Lab Komputer: 50 host → /26 (62 host)
2. Ruang Guru: 25 host → /27 (30 host)
3. Ruang TU: 10 host → /28 (14 host)
4. Link WAN: 2 host → /30 (2 host)

**Alokasi subnet:**

| Departemen | Kebutuhan | CIDR | Network | Host Range | Broadcast |
|------------|-----------|------|---------|------------|-----------|
| Lab Komputer | 50 host | /26 | 192.168.10.0 | .1 – .62 | 192.168.10.63 |
| Ruang Guru | 25 host | /27 | 192.168.10.64 | .65 – .94 | 192.168.10.95 |
| Ruang TU | 10 host | /28 | 192.168.10.96 | .97 – .110 | 192.168.10.111 |
| Link WAN | 2 host | /30 | 192.168.10.112 | .113 – .114 | 192.168.10.115 |
| Sisa (cadangan) | — | — | 192.168.10.116 | — | 192.168.10.255 |

---

## 6. Tabel CIDR Lengkap

### IPv4 CIDR Reference:

| CIDR | Subnet Mask | Host Bits | Jumlah Host | Jumlah Alamat |
|------|-------------|-----------|-------------|---------------|
| /8 | 255.0.0.0 | 24 | 16,777,214 | 16,777,216 |
| /9 | 255.128.0.0 | 23 | 8,388,606 | 8,388,608 |
| /10 | 255.192.0.0 | 22 | 4,194,302 | 4,194,304 |
| /11 | 255.224.0.0 | 21 | 2,097,150 | 2,097,152 |
| /12 | 255.240.0.0 | 20 | 1,048,574 | 1,048,576 |
| /13 | 255.248.0.0 | 19 | 524,286 | 524,288 |
| /14 | 255.252.0.0 | 18 | 262,142 | 262,144 |
| /15 | 255.254.0.0 | 17 | 131,070 | 131,072 |
| /16 | 255.255.0.0 | 16 | 65,534 | 65,536 |
| /17 | 255.255.128.0 | 15 | 32,766 | 32,768 |
| /18 | 255.255.192.0 | 14 | 16,382 | 16,384 |
| /19 | 255.255.224.0 | 13 | 8,190 | 8,192 |
| /20 | 255.255.240.0 | 12 | 4,094 | 4,096 |
| /21 | 255.255.248.0 | 11 | 2,046 | 2,048 |
| /22 | 255.255.252.0 | 10 | 1,022 | 1,024 |
| /23 | 255.255.254.0 | 9 | 510 | 512 |
| /24 | 255.255.255.0 | 8 | 254 | 256 |
| /25 | 255.255.255.128 | 7 | 126 | 128 |
| /26 | 255.255.255.192 | 6 | 62 | 64 |
| /27 | 255.255.255.224 | 5 | 30 | 32 |
| /28 | 255.255.255.240 | 4 | 14 | 16 |
| /29 | 255.255.255.248 | 3 | 6 | 8 |
| /30 | 255.255.255.252 | 2 | 2 | 4 |
| /31 | 255.255.255.254 | 1 | 0 (point-to-point) | 2 |
| /32 | 255.255.255.255 | 0 | 1 (host route) | 1 |

---

## 7. Tips Cepat Subnetting

### Rumus Cepat:

| Yang dicari | Rumus |
|-------------|-------|
| Jumlah host usable | 2^h - 2 (h = host bits) |
| Jumlah subnet | 2^s (s = subnet bits dipinjam) |
| Blok size | 256 - nilai oktet subnet mask |
| Network address | IP AND subnet mask |
| Broadcast | Network + blok size - 1 |

### Trik Menghafal Blok Size:

```
/25 → 128  (256/2)
/26 → 64   (256/4)
/27 → 32   (256/8)
/28 → 16   (256/16)
/29 → 8    (256/32)
/30 → 4    (256/64)
```

### Nilai Oktet Subnet Mask → CIDR:

| Nilai | CIDR (oktet 4) |
|-------|----------------|
| 0 | /24 |
| 128 | /25 |
| 192 | /26 |
| 224 | /27 |
| 240 | /28 |
| 248 | /29 |
| 252 | /30 |
| 254 | /31 |
| 255 | /32 |

<!-- rev: jan9 -->

<!-- rev: jan19 -->

<!-- rev: feb2 -->

<!-- update: 2026-02-14 -->

<!-- rev: feb24 -->

<!-- rev: mar2 -->

<!-- rev: mar10 -->

<!-- update: 2026-03-18 -->

<!-- rev: mar24 -->
