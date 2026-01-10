---
title: Konfigurasi Debian Server Kelas XI
description: Panduan lengkap instalasi dan konfigurasi server Debian untuk praktik TKJ kelas XI
---

# Konfigurasi Server Debian — Kelas XI TKJ

Panduan lengkap untuk menginstall dan mengkonfigurasi berbagai layanan server menggunakan Debian Linux.

---

## 1. Instalasi Debian Server

### Persiapan:
- ISO Debian (download dari [debian.org](https://www.debian.org))
- VM (VirtualBox/VMware) atau PC fisik
- RAM minimal 512 MB, disk minimal 10 GB

### Langkah Instalasi:
1. Boot dari ISO Debian
2. Pilih **Install** (bukan Graphical Install untuk server)
3. Pilih bahasa: **English**
4. Pilih lokasi: **Indonesia**
5. Konfigurasi keyboard: **American English**
6. Set hostname: `server-tkj`
7. Set domain: `tkj.local`
8. Set root password: `(isi password kuat)`
9. Buat user biasa: `admin`
10. Pilih partisi: **Guided - use entire disk**
11. Software selection: **hanya centang SSH server dan Standard system utilities** (jangan install desktop)
12. Install GRUB bootloader: **Yes**

### Setelah Install:
```bash
# Login sebagai root, lalu update sistem
apt update && apt upgrade -y

# Install tools dasar
apt install -y vim curl wget net-tools
```

---

## 2. Konfigurasi IP Statik

Debian menggunakan file `/etc/network/interfaces` untuk konfigurasi jaringan.

```bash
# Lihat interface yang tersedia
ip addr show
# atau
ifconfig -a

# Edit file konfigurasi jaringan
nano /etc/network/interfaces
```

Isi file `/etc/network/interfaces`:

```
# Interface loopback
auto lo
iface lo inet loopback

# Interface eth0 (sesuaikan nama interface)
auto eth0
iface eth0 inet static
    address 192.168.1.10
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8 8.8.4.4
```

```bash
# Restart networking
systemctl restart networking

# atau
ifdown eth0 && ifup eth0

# Verifikasi IP
ip addr show eth0

# Test konektivitas
ping -c 4 8.8.8.8
ping -c 4 google.com
```

### Debian 10+ (menggunakan enp3s0 / ens33):
```bash
# Nama interface bisa berbeda, cek dulu
ip link show

# Edit sesuai nama interface yang muncul
nano /etc/network/interfaces
```

---

## 3. DHCP Server (isc-dhcp-server)

### Instalasi:
```bash
apt install -y isc-dhcp-server
```

### Konfigurasi utama:

Edit `/etc/dhcp/dhcpd.conf`:

```bash
nano /etc/dhcp/dhcpd.conf
```

Isi konfigurasi:

```
# Global options
option domain-name "tkj.local";
option domain-name-servers 192.168.1.10, 8.8.8.8;

default-lease-time 600;
max-lease-time 7200;

# Authoritative untuk network ini
authoritative;

# Subnet LAN
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.200;
    option routers 192.168.1.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.1.255;
    option domain-name-servers 192.168.1.10, 8.8.8.8;
    default-lease-time 600;
    max-lease-time 7200;
}

# Static IP untuk host tertentu
host pc-guru {
    hardware ethernet AA:BB:CC:DD:EE:FF;
    fixed-address 192.168.1.50;
}
```

### Konfigurasi interface DHCP:

Edit `/etc/default/isc-dhcp-server`:

```bash
nano /etc/default/isc-dhcp-server
```

```
# Tentukan interface yang akan melayani DHCP
INTERFACESv4="eth0"
```

```bash
# Start dan enable service
systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server

# Cek status
systemctl status isc-dhcp-server

# Lihat log error
journalctl -u isc-dhcp-server -n 50

# Lihat leases yang aktif
cat /var/lib/dhcp/dhcpd.leases
```

---

## 4. DNS Server (BIND9)

### Instalasi:
```bash
apt install -y bind9 bind9utils bind9-doc
```

### Konfigurasi BIND9:

Edit `/etc/bind/named.conf.options`:

```bash
nano /etc/bind/named.conf.options
```

```
options {
    directory "/var/cache/bind";

    // Forwarder ke DNS publik
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    // Izinkan query dari semua
    allow-query { any; };

    // Recursion untuk LAN
    allow-recursion { 192.168.1.0/24; localhost; };

    dnssec-validation auto;
    listen-on-v6 { any; };
};
```

Edit `/etc/bind/named.conf.local`:

```bash
nano /etc/bind/named.conf.local
```

```
// Zone forward (nama ke IP)
zone "tkj.local" {
    type master;
    file "/etc/bind/db.tkj.local";
};

// Zone reverse (IP ke nama)
zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.1";
};
```

Buat file zone forward `/etc/bind/db.tkj.local`:

```bash
nano /etc/bind/db.tkj.local
```

```
$TTL    604800
@   IN  SOA server.tkj.local. root.tkj.local. (
            2026010101  ; Serial (YYYYMMDDNN)
            604800      ; Refresh
            86400       ; Retry
            2419200     ; Expire
            604800 )    ; Negative Cache TTL

; Name Servers
@       IN  NS  server.tkj.local.

; A Records
server  IN  A   192.168.1.10
router  IN  A   192.168.1.1
www     IN  A   192.168.1.10
ftp     IN  A   192.168.1.10
```

Buat file zone reverse `/etc/bind/db.192.168.1`:

```bash
nano /etc/bind/db.192.168.1
```

```
$TTL    604800
@   IN  SOA server.tkj.local. root.tkj.local. (
            2026010101  ; Serial
            604800      ; Refresh
            86400       ; Retry
            2419200     ; Expire
            604800 )    ; Negative Cache TTL

; Name Servers
@   IN  NS  server.tkj.local.

; PTR Records (IP terakhir saja)
10  IN  PTR server.tkj.local.
1   IN  PTR router.tkj.local.
```

```bash
# Cek syntax konfigurasi
named-checkconf
named-checkzone tkj.local /etc/bind/db.tkj.local
named-checkzone 1.168.192.in-addr.arpa /etc/bind/db.192.168.1

# Start BIND9
systemctl start bind9
systemctl enable bind9
systemctl status bind9

# Test DNS
nslookup server.tkj.local 192.168.1.10
dig @192.168.1.10 server.tkj.local
dig @192.168.1.10 -x 192.168.1.10
```

---

## 5. Web Server (Apache2)

### Instalasi:
```bash
apt install -y apache2

# Start dan enable
systemctl start apache2
systemctl enable apache2
systemctl status apache2
```

### Virtual Host:

```bash
# Buat direktori untuk website
mkdir -p /var/www/tkj-web/public_html

# Buat halaman web sederhana
cat > /var/www/tkj-web/public_html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Website TKJ SMK</title>
</head>
<body>
    <h1>Selamat Datang di Website TKJ!</h1>
    <p>Server Debian berhasil dikonfigurasi.</p>
</body>
</html>
EOF

# Set permission
chown -R www-data:www-data /var/www/tkj-web
chmod -R 755 /var/www/tkj-web
```

Buat Virtual Host config:

```bash
nano /etc/apache2/sites-available/tkj-web.conf
```

```
<VirtualHost *:80>
    ServerName www.tkj.local
    ServerAlias tkj.local
    DocumentRoot /var/www/tkj-web/public_html

    ErrorLog ${APACHE_LOG_DIR}/tkj-web-error.log
    CustomLog ${APACHE_LOG_DIR}/tkj-web-access.log combined

    <Directory /var/www/tkj-web/public_html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```bash
# Aktifkan virtual host
a2ensite tkj-web.conf

# Disable default site
a2dissite 000-default.conf

# Reload Apache
systemctl reload apache2

# Test konfigurasi
apache2ctl configtest
```

---

## 6. FTP Server (vsftpd)

### Instalasi:
```bash
apt install -y vsftpd

systemctl start vsftpd
systemctl enable vsftpd
```

### Konfigurasi `/etc/vsftpd.conf`:

```bash
# Backup config asli
cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

nano /etc/vsftpd.conf
```

Konfigurasi penting:

```
# Izinkan akses anonymous (tidak disarankan untuk produksi)
anonymous_enable=NO

# Izinkan login user lokal
local_enable=YES

# Izinkan upload
write_enable=YES

# Chroot user ke home directory
chroot_local_user=YES
allow_writeable_chroot=YES

# Passive mode (untuk FTP di NAT)
pasv_enable=YES
pasv_min_port=10000
pasv_max_port=10100

# Logging
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
```

```bash
# Buat user FTP
useradd -m -s /bin/bash ftpuser
passwd ftpuser

# Restart vsftpd
systemctl restart vsftpd
systemctl status vsftpd

# Test dari client
ftp 192.168.1.10
```

---

## 7. Samba File Sharing

### Instalasi:
```bash
apt install -y samba samba-common-bin

# Backup konfigurasi
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

### Konfigurasi `/etc/samba/smb.conf`:

```bash
nano /etc/samba/smb.conf
```

```
[global]
   workgroup = WORKGROUP
   server string = %h server (Samba, Ubuntu)
   dns proxy = no
   log file = /var/log/samba/log.%m
   max log size = 1000
   syslog = 0
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   passdb backend = tdbsam
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes

# Share public (bisa diakses semua orang)
[Public]
   path = /srv/samba/public
   comment = Folder Publik TKJ
   browseable = yes
   read only = no
   guest ok = yes
   create mask = 0666
   directory mask = 0777

# Share private (butuh password)
[Data-TKJ]
   path = /srv/samba/data
   comment = Data TKJ
   browseable = yes
   read only = no
   valid users = admin, ftpuser
   create mask = 0660
   directory mask = 0770
```

```bash
# Buat direktori share
mkdir -p /srv/samba/public /srv/samba/data
chmod 777 /srv/samba/public
chmod 770 /srv/samba/data
chown -R root:sambashare /srv/samba/data

# Tambah user Samba
smbpasswd -a admin

# Restart Samba
systemctl restart smbd nmbd
systemctl enable smbd nmbd

# Test dari terminal
smbclient //192.168.1.10/Public -N
smbclient //192.168.1.10/Data-TKJ -U admin

# Test dari Windows
# Explorer: \\192.168.1.10\Public
```

---

## 8. SSH Server

SSH sudah terinstall di Debian saat kita pilih "SSH server" waktu install. Berikut konfigurasi keamanannya.

### Konfigurasi `/etc/ssh/sshd_config`:

```bash
# Backup dan edit
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
nano /etc/ssh/sshd_config
```

Konfigurasi penting:

```
# Port SSH (default 22, bisa diganti untuk keamanan)
Port 22

# Tidak izinkan login root langsung
PermitRootLogin no

# Izinkan password authentication (sementara)
PasswordAuthentication yes

# Izinkan public key auth
PubkeyAuthentication yes

# Batasi user yang boleh SSH
AllowUsers admin ftpuser

# Timeout idle session
ClientAliveInterval 300
ClientAliveCountMax 3
```

```bash
# Restart SSH
systemctl restart sshd

# Test koneksi dari client
ssh admin@192.168.1.10

# Buat SSH key (lebih aman dari password)
ssh-keygen -t rsa -b 4096

# Copy public key ke server
ssh-copy-id admin@192.168.1.10
```

---

## 9. Rangkuman & Checklist

### Checklist Konfigurasi Server:

- [ ] IP statik sudah dikonfigurasi
- [ ] Hostname dan domain sudah di-set
- [ ] DHCP server berjalan dan memberikan IP ke client
- [ ] DNS server bisa resolve nama lokal dan forward ke internet
- [ ] Web server menampilkan halaman website
- [ ] FTP server bisa diakses dari client
- [ ] Samba share bisa diakses dari Windows
- [ ] SSH bisa digunakan untuk remote login

### Troubleshooting Umum:

```bash
# Cek service yang berjalan
systemctl list-units --type=service --state=running

# Cek port yang terbuka
ss -tlnp
# atau
netstat -tlnp

# Cek firewall (jika aktif)
iptables -L -n

# Cek log sistem
journalctl -xe

# Cek log aplikasi spesifik
tail -f /var/log/syslog
tail -f /var/log/apache2/error.log
tail -f /var/log/vsftpd.log
```

<!-- update: 2026-01-10 -->
