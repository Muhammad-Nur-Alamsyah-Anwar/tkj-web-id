---
title: Debian Server
description: Konfigurasi layanan server di Debian — DHCP, DNS, Web Server, FTP, Samba, SSH.
---

# Debian Server — Kelas XI ASJ

Debian adalah distro Linux stabil yang banyak digunakan sebagai server jaringan.

> Panduan ini menggunakan **Debian 12 (Bookworm)**.

## Persiapan Awal

### Konfigurasi IP Statis

```bash
nano /etc/network/interfaces
```

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.100.10
    netmask 255.255.255.0
    gateway 192.168.100.1
    dns-nameservers 8.8.8.8
```

```bash
systemctl restart networking
ip addr show
```
