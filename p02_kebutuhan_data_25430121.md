# Dokumen Kebutuhan Data - Perpustakaan Pakde DS

- **Disusun oleh:** Danang Setiawan
- **NIM:** 25430121
- **Kelas:** A
- **Mata kuliah:** Praktikum Basis Data
- **Milestone:** Proyek 2 (Pertemuan 2)
- **Tema:** Perpustakaan (kode tema: `perpus`) — berdasarkan dua digit akhir NIM 21

## 1. Latar belakang dan aktivitas organisasi

Perpustakaan Pakde DS adalah perpustakaan milik desa yang melayani warga desa setempat, terutama pelajar dan masyarakat umum yang ingin membaca atau meminjam buku. Perpustakaan memiliki sekitar 1.200 eksemplar buku yang dikelola oleh 3 petugas perpustakaan dan dipimpin oleh 1 kepala perpustakaan. Koleksi buku yang dikelola mencakup informasi seperti judul, pengarang, penerbit, tahun terbit, dan jumlah eksemplar yang tersedia.

Kegiatan utama meliputi pendaftaran anggota, peminjaman buku, perpanjangan peminjaman, pengembalian buku, dan pencatatan denda keterlambatan. Anggota dapat meminjam paling banyak 6 buku sekaligus dengan masa pinjam 7 hari dan satu kali perpanjangan selama 7 hari berikutnya. Keterlambatan dikenakan denda sebesar Rp4.000 per hari untuk setiap buku, sedangkan perpustakaan melayani sekitar 60 transaksi peminjaman dan pengembalian setiap hari. Saat ini pencatatan masih menggunakan buku tulis sehingga petugas kesulitan mengetahui buku yang sedang dipinjam, status pengembalian, dan riwayat transaksi anggota.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Petugas perpustakaan | Warga ingin menjadi anggota |
| PB-02 | Mencatat peminjaman buku | Petugas perpustakaan | Anggota ingin meminjam buku |
| PB-03 | Memperpanjang peminjaman | Petugas perpustakaan | Anggota meminta perpanjangan sebelum masa pinjam berakhir |
| PB-04 | Mencatat pengembalian buku | Petugas perpustakaan | Anggota mengembalikan buku |
| PB-05 | Mencatat denda keterlambatan | Petugas perpustakaan | Buku dikembalikan setelah melewati batas waktu peminjaman |
| PB-06 | Mencatat buku baru dan kondisi eksemplar | Petugas perpustakaan | Buku baru diterima melalui pengadaan atau sumbangan, atau kondisi eksemplar berubah |
| PB-07 | Memperbarui status keanggotaan | Kepala perpustakaan | Anggota mengundurkan diri atau tidak lagi memenuhi syarat sebagai anggota |
| PB-08 | Mengelola data petugas | Kepala perpustakaan | Ada petugas baru atau data petugas berubah |
| PB-09 | Menyusun laporan bulanan | Kepala perpustakaan | Awal bulan |
| PB-10 | Menerima pembayaran denda | Petugas perpustakaan | Anggota membayar denda yang masih harus dilunasi |

## 3. Dokumen sumber yang dianalisis

Dokumen sumber yang dianalisis adalah **slip peminjaman** yang dirancang
untuk Perpustakaan Pakde DS. Slip diberikan kepada anggota setiap kali
melakukan peminjaman buku.

### Rancangan slip peminjaman

```text
==================================================
              PERPUSTAKAAN PAKDE DS
==================================================
No. Peminjaman : PMJ-261005-001
Tanggal         : 05-10-2026 14:30
No. Anggota     : A-0125
Nama Anggota    : Sugeng
Kode Petugas    : PTG-003
Petugas         : Yono
--------------------------------------------------
| No | Kode Eksemplar | Judul Buku              |
|----|----------------|-------------------------|
| 1  | EX-0101        | Pemrograman Dasar      |
| 2  | EX-0145        | Basis Data             |
| 3  | EX-0202        | Algoritma              |
--------------------------------------------------
Jumlah Buku     : 3
Jatuh Tempo     : 12-10-2026
Perpanjangan    : Maksimal 1 kali selama 7 hari
Denda           : Rp4.000 per hari per buku
==================================================
        Harap simpan slip ini sebagai bukti
                peminjaman buku
==================================================
```
### Pembedahan elemen data

| Elemen pada slip | Disimpan / Dihitung | Keterangan |
|---|---|---|
| No. Peminjaman | Disimpan | Nomor unik untuk mengidentifikasi setiap transaksi peminjaman |
| Tanggal dan jam peminjaman | Disimpan | Menunjukkan waktu sebenarnya saat transaksi peminjaman dilakukan |
| No. Anggota | Disimpan | Menjadi rujukan ke anggota yang melakukan peminjaman |
| Nama Anggota | Dihitung / ditampilkan dari data Anggota | Nama dapat diperoleh dari no_anggota, sehingga tidak perlu disimpan ulang pada transaksi |
| Petugas | Disimpan | Identitas petugas yang menangani transaksi harus dicatat; sebaiknya menggunakan kode petugas, sedangkan nama hanya ditampilkan |
| No. (urutan baris) | Dihitung | Hanya nomor urut tampilan pada slip dan tidak menjadi data utama transaksi |
| Kode Eksemplar | Disimpan | Menunjukkan eksemplar fisik tertentu yang dipinjam |
| Judul Buku | Dihitung / ditampilkan dari data Buku | Judul dapat diperoleh dari Kode Eksemplar melalui data Eksemplar dan Buku |
| Jumlah Buku | Dihitung | Diperoleh dengan menghitung jumlah baris detail peminjaman |
| Jatuh Tempo | Disimpan | Tanggal dapat berubah setelah perpanjangan, sehingga nilai yang berlaku untuk transaksi perlu dicatat |
| Aturan perpanjangan | Dihitung / ditampilkan dari aturan bisnis | Maksimal 1 kali perpanjangan selama 7 hari merupakan aturan sistem, bukan data transaksi yang perlu disimpan pada slip |
| Tarif denda | Disimpan | Tarif yang berlaku pada transaksi denda perlu disimpan agar transaksi lama tetap menggunakan tarif saat kejadian meskipun tarif berubah di kemudian hari |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | id_anggota, no_anggota, nama_anggota, alamat_anggota, no_hp_anggota, tanggal_daftar_anggota, status_anggota | Formulir pendaftaran anggota |
| Buku | id_buku, kode_buku, judul_buku, pengarang_buku, penerbit_buku, tahun_terbit_buku, kategori_buku | Daftar koleksi buku |
| Eksemplar | id_eksemplar, kode_eksemplar, id_buku, kondisi_eksemplar, status_eksemplar, tanggal_masuk_eksemplar, asal_perolehan_eksemplar | Catatan penerimaan buku |
| Petugas | id_petugas, kode_petugas, nama_petugas, no_hp_petugas, status_petugas | Data petugas perpustakaan |
| Peminjaman | id_peminjaman, no_peminjaman, tanggal_jam_peminjaman, id_anggota, id_petugas, status_peminjaman | Slip peminjaman |
| Detail peminjaman | id_detail_peminjaman, id_peminjaman, id_eksemplar, tanggal_jatuh_tempo, tanggal_kembali, jumlah_perpanjangan | Slip peminjaman dan catatan pengembalian |
| Denda | id_denda, id_detail_peminjaman, tarif_denda, hari_terlambat, jumlah_denda, status_denda, tanggal_bayar_denda, id_petugas | Catatan atau kuitansi denda |

**Catatan pemisahan Buku dan Eksemplar:** `Buku` menyimpan informasi mengenai judul atau jenis buku, sedangkan `Eksemplar` mewakili salinan fisik dari buku tersebut. Satu buku dapat memiliki beberapa eksemplar dengan kode, kondisi, dan status yang berbeda.

**Catatan pemisahan Peminjaman dan Detail peminjaman:** `Peminjaman` menyimpan informasi yang berlaku untuk satu transaksi, seperti nomor peminjaman, anggota, petugas, dan waktu transaksi. `Detail peminjaman` menyimpan setiap eksemplar yang dipinjam beserta tanggal jatuh tempo dan pengembaliannya, sehingga satu transaksi dapat memiliki beberapa baris sampai maksimal 6 buku.

**Catatan Denda:** `tarif_denda` disimpan pada transaksi denda berdasarkan tarif yang berlaku pada tanggal peminjaman. Dengan demikian, apabila tarif berubah di kemudian hari, nilai pada transaksi lama tetap dapat diketahui. `status_denda` digunakan untuk membedakan denda yang belum lunas dan sudah lunas.

## 5. Aturan bisnis

## 6. Kebutuhan informasi

## 7. Matriks CRUD

## 8. Kamus data awal

## 9. Kebutuhan non-fungsional data

## 10. Isu kualitas data yang diantisipasi