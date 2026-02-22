---
title: Komputer Dasar
description: Materi perakitan, instalasi OS, dan troubleshooting dasar komputer.
---

Materi ini adalah "Kawah Candradimuka" anak TKJ. Sebelum bisa ngatur jaringan satu gedung, kamu harus bisa nyalain satu komputer dulu dengan benar.

## 🖥️ Anatomi Komputer (Hardware)

Komputer itu ibarat tubuh manusia. Ada otaknya, ada jantungnya, ada ingatannya.

| Komponen | Istilah Manusia | Fungsi Utama | Tips Anak TKJ |
| :--- | :--- | :--- | :--- |
| **Processor (CPU)** | Otak | Memproses instruksi. | Jangan lupa kasih thermal paste tipis-tipis! |
| **RAM** | Ingatan Jangka Pendek | Menyimpan data sementara. | Kalau bunyi *beep-beep* panjang, coba bersihin kuningannya pake penghapus karet. |
| **Harddisk/SSD** | Ingatan Jangka Panjang | Menyimpan data permanen (OS, File). | SSD wajib buat teknisi 2026. HDD cuma buat simpan film. |
| **Motherboard** | Tulang Belakang | Tempat semua komponen nempel. | Hati-hati sama pin processor (LGA) jangan sampai bengkok. |
| **Power Supply (PSU)** | Jantung | Menyuplai listrik. | Jangan beli PSU abal-abal kalau sayang komponen lain. |

## 💿 Instalasi Sistem Operasi

Dua OS yang wajib kamu kuasai cara installnya:

### 1. Windows (10/11)
*   **Partisi:** Hati-hati saat format! Pastikan *System Reserved* (C:) yang diformat, bukan Data (D:).
*   **Driver:** Setelah install, cek *Device Manager*. Kalau ada tanda seru kuning (!), berarti driver belum lengkap.

### 2. Linux (Debian/Ubuntu)
*   **Root vs User:** Pahami bedanya `root` (dewa) dan user biasa.
*   **Swap:** Memori cadangan di harddisk kalau RAM penuh. Biasanya 2x ukuran RAM.
*   **CLI:** Biasakan install mode *Text* (CLI), bukan GUI. Server sejati gak butuh mouse!

## 🔧 Troubleshooting Dasar (Diagnosa Dokter)

Teknisi itu kerjanya mencari masalah (dan menyelesaikannya).

### POST (Power On Self Test)
Saat komputer baru nyala, dia akan ngecek dirinya sendiri. Kalau ada yang salah, dia "teriak" lewat bunyi **Beep**.

*   **1 Beep Pendek:** Normal (Sehat).
*   **Beep Terus-menerus:** Masalah Power Supply atau Motherboard.
*   **1 Beep Panjang, 2 Pendek:** Masalah VGA (Kartu Grafis).
*   **1 Beep Panjang, 3 Pendek:** Masalah Keyboard (jarang, tapi mungkin).
*   **Bunyi Niiing..... (Fan kencang):** Overheat. Cek thermal paste atau kipas.

### Masalah Umum & Solusi

1.  **No Display (Layar Hitam tapi Kipas Muter)**
    *   *Solusi:* Cabut RAM, gosok pin emasnya pakai penghapus, pasang lagi. Cek kabel VGA/HDMI.
2.  **Blue Screen of Death (BSOD)**
    *   *Solusi:* Catat kode errornya (misal: `CRITICAL_PROCESS_DIED`). Biasanya masalah driver crash, RAM rusak, atau OS korup.
3.  **Boot Device Not Found**
    *   *Solusi:* Kabel Harddisk kendor atau Harddisk rusak. Cek prioritas Boot di BIOS.

---

### 🧠 Tantangan Rakit PC
Urutkan langkah merakit PC yang benar:
1. Pasang Motherboard ke Casing
2. Pasang Processor ke Motherboard
3. Pasang Kabel Front Panel (Tombol Power, Reset)
4. Pasang Power Supply

<details>
<summary>Lihat Urutan Ideal</summary>

**Urutan yang disarankan:**
1. Pasang Processor & RAM ke Motherboard (Di luar casing dulu, biar gampang).
2. Pasang Power Supply ke Casing.
3. Pasang Backpanel I/O Shield.
4. Pasang Motherboard ke Casing.
5. Pasang Kabel-kabel.

*Memasang komponen kecil di luar casing jauh lebih mudah daripada tangan nyelip-nyelip di dalam casing sempit!*
</details>