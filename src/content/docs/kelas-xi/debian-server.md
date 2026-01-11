---
title: Debian Server
description: Panduan konfigurasi layanan server di Debian — DHCP, DNS, Apache2, Nginx, Samba, FTP, dan SSH.
---

# Debian Server — Konfigurasi Layanan Jaringan

Debian adalah distribusi Linux yang stabil dan banyak digunakan sebagai server jaringan di dunia industri. Materi ini membahas konfigurasi berbagai layanan server sesuai kurikulum ASJ (Administrasi Sistem Jaringan) kelas XI TKJ.

> **Spesifikasi:** Panduan ini menggunakan Debian 12 (Bookworm). Sebagian besar kompatibel dengan Debian 11.

---

## Persiapan Awal

### Konfigurasi IP Statis

Edit file konfigurasi jaringan:

```bash
nano /etc/network/interfaces
```

```
# Interface loopback
auto lo
iface lo inet loopback

# Interface LAN (eth0 atau ens3, sesuaikan)
auto eth0
iface eth0 inet static
    address 192.168.100.10
    netmask 255.255.255.0
    gateway 192.168.100.1
    dns-nameservers 8.8.8.8
```

```bash
# Restart jaringan
systemctl restart networking

# Cek IP
ip addr show
ip route show
```

### Update Sistem

```bash
apt update && apt upgrade -y
```

---

## 1. DHCP Server (isc-dhcp-server)

### Instalasi

```bash
apt install isc-dhcp-server -y
```

### Konfigurasi

```bash
nano /etc/dhcp/dhcpd.conf
```

```conf
# Konfigurasi global
default-lease-time 86400;
max-lease-time 172800;

# Deklarasi subnet
subnet 192.168.100.0 netmask 255.255.255.0 {
    range 192.168.100.50 192.168.100.200;
    option routers 192.168.100.1;
    option domain-name-servers 192.168.100.10, 8.8.8.8;
    option domain-name "tkj.local";
}

# IP statis untuk satu host
host pc-server {
    hardware ethernet AA:BB:CC:DD:EE:FF;
    fixed-address 192.168.100.20;
}
```

```bash
# Set interface DHCP
nano /etc/default/isc-dhcp-server
# Ubah: INTERFACESv4="eth0"

# Mulai dan enable service
systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server
systemctl status isc-dhcp-server

# Lihat lease aktif
cat /var/lib/dhcpd/dhcpd.leases
```

---

## 2. DNS Server (BIND9)

### Instalasi

```bash
apt install bind9 bind9utils bind9-doc -y
```

### Konfigurasi Named.conf.local

```bash
nano /etc/bind/named.conf.local
```

```conf
// Forward zone
zone "tkj.local" {
    type master;
    file "/etc/bind/db.tkj.local";
};

// Reverse zone (untuk 192.168.100.x)
zone "100.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.100";
};
```

### File Forward Zone

```bash
cp /etc/bind/db.local /etc/bind/db.tkj.local
nano /etc/bind/db.tkj.local
```

```
$TTL    604800
@   IN  SOA ns1.tkj.local. root.tkj.local. (
            2024010101  ; Serial
            604800      ; Refresh
            86400       ; Retry
            2419200     ; Expire
            604800 )    ; Negative Cache TTL

; Name servers
@   IN  NS  ns1.tkj.local.

; A records
ns1     IN  A   192.168.100.10
server  IN  A   192.168.100.10
web     IN  A   192.168.100.10
ftp     IN  A   192.168.100.10
```

### File Reverse Zone

```bash
cp /etc/bind/db.127 /etc/bind/db.192.168.100
nano /etc/bind/db.192.168.100
```

```
$TTL    604800
@   IN  SOA ns1.tkj.local. root.tkj.local. (
            2024010101
            604800
            86400
            2419200
            604800 )

@   IN  NS  ns1.tkj.local.

; PTR records
10  IN  PTR ns1.tkj.local.
10  IN  PTR server.tkj.local.
```

```bash
# Cek konfigurasi
named-checkconf
named-checkzone tkj.local /etc/bind/db.tkj.local
named-checkzone 100.168.192.in-addr.arpa /etc/bind/db.192.168.100

# Restart BIND9
systemctl restart bind9
systemctl enable bind9

# Test DNS
dig @192.168.100.10 server.tkj.local
nslookup server.tkj.local 192.168.100.10
```

---

## 3. Web Server — Apache2

### Instalasi

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
    ServerAlias tkj.local
    DocumentRoot /var/www/tkj
    
    ErrorLog ${APACHE_LOG_DIR}/tkj-error.log
    CustomLog ${APACHE_LOG_DIR}/tkj-access.log combined
    
    <Directory /var/www/tkj>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```bash
# Buat direktori dan halaman web
mkdir -p /var/www/tkj
echo "<h1>Selamat Datang di Server TKJ</h1>" > /var/www/tkj/index.html

# Aktifkan virtual host
a2ensite tkj.local.conf
a2dissite 000-default.conf

# Cek konfigurasi dan restart
apache2ctl configtest
systemctl reload apache2
```

### Modul Apache Umum

```bash
# Aktifkan mod_rewrite (untuk .htaccess)
a2enmod rewrite

# Aktifkan SSL
a2enmod ssl
a2ensite default-ssl

# Aktifkan directory listing
a2enmod autoindex
```

---

## 4. Web Server — Nginx

### Instalasi

```bash
apt install nginx -y
systemctl start nginx
systemctl enable nginx
```

### Konfigurasi Virtual Host Nginx

```bash
nano /etc/nginx/sites-available/tkj.local
```

```nginx
server {
    listen 80;
    server_name www.tkj.local tkj.local;
    root /var/www/tkj;
    index index.html index.php;

    access_log /var/log/nginx/tkj-access.log;
    error_log  /var/log/nginx/tkj-error.log;

    location / {
        try_files $uri $uri/ =404;
    }
    
    # PHP support
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    }
}
```

```bash
# Aktifkan site
ln -s /etc/nginx/sites-available/tkj.local /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Test dan reload
nginx -t
systemctl reload nginx
```

---

## 5. Samba (File Sharing)

### Instalasi

```bash
apt install samba -y
```

### Konfigurasi Share

```bash
nano /etc/samba/smb.conf
```

```ini
[global]
   workgroup = WORKGROUP
   server string = Samba Server TKJ
   netbios name = DEBIAN-SERVER
   security = user
   map to guest = bad user

# Share publik (tanpa password)
[public]
   path = /srv/samba/public
   browsable = yes
   writable = yes
   guest ok = yes
   read only = no

# Share privat (butuh login)
[data-tkj]
   path = /srv/samba/data
   browsable = yes
   writable = yes
   valid users = @samba-users
   read only = no
```

```bash
# Buat direktori dan atur permission
mkdir -p /srv/samba/public /srv/samba/data
chmod 0777 /srv/samba/public
chmod 0770 /srv/samba/data

# Buat group dan user samba
groupadd samba-users
useradd -M -s /sbin/nologin sambauser
usermod -aG samba-users sambauser
smbpasswd -a sambauser

# Restart Samba
systemctl restart smbd nmbd
systemctl enable smbd nmbd

# Cek konfigurasi
testparm
```

### Akses dari Windows

```
\\192.168.100.10\public
\\192.168.100.10\data-tkj
```

---

## 6. FTP Server (vsftpd)

### Instalasi

```bash
apt install vsftpd -y
```

### Konfigurasi

```bash
nano /etc/vsftpd.conf
```

```conf
# Konfigurasi dasar
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES

# Batasi user ke home directory
chroot_local_user=YES
allow_writeable_chroot=YES

# Banner
ftpd_banner=Selamat datang di FTP Server TKJ

# Passive mode (untuk NAT/firewall)
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
```

```bash
# Buat user FTP
useradd -m ftpuser
passwd ftpuser

# Buat direktori dan atur permission
mkdir -p /home/ftpuser/ftp
chmod 550 /home/ftpuser
chmod 750 /home/ftpuser/ftp

# Restart vsftpd
systemctl restart vsftpd
systemctl enable vsftpd
```

### Test FTP

```bash
# Test dari server sendiri
ftp 192.168.100.10

# Atau pakai curl
curl ftp://192.168.100.10 --user ftpuser:password
```

---

## 7. SSH Server (OpenSSH)

### Instalasi (biasanya sudah terinstall)

```bash
apt install openssh-server -y
```

### Konfigurasi Keamanan SSH

```bash
nano /etc/ssh/sshd_config
```

```conf
# Ganti port default (opsional, untuk keamanan)
Port 22

# Nonaktifkan login root langsung
PermitRootLogin no

# Gunakan autentikasi password (atau key-based)
PasswordAuthentication yes

# Batasi user yang bisa SSH
AllowUsers admin tkjuser

# Timeout sesi idle (menit)
ClientAliveInterval 300
ClientAliveCountMax 2

# Maksimum percobaan login
MaxAuthTries 3
```

```bash
# Restart SSH
systemctl restart sshd

# Cek status
systemctl status sshd
```

### SSH Key Authentication

```bash
# Generate key di client
ssh-keygen -t rsa -b 4096

# Copy public key ke server
ssh-copy-id user@192.168.100.10

# Atau manual
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

---

## 8. Firewall dengan UFW

```bash
# Install dan aktifkan UFW
apt install ufw -y
ufw enable

# Allow layanan yang dibutuhkan
ufw allow ssh
ufw allow http
ufw allow https
ufw allow ftp
ufw allow samba

# Allow port spesifik
ufw allow 3306/tcp   # MySQL
ufw allow 8080/tcp   # Web alternatif

# Lihat status
ufw status verbose

# Blokir IP tertentu
ufw deny from 10.0.0.100
```

---

## Troubleshooting Umum

```bash
# Cek service yang berjalan
systemctl list-units --type=service --state=running

# Cek port yang digunakan
ss -tulnp
netstat -tulnp

# Cek log sistem
journalctl -xe
tail -f /var/log/syslog

# Test koneksi ke port
nc -zv 192.168.100.10 80
telnet 192.168.100.10 21

# Restart semua layanan
systemctl restart apache2 bind9 isc-dhcp-server vsftpd smbd
```

---

## Checklist Konfigurasi Server

- [ ] IP statis sudah dikonfigurasi
- [ ] DNS server (BIND9) berjalan dan bisa resolve nama lokal
- [ ] DHCP server memberikan IP ke client
- [ ] Web server (Apache/Nginx) bisa diakses dari browser
- [ ] FTP server bisa diakses dan upload/download berfungsi
- [ ] Samba share bisa diakses dari Windows
- [ ] SSH bisa digunakan untuk remote akses
- [ ] Firewall (UFW) aktif dengan rule yang benar
