# Normalisasi Perpustakaan Pakde DS — Danang Setiawan (25430121)

## 1. Bentuk UNF

```text
PINJAM_UNF (
    no_peminjaman, tanggal_jam_peminjaman,
    no_anggota, nama_anggota,
    kode_petugas, nama_petugas,
    {
        kode_eksemplar, judul_buku,
        tanggal_jatuh_tempo, tanggal_kembali, jumlah_perpanjangan,
        [ tarif_denda, hari_terlambat, jumlah_denda,
          status_denda, tanggal_bayar_denda, kode_petugas_denda ]
    },
    jumlah_buku
)
```

**Penjelasan grup berulang:**

Grup berulang ditandai dengan tanda `{ }`, yaitu data setiap eksemplar yang dipinjam. Grup ini berulang karena satu transaksi peminjaman dapat berisi beberapa buku, dan setiap eksemplar memiliki kode serta catatan pengembalian masing-masing.

Data denda ditempatkan di dalam grup eksemplar karena denda berkaitan dengan detail peminjaman tertentu, bukan otomatis berlaku untuk seluruh transaksi. Jika suatu eksemplar terlambat dikembalikan, data dendanya dicatat pada bagian eksemplar tersebut. Jika tidak ada denda, bagian data denda tidak diisi.

Catatan: `jumlah_buku` merupakan nilai yang dapat dihitung dari jumlah eksemplar. `aturan_perpanjangan` dan `kebijakan_denda` adalah informasi aturan yang ditampilkan pada slip, bukan catatan transaksi denda yang sebenarnya.

## 2. Tiga anomali pada data belum ternormalisasi

### a. Anomali ubah

Kolom nama_anggota dapat berulang pada beberapa baris peminjaman milik anggota yang sama. Jika nama anggota diperbaiki pada satu baris saja, tetapi baris lainnya tidak ikut diperbarui, data dengan no_anggota yang sama bisa memiliki nama berbeda.

### b. Anomali sisip

Data buku atau eksemplar baru sulit dicatat jika belum pernah dipinjam, karena kode_eksemplar dan judul_buku hanya tercatat pada baris peminjaman. Akibatnya, perpustakaan tidak bisa mencatat koleksi baru secara terpisah dari transaksi peminjaman.

### c. Anomali hapus

Jika satu-satunya baris peminjaman yang mencatat eksemplar EX-0145 dihapus, informasi kode_eksemplar dan judul_buku yang terkait juga bisa ikut hilang. Padahal, eksemplar tersebut mungkin masih menjadi koleksi perpustakaan dan tersedia untuk dipinjam kembali.

## 3. Bentuk 1NF

```text
PINJAM_1NF (
    no_peminjaman, kode_eksemplar,
    tanggal_jam_peminjaman, no_anggota, nama_anggota,
    kode_petugas, nama_petugas,
    judul_buku,
    tanggal_jatuh_tempo, tanggal_kembali, jumlah_perpanjangan,
    tarif_denda, hari_terlambat, jumlah_denda,
    status_denda, tanggal_bayar_denda, kode_petugas_denda,
    jumlah_buku
)
```

Perubahan dari UNF ke 1NF:

Grup berulang yang berisi data eksemplar dan dendanya diubah menjadi baris-baris terpisah. Setiap baris mewakili satu eksemplar dalam satu transaksi peminjaman. Kolom header seperti nama_anggota, nama_petugas, dan jumlah_buku tetap muncul pada setiap baris yang berasal dari peminjaman yang sama.

Alasan kunci primer menjadi gabungan no_peminjaman dan kode_eksemplar:

no_peminjaman saja tidak cukup untuk membedakan setiap baris karena satu transaksi dapat memuat beberapa eksemplar. Sementara itu, kode_eksemplar saja juga tidak cukup karena eksemplar yang sama dapat dipinjam kembali dalam transaksi lain setelah dikembalikan. Karena itu, gabungan no_peminjaman dan kode_eksemplar digunakan sebagai kunci primer komposit untuk membedakan setiap eksemplar pada setiap transaksi peminjaman.

## 4. Dependensi fungsional

Dependensi fungsional menunjukkan bahwa suatu kolom atau gabungan kolom menentukan nilai kolom lainnya. FD pada rancangan ini diturunkan dari aturan bisnis, struktur slip peminjaman, serta hubungan antara entitas Buku, Eksemplar, Peminjaman, dan Denda.

**FD1 — Data utama peminjaman**

```text
no_peminjaman → tanggal_jam_peminjaman, no_anggota, kode_petugas
```

Dasar: struktur slip peminjaman. Satu nomor peminjaman mengidentifikasi satu transaksi yang memiliki tanggal, satu anggota, dan petugas yang menangani transaksi tersebut. AB-11 mendukung kebutuhan untuk mencatat petugas yang menangani transaksi.

**FD2 — Nama anggota**

```text
no_anggota → nama_anggota
```

Dasar: AB-10 menyatakan bahwa `no_anggota` harus unik. Karena itu, satu nomor anggota menunjuk kepada satu anggota dengan nama tertentu.

**FD3 — Nama petugas**

```text
kode_petugas → nama_petugas
```

Dasar: rancangan data Petugas menetapkan `kode_petugas` sebagai kode unik untuk mengidentifikasi petugas. AB-11 mendukung pencatatan petugas yang menangani transaksi.

**FD4 — Judul buku**

```text
kode_eksemplar → judul_buku
```

Dasar: AB-10 menyatakan bahwa `kode_eksemplar` harus unik. Berdasarkan hubungan Eksemplar dengan Buku, setiap eksemplar mengacu pada satu buku, sedangkan judul disimpan pada data Buku. Jadi, judul diperoleh melalui hubungan Eksemplar ke Buku.

**FD5 — Data detail peminjaman**

```text
(no_peminjaman, kode_eksemplar)
    → tanggal_jatuh_tempo, tanggal_kembali, jumlah_perpanjangan
```

Dasar: AB-03 menetapkan masa pinjam selama 7 hari, AB-04 menetapkan maksimal satu kali perpanjangan selama 7 hari tambahan, dan AB-05 mengatur bahwa perpanjangan harus diajukan sebelum jatuh tempo. Ketiga atribut tersebut berlaku untuk eksemplar tertentu dalam transaksi peminjaman tertentu.

**FD6 — Data denda**

```text
(no_peminjaman, kode_eksemplar)
    → tarif_denda, hari_terlambat, jumlah_denda,
      status_denda, tanggal_bayar_denda, kode_petugas_denda
```

Dasar: AB-08 mengatur denda Rp4.000 per hari untuk setiap buku yang terlambat, AB-09 mengatur penggunaan tarif yang berlaku saat peminjaman, dan AB-11 mengharuskan transaksi mencatat petugas yang menanganinya. Berdasarkan ERD, satu detail peminjaman dapat memiliki nol atau satu catatan denda.

**FD7 — Hari keterlambatan (turunan)**

```text
(tanggal_jatuh_tempo, tanggal_kembali)
    → hari_terlambat
```

Dasar: nilai `hari_terlambat` dihitung dari selisih antara tanggal pengembalian dan tanggal jatuh tempo. Nilai ini hanya menunjukkan keterlambatan jika buku dikembalikan setelah tanggal jatuh tempo.

**FD8 — Jumlah denda (turunan)**

```text
(tarif_denda, hari_terlambat)
    → jumlah_denda
```

Dasar: AB-08 menetapkan bahwa denda dihitung berdasarkan tarif per hari dikalikan jumlah hari keterlambatan.

**FD9 — Jumlah buku dalam satu peminjaman (turunan)**

```text
no_peminjaman → jumlah_buku
```

Dasar: jumlah buku pada slip diperoleh dengan menghitung jumlah eksemplar yang tercatat pada detail peminjaman dengan nomor peminjaman tersebut. AB-02 menetapkan batas maksimal enam eksemplar dalam satu transaksi.

## 5. Menuju 2NF

Pada `PINJAM_1NF`, kunci primer kompositnya adalah (`no_peminjaman`, `kode_eksemplar`). FD1 dan FD9 melanggar 2NF karena atributnya hanya bergantung pada `no_peminjaman`, sedangkan FD4 hanya bergantung pada `kode_eksemplar`. Oleh karena itu, data yang bergantung pada nomor peminjaman dipisahkan ke tabel `PEMINJAMAN`, sedangkan data eksemplar sementara dipisahkan ke tabel `EKSEMPLAR`.

Atribut yang berkaitan dengan satu eksemplar dalam satu transaksi, seperti tanggal jatuh tempo, tanggal kembali, jumlah perpanjangan, dan data denda, sementara tetap berada di `DETAIL_PEMINJAMAN`. Pemisahan ini merupakan tahap 2NF; ketergantungan berantai yang masih ada akan diperbaiki pada tahap 3NF.

### Bentuk 2NF Sementara

```text
PEMINJAMAN (
    no_peminjaman, tanggal_jam_peminjaman, no_anggota, nama_anggota,
    kode_petugas, nama_petugas, jumlah_buku
)

EKSEMPLAR (
    kode_eksemplar, judul_buku
)

DETAIL_PEMINJAMAN (
    no_peminjaman*, kode_eksemplar*,
    tanggal_jatuh_tempo, tanggal_kembali, jumlah_perpanjangan,
    tarif_denda, hari_terlambat, jumlah_denda,
    status_denda, tanggal_bayar_denda, kode_petugas_denda
)
```

Keterangan:
- `no_peminjaman` menjadi kunci primer tabel `PEMINJAMAN`.
- `kode_eksemplar` menjadi kunci primer sementara tabel `EKSEMPLAR`.
- Gabungan (`no_peminjaman`, `kode_eksemplar`) menjadi kunci primer `DETAIL_PEMINJAMAN`.
- Tanda `*` menunjukkan kunci tamu (FK).
- `jumlah_buku`, `hari_terlambat`, dan `jumlah_denda` masih perlu ditinjau pada bagian keputusan nilai turunan.

## 6. Menuju 3NF

Pada bentuk 2NF masih terdapat tiga ketergantungan berantai yang perlu diperbaiki.

**Rantai 1 — Data anggota**

`no_peminjaman → no_anggota → nama_anggota`

Nama anggota ditentukan oleh `no_anggota`, bukan langsung oleh nomor peminjaman. Oleh karena itu, data anggota dipisahkan ke tabel `ANGGOTA`, sedangkan tabel `PEMINJAMAN` hanya menyimpan `id_anggota` sebagai kunci tamu.

**Rantai 2 — Data petugas**

`no_peminjaman → kode_petugas → nama_petugas`

Nama petugas ditentukan oleh kode petugas. Agar nama petugas tidak berulang pada setiap transaksi, data petugas dipisahkan ke tabel `PETUGAS`. Tabel `PEMINJAMAN` cukup menyimpan `id_petugas` sebagai kunci tamu.

**Rantai 3 — Data buku dan eksemplar**

`kode_eksemplar → kode_buku → judul_buku`

Setiap eksemplar merupakan salinan fisik dari satu buku. Judul buku ditentukan oleh identitas buku, bukan oleh transaksi peminjaman. Oleh karena itu, informasi judul dipisahkan ke tabel `BUKU`, sedangkan tabel `EKSEMPLAR` menyimpan `id_buku` sebagai kunci tamu.

### Keputusan Pemisahan Tabel DENDA

Saya memilih memisahkan `DENDA` dari `DETAIL_PEMINJAMAN`. Alasannya, tidak semua eksemplar yang dipinjam terkena denda, sehingga jika atribut denda tetap berada di tabel detail, banyak kolom denda akan kosong. Pemisahan ini juga sesuai dengan ERD Modul 3, karena satu detail peminjaman dapat memiliki nol atau satu catatan denda.

`hari_terlambat` ditandai sebagai atribut turunan karena dapat dihitung dari tanggal kembali dan tanggal jatuh tempo. Keputusan penyimpanannya dijelaskan lebih lanjut pada Bagian 7. Sementara itu, `jumlah_denda` tetap disimpan karena mencatat nilai denda yang benar-benar ditagihkan kepada anggota.

### Bentuk 3NF

```text
ANGGOTA (
    id_anggota [PK], no_anggota [UNIQUE], nama_anggota,
    alamat_anggota, no_hp_anggota, tanggal_daftar_anggota,
    status_anggota
)

PETUGAS (
    id_petugas [PK], kode_petugas [UNIQUE], nama_petugas,
    no_hp_petugas, status_petugas
)

BUKU (
    id_buku [PK], kode_buku [UNIQUE], judul_buku,
    pengarang_buku, penerbit_buku, tahun_terbit_buku
)

EKSEMPLAR (
    id_eksemplar [PK], kode_eksemplar [UNIQUE], id_buku [FK],
    kondisi_eksemplar, status_eksemplar,
    tanggal_masuk_eksemplar, asal_perolehan_eksemplar
)

PEMINJAMAN (
    id_peminjaman [PK], no_peminjaman [UNIQUE],
    tanggal_jam_peminjaman, id_anggota [FK], id_petugas [FK]
)

DETAIL_PEMINJAMAN (
    id_detail_peminjaman [PK], id_peminjaman [FK],
    id_eksemplar [FK], tanggal_jatuh_tempo,
    tanggal_kembali, jumlah_perpanjangan,
    UNIQUE (id_peminjaman, id_eksemplar)
)

DENDA (
    id_denda [PK], id_detail_peminjaman [FK, UNIQUE],
    tarif_denda, jumlah_denda, status_denda,
    tanggal_bayar_denda, id_petugas [FK]
)
```

Keterangan:
- `[PK]` = kunci primer.
- `[FK]` = kunci tamu.
- `[UNIQUE]` = nilai harus unik.
- `UNIQUE (id_peminjaman, id_eksemplar)` mencegah eksemplar yang sama dicatat dua kali dalam satu transaksi peminjaman.
- `id_detail_peminjaman` yang unik pada tabel `DENDA` membatasi satu detail peminjaman memiliki paling banyak satu catatan denda.
- `jumlah_buku` tidak disimpan karena dapat dihitung dari jumlah baris pada `DETAIL_PEMINJAMAN`.
- `hari_terlambat` tidak dicantumkan sebagai kolom tersimpan karena merupakan nilai turunan. Atribut ini tetap dapat ditampilkan sebagai atribut turunan pada ERD.

**Kesesuaian dengan ERD Modul 3:** Pemisahan tabel `DENDA` tidak mengubah entitas dan relasi utama karena Denda sudah menjadi entitas tersendiri. Bentuk 3NF ini menggunakan kunci pengganti `id_*` sesuai rancangan ERD, sedangkan kode alami seperti `no_peminjaman`, `no_anggota`, dan `kode_eksemplar` tetap dipertahankan sebagai identitas unik.

## 7. Keputusan nilai turunan

### a. `hari_terlambat`

`hari_terlambat` tidak disimpan sebagai kolom tersendiri karena nilainya dapat dihitung dari `tanggal_kembali` dikurangi `tanggal_jatuh_tempo`. Dengan menghitungnya saat dibutuhkan, sistem tidak perlu menyimpan dua data yang bisa berbeda jika tanggal pengembalian diperbaiki. Selama buku belum dikembalikan, lama keterlambatan dapat dihitung sementara menggunakan tanggal hari ini untuk keperluan pemantauan.

### b. `jumlah_denda`

`jumlah_denda` tetap disimpan karena mencatat jumlah uang yang benar-benar ditagihkan kepada anggota saat denda ditetapkan. Walaupun nilainya berasal dari `tarif_denda × hari_terlambat`, jumlah yang sudah ditagihkan merupakan catatan historis yang perlu dipertahankan. Jika tanggal pengembalian kemudian dikoreksi, jumlah denda yang tersimpan tidak otomatis berubah; petugas perlu memeriksa dan melakukan penyesuaian secara sengaja apabila diperlukan.

### c. `jumlah_buku`

`jumlah_buku` tidak disimpan karena dapat diperoleh dengan menghitung jumlah baris pada `DETAIL_PEMINJAMAN` untuk suatu transaksi. Dengan cara ini, jumlah buku pada slip selalu mengikuti data detail dan tidak berisiko berbeda dari jumlah eksemplar yang sebenarnya tercatat.

### d. Nilai tampilan lainnya

- `nama_anggota` ditampilkan dari tabel `ANGGOTA` melalui `no_anggota` atau `id_anggota`, bukan disimpan ulang pada setiap transaksi peminjaman.
- `nama_petugas` ditampilkan dari tabel `PETUGAS` melalui identitas petugas.
- `judul_buku` diperoleh melalui hubungan `EKSEMPLAR` dengan `BUKU`.
- Nomor urutan baris pada slip dibuat saat ditampilkan dan tidak disimpan sebagai data utama transaksi.
- Aturan perpanjangan dan tarif umum pada slip merupakan informasi kebijakan. Namun, `tarif_denda` yang berlaku pada suatu catatan denda tetap disimpan agar tarif historis dapat diketahui jika kebijakan berubah.

**Kesimpulan:** `hari_terlambat` dan `jumlah_buku` dihitung ketika dibutuhkan, sedangkan `jumlah_denda` disimpan untuk mempertahankan nilai yang benar-benar ditagihkan. Keputusan ini membedakan nilai hasil perhitungan dari catatan transaksi historis.

## 8. Pemeriksaan BCNF

- **ANGGOTA** — Penentunya adalah `id_anggota` dan `no_anggota`. Keduanya merupakan kunci kandidat karena masing-masing mengidentifikasi satu anggota secara unik. Jadi, BCNF terpenuhi.
- **PETUGAS** — Penentunya adalah `id_petugas` dan `kode_petugas`. Keduanya merupakan kunci kandidat yang menentukan data petugas. Jadi, BCNF terpenuhi.
- **BUKU** — Penentunya adalah `id_buku` dan `kode_buku`. Keduanya merupakan kunci kandidat yang menentukan data buku. Jadi, BCNF terpenuhi.
- **EKSEMPLAR** — Penentunya adalah `id_eksemplar` dan `kode_eksemplar`. Keduanya merupakan kunci kandidat yang menentukan data eksemplar. Jadi, BCNF terpenuhi.
- **PEMINJAMAN** — Penentunya adalah `id_peminjaman` dan `no_peminjaman`. Keduanya merupakan kunci kandidat yang menentukan data transaksi peminjaman. Jadi, BCNF terpenuhi.
- **DETAIL_PEMINJAMAN** — Penentunya adalah `id_detail_peminjaman` serta gabungan (`id_peminjaman`, `id_eksemplar`). Keduanya merupakan kunci kandidat karena dapat mengenali satu baris detail secara unik. Jadi, BCNF terpenuhi.
- **DENDA** — Penentunya adalah `id_denda` dan `id_detail_peminjaman`. Keduanya merupakan kunci kandidat karena setiap catatan denda memiliki identitas unik dan satu detail peminjaman paling banyak memiliki satu catatan denda. Jadi, BCNF terpenuhi.

**Kesimpulan:** Ketujuh tabel memenuhi BCNF berdasarkan dependensi fungsional dan batasan keunikan yang ditetapkan. Setiap penentu pada pemeriksaan ini merupakan kunci kandidat. Penggunaan kunci pengganti `id_*` tidak menghilangkan kewajiban memeriksa kunci alami, seperti `no_anggota` dan `kode_eksemplar`.

## 9. Perbandingan dengan Skema Kanonik

Hasil normalisasi proyek Perpustakaan Pakde DS menggunakan kunci pengganti `id_*` sebagai kunci primer dan tetap mempertahankan kode alami, seperti `no_anggota`, `kode_petugas`, `kode_buku`, `kode_eksemplar`, dan `no_peminjaman`, sebagai nilai unik. Susunan tabel hasil 3NF juga tetap memisahkan data anggota, petugas, buku, eksemplar, peminjaman, detail peminjaman, dan denda.

Hasil tersebut sudah selaras dengan ERD Modul 3. Tidak ada perubahan entitas atau hubungan yang mengharuskan ERD digambar ulang. `hari_terlambat` tetap diperlakukan sebagai atribut turunan, `jumlah_denda` disimpan sebagai catatan jumlah yang ditagihkan, dan `jumlah_buku` dihitung dari detail peminjaman. Keputusan ini didokumentasikan pada bagian normalisasi agar alasan desain dapat ditelusuri kembali.