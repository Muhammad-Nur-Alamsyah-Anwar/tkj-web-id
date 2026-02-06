---
title: ACL Cisco (Access Control List)
description: Materi ACL kelas XI — filter traffic di router Cisco dengan ACL standard dan extended.
---

# ACL — Access Control List

ACL dipakai untuk filter traffic yang masuk atau keluar dari interface router. Bisa blokir host tertentu, izinkan jaringan tertentu, atau batasi akses ke layanan.

## Tipe ACL

- **Standard ACL** — filter berdasarkan IP sumber saja. Nomor 1–99 dan 1300–1999.
- **Extended ACL** — filter berdasarkan IP sumber, IP tujuan, protokol, dan port. Nomor 100–199 dan 2000–2699.

## Standard ACL

```
Router(config)# access-list 10 permit 192.168.1.0 0.0.0.255
Router(config)# access-list 10 deny any
```

Wildcard mask = kebalikan subnet mask. `/24` → `0.0.0.255`

Terapkan ke interface (dekat tujuan):

```
Router(config)# interface fastEthernet 0/1
Router(config-if)# ip access-group 10 out
```

## Extended ACL

```
Router(config)# access-list 110 permit tcp 192.168.1.0 0.0.0.255 any eq 80
Router(config)# access-list 110 permit tcp 192.168.1.0 0.0.0.255 any eq 443
Router(config)# access-list 110 deny ip any any
```

Artinya: izinkan HTTP dan HTTPS dari jaringan 192.168.1.0/24, blokir sisanya.

```
Router(config-if)# ip access-group 110 in
```

## Cek ACL

```
Router# show access-lists
Router# show ip interface fastEthernet 0/1
```

## Named ACL

```
Router(config)# ip access-list extended BLOKIR-FTP
Router(config-ext-nacl)# deny tcp any any eq 21
Router(config-ext-nacl)# permit ip any any
Router(config-ext-nacl)# exit

Router(config)# interface fa0/0
Router(config-if)# ip access-group BLOKIR-FTP in
```

## Aturan penting ACL

1. ACL diproses dari atas ke bawah — urutan baris penting
2. Di akhir setiap ACL ada implicit `deny any` — kalau tidak ada permit sama sekali, semua diblokir
3. Standard ACL ditaruh dekat tujuan, Extended ACL dekat sumber
4. Satu interface bisa punya satu ACL per arah (in/out)

## Hapus ACL

```
Router(config)# no access-list 10
Router(config)# no ip access-list extended BLOKIR-FTP
```

Kalau sudah diterapkan ke interface, hapus dulu dari interface:

```
Router(config-if)# no ip access-group 10 out
```

## Contoh kasus

### Skenario 1: Blokir satu host dari akses internet

```
Router(config)# access-list 101 deny ip host 192.168.1.100 any
Router(config)# access-list 101 permit ip any any
```

`host 192.168.1.100` = wildcard `192.168.1.100 0.0.0.0`

### Skenario 2: Izinkan hanya DNS dan HTTP ke server

```
Router(config)# access-list 102 permit udp any host 10.0.0.1 eq 53
Router(config)# access-list 102 permit tcp any host 10.0.0.1 eq 80
Router(config)# access-list 102 deny ip any any
```

### Skenario 3: Blokir ping (ICMP)

```
Router(config)# access-list 103 deny icmp any any
Router(config)# access-list 103 permit ip any any
```
