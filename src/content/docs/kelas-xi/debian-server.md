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

## DHCP Server (isc-dhcp-server)

```bash
# Instalasi
apt install isc-dhcp-server -y

# Konfigurasi
nano /etc/dhcp/dhcpd.conf
```

```conf
default-lease-time 86400;
max-lease-time 172800;

subnet 192.168.100.0 netmask 255.255.255.0 {
    range 192.168.100.50 192.168.100.200;
    option routers 192.168.100.1;
    option domain-name-servers 192.168.100.10, 8.8.8.8;
    option domain-name "tkj.local";
}
```

```bash
# Set interface
nano /etc/default/isc-dhcp-server
# INTERFACESv4="eth0"

systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server
```
