-- p01_lingkungan_25430121.sql
-- Password sengaja saya ganti penanda. TIDAK saya commit password asli.
CREATE DATABASE IF NOT EXISTS kopma_121
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'mhs_121'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_121.* TO 'mhs_121'@'localhost';