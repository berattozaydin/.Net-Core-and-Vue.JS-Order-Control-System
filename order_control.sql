-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 03 May 2023, 09:53:37
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

--
-- Tablo döküm verisi `log`
--

INSERT INTO `log` (`id`, `LogDescription`, `LogMethod`, `LogStatusCode`, `LogPath`, `MachineName`, `CreatedDate`) VALUES
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
(150, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:01'),
(151, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:04'),
(152, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:05'),
(153, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:06'),
(154, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:09'),
(155, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:10'),
(156, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:14'),
(157, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:16'),
(158, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:17'),
(159, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:18'),
(160, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:19'),
(161, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:21'),
(162, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:22'),
(163, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:24'),
(164, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:25'),
(165, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:26'),
(166, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:27'),
(167, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:29'),
(168, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:30'),
(169, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:31'),
(170, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:32'),
(171, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:13:34'),
(172, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:32'),
(173, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:34'),
(174, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:36'),
(175, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:37'),
(176, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:39'),
(177, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:40'),
(178, 'Seviye-3 Hata. Websocket', 'GET', 101, '/ws/customerOrders', 'DESKTOP-6I0AS7K', '2023-04-10 16:21:41'),
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
INSERT INTO `log` (`id`, `LogDescription`, `LogMethod`, `LogStatusCode`, `LogPath`, `MachineName`, `CreatedDate`) VALUES
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
(327, 'Reçete Güncellendi [ TpHetr.L3.DAL.Receipt ]', 'POST', 200, '/api/receipt/UpdateReceipt', 'DESKTOP-6I0AS7K', '2023-04-17 10:11:26'),
(328, 'Kullanıcı Giriş Yaptı : adminIT', 'AuthManager/LoginUser', 200, 'AuthController/Login', 'DESKTOP-6I0AS7K', '2023-04-18 11:10:50'),
(329, 'Kullanıcı Giriş Yaptı : adminIT', 'AuthManager/LoginUser', 200, 'AuthController/Login', 'DESKTOP-6I0AS7K', '2023-04-18 11:10:50'),
(330, 'An exception has been raised that is likely due to a transient failure. Consider enabling transient error resiliency by adding \'EnableRetryOnFailure()\' to the \'UseMySql\' call.', 'POST', 200, '/api/customerorder/ListWithCustomerOrder', 'DESKTOP-6I0AS7K', '2023-05-03 10:00:40'),
(331, 'An exception has been raised that is likely due to a transient failure. Consider enabling transient error resiliency by adding \'EnableRetryOnFailure()\' to the \'UseMySql\' call.', 'POST', 200, '/api/customerorder/ListWithCustomerOrder', 'DESKTOP-6I0AS7K', '2023-05-03 10:00:40'),
(332, 'Unknown column \'c.MaterialQualityId\' in \'field list\'', 'GET', 200, '/api/customerOrderItem/GetCustomerOrderItemList', 'DESKTOP-6I0AS7K', '2023-05-03 10:00:59'),
(333, 'One or more errors occurred. (Unknown column \'c.MaterialQualityId\' in \'on clause\')', 'GET', 200, '/api/customerOrder/GetCustomerOrder', 'DESKTOP-6I0AS7K', '2023-05-03 10:00:59'),
(334, 'One or more errors occurred. (Unknown column \'c.MaterialQualityId\' in \'on clause\')', 'GET', 200, '/api/customerOrder/GetCustomerOrder', 'DESKTOP-6I0AS7K', '2023-05-03 10:04:18'),
(335, 'Unknown column \'c.MaterialQualityId\' in \'field list\'', 'GET', 200, '/api/customerOrderItem/GetCustomerOrderItemList', 'DESKTOP-6I0AS7K', '2023-05-03 10:04:17'),
(336, 'Unknown column \'c.MaterialQualityId\' in \'field list\'', 'GET', 200, '/api/customerOrderItem/GetCustomerOrderItemList', 'DESKTOP-6I0AS7K', '2023-05-03 10:08:59'),
(337, 'Unknown column \'c.MaterialQualityId\' in \'field list\'', 'GET', 200, '/api/customerOrderItem/GetCustomerOrderItemList', 'DESKTOP-6I0AS7K', '2023-05-03 10:10:06'),
(338, 'One or more errors occurred. (Unknown column \'c.MaterialQualityId\' in \'on clause\')', 'GET', 200, '/api/customerOrder/GetCustomerOrder', 'DESKTOP-6I0AS7K', '2023-05-03 10:10:06'),
(339, 'Sipariş Güncellendi [ OrderControlSystem.DAL.CustomerOrder ]', 'POST', 200, '/api/customerOrder/UpdateCustomerOrder', 'DESKTOP-6I0AS7K', '2023-05-03 10:15:49');

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
