-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 03 May 2023, 09:57:50
-- Sunucu sürümü: 10.4.24-MariaDB
-- PHP Sürümü: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `order_control`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`%` PROCEDURE `usp_CreateCustomerOrderNumber` ()   BEGIN
DECLARE CUSTOMERORDERNUMBERCNT INT(11);
DECLARE CUSTOMERORDERNUMBERCRTED VARCHAR(250);
SET CUSTOMERORDERNUMBERCNT = (SELECT CustomerOrderNumberCounter FROM CustomerOrderNumber Order by CustomerOrderNumberCounter DESC limit 1);

IF (CUSTOMERORDERNUMBERCNT = 100) THEN 
DELETE FROM CustomerOrderNumber WHERE CustomerOrderNumberCounter < CUSTOMERORDERNUMBERCNT;
END IF;

SET CUSTOMERORDERNUMBERCNT = CUSTOMERORDERNUMBERCNT+2;
SET CUSTOMERORDERNUMBERCRTED = CONCAT('O-',(REPLACE(CURRENT_DATE(),'-','')),CUSTOMERORDERNUMBERCNT );
INSERT INTO CustomerOrderNumber(CustomerOrderNumberCounter) VALUES(CUSTOMERORDERNUMBERCNT);
UPDATE CustomerOrderNumber Set CustomerOrderNumberCreated=CUSTOMERORDERNUMBERCRTED WHERE CustomerOrderNumberCounter = CUSTOMERORDERNUMBERCNT;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `usp_CreateWorkOrderNumber` ()   BEGIN
DECLARE WORKORDERNUMBERCNT INT(11);
DECLARE WORKORDERNUMBERCRTED VARCHAR(250);
SET WORKORDERNUMBERCNT = (SELECT WorkOrderNumberCounter FROM WorkOrderNumber Order by WorkOrderNumberCounter DESC limit 1);

IF (WORKORDERNUMBERCNT = 100) THEN 
DELETE FROM WorkOrderNumber WHERE WorkOrderNumberCounter < WORKORDERNUMBERCNT;
END IF;

SET WORKORDERNUMBERCNT = WORKORDERNUMBERCNT+1;
SET WORKORDERNUMBERCRTED = CONCAT('O-',(REPLACE(CURRENT_DATE(),'-','')),WORKORDERNUMBERCNT );
INSERT INTO WorkOrderNumber(WorkOrderNumberCounter) VALUES(WORKORDERNUMBERCNT);
UPDATE WorkOrderNumber Set WorkOrderNumberCreated =WORKORDERNUMBERCRTED WHERE WorkOrderNumberCounter = WORKORDERNUMBERCNT;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `usp_GetWorkOrderNumber` ()   BEGIN
SELECT WorkOrderNumberCreated FROM WorkOrderNumber ORDER BY WorkOrderNumberCounter DESC limit 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `account`
--

CREATE TABLE `account` (
  `Id` int(11) NOT NULL,
  `CustomerId` int(11) DEFAULT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(256) NOT NULL,
  `Role` smallint(6) NOT NULL DEFAULT 4,
  `Name` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `CreateDati` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdateDati` datetime DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT 1,
  `Email` varchar(100) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `account`
--

INSERT INTO `account` (`Id`, `CustomerId`, `Username`, `Password`, `Role`, `Name`, `LastName`, `CreateDati`, `UpdateDati`, `IsActive`, `Email`, `PhoneNumber`) VALUES
(1, NULL, 'admins2', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 3, 'Admin', 'Seviye2', '2022-06-22 20:57:13', '2023-04-07 16:15:27', 1, 'a@a.com', '1543234123'),
(2, NULL, 'admins3', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 2, 'Admin', 'Seviye3', '2022-12-14 07:05:51', '2022-12-14 07:05:31', 1, 'b@b.com', '1'),
(3, NULL, 'adminIT', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 1, 'admin', 'IT', '2022-12-14 13:22:39', '2023-04-07 17:45:07', 1, 'admin@admin.com', '1');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customer`
--

CREATE TABLE `customer` (
  `CustomerId` int(11) NOT NULL,
  `CompanyName` varchar(200) NOT NULL,
  `CompanyFullName` varchar(200) NOT NULL,
  `TaxNumber` varchar(200) NOT NULL,
  `TaxAdministration` varchar(200) NOT NULL,
  `Remark` varchar(200) NOT NULL,
  `CurrencyType` int(11) NOT NULL,
  `PartitionType` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `Maturity` int(11) NOT NULL,
  `CompanyCode` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customer`
--

INSERT INTO `customer` (`CustomerId`, `CompanyName`, `CompanyFullName`, `TaxNumber`, `TaxAdministration`, `Remark`, `CurrencyType`, `PartitionType`, `Status`, `Maturity`, `CompanyCode`) VALUES
(1, 'Test Şirket', 'Test Şirket', '1234567', 'İstanbul', '', 0, 0, 0, 0, '123456789');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customerorder`
--

CREATE TABLE `customerorder` (
  `CustomerOrderId` varchar(36) NOT NULL,
  `CustomerId` int(11) NOT NULL,
  `CustomerOrderStatusId` int(11) NOT NULL,
  `OrderNumber` varchar(15) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Remark` varchar(50) NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT current_timestamp(),
  `UpdatedDate` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customerorder`
--

INSERT INTO `customerorder` (`CustomerOrderId`, `CustomerId`, `CustomerOrderStatusId`, `OrderNumber`, `Name`, `Remark`, `CreatedDate`, `UpdatedDate`) VALUES
('478f1bd2-1b8b-450c-86e9-4b487b5f57e3', 1, 11, 'TP0003', 'Rulo Sertlik Ayarı', 'Rulo Sertlik Ayarı', '2023-04-17 09:35:12', '2023-05-03 10:15:48'),
('54d48b43-8642-422d-81d8-e48448e52e9a', 1, 11, 'TP-2023041227', 'Doğal Gaz Test Siparişi', 'Doğal Gaz Test Siparişi', '2023-04-15 14:49:19', '2023-04-17 09:12:48');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customerorderitem`
--

CREATE TABLE `customerorderitem` (
  `CustomerOrderItemId` char(36) NOT NULL,
  `CustomerOrderId` varchar(36) NOT NULL,
  `CustomerOrderItemStatusId` int(11) NOT NULL,
  `CustomerId` int(11) NOT NULL,
  `TreatmentTypeId` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `PieceNumber` int(11) NOT NULL,
  `PieceWeight` int(11) NOT NULL,
  `Width` int(11) NOT NULL,
  `Height` int(11) NOT NULL,
  `CreateDate` date NOT NULL,
  `RegistrationDate` date DEFAULT NULL,
  `RequestDate` date DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `FinishDate` date DEFAULT NULL,
  `ShippingDate` date DEFAULT NULL,
  `Remark` varchar(200) NOT NULL,
  `FilePath` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customerorderitem`
--

INSERT INTO `customerorderitem` (`CustomerOrderItemId`, `CustomerOrderId`, `CustomerOrderItemStatusId`, `CustomerId`, `TreatmentTypeId`, `Name`, `PieceNumber`, `PieceWeight`, `Width`, `Height`, `CreateDate`, `RegistrationDate`, `RequestDate`, `StartDate`, `FinishDate`, `ShippingDate`, `Remark`, `FilePath`) VALUES
('4efa9b81-f351-46c2-aed1-4422e815a7e0', '54d48b43-8642-422d-81d8-e48448e52e9a', 20, 1, 1, 'Doğal Gaz Test Siparişi', 123, 213, 123, 123, '2023-04-15', '2023-04-15', '2023-04-15', '2023-04-15 11:48:50', '2023-04-15', '2023-04-15', 'Doğal Gaz Test Siparişi', 'C:\\Users\\berat\\Desktop\\tphert\\TpHetr\\TpHetr.L3.WebAPI\\wwwroot//pdfs\\fbaf6861-fd25-4124-9156-44014adf083d.xlsx');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customerorderitemstatus`
--

CREATE TABLE `customerorderitemstatus` (
  `CustomerOrderItemStatusId` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customerorderitemstatus`
--

INSERT INTO `customerorderitemstatus` (`CustomerOrderItemStatusId`, `Name`) VALUES
(10, 'Taslak'),
(20, 'Onaylanmış'),
(21, 'Paketleme Aşamasında'),
(30, 'İptal Edilmiş'),
(40, 'Tamamlandı'),
(50, 'Sevkediliyor'),
(60, 'Kapandı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customerordernumber`
--

CREATE TABLE `customerordernumber` (
  `CustomerOrderNumberId` int(11) NOT NULL,
  `CustomerOrderNumberCounter` int(11) DEFAULT NULL,
  `CustomerOrderNumberCreated` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customerordernumber`
--

INSERT INTO `customerordernumber` (`CustomerOrderNumberId`, `CustomerOrderNumberCounter`, `CustomerOrderNumberCreated`) VALUES
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
-- Tablo için tablo yapısı `customerorderstatus`
--

CREATE TABLE `customerorderstatus` (
  `CustomerOrderStatusId` int(11) NOT NULL,
  `Name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customerorderstatus`
--

INSERT INTO `customerorderstatus` (`CustomerOrderStatusId`, `Name`) VALUES
(10, 'Taslak'),
(11, 'Sipariş Oluşturuldu'),
(20, 'Onaylanmış'),
(21, 'Paketleme Aşamasında'),
(30, 'İptal Edildi'),
(40, 'Tamamlandı'),
(50, 'Sevkediliyor'),
(60, 'Kapandı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `log`
--

CREATE TABLE `log` (
  `id` int(11) NOT NULL,
  `LogDescription` varchar(10000) DEFAULT NULL,
  `LogMethod` varchar(250) DEFAULT NULL,
  `LogStatusCode` int(11) DEFAULT NULL,
  `LogPath` varchar(250) DEFAULT NULL,
  `MachineName` varchar(100) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `processsteps`
--

CREATE TABLE `processsteps` (
  `ProcessStepsId` int(11) NOT NULL,
  `TreatmentTypeId` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Remark` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `role`
--

CREATE TABLE `role` (
  `RoleId` smallint(6) NOT NULL,
  `RoleName` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `role`
--

INSERT INTO `role` (`RoleId`, `RoleName`) VALUES
(1, 'IT'),
(2, 'Admin'),
(3, 'SuperVisor'),
(4, 'User');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `treatmenttype`
--

CREATE TABLE `treatmenttype` (
  `TreatmentTypeId` int(11) NOT NULL,
  `Name` varchar(35) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `treatmenttype`
--

INSERT INTO `treatmenttype` (`TreatmentTypeId`, `Name`) VALUES
(1, 'Satış'),
(2, 'Değişim'),
(3, 'İade');

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `CustomerId` (`CustomerId`),
  ADD KEY `Role` (`Role`);

--
-- Tablo için indeksler `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CustomerId`);

--
-- Tablo için indeksler `customerorder`
--
ALTER TABLE `customerorder`
  ADD PRIMARY KEY (`CustomerOrderId`),
  ADD UNIQUE KEY `UK_OrderNumber` (`OrderNumber`),
  ADD KEY `CustomerId` (`CustomerId`),
  ADD KEY `CustomerOrderStatusId` (`CustomerOrderStatusId`);

--
-- Tablo için indeksler `customerorderitem`
--
ALTER TABLE `customerorderitem`
  ADD PRIMARY KEY (`CustomerOrderItemId`),
  ADD KEY `CustomerId` (`CustomerId`),
  ADD KEY `TreatmentTypeId` (`TreatmentTypeId`),
  ADD KEY `CustomerOrderItemStatus` (`CustomerOrderItemStatusId`),
  ADD KEY `CustomerOrderId` (`CustomerOrderId`);

--
-- Tablo için indeksler `customerorderitemstatus`
--
ALTER TABLE `customerorderitemstatus`
  ADD PRIMARY KEY (`CustomerOrderItemStatusId`);

--
-- Tablo için indeksler `customerordernumber`
--
ALTER TABLE `customerordernumber`
  ADD PRIMARY KEY (`CustomerOrderNumberId`);

--
-- Tablo için indeksler `customerorderstatus`
--
ALTER TABLE `customerorderstatus`
  ADD PRIMARY KEY (`CustomerOrderStatusId`);

--
-- Tablo için indeksler `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `processsteps`
--
ALTER TABLE `processsteps`
  ADD PRIMARY KEY (`ProcessStepsId`),
  ADD KEY `TreatmentTypeId` (`TreatmentTypeId`);

--
-- Tablo için indeksler `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`RoleId`);

--
-- Tablo için indeksler `treatmenttype`
--
ALTER TABLE `treatmenttype`
  ADD PRIMARY KEY (`TreatmentTypeId`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `account`
--
ALTER TABLE `account`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Tablo için AUTO_INCREMENT değeri `customer`
--
ALTER TABLE `customer`
  MODIFY `CustomerId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

--
-- Tablo için AUTO_INCREMENT değeri `customerorderitemstatus`
--
ALTER TABLE `customerorderitemstatus`
  MODIFY `CustomerOrderItemStatusId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- Tablo için AUTO_INCREMENT değeri `customerordernumber`
--
ALTER TABLE `customerordernumber`
  MODIFY `CustomerOrderNumberId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Tablo için AUTO_INCREMENT değeri `customerorderstatus`
--
ALTER TABLE `customerorderstatus`
  MODIFY `CustomerOrderStatusId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- Tablo için AUTO_INCREMENT değeri `log`
--
ALTER TABLE `log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=340;

--
-- Tablo için AUTO_INCREMENT değeri `processsteps`
--
ALTER TABLE `processsteps`
  MODIFY `ProcessStepsId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- Tablo için AUTO_INCREMENT değeri `treatmenttype`
--
ALTER TABLE `treatmenttype`
  MODIFY `TreatmentTypeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `Account_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`CustomerId`),
  ADD CONSTRAINT `Account_ibfk_2` FOREIGN KEY (`Role`) REFERENCES `role` (`RoleId`);

--
-- Tablo kısıtlamaları `customerorder`
--
ALTER TABLE `customerorder`
  ADD CONSTRAINT `CustomerId` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`CustomerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CustomerOrderStatusId` FOREIGN KEY (`CustomerOrderStatusId`) REFERENCES `customerorderstatus` (`CustomerOrderStatusId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `customerorderitem`
--
ALTER TABLE `customerorderitem`
  ADD CONSTRAINT `CustomerOrderItemStatus` FOREIGN KEY (`CustomerOrderItemStatusId`) REFERENCES `customerorderitemstatus` (`CustomerOrderItemStatusId`),
  ADD CONSTRAINT `CustomerOrderItem_ibfk_1` FOREIGN KEY (`CustomerId`) REFERENCES `customer` (`CustomerId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CustomerOrderItem_ibfk_2` FOREIGN KEY (`TreatmentTypeId`) REFERENCES `treatmenttype` (`TreatmentTypeId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CustomerOrderItem_ibfk_5` FOREIGN KEY (`CustomerOrderId`) REFERENCES `customerorder` (`CustomerOrderId`);

--
-- Tablo kısıtlamaları `processsteps`
--
ALTER TABLE `processsteps`
  ADD CONSTRAINT `Receipt_ibfk_1` FOREIGN KEY (`TreatmentTypeId`) REFERENCES `treatmenttype` (`TreatmentTypeId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
