-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 172.16.10.15
-- Üretim Zamanı: 18 Nis 2023, 05:15:13
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
-- Veritabanı: `TpHetrL3`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`%` PROCEDURE `usp_CreateCustomerOrderNumber` ()  BEGIN
DECLARE CUSTOMERORDERNUMBERCNT INT(11);
DECLARE CUSTOMERORDERNUMBERCRTED VARCHAR(250);
SET CUSTOMERORDERNUMBERCNT = (SELECT CustomerOrderNumberCounter FROM CustomerOrderNumber Order by CustomerOrderNumberCounter DESC limit 1);

IF (CUSTOMERORDERNUMBERCNT = 100) THEN 
DELETE FROM CustomerOrderNumber WHERE CustomerOrderNumberCounter < CUSTOMERORDERNUMBERCNT;
END IF;

SET CUSTOMERORDERNUMBERCNT = CUSTOMERORDERNUMBERCNT+2;
SET CUSTOMERORDERNUMBERCRTED = CONCAT('TP-',(REPLACE(CURRENT_DATE(),'-','')),CUSTOMERORDERNUMBERCNT );
INSERT INTO CustomerOrderNumber(CustomerOrderNumberCounter) VALUES(CUSTOMERORDERNUMBERCNT);
UPDATE CustomerOrderNumber Set CustomerOrderNumberCreated=CUSTOMERORDERNUMBERCRTED WHERE CustomerOrderNumberCounter = CUSTOMERORDERNUMBERCNT;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `usp_CreateWorkOrderNumber` ()  BEGIN
DECLARE WORKORDERNUMBERCNT INT(11);
DECLARE WORKORDERNUMBERCRTED VARCHAR(250);
SET WORKORDERNUMBERCNT = (SELECT WorkOrderNumberCounter FROM WorkOrderNumber Order by WorkOrderNumberCounter DESC limit 1);

IF (WORKORDERNUMBERCNT = 100) THEN 
DELETE FROM WorkOrderNumber WHERE WorkOrderNumberCounter < WORKORDERNUMBERCNT;
END IF;

SET WORKORDERNUMBERCNT = WORKORDERNUMBERCNT+1;
SET WORKORDERNUMBERCRTED = CONCAT('TP-',(REPLACE(CURRENT_DATE(),'-','')),WORKORDERNUMBERCNT );
INSERT INTO WorkOrderNumber(WorkOrderNumberCounter) VALUES(WORKORDERNUMBERCNT);
UPDATE WorkOrderNumber Set WorkOrderNumberCreated =WORKORDERNUMBERCRTED WHERE WorkOrderNumberCounter = WORKORDERNUMBERCNT;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `usp_GetWorkOrderNumber` ()  BEGIN
SELECT WorkOrderNumberCreated FROM WorkOrderNumber ORDER BY WorkOrderNumberCounter DESC limit 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Account`
--

CREATE TABLE `Account` (
  `Id` int NOT NULL,
  `CustomerId` int DEFAULT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(256) NOT NULL,
  `Role` smallint NOT NULL DEFAULT '4',
  `Name` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `CreateDati` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateDati` datetime DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  `Email` varchar(100) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `Account`
--

INSERT INTO `Account` (`Id`, `CustomerId`, `Username`, `Password`, `Role`, `Name`, `LastName`, `CreateDati`, `UpdateDati`, `IsActive`, `Email`, `PhoneNumber`) VALUES
(1, 45, 'admins2', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 3, 'Admin', 'Seviye2', '2022-06-22 20:57:13', '2023-04-07 16:15:27', 1, 'a@a.com', '1543234123'),
(2, 45, 'admins3', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 2, 'Admin', 'Seviye3', '2022-12-14 07:05:51', '2022-12-14 07:05:31', 1, 'b@b.com', '1'),
(3, 45, 'adminIT', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 1, 'admin', 'IT', '2022-12-14 13:22:39', '2023-04-07 17:45:07', 1, 'admin@admin.com', '1');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Customer`
--

CREATE TABLE `Customer` (
  `CustomerId` int NOT NULL,
  `CompanyName` varchar(200) NOT NULL,
  `CompanyFullName` varchar(200) NOT NULL,
  `TaxNumber` varchar(200) NOT NULL,
  `TaxAdministration` varchar(200) NOT NULL,
  `Remark` varchar(200) NOT NULL,
  `CurrencyType` int NOT NULL,
  `PartitionType` int NOT NULL,
  `Status` int NOT NULL,
  `Maturity` int NOT NULL,
  `CompanyCode` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `Customer`
--

INSERT INTO `Customer` (`CustomerId`, `CompanyName`, `CompanyFullName`, `TaxNumber`, `TaxAdministration`, `Remark`, `CurrencyType`, `PartitionType`, `Status`, `Maturity`, `CompanyCode`) VALUES
(1, 'KARDEMİR KARABÜK DEMİR ÇELİK SANAYİ VE TİCARET A.Ş.', 'KARDEMİR', '505 005 5358', 'KARABÜK', '', 0, 0, 0, 0, '1201000'),
(2, 'MİPAR METAL SANAYİ TİCARET LTD.ŞTİ', 'MİPAR METAL', '621088868', 'ERTUGRULGAZİ', '', 0, 0, 0, 0, '1201001'),
(3, 'BAYAR ÇELİK SANAYİ ve TİC.LTD.ŞTİ.', 'BAYAR ÇELİK SANAYİ', '151 004 6055', 'MARMARA KURUMLAR', '', 0, 0, 0, 0, '1201002'),
(4, 'KDZ. EREĞLİ GÖKGÖZ MÜH. HİZ. MAKİNA TASARIM LTD. ŞTİ.', 'GÖKGÖZ MÜHENDİSLİK', '5410517098', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201003'),
(5, 'KELEŞOĞLU SAC TİC. NAK. SAN. LTD.ŞTİ.', 'KELEŞOĞLU SAC', '543 000 1668', 'KDZ EREĞLİ', 'NİYAZİ KELEŞ 0532 231 74 50', 0, 0, 0, 0, '1201004'),
(6, 'BİRLİK MAKİNA SANAYİ VE TİCARET LTD.ŞTİ.', 'BİRLİK MAKİNA', '1780027345', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201005'),
(7, 'NUR - İŞ METAL SANAYİ VE TİC. LTD.ŞTİ', 'NUR - İŞ', '6320412328', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201006'),
(8, 'BLS MAKİNA MÜHENDİSLİK TAAH.DIŞ TİCARET TUR. SAN. VE TİC. LTD.ŞTİ.', 'BLS MAKİNA', '178 061 3407', 'ULUÇINAR', '', 0, 0, 0, 0, '1201007'),
(9, 'YÜKSEL OTOMASYON LTD.ŞTİ', 'YÜKSEL OTOMASYON', '9950522103', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201008'),
(10, 'ER - TEKSAN MAKİNA METAL ve PLASTİK SANAYİ ve TİC. LTD.ŞTİ.', 'ER - TEKSAN', '3360088177', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201009'),
(11, 'ÇINAR BORU PROFİL  SANAYİ VE TİC.A.Ş', 'ÇINAR BORU PROFİL', '2510294868', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201010'),
(12, 'EREĞLİ DEMİR  VE ÇELİK FABRİKALARI T.A.Ş', 'ERDEMİR', '3520006426', 'KDZ EREĞLİ', 'MÜŞTERİ NUMARAMIZ 13401', 0, 0, 0, 0, '1201011'),
(13, 'İDARİ VE MALİ İŞLER DAİRE BAŞKANLIĞI  YÜKSEK ÖGRETİM KURUMLARI RECEP TAYYİP ERDOĞAN ÜNİVERSİTESİ.', 'RTE Üniversitesi', '735 059 1657', 'KAÇKAR', '', 0, 0, 0, 0, '1201012'),
(14, 'EREĞLİ BOSTAN METAL İNŞ. SAN. ve TİC.LTD.ŞTİ.', 'EREĞLİ BOSTAN METAL', '3520162676', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201013'),
(16, 'İLHAN DEMİR ÇELİK VE BORU PROFİL END. A.Ş', 'İLHAN DEMİR ÇELİK', '4720033391', 'DÖRTYOL', '', 0, 0, 0, 0, '1201015'),
(17, 'YUKON MAKİNE MÜHENDİSLİK LTD. STİ.                                                                      ', 'YUKON', '984 031 4478', 'KOZYATAGI', '', 0, 0, 0, 0, '1201016'),
(18, 'ASAŞ ALÜMİNYUM SANAYİ VE TİCARET A.Ş.', 'ASAŞ ALÜMİNYUM', '086 003 8375', 'BÜYÜK MÜKELLEFLER', 'FATURANIN  GÖNDÜRÜLECEĞİ  ADRES KIŞLA ALANI MEVKİİ KÜÇÜCEK BELDESİ AKAYAZI / SAKARYA ', 0, 0, 0, 0, '1201017'),
(19, 'NST METAL İMALAT ENDÜSTRİ SANAYİ VE TİCARET LTD.ŞTİ.', 'NST METAL', '6110491417', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '0'),
(20, 'MECALP MAKİNA MÜHENDİSLİK SANAYİ VE TİCARET ANONİM ŞİRKETİ', 'MECALP MAKİNA ', '0580179576', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201019'),
(21, 'YELKEN KALIP PENCERE - KAPI AKSESUARLARI ve METAL SAN.TİC.A.Ş', 'YELKEN KALIP PENCERE', '947 044 6329', 'MARMARA KURUMLAR', '', 0, 0, 0, 0, '1201020'),
(22, 'TOSÇELİK PROFİL VE SAC END. A.Ş', 'TOSÇELİK', '0860013021', 'ASIM GÜNDÜZ', '', 0, 0, 0, 0, '1201021'),
(23, 'FLOWTECH MAKINA SANAYI VE TiCARET LTD.STI.', 'FLOWTECH MAKINA', '388 0629 203', 'AKSARAY', '', 0, 0, 0, 0, '1201022'),
(24, 'GERD WOLFF MAKİNA SANAYİ VE TİCARET LTD.ŞTİ.', 'GERD WOLFF', '3940436605', 'DÜZCE', '', 0, 0, 0, 0, '1201023'),
(25, 'TAT METAL ÇELİK SANAYİ VE TİCARET  A.Ş.', 'TAT METAL', '8310440672', 'BÜYÜK MÜKELLEFLER', '', 0, 0, 0, 0, '1201024'),
(26, 'OFAR MAKİNE İNŞ. MALZ. METAL MÜT. GIDA SAN. TİC. LTD. ŞTİ.', 'OFAR MAKİNE', '634 009 1362', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201025'),
(27, 'OBAL ALÜMİNYUM SANAYİ VE TİCARET A.Ş.', 'OBAL ALÜMİNYUM', '6320416508', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201026'),
(28, 'EREĞLİ GEMİ İNŞAAT  SANAYİ TİC.A.Ş.', 'EREĞLİ GEMİ', '352 012 5298', 'BEYOĞLU', '', 0, 0, 0, 0, '1201027'),
(29, 'ERDEMİR ÇELİK SERVİS MERKEZİ SAN. ve TİC. A.Ş.', 'ERSEM', '3460185924', 'İLYASBEY', '', 0, 0, 0, 0, '1201028'),
(30, 'ALBARAKA A.Ş', 'ALBARAKA A.Ş', '', '', '', 0, 0, 0, 0, '0'),
(31, 'TÜBİTAK', 'TÜBİTAK', '', '', '', 0, 0, 0, 0, '1201028'),
(32, 'DERİNDERE TURİZM A.Ş.', 'DRD', '', '', '', 0, 0, 0, 0, '1201029'),
(33, 'TÜMEN MAKİNA - MUSTAFA TÜMEN', 'TÜMEN MAKİNA', '629 143 66276', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201030'),
(34, 'İRAN Hydro-Sanat-Sharif Co Ltd', 'Hydro Sanat Sharif - İran', '', '', '', 0, 0, 0, 0, '1201031'),
(35, '', '', '', '', '', 0, 0, 0, 0, '0'),
(36, 'ERDOĞAN METAL İNŞ.HİZ. OTOM.ORM.ÜR. SANAYİ VE TİCARET LTD.ŞTİ.', 'ERDOĞAN METAL', '3510291495', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201033'),
(37, 'Arcelor Mittal RZK ÇELİK SERVİS MERKEZİ SAN. VE TİC. A.Ş.', 'Arcelor Mittal RZK', '7350027599', 'BÜYÜK MÜKELLEFLER', ' - 0262 724 89 00\r\n', 0, 0, 0, 0, '1201034'),
(38, 'SH TEKNİK ÇÖZÜM MÜHENDİSLİK  SAN. TİC. LTD.ŞTİ.', 'SH TEKNİK ÇÖZÜM', '769 071 2426', 'HENDEK', '', 0, 0, 0, 0, '1201035'),
(39, 'ALCOS MAKİNA ELEKTRİK ELEKTRONİK NAK. İTH.İHR. SAN. VE TİC. LTD.ŞTİ', 'ALCOS', '0590287845', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201036'),
(40, 'YAHYAOĞLU ÇELİK DÖKÜM SAN. TİC. A.Ş.', 'YAHYAOĞLU ÇELİK DÖKÜM', '9280444419', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201038'),
(41, 'PAREKENDE SATIŞ', 'PAREKENDE SATIŞ', '086 003 8375', 'BÜYÜK MÜKELLEFLER', '', 0, 0, 0, 0, '1201039'),
(42, 'TEK MAK AGIR MAK.SAN. VE TİC.LTD.ŞTİ.', 'TEK MAK MAKİNE', '833 046 6154', 'ULUÇINAR', '', 0, 0, 0, 0, '1201040'),
(43, 'KMS ENDÜSTRİ MAKİNE METAL SAN.VE TİC. LTD. ŞTİ', 'KMS', '5640243031', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201041'),
(44, 'MTALL SAC MAKİNE  SANAYİ TİCARET  A.Ş', 'MTALL', '623 033 0505', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201042'),
(45, ' TEKNOPLAN MÜHENDİSLİK OTOMASYON MAKİNE BİLİŞİM SAN. ve TİC.LTD.ŞTİ', ' TEKNOPLAN', '', '', '', 0, 0, 0, 0, '1201043'),
(46, 'SAMİ SOYBAŞ DEMİR SANAYİ VE TİCARET A.Ş.', 'SOYBAŞLAR', '7420402402', 'ULUÇINAR', '', 0, 0, 0, 0, '1201044'),
(47, 'SİMETRİ TANK RAF SATIŞ VE TEŞH.EKİPM. METAL İNŞ.OTO. SAN. TİC. LTD.ŞTİ.', 'SİMETRİ TANK RAF', '770 039 6032', 'KÜÇÜKYALI', '', 0, 0, 0, 0, '1201045'),
(48, 'DİNAMİK RAF SİSTEMLERİ SAN. VE TİC.A.Ş.', 'DİNAMİK RAF', '2971014153', 'İKİTELLİ', '', 0, 0, 0, 0, '1201046'),
(49, 'BÜLENT ECEVİT ÜNİVERSİTESİ ALAPLI MESLEK YÜKSEK OKULU', 'BÜLENT ECEVİT ÜNİVERSİTESİ', '998 064 8812', 'UZUNMEHMET', '', 0, 0, 0, 0, '1201047'),
(50, 'AKBOR BORU SANAYİ VE TİCARET LTD. ŞTİ.', 'AKBOR', '0160492288', 'MALTEPE', '', 0, 0, 0, 0, '1201048'),
(51, 'İMZA ÇELİK SANAYİ VE TİCARET LTD.ŞTİ.', 'İMZA ÇELİK', '474 039 6418', 'KARABÜK', '', 0, 0, 0, 0, '1201049'),
(52, 'BAYIK DEMİR TİCARET VE SANAYİ LTD.ŞTİ.', 'BAYIK METAL', '153 002 3335', 'SELÇUK', '', 0, 0, 0, 0, '1201050'),
(53, 'İBRAHİM PAY', 'İBRAHİM PAY', 'KOCAELİ', '50644364518', 'Bir kereye mahsus araba satışı gerçekleştirildi.', 0, 0, 0, 0, '1201051'),
(54, 'KARABÜK ÜNİVERSİTESİ REKTÖRLÜĞÜ', 'KARABÜK ÜNİVERSİTESİ', '505 057 6205', 'KARABÜK', '', 0, 0, 0, 0, '1201052'),
(55, 'YAPI  KREDİ FİNANSAL KİRALAMA O.A.', 'YAPI  KREDİ', '937 001 7457', 'BOGAZİÇİ KURUMLAR', '', 0, 0, 0, 0, '1201053'),
(56, 'GÜNSA MAKİNA METAL SAN. ve TİC. LTD.ŞT.  Tavşanlı Yolu Oryap Karşısı                                         GEBZE / KOCAELİ', 'GÜNSA MAKİNA', '4380062002', 'ULUÇINAR', '', 0, 0, 0, 0, '1201054'),
(57, 'DORPEN PVC KAPI VE PENCERE AKSESUARLARI İMALAT GAYRİMENKUL PAZARLAMA SANAYİ TİCARET A.Ş.', 'DORPEN PVC KAPI', '310 063 5534', 'BEYLİKDÜZÜ', '', 0, 0, 0, 0, '1201055'),
(58, 'TİMKO MAKİNA İMALAT PAZARLAMA SAN. TİC. LTD. ŞTİ.', 'TİMKO MAKİNA', '8440457191', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201056'),
(59, 'TUSAŞ TÜRK HAVACILIK VE UZAY SANAYİ A.Ş.', 'TAİ - TUSAŞ', '8720013736', 'ANKARA KURUMLAR', '', 0, 0, 0, 0, '1201057'),
(60, ' KOYUNCU SAC METAL İNŞ. SAN. VE TİC. AŞ.', 'KOYUNCU SAC ', '5811381163', 'MEVLANA', '', 0, 0, 0, 0, '1201058'),
(61, 'KENAN DEMİRTÜRK', 'KENAN DEMİRTÜRK', '0', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201059'),
(62, 'ZEKİ KANTEMÜR', 'ZEKİ KANTEMÜR', '0', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201060'),
(63, 'OBAL PLASTİK SAN. VE TİC. A.Ş.', 'OBAL PLASTİK', '632 042 7496', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201061'),
(64, 'KARAYOLLARI 15. BÖLGE MÜDÜRLÜĞÜ', 'KARAYOLLARI 15. BÖLGE MD.', '523 002 8847', 'KASTAMONU', '', 0, 0, 0, 0, '1201062'),
(65, 'ÖZYAŞAR TEL VE GALVANİZLEME SAN. A.Ş. ', 'ÖZYAŞAR TEL', 'BOĞAZİÇİ KURUMLAR', '717 0022 641', '', 0, 0, 0, 0, '1201063'),
(66, 'ERBAA ÇELİK SERVİS LOJİSTİK SAN.LTD.ŞTİ.', 'ERBAA ÇELİK SERVİS', 'KDZ. EREĞLİ', '337 036 7130', 'KÖSELER MAH. SANAYİ CAD. NO:48\r\n', 0, 0, 0, 0, '1201064'),
(67, 'BORSAN CTP BORU SANAYİ VE TİCARET A.Ş.', 'BORSAN CTP BORU', '1800468682', 'BOR', '', 0, 0, 0, 0, '1201065'),
(68, 'İSMAİL KARADENİZ - KARADENİZ OTOMASYON VE MAKİNA', 'İSMAİL KARADENİZ', '655 002 79936', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201066'),
(69, 'NORM LLC', 'NORM LLC', '', 'KONUL TAHMAZOVA', '', 0, 0, 0, 0, '1201067'),
(70, 'KILIÇLAR MADENCİLİK SAN. TİC.LTD.ŞTİ.', 'KILIÇLAR MADENCİLİK', '554 003 1764', 'ALAPLI MAL MÜDÜRLÜĞÜ', '', 0, 0, 0, 0, '1201068'),
(71, 'ARMADA YAZILIM A.Ş', 'ARMADA YAZILIM', '079 036 3325', 'KARTAL', '', 0, 0, 0, 0, '1201069'),
(72, 'KOSGEB', 'KOSGEB', '0', '0', '', 0, 0, 0, 0, '1201070'),
(73, 'YMK MAKİNA İNŞAAT DEMİR ÇELİK KONTRÜKSİYON SANAYİ VE TİCARET LTD.ŞTİ.', 'YMK MAKİNA', '981 064 4380', 'ALAPLI MAL MÜDÜRLÜĞÜ', '', 0, 0, 0, 0, '1201071'),
(74, 'TEKGÜL METAL SAN. TİC. LTD. ŞTİ.', 'TEKGÜL METAL', '8340741928', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201072'),
(75, 'PİM MÜHENDİSLİK DEMİR ÇELİK ÜRÜN. MÜTEAHHİT VE HİZ.ORG.SAN. LTD.ŞTİ', 'PİM MÜHENDİSLİK', '7010 306 594', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201073'),
(76, 'ALPER FINDIK  VE GIDA SANAYİ TİC.LTD.ŞTİ', 'ALPER FINDIK ', '057 003 9184', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201074'),
(77, 'ETİ MADEN İŞLETMELERİ GENEL MÜDÜRLÜĞÜ - BİGADİÇ BOR İŞLETME MÜDÜRLÜĞÜ', 'ETİ MADEN İŞLETMELERİ', '381 007 1289', 'HİTİT', '', 0, 0, 0, 0, '1201075'),
(78, 'GÖKMETAL SAÇ SANAYİ VE DIŞ. TİC. A.Ş.', 'GÖKMETAL', '4040275175', 'ANADOLU KURUMLAR', '', 0, 0, 0, 0, '1201076'),
(79, 'BAYIK BORU PROFİL END. A.Ş', 'BAYIK BORU', '1530533877', 'SELÇUK', '', 0, 0, 0, 0, '1201077'),
(80, 'BURSAM NDT TIBBİ VE METALURJİ CİHAZLARI SAN. TİC.LTD.ŞTİ.', 'BURSAM NDT', '191 052 0288', 'ÇEKİRGE', '', 0, 0, 0, 0, '1201078'),
(81, 'ETASİS ELEKTRONİK TARTI ALETLERİ  VE SİSTEMLERİ SANAYİ VE TİC. A.Ş.', 'ETASİS ', '3810019085', 'ESKİŞEHİR', '', 0, 0, 0, 0, '1201079'),
(82, 'ABDULKADİR ÖZÇELİK', 'ABDULKADİR', '34594938050', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201080'),
(83, 'REINHOLD SCHMITT GMBH', 'REINHOLD SCHMITT GMBH', 'DE125129667', 'Register HRB2184', '', 0, 0, 0, 0, '1201081'),
(84, 'ÇAĞATAY METAL MAKİNA İNŞ. NAKL.SAN.TİC.LTD.ŞTİ.', 'ÇAĞATAY', '216 059 0906', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201082'),
(85, 'BARTIN ÇİMENTO SAN. VE TİC. A.Ş. EREĞLİ ÇİMENTO ŞUBESİ', 'BARTIN ÇİMENTO', '142 057 57 32', 'GAZİKENT', '', 0, 0, 0, 0, '1201083'),
(86, 'Teknika Teknik Taahh.Mak.İnş.Bilg.San. ve Tic.A.Ş', 'Teknika ', '836 010 9833', 'MALTEPE', '', 0, 0, 0, 0, '1201084'),
(87, 'SİEMENS SANAYİ ve TİCARET A.Ş', 'SİEMENS', '7700037454', 'BÜYÜK MÜKELLEFLER', '', 0, 0, 0, 0, '1201085'),
(88, 'GÖYMEN HADDECİLİK SAN. VE TİC. LTD. ŞTİ.', 'GÖYMEN', '410 070 3153', 'DÖRTYOL', '', 0, 0, 0, 0, '1201086'),
(89, 'ZONGULDAK YATIRIM FİLYOS ATEŞ TUĞLASI MAKİNE MADENCİLİK ENERJİ SAN.VE TİC.A.Ş.', 'TUĞLA FABRİKASI', '998 010 2116', 'ÇAYÇUMA', '', 0, 0, 0, 0, '1201087'),
(90, 'ARCELORMİTTAL AMBALAJ ÇELİĞİ SAN.TİC.A.Ş', 'ARCELORMİTTAL AMBALAJ', '773 004 3265', 'BÜYÜK MÜKELLEFLER', '', 0, 0, 0, 0, '1201088'),
(91, 'DTI TOZSUZLAŞTIRMA ve TEK.SAN.ve TİC. A.Ş.', 'DTI', '313 058 6535', 'KOCASİNAN', '', 0, 0, 0, 0, '1201089'),
(92, 'KOŞUNLAR DEMİR ÇELİK NAK.SAN. VE TİC.LTD. ŞTİ.', 'KOŞUNLAR', '581065 4531', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201090'),
(93, 'M.P.S. METAL PLSATİK SANAYİ CEMBER VE PAKETLEME SİS. İML. VE TİC.A.Ş.', 'M.P.S. METAL', '6090117486', 'İLYASBEY', '', 0, 0, 0, 0, '1201091'),
(94, 'MMZ ONUR BORU PROFİL ÜRETİM SAN. VE TİC.A.Ş.', 'MMZ ONUR BORU', '6220202081', 'BÜYÜK MÜKELLEFLER', '', 0, 0, 0, 0, '1201092'),
(95, 'POMİNİ TENOVA - TENOVA S.P.A', 'TENOVA ', '', '', '', 0, 0, 0, 0, '1201093'),
(96, 'EREĞLİ  ANKA İNŞAAT  METAL NAK.  PET. OTO.SAN. VE TİC.LTD.ŞTİ.', 'EREĞLİ  ANKA', '352 015 9223', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201094'),
(97, ' TATSAN ÇELİK KONSTRÜKSİYON İMALAT VE MONTAJ SAN TİC.LTD.ŞTİ.', ' TATSAN ÇELİK', '831 042 1198', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201095'),
(98, 'MY GRUP METAL GIDA İNŞ.TAAH.HİZ.NAK.İTH.İHR.SAN.TİC.LTD.ŞTİ.', 'MY GRUP', '626 037 3945', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201096'),
(99, ' 3-S MÜHENDİSLİK MÜŞAVİRLİK SAN ve TİC AŞ ', ' 3-S MÜHENDİSLİK', '0010753515', 'YENİKAPI', '', 0, 0, 0, 0, '1201097'),
(100, 'KARABÜK ÜNİVERSİTESİ  TEKNOLOJİ FAKÜLTESİ DEKANLIĞI', 'KARABÜK TEKNOLOJİ FAKÜLTESİ ', '505 058 3010', 'KARABÜK', '', 0, 0, 0, 0, '1201098'),
(101, 'KARABÜK ÜNİVERSİTESİ REKTÖRLÜĞÜ SAĞLIK KÜLTÜR VE SPOR DAİRESİ BAŞKANLIĞI', 'KARABÜK SAĞLIK DAİRESİ', '739 048 4619', 'KARABÜK', '', 0, 0, 0, 0, '1201099'),
(102, 'İSKENDERUN DEMİR VE ÇELİK A.Ş.', 'İSDEMİR', '8790009670', 'AKDENİZ', '', 0, 0, 0, 0, '1201100'),
(103, 'FEVZİ ÖZÇELİK', 'FEVZİ ÖZÇELİK', '', '', '', 0, 0, 0, 0, '1201101'),
(104, 'HİDROSER HİDROLİK PNÖMATİK EKİPMANLARI SAN. VE TİC. A.Ş.', 'HİDROSER', '462 004 6300', 'ATIŞALANI', '', 0, 0, 0, 0, '1201102'),
(105, 'ERCOM MAKİNE SAN. VE TİC.LTD.ŞTİ.', 'ERCOM MAKİNE ', ' 342 033 8648', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201103'),
(106, 'MKE BARUT FABRİKASI MÜDÜRLÜĞ', 'MAKİNE KİMYA', '0', '0', '', 0, 0, 0, 0, '1201104'),
(107, 'İLKNUR DÖNMEZ', 'İLKNUR DÖNMEZ', '605565487180', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201105'),
(108, 'SCHEUERLE Member of TII Group', 'SCHEUERLE', '', '', '', 0, 0, 0, 0, '1201106'),
(109, 'DRESSEL GmbH ', 'DRESSEL', 'DE 258 206 253', ' Local Court Hamm', '', 0, 0, 0, 0, '1201107'),
(110, 'GÖYMEN DEMİR ÇELİK İNŞ.SAN. VE TİC.LTD.ŞTİ.', 'GÖYMEN DEMİR ÇELİK', '410 004 6586', 'GAZİKENT', '', 0, 0, 0, 0, '1201108'),
(111, 'USLU ÇSM DEMİR ÇELİK A.Ş', 'USLU ÇSM', '895 041 2369', 'MENEMEN', '', 0, 0, 0, 0, '1201109'),
(112, 'PRİMETALS TEKNOLOJİ SANAYİ VE TİCARET A.Ş', 'PRİMETALS ', '769 064 2881', 'KARTAL', '', 0, 0, 0, 0, '1201110'),
(113, 'BCS ÇELİK BORU SAN.  A.Ş', 'BCS ÇELİK ', '1601216473', 'KOZYATAĞI', '', 0, 0, 0, 0, '1201111'),
(114, 'BOZANKAYA OTOMOTİV MAKİNA İMALAT İTHALAT VE İHRACAT A.Ş.', 'BOZANKAYA', '183 064 2976', 'SİNCAN', '', 0, 0, 0, 0, '1201112'),
(115, 'BAZ METAL - DİNDAR AYDIN', 'BAZ METAL', ' 63862014066', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201113'),
(116, 'USEL MAKİNA İNŞ. SAN. TİC.LTD.ŞTİ.', 'USEL MAKİNA', ' 8940302026', 'ANADOLU KURUMLAR', '', 0, 0, 0, 0, '1201114'),
(117, 'PDS PROFİL DİLME SAC MAKİNALARI SAN. VE DIŞ TİC.A.Ş', 'PDS PROFİL DİLME', '7230394971', 'TUZLA', '', 0, 0, 0, 0, '1201115'),
(118, 'ARKIN METAL SAN. VE TİC.LTD.ŞTİ.', 'ARKIN METAL', '079 002 3087', 'İKİTELLİ', '', 0, 0, 0, 0, '1201116'),
(119, 'ROTA MÜHENDİSLİK VE ENERJİ SİSTEMLERİ SAN. TİC.A.Ş', 'ROTA MÜHENDİSLİK', '7350841580', 'SARIGAZİ', '', 0, 0, 0, 0, '1201117'),
(120, 'ARK KAREMAYERLİ CEPHE ASENSÖRLERİ SAN.TİC.LTD.ŞTİ.', 'ARK KAREMAYERLİ ', '079 031 7822', 'OSTİM', '', 0, 0, 0, 0, '1201118'),
(121, 'HÜSEYİN ALTINKAYA', 'HÜSEYİN ALTINKAYA', ' 72793096126', 'KARABÜK', '', 0, 0, 0, 0, '1201119'),
(122, 'SERTAÇ AKÇAY', 'SERTAÇ AKÇAY', ' 26117586220', 'ALAPLI MAL MÜDÜRLÜĞÜ', '', 0, 0, 0, 0, '1201120'),
(123, 'GÜNEŞ TEL ÇEKME SAN.VE TİC.A.Ş.', 'GÜNEŞ TEL ', '4340 635 203', 'BÜYÜKÇEKMECE', '', 0, 0, 0, 0, '1201121'),
(124, 'ER - MEK  MAKİNA - KENAN ÇUBUK', 'ER - MEK  MAKİNA ', '48223855434', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201122'),
(125, 'SERTAŞ DEMİR ÇELİK MAK. ÇEMBER SAN. VE TİC.LTD.ŞTİ.', 'SERTAŞ DEMİR', '757 013 4399', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201123'),
(126, 'ATAKAŞ ÇELİK SANAYİ VE TİC.A.Ş', 'ATAKAŞ ÇELİK ', '095 030 3776', 'DÖRTYOL', '', 0, 0, 0, 0, '1201124'),
(127, 'DİMAS DÖVME ÇELİK MAKİNA MÜH. METAL SAN. VE TİCARET LTD.ŞTİ.', 'DİMAS DÖVME ÇELİK', '206 013 1583 ', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201125'),
(128, 'ZSR PATLAYICI SAN. A.Ş.', 'ZSR PATLAYICI', '940 005 7802', 'KURTDERELİ ', '', 0, 0, 0, 0, '1201126'),
(129, 'HİRA HAVLUPAN METAL MADENCİLİK SAN.TİC.LTD.ŞTİ.', 'HİRA HAVLUPAN', '4630505669', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201127'),
(130, 'AKKESE MÜHENDİSLİK SANAYİ VE TİCARET LTD. ŞTİ.', 'AKKESE GEMİ ', ' 030 048 6575', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201128'),
(131, 'BİLGE OTOMASYON SİSTEMLERİ SAN.VE TİC.LTD.ŞTİ', 'BİLGE OTOMASYON ', '1720369688', 'ŞEHİTKAMİL', '', 0, 0, 0, 0, '1201129'),
(132, 'MAS DEMİR ÇELİK SANAYİ VE TİC. A.Ş.', 'MAS DEMİR', '6130800707 ', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201130'),
(133, 'ÖZDEMİRLER İÇ VE DIŞ TİCARET LTD.ŞTİ.', 'ÖZDEMİRLER', '6810034542', 'UZUNMEHMET', '', 0, 0, 0, 0, '1201131'),
(134, 'EREĞLİ  ÜNALLAR METAL NAK. İNŞ. MÜT. DENİZCİLİK SAN. VE TİC.LTD.ŞTİ.', 'EREĞLİ  ÜNALLAR METAL ', '5410178490', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201132'),
(135, 'TEKMONT ENDÜSTRİ TESİSLERİ İMALAT VE MONTAJ SANAYİ TİCARET LİMİTED ŞİRKETİ', 'TEKMONT', '8360459520', 'KOZYATAĞI', '', 0, 0, 0, 0, '1201133'),
(136, 'KT ELEKTRİK ELEKTRONİK MÜH. HİZ. SAN. LTD.ŞTİ.', 'KT ELEKTRİK ELEKTRONİK ', '5900409168', 'YAKACIK', '', 0, 0, 0, 0, '1201134'),
(137, 'VİRTUS AMBALAJ ÇELİK SANAYİ VE TİCARET A.Ş.', 'VİRTUS AMBALAJ', '7730043265', 'BÜYÜK MÜKELLEFLER', '', 0, 0, 0, 0, '1201135'),
(138, 'KM MAKİNE MÜHENDİSLİK İNŞAAT TAAHHÜT İMALAT SANAYİ VE TİCERET LTD.ŞTİ.', 'KM MAKİNE', '5641044024', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201136'),
(139, 'CİHAN UÇA ', 'CİHAN UÇA ', '42830074042', 'BARTIN', '', 0, 0, 0, 0, '1201137'),
(140, 'YILDIZ ENTEGRE AĞAÇ SANAYİ VE TİCARET A.Ş.', 'YILDIZ ENTEGRE', '9650030021', 'TEPECİK', '', 0, 0, 0, 0, '1201138'),
(141, 'ANKA ELEKTRİK ELEKTRONİK OTOMASYON MEKANİK MAKİNA SAN.VE TİC.LTD.ŞTİ.', 'ANKA ELEKTRİK ', '0690285050', 'MİMARSİNAN', '', 0, 0, 0, 0, '1201139'),
(142, 'JOULE BAKIM HİZMETLERİ SAN.VE TİC. LTD. ŞTİ.', 'JOULE BAKIM ', '3360559147', 'KOZYATAĞI', '', 0, 0, 0, 0, '1201140'),
(143, 'ALAPLI FINDIK FABRİKASI', 'ALAPLI FINDIK FABRİKASI', '', '', '', 0, 0, 0, 0, '1201141'),
(144, 'ÇEMSAN DEMIR ÇELIK SANAYI VE TICARET LIMITED SIRKETI', 'ÇEMSAN DEMIR ÇELIK', '2420065437', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201142'),
(145, 'SAMSUN PROJE ULAŞIM İMAR İNŞAAT YAT.SAN. VE TİC. A.Ş.', 'SAMULAŞ', '7420410155', 'GAZİLER', '', 0, 0, 0, 0, '1201143'),
(146, 'ÜNALLAR METAL İNŞ. SAN. VE TİC.  A.Ş.', 'ÜNALLAR METAL İNŞ. SAN. VE TİC.  A.Ş.', '9120244893', 'SİNCAN', '', 0, 0, 0, 0, '1201144'),
(147, 'SAMSUN ÇİVİ METAL SAN. VE TİC. A.Ş.', 'SAMSUN ÇİVİ METAL', '7420440281', 'OSMANİYE', '', 0, 0, 0, 0, '1201145'),
(148, 'GL MAKİNA İML. MOTAJ SAN. TİC.LTD.ŞTİ.', 'GL MAKİNA', '3960602041', 'sincan', '', 0, 0, 0, 0, '1201146'),
(149, 'ÖZRAY ASANSÖR SAN TİC AŞ', 'ÖZRAY ASANSÖR', '7040383818', 'TORBALI', '', 0, 0, 0, 0, '1201147'),
(150, 'KUVEYT TÜRK KATILIM BANKASI A.Ş', 'KUVEYT TÜRK', '6000026814', 'BÜYÜKMÜKELLEFLER', '', 0, 0, 0, 0, '1201148'),
(151, 'SAVÇELİK MAKİNA SAN. VE TİC.LTD.ŞTİ.', 'SAVÇELİK MAKİNA ', '7530904497', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201149'),
(152, 'ELEMENTAL GERİ DÖNÜŞÜM ANONİM ŞİRKETİ', 'ELEMENTAL ', '3810451269', 'Y.GALİP', '', 0, 0, 0, 0, '1201150'),
(153, 'ŞADİLER DEMİR ÇELİK SAN. VE TİC. LTD. ŞTİ', 'ŞADİLER DEMİR ', '7890534055', 'DÖRTYOL', '', 0, 0, 0, 0, '1201151'),
(154, 'HUZUR MAKİNA - HALİT  YENER ', 'HUZUR MAKİNA - HALİT  YENER ', '18041855114', 'ALAPLI MALMÜDRLÜĞÜ', '', 0, 0, 0, 0, '1201152'),
(155, 'BİRUNİ ECZANESİ', 'BİRUNİ ECZANESİ', '', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201153'),
(156, 'JE ENDÜSTRİ TESİSLERİ İMALAT MONTAJ BAKIM VE MÜHENDİSLİK SAN.TİC.LTD.ŞTİ.', 'JE ENDÜSTRİ ', '4841913302', 'KOZYATAĞI', '', 0, 0, 0, 0, '1201154'),
(157, 'EREĞLİ DİLME SANAYİ VE TİCARET A.Ş', 'EREĞLİ DİLME', '3520051375', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201155'),
(158, 'TÜRKİYE TAŞKÖMÜRÜ KURUMU GENEL MÜDÜRLÜĞÜ', 'TÜRKİYE TAŞKÖMÜRÜ KURUMU ', '8150034586', 'KARAELMAS', '', 0, 0, 0, 0, '1201156'),
(159, 'HATTAT ENERJİ VE MADEN TİC.A.Ş.', 'HATTAT ENERJİ ', '4590032545', 'BOĞAZİÇİKURUMLAR', '', 0, 0, 0, 0, '1201157'),
(160, 'ELZ MAKİNE NAKLİYE İNŞAAT SAN.VE TİC.LTD.ŞTİ', 'ELZ MAKİNE ', '3330742537', 'YÜREĞİR', '', 0, 0, 0, 0, '1201158'),
(161, 'DETAŞ SAÇ PROFİL DEMİR ÇELİK SANAYİ VE TİCARET ANONİM ŞİRKETİ', 'DETAŞ SAÇ PROFİL', '2930159135', 'BEYKOZ', '', 0, 0, 0, 0, '1201159'),
(162, 'COMESA S.R.L', 'COMESA S.R.L', '', '', '', 0, 0, 0, 0, '1201160'),
(163, 'ÖZGÜN MAKİNA İMALAT ve TİCARET HAKAN MUTLU- SEVİM AYKENAR', 'ÖZGÜN MAKİNA İMALAT ve TİCARET HAKAN MUTLU- SEVİM AYKENAR', '6260256756', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201161'),
(164, 'MERVE MELİKEÖĞRENCİ YURDU TURZ. TAR. İHR.İTH.SAN. VE TİC.LTD.ŞTİ.', 'MERVE MELİKEÖĞRENCİ YURDU', '6190587583', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201162'),
(165, 'PROTON OTOMASYON ELEKTRİK MAKİNA İNŞ.TAAH. SAN.VE TİC.LTD.ŞTİ', 'PROTON OTOMASYON ', '7330320997', 'GÖKPINAR', '', 0, 0, 0, 0, '1201163'),
(166, 'MİLTİM İNŞ. SAN. VE TİC. LTD. ŞTİ.', 'MİLTİM ', '6230309546', 'CUMHURİYET', '', 0, 0, 0, 0, '1201164'),
(167, 'SİMBA END.OTOMASYON VE MÜH.HİZ.SAN.TİC.LTD.ŞTİ.', 'SİMBA END', '7700423721', 'YAKACIK', '', 0, 0, 0, 0, '1201165'),
(168, 'HAS METAL TİCARET VE SANAYİ  A.Ş ', 'HAS METAL ', '4580568537', 'ANADOLU KURUMLAR', 'Organize Sanayi Bölgesi Mh. 8. Sk. Fabrika binası No:13/2', 0, 0, 0, 0, '1201166'),
(169, 'KAYSERİ ULAŞIM TRUZİM İNŞAAT TAAHHÜT PROJE MÜŞAVİRLİK TELEKOMÜNİKASYON SAN. VE TİC. A.Ş', 'KAYSERİ ULAŞIM', '5400382777', 'MİMAR SİNAN', '', 0, 0, 0, 0, '1201167'),
(170, 'ATASİM ENDÜSTRİYEL OTOMASYON SİSTEMLERİ SAN. TİC.LTD.ŞTİ.', 'ATASİM ENDÜSTRİYEL ', '0980504402', 'MESİR', '', 0, 0, 0, 0, '1201168'),
(171, 'NORM TEKNİK MAKİNA İNŞAAT SAN. VE TİC. LTD. ŞTİ', 'NORM TEKNİK MAKİNA', '6310710584', 'EGE', '', 0, 0, 0, 0, '1201169'),
(172, 'YAPPLUS MÜHENDİSLİK ELEKTRİK ELEKTRONİK OTOMASYON İTH. İHR. SAN. VE TİC.LTD.ŞTİ.', 'YAPPLUS MÜHENDİSLİK', '9371405427', 'KAĞITHANE', '', 0, 0, 0, 0, '1201170'),
(173, 'SİSTEMPARK ARITMA  VE ÇEVRE TEKNOLOJİLERİ MÜH. VE DAN.HİZ. İTH.İHR. İNŞ.SAN.TİC.LTD.ŞTİ.', 'SİSTEMPARK ARITMA  ', '7710333210', 'ÇEKİRGE', '', 0, 0, 0, 0, '1201171'),
(174, 'BİRİM MAKİNA SAN. VE TİC.LTD.ŞTİ', 'BİRİM MAKİNA', '1780714389', 'KEMALPAŞA', '', 0, 0, 0, 0, '1201172'),
(175, 'ŞAVAŞ KOLAY - ÖZÇEVRE TEMİZLİK ÜRÜN.. VE TAŞIMACILIK HİZM.', 'ŞAVAŞ KOLAY - ÖZÇEVRE TEMİZLİK ÜRÜN.. VE TAŞIMACILIK HİZM.', '5750343109', 'DÜZCE', '', 0, 0, 0, 0, '1201173'),
(176, 'PROFESYONEL PERSONEL HİZMETLERİ A.Ş', 'PROFESYONEL PERSONEL ', '7330386275', 'MECİDİYEKÖY', '', 0, 0, 0, 0, '1201174'),
(177, 'BUCHER HİDROLİK SİSTEMLERİ TİCARET LTD.ŞTİ.', 'BUCHER HİDROLİK SİSTEMLERİ TİCARET LTD.ŞTİ.', '1870100996', 'GÜNEŞLİ', '', 0, 0, 0, 0, '1201175'),
(178, 'ORTAÇLAR ELEKTRİK SANAYİ VE TİCARET LİMİTED ŞİRKETİ', 'ORTAÇLAR ELEKTRİK SANAYİ VE TİCARET LİMİTED ŞİRKETİ', '6470363102', 'BÜYÜKÇEKMECE', '', 0, 0, 0, 0, '1201176'),
(179, 'PORT KARGO VE LOJİSTİK A.Ş.', 'PORT KARGO VE LOJİSTİK A.Ş.', '7321640262', 'ÜSKÜDAR', '', 0, 0, 0, 0, '1201177'),
(180, 'AYKUT ÇUR', 'AYKUT ÇUR', '47476836634', 'ŞEHİTLİK', '', 0, 0, 0, 0, '1201178'),
(181, 'METPRO MAKİNA - HAMDİ GENÇ', 'METPRO MAKİNA - HAMDİ GENÇ', '66046261270', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201179'),
(182, 'PASTEL MAKİNA SANAYİ VE TİCARET ANONİM ŞİRKETİ', 'PASTEL MAKİNA ', '7230442820', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201180'),
(183, 'ARPACI ELEKTRİK ÜRETİM VE TİC.A.Ş', 'ARPACI ELEKTRİK ', '0800352080', 'BEYOĞLU', '', 0, 0, 0, 0, '1201181'),
(184, 'GAZİ METAL MAMÜLLERİ SANAYİ SANAYİ VE TİC. A.Ş.', 'GAZİ METAL', '3890547537', 'İLYASBEY', '', 0, 0, 0, 0, '1201182'),
(185, 'GÖKERPLAST PLASTİK SAN. VE TİC. LTD. ŞTİ.', 'GÖKERPLAST PLASTİK', '4020014789', 'GÖZTEPE', '', 0, 0, 0, 0, '1201183'),
(186, 'TANIKLAR METAL SANAYİ VE TİCARET LTD.ŞTİ.', 'TANIKLAR METAL', '8200690794', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201184'),
(187, 'GALVA METAL SAN VE TİC A.Ş.', 'GALVA METAL SAN VE TİC A.Ş.', '3881603709', 'ALEMDAR', '', 0, 0, 0, 0, '1201185'),
(188, 'HEMA ENDÜSTRİ A.Ş.', 'HEMA ENDÜSTRİ', '4610031137', 'BÜYÜK MÜKELLEFLER', '', 0, 0, 0, 0, '1201186'),
(189, 'TOSYALI DEMİR ÇELİK SANAYİ ANONİM ŞİRKETİ', 'TOSYALI DEMİR ÇELİK ', '8580043176', 'ASIM GÜNDÜZ', '', 0, 0, 0, 0, '1201187'),
(190, 'ANIT KONTROL SİSİ. ROBOT MAK. OTOM.SAN.TİC. ÇLTD.ŞTİ.', 'ANIT KONTROL', '0690456505', 'TEPECİK', '', 0, 0, 0, 0, '1201188'),
(191, 'BAHAR MAKİNE - MUSTAFA BAHAR', 'BAHAR MAKİNE - MUSTAFA BAHAR', '11439006846', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201189'),
(192, 'DANIELİ GERMANY GmbH', '', '5134/5756/0743', '', '', 0, 0, 0, 0, '1201190'),
(193, 'TUNCAY UYSAL - NET İNŞAAT', 'TUNCAY UYSAL - NET İNŞAAT', '9000331603', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201191'),
(194, 'ADV TEKNOLOJİ BİLİŞİM TİCARET A.Ş.', 'ADV TEKNOLOJİ BİLİŞİM TİCARET A.Ş.', '0081625992', 'DOĞANBEY', '', 0, 0, 0, 0, '1201192'),
(195, 'DANİELİ GERMANY Gmbh ', 'DANİELİ GERMANY Gmbh ', '22222222222', '', '', 0, 0, 0, 0, '1201193'),
(196, 'AZİ MAKİNA MONTAJ İMALAT İHRACAT İTHALAT SANAYİ VE TİCARET LİMİTED ŞİRKETİ', 'AZİ MAKİNA ', '1271107825', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201194'),
(197, 'BK KUMALAMA VE BOYA - BURAK BÜYÜK', 'BK KUMALAMA VE BOYA - BURAK BÜYÜK', '11611684558', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201195'),
(198, 'ÜNİVERSAL BIÇAK MAK.HASSAS İŞLEME SAN.TİC.LTD.ŞTİ.', 'ÜNİVERSAL BIÇAK', '9130445203', 'DAVUTPAŞA', '', 0, 0, 0, 0, '1201196'),
(199, 'TOPOCROM SYSTEMS AG', 'TOPOCROM SYSTEMS AG', '', '', '', 0, 0, 0, 0, '1201197'),
(200, 'PAPOLOTES FELİZARDO ELİZONDO GUAJARDO SA D CV', 'PAPOLOTES ', '', '', '', 0, 0, 0, 0, '1201198'),
(201, 'MUSTAFA  TEMEL ', 'MUSTAFA  TEMEL ', '22466608262', 'İLYASBEY', '', 0, 0, 0, 0, '1201199'),
(202, 'ERLER SAÇ METAL ANONİM ŞİRKETİ', 'ERLER SAÇ METAL ', '3640521143', 'SELÇUK', '', 0, 0, 0, 0, '1201200'),
(203, 'ERHAN ÇETİNKAYA', 'ERHAN ÇETİNKAYA', '2460341399', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201201'),
(204, 'BORSAC METAL SANAYİ İÇ VE DIŞ TİC. A.Ş.', 'BORSAC METAL ', '1790624481', 'KOZYATAĞI', '', 0, 0, 0, 0, '1201202'),
(205, 'MESTAŞ METAL MAM.MAK.SAN.VE TİC.A.Ş.', 'MESTAŞ METAL MAM.MAK.SAN.VE TİC.A.Ş.', '6190021347', 'AKYAZI', '', 0, 0, 0, 0, '1201203'),
(206, 'ARDADEMİRÇELİK METAL YAPI İNŞAAT TAAHHÜT TAŞIMACILIK SANAYİ VE TİCARET LİMİTED ŞİRKETİ	', 'ARDADEMİRÇELİK METAL', '0730433099', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201204'),
(207, 'AKYILDIZ OTOMASYON SAN. VE TİC. LTD. ŞTİ.	', 'AKYILDIZ OTOMASYON ', '0440485961', '', '', 0, 0, 0, 0, '1201205'),
(208, 'BORSAN PROFİL BORU DEMİR ÇELİK SAN. TİC. LTD. ŞTİ.', 'BORSAN PROFİL', '1800406932', 'DÖRTYOL', '', 0, 0, 0, 0, '1201206'),
(209, 'KDZ EREĞLİ YILDIZ DEMİRÇELİK ÜRÜNLERİ NAK.İNŞ. SAN. VE TİC.LTD.ŞTİ.', 'KDZ EREĞLİ YILDIZ DEMİRÇELİK ', '5410307476', 'KDZ EREĞLİ', '', 0, 0, 0, 0, '1201207');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `CustomerOrder`
--

CREATE TABLE `CustomerOrder` (
  `CustomerOrderId` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CustomerId` int NOT NULL,
  `CustomerOrderStatusId` int NOT NULL,
  `OrderNumber` varchar(15) NOT NULL,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `Remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `CustomerOrder`
--

INSERT INTO `CustomerOrder` (`CustomerOrderId`, `CustomerId`, `CustomerOrderStatusId`, `OrderNumber`, `Name`, `Remark`, `CreatedDate`, `UpdatedDate`) VALUES
('478f1bd2-1b8b-450c-86e9-4b487b5f57e3', 2, 11, 'TP0003', 'Rulo Sertlik Ayarı', 'Rulo Sertlik Ayarı', '2023-04-17 09:35:12', '2023-04-17 10:00:49'),
('54d48b43-8642-422d-81d8-e48448e52e9a', 1, 11, 'TP-2023041227', 'Doğal Gaz Test Siparişi', 'Doğal Gaz Test Siparişi', '2023-04-15 14:49:19', '2023-04-17 09:12:48');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `CustomerOrderItem`
--

CREATE TABLE `CustomerOrderItem` (
  `CustomerOrderItemId` char(36) NOT NULL,
  `CustomerOrderId` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CustomerOrderItemStatusId` int NOT NULL,
  `CustomerId` int NOT NULL,
  `TreatmentTypeId` int NOT NULL,
  `MaterialQualityId` int DEFAULT NULL,
  `MaterialQualityUnknown` varchar(35) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `DrawingNo` varchar(30) NOT NULL,
  `PieceNumber` int NOT NULL,
  `PieceWeight` int NOT NULL,
  `Width` int NOT NULL,
  `Height` int NOT NULL,
  `Depth` int NOT NULL,
  `Hrc` int NOT NULL,
  `Hb` int NOT NULL,
  `CreateDate` date NOT NULL,
  `RegistrationDate` date DEFAULT NULL,
  `RequestDate` date DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `FinishDate` date DEFAULT NULL,
  `ShippingDate` date DEFAULT NULL,
  `Remark` varchar(200) NOT NULL,
  `FilePath` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `CustomerOrderItem`
--

INSERT INTO `CustomerOrderItem` (`CustomerOrderItemId`, `CustomerOrderId`, `CustomerOrderItemStatusId`, `CustomerId`, `TreatmentTypeId`, `MaterialQualityId`, `MaterialQualityUnknown`, `Name`, `DrawingNo`, `PieceNumber`, `PieceWeight`, `Width`, `Height`, `Depth`, `Hrc`, `Hb`, `CreateDate`, `RegistrationDate`, `RequestDate`, `StartDate`, `FinishDate`, `ShippingDate`, `Remark`, `FilePath`) VALUES
('4efa9b81-f351-46c2-aed1-4422e815a7e0', '54d48b43-8642-422d-81d8-e48448e52e9a', 20, 1, 1, 1, NULL, 'Doğal Gaz Test Siparişi', 'TP9423', 123, 213, 123, 123, 123, 123, 123, '2023-04-15', '2023-04-15', '2023-04-15', '2023-04-15 11:48:50', '2023-04-15', '2023-04-15', 'Doğal Gaz Test Siparişi', 'C:\\Users\\berat\\Desktop\\tphert\\TpHetr\\TpHetr.L3.WebAPI\\wwwroot//pdfs\\fbaf6861-fd25-4124-9156-44014adf083d.xlsx'),
('TP2003', '478f1bd2-1b8b-450c-86e9-4b487b5f57e3', 20, 130, 4, 4, NULL, 'Rulo Gerilim Giderme', '321', 1, 2100, 500, 500, 2000, 70, 70, '2023-01-05', '2023-01-05', '2023-01-05', '2023-01-05 00:00:00', '2023-01-05', '2023-01-05', 'Rulo Gerilim Giderme', NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `CustomerOrderItemStatus`
--

CREATE TABLE `CustomerOrderItemStatus` (
  `CustomerOrderItemStatusId` int NOT NULL,
  `Name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `CustomerOrderItemStatus`
--

INSERT INTO `CustomerOrderItemStatus` (`CustomerOrderItemStatusId`, `Name`) VALUES
(10, 'Taslak'),
(20, 'Onaylanmış'),
(21, 'Isıl İşlemde'),
(30, 'İptal Edilmiş'),
(40, 'Tamamlandı'),
(50, 'Sevkediliyor'),
(60, 'Kapandı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `CustomerOrderNumber`
--

CREATE TABLE `CustomerOrderNumber` (
  `CustomerOrderNumberId` int NOT NULL,
  `CustomerOrderNumberCounter` int DEFAULT NULL,
  `CustomerOrderNumberCreated` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `CustomerOrderNumber`
--

INSERT INTO `CustomerOrderNumber` (`CustomerOrderNumberId`, `CustomerOrderNumberCounter`, `CustomerOrderNumberCreated`) VALUES
(1, 1, 'TP-932412'),
(2, 3, 'TP-202304103'),
(3, 5, 'TP-202304105'),
(4, 7, 'TP-202304107'),
(5, 9, 'TP-202304119'),
(6, 11, 'TP-2023041111'),
(7, 13, 'TP-2023041113'),
(8, 15, 'TP-2023041115'),
(9, 17, 'TP-2023041117'),
(10, 19, 'TP-2023041119'),
(11, 21, 'TP-2023041121'),
(12, 23, 'TP-2023041123'),
(13, 25, 'TP-2023041125'),
(14, 27, 'TP-2023041227'),
(15, 29, 'TP-2023041529'),
(16, 31, 'TP-2023041731');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `CustomerOrderStatus`
--

CREATE TABLE `CustomerOrderStatus` (
  `CustomerOrderStatusId` int NOT NULL,
  `Name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `CustomerOrderStatus`
--

INSERT INTO `CustomerOrderStatus` (`CustomerOrderStatusId`, `Name`) VALUES
(10, 'Taslak'),
(11, 'Sipariş Oluşturuldu'),
(20, 'Onaylanmış'),
(21, 'Isıl İşlemde'),
(30, 'İptal Edildi'),
(40, 'Tamamlandı'),
(50, 'Sevkediliyor'),
(60, 'Kapandı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Furnance`
--

CREATE TABLE `Furnance` (
  `FurnanceId` int NOT NULL,
  `Name` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `Furnance`
--

INSERT INTO `Furnance` (`FurnanceId`, `Name`) VALUES
(1, 'Doğalgaz Fırını'),
(2, 'Elektrik Fırını'),
(3, 'İndüksiyon Fırını');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Log`
--

CREATE TABLE `Log` (
  `id` int NOT NULL,
  `LogDescription` varchar(10000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `LogMethod` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `LogStatusCode` int DEFAULT NULL,
  `LogPath` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `MachineName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `Log`
--

INSERT INTO `Log` (`id`, `LogDescription`, `LogMethod`, `LogStatusCode`, `LogPath`, `MachineName`, `CreatedDate`) VALUES
(1, 'Sipariş Silindi [fcde67cf-0b28-48dd-bf4e-2a88eb7a80ce]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-06 15:38:31'),
(2, 'Sipariş Silindi [a5315991-f1b2-42c4-91f8-53892fe65f83]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-06 15:38:45'),
(3, 'One or more errors occurred. (\'<\' is an invalid start of a value. Path: $ | LineNumber: 0 | BytePositionInLine: 0.)', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-06 15:39:40'),
(4, 'Reçete Eklendi [TpHetr.L3.DAL.Receipt]', 'POST', 200, '/api/receipt/AddReceipt', 'DESKTOP-6I0AS7K', '2023-04-06 15:39:59'),
(5, 'Reçete Silindi [54]', 'POST', 200, '/api/receipt/DeleteReceipt', 'DESKTOP-6I0AS7K', '2023-04-06 15:40:01'),
(6, 'One or more errors occurred. (\'<\' is an invalid start of a value. Path: $ | LineNumber: 0 | BytePositionInLine: 0.)', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-06 15:41:28'),
(7, 'İş Emri Eklendi [TpHetr.L3.DAL.WorkOrder]', 'POST', 200, '/api/workorder/AddWorkOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:51:23'),
(8, 'İş Emri Silindi [104]', 'POST', 200, '/api/workOrder/DeleteWorkOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:51:27'),
(9, 'İş Emri Eklendi [TpHetr.L3.DAL.WorkOrder]', 'POST', 200, '/api/workorder/AddWorkOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:52:00'),
(10, 'İş Emri Silindi [105]', 'POST', 200, '/api/workOrder/DeleteWorkOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:52:03'),
(11, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:52:57'),
(12, 'Sipariş Alt Kalemi Eklendi [TpHetr.L3.DAL.CustomerOrderItem]', 'POST', 200, '/api/customerOrderItem/AddCustomerOrderItem', 'WIN-0I9TMG3F88B', '2023-04-06 15:53:27'),
(13, 'Sipariş Güncellendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:53:32'),
(14, 'One or more errors occurred. (\'<\' is an invalid start of a value. Path: $ | LineNumber: 0 | BytePositionInLine: 0.)', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'WIN-0I9TMG3F88B', '2023-04-06 15:53:52'),
(15, 'İş Emiri Alt Kalemi Eklendi [TpHetr.L3.DAL.WorkOrderItem]', 'POST', 200, '/api/workOrderItem/AddWorkOrderItem', 'WIN-0I9TMG3F88B', '2023-04-06 15:54:19'),
(16, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:55:46'),
(17, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:55:54'),
(18, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:56:03'),
(19, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:56:14'),
(20, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:56:23'),
(21, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:56:54'),
(22, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:57:03'),
(23, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:57:13'),
(24, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:57:26'),
(25, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:57:36'),
(26, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:57:45'),
(27, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:57:53'),
(28, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:58:06'),
(29, 'Sipariş Eklendi [TpHetr.L3.DAL.CustomerOrder]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-06 15:58:15'),
(30, 'Unexpected end of request content.', 'POST', 200, '/api/workOrder/GetWorkOrderWithDetailList', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:04'),
(31, 'Sipariş Silindi [ 4f5d1495-9cac-48fd-bc9d-de844bfddf28 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:22'),
(32, 'Sipariş Silindi [ 87c478d9-30d1-4e57-99be-e830bf0d5382 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:26'),
(33, 'Sipariş Silindi [ 593fd31a-6d88-4f30-aa92-f60c962a435a ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:30'),
(34, 'Sipariş Silindi [ d24b45d1-4d4f-48fe-ad77-47312a465aa8 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:33'),
(35, 'Sipariş Silindi [ 75d360ff-4cb9-4512-aa0a-0ff2ed302292 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:36'),
(36, 'Sipariş Silindi [ d49d21ad-1424-4a30-88f0-5029b94014dd ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:39'),
(37, 'Sipariş Silindi [ 95f2cd43-6c96-4052-af75-7224a4d2fc95 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:31:43'),
(38, 'Sipariş Silindi [ 2ad2b0d6-8faa-403b-84ec-ab1fe0925cd9 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:32:16'),
(39, 'Sipariş Silindi [ b8ca2f67-c118-4caf-8428-d587e9cebb9e ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:32:19'),
(40, 'Sipariş Silindi [ 46c8af52-ba63-45e8-979a-c2a8ee86eee9 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:32:22'),
(41, 'Sipariş Silindi [ 73cf0fd6-db11-4d27-9d78-88b6d4c1a677 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:32:24'),
(42, 'Sipariş Silindi [ e5cbc888-0b24-4c9a-a05a-d3364ba9c85f ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:32:28'),
(43, 'Sipariş Silindi [ 072c390b-2bac-485f-ad1c-dc524d13c0bb ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:32:32'),
(44, 'Sipariş Silindi [ ea26be00-7314-4a9d-9bcc-2dc6c31777dc ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:32:47'),
(45, 'Sipariş Silindi [ ce411fc6-4c3a-4be2-8bcb-69ad7202ddf4 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:33:28'),
(46, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:34:36'),
(47, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-07 08:34:55'),
(48, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 08:50:19'),
(49, 'Seviye-2 İş Emir Durumu Güncellendi [TpHetr.L3.Core.Models.Level2ToLevel3]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 08:50:19'),
(50, 'Seviye-2 Den İş Emri Güncellendi [TpHetr.L3.Core.Models.L2ToL3WorkOrderData]', 'POST', 200, '/api/l2tol3/UpdateL2WorkOrderData', 'WIN-0I9TMG3F88B', '2023-04-07 08:50:34'),
(51, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 08:50:35'),
(52, 'Seviye-2 İş Emir Durumu Güncellendi [TpHetr.L3.Core.Models.Level2ToLevel3]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 08:50:35'),
(53, 'Specified argument was out of the range of valid values. (Parameter \'index\')', 'GET', 200, '/api/customer/getcustomerlistwithaccounting', 'DESKTOP-6I0AS7K', '2023-04-07 09:13:04'),
(54, 'Unexpected end of request content.', 'POST', 200, '/api/workOrder/GetWorkOrderWithDetailList', 'DESKTOP-6I0AS7K', '2023-04-07 09:36:58'),
(55, 'The required column \'WorkOrderNumberId\' was not present in the results of a \'FromSql\' operation.', 'GET', 200, '/api/workOrder/GetWorkOrderNumber', 'DESKTOP-6I0AS7K', '2023-04-07 10:03:07'),
(56, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 11:56:24'),
(57, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 11:56:38'),
(58, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 11:57:27'),
(59, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 11:57:52'),
(60, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 11:58:50'),
(61, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 12:47:44'),
(62, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 12:48:29'),
(63, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Account ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 12:50:09'),
(64, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 12:52:58'),
(65, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:02:43'),
(66, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:05:55'),
(67, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:06:52'),
(68, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:12:24'),
(69, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:12:54'),
(70, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:18:05'),
(71, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:18:55'),
(72, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:19:04'),
(73, 'Kullanıcı Eklendi [ TpHetr.L3.DAL.Account ]', 'POST', 200, '/api/Account/CreateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:33:23'),
(74, 'An error occurred while updating the entries. See the inner exception for details.', 'POST', 200, '/api/Account/CreateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:33:24'),
(75, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:37:18'),
(76, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:43:18'),
(77, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:43:36'),
(78, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:43:43'),
(79, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:51:49'),
(80, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:52:16'),
(81, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:55:03'),
(82, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:56:09'),
(83, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:56:18'),
(84, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:58:32'),
(85, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:59:08'),
(86, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 13:59:33'),
(87, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 14:02:31'),
(88, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 14:02:37'),
(89, 'One or more errors occurred. (\'<\' is an invalid start of a value. Path: $ | LineNumber: 0 | BytePositionInLine: 0.)', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-07 14:36:16'),
(90, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 14:53:17'),
(91, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-07 14:54:07'),
(92, 'Reçete Güncellendi [ TpHetr.L3.DAL.Receipt ]', 'POST', 200, '/api/receipt/UpdateReceipt', 'DESKTOP-6I0AS7K', '2023-04-07 15:26:57'),
(93, 'Reçete Güncellendi [ TpHetr.L3.DAL.Receipt ]', 'POST', 200, '/api/receipt/UpdateReceipt', 'DESKTOP-6I0AS7K', '2023-04-07 15:27:02'),
(94, 'One or more errors occurred. (An exception was thrown while attempting to evaluate the LINQ query parameter expression \'value(TpHetr.L3.BLL.Managers.ReceiptManager+<>c__DisplayClass17_0).workOrderItem.WorkOrder.ReceiptId\'. See the inner exception for more information.)', 'GET', 200, '/api/receipt/GetReceiptDataByCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-07 15:33:57'),
(95, 'One or more errors occurred. (An exception was thrown while attempting to evaluate the LINQ query parameter expression \'value(TpHetr.L3.BLL.Managers.ReceiptManager+<>c__DisplayClass17_0).workOrderItem.WorkOrder.ReceiptId\'. See the inner exception for more information.)', 'GET', 200, '/api/receipt/GetReceiptDataByCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-07 15:35:11'),
(96, 'One or more errors occurred. (An exception was thrown while attempting to evaluate the LINQ query parameter expression \'value(TpHetr.L3.BLL.Managers.ReceiptManager+<>c__DisplayClass17_0).workOrderItem.WorkOrder.ReceiptId\'. See the inner exception for more information.)', 'GET', 200, '/api/receipt/GetReceiptDataByCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-07 15:36:23'),
(97, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 16:15:28'),
(98, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 16:20:53'),
(99, 'Sipariş Alt Kalemi Güncellendi [ TpHetr.L3.DAL.CustomerOrderItem ]', 'POST', 200, '/api/customerOrderItem/UpdateCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-07 16:21:12'),
(100, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 17:04:15'),
(101, 'Reçete Güncellendi [ TpHetr.L3.DAL.Receipt ]', 'POST', 200, '/api/receipt/UpdateReceipt', 'DESKTOP-6I0AS7K', '2023-04-07 17:04:20'),
(102, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 17:13:11'),
(103, 'İş Emri Güncellendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workOrder/UpdateWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-07 17:13:19'),
(104, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/l3tol4status/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-07 17:16:50'),
(105, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-07 17:17:48'),
(106, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-07 17:18:25'),
(107, 'İş Emri Güncellendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workOrder/UpdateWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-07 17:19:46'),
(108, 'Kullanıcı Giriş Yaptı : admins2', 'AuthManager/LoginUser', 200, 'AuthController/Login', 'DESKTOP-6I0AS7K', '2023-04-07 17:24:56'),
(109, 'Kullanıcı Giriş Yaptı : adminIT', 'AuthManager/LoginUser', 200, 'AuthController/Login', 'DESKTOP-6I0AS7K', '2023-04-07 17:25:08'),
(110, 'Kullanıcı Eklendi [ TpHetr.L3.DAL.Account ]', 'POST', 200, '/api/Account/CreateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 17:26:30'),
(111, 'Kullanıcı Eklendi [ TpHetr.L3.DAL.Account ]', 'POST', 200, '/api/Account/CreateAccount', 'DESKTOP-6I0AS7K', '2023-04-07 17:35:38'),
(112, 'Kullanıcı Silindi [ fddsfas ]', 'POST', 200, '/api/Account/DeleteAccount', 'DESKTOP-6I0AS7K', '2023-04-07 17:39:52'),
(113, 'Kullanıcı Güncellendi [ TpHetr.L3.DAL.Models.AccountDto ]', 'POST', 200, '/api/Account/UpdateAccount', 'WIN-0I9TMG3F88B', '2023-04-07 17:45:07'),
(114, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-07 17:45:13'),
(115, 'One or more errors occurred. (\'<\' is an invalid start of a value. Path: $ | LineNumber: 0 | BytePositionInLine: 0.)', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'WIN-0I9TMG3F88B', '2023-04-07 17:45:19'),
(116, 'İş Emri Güncellendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workOrder/UpdateWorkOrder', 'WIN-0I9TMG3F88B', '2023-04-07 17:45:27'),
(117, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 17:50:34'),
(118, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 17:50:34'),
(119, 'Seviye-2 Den İş Emri Güncellendi [ TpHetr.L3.Core.Models.L2ToL3WorkOrderData ]', 'POST', 200, '/api/l2tol3/UpdateL2WorkOrderData', 'WIN-0I9TMG3F88B', '2023-04-07 17:52:05'),
(120, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 17:52:06'),
(121, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-07 17:52:06'),
(122, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 08:28:29'),
(123, 'Sipariş Alt Kalemi Güncellendi [ TpHetr.L3.DAL.CustomerOrderItem ]', 'POST', 200, '/api/customerOrderItem/UpdateCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-10 08:29:43'),
(124, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 08:58:12'),
(125, 'Field \'CustomerOrderNumberCreated\' doesn\'t have a default value', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 08:58:12'),
(126, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 08:59:25'),
(127, 'An error occurred while updating the entries. See the inner exception for details.', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 08:59:25'),
(128, 'Sipariş Silindi [ 03948a8c-cadb-450c-ae4d-b645d899e2cd ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 08:59:39'),
(129, 'Sipariş Silindi [ 76fbc416-3e03-4e2a-92ac-d103da21505f ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 08:59:42'),
(130, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 09:00:12'),
(131, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 09:00:27'),
(132, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 09:00:36'),
(133, 'Sipariş Silindi [ e0fb4b86-da0d-4ebd-97a1-eddc0a3ad699 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 09:00:46'),
(134, 'Sipariş Silindi [ 5004e35b-0fac-42be-880d-de46aa9e4212 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 09:00:49'),
(135, 'Sipariş Silindi [ 76307921-43d2-490a-8be8-bc924ad2d306 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 09:00:51'),
(136, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 09:04:33'),
(137, 'One or more errors occurred. (Hedef makine etkin olarak reddettiğinden bağlantı kurulamadı. (localhost:80))', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-10 09:04:55'),
(138, 'Specified argument was out of the range of valid values. (Parameter \'index\')', 'GET', 200, '/api/customer/getcustomerlistwithaccounting', 'DESKTOP-6I0AS7K', '2023-04-10 09:44:06'),
(139, 'Object reference not set to an instance of an object.', 'GET', 101, '/ws', 'DESKTOP-6I0AS7K', '2023-04-10 10:55:00'),
(140, 'Object reference not set to an instance of an object.', 'GET', 101, '/ws', 'DESKTOP-6I0AS7K', '2023-04-10 10:56:26'),
(141, 'Unexpected end of request content.', 'POST', 200, '/api/customerorder/ListWithCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 11:11:59'),
(142, 'Unexpected end of request content.', 'POST', 200, '/api/customerorder/ListWithCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 11:11:59'),
(143, 'Input string was not in a correct format.', 'GET', 101, '/ws/workOrders', 'DESKTOP-6I0AS7K', '2023-04-10 13:17:42'),
(144, 'Input string was not in a correct format.', 'GET', 101, '/ws/workOrders', 'DESKTOP-6I0AS7K', '2023-04-10 13:17:58'),
(145, 'Input string was not in a correct format.', 'GET', 101, '/ws/workOrders', 'DESKTOP-6I0AS7K', '2023-04-10 13:18:32'),
(146, 'Input string was not in a correct format.', 'GET', 101, '/ws/workOrders', 'DESKTOP-6I0AS7K', '2023-04-10 13:18:40'),
(147, 'Input string was not in a correct format.', 'GET', 101, '/ws/workOrders', 'DESKTOP-6I0AS7K', '2023-04-10 13:19:51'),
(148, 'Reçete Eklendi [ TpHetr.L3.DAL.Receipt ]', 'POST', 200, '/api/receipt/AddReceipt', 'DESKTOP-6I0AS7K', '2023-04-10 13:36:14'),
(149, 'Unexpected end of request content.', 'POST', 200, '/api/workOrder/GetWorkOrderWithDetailList', 'DESKTOP-6I0AS7K', '2023-04-10 13:48:03'),
(150, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:01'),
(151, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:04'),
(152, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:05'),
(153, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:06'),
(154, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:09'),
(155, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:10'),
(156, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:14'),
(157, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:16'),
(158, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:17'),
(159, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:18'),
(160, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:19'),
(161, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:21'),
(162, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:22'),
(163, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:24'),
(164, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:25'),
(165, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:26'),
(166, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:27'),
(167, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:29'),
(168, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:30'),
(169, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:31'),
(170, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:32'),
(171, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:34'),
(172, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:32'),
(173, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:34'),
(174, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:36'),
(175, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:37'),
(176, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:39'),
(177, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:40'),
(178, '  Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:41'),
(179, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-10 16:53:57'),
(180, 'Sipariş Alt Kalemi Güncellendi [ TpHetr.L3.DAL.CustomerOrderItem ]', 'POST', 200, '/api/customerOrderItem/UpdateCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-11 09:37:15'),
(181, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 09:40:16'),
(182, 'An error occurred while updating the entries. See the inner exception for details.', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 09:40:16'),
(183, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 09:47:19'),
(184, 'Sipariş Silindi [ 3981e55b-4856-45a1-97d9-1ce9e65b7d92 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 09:47:29'),
(185, 'The WebSocket is in an invalid state (\'CloseReceived\') for this operation. Valid states are: \'Open, CloseSent\'', 'GET', 101, '/ws/workOrders', 'DESKTOP-6I0AS7K', '2023-04-11 10:36:31'),
(186, 'Nullable object must have a value.', 'GET', 101, '/ws/workorders', 'DESKTOP-6I0AS7K', '2023-04-11 10:43:19'),
(187, 'Nullable object must have a value.', 'GET', 101, '/ws/workorders', 'DESKTOP-6I0AS7K', '2023-04-11 10:43:30'),
(188, 'İş Emri Silindi [ 107 ]', 'POST', 200, '/api/workOrder/DeleteWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 11:27:11'),
(189, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 11:41:37'),
(190, 'Sipariş Silindi [ 478f1bd2-1b8b-450c-86e9-4b487b5f57e3 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 11:57:42'),
(191, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 11:57:47'),
(192, 'Sipariş Silindi [ 478f1bd2-1b8b-450c-86e9-4b487b5f57e3 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 11:58:39'),
(193, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 11:58:43'),
(194, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 11:59:01'),
(195, 'İş Emri Silindi [ 109 ]', 'POST', 200, '/api/workOrder/DeleteWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 12:00:41'),
(196, 'Sipariş Silindi [ 478f1bd2-1b8b-450c-86e9-4b487b5f57e3 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 12:00:46'),
(197, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 12:01:56'),
(198, 'Sipariş Silindi [ 478f1bd2-1b8b-450c-86e9-4b487b5f57e3 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 13:00:22'),
(199, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:01:32'),
(200, 'Sipariş Silindi [ 478f1bd2-1b8b-450c-86e9-4b487b5f57e3 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 13:01:50'),
(201, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:02:20'),
(202, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:02:31'),
(203, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:05:29'),
(204, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:08:41'),
(205, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:10:21'),
(206, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:10:29'),
(207, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:10:36'),
(208, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:21:36'),
(209, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:23:04'),
(210, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:26:25'),
(211, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:29:56'),
(212, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:31:05'),
(213, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:31:37'),
(214, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:32:49'),
(215, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:32:59'),
(216, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:34:02'),
(217, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:35:17'),
(218, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:35:53'),
(219, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:41:58'),
(220, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:44:19'),
(221, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:46:03'),
(222, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:46:29'),
(223, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:47:29'),
(224, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:51:13'),
(225, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:52:39'),
(226, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:52:39'),
(227, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 13:53:34'),
(228, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:03:44'),
(229, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:06:26'),
(230, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:08:18'),
(231, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:11:36'),
(232, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:13:14'),
(233, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:16:27'),
(234, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:17:19'),
(235, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:18:19'),
(236, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:19:25'),
(237, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:21:06'),
(238, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:22:16'),
(239, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 14:22:35'),
(240, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 14:23:03'),
(241, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:23:41'),
(242, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:23:41'),
(243, 'Seviye-2 Den İş Emri Güncellendi [ TpHetr.L3.Core.Models.L2ToL3WorkOrderData ]', 'POST', 200, '/api/l2tol3/UpdateL2WorkOrderData', 'WIN-0I9TMG3F88B', '2023-04-11 14:24:26'),
(244, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:24:26'),
(245, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:24:26'),
(246, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 14:36:54'),
(247, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 14:37:18'),
(248, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 14:37:38'),
(249, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:38:07'),
(250, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:38:07'),
(251, 'Seviye-2 Den İş Emri Güncellendi [ TpHetr.L3.Core.Models.L2ToL3WorkOrderData ]', 'POST', 200, '/api/l2tol3/UpdateL2WorkOrderData', 'WIN-0I9TMG3F88B', '2023-04-11 14:38:28'),
(252, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:38:29'),
(253, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 14:38:29'),
(254, 'One or more errors occurred. (Hedef makine etkin olarak reddettiğinden bağlantı kurulamadı. (localhost:80))', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-11 14:41:28'),
(255, 'One or more errors occurred. (Hedef makine etkin olarak reddettiğinden bağlantı kurulamadı. (localhost:80))', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-11 14:41:34'),
(256, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 15:02:21'),
(257, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 15:04:12'),
(258, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:06:45'),
(259, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:06:45'),
(260, 'Seviye-2 Den İş Emri Güncellendi [ TpHetr.L3.Core.Models.L2ToL3WorkOrderData ]', 'POST', 200, '/api/l2tol3/UpdateL2WorkOrderData', 'WIN-0I9TMG3F88B', '2023-04-11 15:09:42'),
(261, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:09:42'),
(262, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:09:42'),
(263, 'Seviye-2 Den İş Emri Güncellendi [ TpHetr.L3.Core.Models.L2ToL3WorkOrderData ]', 'POST', 200, '/api/l2tol3/UpdateL2WorkOrderData', 'WIN-0I9TMG3F88B', '2023-04-11 15:10:14'),
(264, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:10:14'),
(265, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:10:14'),
(266, 'Seviye-2 Den İş Emri Güncellendi [ TpHetr.L3.Core.Models.L2ToL3WorkOrderData ]', 'POST', 200, '/api/l2tol3/UpdateL2WorkOrderData', 'WIN-0I9TMG3F88B', '2023-04-11 15:10:16'),
(267, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:10:16'),
(268, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 15:10:16'),
(269, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 15:22:54'),
(270, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-11 15:23:18'),
(271, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 15:23:34'),
(272, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:24:26'),
(273, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:24:40'),
(274, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:24:40'),
(275, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:25:32'),
(276, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:25:32'),
(277, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-11 15:28:10'),
(278, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'DESKTOP-6I0AS7K', '2023-04-11 15:28:38'),
(279, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:28:55'),
(280, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:28:55'),
(281, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:29:16'),
(282, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:29:16'),
(283, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:29:41'),
(284, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:29:41'),
(285, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:34:22'),
(286, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:34:22'),
(287, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:35:25'),
(288, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:35:25'),
(289, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:36:30'),
(290, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'DESKTOP-6I0AS7K', '2023-04-11 15:36:30'),
(291, 'Specified argument was out of the range of valid values. (Parameter \'index\')', 'GET', 200, '/api/customer/getcustomerlistwithaccounting', 'WIN-0I9TMG3F88B', '2023-04-11 17:07:12'),
(292, 'Sipariş Silindi [ 3337ea49-d472-4e13-8d28-dfb98a17d5ba ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-11 17:19:27'),
(293, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'WIN-0I9TMG3F88B', '2023-04-11 17:19:48'),
(294, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-11 17:19:57'),
(295, 'İş Emri Eklendi [ TpHetr.L3.DAL.WorkOrder ]', 'POST', 200, '/api/workorder/AddWorkOrder', 'WIN-0I9TMG3F88B', '2023-04-11 17:20:14'),
(296, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 17:21:34'),
(297, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 17:21:34'),
(298, 'Seviye 3\'den Seviye 4\'e veri aktarıldı.', 'UpdateL4CustomerOrderStatus', 200, 'l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 17:21:56'),
(299, 'Seviye-2 İş Emir Durumu Güncellendi [ TpHetr.L3.Core.Models.Level2ToLevel3 ]', 'POST', 200, '/api/l2tol3/SetWorkOrderStatus', 'WIN-0I9TMG3F88B', '2023-04-11 17:21:56'),
(300, 'One or more errors occurred. (\'<\' is an invalid start of a value. Path: $ | LineNumber: 0 | BytePositionInLine: 0.)', 'POST', 200, '/api/MaterialQuality/AddMaterialQuality', 'WIN-0I9TMG3F88B', '2023-04-11 17:27:32'),
(301, 'Specified argument was out of the range of valid values. (Parameter \'index\')', 'GET', 200, '/api/customer/getcustomerlistwithaccounting', 'WIN-0I9TMG3F88B', '2023-04-11 17:28:08'),
(302, 'Reçete Güncellendi [ TpHetr.L3.DAL.Receipt ]', 'POST', 200, '/api/receipt/UpdateReceipt', 'WIN-0I9TMG3F88B', '2023-04-11 17:28:15'),
(303, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-11 17:35:11'),
(304, 'An error occurred while updating the entries. See the inner exception for details.', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-11 17:35:11'),
(305, 'Sipariş Alt Kalemi Güncellendi [ TpHetr.L3.DAL.CustomerOrderItem ]', 'POST', 200, '/api/customerOrderItem/UpdateCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-12 09:26:16'),
(306, 'Sipariş Alt Kalemi Güncellendi [ TpHetr.L3.DAL.CustomerOrderItem ]', 'POST', 200, '/api/customerOrderItem/UpdateCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-12 09:26:23'),
(307, 'Specified argument was out of the range of valid values. (Parameter \'index\')', 'GET', 200, '/api/customer/getcustomerlistwithaccounting', 'DESKTOP-6I0AS7K', '2023-04-12 09:27:16'),
(308, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-12 09:49:58');
INSERT INTO `Log` (`id`, `LogDescription`, `LogMethod`, `LogStatusCode`, `LogPath`, `MachineName`, `CreatedDate`) VALUES
(309, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-12 09:50:17'),
(310, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-12 09:50:59'),
(311, 'Sipariş Silindi [ 84a1459a-a978-4b7f-9ed6-f1efedace835 ]', 'POST', 200, '/api/customerOrder/DeleteCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-12 09:51:17'),
(312, 'Object reference not set to an instance of an object.', 'POST', 200, '/api/CustomerOrderItem/UploadFile', 'DESKTOP-6I0AS7K', '2023-04-12 10:02:25'),
(313, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-12 11:05:42'),
(314, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-12 11:06:07'),
(315, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-12 11:37:50'),
(316, 'One or more errors occurred. (Hedef makine etkin olarak reddettiğinden bağlantı kurulamadı. (localhost:80))', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-12 12:12:05'),
(317, 'One or more errors occurred. (Hedef makine etkin olarak reddettiğinden bağlantı kurulamadı. (localhost:80))', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-12 12:12:11'),
(318, 'One or more errors occurred. (\'<\' is an invalid start of a value. Path: $ | LineNumber: 0 | BytePositionInLine: 0.)', 'POST', 200, '/api/MaterialQuality/UpdateMaterialQuality', 'DESKTOP-6I0AS7K', '2023-04-12 12:13:01'),
(319, 'Sipariş Eklendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/AddCustomerOrder', 'WIN-0I9TMG3F88B', '2023-04-15 14:49:19'),
(320, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-17 09:12:49'),
(321, 'One or more errors occurred. (An exception was thrown while attempting to evaluate the LINQ query parameter expression \'value(TpHetr.L3.BLL.Managers.ReceiptManager+<>c__DisplayClass17_0).workOrderItem.WorkOrderId\'. See the inner exception for more information.)', 'GET', 200, '/api/receipt/GetReceiptDataByCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-17 09:13:30'),
(322, 'Serialization and deserialization of \'System.Action\' instances are not supported. Path: $.MoveNextAction.', 'GET', 200, '/api/customerOrderItem/GetFurnaceDataByCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-17 09:17:09'),
(323, 'One or more errors occurred. (An exception was thrown while attempting to evaluate the LINQ query parameter expression \'value(TpHetr.L3.BLL.Managers.ReceiptManager+<>c__DisplayClass17_0).workOrderItem.WorkOrderId\'. See the inner exception for more information.)', 'GET', 200, '/api/receipt/GetReceiptDataByCustomerOrderItem', 'DESKTOP-6I0AS7K', '2023-04-17 09:17:26'),
(324, 'Specified argument was out of the range of valid values. (Parameter \'index\')', 'GET', 200, '/api/customer/getcustomerlistwithaccounting', 'DESKTOP-6I0AS7K', '2023-04-17 09:34:57'),
(325, 'Seviye 4 Durumları Güncellendi [ TpHetr.L3.Core.Models.Level3Tolevel4`1[TpHetr.L3.DAL.CustomerOrder] ]', 'POST', 200, '/api/level4/UpdateL4Status', 'DESKTOP-6I0AS7K', '2023-04-17 09:35:13'),
(326, 'Sipariş Güncellendi [ TpHetr.L3.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-04-17 10:00:49'),
(327, 'Reçete Güncellendi [ TpHetr.L3.DAL.Receipt ]', 'POST', 200, '/api/receipt/UpdateReceipt', 'DESKTOP-6I0AS7K', '2023-04-17 10:11:26');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `MaterialQuality`
--

CREATE TABLE `MaterialQuality` (
  `MaterialQualityId` int NOT NULL,
  `Code` varchar(10) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Remark` varchar(500) NOT NULL,
  `CreatedDatetime` datetime NOT NULL,
  `UpdatedDatetime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `MaterialQuality`
--

INSERT INTO `MaterialQuality` (`MaterialQualityId`, `Code`, `Name`, `Remark`, `CreatedDatetime`, `UpdatedDatetime`) VALUES
(1, '4140', '4140', '4140 Kalitesi', '2022-10-14 04:54:37', '2023-04-12 12:16:48'),
(2, 'ck45', 'ck45', 'ck45 Kalitesi', '0001-01-01 00:00:00', '2023-03-31 14:56:42'),
(3, '1040', '1040', '55', '0001-01-01 00:00:00', '2023-03-30 13:29:33'),
(4, '100CR6', '100CR6', 'TTT', '0001-01-01 00:00:00', '2023-04-04 13:56:03'),
(5, 'S235JR', 'S235JR', '123', '2022-12-05 06:22:02', '2023-03-30 14:23:04'),
(6, 'S275JR', 'S275JR', '54645', '2022-12-05 06:26:42', '2023-04-04 13:56:06'),
(7, 'S355JR', 'S355JR', '123', '2022-12-05 06:54:30', '2023-04-07 14:36:10'),
(8, '2379', '2379', '88', '0001-01-01 00:00:00', '2023-04-07 17:45:18'),
(32, 'DQ', 'DQ', 'DQ', '0001-01-01 00:00:00', '2023-04-11 14:41:23'),
(33, 'DQ', 'DQ', 'DQ', '0001-01-01 00:00:00', '2023-04-06 15:41:26'),
(34, 'DQ', 'DQ', 'DQ', '0001-01-01 00:00:00', '2023-04-06 09:05:24'),
(35, 'EESH3', 'EESH3 Kalite', 'EESH3 Kalite', '0001-01-01 00:00:00', '2023-04-06 15:53:52'),
(36, '123qw', 'Test Sviye4', 'Test Sviye4', '0001-01-01 00:00:00', '2023-04-11 17:27:31');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Receipt`
--

CREATE TABLE `Receipt` (
  `ReceiptId` int NOT NULL,
  `TreatmentTypeId` int NOT NULL,
  `FurnanceId` int NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Remark` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `Receipt`
--

INSERT INTO `Receipt` (`ReceiptId`, `TreatmentTypeId`, `FurnanceId`, `Name`, `Remark`) VALUES
(48, 1, 1, 'Doğalgaz Test Reçete', 'Doğal Gaz Test'),
(49, 1, 2, 'Elektirik Test Reçete', 'Elektirik Test Reçete'),
(52, 6, 3, 'Induksiyon Fırın Reçetesi', 'İndüksüyon fırını reçetesi'),
(55, 2, 1, 'Doğal Gaz Menevişleme', 'Doğal Gaz Menevişleme Reçetesi');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ReceiptDetail`
--

CREATE TABLE `ReceiptDetail` (
  `ReceiptDetailId` int NOT NULL,
  `ReceiptId` int NOT NULL,
  `HeatingTime` int NOT NULL,
  `Temperature` int NOT NULL,
  `StepNo` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `ReceiptDetail`
--

INSERT INTO `ReceiptDetail` (`ReceiptDetailId`, `ReceiptId`, `HeatingTime`, `Temperature`, `StepNo`) VALUES
(41, 48, 15, 200, 1),
(42, 48, 15, 300, 2),
(43, 48, 20, 500, 3),
(44, 48, 5, 550, 4),
(45, 48, 10, 600, 5),
(46, 49, 10, 200, 1),
(47, 49, 10, 300, 2),
(48, 49, 20, 400, 3),
(49, 49, 30, 600, 4),
(50, 49, 20, 650, 5),
(53, 52, 5, 100, 1),
(54, 52, 5, 200, 2),
(55, 52, 10, 250, 3),
(56, 52, 30, 500, 4),
(57, 48, 20, 650, 6),
(58, 55, 5, 200, 1),
(59, 55, 10, 300, 2),
(60, 55, 20, 350, 3),
(61, 55, 50, 550, 4),
(62, 55, 70, 650, 5);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Role`
--

CREATE TABLE `Role` (
  `RoleId` smallint NOT NULL,
  `RoleName` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `Role`
--

INSERT INTO `Role` (`RoleId`, `RoleName`) VALUES
(1, 'IT'),
(2, 'Admin'),
(3, 'SuperVisor');

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

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `WorkOrder`
--

CREATE TABLE `WorkOrder` (
  `WorkOrderId` int NOT NULL,
  `WorkOrderStatusId` int NOT NULL,
  `FurnanceId` int DEFAULT NULL,
  `ReceiptId` int NOT NULL,
  `WorkOrderNumber` varchar(50) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Remark` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `StartedDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `UpdatedDate` datetime DEFAULT NULL,
  `NgfNaturalGasStart` float DEFAULT NULL,
  `NgfNaturalGasEnd` float DEFAULT NULL,
  `EfHeaterRate1Avg` float DEFAULT NULL,
  `EfHeaterRate2Avg` float DEFAULT NULL,
  `IfGuc` float DEFAULT NULL,
  `IfVoltage` float DEFAULT NULL,
  `IfFreq` float DEFAULT NULL,
  `IfPower` float DEFAULT NULL,
  `IfCurrent` float DEFAULT NULL,
  `IfActualSpeed` float DEFAULT NULL,
  `IfReferenceSpeed` float DEFAULT NULL,
  `IfDuration` float DEFAULT NULL,
  `RemarkOperator` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `WorkOrder`
--

INSERT INTO `WorkOrder` (`WorkOrderId`, `WorkOrderStatusId`, `FurnanceId`, `ReceiptId`, `WorkOrderNumber`, `Name`, `Remark`, `CreatedDate`, `StartedDate`, `EndDate`, `UpdatedDate`, `NgfNaturalGasStart`, `NgfNaturalGasEnd`, `EfHeaterRate1Avg`, `EfHeaterRate2Avg`, `IfGuc`, `IfVoltage`, `IfFreq`, `IfPower`, `IfCurrent`, `IfActualSpeed`, `IfReferenceSpeed`, `IfDuration`, `RemarkOperator`) VALUES
(87, 50, 1, 48, 'TP0534953', 'Doğalgaz Test Sipariş', 'Doğalgaz Test Sipariş', '2023-03-27 15:15:11', NULL, NULL, '2023-03-31 11:53:44', 2, 3, 4, 5, 6, 6, 6, 6, 6, 7, 8, 7, '5'),
(89, 50, 1, 48, 'TP052955', 'Silinen selectedcustomerorder değişkeni testi', 'Silinen selectedcustomerorder değişkeni testi', '2023-03-29 15:53:07', NULL, NULL, '2023-03-30 14:21:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(90, 50, 1, 48, 'T05345TT', 'WorkOrderden silinen selectedcustomerorder testi', 'WorkOrderden silinen selectedcustomerorder testi', '2023-03-29 16:00:32', NULL, NULL, '2023-03-29 17:43:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(91, 50, 1, 48, 'TP04239429', 'Seviye 4 testi', 'Seviye 4 testi', '2023-03-29 17:05:04', NULL, NULL, '2023-04-06 08:17:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(106, 50, 1, 48, 'TP-202314512', 'Test İş Emri', 'Test İş Emri', '2023-04-07 08:34:54', NULL, NULL, '2023-04-07 08:50:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(108, 50, 1, 48, 'TP-2023040714', 'Yüzey Sertleştirme Seviye 4 Siparişi', 'Yüzey Sertleştirme Seviye 4 Siparişi', '2023-04-07 17:18:25', NULL, NULL, '2023-04-07 17:52:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(110, 50, 1, 48, 'TP-2023041116', 'Rulo Sertlik Ayarı', 'Rulo Sertlik Ayarı', '2023-04-11 14:23:01', NULL, NULL, '2023-04-11 14:24:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(111, 50, 1, 48, 'TP-2023041117', 'asdasdwq', 'dasasdwqeasdad', '2023-04-11 14:37:36', NULL, NULL, '2023-04-11 14:38:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(112, 50, 1, 48, 'TP-2023041118', 'sadasdqw3234re', 'ffasfasfwerwer', '2023-04-11 15:04:09', NULL, NULL, '2023-04-11 15:10:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(113, 50, 1, 48, 'TP-2023041119', 'asdqwe', 'dasfadszxvcczvfsdf', '2023-04-11 15:23:33', NULL, NULL, '2023-04-11 15:25:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(114, 50, 1, 48, 'TP-2023041120', 'DAWQEQDS', 'ADS', '2023-04-11 15:28:37', NULL, NULL, '2023-04-11 15:36:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(115, 50, 1, 48, 'TP-2023041121', 'RETWERTWERTEW', 'ERTEWRTWERTWERWT', '2023-04-11 17:20:12', NULL, NULL, '2023-04-11 17:21:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `WorkOrderItem`
--

CREATE TABLE `WorkOrderItem` (
  `WorkOrderItemId` int NOT NULL,
  `WorkOrderId` int NOT NULL,
  `CustomerOrderItemId` char(36) NOT NULL,
  `WorkOrderItemStatusId` int NOT NULL DEFAULT '10',
  `NextHrc` int DEFAULT NULL,
  `NextHb` int DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `WorkOrderItemStatus`
--

CREATE TABLE `WorkOrderItemStatus` (
  `WorkOrderItemStatusId` int NOT NULL,
  `Name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `WorkOrderItemStatus`
--

INSERT INTO `WorkOrderItemStatus` (`WorkOrderItemStatusId`, `Name`) VALUES
(10, 'Taslak'),
(20, 'Başlamadı'),
(30, 'Devam Ediyor'),
(40, 'Durduruldu'),
(50, 'Tamamlandı'),
(60, 'Kapandı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `WorkOrderNumber`
--

CREATE TABLE `WorkOrderNumber` (
  `WorkOrderNumberId` int NOT NULL,
  `WorkOrderNumberCounter` int DEFAULT NULL,
  `WorkOrderNumberCreated` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `WorkOrderNumber`
--

INSERT INTO `WorkOrderNumber` (`WorkOrderNumberId`, `WorkOrderNumberCounter`, `WorkOrderNumberCreated`) VALUES
(1, 1, NULL),
(2, 2, NULL),
(3, 3, NULL),
(4, 4, NULL),
(5, 5, NULL),
(6, 6, NULL),
(7, 7, NULL),
(8, 8, NULL),
(9, 9, NULL),
(10, 10, NULL),
(11, 11, 'TP-2023040711'),
(12, 12, 'TP-2023040712'),
(13, 13, 'TP-2023040713'),
(14, 14, 'TP-2023040714'),
(15, 15, 'TP-2023040715'),
(16, 16, 'TP-2023041116'),
(17, 17, 'TP-2023041117'),
(18, 18, 'TP-2023041118'),
(19, 19, 'TP-2023041119'),
(20, 20, 'TP-2023041120'),
(21, 21, 'TP-2023041121'),
(22, 22, 'TP-2023041122');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `WorkOrderStatus`
--

CREATE TABLE `WorkOrderStatus` (
  `WorkOrderStatusId` int NOT NULL,
  `Name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Tablo döküm verisi `WorkOrderStatus`
--

INSERT INTO `WorkOrderStatus` (`WorkOrderStatusId`, `Name`) VALUES
(10, 'Taslak'),
(20, 'Onaylandı'),
(30, 'Isıl İşlemde'),
(40, 'İptal Edildi'),
(50, 'Tamamlandı'),
(60, 'Kapandı (SİLİNECEK)');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `Account`
--
ALTER TABLE `Account`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `CustomerId` (`CustomerId`),
  ADD KEY `Role` (`Role`);

--
-- Tablo için indeksler `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`CustomerId`);

--
-- Tablo için indeksler `CustomerOrder`
--
ALTER TABLE `CustomerOrder`
  ADD PRIMARY KEY (`CustomerOrderId`),
  ADD UNIQUE KEY `UK_OrderNumber` (`OrderNumber`),
  ADD KEY `CustomerId` (`CustomerId`),
  ADD KEY `CustomerOrderStatusId` (`CustomerOrderStatusId`);

--
-- Tablo için indeksler `CustomerOrderItem`
--
ALTER TABLE `CustomerOrderItem`
  ADD PRIMARY KEY (`CustomerOrderItemId`),
  ADD KEY `CustomerId` (`CustomerId`),
  ADD KEY `TreatmentTypeId` (`TreatmentTypeId`),
  ADD KEY `CustomerOrderItemStatus` (`CustomerOrderItemStatusId`),
  ADD KEY `MaterialQualityId` (`MaterialQualityId`),
  ADD KEY `CustomerOrderId` (`CustomerOrderId`);

--
-- Tablo için indeksler `CustomerOrderItemStatus`
--
ALTER TABLE `CustomerOrderItemStatus`
  ADD PRIMARY KEY (`CustomerOrderItemStatusId`);

--
-- Tablo için indeksler `CustomerOrderNumber`
--
ALTER TABLE `CustomerOrderNumber`
  ADD PRIMARY KEY (`CustomerOrderNumberId`);

--
-- Tablo için indeksler `CustomerOrderStatus`
--
ALTER TABLE `CustomerOrderStatus`
  ADD PRIMARY KEY (`CustomerOrderStatusId`);

--
-- Tablo için indeksler `Furnance`
--
ALTER TABLE `Furnance`
  ADD PRIMARY KEY (`FurnanceId`);

--
-- Tablo için indeksler `Log`
--
ALTER TABLE `Log`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `MaterialQuality`
--
ALTER TABLE `MaterialQuality`
  ADD PRIMARY KEY (`MaterialQualityId`);

--
-- Tablo için indeksler `Receipt`
--
ALTER TABLE `Receipt`
  ADD PRIMARY KEY (`ReceiptId`),
  ADD KEY `TreatmentTypeId` (`TreatmentTypeId`),
  ADD KEY `FurnanceId` (`FurnanceId`);

--
-- Tablo için indeksler `ReceiptDetail`
--
ALTER TABLE `ReceiptDetail`
  ADD PRIMARY KEY (`ReceiptDetailId`),
  ADD KEY `ReceiptDetail_ibfk_1` (`ReceiptId`);

--
-- Tablo için indeksler `Role`
--
ALTER TABLE `Role`
  ADD PRIMARY KEY (`RoleId`);

--
-- Tablo için indeksler `TreatmentType`
--
ALTER TABLE `TreatmentType`
  ADD PRIMARY KEY (`TreatmentTypeId`);

--
-- Tablo için indeksler `WorkOrder`
--
ALTER TABLE `WorkOrder`
  ADD PRIMARY KEY (`WorkOrderId`),
  ADD KEY `ReceiptId` (`ReceiptId`),
  ADD KEY `WorkOrderStatusId` (`WorkOrderStatusId`);

--
-- Tablo için indeksler `WorkOrderItem`
--
ALTER TABLE `WorkOrderItem`
  ADD PRIMARY KEY (`WorkOrderItemId`),
  ADD KEY `WorkOrderItemStatusId` (`WorkOrderItemStatusId`),
  ADD KEY `WorkOrderItem_ibfk_3` (`WorkOrderId`),
  ADD KEY `WorkOrderItem_ibfk_4` (`CustomerOrderItemId`);

--
-- Tablo için indeksler `WorkOrderItemStatus`
--
ALTER TABLE `WorkOrderItemStatus`
  ADD PRIMARY KEY (`WorkOrderItemStatusId`);

--
-- Tablo için indeksler `WorkOrderNumber`
--
ALTER TABLE `WorkOrderNumber`
  ADD PRIMARY KEY (`WorkOrderNumberId`);

--
-- Tablo için indeksler `WorkOrderStatus`
--
ALTER TABLE `WorkOrderStatus`
  ADD PRIMARY KEY (`WorkOrderStatusId`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `Account`
--
ALTER TABLE `Account`
  MODIFY `Id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `Customer`
--
ALTER TABLE `Customer`
  MODIFY `CustomerId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

--
-- Tablo için AUTO_INCREMENT değeri `CustomerOrderItemStatus`
--
ALTER TABLE `CustomerOrderItemStatus`
  MODIFY `CustomerOrderItemStatusId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- Tablo için AUTO_INCREMENT değeri `CustomerOrderNumber`
--
ALTER TABLE `CustomerOrderNumber`
  MODIFY `CustomerOrderNumberId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Tablo için AUTO_INCREMENT değeri `CustomerOrderStatus`
--
ALTER TABLE `CustomerOrderStatus`
  MODIFY `CustomerOrderStatusId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- Tablo için AUTO_INCREMENT değeri `Furnance`
--
ALTER TABLE `Furnance`
  MODIFY `FurnanceId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `Log`
--
ALTER TABLE `Log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=328;

--
-- Tablo için AUTO_INCREMENT değeri `MaterialQuality`
--
ALTER TABLE `MaterialQuality`
  MODIFY `MaterialQualityId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- Tablo için AUTO_INCREMENT değeri `Receipt`
--
ALTER TABLE `Receipt`
  MODIFY `ReceiptId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- Tablo için AUTO_INCREMENT değeri `ReceiptDetail`
--
ALTER TABLE `ReceiptDetail`
  MODIFY `ReceiptDetailId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- Tablo için AUTO_INCREMENT değeri `TreatmentType`
--
ALTER TABLE `TreatmentType`
  MODIFY `TreatmentTypeId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Tablo için AUTO_INCREMENT değeri `WorkOrder`
--
ALTER TABLE `WorkOrder`
  MODIFY `WorkOrderId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

--
-- Tablo için AUTO_INCREMENT değeri `WorkOrderItem`
--
ALTER TABLE `WorkOrderItem`
  MODIFY `WorkOrderItemId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=158;

--
-- Tablo için AUTO_INCREMENT değeri `WorkOrderNumber`
--
ALTER TABLE `WorkOrderNumber`
  MODIFY `WorkOrderNumberId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Tablo için AUTO_INCREMENT değeri `WorkOrderStatus`
--
ALTER TABLE `WorkOrderStatus`
  MODIFY `WorkOrderStatusId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `Account`
--
ALTER TABLE `Account`
  ADD CONSTRAINT `Account_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `Customer` (`CustomerId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `Account_ibfk_2` FOREIGN KEY (`Role`) REFERENCES `Role` (`RoleId`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Tablo kısıtlamaları `CustomerOrder`
--
ALTER TABLE `CustomerOrder`
  ADD CONSTRAINT `CustomerId` FOREIGN KEY (`CustomerId`) REFERENCES `Customer` (`CustomerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CustomerOrderStatusId` FOREIGN KEY (`CustomerOrderStatusId`) REFERENCES `CustomerOrderStatus` (`CustomerOrderStatusId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `CustomerOrderItem`
--
ALTER TABLE `CustomerOrderItem`
  ADD CONSTRAINT `CustomerOrderItem_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `Customer` (`CustomerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CustomerOrderItem_ibfk_2` FOREIGN KEY (`TreatmentTypeId`) REFERENCES `TreatmentType` (`TreatmentTypeId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CustomerOrderItem_ibfk_4` FOREIGN KEY (`MaterialQualityId`) REFERENCES `MaterialQuality` (`MaterialQualityId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `CustomerOrderItem_ibfk_5` FOREIGN KEY (`CustomerOrderId`) REFERENCES `CustomerOrder` (`CustomerOrderId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `CustomerOrderItemStatus` FOREIGN KEY (`CustomerOrderItemStatusId`) REFERENCES `CustomerOrderItemStatus` (`CustomerOrderItemStatusId`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Tablo kısıtlamaları `Receipt`
--
ALTER TABLE `Receipt`
  ADD CONSTRAINT `Receipt_ibfk_1` FOREIGN KEY (`TreatmentTypeId`) REFERENCES `TreatmentType` (`TreatmentTypeId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `Receipt_ibfk_2` FOREIGN KEY (`FurnanceId`) REFERENCES `Furnance` (`FurnanceId`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Tablo kısıtlamaları `ReceiptDetail`
--
ALTER TABLE `ReceiptDetail`
  ADD CONSTRAINT `ReceiptDetail_ibfk_1` FOREIGN KEY (`ReceiptId`) REFERENCES `Receipt` (`ReceiptId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `WorkOrder`
--
ALTER TABLE `WorkOrder`
  ADD CONSTRAINT `WorkOrder_ibfk_1` FOREIGN KEY (`ReceiptId`) REFERENCES `Receipt` (`ReceiptId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `WorkOrder_ibfk_2` FOREIGN KEY (`WorkOrderStatusId`) REFERENCES `WorkOrderStatus` (`WorkOrderStatusId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `WorkOrderItem`
--
ALTER TABLE `WorkOrderItem`
  ADD CONSTRAINT `WorkOrderItem_ibfk_2` FOREIGN KEY (`WorkOrderItemStatusId`) REFERENCES `WorkOrderItemStatus` (`WorkOrderItemStatusId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `WorkOrderItem_ibfk_3` FOREIGN KEY (`WorkOrderId`) REFERENCES `WorkOrder` (`WorkOrderId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `WorkOrderItem_ibfk_4` FOREIGN KEY (`CustomerOrderItemId`) REFERENCES `CustomerOrderItem` (`CustomerOrderItemId`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
