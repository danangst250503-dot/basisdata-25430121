# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

Disusun oleh: Danang Setiawan (25430121) - Kelas A
Studi kasus latihan Modul 2, Praktikum Basis Data

## 1. Latar belakang dan aktivitas organisasi

Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus.
Pembeli dapat berupa anggota atau umum. Kegiatan utama mencakup pendaftaran
anggota, penjualan di kasir, pengendalian stok, pemesanan ke pemasok,
penerimaan barang, dan pelaporan bulanan.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok | Petugas gudang | Pemasok baru atau data pemasok berubah |
| PB-07 | Memperbarui status keanggotaan | Ketua koperasi | Anggota lulus, tidak memenuhi syarat, atau mengundurkan diri |

## 3. Dokumen sumber yang dianalisis

Dokumen sumber yang dianalisis adalah **nota penjualan Kopma** (Gambar 2.5).
Setiap isian pada nota diperlakukan sebagai kandidat elemen data.

| Elemen pada nota | Disimpan / Dihitung | Keterangan |
|---|---|---|
| Nomor nota | Disimpan | Penanda unik tiap transaksi |
| Tanggal-jam | Disimpan | Waktu transaksi terjadi |
| Kasir | Disimpan | Petugas yang melayani |
| Anggota | Disimpan (opsional) | Kosong bila pembeli umum |
| Barang | Disimpan | Per baris nota |
| Qty | Disimpan | Per baris nota |
| Harga satuan saat transaksi | Disimpan | Tidak mengikuti harga barang terkini (AB-04) |
| Subtotal per baris | Dihitung | qty x harga satuan |
| Total nota | Dihitung | jumlah subtotal dikurangi diskon |
| Bayar | Disimpan | Jumlah uang yang diterima |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

**Catatan pemisahan Penjualan dan Detail penjualan:** data yang muncul sekali per
nota (nomor, tanggal, kasir, anggota) dipisahkan dari data yang berulang per baris
barang (barang, qty, harga), karena satu nota dapat memuat jumlah baris yang
berbeda-beda.

## 5. Aturan bisnis

| Kode | Aturan bisnis | Asal |
|---|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. | Bentuk nota |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. | Narasi |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. | Keluhan petugas gudang |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. | Keluhan ketua |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. | Keluhan kasir |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. | Narasi, pemicu PB-03 |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | R | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |
| PB-06 Mengelola data pemasok | | | | | C, U | |
| PB-07 Memperbarui status keanggotaan | U | | | | | |

**Temuan pemeriksaan matriks (Titik Analisis 3):**

**Bagian A — Pemasok**

Tidak adanya `C` pada kolom `Pemasok` berarti belum ada proses yang membuat atau mencatat data pemasok. Saya menambahkan **PB-06 Mengelola data pemasok** dengan aktor **petugas gudang**. Hal ini diperlukan karena PB-03 hanya membaca data pemasok untuk membuat pesanan, padahal sebelumnya belum ada proses yang mencatat data pemasok, sehingga sistem akan kesulitan menggunakan data pemasok tersebut.

**Bagian B — Status Anggota**

Status aktif anggota juga perlu diperhatikan karena pada proses yang ada belum terdapat proses yang mengubah status tersebut. Saya menambahkan **PB-07 Memperbarui status keanggotaan** dengan aktor **ketua koperasi**. Pemicu proses ini adalah ketika status keanggotaan anggota berubah, misalnya karena anggota sudah lulus, tidak lagi memenuhi syarat keanggotaan, atau mengundurkan diri. Proses ini diperlukan agar perubahan status anggota dapat dicatat dan data anggota tetap sesuai dengan kondisi sebenarnya.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit (AB-05) | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota (AB-01) | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 (AB-04) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat >= 0 (AB-03) | Petugas gudang |

## 9. Kebutuhan non-fungsional data

| Jenis | Ketentuan |
|---|---|
| Volume | Perkiraan +/- 150 nota per hari |
| Retensi | Data transaksi disimpan minimal 5 tahun |
| Privasi | Nomor HP anggota hanya boleh dilihat oleh ketua koperasi |

## 10. Isu kualitas data yang diantisipasi

Beberapa isu kualitas data yang perlu diantisipasi dari hasil wawancara adalah:

1. **Stok minus (akurasi)**  
   Data stok harus sesuai dengan jumlah barang yang sebenarnya tersedia. Jika pencatatan tidak tepat, stok di sistem dapat menjadi minus atau berbeda dengan kondisi barang di gudang.

2. **Harga pada nota lama berubah (ketepatan historis)**  
   Harga yang tercatat pada transaksi harus tetap sesuai dengan harga saat transaksi terjadi. Jika harga pada data barang berubah, harga pada nota lama tidak boleh ikut berubah karena dapat menyebabkan riwayat transaksi menjadi tidak sesuai.

3. **Anggota lupa membawa kartu (kemudahan identifikasi)**  
   Sistem perlu membantu petugas menemukan dan mengenali data anggota dengan mudah ketika anggota tidak membawa kartu. Hal ini penting agar transaksi tetap dapat dilayani tanpa salah memilih data anggota.