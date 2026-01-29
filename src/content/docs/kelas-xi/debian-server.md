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

## DNS Server (BIND9)

```bash
apt install bind9 bind9utils -y
```

### named.conf.local

```conf
zone "tkj.local" {
    type master;
    file "/etc/bind/db.tkj.local";
};

zone "100.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.100";
};
```

### Forward Zone (db.tkj.local)

```
$TTL    604800
@   IN  SOA ns1.tkj.local. root.tkj.local. (
            2024010101 604800 86400 2419200 604800 )
@   IN  NS  ns1.tkj.local.
ns1     IN  A   192.168.100.10
server  IN  A   192.168.100.10
web     IN  A   192.168.100.10
```

```bash
# Cek dan restart
named-checkconf
named-checkzone tkj.local /etc/bind/db.tkj.local
systemctl restart bind9
```

## Web Server — Apache2

```bash
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
```

### Virtual Host

```bash
nano /etc/apache2/sites-available/tkj.local.conf
```

```apache
<VirtualHost *:80>
    ServerName www.tkj.local
    DocumentRoot /var/www/tkj
    
    <Directory /var/www/tkj>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```bash
mkdir -p /var/www/tkj
echo "<h1>Server TKJ</h1>" > /var/www/tkj/index.html
a2ensite tkj.local.conf
a2dissite 000-default.conf
apache2ctl configtest
systemctl reload apache2
```

## Web Server — Nginx

```bash
apt install nginx -y
```

```nginx
# /etc/nginx/sites-available/tkj.local
server {
    listen 80;
    server_name www.tkj.local;
    root /var/www/tkj;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
ln -s /etc/nginx/sites-available/tkj.local /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

## FTP Server (vsftpd)

```bash
apt install vsftpd -y

nano /etc/vsftpd.conf
```

```conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
```

```bash
# Buat user FTP
useradd -m ftpuser
passwd ftpuser

systemctl restart vsftpd
systemctl enable vsftpd
```
