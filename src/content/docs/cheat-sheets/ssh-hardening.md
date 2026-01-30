---
title: SSH Hardening
description: Tips mengamankan SSH server di Debian/Linux untuk praktek TKJ.
---

# SSH Hardening

Konfigurasi default SSH tidak selalu aman. Ini yang perlu diubah setelah install Debian server.

## File konfigurasi

```bash
nano /etc/ssh/sshd_config
```

Setelah edit, restart service:

```bash
systemctl restart ssh
```

## Ubah port default

```
Port 2222
```

Port default SSH adalah 22. Mengubahnya mengurangi hit dari scanner otomatis.

## Nonaktifkan login root

```
PermitRootLogin no
```

Login pakai user biasa, lalu `su -` atau `sudo` kalau butuh akses root.

## Batasi user yang boleh SSH

```
AllowUsers admin
```

## Key-based authentication

Lebih aman dari password. Generate key di client:

```bash
ssh-keygen -t ed25519 -C "admin@sekolah"
```

Copy public key ke server:

```bash
ssh-copy-id -p 2222 admin@192.168.1.10
```

Atau manual — copy isi `~/.ssh/id_ed25519.pub` ke server di `~/.ssh/authorized_keys`.

Setelah key berjalan, nonaktifkan password auth:

```
PasswordAuthentication no
```

## Timeout dan max percobaan login

```
LoginGraceTime 30
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
```

## Fail2ban

Install fail2ban untuk blokir IP yang terlalu banyak gagal login:

```bash
apt install fail2ban
```

Konfigurasi di `/etc/fail2ban/jail.local`:

```ini
[sshd]
enabled = true
port = 2222
maxretry = 5
bantime = 3600
findtime = 600
```

Cek status:

```bash
fail2ban-client status sshd
fail2ban-client status sshd | grep "Banned IP"
```

## Ringkasan konfigurasi minimal

```
Port 2222
PermitRootLogin no
PasswordAuthentication no
AllowUsers admin
MaxAuthTries 3
LoginGraceTime 30
X11Forwarding no
```

## Test konfigurasi

Sebelum restart SSH, test dulu konfigurasinya:

```bash
sshd -t
```

Kalau tidak ada output = konfigurasi valid. Baru restart:

```bash
systemctl restart ssh
```

Jangan sampai restart SSH tanpa test — kalau ada syntax error kamu bisa terkunci dari server.

## Jaga sesi SSH tetap terbuka

Buka sesi SSH kedua sebelum logout dari sesi pertama. Ini jaga-jaga kalau konfigurasi baru menyebabkan masalah akses.
