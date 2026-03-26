---
title: Arsip Laporan TKJ
description: Template dan panduan membuat laporan PKL, laporan praktek jaringan, dan tips penulisan laporan TKJ
---

# Arsip Laporan TKJ

Kumpulan template dan panduan untuk membuat laporan PKL, laporan praktek jaringan, dan berbagai dokumen akademik TKJ.

---

## 1. Template Laporan PKL (Praktik Kerja Lapangan)

### Struktur Laporan PKL:

```
HALAMAN JUDUL
HALAMAN PENGESAHAN
KATA PENGANTAR
DAFTAR ISI
DAFTAR GAMBAR
DAFTAR TABEL

BAB I    PENDAHULUAN
BAB II   GAMBARAN UMUM PERUSAHAAN/INSTANSI
BAB III  PELAKSANAAN PKL
BAB IV   PENUTUP

DAFTAR PUSTAKA
LAMPIRAN
```

### Template Halaman Judul:

```
LAPORAN PRAKTIK KERJA LAPANGAN (PKL)
DI [NAMA PERUSAHAAN/INSTANSI]
[TANGGAL MULAI] – [TANGGAL SELESAI]

[LOGO SEKOLAH]

Disusun Oleh:
Nama    : [Nama Lengkap Siswa]
NIS     : [Nomor Induk Siswa]
Kelas   : [Kelas XI/XII TKJ]

PROGRAM KEAHLIAN TEKNIK KOMPUTER DAN JARINGAN
SMK [NAMA SEKOLAH]
[KOTA]
[TAHUN]
```

### Template Halaman Pengesahan:

```
HALAMAN PENGESAHAN

Laporan PKL ini telah disetujui dan disahkan oleh:

Pembimbing Sekolah          Pembimbing DU/DI

[Nama Pembimbing Sekolah]   [Nama Pembimbing Perusahaan]
NIP. ..................      NIK. ....................

Mengetahui,
Kepala Program TKJ

[Nama Kepala Program]
NIP. ..................
```

### Isi BAB I — Pendahuluan:

```markdown
## BAB I PENDAHULUAN

### 1.1 Latar Belakang

Praktik Kerja Lapangan (PKL) merupakan salah satu kegiatan yang 
wajib dilaksanakan oleh siswa SMK sebagai bagian dari program 
pendidikan sistem ganda (PSG). PKL memberikan kesempatan kepada 
siswa untuk menerapkan ilmu yang telah dipelajari di sekolah ke 
dalam dunia kerja nyata.

Program Keahlian Teknik Komputer dan Jaringan (TKJ) menuntut 
siswa untuk mampu menguasai berbagai aspek teknologi informasi 
dan komunikasi, khususnya dalam bidang jaringan komputer. Dengan 
melaksanakan PKL di [nama perusahaan], diharapkan siswa dapat 
memperoleh pengalaman kerja dan wawasan yang lebih luas.

### 1.2 Tujuan PKL

Tujuan dilaksanakannya PKL adalah:
1. Menerapkan teori yang telah dipelajari di sekolah ke dalam 
   praktik kerja nyata
2. Meningkatkan kompetensi siswa di bidang Teknik Komputer dan Jaringan
3. Mengenal lingkungan kerja yang sesungguhnya
4. Melatih kedisiplinan dan profesionalisme kerja

### 1.3 Manfaat PKL

Manfaat PKL bagi siswa:
- Mendapatkan pengalaman kerja langsung
- Mengasah kemampuan komunikasi dan kerja tim
- Memahami budaya kerja di dunia industri

Manfaat PKL bagi sekolah:
- Mempererat hubungan antara sekolah dan DU/DI
- Mendapatkan masukan untuk pengembangan kurikulum

### 1.4 Waktu dan Tempat PKL

- Waktu PKL  : [Tanggal Mulai] – [Tanggal Selesai]
- Tempat PKL : [Nama Perusahaan/Instansi]
- Alamat     : [Alamat Lengkap]
```

### Template BAB III — Pelaksanaan PKL:

```markdown
## BAB III PELAKSANAAN PKL

### 3.1 Kegiatan Harian

| Hari/Tanggal | Kegiatan | Keterangan |
|--------------|----------|------------|
| Senin, 6 Jan 2026 | Orientasi tempat PKL | Perkenalan dengan staf IT |
| Selasa, 7 Jan 2026 | Instalasi OS Windows 11 | Di lab komputer klien |
| Rabu, 8 Jan 2026 | Konfigurasi jaringan LAN | Setting IP dan share printer |
| ... | ... | ... |

### 3.2 Kegiatan Utama

#### 3.2.1 Instalasi dan Konfigurasi Jaringan

Selama PKL, penulis mendapatkan tugas untuk melakukan instalasi 
dan konfigurasi jaringan di [nama perusahaan]. Kegiatan meliputi:

**a. Instalasi Kabel Jaringan**
- Crimping kabel UTP Cat5e
- Pemasangan wall outlet dan patch panel
- Pengujian konektivitas kabel

**b. Konfigurasi Router MikroTik**
[Jelaskan kegiatan konfigurasi yang dilakukan]

**c. Troubleshooting Jaringan**
[Jelaskan masalah yang ditemukan dan solusinya]

### 3.3 Hambatan dan Solusi

| Hambatan | Solusi |
|----------|--------|
| Koneksi internet tidak stabil | Penggantian kabel UTP yang rusak |
| IP address conflict | Penerapan DHCP server |
| ... | ... |
```

---

## 2. Template Laporan Praktek Jaringan

### Struktur Laporan Praktek:

```
HALAMAN JUDUL
LEMBAR KERJA SISWA (LKS) / JOBSHEET

I.    TUJUAN PRAKTEK
II.   ALAT DAN BAHAN
III.  KESELAMATAN KERJA
IV.   DASAR TEORI
V.    LANGKAH KERJA
VI.   HASIL PENGAMATAN
VII.  ANALISIS DAN PEMBAHASAN
VIII. KESIMPULAN
IX.   JAWABAN PERTANYAAN
```

### Template Laporan Praktek Konfigurasi MikroTik:

```markdown
# LAPORAN PRAKTEK
## Konfigurasi Router MikroTik sebagai Gateway Internet

**Nama Siswa  :** [Nama Lengkap]
**Kelas       :** XI TKJ [A/B/C]
**NIS         :** [Nomor Induk]
**Tanggal     :** [Tanggal Praktek]
**Nilai       :** ________

---

### I. TUJUAN PRAKTEK

Setelah melaksanakan praktek ini, siswa mampu:
1. Mengkonfigurasi IP address pada router MikroTik
2. Mengaktifkan NAT Masquerade untuk sharing internet
3. Mengkonfigurasi DHCP Server
4. Memverifikasi konektivitas jaringan

### II. ALAT DAN BAHAN

**Perangkat Keras:**
- Router MikroTik RB750Gr3 (1 unit)
- Switch TP-Link 8 port (1 unit)
- PC/Laptop (3 unit)
- Kabel UTP Cat5e (secukupnya)

**Perangkat Lunak:**
- Winbox v3.xx
- Web browser

### III. DASAR TEORI

MikroTik RouterOS adalah sistem operasi yang digunakan pada 
router MikroTik. RouterOS memiliki fitur lengkap untuk mengelola 
jaringan seperti routing, firewall, NAT, DHCP, dan lainnya.

**NAT (Network Address Translation)** adalah proses menerjemahkan 
IP address private ke IP address public agar host dalam jaringan 
LAN bisa mengakses internet.

**DHCP Server** secara otomatis memberikan IP address kepada 
client yang terhubung ke jaringan.

### IV. TOPOLOGI JARINGAN

[Gambar topologi atau diagram ASCII]

```
Internet
   |
[ISP Modem] 192.168.0.1/24
   |
[MikroTik ether1] 192.168.0.2/24 (WAN)
[MikroTik ether2] 192.168.1.1/24 (LAN)
   |
[Switch]
   |────── PC1 (192.168.1.x)
   |────── PC2 (192.168.1.x)
```

### V. LANGKAH KERJA

1. Hubungkan router MikroTik ke sumber listrik
2. Hubungkan kabel UTP dari modem ISP ke ether1 MikroTik
3. Hubungkan kabel UTP dari ether2 MikroTik ke switch
4. Hubungkan PC ke switch
5. Buka Winbox → Connect ke router via MAC address
6. Konfigurasi IP address ether1 dan ether2
7. Tambah default route ke gateway ISP
8. Aktifkan NAT Masquerade
9. Setup DHCP Server di ether2
10. Test konektivitas dari PC client

### VI. HASIL PENGAMATAN

| Pengujian | Hasil | Keterangan |
|-----------|-------|------------|
| Ping dari router ke ISP | Berhasil/Gagal | |
| Ping dari router ke internet | Berhasil/Gagal | |
| DHCP client mendapat IP | Berhasil/Gagal | IP: |
| Ping dari client ke internet | Berhasil/Gagal | |
| Browsing dari client | Berhasil/Gagal | |

### VII. ANALISIS DAN PEMBAHASAN

[Tuliskan analisis dari hasil praktek. Jelaskan mengapa berhasil 
atau gagal, dan apa yang dipelajari]

Pada praktek ini, konfigurasi router MikroTik sebagai gateway 
internet berhasil dilaksanakan. IP address pada ether1 berhasil 
dikonfigurasi sebagai interface WAN, sedangkan ether2 sebagai 
interface LAN. NAT Masquerade yang dikonfigurasi memungkinkan 
semua client dalam jaringan LAN untuk mengakses internet.

### VIII. KESIMPULAN

Dari praktek yang telah dilaksanakan, dapat disimpulkan:
1. Konfigurasi MikroTik sebagai gateway internet memerlukan 
   IP address di WAN dan LAN interface
2. NAT Masquerade diperlukan agar traffic dari LAN bisa 
   mengakses internet
3. DHCP Server memudahkan distribusi IP address secara otomatis

### IX. PERTANYAAN DAN JAWABAN

**1. Apa perbedaan NAT Masquerade dengan Src-NAT?**
Jawaban: NAT Masquerade secara otomatis menggunakan IP dari 
interface WAN sebagai source IP, sedangkan Src-NAT menggunakan 
IP yang ditentukan secara manual.

**2. Mengapa DHCP Server perlu dikonfigurasi dengan IP Pool?**
Jawaban: IP Pool mendefinisikan range IP address yang boleh 
dibagikan ke client DHCP, sehingga tidak ada IP yang tumpang 
tindih (conflict).
```

---

## 3. Tips Membuat Laporan yang Baik

### Prinsip Dasar Penulisan Laporan:

#### ✅ Yang Harus Dilakukan:
- Gunakan bahasa Indonesia yang baik dan baku
- Tulis dengan kalimat yang jelas dan tidak ambigu
- Sertakan gambar/screenshot yang relevan
- Beri keterangan pada setiap gambar (caption)
- Konsisten dalam penggunaan format dan font
- Cek ejaan sebelum dikumpulkan
- Cantumkan sumber referensi

#### ❌ Yang Harus Dihindari:
- Jangan copy-paste tanpa modifikasi
- Hindari kalimat yang terlalu panjang dan berbelit
- Jangan pakai bahasa gaul atau slang
- Hindari gambar yang blur atau tidak jelas
- Jangan biarkan halaman kosong tanpa konten

### Format Penulisan Standar:

| Elemen | Ketentuan |
|--------|-----------|
| Font | Times New Roman 12pt |
| Spasi | 1.5 spasi |
| Margin | Atas 4cm, Kiri 4cm, Kanan 3cm, Bawah 3cm |
| Ukuran Kertas | A4 |
| Penomoran Halaman | Romawi untuk bagian awal, Arab untuk isi |

### Tips Menulis BAB yang Baik:

**BAB I (Pendahuluan):**
- Latar belakang: tuliskan mengapa topik ini penting
- Rumusan masalah: tulis dalam bentuk pertanyaan
- Tujuan: jawab dari rumusan masalah
- Manfaat: tuliskan manfaat konkret

**BAB II (Landasan Teori/Gambaran Umum):**
- Jelaskan teori yang relevan dengan kegiatan
- Sertakan gambar arsitektur atau topologi
- Kutip sumber yang valid

**BAB III (Pembahasan/Pelaksanaan):**
- Ini bagian terpenting — tulis secara detail
- Sertakan screenshot atau foto setiap langkah
- Jelaskan juga kendala yang dihadapi
- Tulis solusi dari setiap masalah

**BAB IV (Penutup):**
- Kesimpulan harus menjawab tujuan di BAB I
- Saran harus konstruktif dan spesifik
- Jangan terlalu panjang

### Penulisan Perintah/Kode:

Gunakan format monospace untuk perintah CLI:

```
Contoh yang benar:
Perintah /ip address print digunakan untuk melihat daftar IP.

Contoh yang salah:
Perintah ip address print digunakan untuk melihat daftar IP.
```

### Checklist Sebelum Submit Laporan:

- [ ] Halaman judul sudah lengkap (nama, NIS, kelas, tahun)
- [ ] Halaman pengesahan sudah ditandatangani
- [ ] Kata pengantar sudah ditulis
- [ ] Daftar isi sudah sesuai halaman
- [ ] Gambar sudah bernomor dan ada caption
- [ ] Tabel sudah bernomor dan ada judul
- [ ] Tidak ada halaman yang kosong
- [ ] Bahasa sudah disunting
- [ ] Daftar pustaka sudah ada
- [ ] Lampiran (jika ada) sudah dilampirkan
- [ ] File PDF sudah di-compress (maks 5MB)

### Format Daftar Pustaka:

**Buku:**
```
Penulis, Nama. (Tahun). Judul Buku. Penerbit: Kota.
```

**Website:**
```
Nama Penulis/Organisasi. (Tahun). Judul Artikel. Diakses dari
https://www.contoh.com/artikel pada tanggal DD Bulan YYYY.
```

**Contoh:**
```
MikroTik. (2024). RouterOS Documentation. Diakses dari
https://help.mikrotik.com pada tanggal 15 Januari 2026.

Sofana, Iwan. (2017). Cisco CCNA & Jaringan Komputer.
Informatika: Bandung.
```

---

## 4. Template Surat Permohonan PKL

```
[Kop Surat Sekolah]

Nomor    : 421.5/[nomor]/[nama sekolah]/[tahun]
Lampiran : 1 (satu) berkas
Perihal  : Permohonan Praktek Kerja Lapangan

Kepada Yth.
[Jabatan Penerima]
[Nama Perusahaan/Instansi]
Di Tempat

Dengan hormat,

Dalam rangka memenuhi persyaratan kelulusan siswa Program Keahlian 
Teknik Komputer dan Jaringan (TKJ), kami mengharapkan bantuan 
Bapak/Ibu untuk menerima siswa kami melaksanakan Praktek Kerja 
Lapangan (PKL) di instansi yang Bapak/Ibu pimpin.

Adapun siswa yang kami usulkan adalah:
1. Nama : [Nama Siswa 1], NIS: [NIS], Kelas: [Kelas]
2. Nama : [Nama Siswa 2], NIS: [NIS], Kelas: [Kelas]

Pelaksanaan PKL direncanakan:
Waktu  : [Tanggal] s.d. [Tanggal]
Tempat : [Nama Instansi]

Demikian permohonan ini kami sampaikan. Atas perhatian dan 
bantuan Bapak/Ibu, kami mengucapkan terima kasih.

                              [Kota], [Tanggal]
                              Kepala Sekolah,


                              [Nama Kepala Sekolah]
                              NIP. [NIP]
```

<!-- update: 2026-02-04 -->

<!-- rev: feb5 -->

<!-- rev: feb6 -->

<!-- rev: feb12 -->

<!-- rev: feb13 -->

<!-- rev: feb23 -->

<!-- update: 2026-03-04 -->

<!-- rev: mar9 -->

<!-- rev: mar16 -->

<!-- update: 2026-03-21 -->

<!-- update: 2026-03-26 -->
