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

Atau kalau mau izinkan beberapa user:

```
AllowUsers admin deploy backup
```
