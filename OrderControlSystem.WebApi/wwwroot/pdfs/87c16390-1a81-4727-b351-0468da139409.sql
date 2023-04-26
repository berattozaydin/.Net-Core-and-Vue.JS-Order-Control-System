-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 172.16.10.15
-- Üretim Zamanı: 30 Ara 2022, 10:51:33
-- Sunucu sürümü: 8.0.28
-- PHP Sürümü: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `TpHetrCRM`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `TreatmentType`
--

CREATE TABLE `TreatmentType` (
  `TreatmentTypeId` int NOT NULL,
  `Name` varchar(35) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `TreatmentType`
--

INSERT INTO `TreatmentType` (`TreatmentTypeId`, `Name`) VALUES
(1, 'Sertleştirme'),
(2, 'Menevişleme'),
(3, 'Islah'),
(4, 'Gerilim Giderme'),
(5, 'Normalizasyon'),
(6, 'Yumuşatma'),
(7, 'İndüksiyon Yüzey Sertleştirme');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `TreatmentType`
--
ALTER TABLE `TreatmentType`
  ADD PRIMARY KEY (`TreatmentTypeId`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `TreatmentType`
--
ALTER TABLE `TreatmentType`
  MODIFY `TreatmentTypeId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
