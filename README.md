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

## uji payement gateway
settingan midtrans nya masih sandbox jadi untuk pembayarannya menggunakan midtran payment simulator 
agar lebih mudah saya menyarankan menggunakan metode pembayaran **alfamaret https://simulator.sandbox.midtrans.com/alfamart/index**
atau visa **https://doc-midtrans.dev.fleava.com/en/technical-reference/sandbox-test**

## Cara Penggunaan APlikasinya 
1) download aplikasi link diatas google drive
2) install dan buka aplikasinya
3) lakukan registrasi dan masukan data dummy atau sembarang 
4) pilih game yang akan di top up misal mobile legends
5) tekan tombol + di pojok kanan di bawah icon cart
6) masukan data id game dan server id
7) tekan tombol pilih akun
8) pilih akun game yang akan di top up
9) pilih katagori diamond
10) tekan tombol + untuk memaukan item ke keranjang
11) tekan tombol buy sekarang
11) pilih metode pembayaran misal pilih alfamaret
12) copy kode pembelian
13) bukan halaman **alfamaret https://simulator.sandbox.midtrans.com/alfamart/index** masukan kode pembelian
14) kembali ke aplikasi maka transaksi akan sukses
15) cek history transaksi
16) jika masih pending pindah halaman produk lalu kembali lagi
17) status transaksi berubah menjadi success
