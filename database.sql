
-- =====================================================
-- PROJECT: PORTAL INFORMASI UMKM DAN POTENSI DESA
-- DESA TAMBAKRIGADUNG
-- DATABASE: db_umkm_tambakrigadung
-- DBMS: PostgreSQL
-- =====================================================


-- 1. TABEL ADMIN
CREATE TABLE admin (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 2. TABEL PROFIL ADMIN
-- Relasi ONE TO ONE dengan tabel admin
CREATE TABLE profil_admin (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    admin_id BIGINT NOT NULL UNIQUE,
    nama_lengkap VARCHAR(100) NOT NULL,
    jabatan VARCHAR(100),
    no_telepon VARCHAR(20),

    CONSTRAINT fk_profil_admin
        FOREIGN KEY (admin_id)
        REFERENCES admin(id)
        ON DELETE CASCADE
);


-- 3. TABEL KATEGORI UMKM
CREATE TABLE kategori_umkm (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT
);


-- 4. TABEL UMKM
-- Relasi ONE TO MANY dengan kategori_umkm
CREATE TABLE umkm (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kategori_id BIGINT NOT NULL,
    nama_usaha VARCHAR(150) NOT NULL,
    nama_pemilik VARCHAR(100),
    alamat_usaha TEXT,
    nomor_telepon VARCHAR(20),
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_umkm_kategori
        FOREIGN KEY (kategori_id)
        REFERENCES kategori_umkm(id)
);


-- 5. TABEL PRODUK
-- Relasi ONE TO MANY dengan tabel umkm
CREATE TABLE produk (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    umkm_id BIGINT NOT NULL,
    nama_produk VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    harga NUMERIC(15,2) CHECK (harga >= 0),
    foto_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_produk_umkm
        FOREIGN KEY (umkm_id)
        REFERENCES umkm(id)
        ON DELETE CASCADE
);


-- 6. TABEL KATEGORI POTENSI
CREATE TABLE kategori_potensi (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT
);


-- 7. TABEL POTENSI DESA
-- Relasi ONE TO MANY dengan kategori_potensi
CREATE TABLE potensi_desa (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kategori_id BIGINT NOT NULL,
    nama_potensi VARCHAR(150) NOT NULL,
    lokasi TEXT,
    deskripsi TEXT,
    foto_url TEXT,
    status VARCHAR(20) DEFAULT 'aktif'
        CHECK (status IN ('aktif', 'tidak_aktif')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_potensi_kategori
        FOREIGN KEY (kategori_id)
        REFERENCES kategori_potensi(id)
);


-- 8. TABEL PAGUYUBAN
-- Struktur disiapkan untuk pengelolaan paguyuban
CREATE TABLE paguyuban (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_paguyuban VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    alamat TEXT,
    kontak VARCHAR(30)
);


-- 9. TABEL ANGGOTA PAGUYUBAN
-- Tabel penghubung MANY TO MANY antara UMKM dan paguyuban
CREATE TABLE anggota_paguyuban (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    umkm_id BIGINT NOT NULL,
    paguyuban_id BIGINT NOT NULL,
    tanggal_bergabung DATE,
    status VARCHAR(20) DEFAULT 'aktif',

    CONSTRAINT unique_anggota
        UNIQUE (umkm_id, paguyuban_id),

    CONSTRAINT fk_anggota_umkm
        FOREIGN KEY (umkm_id)
        REFERENCES umkm(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_anggota_paguyuban
        FOREIGN KEY (paguyuban_id)
        REFERENCES paguyuban(id)
        ON DELETE CASCADE
);


-- =====================================================
-- DATA KATEGORI POTENSI DESA YANG SUDAH DIKONFIRMASI
-- =====================================================

INSERT INTO kategori_potensi (nama_kategori, deskripsi)
VALUES
(
    'Koperasi',
    'Kategori potensi koperasi desa'
),
(
    'Wisata',
    'Kategori potensi wisata desa'
),
(
    'Perikanan',
    'Kategori potensi sektor perikanan desa'
),
(
    'Peternakan',
    'Kategori potensi sektor peternakan desa'
);


-- =====================================================
-- SELESAI MEMBUAT DATABASE
-- =====================================================
