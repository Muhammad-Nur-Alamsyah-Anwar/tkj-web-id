---
title: Perintah Dasar Linux (Debian)
description: Cheat sheet perintah terminal Linux lengkap untuk ujian praktek TKJ.
---

Berikut adalah kumpulan perintah dasar Linux (Debian) yang wajib dihapal diluar kepala untuk ujian kompetensi kejuruan (UKK) dan praktek sehari-hari.

## 📂 Manajemen File (File Management)

| Perintah | Deskripsi | Contoh Penggunaan |
| :--- | :--- | :--- |
| `ls` | List directory. Melihat isi folder. | `ls -l` (detail), `ls -a` (hidden) |
| `cd` | Change directory. Pindah folder. | `cd /etc/network`, `cd ..` (kembali) |
| `mkdir` | Make directory. Membuat folder baru. | `mkdir data_sekolah` |
| `cp` | Copy. Menyalin file/folder. | `cp file.txt /home/` |
| `mv` | Move. Memindahkan atau rename file. | `mv file.txt data.txt` |
| `rm` | Remove. Menghapus file. | `rm file.txt`, `rm -rf folder/` |
| `nano` | Text editor CLI paling umum. | `nano /etc/network/interfaces` |
| `cat` | Melihat isi file tanpa membuka editor. | `cat /etc/resolv.conf` |
| `chmod` | Mengubah permission file. | `chmod 777 script.sh` |
| `chown` | Mengubah kepemilikan (owner) file. | `chown www-data:www-data index.html` |

## 🌐 Konfigurasi Jaringan (Network Config)

Fokus pada konfigurasi IP Address dan troubleshooting jaringan.

| Perintah | Deskripsi | Contoh Penggunaan |
| :--- | :--- | :--- |
| `ip a` | Cek IP Address (pengganti `ifconfig`). | `ip a` |
| `nano /etc/network/interfaces` | Edit konfigurasi IP statis/dinamis. | `nano /etc/network/interfaces` |
| `systemctl restart networking` | Restart service network (Debian). | `systemctl restart networking` |
| `/etc/init.d/networking restart` | Restart network (cara lama/SysVinit). | `/etc/init.d/networking restart` |
| `ping` | Cek koneksi ke host lain. | `ping 8.8.8.8`, `ping google.com` |
| `ip route` | Cek tabel routing/gateway. | `ip route show` |
| `nslookup` | Cek DNS resolve (perlu install `dnsutils`). | `nslookup tkj.web.id` |
| `resolv.conf` | File konfigurasi DNS Resolver. | `nano /etc/resolv.conf` |

## 👤 Manajemen User (User Management)

Penting untuk keamanan dan hak akses server.

| Perintah | Deskripsi | Contoh Penggunaan |
| :--- | :--- | :--- |
| `adduser` | Tambah user baru (lebih interaktif). | `adduser siswa` |
| `useradd` | Tambah user manual (tanpa home dir). | `useradd -m siswa` |
| `deluser` | Hapus user. | `deluser siswa` |
| `passwd` | Ganti password user. | `passwd root` |
| `su` | Switch User. Pindah user. | `su -` (jadi root), `su siswa` |
| `whoami` | Cek user yang sedang aktif. | `whoami` |
| `sudo` | Menjalankan perintah sebagai root. | `sudo apt update` |

## ℹ️ Informasi Sistem & Paket (System Info)

| Perintah | Deskripsi | Contoh Penggunaan |
| :--- | :--- | :--- |
| `apt update` | Update daftar paket repository. | `apt update` |
| `apt install` | Install aplikasi/paket baru. | `apt install apache2` |
| `apt remove` | Hapus aplikasi. | `apt remove apache2` |
| `systemctl status` | Cek status service berjalan/mati. | `systemctl status bind9` |
| `htop` / `top` | Task manager. Cek penggunaan CPU/RAM. | `htop` |
| `df -h` | Cek sisa kapasitas harddisk. | `df -h` |
| `free -h` | Cek penggunaan RAM. | `free -h` |
| `reboot` | Restart komputer. | `reboot` |
| `poweroff` | Mematikan komputer. | `poweroff` |
| `history` | Melihat riwayat perintah yang diketik. | `history` |
## Perintah Jaringan Lanjutan

```bash
# Cek semua interface dan IP
ip addr show
ip -br addr

# Tambah IP sementara
ip addr add 192.168.1.100/24 dev eth0

# Hapus IP
ip addr del 192.168.1.100/24 dev eth0

# Tambah route
ip route add 10.0.0.0/8 via 192.168.1.1

# Lihat routing table
ip route show

# Monitor koneksi aktif
ss -tulnp
netstat -tulnp

# Cek port terbuka
nmap -sV localhost
```

## Manajemen Service (systemd)

```bash
# Status service
systemctl status nginx

# Start/stop/restart
systemctl start apache2
systemctl stop apache2
systemctl restart apache2

# Enable/disable (otomatis start)
systemctl enable ssh
systemctl disable telnet

# Lihat semua service aktif
systemctl list-units --type=service --state=running

# Reload konfigurasi tanpa restart
systemctl reload nginx

# Log service
journalctl -u nginx -f
journalctl -u apache2 --since "1 hour ago"
```

## Manajemen File dan Direktori

```bash
# Navigasi
ls -la          # list dengan permission
cd /etc         # pindah direktori
pwd             # lokasi sekarang

# Buat/hapus
mkdir -p /srv/data/tkj   # buat direktori
rm -rf /tmp/old          # hapus direktori
cp -r /src /dst          # copy rekursif
mv file.txt /tmp/        # pindah file

# Cari file
find /etc -name "*.conf"
find / -type f -name "sshd_config"
locate nginx.conf

# Lihat isi file
cat /etc/hosts
less /var/log/syslog
head -20 /var/log/auth.log
tail -f /var/log/syslog  # real-time
```

## Permission dan Ownership

```bash
# Lihat permission
ls -la

# Ubah permission (numeric)
chmod 755 /var/www/html
chmod 600 ~/.ssh/id_rsa
chmod -R 644 /srv/samba/public

# Ubah ownership
chown www-data:www-data /var/www/html
chown -R ftpuser:ftpuser /home/ftpuser

# Mode permission:
# r=4, w=2, x=1
# 755 = rwxr-xr-x (owner: rwx, group: r-x, other: r-x)
# 644 = rw-r--r-- (owner: rw-, group: r--, other: r--)
# 600 = rw------- (owner: rw-)
```

## Text Processing

```bash
# grep — cari teks
grep "error" /var/log/syslog
grep -r "ServerName" /etc/apache2/
grep -i "failed" /var/log/auth.log   # case insensitive
grep -n "Port" /etc/ssh/sshd_config  # tampilkan nomor baris

# sed — stream editor
sed -i 's/old/new/g' file.txt        # replace teks
sed -n '10,20p' file.txt             # print baris 10-20

# awk
awk '{print $1}' access.log          # print kolom pertama
awk -F: '{print $1}' /etc/passwd     # print username

# cut
cut -d: -f1 /etc/passwd              # ambil field pertama
```
