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

## SSH Server

```bash
apt install openssh-server -y

nano /etc/ssh/sshd_config
```

```conf
Port 22
PermitRootLogin no
PasswordAuthentication yes
MaxAuthTries 3
```

```bash
systemctl restart sshd
```

### SSH Key Auth

```bash
# Generate key di client
ssh-keygen -t rsa -b 4096

# Copy ke server
ssh-copy-id user@192.168.100.10
```

## Samba (File Sharing)

```bash
apt install samba -y

nano /etc/samba/smb.conf
```

```ini
[global]
   workgroup = WORKGROUP

[public]
   path = /srv/samba/public
   browsable = yes
   writable = yes
   guest ok = yes

[data]
   path = /srv/samba/data
   valid users = @samba-users
   writable = yes
```

```bash
mkdir -p /srv/samba/public /srv/samba/data
chmod 0777 /srv/samba/public
smbpasswd -a sambauser
systemctl restart smbd
testparm
```

## Firewall dengan UFW

```bash
apt install ufw -y
ufw enable

# Allow layanan
ufw allow ssh
ufw allow http
ufw allow https
ufw allow ftp
ufw allow from 192.168.100.0/24 to any port 445  # Samba dari LAN

# Blokir IP
ufw deny from 10.0.0.100

# Status
ufw status verbose
ufw status numbered

# Hapus rule
ufw delete deny from 10.0.0.100
```

## Monitoring Server

```bash
# Cek resource
htop          # CPU, RAM real-time
df -h         # disk usage
free -h       # RAM usage
uptime        # load average

# Cek service
systemctl status apache2
systemctl status bind9

# Cek port
ss -tulnp
netstat -tulnp

# Log
tail -f /var/log/apache2/access.log
tail -f /var/log/syslog
journalctl -xe
```

## Troubleshooting Umum

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Web tidak bisa diakses | Apache/Nginx mati | `systemctl restart apache2` |
| DNS tidak resolve | BIND9 error | `named-checkconf`, cek log |
| DHCP tidak memberi IP | Interface salah | Cek `/etc/default/isc-dhcp-server` |
| FTP gagal login | chroot permission | `allow_writeable_chroot=YES` |
| SSH connection refused | sshd mati | `systemctl start sshd` |

```bash
# Cek semua service sekaligus
systemctl status apache2 bind9 isc-dhcp-server vsftpd smbd sshd
```

## Reverse Proxy dengan Nginx

```bash
# Nginx sebagai reverse proxy ke Apache di port 8080
nano /etc/nginx/sites-available/reverse-proxy
```

```nginx
server {
    listen 80;
    server_name web.tkj.local;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

```bash
# Ubah Apache ke port 8080
nano /etc/apache2/ports.conf
# Listen 8080

ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

## NTP Server

```bash
apt install ntp -y

nano /etc/ntp.conf
```

```conf
# Server NTP Indonesia
server 0.id.pool.ntp.org iburst
server 1.id.pool.ntp.org iburst
server time.google.com iburst

# Izinkan client di LAN sinkronisasi
restrict 192.168.100.0 mask 255.255.255.0 nomodify notrap
```

```bash
systemctl restart ntp
systemctl enable ntp

# Cek status
ntpq -p
timedatectl status
```

## LDAP Server (OpenLDAP)

```bash
apt install slapd ldap-utils -y

# Konfigurasi ulang slapd
dpkg-reconfigure slapd
```

Isi saat konfigurasi:
- Omit initial config: **No**
- DNS domain: **tkj.local**
- Organization: **TKJ School**
- Admin password: (isi)
- Remove database: **Yes** (jika reinstall)

```bash
# Test koneksi LDAP
ldapsearch -x -H ldap://localhost -b "dc=tkj,dc=local"

# Tambah user via LDIF
ldapadd -x -D "cn=admin,dc=tkj,dc=local" -W -f user.ldif
```
