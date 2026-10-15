# Normalisasi Kopma — Danang Setiawan (25430121)

## 1. Bentuk UNF

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

Grup berulang terdapat pada atribut yang diapit tanda {}, yaitu kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, dan subtotal_detail_penjualan. Atribut tersebut disebut grup berulang karena satu nota bisa berisi beberapa barang, sehingga informasi barang muncul berulang kali dalam satu nota.

## 2. Tiga anomali pada data belum ternormalisasi

### a. Anomali ubah

Kolom nama_anggota dapat tersimpan berulang pada beberapa baris penjualan. Jika nama anggota diperbarui pada satu baris saja, sedangkan baris lainnya tidak ikut diperbarui, anggota dengan no_anggota yang sama bisa tercatat dengan nama yang berbeda.

### b. Anomali sisip

Barang baru yang belum pernah terjual tidak bisa dicatat dengan mudah karena data kode_barang dan nama_barang tersimpan dalam grup barang pada nota penjualan. Tanpa adanya transaksi penjualan, tidak ada baris nota untuk menyimpan data barang tersebut.

### c. Anomali hapus

Jika nota terakhir yang memuat suatu barang dihapus, informasi kode_barang dan nama_barang barang tersebut bisa ikut hilang. Akibatnya, data barang yang seharusnya masih perlu diketahui tidak lagi tercatat dalam spreadsheet penjualan.

## 3. Bentuk 1NF

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas,
          nama_petugas, no_anggota,
          nama_anggota, nama_barang, qty_detail_penjualan,
          harga_satuan_detail_penjualan, subtotal_detail_penjualan,
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

Perubahan dari UNF ke 1NF: Grup berulang dihilangkan dengan membuat satu baris untuk setiap barang dalam satu nota. Setiap kolom berisi satu nilai, sehingga tidak ada lagi grup barang yang berulang dalam satu nota.

Alasan kunci primer menjadi (no_nota_penjualan, kode_barang): Satu nota dapat berisi beberapa barang, sehingga no_nota_penjualan saja tidak cukup untuk membedakan setiap baris. Sementara itu, kode_barang yang sama juga dapat muncul pada nota yang berbeda. Oleh karena itu, gabungan no_nota_penjualan dan kode_barang digunakan sebagai kunci primer komposit untuk membedakan setiap barang pada setiap nota.

## 4. Dependensi fungsional

FD1: no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota (AB-01)

FD2: kode_petugas → nama_petugas

FD3: no_anggota → nama_anggota (AB-05)

FD4: kode_barang → nama_barang

FD5: (no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan (AB-04)

FD6: qty_detail_penjualan, harga_satuan_detail_penjualan → subtotal_detail_penjualan (turunan)

### Titik Analisis 1

**1. Mengapa harga satuan pada transaksi ditentukan oleh gabungan `no_nota_penjualan` dan `kode_barang`, bukan oleh `kode_barang` saja?**

Karena harga barang bisa berubah dari waktu ke waktu. AB-04 menyatakan bahwa harga yang digunakan pada nota harus tetap sesuai dengan harga saat transaksi terjadi. Jadi, kode barang saja tidak cukup untuk menentukan harga transaksi karena barang yang sama bisa dijual dengan harga berbeda pada nota yang berbeda.

**2. Apa yang terjadi pada laporan omzet tahun lalu jika harga satuan dipindah ke tabel barang?**

Laporan omzet tahun lalu bisa menjadi tidak akurat. Contohnya, jika harga pulpen tahun lalu Rp4.000 dan sekarang naik menjadi Rp6.000, sistem bisa menggunakan harga Rp6.000 untuk menghitung transaksi lama. Akibatnya, omzet tahun lalu terlihat lebih besar daripada yang sebenarnya.

## 5. Menuju 2NF

FD1 dan FD4 melanggar 2NF karena atributnya bergantung pada sebagian kunci primer komposit (no_nota_penjualan, kode_barang). Pada FD1, informasi tanggal, petugas, dan anggota cukup ditentukan oleh no_nota_penjualan, sedangkan pada FD4, nama_barang cukup ditentukan oleh kode_barang.

Untuk mengatasi masalah tersebut, atribut yang bergantung pada no_nota_penjualan dipisahkan ke tabel PENJUALAN, atribut yang bergantung pada kode_barang dipisahkan ke tabel BARANG, dan atribut yang bergantung pada gabungan kedua kunci tetap berada di tabel DETAIL_PENJUALAN.

## 6. Menuju 3NF

Setelah mencapai 2NF, tabel PENJUALAN masih memiliki ketergantungan berantai, yaitu no_nota_penjualan → kode_petugas → nama_petugas dan no_nota_penjualan → no_anggota → nama_anggota. Artinya, nama petugas ditentukan oleh kode petugas dan nama anggota ditentukan oleh nomor anggota, bukan secara langsung oleh nomor nota.

Untuk mengatasi masalah tersebut, data petugas dipisahkan ke tabel PETUGAS dan data anggota dipisahkan ke tabel ANGGOTA. Tabel PENJUALAN tetap menyimpan kode_petugas dan no_anggota sebagai kunci tamu untuk menghubungkan transaksi dengan petugas dan anggota.

Hasil akhir normalisasi:

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*,
           no_anggota*, bayar_penjualan)

DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*,
                  qty_detail_penjualan, harga_satuan_detail_penjualan)

BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang,
        stok_barang, stok_min_barang)

PETUGAS (kode_petugas, nama_petugas, peran_petugas)

ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
         no_hp_anggota, status_anggota, tgl_daftar_anggota)

-- Kunci primer (PK):
-- PENJUALAN: no_nota_penjualan
-- DETAIL_PENJUALAN: (no_nota_penjualan, kode_barang)
-- BARANG: kode_barang
-- PETUGAS: kode_petugas
-- ANGGOTA: no_anggota
-- Tanda * menunjukkan kunci tamu (FK).
```

Hasil ini memisahkan data transaksi, barang, petugas, dan anggota agar data tidak perlu diulang pada banyak baris serta mengurangi risiko ketidakkonsistenan ketika data diperbarui.

## 7. Keputusan nilai turunan

- `subtotal_detail_penjualan` — tidak disimpan. Nilainya dihitung dari qty_detail_penjualan × harga_satuan_detail_penjualan saat dibutuhkan.
- `jumlah_penjualan` — tidak disimpan. Nilainya dihitung dari penjumlahan seluruh subtotal barang dalam satu nota.
- `total_penjualan` — tidak disimpan pada tabel operasional. Nilainya dihitung dari jumlah_penjualan dikurangi diskon yang diterapkan.
- `diskon_penjualan` — tidak disimpan. Dihitung berdasarkan ketentuan diskon anggota (AB-02); `bayar_penjualan` tetap disimpan untuk mencatat jumlah uang yang benar-benar diterima.

Saya memilih tidak menyimpan subtotal, jumlah penjualan, dan total penjualan karena ketiganya dapat dihitung kembali dari data lain. Keputusan ini mengurangi risiko ketidaksesuaian jika detail transaksi diperbaiki. Sementara itu, nilai diskon yang benar-benar diterapkan perlu dicatat agar riwayat potongan pada nota lama tidak berubah mengikuti kebijakan terbaru.

### Titik Analisis 2

Keputusan yang berbeda antara tabel operasional dan tabel arsip tetap konsisten karena keduanya memiliki tujuan berbeda. Pada tabel operasional, transaksi masih dapat diperbaiki sehingga total lebih baik dihitung dari data detail terbaru agar tidak berbeda dengan isi transaksi. Sebaliknya, tabel arsip menyimpan catatan transaksi yang sudah selesai dan tidak boleh berubah. Karena itu, total penjualan boleh disimpan dalam arsip untuk mempertahankan nilai transaksi pada saat kejadian, tanpa dipengaruhi perubahan data atau tarif di kemudian hari.

## 8. Pemeriksaan BCNF

- **PENJUALAN** — Penentu: `no_nota_penjualan`. Kolom ini merupakan kunci primer yang menentukan atribut lainnya. Jadi, BCNF terpenuhi.
- **DETAIL_PENJUALAN** — Penentu: (`no_nota_penjualan`, `kode_barang`). Gabungan kedua kolom ini merupakan kunci primer yang menentukan jumlah dan harga barang pada setiap nota. Jadi, BCNF terpenuhi.
- **BARANG** — Penentu: `kode_barang`. Kolom ini merupakan kunci primer yang menentukan data barang lainnya. Jadi, BCNF terpenuhi.
- **PETUGAS** — Penentu: `kode_petugas`. Kolom ini merupakan kunci primer yang menentukan nama dan peran petugas. Jadi, BCNF terpenuhi.
- **ANGGOTA** — Penentu: `no_anggota` dan `nim_anggota`. Keduanya merupakan kunci kandidat karena masing-masing dapat mengenali satu anggota secara unik. Jadi, setiap penentu merupakan kunci kandidat dan BCNF terpenuhi.

**Kesimpulan:** Kelima tabel memenuhi BCNF karena setiap penentu yang diperiksa merupakan kunci kandidat. Walaupun tabel `ANGGOTA` memiliki dua kunci kandidat, kondisi tersebut tidak melanggar BCNF karena keduanya dapat menentukan atribut anggota lainnya secara unik.

## 9. Perbandingan dengan skema kanonik

### Tabel 4.2 Skema Kanonik Kopma Hasil Normalisasi

| Tabel | Kunci primer (PK) | Kunci unik | Kunci tamu (FK) |
|---|---|---|---|
| `petugas` | `id_petugas` | `kode_petugas` | — |
| `anggota` | `id_anggota` | `no_anggota`, `nim_anggota` | — |
| `barang` | `id_barang` | `kode_barang` | — |
| `pemasok` | `id_pemasok` | — | — |
| `penjualan` | `id_penjualan` | `no_nota_penjualan` | `id_petugas`, `id_anggota` (boleh `NULL`) |
| `detail_penjualan` | (`id_penjualan`, `id_barang`) | — | `id_penjualan`, `id_barang` |
| `pembelian` | `id_pembelian` | — | `id_pemasok` |
| `detail_pembelian` | (`id_pembelian`, `id_barang`) | — | `id_pembelian`, `id_barang` |

**Perbandingan dengan hasil normalisasi saya:**

Hasil normalisasi saya menggunakan kunci alami, seperti `no_nota_penjualan` pada tabel `PENJUALAN` dan `kode_barang` pada tabel `BARANG`. Sementara itu, skema kanonik menggunakan kunci pengganti berupa `id_*` sebagai kunci primer, sedangkan kunci alami tetap dipertahankan sebagai kunci unik. Pada tabel `ANGGOTA`, `no_anggota` dan `nim_anggota` juga tetap unik. Perbedaan ini merupakan keputusan desain, bukan berarti hasil normalisasi saya salah. Penggunaan `id_*` juga sesuai dengan ERD Kopma pada Modul 3. Selain itu, skema kanonik mencakup data pemasok dan pembelian, sedangkan hasil normalisasi awal saya berfokus pada nota penjualan.

### Titik Analisis 3

Informasi tentang barang yang dipasok oleh pemasok disimpan melalui tabel `pemasok`, `pembelian`, `detail_pembelian`, dan `barang`. Hubungannya dapat ditelusuri melalui jalur `pemasok → pembelian → detail_pembelian → barang`. Dengan cara ini, sistem dapat mengetahui pemasok yang mengirim suatu barang berdasarkan catatan pembeliannya.

Keuntungannya adalah satu barang dapat dibeli dari beberapa pemasok yang berbeda pada transaksi pembelian yang berbeda. Jika nama pemasok hanya disimpan di tabel `barang`, sistem akan kesulitan mencatat beberapa pemasok untuk barang yang sama. Selain itu, riwayat pemasok sebelumnya tetap bisa ditelusuri meskipun barang tersebut kemudian dibeli dari pemasok lain.

