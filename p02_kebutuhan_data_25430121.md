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

## 4. Entitas kandidat dan elemen data

## 5. Aturan bisnis

## 6. Kebutuhan informasi

## 7. Matriks CRUD

## 8. Kamus data awal

## 9. Kebutuhan non-fungsional data

## 10. Isu kualitas data yang diantisipasi