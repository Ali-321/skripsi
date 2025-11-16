# Skripsi - Sistem Top Up Voucher Game Online

Repository ini berisi source code dan backend dari proyek skripsi berjudul **"Implementasi Metode Waterfall pada Sistem Informasi Top Up Voucher Game Online Berbasis Android"**.

---

## 📱 Folder: `flutter_topup_voucher_game_online`

Merupakan **aplikasi mobile berbasis Flutter** yang dikembangkan untuk melakukan transaksi top up voucher game secara praktis dan efisien.  
Fitur utama aplikasi ini meliputi:

- Login & Registrasi pengguna
- Pilih game dan nominal voucher
- Keranjang & checkout
- Integrasi pembayaran dengan Midtrans
- Riwayat transaksi


---

## 🖥️ Folder: `topup-voucher-gameonline-strapi`

Merupakan **backend berbasis Strapi** (Headless CMS + API) yang digunakan untuk:

- Mengelola data produk/game
- Mengatur transaksi dan pembayaran
- Menyimpan riwayat pembayaran
- Berfungsi sebagai API yang diakses oleh aplikasi Flutter

Fitur backend meliputi:

- Role-based access (admin & user)
- Otomatisasi entri data ke tabel terkait saat transaksi dibuat
- Midtrans webhook untuk update status pembayaran
- Dukungan custom controller alih-alih lifecycle hooks

---

## ⚙️ Teknologi yang Digunakan

- **Flutter** (frontend)
- **Strapi v5** (backend)
- **MySQL** (database via Laragon)
- **Midtrans Snap** (payment gateway)

---

## 📄 Catatan Tambahan

Proyek ini dikembangkan dengan metode **Waterfall** dengan tahapan:

1. Analisis kebutuhan
2. Perancangan sistem
3. Implementasi
4. Integrasi & pengujian
5. Verifikasi
6. Operasi & pemeliharaan

---


## Demo App on youtube
[https://youtu.be/QAlbiJqXuQQ](https://youtu.be/QAlbiJqXuQQ)

## apk bisa di download disini 
https://drive.google.com/file/d/1I2TKmtE5P31VmgimOcfzikVjJMWHV60s/view?usp=drive_link

