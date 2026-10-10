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
Kode Petugas    : PT-001
Petugas         : Yono
--------------------------------------------------
| No | Kode Eksemplar | Judul Buku               |
|----|----------------|--------------------------|
| 1  | EX-0101        | Pemrograman Dasar        |
| 2  | EX-0145        | Basis Data               |
| 3  | EX-0202        | Algoritma                |
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
| Buku | id_buku, kode_buku, judul_buku, pengarang_buku, penerbit_buku, tahun_terbit_buku | Daftar koleksi buku |
| Eksemplar | id_eksemplar, kode_eksemplar, id_buku, kondisi_eksemplar, status_eksemplar, tanggal_masuk_eksemplar, asal_perolehan_eksemplar | Catatan penerimaan buku |
| Petugas | id_petugas, kode_petugas, nama_petugas, no_hp_petugas, status_petugas | Data petugas perpustakaan |
| Peminjaman | id_peminjaman, no_peminjaman, tanggal_jam_peminjaman, id_anggota, id_petugas | Slip peminjaman |
| Detail peminjaman | id_detail_peminjaman, id_peminjaman, id_eksemplar, tanggal_jatuh_tempo, tanggal_kembali, jumlah_perpanjangan | Slip peminjaman dan catatan pengembalian |
| Denda | id_denda, id_detail_peminjaman, tarif_denda, hari_terlambat, jumlah_denda, status_denda, tanggal_bayar_denda, id_petugas | Catatan atau kuitansi denda |

**Catatan pemisahan Buku dan Eksemplar:** `Buku` menyimpan informasi mengenai judul atau jenis buku, sedangkan `Eksemplar` mewakili salinan fisik dari buku tersebut. Satu buku dapat memiliki beberapa eksemplar dengan kode, kondisi, dan status yang berbeda.

**Catatan pemisahan Peminjaman dan Detail peminjaman:** `Peminjaman` menyimpan informasi yang berlaku untuk satu transaksi, seperti nomor peminjaman, anggota, petugas, dan waktu transaksi. `Detail peminjaman` menyimpan setiap eksemplar yang dipinjam beserta tanggal jatuh tempo dan pengembaliannya, sehingga satu transaksi dapat memiliki beberapa baris sampai maksimal 6 buku.

**Catatan Denda:** `tarif_denda` disimpan pada transaksi denda berdasarkan tarif yang berlaku pada tanggal peminjaman. Dengan demikian, apabila tarif berubah di kemudian hari, nilai pada transaksi lama tetap dapat diketahui. `status_denda` digunakan untuk membedakan denda yang belum lunas dan sudah lunas.

## 5. Aturan bisnis

| Kode | Aturan bisnis | Asal |
|---|---|---|
| AB-01 | Anggota hanya boleh melakukan peminjaman jika `status_anggota` menunjukkan anggota masih aktif. | Lingkup layanan, elemen `status_anggota` |
| AB-02 | Setiap transaksi peminjaman dapat memuat paling banyak 6 eksemplar buku. | Parameter P |
| AB-03 | Masa pinjam setiap buku adalah 7 hari sejak tanggal peminjaman. | Lingkup layanan |
| AB-04 | Setiap peminjaman dapat diperpanjang paling banyak 1 kali, dengan tambahan masa pinjam 7 hari. | Lingkup layanan |
| AB-05 | Permintaan perpanjangan hanya dapat dilakukan sebelum tanggal jatuh tempo peminjaman. | Asumsi desain |
| AB-06 | Eksemplar hanya boleh dipinjam jika `status_eksemplar` bernilai `tersedia` dan `kondisi_eksemplar` bernilai `baik`. | Elemen `status_eksemplar` dan `kondisi_eksemplar` |
| AB-07 | Satu eksemplar tidak boleh tercatat dalam lebih dari satu peminjaman yang masih aktif pada waktu yang sama. | Integritas proses peminjaman |
| AB-08 | Keterlambatan pengembalian dikenakan denda sebesar Rp4.000 per hari untuk setiap buku yang terlambat. | Parameter P |
| AB-09 | Tarif denda yang digunakan untuk suatu peminjaman ditentukan berdasarkan tarif yang berlaku pada tanggal peminjaman dan tidak berubah meskipun tarif denda diperbarui kemudian. | Keputusan desain |
| AB-10 | `no_anggota` dan `kode_eksemplar` harus unik sehingga setiap anggota dan setiap eksemplar dapat diidentifikasi tanpa duplikasi. | Elemen `no_anggota` dan `kode_eksemplar` |
| AB-11 | Setiap transaksi peminjaman, perpanjangan, pengembalian, dan pembayaran denda harus mencatat petugas yang menanganinya. | Lingkup layanan dan kebutuhan ketertelusuran |
| AB-12 | Anggota tidak boleh melakukan peminjaman baru jika masih memiliki denda dengan `status_denda` bernilai `belum lunas`. | Keputusan desain |
| AB-13 | Setiap transaksi peminjaman harus memuat minimal satu eksemplar buku. | Pemeriksaan kardinalitas Modul 3 |
| AB-14 | Setiap judul buku yang dicatat dalam perpustakaan harus memiliki minimal satu eksemplar fisik. | PB-06 dan keputusan desain |

**Catatan penambahan (Modul 3):** AB-13 dan AB-14 ditambahkan setelah pemeriksaan
kardinalitas pada Modul 3 menemukan dua relasi yang nilai minimumnya belum memiliki
dasar aturan bisnis.

### Nilai `kondisi_eksemplar`

Nilai yang digunakan untuk `kondisi_eksemplar` adalah:

- `baik`
- `rusak ringan`
- `rusak berat`

Hanya eksemplar dengan `kondisi_eksemplar` bernilai `baik` yang boleh dipinjam sesuai AB-06.

### Catatan aturan denda

Tarif denda disimpan berdasarkan tarif yang berlaku pada saat peminjaman. Dengan demikian, apabila tarif denda berubah di kemudian hari, transaksi peminjaman lama tetap menggunakan tarif yang berlaku pada saat transaksi tersebut dibuat.

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Daftar eksemplar dan judul buku yang sedang dipinjam saat ini | Peminjaman, detail peminjaman, eksemplar, buku |
| KI-02 | Daftar peminjaman yang sudah melewati tanggal jatuh tempo tetapi belum dikembalikan | Peminjaman, detail peminjaman, anggota, eksemplar |
| KI-03 | Riwayat peminjaman setiap anggota dalam 12 bulan terakhir | Anggota, peminjaman, detail peminjaman, eksemplar, buku |
| KI-04 | Sepuluh buku yang paling sering dipinjam per bulan berdasarkan jumlah peminjaman | Buku, eksemplar, detail peminjaman |
| KI-05 | Jumlah peminjaman, jumlah pengembalian, dan total denda per bulan | Peminjaman, detail peminjaman, denda |
| KI-06 | Daftar anggota yang masih memiliki denda belum lunas saat ini | Anggota, peminjaman, detail peminjaman, denda |
| KI-07 | Daftar eksemplar yang memiliki kondisi `rusak ringan` atau `rusak berat` saat ini | Eksemplar, buku |

## 7. Matriks CRUD

| Proses | Anggota | Buku | Eksemplar | Petugas | Peminjaman | Detail | Denda |
|---|---|---|---|---|---|---|---|
| PB-01 Mendaftarkan anggota | C | | | | | | |
| PB-02 Mencatat peminjaman buku | R | R | R, U | R | C | C | R |
| PB-03 Memperpanjang peminjaman | | | | R | R | R, U | |
| PB-04 Mencatat pengembalian buku | | | R, U | R | R | R, U | |
| PB-05 Mencatat denda keterlambatan | | | | R | R | R | C |
| PB-06 Mencatat buku baru dan kondisi eksemplar | | R, C | C | R | | | |
| PB-07 Memperbarui status keanggotaan | R, U | | | R | | | |
| PB-08 Mengelola data petugas | | | | C, R, U | | | |
| PB-09 Menyusun laporan bulanan | R | R | R | R | R | R | R |
| PB-10 Menerima pembayaran denda | R | | | R | R | R | R, U |

## 8. Kamus data awal

| Entitas | Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|---|
| Anggota | id_anggota | Identitas unik anggota | 1 | Unik sebagai identitas anggota | Petugas perpustakaan |
| Anggota | no_anggota | Nomor anggota yang digunakan dalam transaksi | A-0125 | Harus unik (AB-10) | Petugas perpustakaan |
| Anggota | nama_anggota | Nama lengkap anggota | Budi Santoso | Wajib diisi | Petugas perpustakaan |
| Anggota | alamat_anggota | Alamat tempat tinggal anggota | Desa Sukamaju | Wajib diisi | Petugas perpustakaan |
| Anggota | no_hp_anggota | Nomor HP anggota | 081234567890 | Data pribadi, akses terbatas | Kepala perpustakaan |
| Anggota | tanggal_daftar_anggota | Tanggal anggota terdaftar | 2026-10-05 | Tanggal yang valid; dicatat saat pendaftaran (PB-01) | Petugas perpustakaan |
| Anggota | status_anggota | Status keaktifan anggota | aktif | Hanya `aktif` atau `nonaktif`; hanya `aktif` yang boleh meminjam (AB-01) | Kepala perpustakaan |
| Buku | id_buku | Identitas unik buku | 1 | Unik sebagai identitas buku | Petugas perpustakaan |
| Buku | kode_buku | Kode identifikasi buku | BK-0101 | Harus unik | Petugas perpustakaan |
| Buku | judul_buku | Judul buku | Basis Data Dasar | Wajib diisi | Petugas perpustakaan |
| Buku | pengarang_buku | Nama pengarang buku | Abdul Karim | Wajib diisi | Petugas perpustakaan |
| Buku | penerbit_buku | Nama penerbit buku | Informatika Press | Wajib diisi | Petugas perpustakaan |
| Buku | tahun_terbit_buku | Tahun buku diterbitkan | 2024 | Berupa tahun yang valid | Petugas perpustakaan |
| Eksemplar | id_eksemplar | Identitas unik eksemplar fisik | 1 | Unik sebagai identitas eksemplar | Petugas perpustakaan |
| Eksemplar | kode_eksemplar | Kode identifikasi eksemplar fisik | EX-0101 | Harus unik (AB-10) | Petugas perpustakaan |
| Eksemplar | id_buku | Rujukan ke buku yang dimiliki eksemplar | 1 | Harus mengacu ke buku yang valid | Petugas perpustakaan |
| Eksemplar | kondisi_eksemplar | Kondisi fisik eksemplar | baik | Hanya `baik`, `rusak ringan`, atau `rusak berat`; hanya `baik` yang boleh dipinjam (AB-06) | Petugas perpustakaan |
| Eksemplar | status_eksemplar | Status operasional eksemplar | tersedia | Hanya `tersedia`, `dipinjam`, atau `tidak tersedia`; peminjaman hanya untuk status `tersedia` (AB-06, AB-07) | Petugas perpustakaan |
| Eksemplar | tanggal_masuk_eksemplar | Tanggal eksemplar masuk ke perpustakaan | 2026-01-15 | Menggunakan tanggal yang valid | Petugas perpustakaan |
| Eksemplar | asal_perolehan_eksemplar | Sumber diperolehnya eksemplar | Sumbangan | Diisi berdasarkan asal buku, misalnya pengadaan atau sumbangan | Petugas perpustakaan |
| Petugas | id_petugas | Identitas unik petugas | 1 | Unik sebagai identitas petugas | Kepala perpustakaan |
| Petugas | kode_petugas | Kode identifikasi petugas | PT-001 | Harus unik | Kepala perpustakaan |
| Petugas | nama_petugas | Nama lengkap petugas | Yono | Wajib diisi | Kepala perpustakaan |
| Petugas | no_hp_petugas | Nomor HP petugas | 081298765432 | Nomor kontak petugas | Kepala perpustakaan |
| Petugas | status_petugas | Status keaktifan petugas | aktif | Hanya `aktif` atau `nonaktif` | Kepala perpustakaan |
| Peminjaman | id_peminjaman | Identitas unik transaksi peminjaman | 1 | Unik sebagai identitas transaksi | Petugas perpustakaan |
| Peminjaman | no_peminjaman | Nomor transaksi peminjaman | PMJ-261005-001 | Harus unik | Petugas perpustakaan |
| Peminjaman | tanggal_jam_peminjaman | Tanggal dan waktu peminjaman | 2026-10-05 14:30 | Harus mencatat waktu transaksi | Petugas perpustakaan |
| Peminjaman | id_anggota | Rujukan anggota yang melakukan peminjaman | 1 | Harus mengacu ke anggota yang valid | Petugas perpustakaan |
| Peminjaman | id_petugas | Rujukan petugas yang menangani peminjaman | 1 | Harus mengacu ke petugas yang valid dan mendukung ketertelusuran (AB-11) | Petugas perpustakaan |
| Detail peminjaman | id_detail_peminjaman | Identitas unik detail peminjaman | 1 | Unik sebagai identitas detail | Petugas perpustakaan |
| Detail peminjaman | id_peminjaman | Rujukan ke transaksi peminjaman | 1 | Harus mengacu ke peminjaman yang valid | Petugas perpustakaan |
| Detail peminjaman | id_eksemplar | Rujukan ke eksemplar yang dipinjam | 1 | Harus mengacu ke eksemplar yang valid | Petugas perpustakaan |
| Detail peminjaman | tanggal_jatuh_tempo | Batas tanggal pengembalian buku | 2026-10-12 | Masa pinjam 7 hari dan dapat berubah jika dilakukan perpanjangan (AB-03, AB-04) | Petugas perpustakaan |
| Detail peminjaman | tanggal_kembali | Tanggal buku dikembalikan | 2026-10-15 | Diisi saat buku dikembalikan | Petugas perpustakaan |
| Detail peminjaman | jumlah_perpanjangan | Jumlah perpanjangan yang sudah dilakukan | 1 | Maksimal 1 kali (AB-04) | Petugas perpustakaan |
| Denda | id_denda | Identitas unik transaksi denda | 1 | Unik sebagai identitas denda | Petugas perpustakaan |
| Denda | id_detail_peminjaman | Rujukan ke detail peminjaman yang terkena denda | 1 | Harus mengacu ke detail peminjaman yang valid | Petugas perpustakaan |
| Denda | id_petugas | Rujukan petugas yang menangani denda | 1 | Harus mengacu ke petugas yang valid dan mendukung ketertelusuran (AB-11) | Petugas perpustakaan |
| Denda | tarif_denda | Tarif denda per hari per buku | 4000 | Ditentukan berdasarkan tarif yang berlaku pada tanggal peminjaman dan tidak berubah kemudian (AB-08, AB-09) | Petugas perpustakaan |
| Denda | hari_terlambat | Jumlah hari keterlambatan pengembalian | 3 | Atribut turunan: `tanggal_kembali − tanggal_jatuh_tempo` pada detail peminjaman; keputusan disimpan atau dihitung ditetapkan di Modul 4 | Petugas perpustakaan |
| Denda | jumlah_denda | Jumlah uang denda yang ditetapkan pada transaksi | 12000 | Nilai = `tarif_denda × hari_terlambat` dan disimpan karena menjadi jumlah denda yang benar-benar ditagihkan/dibayar | Petugas perpustakaan |
| Denda | status_denda | Status pembayaran denda | belum lunas | Hanya `belum lunas` atau `lunas`; anggota dengan denda `belum lunas` tidak boleh meminjam (AB-12) | Petugas perpustakaan |
| Denda | tanggal_bayar_denda | Tanggal pembayaran denda | 2026-10-16 | Diisi ketika denda dibayar | Petugas perpustakaan |

**Catatan keputusan (Modul 3):** saat ERD digambar, entitas kandidat pada bagian 4 dicocokkan dengan kamus data ini, dan hasilnya sebagai berikut.

- `tanggal_daftar_anggota` ditambahkan ke kamus data karena dicatat pada formulir pendaftaran anggota (PB-01).
- `id_petugas` pada Denda ditambahkan karena relasi petugas menangani denda (AB-11) membutuhkan kunci tamu.
- `kategori_buku` dihapus dari bagian 4 karena tidak termasuk data katalog pada lingkup layanan dan tidak dipakai oleh kebutuhan informasi mana pun.
- `status_peminjaman` dihapus dari bagian 4 karena dapat diturunkan dari `tanggal_kembali` pada detail peminjaman, sehingga menyimpannya berisiko tidak konsisten (isu kualitas nomor 2).
- `hari_terlambat` ditandai sebagai atribut turunan pada ERD; keputusan menyimpan atau menghitungnya ditetapkan saat normalisasi Modul 4. `jumlah_denda` tetap atribut biasa karena sudah diputuskan disimpan sebagai jumlah yang ditagihkan.

## 9. Kebutuhan non-fungsional data

### Perhitungan parameter P

Dua digit terakhir NIM saya adalah 21.

P = (21 mod 9) + 1
P = 3 + 1
P = 4

P digunakan untuk menentukan beberapa parameter proyek sebagai berikut:

- Maksimal buku dalam satu peminjaman = P + 2 = 4 + 2 = **6 buku**
- Denda keterlambatan per hari per buku = P ribu = **Rp4.000**
- Perkiraan transaksi per hari = 40 + 5P = 40 + (5 × 4) = **60 transaksi per hari**

### Volume data

Perpustakaan Pakde DS diperkirakan memiliki sekitar **800 judul buku** dengan total sekitar **1.200 eksemplar**. Jumlah anggota diperkirakan sekitar **500 orang**, sedangkan aktivitas peminjaman dan pengembalian mencapai sekitar **60 transaksi per hari**.

### Retensi data

Data transaksi peminjaman, pengembalian, perpanjangan, dan denda disimpan minimal **5 tahun**. Data tersebut dipertahankan agar riwayat transaksi anggota dan catatan denda tetap dapat ditelusuri ketika diperlukan.

### Privasi data

Data pribadi anggota yang perlu dilindungi meliputi `nama_anggota`, `alamat_anggota`, dan `no_hp_anggota`. Petugas perpustakaan dapat mengakses data yang diperlukan untuk melayani transaksi, seperti `no_anggota` dan `nama_anggota`, sedangkan data alamat dan nomor HP hanya boleh diakses oleh kepala perpustakaan.

Riwayat peminjaman anggota juga termasuk data yang perlu dibatasi karena dapat menunjukkan aktivitas seorang anggota. Petugas hanya dapat melihat riwayat yang diperlukan untuk melayani transaksi, sedangkan akses penuh terhadap riwayat peminjaman anggota diberikan kepada kepala perpustakaan.

## 10. Isu kualitas data yang diantisipasi

Beberapa isu kualitas data yang perlu diantisipasi adalah:

1. **Status eksemplar tidak sesuai kondisi sebenarnya (konsistensi)**  
   Jika `status_eksemplar` tidak diperbarui saat buku dipinjam atau dikembalikan, sistem dapat menunjukkan eksemplar masih dipinjam padahal buku sebenarnya sudah berada di rak. Hal ini dapat menyebabkan buku yang tersedia dianggap tidak dapat dipinjam.

2. **Status pengembalian tidak tercatat (kelengkapan)**  
   Jika `tanggal_kembali` tidak diisi ketika buku sudah dikembalikan, sistem dapat menganggap peminjaman masih berlangsung. Akibatnya, daftar keterlambatan dan status eksemplar dapat menjadi tidak sesuai dengan kondisi sebenarnya.

3. **Riwayat peminjaman anggota tidak lengkap (kelengkapan dan ketertelusuran)**  
   Setiap transaksi peminjaman dan pengembalian perlu dicatat dengan benar agar riwayat anggota dapat ditelusuri. Data yang hilang akan menyulitkan petugas ketika mencari riwayat peminjaman atau memeriksa transaksi sebelumnya.

4. **Jumlah denda tidak sesuai perhitungannya (akurasi)**  
   Nilai `jumlah_denda` harus sesuai dengan `tarif_denda × hari_terlambat`. Jika salah satu nilai yang menjadi dasar perhitungan salah, jumlah denda yang ditagihkan kepada anggota juga akan salah.

5. **Kondisi eksemplar tidak diperbarui (kemutakhiran)**  
   Kondisi fisik buku dapat berubah setelah digunakan, tetapi perubahan tersebut hanya dicatat melalui proses pengelolaan kondisi eksemplar. Jika pemeriksaan kondisi tidak dilakukan dan datanya tidak diperbarui, sistem dapat menunjukkan kondisi buku yang sudah tidak sesuai dengan keadaan fisiknya.

6. **Data peminjaman tidak dapat ditelusuri ke petugas (ketertelusuran)**  
   Setiap transaksi harus mencatat petugas yang menanganinya. Jika `id_petugas` tidak tercatat dengan benar, perpustakaan akan kesulitan mengetahui siapa yang menangani suatu transaksi ketika terjadi masalah atau diperlukan pemeriksaan.