-- =========================================
-- FILE: kuis_pertemuan4_IK2411013.sql
-- =========================================

-- =========================================
-- 1. PROCEDURE CEK STATUS STOK
-- =========================================
DROP PROCEDURE IF EXISTS cek_status_stok;
DELIMITER $$

CREATE PROCEDURE cek_status_stok(IN p_stok INT)
BEGIN
    DECLARE v_status VARCHAR(50);

    IF p_stok = 0 THEN
        SET v_status = 'Habis';
    ELSEIF p_stok BETWEEN 1 AND 5 THEN
        SET v_status = 'Hampir Habis';
    ELSEIF p_stok BETWEEN 6 AND 20 THEN
        SET v_status = 'Tersedia';
    ELSE
        SET v_status = 'Stok Aman';
    END IF;

    SELECT CONCAT('Status: ', v_status) AS hasil;
END$$

DELIMITER ;



-- =========================================
-- 2. PROCEDURE HITUNG DISKON 
-- =========================================
DROP PROCEDURE IF EXISTS hitung_diskon;
DELIMITER $$

CREATE PROCEDURE hitung_diskon(IN p_input VARCHAR(20))
BEGIN
    DECLARE total_belanja DECIMAL(12,2);
    DECLARE v_diskon_persen INT DEFAULT 0;
    DECLARE v_jumlah_diskon DECIMAL(12,2) DEFAULT 0;
    DECLARE v_total_bayar DECIMAL(12,2) DEFAULT 0;

    -- Hilangkan titik (format Indonesia)
    SET total_belanja = REPLACE(p_input, '.', '');

    IF total_belanja >= 1000000 THEN
        SET v_diskon_persen = 15;
    ELSEIF total_belanja >= 500000 THEN
        SET v_diskon_persen = 10;
    ELSEIF total_belanja >= 250000 THEN
        SET v_diskon_persen = 5;
    ELSE
        SET v_diskon_persen = 0;
    END IF;

    SET v_jumlah_diskon = total_belanja * v_diskon_persen / 100;
    SET v_total_bayar = total_belanja - v_jumlah_diskon;

    SELECT 
        total_belanja,
        CONCAT(v_diskon_persen, '%') AS persentase_diskon,
        v_jumlah_diskon,
        v_total_bayar;
END$$

DELIMITER ;



-- =========================================
-- 3. PROCEDURE CEK PREDIKAT MAHASISWA
-- =========================================
DROP PROCEDURE IF EXISTS cek_predikat_mahasiswa;
DELIMITER $$

CREATE PROCEDURE cek_predikat_mahasiswa(IN p_nilai INT)
BEGIN
    DECLARE v_predikat VARCHAR(50);
    DECLARE v_status VARCHAR(20);

    IF p_nilai BETWEEN 90 AND 100 THEN
        SET v_predikat = 'Sangat Memuaskan';
    ELSEIF p_nilai BETWEEN 80 AND 89 THEN
        SET v_predikat = 'Memuaskan';
    ELSEIF p_nilai BETWEEN 70 AND 79 THEN
        SET v_predikat = 'Baik';
    ELSEIF p_nilai BETWEEN 60 AND 69 THEN
        SET v_predikat = 'Cukup';
    ELSE
        SET v_predikat = 'Kurang';
    END IF;

    IF p_nilai >= 70 THEN
        SET v_status = 'Lulus';
    ELSE
        SET v_status = 'Tidak Lulus';
    END IF;

    SELECT 
        p_nilai AS nilai,
        v_predikat AS predikat,
        v_status AS status;
END$$

DELIMITER ;



-- =========================================
-- 4. TABEL PRODUK
-- =========================================
DROP TABLE IF EXISTS produk;

CREATE TABLE produk ( 
    id_produk INT AUTO_INCREMENT PRIMARY KEY, 
    nama_produk VARCHAR(100), 
    stok INT 
);



-- =========================================
-- 5. INSERT DATA PRODUK
-- =========================================
INSERT INTO produk (nama_produk, stok) VALUES
('Laptop', 25),
('Mouse', 3),
('Keyboard', 10),
('Monitor', 0),
('Flashdisk', 6);



-- =========================================
-- 6. QUERY STATUS STOK (CASE)
-- =========================================
SELECT 
    id_produk,
    nama_produk,
    stok,
    CASE
        WHEN stok = 0 THEN 'Habis'
        WHEN stok BETWEEN 1 AND 5 THEN 'Hampir Habis'
        WHEN stok BETWEEN 6 AND 20 THEN 'Tersedia'
        ELSE 'Stok Aman'
    END AS status_stok
FROM produk;



-- =========================================
-- 7. CONTOH PEMANGGILAN PROCEDURE
-- =========================================

-- Cek stok
CALL cek_status_stok(3);

-- Hitung diskon 
CALL hitung_diskon('750.000');

-- Cek predikat mahasiswa
CALL cek_predikat_mahasiswa(85);