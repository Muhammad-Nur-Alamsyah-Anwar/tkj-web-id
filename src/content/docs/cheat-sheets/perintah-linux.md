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