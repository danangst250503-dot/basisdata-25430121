-- p05_ddl_25430121.sql
-- Proyek: Perpustakaan Pakde DS
-- Nama: Danang Setiawan
-- NIM: 25430121
-- Kelas: A

USE perpus_121;

DROP TABLE IF EXISTS denda;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS petugas;
DROP TABLE IF EXISTS anggota;

-- 1. Tabel anggota
CREATE TABLE anggota (
    id_anggota INT NOT NULL AUTO_INCREMENT,
    no_anggota CHAR(6) NOT NULL,
    nama_anggota VARCHAR(100) NOT NULL,
    alamat_anggota VARCHAR(200) NOT NULL,
    no_hp_anggota VARCHAR(20) NULL,
    tanggal_daftar_anggota DATE NOT NULL,
    status_anggota ENUM('aktif', 'nonaktif') NOT NULL,
    PRIMARY KEY (id_anggota),
    UNIQUE KEY uq_anggota_no (no_anggota) -- AB-10: nomor anggota unik
) ENGINE=InnoDB;

-- 2. Tabel petugas
CREATE TABLE petugas (
    id_petugas INT NOT NULL AUTO_INCREMENT,
    kode_petugas CHAR(6) NOT NULL, -- Format resmi: PT-001
    nama_petugas VARCHAR(100) NOT NULL,
    no_hp_petugas VARCHAR(20) NULL,
    status_petugas ENUM('aktif', 'nonaktif') NOT NULL,
    PRIMARY KEY (id_petugas),
    UNIQUE KEY uq_petugas_kode (kode_petugas) -- Identitas data: kode petugas unik
) ENGINE=InnoDB;

-- 3. Tabel buku
CREATE TABLE buku (
    id_buku INT NOT NULL AUTO_INCREMENT,
    kode_buku CHAR(7) NOT NULL,
    judul_buku VARCHAR(200) NOT NULL,
    pengarang_buku VARCHAR(100) NOT NULL,
    penerbit_buku VARCHAR(100) NOT NULL,
    tahun_terbit_buku YEAR NOT NULL,
    PRIMARY KEY (id_buku),
    UNIQUE KEY uq_buku_kode (kode_buku) -- Identitas data: kode buku unik
) ENGINE=InnoDB;

-- 4. Tabel eksemplar
CREATE TABLE eksemplar (
    id_eksemplar INT NOT NULL AUTO_INCREMENT,
    kode_eksemplar CHAR(7) NOT NULL,
    id_buku INT NOT NULL,
    kondisi_eksemplar ENUM(
        'baik',
        'rusak ringan',
        'rusak berat'
    ) NOT NULL, -- AB-06: pembatasan kondisi eksemplar
    status_eksemplar ENUM(
        'tersedia',
        'dipinjam',
        'tidak tersedia'
    ) NOT NULL, -- AB-06: pembatasan status eksemplar
    tanggal_masuk_eksemplar DATE NOT NULL,
    asal_perolehan_eksemplar VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_eksemplar),
    UNIQUE KEY uq_eksemplar_kode (kode_eksemplar), -- AB-10: kode eksemplar unik
    CONSTRAINT fk_eksemplar_buku
        FOREIGN KEY (id_buku)
        REFERENCES buku (id_buku) -- AB-14: eksemplar terhubung dengan buku
) ENGINE=InnoDB;

-- 5. Tabel peminjaman
CREATE TABLE peminjaman (
    id_peminjaman INT NOT NULL AUTO_INCREMENT,
    no_peminjaman CHAR(14) NOT NULL,
    tanggal_jam_peminjaman DATETIME NOT NULL,
    id_anggota INT NOT NULL, -- AB-01
    id_petugas INT NOT NULL, -- AB-11
    PRIMARY KEY (id_peminjaman),
    UNIQUE KEY uq_peminjaman_no (no_peminjaman),
    CONSTRAINT fk_peminjaman_anggota
        FOREIGN KEY (id_anggota)
        REFERENCES anggota (id_anggota),
    CONSTRAINT fk_peminjaman_petugas
        FOREIGN KEY (id_petugas)
        REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

-- 6. Tabel detail_peminjaman
CREATE TABLE detail_peminjaman (
    id_detail_peminjaman INT NOT NULL AUTO_INCREMENT,
    id_peminjaman INT NOT NULL,
    id_eksemplar INT NOT NULL,
    tanggal_jatuh_tempo DATE NOT NULL,
    tanggal_kembali DATE NULL,
    jumlah_perpanjangan TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id_detail_peminjaman),
    UNIQUE KEY uq_detail_peminjaman_eksemplar (
        id_peminjaman,
        id_eksemplar
    ),
    CONSTRAINT fk_detail_peminjaman_peminjaman
        FOREIGN KEY (id_peminjaman)
        REFERENCES peminjaman (id_peminjaman)
        ON DELETE CASCADE,
    CONSTRAINT fk_detail_peminjaman_eksemplar
        FOREIGN KEY (id_eksemplar)
        REFERENCES eksemplar (id_eksemplar),
    CONSTRAINT ck_detail_jumlah_perpanjangan
        CHECK (jumlah_perpanjangan <= 1) -- AB-04: maksimal 1 kali perpanjangan
) ENGINE=InnoDB;

-- 7. Tabel denda
CREATE TABLE denda (
    id_denda INT NOT NULL AUTO_INCREMENT,
    id_detail_peminjaman INT NOT NULL,
    id_petugas INT NOT NULL, -- AB-11: petugas penanganan denda wajib tercatat
    tarif_denda DECIMAL(12,2) NOT NULL, -- AB-09: tarif denda disimpan saat transaksi
    jumlah_denda DECIMAL(12,2) NOT NULL DEFAULT 0,
    status_denda ENUM('belum lunas', 'lunas')
        NOT NULL DEFAULT 'belum lunas', -- AB-12: status pelunasan denda
    tanggal_bayar_denda DATE NULL,
    PRIMARY KEY (id_denda),
    UNIQUE KEY uq_denda_detail (id_detail_peminjaman),
    CONSTRAINT fk_denda_detail_peminjaman
        FOREIGN KEY (id_detail_peminjaman)
        REFERENCES detail_peminjaman (id_detail_peminjaman),
    CONSTRAINT fk_denda_petugas
        FOREIGN KEY (id_petugas)
        REFERENCES petugas (id_petugas),
    CONSTRAINT ck_denda_tarif
        CHECK (tarif_denda >= 0),
    CONSTRAINT ck_denda_jumlah
        CHECK (jumlah_denda >= 0)
) ENGINE=InnoDB;