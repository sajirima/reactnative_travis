-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 14, 2026 at 05:48 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `travis`
--

-- --------------------------------------------------------

--
-- Table structure for table `cameras`
--

CREATE TABLE `cameras` (
  `camera_id` bigint(20) UNSIGNED NOT NULL,
  `camera_name` varchar(120) NOT NULL,
  `location` varchar(255) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `status` enum('online','offline','maintenance','decommissioned') NOT NULL DEFAULT 'offline',
  `installed_at` date DEFAULT NULL,
  `last_maintenance_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `camera_monitoring_logs`
--

CREATE TABLE `camera_monitoring_logs` (
  `log_id` bigint(20) UNSIGNED NOT NULL,
  `camera_id` bigint(20) UNSIGNED NOT NULL,
  `recorded_at` datetime NOT NULL DEFAULT current_timestamp(),
  `vehicle_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `inbound_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `outbound_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `congestion_level` enum('none','low','moderate','heavy','severe') NOT NULL DEFAULT 'none',
  `officer_presence` enum('none','detected','multiple','unknown') NOT NULL DEFAULT 'unknown',
  `potential_collision` enum('none','possible','confirmed') NOT NULL DEFAULT 'none',
  `incident_notes` text DEFAULT NULL,
  `alert_generated` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ml_predictions`
--

CREATE TABLE `ml_predictions` (
  `prediction_id` bigint(20) UNSIGNED NOT NULL,
  `prediction_type` enum('season-based','time-based','high-violation-period','other') NOT NULL,
  `predicted_result` varchar(255) NOT NULL,
  `confidence_score` decimal(5,4) NOT NULL DEFAULT 0.0000,
  `location` varchar(255) DEFAULT NULL,
  `violation_type` varchar(120) DEFAULT NULL,
  `frequency_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `risk_level` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `prediction_date` datetime NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `monitoring_alerts`
--

CREATE TABLE `monitoring_alerts` (
  `alert_id` bigint(20) UNSIGNED NOT NULL,
  `camera_log_id` bigint(20) UNSIGNED DEFAULT NULL,
  `alert_type` enum('congestion','collision','incident','system') NOT NULL,
  `severity` enum('info','warning','critical') NOT NULL DEFAULT 'warning',
  `message` text NOT NULL,
  `status` enum('active','acknowledged','resolved') NOT NULL DEFAULT 'active',
  `generated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `acknowledged_by` bigint(20) UNSIGNED DEFAULT NULL,
  `acknowledged_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `officers`
--

CREATE TABLE `officers` (
  `officer_id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `badge_number` varchar(50) DEFAULT NULL,
  `rank` varchar(80) DEFAULT NULL,
  `contact_number` varchar(30) DEFAULT NULL,
  `zone_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('active','inactive','retired','suspended') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `officer_duty_schedules`
--

CREATE TABLE `officer_duty_schedules` (
  `schedule_id` bigint(20) UNSIGNED NOT NULL,
  `officer_id` bigint(20) UNSIGNED NOT NULL,
  `duty_date` date NOT NULL,
  `shift_start` time DEFAULT NULL,
  `shift_end` time DEFAULT NULL,
  `status` enum('active duty','break','lunch break','off-duty') NOT NULL DEFAULT 'active duty',
  `notes` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `officer_presence_logs`
--

CREATE TABLE `officer_presence_logs` (
  `presence_id` bigint(20) UNSIGNED NOT NULL,
  `officer_id` bigint(20) UNSIGNED NOT NULL,
  `zone_id` bigint(20) UNSIGNED DEFAULT NULL,
  `presence_date` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('on_duty','break','lunch_break','off_duty','not_present') NOT NULL DEFAULT 'not_present',
  `recorded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `officer_zones`
--

CREATE TABLE `officer_zones` (
  `zone_id` bigint(20) UNSIGNED NOT NULL,
  `zone_name` varchar(120) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `location_details` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` bigint(20) UNSIGNED NOT NULL,
  `violation_id` bigint(20) UNSIGNED NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_status` enum('pending','completed','failed','refunded') NOT NULL DEFAULT 'completed',
  `payment_date` datetime NOT NULL DEFAULT current_timestamp(),
  `received_by` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_method` enum('cash','card','online','cheque','mobile_wallet','other') NOT NULL DEFAULT 'cash',
  `receipt_reference` varchar(120) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `public_announcements`
--

CREATE TABLE `public_announcements` (
  `announcement_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `announcement_type` enum('public announcement','traffic advisory','tmo activity','public notice') NOT NULL,
  `publish_date` datetime NOT NULL DEFAULT current_timestamp(),
  `expiry_date` datetime DEFAULT NULL,
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` bigint(20) UNSIGNED NOT NULL,
  `report_type` enum('traffic monitoring','violation','payment','alert','prediction','hotspot','custom') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `generated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `generated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `file_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Administrator','TMO Personnel','Treasury Personnel') NOT NULL DEFAULT 'TMO Personnel',
  `status` enum('active','inactive','suspended','pending') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `email`, `password`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, 'treasurer', 'treasurer@gmail.com', '123456', 'Treasury Personnel', 'active', '2026-07-11 10:17:24', '2026-07-11 10:17:24'),
(2, 'admin', 'admin@gmail.com', '123456', 'Administrator', 'active', '2026-07-11 12:28:07', '2026-07-11 12:28:07');

-- --------------------------------------------------------

--
-- Table structure for table `violations`
--

CREATE TABLE `violations` (
  `violation_id` bigint(20) UNSIGNED NOT NULL,
  `ticket_number` varchar(80) NOT NULL,
  `driver_name` varchar(150) NOT NULL,
  `license_number` varchar(80) NOT NULL,
  `plate_number` varchar(50) NOT NULL,
  `vehicle_type` enum('Motorcycle','Car','SUV','Truck','Bus','Other') NOT NULL,
  `violation_type` varchar(255) NOT NULL,
  `violation_location` varchar(255) NOT NULL,
  `violation_date` date NOT NULL,
  `violation_time` time NOT NULL,
  `penalty_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `input_method` enum('manual','ocr') NOT NULL DEFAULT 'manual',
  `encoded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('pending','paid','overdue','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `violations`
--

INSERT INTO `violations` (`violation_id`, `ticket_number`, `driver_name`, `license_number`, `plate_number`, `vehicle_type`, `violation_type`, `violation_location`, `violation_date`, `violation_time`, `penalty_amount`, `input_method`, `encoded_by`, `status`, `created_at`, `updated_at`) VALUES
(1, '19573', 'COSARE, RAYMART', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREGISTERED MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(2, '25655', 'GACOS, ALFREDO BADILLO', 'N/A', 'N/A', 'Other', 'DRIVING WITH INVALID DRIVERS LICENSE', 'Nasugbu, Batangas', '2016-08-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(3, '28851', 'REGALADO, REYSON', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER / 34J; UNREGISTERED MOTOR VEHICLE', 'Nasugbu, Batangas', '2017-03-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(4, '30985', 'MADRIGAL, CHRISTIAN RENALDE', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFFICER', 'Nasugbu, Batangas', '2019-07-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(5, '30987', 'DE JOYA, ARVEE CORPUZ', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-08-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(6, '30993', 'PADLAN, ERICSON NAPARITE', 'N/A', 'N/A', 'Other', 'RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(7, '30994', 'CORDERO, JUSTIN JOHN MANANQUIL', 'N/A', 'N/A', 'Other', 'LOI 1482; RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(8, '30995', 'ALIPUSTAIN, MELCHOR HERNANDEZ', 'N/A', 'N/A', 'Other', 'LOI 1482; OBSTRUCTION', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(9, '30996', 'ELEPONGA, EULOGIO PINEDA', 'N/A', 'N/A', 'Other', 'LOI 1482; OVERLOADING; RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(10, '30998', 'BAYABORDA, MERILL GUEVARRA', 'N/A', 'N/A', 'Other', 'LOI 1482; OBSTRUCTION', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(11, '30999', 'ADRIAS, RICHARD TALACTAC', 'N/A', 'N/A', 'Other', 'LOI 1482; OBSTRUCTION', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(12, '31000', 'HABAN, JAY AR BAYANI', 'N/A', 'N/A', 'Other', 'LOI 1482; OBSTRUCTION', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(13, '31051', 'BICONIA, EDMAR BANASIHAN', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2018-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(14, '31095', 'MAGNAYE, RODGER IRAHAM', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-10-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(15, '31096', 'PAMPLONA, VERGILIO LALOMA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(16, '31224', 'DE JOYA, JULIUS', 'N/A', 'N/A', 'Other', 'CODING TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2017-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(17, '31851', 'BULANHAGUI, LEVIE', 'N/A', 'N/A', 'Other', 'LOI 1482; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2017-11-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(18, '32566', 'ALDAY, JOJO ROSALES', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(19, '32567', 'TENORIO, CARL VIEN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(20, '32568', 'TIQUIS, ROMMEL JOSHUA VILLARIN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(21, '32572', 'CALBARIO, RENANTE ZAFRA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(22, '32574', 'BAUTISTA, ALVIN A', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(23, '32768', 'GAMEZ, DIONISIO B', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-08-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(24, '32788', 'BAUTISTA, REYNALDO JR D', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFFICER', 'Nasugbu, Batangas', '2019-07-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(25, '32791', 'UDARBE, MERWIN CABATO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(26, '32796', 'CORSIGA, NESTOR CLADO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-12-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(27, '33144', 'ORIONDO, ENRICO SEVILLA', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(28, '33145', 'CASIL, ALLAN SALGO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-10-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(29, '33146', 'APOLONIO, ANDINO BARBO', 'N/A', 'N/A', 'Other', 'LOI 1482; REFUSAL TO SIGN TRAFFIC CIT.TICKET', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(30, '33147', 'MARASIGAN, ERNISTO.', 'N/A', 'N/A', 'Other', 'LOI 1482; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(31, '33149', 'DIMAANO, JOSELITO MOSQUETES', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-11-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(32, '33191', 'ROTULO, JOMER ELIK', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(33, '33204', 'CORSIGA, ALBERTO', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2018-02-03', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(34, '33544', 'SEVILLA, REDENTOR', 'N/A', 'N/A', 'Other', 'RA 4136', 'Nasugbu, Batangas', '2018-06-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(35, '34502', 'CAPUPUS, EDWIN .', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2018-05-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(36, '35101', 'APAY, MIGUEL', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2018-07-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(37, '35620', 'SEVILLA, LOURDES PINEDA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(38, '35622', 'CUPO, CARLOS DELA CUESTA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(39, '35625', 'ARELLANO, NOLITO PONDALES', 'N/A', 'N/A', 'Other', 'DRIVING NOT WEARING SHOES; RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(40, '35626', 'ANDIS, CHRISTOPHER MONTALBO', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; DISREGARDING TRAFFIC SIGN/OFCR; LOI 1482', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(41, '35627', 'GUINOO JR., ANGELES CLAUD', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(42, '35694', 'LANTING, ROBERT J', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-03-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(43, '35696', 'ROMANES, AUGUSTO B.', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-03-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(44, '36290', 'TENORIO, EDGARDO GOMEZ', 'N/A', 'N/A', 'Other', 'LOI 1482; REFUSAL TO SIGN TRAFFIC CIT. TICKET', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(45, '36292', 'CABINGAN, RENATO HERNANDO', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(46, '36293', 'MENDOZA, EDUARDO A.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(47, '36294', 'LISBOA, KAREM', 'N/A', 'N/A', 'Other', '2ND OFFENSE - LOI 1482; 2ND OFFENSE - NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(48, '36295', 'MINA, JOLITO RONE', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE; TAMPERED STICKER(N.C.S.O)', 'Nasugbu, Batangas', '2019-09-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(49, '36299', 'CABATIAN, LUISITO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - CODING NUMBER CODING ORDINANCE; 2ND OFFENSE - NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(50, '36758', 'DELA CRUZ, RICSAN D', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-03-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(51, '37306', 'MORILLO, SANNEMAR BATOTO', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-03-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(52, '37352', 'LAPITAN, ROLLY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(53, '37353', 'MENDOZA, MARY ROSE VILLAFRANCA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(54, '37355', 'PATCHALIGAN, GREGORIO JR.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(55, '37356', 'LIWANAG, LAURO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(56, '37357', 'TENORIO, BENJAMIN JR CUESTA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-09-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(57, '37363', 'LIQUIDO, SHARLYN FAYE GLUDO', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(58, '37365', 'ALCARAZ, CYRUZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(59, '37366', 'ORIONDO, WILFRED GANTONG', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(60, '37370', 'ULARTE, RONALD', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(61, '37378', 'BALBOA, RAYMUNDO MARSAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(62, '37388', 'ROSARIO, MONSON COLOBONG', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(63, '37389', 'VILLANUEVA, FLORENTINO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(64, '37390', 'MARASIGAN, RAFAEL DE CASTRO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-10-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(65, '37392', 'MENDOZA, ARIEL DIMAALA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(66, '37393', 'HERNANDEZ, DOMINADOR', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(67, '37400', 'HUMARANG, WILSON', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(68, '37458', 'DONOR, JASON MAGNO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(69, '37459', 'MARANAN, ROVHIC CEBEDA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(70, '37460', 'LAGRISOLA, ARIEL LAGUERTA', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-08-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(71, '37464', 'MANALO, CHRISTIAN', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(72, '37465', 'ALLA, ARIES ARELLANO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(73, '37467', 'BAPOL, RICARDO BUEN', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(74, '37469', 'SALANGUIT, JASPER MARASIGAN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-09-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(75, '37470', 'AQUINO, CEE JAY YAGO', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-09-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(76, '37474', 'CORPUZ, VICTOR B.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(77, '37478', 'SUAREZ, FERNANDO B', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(78, '37480', 'ALIPIO, MELCHOR GABRIEL', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(79, '37493', 'PANGANIBAN, REJIE.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(80, '37498', 'AGSALOG, ORLANDO IPAC', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-10-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(81, '37500', 'ORDIALES, KENNETH .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(82, '37817', 'CRUZADO, JOSE BAUTISTA', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-05-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(83, '37822', 'PEREZ, ROLANDO MALINAY', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE; DRIVING WITH INVALID DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-05-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(84, '37836', 'DIPDIPIN, ALVIN BRILLANTE', 'N/A', 'N/A', 'Other', 'CODING TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-06-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(85, '37923', 'SOCITO, EDGARDO CASTILLO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-07-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(86, '37924', 'DELAS ALAS, GERRIEL PANGANIBAN', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-08-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(87, '37925', 'CABASIS, GENER', 'N/A', 'N/A', 'Other', 'LOI 1482; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(88, '37927', 'SEVILLA, ARTEMIO DELAS ALAS', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(89, '37928', 'MACALAGUIM, JOY HERNANDEZ', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(90, '37929', 'FERNANDEZ, JOHN ZEDNIE HERNANDEZ', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-08-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(91, '37933', 'BORRERO, JOHN LUIS MENDOZA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(92, '37934', 'VIDENA, MARK FRANCIS RAZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(93, '37935', 'MUÑOZ, MONTANO SUARIO', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(94, '37936', 'ESPENILE, MARK HERNANDEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(95, '37941', 'DELEQUENA, SONNY DIAZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(96, '37942', 'SOBREMONTE, JAYSON GRANADOS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(97, '37944', 'DULAY, JACOBO II PUNLA', 'N/A', 'N/A', 'Other', 'DRIVING NOT WEARING SHOES; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(98, '37945', 'SILVA, SERVANDO A', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(99, '37975', 'LADERAS, JOHN MARK CONJE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-09-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(100, '37977', 'LUNDAY, JOCELYN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(101, '37978', 'CAISIP, VANESSA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(102, '37979', 'CASANOVA, LEAH MARIEL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(103, '37980', 'ROMANES, REYNALDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(104, '37981', 'JIMENA, ELDO MAHINAY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(105, '37983', 'PAGKALIWANGAN, JOSEPH LORENZ HERNANDEZ', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-09-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(106, '37985', 'BARRION, LEO PACIA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(107, '37986', 'MUROS, ALLAN KYLE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-09-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(108, '37987', 'SILVA, MARK LORENZ LEYESA', 'N/A', 'N/A', 'Other', 'DRIVING NOT WEARING SHOES', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(109, '37995', 'BREN, NESTOR DE CASTRO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-10-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(110, '37996', 'SAMONTAÑEZ, ALONA DELA VEGA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-10-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(111, '38144', 'MORALES, FRANCIS JONSON', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(112, '38147', 'PUNONGBAYAN, LINO JR BODINO', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(113, '38148', 'AMISTAD, REYMOND JOSE BULANHAGUI', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(114, '38149', 'VILLAJIN, ROMEO AUSTRIA', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(115, '38150', 'ALFONSO, HILBERT CANTILA', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(116, '38155', 'GUTIERREZ, DENNIS REYES', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(117, '38178', 'SECONDEZ, RODTRIGO LOPEZ', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-08-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(118, '38264', 'MALABANAN, MERCADO MAURO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-26', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(119, '38266', 'MILAN, AMADO UY', 'N/A', 'N/A', 'Other', 'RA 4136', 'Nasugbu, Batangas', '2019-07-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(120, '38267', 'DELA CRUZ, MICHAEL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(121, '38268', 'HANDUSAY, ARNEL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRIED', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(122, '38269', 'BITUIN, EFREN DELAS ALAS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(123, '38270', 'SIAPNO, GUILLERMO MAGBAGO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(124, '38271', 'ALCARAZ, EDWIN HERNANDEZ', 'N/A', 'N/A', 'Other', 'RA 4136', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(125, '38272', 'PAGKALIWANGAN ARNEL SANTOS', 'N/A', 'N/A', 'Other', 'RA 4136', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(126, '38274', 'ADRIAS JR., JUANCHO RAMOS', 'N/A', 'N/A', 'Other', 'RA 4136', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(127, '38275', 'URCIA, FRANCIS DE CLARO', 'N/A', 'N/A', 'Other', 'RA 4136', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(128, '38276', 'LAYNESA, CRISTOPHER', 'N/A', 'N/A', 'Other', 'RA 4136', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(129, '38279', 'ANGSIOCO, RALPH DAMIAN ORIONDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(130, '38280', 'CUDIAMAT, ALVIN DEMESA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(131, '38282', 'DEL MUNDO, LITO ANSELMO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OBSTRUCTION; OR/CR NOT CARRRIED; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(132, '38413', 'MAGYAYA, REGINARD A', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2019-05-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(133, '38573', 'ROL, REYNALD .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(134, '38574', 'DIGNO, CARLO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(135, '38576', 'DEJOYA, CARLO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(136, '38590', 'CAISIP, JERICHO', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(137, '38593', 'SEVILLA, THEDORO DERAIN', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(138, '38594', 'DERAIN, AARON .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(139, '38595', 'PASTOR, KENNETH', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(140, '38596', 'RUEDAS, EDGARDO SARAZA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(141, '38600', 'LOZANA, JOSHUA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(142, '38602', 'RAMOS, GERALD LOVERES', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-06-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(143, '38767', 'MARANAN, MIGUEL JR GALO', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(144, '38808', 'SEVILLA, LORENZO D.', 'N/A', 'N/A', 'Other', 'CODING TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-06-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(145, '38838', 'BAUSO, JEFFREY ANDAYA', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-07-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(146, '38847', 'CARANDANG, RICHARD ROMASANTA', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(147, '38854', 'BUENO, ARVIN', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(148, '38855', 'VALENZUELA, ARDIEE CARAUSOS', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(149, '38856', 'BARRIOS, ARNEL .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(150, '38857', 'VERGARA, RENE MANALO', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(151, '38860', 'MENDOZA, JUN B', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(152, '38861', 'MADRIGAL, CHRISTIAN RENALDE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(153, '38864', 'ROSALES, EL JOHN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(154, '38865', 'CABRAL, LEO JUNELLE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(155, '38866', 'RUIZ, GLEENMORE D.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(156, '38868', 'ADOVE, PABLO MENDOZA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(157, '38869', 'CARABALLOS, BILLY P.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(158, '38870', 'LISTANA, FRANZ V', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(159, '38871', 'HERNANDEZ, JOMAR BUHAY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(160, '38872', 'VARGAS, ALEXANDER', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(161, '38873', 'ALBANIO, JOHN MARCO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(162, '38874', 'PERALTA, DARWIN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(163, '38875', 'CAGUNGUN, EDWARD O.', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2019-08-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(164, '38915', 'JUGO, MARVIN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(165, '38916', 'ECALDRE, CHRISTIAN JOSHUA RESURRECCION', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(166, '38918', 'BASCUGUIN, HEMINIANO DE LEON', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(167, '38926', 'EDEN, WILLIE VILLANUEVA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-10-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(168, '38951', 'CATAPANG, LEXTER RODRIGUEZ', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE', 'Nasugbu, Batangas', '2019-07-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(169, '38966', 'TAMOSA, ALEX YCO', 'N/A', 'N/A', 'Other', 'CODING TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-07-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(170, '38990', 'SAFRA, EDUARDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(171, '38991', 'MARTINEZ, HAROLD VERNON DUMAN', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(172, '38992', 'ULAYE, JOSELITO CABRAL', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(173, '38993', 'BUHAY, RODELIO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(174, '38994', 'MALANA, RYAL RAJ B', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(175, '38997', 'PITALIAR, JEREMY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(176, '38999', 'REYES, RONWALDO GABA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(177, '39028', 'MENDOZA, MARIOLINO C.', 'N/A', 'N/A', 'Other', 'COLORUM TRICYCLE - NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-07-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(178, '39059', 'BAUTISTA, HECTOR', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(179, '39061', 'DEREJE, JOBERT C', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(180, '39063', 'APOLINAR, CHRISTIAN PAUL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(181, '39064', 'TORRES, JERVIN RECINTO', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(182, '39065', 'DELOS REYES, ARVEE', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(183, '39066', 'JAVIER, SHIRWIN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(184, '39067', 'LUNDAG, MARIO JAVIER', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(185, '39070', 'JALICJIC, DAVE LYSTER', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(186, '39071', 'SIMUANGCO, ENRIQUE REYES', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(187, '39072', 'BASA, ERIC', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(188, '39072-2', 'BASA, ERIC .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(189, '39074', 'ERNA, ALLAN .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(190, '39078', 'JIONGCO, FELIZARDO JR. NEBRESE', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(191, '39081', 'ROXAS, FILINO ROWAL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(192, '39082', 'MENDOZA, JULIUS .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(193, '39085', 'HERJAS, GREGORIO PILIT', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(194, '39087', 'ILAGAN, GERARDO', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-08-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(195, '39088', 'MATALOG, LUDUVICO FRUNCTUSO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(196, '39089', 'AQUINO, BEVERLY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(197, '39090', 'CAPILI, JERRY BENTIR', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(198, '39091', 'CEBEDA, ALFREDO DELOS REYES', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(199, '39092', 'BENJERA, JERRY MAGSINO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(200, '39097', 'ROYO, JUNE MAR RUEDAS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(201, '39098', 'BLANZA, MYRA CONSIGO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(202, '39116', 'CALBAYAR, FRANCISCO C.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(203, '39117', 'ALEGADO, EUGENIO L.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(204, '39118', 'ROSARIO, RICHARD TIBAYAN', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-08-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(205, '39119', 'DEJOYA, ANGELO OBRADOR', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NO SIDE MIRROR', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(206, '39121', 'ROL, LUMERITO M', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(207, '39122', 'GALZA, GARY D', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(208, '39123', 'JURIAL, MARY JOYCE M', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-07-26', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(209, '39125', 'GADON, JOJO ROXAS', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-26', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(210, '39126', 'MABUNGA, MARIO CUPO', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(211, '39127', 'DE RAMA, MARVIN CERTEZA', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(212, '39130', 'DEMINGOY, JAMES JAY .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(213, '39131', 'MARASIGAN, JONNE P.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(214, '39132', 'RUBIO, MARCIANIO .', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(215, '39134', 'RUFO, ROLANDO ALABADO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2019-08-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(216, '39139', 'LABAY, RANDY STO THOMAS', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-08-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(217, '39141', 'CANDELARIA, BENITO GOMEZ', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-08-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(218, '39142', 'GABINETE, FEDERICK', 'N/A', 'N/A', 'Other', '2ND OFFENSE - ILLEGAL TERMINAL', 'Nasugbu, Batangas', '2019-08-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(219, '39143', 'SECONDEZ, AUGUSTO V', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(220, '39145', 'ROBLES, GILDO ASUNCION', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; REFUSAL TO SIGN TRAFFIC CIT. TICKET', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(221, '39146', 'BARTINA, ANDERSON REYES', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(222, '39151', 'MARQUEZ, JONER JOHN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(223, '39152', 'RUEDAS, MANUEL', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(224, '39154', 'ESTIPONA, BENIDICTO G.', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(225, '39155', 'CRUZ, JOHN BRYAN', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(226, '39156', 'DULUTAN, ARNEL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(227, '39157', 'CARAIG, ALFONSO GARCIA', 'N/A', 'N/A', 'Other', 'RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(228, '39158', 'RODRIGUEZ, MARIO JR. VILLAFANIA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(229, '39160', 'GUTTAN, FELECIANO DAQUIWAG', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(230, '39165', 'VILLAVEZA, ARNEL MANIBAY', 'N/A', 'N/A', 'Other', 'COLORUM JEEP, VAN BUS', 'Nasugbu, Batangas', '2019-08-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09');
INSERT INTO `violations` (`violation_id`, `ticket_number`, `driver_name`, `license_number`, `plate_number`, `vehicle_type`, `violation_type`, `violation_location`, `violation_date`, `violation_time`, `penalty_amount`, `input_method`, `encoded_by`, `status`, `created_at`, `updated_at`) VALUES
(231, '39166', 'BAYANI, ROBERTO A', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(232, '39167', 'RUFO, FRANCIS ABELLERA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-08-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(233, '39179', 'MAGNO, REYMON S', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(234, '39187', 'DITAUNON, JUDIE ALDAY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(235, '39197', 'REYES, DENNIES ILAO', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(236, '39198', 'CARPO, ARNEL HERNANDEZ', 'N/A', 'N/A', 'Other', 'FAILURE TO CARRY DRIVERS LIC.; NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(237, '39200', 'ROMA, RONATO', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(238, '39202', 'VALENCIA, ADRIAN MARASIGAN', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(239, '39205', 'ROTAIRO, PHILIP', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(240, '39206', 'RAMOS, MICHAEL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-07-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(241, '39208', 'CASTILLO, PEDRO B', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; LOI 1482', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(242, '39212', 'SEVILLA, RYAN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(243, '39213', 'BERNARDO, CARLO ADONA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-07-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(244, '39214', 'VIDAL, JAYBIE ARGEL MENDOZA', 'N/A', 'N/A', 'Other', '2ND OFFENSE - ILLEGAL PARKING; DISCOURTEOUS/ARROGANT DRIVER; DRIVING NOT WEARING SHOES; DRIVING W/SLEEVELESS SHIRT & SHORT', 'Nasugbu, Batangas', '2019-07-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(245, '39215', 'BACULI, WILLIAM CONCEPCION', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(246, '39216', 'PINEDA, CLARK GARCIA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-26', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(247, '39218', 'NICDAO, BINEDICK', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE; 2ND OFFENSE - NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-26', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(248, '39219', 'BAYANI, ROVELITO D.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(249, '39220', 'MORALES, KENZIE P', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(250, '39222', 'DEMAFELIX, ARIEL DELEGANZO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(251, '39225', 'BISIN, MICHAEL', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(252, '39226', 'OGERIO, DAVE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(253, '39227', 'PINEDA, RONNIE CUDIAMAT', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(254, '39228', 'DE JOYA, ARVEE', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(255, '39229', 'NORCIO, MAEIA HERNANDO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(256, '39230', 'PERERAS, ENRICO DACILLO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(257, '39239', 'BARCELON, RHAZEL CABUEN', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(258, '39240', 'BUTOR, MANUEL ERMITA', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-08-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(259, '39241', 'RIVERA, CHRITOPHER IAN CASTRO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(260, '39242', 'VILLANUEVA, ARTURO MANGUBAT', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(261, '39250', 'LABAY, RANDY SANTO TOMAS', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; OBSTRUCTION', 'Nasugbu, Batangas', '2019-08-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(262, '39253', 'PENAFLORIDA, HUSKY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(263, '39254', 'CAMAS, EDWIN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(264, '39255', 'RONDEN, FLORENTINO JR. BELARMINO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(265, '39258', 'MAGAMOS, FLAVIANO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(266, '39262', 'CUDIAMAT, MARK CHRISTIAN AGUILAR', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-08-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(267, '39263', 'CABRAL, RAFAEL TAYAB', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-08-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(268, '39269', 'CULAPO, RONNIE BOY CONCEPCION', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-09-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(269, '39270', 'SALANGUIT, SANCHO DE VERA', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-09-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(270, '39273', 'JANTOC, MICHAEL JOHN SOBREVILLA', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-09-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(271, '39274', 'BALBAR, MICHAEL JOHN RODRIGUEZ', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(272, '39275', 'LACSON, CHRISTIAN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(273, '39279', 'LIMOICO, CRISANYO LIMOICO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(274, '39280', 'MUÑOZ, MONTANO SUARIO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; ILLEGAL PARKING; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(275, '39283', 'CAILING, ANTONIO VELANIO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(276, '39288', 'MOLO, NOEL PONPON', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(277, '39293', 'SOLLESTRE, GERONIMO JR VILLADELREY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(278, '39294', 'PANGANIBAN, ADELAINDO DERAIN', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(279, '39296', 'BITUIN, ROSE MARIE', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(280, '39302', 'PELICANO, MOISES CONCEPCION', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(281, '39303', 'LAGUS, RODEL MONTEALEGRE', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-07-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(282, '39304', 'MAGBAGO, ENRICO CRUZADA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(283, '39306', 'LONGNO, STEVEN JAMES', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(284, '39307', 'MONALIS, JOHN PAUL G.', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; OVERLOADING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-07-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(285, '39309', 'BUENO, ARVIN .', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2019-08-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(286, '39310', 'MAULA, HERNANDO POLICARPIO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(287, '39314', 'TRAJICO, RONALD JR TUNAY', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(288, '39315', 'FERNANDEZ, DANILO MORTILLA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(289, '39317', 'DE GUZMAN, LEONY BAUTISTA', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-08-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(290, '39318', 'ENRIQUEZ, JOSEPH', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(291, '39319', 'ARQUINES, NELVIN VILLASANTA', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(292, '39320', 'MENDOZA, REGGIE ALVIZO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(293, '39324', 'DELOS SANTOS, FRANCIS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(294, '39330', 'PADILLA, CHRISTIAN CATAP', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(295, '39332', 'GUTIEREZ, ANNA RIZA RIVERA', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(296, '39333', 'DELA VEGA, TEODORO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(297, '39347', 'CABALAG, EDGARDO VELILA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(298, '39348', 'VILLAMOR, DANDRED INION', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(299, '39353', 'ESTERON, PAUL JOHN GODINEZ', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(300, '39358', 'VILLELA, ALRAY BANTRE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRIED; RECKLESS DRIVING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-12-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(301, '39412', 'ASESOR, JOHVANNY SARA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(302, '39413', 'ALBANIO, JOHN REY D.', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(303, '39414', 'SEVILLA, MARK ANGEL DE LOS REYES', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(304, '39416', 'VILLAMAS, PATRICK TRAJANO', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-08-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(305, '39418', 'DIMAANO, JOSELITO MOSQUETES', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(306, '39419', 'MERCADO, JOHN KENNEDY BADON', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(307, '39420', 'CARAIG, BEJORN CABADIN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(308, '39421', 'AGUIRRE, MARY JOY DAUBA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(309, '39423', 'CASAY, RODERICK V', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-08-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(310, '39429', 'ESPAYOS, JESSIE CAHAYON', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(311, '39430', 'LUTERTE, GEERONIMO ILAO', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(312, '39431', 'ROLLE, ZEAL ALLAN GATDULA', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(313, '39433', 'VILLAESTER, CHRISTIAN PANTOJA', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; DRIVING UNDER THE INFLUENCE OF LIQUOR; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-08-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(314, '39434', 'ANGELES, MARK JOSEPH PANGANIBAN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRIED', 'Nasugbu, Batangas', '2019-08-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(315, '39436', 'CANJA, JOEL BUGARIN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; RECKLESS DRIVING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(316, '39439', 'APILO, CHRISTIAN TUPAZ', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(317, '39441', 'DE OLASO, CARLOS MIGUEL RINOZA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(318, '39442', 'TAPALLA, REYNIEL COMIA', 'N/A', 'N/A', 'Other', 'DRIVING UNDER THE INFLUENCE OF LIQUOR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(319, '39447', 'BAUYON, JAYSON A', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(320, '39448', 'CANONOY, JOHN RUEL BANDAL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(321, '39450', 'SANTILLAN, MATEC MAGSAYO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(322, '39451', 'DELA VEGA, ROBERTO LEOPARDO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(323, '39452', 'ROLE, JACINTO DELEOS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(324, '39453', 'VILLAVIRAY, JOHN PAUL OGERIO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(325, '39454', 'GOSIENGFIAO, IRWIN CASTRO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(326, '39455', 'MARISANO, JAYSON DE JESUS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(327, '39456', 'RIVERA, VICTORIANA SUMANGUID', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(328, '39457', 'GABANAN, GANE PALACIO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(329, '39458', 'DECILOS, NEIL JOHN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(330, '39467', 'DUEÑAS, NIÑO PINOHERMOSO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(331, '39469', 'SANER, JOHN CARLO GATDULA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(332, '39470', 'MARASIGAN, AMELITA GABILO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(333, '39485', 'DELA ROSA, HERNA A.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(334, '39490', 'AZORES, MARCELINO MANDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(335, '39492', 'CABALAG, BERLITO DIPDIPIN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(336, '39496', 'DITAN, MERNA M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(337, '39498', 'BALCE, ARNULFO PADIERNOS', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(338, '39502', 'BULANHAGUI, LORETO PANALIGAN', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-08-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(339, '39507', 'BAUSAS, ELMER NAYAT', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(340, '39508', 'DAIGDIGAN, LEODIGARIO BALANI', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(341, '39511', 'DE LAS ALAS, EDRIAN DE OCAMPO', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-09-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(342, '39512', 'CASILIHAN, JERWIN BLANCA', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(343, '39513', 'VILLA, RENATO SACAYAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(344, '39516', 'DELAS ALAS, JAYVEE PUNONG BAYAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(345, '39517', 'GARCIA, EFREN SANGALANG', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(346, '39521', 'GAZO, JHERWIN', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(347, '39526', 'DELOS REYES, FLORDELIZA LOTINO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(348, '39531', 'HERNANDEZ, JOEL SALANGUIT', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(349, '39534', 'SALANGUIT, RODELIO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(350, '39553', 'LIMETA, CARLO LONGOY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-08-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(351, '39557', 'BAUTISTA, LEOMAR RODRIGUEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(352, '39558', 'MANALO, RODANTE OYALDA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(353, '39564', 'CASANOVA, MC NIEL MERCADO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(354, '39577', 'SEVILLA, LESTER LAURIO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(355, '39578', 'PUNONGBAYAN, MAHIEZ.', 'N/A', 'N/A', 'Other', 'NO CANVASS COVER-TRUCK', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(356, '39580', 'MAROTO, ROMEO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(357, '39581', 'SARAZA, FELICISIMO TRAVIEZO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(358, '39582', 'HIRADO, CHRISTOPHER MENDOZA', 'N/A', 'N/A', 'Other', 'LOI 1482; NO DRIVERS LICENSE; OR/CR NOT CARRIED', 'Nasugbu, Batangas', '2019-11-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(359, '39583', 'RAMOS, ISAIAS JR. DELA CRUZ', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-11-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(360, '39584', 'BALADIANG, JAMESWEL SARAZA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-11-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(361, '39587', 'HABAN, JAY AR BAYANI', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL', 'Nasugbu, Batangas', '2019-12-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(362, '39602', 'DELA VEGA, JAYPEE ALBANIO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(363, '39610', 'DONATO, KIMBERLY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-09-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(364, '39613', 'PALO, RAMPE REÑOS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(365, '39614', 'DIAGO JR., VALENTIN AMBION', 'N/A', 'N/A', 'Other', 'DRIVING NOT WEARING SHOES; DRIVING UNDER THE INFLUENCE OF LIQUOR; DRIVING W/SLEEVELESS SHIRT & SHORT; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-09-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(366, '39615', 'SANTANDER, REYNANTE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; OBSTRUCTION', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(367, '39616', 'AGUILAR, SHERWIN ORTEGA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; OBSTRUCTION', 'Nasugbu, Batangas', '2019-09-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(368, '39618', 'BARCELON, JULIUS ANDOR', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; OBSTRUCTION', 'Nasugbu, Batangas', '2019-09-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(369, '39621', 'BAUTISTA, MELCHOR GARCIA', 'N/A', 'N/A', 'Other', 'DRIVING UNDER THE INFLUENCE OF LIQUOR; ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(370, '39622', 'SUAREZ, ANGELITO RUEDAS', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(371, '39623', 'RONAS, KEN ROVIC', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(372, '39624', 'RAFADA, IAN HUMPHREY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-09-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(373, '39626', 'ENRIQUEZ, JESSIE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(374, '39627', 'ROXAS, NIEL VINCENT', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-09-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(375, '39651', 'DIOQUINO, DANIEL CARATIQUIT', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(376, '39655', 'CATAPANG, ALBERT', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(377, '39658', 'ROL, MARCELINO.', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(378, '39660', 'ENCENARES, JERON JACOBE', 'N/A', 'N/A', 'Other', 'RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(379, '39662', 'CUENCA, DARWIN RAMOS', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(380, '39664', 'CATAPANG, LEXTER RODRIGUEZ', 'N/A', 'N/A', 'Other', '3RD OFFENSE - COLORUM TRICYCLE / IMPOUND TRICYCLE; TAMPERED STICKER N.C.O.', 'Nasugbu, Batangas', '2019-11-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(381, '39665', 'ROMARATE, JUANCHO SANTOS', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-26', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(382, '39667', 'MATALOG, JUN', 'N/A', 'N/A', 'Other', 'DRIVING W/SLEEVELESS SHIRT & SHORT; NO DRIVERS LICENSE; OR/CR NOT CARRIED', 'Nasugbu, Batangas', '2019-12-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(383, '39670', 'DONOR, NORMAN HERNANDEZ', 'N/A', 'N/A', 'Other', 'DRIVING W/SLEEVELESS SHIRT & SHORT; ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-03-03', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(384, '39702', 'REGENCIA, REYNALDO RICAMARA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(385, '39703', 'MASANGKAY, ADRIAN .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(386, '39704', 'SALANIO, EMIL BABAISON', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(387, '39706', 'BRIVA, JULIUS A', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(388, '39710', 'PASIA, MARIO.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(389, '39713', 'NUEVE, BERNABE ARIOLA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(390, '39715', 'PITALLAR, CARLOS.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(391, '39717', 'BOTOBARA, JAY-R', 'N/A', 'N/A', 'Other', 'FAILURE TO CARRY DRIVERS LIC.; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(392, '39719', 'MASANGKAY BERNABE CONCEPCION', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(393, '39721', 'PUJANTE, FLORENTINO PASNO', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(394, '39723', 'TRAVIEZO, JOHN CHRISTOPHER', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(395, '39725', 'COLANGCO, BENBENIDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-12-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(396, '39731', 'GABRIEL, JOHN ALDRIN DERAIN', 'N/A', 'N/A', 'Other', 'OBSTRUCTION; RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-12-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(397, '39751', 'DIMAALA, ROLANDO ALMIN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(398, '39752', 'VECINAL, RODEL', 'N/A', 'N/A', 'Other', '2ND OFFENSE - ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(399, '39756', 'MALINAY, PAMFILO LIQUE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(400, '39759', 'MARASIGAN, MALON BUHAY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(401, '39762', 'EVANGELISTA, RUELITO FAYTAREN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(402, '39763', 'DIÑO, ERIC ANIEL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(403, '39766', 'MARANAN, EDUARDO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(404, '39767', 'DELIOLA, VERGILIO ZARATE', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(405, '39768', 'CASILIHAN, FERNANDO DE GUZMAN', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(406, '39771', 'FERNANDEZ, DANILO MORTILLA', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(407, '39778', 'MAGADA, MARGARITO M.', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-12-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(408, '39780', 'TEVES, LEONITO SELGAS', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-12-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(409, '39787', 'UMANDAL, JONATHAN ROLLON', 'N/A', 'N/A', 'Other', 'FAILURE TO CARRY DRIVERS LIC.', 'Nasugbu, Batangas', '2020-02-26', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(410, '39798', 'VILLAJUAN, RODERICK MARFIL', 'N/A', 'N/A', 'Other', '2ND OFFENSE - CODING NUMBER CODING ORDINANCE; STUDENT PERMIT NOT ACCOMPANIED BY LICENSED DRIVER', 'Nasugbu, Batangas', '2020-03-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(411, '39805', 'MENDOZA, ORLANDO A', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(412, '39807', 'MANDAK, ANTONIO R', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED; RA 4136; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(413, '39811', 'ACOSTA, JOSEPATTERNC VIDAL', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(414, '39811-2', 'ACOSTA, JOSEPATTERNO VIDAL', 'N/A', 'N/A', 'Other', 'FAILURE TO CARRY DRIVERS LIC.', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(415, '39814', 'MOTOS, CARLO .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(416, '39816', 'CHUA, ZEUS .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(417, '39818', 'ECOY, JOHN KELVIN ORTIZO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(418, '39820', 'BAUSAS, ELMER NAYAT', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(419, '39821', 'AGUILA, WILBRYAN', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(420, '39822', 'GUEVARRA, CRISANTO VILLADELREY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(421, '39825', 'MASIPAG, ROLLY SOBRADO', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(422, '39827', 'VICEDO, JIMMY CAHAYON', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OVERLOADING', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(423, '39830', 'CORDERO, JUSTIN', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2019-11-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(424, '39832', 'VILLAMIN, MARILOU DELA CRUZ', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-11-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(425, '39833', 'BAYANI, JASON', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(426, '39834', 'BAYANI, GRACIANO GUERNALDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(427, '39836', 'AURELIO, RENEBOY MERCADO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(428, '39837', 'MENDOZA, EDUARDO ALANO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(429, '39838', 'ROSALES, RONEL VICTOR', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(430, '39840', 'SALAO, DENNIS GRANADOS', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(431, '39841', 'CABALI, CHRISTIAN DE JESUS', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(432, '39843', 'DULUTAN, RUFERTO ULARTE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRIED', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(433, '39847', 'DIGMA, REYMART MORTIR', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(434, '39851', 'MANGALILI, ARVIN VILLADELREY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(435, '39852', 'MORALES, ARISTEO VIADO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(436, '39853', 'MAGTIBAY, ROMAN OGERIO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(437, '39854', 'JONSON, ALBERTO NIEVE', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; FAILURE TO CARRY DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(438, '39857', 'SALANGUIT, ARMANDO VASQUEZ', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(439, '39858', 'CADIENTE, ESTELITO MANINGAT', 'N/A', 'N/A', 'Other', 'FAILURE TO CARRY DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(440, '39859', 'ANZALDO, LUCILO HERNANDEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(441, '39864', 'LOZANO, GENEROSO BUGAGAO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(442, '39865', 'VILLEGAS, ROSALITO JR. BIDAS', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(443, '39866', 'BASCUGUIN, EUGENIO SUMANGUID', 'N/A', 'N/A', 'Other', 'FAILURE TO CARRY DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(444, '39867', 'CIRACON, JULIUS PERIO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(445, '39868', 'SEVILLA, RENATO BERSAMINA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(446, '39871', 'URGE, JAIME DELA VEGA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; STUDENT PERMIT NOT ACCOMPANIED BY LICENSED DRIVER', 'Nasugbu, Batangas', '2019-11-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(447, '39872', 'BENZITO, ABELARDO APILAN', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(448, '39873', 'CARAIG JR., ERNESTO BOTONES', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(449, '39874', 'IRAHAM, JIKIRAN', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(450, '39876', 'MANDEA, FERNANDO B', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(451, '39881', 'MERCADO, JOEL LAINEZ', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(452, '39882', 'PALO, ROMEC HERNANDEZ', 'N/A', 'N/A', 'Other', '2ND OFFENSE - CODING NUMBER CODING ORDINANCE', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(453, '39884', 'VILLANUEVA, LUIS APOLONIA', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(454, '39886', 'BAUSAS, RODEL SANCHES', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09');
INSERT INTO `violations` (`violation_id`, `ticket_number`, `driver_name`, `license_number`, `plate_number`, `vehicle_type`, `violation_type`, `violation_location`, `violation_date`, `violation_time`, `penalty_amount`, `input_method`, `encoded_by`, `status`, `created_at`, `updated_at`) VALUES
(455, '39887', 'BALENTON, FELIX MENDOZA', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2019-11-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(456, '39888', 'ROMARATE, FERNANDO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(457, '39890', 'MELGAR, ELMER ROLOMER', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(458, '39891', 'ANDAYA, EXEQUIEL MARTINEZ', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(459, '39893', 'VILLAFRANCA, WILLY', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(460, '39904', 'RAMIREZ, PRINCE BAUTISTA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-10-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(461, '39908', 'GARCIA, JOHN CARLO BALBOA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(462, '39910', 'BOSA, ARNEL VITALES', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(463, '39914', 'LASCANO, REYNALDO HERNANDO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; 3RD OFFENSE - COLORUM TRICYCLE / IMPOUND TRICYCLE', 'Nasugbu, Batangas', '2019-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(464, '39916', 'MAGTIBAY, TEODOLFO PANALIGAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(465, '39919', 'PANTOJA, JAY-AR LOZADA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(466, '39920', 'ATIENZA, CRISPIN G.', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2019-10-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(467, '39923', 'APALE, JOEL HINAOT', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(468, '39935', 'BUTIONG, MARVIN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(469, '39936', 'COLAWAY, ROBERT SAN AGUSTIN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(470, '39937', 'AGUILAR, MARVIN CHOSA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(471, '39938', 'CASAYURAN, RUEL PERLADA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(472, '39940', 'SALAS, MARVIN VILLEGAS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(473, '39942', 'SISON, CARLITO MENDOZA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-10-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(474, '39946', 'ABELLO, COPER MATA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(475, '39952', 'VILLAVIRAY, FERNANDO .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(476, '39960', 'DE GUZMAN, JERIC BULUSAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(477, '39965', 'SARAZA, MARCELO CABATIAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(478, '39973', '. , AMBROCIO VILLAFRANCA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(479, '39976', 'FACTOR, JOHN VINCENT TACTAY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(480, '39977', 'CARAYAG, NIEL PATRICK CORPUZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(481, '39978', 'MARANAN, MENARDO ROMANES', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(482, '39979', 'DE LEON, DOMINADOR ZAFRA', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(483, '39980', 'ARELLANO, CHISTOPHER AQUINO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(484, '39981', 'GONZALES, JOEBERT.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(485, '39982', 'DESACOLA, BARTOLOME CAISIP', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(486, '39985', 'ARAÑEZ, LINO JEFF GLORY', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(487, '39986', 'DIMAAYAO, YASSER SACAR', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(488, '39987', 'TAPICAN, JAY-AR I', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(489, '39988', 'PANALIGAN, JEFFREY PASTOR', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(490, '40002', 'ULARTE, NIÑO CABALLES', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(491, '40003', 'DIGNO, JOHN MARK', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(492, '40006', 'SOBREMONTE, MARK ANTHONY', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(493, '40010', 'OCOMA, CHRISSEN CARAIG', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(494, '40011', 'LAGUARDIA, ERWIN .', 'N/A', 'N/A', 'Other', 'DRIVING UNDER THE INFLUENCE OF LIQUOR; NO DRIVERS LICENSE; OR/CR NOT CARRRIED; RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(495, '40012', 'LAPARAN, REDELIC BENITEZ', 'N/A', 'N/A', 'Other', 'DRIVING UNDER THE INFLUENCE OF LIQUOR; NO DRIVERS LICENSE; OR/CR NOT CARRRIED; RECKLESS DRIVING', 'Nasugbu, Batangas', '2019-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(496, '40013', 'ALEROZA, ANTONIO MACALALAD', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(497, '40015', 'URIARTRE, JEFFREY AVENIDA', 'N/A', 'N/A', 'Other', 'DRIVING NOT WEARING SHOES; NO DRIVERS LICENSE; NO HELMET', 'Nasugbu, Batangas', '2019-10-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(498, '40019', 'CANARIA, LEONARD', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(499, '40023', 'MANALO, JOVITO DIMAALA', 'N/A', 'N/A', 'Other', 'DRIVING UNDER THE INFLUENCE OF LIQUOR; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(500, '40025', 'VILLAFANIA, BRYAN MAGUILIMAN', 'N/A', 'N/A', 'Other', 'DRIVING UNDER THE INFLUENCE OF LIQUOR; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-12-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(501, '40032', 'PASTOR, ELWIN ANTHONY SIRAY', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-12-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(502, '40033', 'BALBAR, FREDERICK MAXIMILIAN SANTIAGO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-12-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(503, '40037', 'SUMANGUID, JOMAR ROMA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-12-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(504, '40039', 'CUPO, SIMON PETER NERI', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-12-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(505, '40042', 'BALASI, WINIFREDO SAMONTE', 'N/A', 'N/A', 'Other', 'OR/CR NOT CARRRIED; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-12-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(506, '40045', 'MENDOZA, NILO FAUSTINO', 'N/A', 'N/A', 'Other', 'OR/CR NOT CARRRIED; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-12-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(507, '40049', 'CASTILLO, GINALYN CREDITO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2019-12-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(508, '40050', 'ROMULO JR, ANTERO CALIMAG', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-12-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(509, '40052', 'PALIMA, LIGAYA', 'N/A', 'N/A', 'Other', 'FAILURE TO CARRY DRIVERS LIC.; ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(510, '40055', 'ABELLO, COPER MATA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-10-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(511, '40056', 'SIMUANGCO, ENRIQUE REYES', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2019-10-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(512, '40061', 'LAGTO, NESTOR', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(513, '40067', 'GONCE, FLORANTE CABILLETE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(514, '40072', 'ESCAREZ, RUBEN SAMOLDE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(515, '40073', 'ACEDILLO, JOHN ANGELO GAMEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(516, '40074', 'VIVAS, JHUN JHUN SALAS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(517, '40081', 'LIRASAN, MARIO SALANGUIT', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(518, '40082', 'ENDOZO, RIZALINA.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-10-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(519, '40088', 'TORRES, ERICKSON ROL', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(520, '40090', 'PLOPINO, JOHN ALBERT SOBREVILLA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(521, '40091', 'BOLINTIAM, RAFAEL MENDOZA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(522, '40093', 'RIVERA, CHRISTOPHER IAN CASTRO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-11-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(523, '40097', 'VILLANUEVA, EFREN VILLAFLOR', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(524, '40107', 'MENDOZA, FREGADO BAYAN', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(525, '40108', 'RIEGO DE DIOS, FRANCISCO V', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2019-10-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(526, '40116', 'GONZALES, BRYAN JOE URIARTE', 'N/A', 'N/A', 'Other', 'NO SIDE MIRROR; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-10-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(527, '40117', 'MARANAN, MARVIN GALO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-10-31', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(528, '40121', 'NUEVE, ARIEL UMALI', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; DRIVING NOT WEARING SHOES; DRIVING W/SLEEVELESS SHIRT & SHORT; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(529, '40122', 'DAGUMAN, RODIZA CORNELIO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(530, '40125', 'MANALO, ELMER ENRIQUEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2019-11-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(531, '40134', 'PANGANIBAN, SEDRICK MAHUSAY', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2019-12-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(532, '40136', 'LAGRISOLA, NESTOR LAYON', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2019-12-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(533, '40154', 'CASTILLO, RYAM MANALO', 'N/A', 'N/A', 'Other', 'OR/CR NOT CARRIED', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(534, '40159', 'IGANA, ARIS GASIC', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(535, '40160', 'BUSALPA, AIRON CABANLIG', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2019-11-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(536, '40163', 'CABRIDO, ALBERT DARREN VECINAL', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2019-11-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(537, '40164', 'CARAIG, CATALINO MERCADO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(538, '40166', 'MONTON, JUSIAH SEVILLA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-11-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(539, '40174', 'MANAL, MICHAEL OGERIO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2019-12-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(540, '40206', 'GARCIA, MANILYN ULARTE', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; FAILURE TO CARRY DRIVERS LIC.', 'Nasugbu, Batangas', '2019-11-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(541, '40214', 'VISPERAS, RONALDO ALBAY', 'N/A', 'N/A', 'Other', 'NO PROF. DRIVER (OPTR.PUV, HEAVY EQ, AGRI. MACH)', 'Nasugbu, Batangas', '2020-02-04', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(542, '40228', 'DE VILLA, VICTOR VILLAFRANCA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-02-27', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(543, '40235', 'PANGANIBAN, NOEL LAMIO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2020-03-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(544, '40237', 'DELLEOPAC, VINCENT ALDWIN GO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-03-03', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(545, '40241', 'ANIANO, ANIANO VILLAFRANCA', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-03-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(546, '40242', 'ORETA, MICHAEL RAMIREZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-03-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(547, '40243', 'DELOS REYES, BRYAN E.', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-03-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(548, '40244', 'LUTAO, EDGARDO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(549, '40245', 'BAUTISTA, RAYMUNDO TALADRO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(550, '40249', 'ALENSUAS, RAUL ABEJO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(551, '40269', 'DE GULA, JOSHUA.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(552, '40272', 'ANDINO, ARNEL CAMACHO', 'N/A', 'N/A', 'Other', 'LOI 1482', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(553, '40364', 'GALIT, EDGAR HOMER', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-02-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(554, '40483', 'HILARIO, HILARIO ANDAYA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-02-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(555, '40497', 'CASAS, ROVIC JOHN SERNA', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; OR/CR NOT CARRRIED; RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-08-03', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(556, '40499', 'WAGE, KIM RUSTY ROMANES', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-08-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(557, '40560', 'ALINDUGAN, RAYMOND', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(558, '40564', 'DE LEON, MARK', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(559, '40566', 'LISNIANA, MICHAEL MORRIES', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(560, '40567', 'RUFO, RAYMUNDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(561, '40572', 'ARIOLA, FRANCISCO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(562, '40574', 'BAUTISTA, MAR.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(563, '40575', 'VILLAJUAN, JAY-AR PEREZ', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(564, '40577', 'URGE, ARVY TROY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(565, '40622', 'DELERA, JULIAN JR P', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-02-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(566, '40628', 'UMANDAL, JAYSON ADOPTANTE', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-02-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(567, '40629', 'BARCELON, CHRISTIAN RUFO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-02-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(568, '40676', 'BUEN, ALLANE DUHAN', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-01-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(569, '40683', 'RODRIGO, JAIME', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-02-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(570, '40683-2', 'RODRIGO, JAIME.', 'N/A', 'N/A', 'Other', 'NUISANCE MUFFLER/34J; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-02-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(571, '40691', 'COMBRAS, BRIAN BAYONETO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-03-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(572, '40758', 'ALVIZO, KIM ROGER', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(573, '40760', 'BUENAVENTURA, ROMEO VILLACRUSIS', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(574, '40762', 'ILAO, ROLDAN C.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(575, '40763', 'EPARWA, ED VINCENT CUEVAS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(576, '40768', 'CONSIGO, LORIE JOY HERNANDEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(577, '40769', 'TANGLAO, ARNELITO SANTOS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(578, '40804', 'PASTOR, RONILO D.', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-02-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(579, '40817', 'ARIOLA, CARLIE CONSTANTINO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O', 'Nasugbu, Batangas', '2020-03-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(580, '40828', 'GOMEZ, RCHARD C', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2020-03-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(581, '40829', 'CAMILO, ROLANDO JR VISTO', 'N/A', 'N/A', 'Other', 'COLORUM TRIC.-N.C.O; STUDENT PERMIT NOT ACCOMPANIED BY LICENSED DRIVER', 'Nasugbu, Batangas', '2020-03-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(582, '40830', 'PARAISO, NICANOR CASAYSAYAN', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2020-03-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(583, '40832', 'URGE, JAIME DELA VEGA', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE; [ILLEGIBLE - verify]', 'Nasugbu, Batangas', '2020-03-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(584, '40833', 'HERNANDEZ, JOHN JAYSEN VENTURA', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2020-03-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(585, '40835', 'CABAYA, LEO', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O; STUDENT PERMIT NOT ACCOMPANIED BY LICENSED DRIVER', 'Nasugbu, Batangas', '2020-03-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(586, '40843', 'VECINAL, ERIC MENDOZA', 'N/A', 'N/A', 'Other', 'LOI 1482; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(587, '40845', 'PADILLA, ISAGANI', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(588, '40846', 'BENGCANG, BERNARDO HERNANDEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(589, '40847', 'SARMIENTO, ALBERTO C.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(590, '40848', 'BUTIONG, RIALYN M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(591, '40849', 'CABALI, DOMINADOR FRONDA', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(592, '40852', 'DE LUNAS, EREBERTO CUDIAMAT', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2020-03-11', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(593, '40853', 'NAS, ALVER JR NOYNAY', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; OBSTRUCTION', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(594, '40903', 'CARRIEDO, AARON RAMIREZ', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; REFUSAL TO SIGN TRAFFIC CIT.TICKET', 'Nasugbu, Batangas', '2020-02-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(595, '40951', 'TARRAS, HERNANDO JR.', 'N/A', 'N/A', 'Other', 'NO ER(OPTR.PUV,HEAVYEQI AGRI. MACH)', 'Nasugbu, Batangas', '2020-02-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(596, '41011', 'ULARTE, ISRAEL M.', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-03-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(597, '41017', 'SABLE, JEFFREY C.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-03-10', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(598, '41018', 'BAYABORDA, NENITA VILLALUNA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-03-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(599, '41019', 'ILAO, JUAN CABALLES', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2020-03-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(600, '41020', 'MENDOZA, RODELIO DE LEOLA', 'N/A', 'N/A', 'Other', 'DRIVING NOT WEARING SHOES; DRIVING W/SLEEVELESS SHIRT & SHORT', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(601, '41021', 'GARCIA, JAY SANGALANG', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(602, '41022', 'DIME, CELSO COYAGAN', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(603, '41023', 'AYALA, MARIC CABALFIN', 'N/A', 'N/A', 'Other', '2ND OFFENSE - COLORUM TRICYCLE', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(604, '41024', 'HELIS, LITO ANDA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(605, '41033', 'BINUYA, ALEXANDER SANTOS', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE; RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-07-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(606, '41035', 'COMIA, RENATO DELOS REYES', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-08-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(607, '41036', 'VILLAJIN, LEMUEL MORALES', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(608, '41041', 'PALARAN, JUNMAR FLORENTINO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(609, '41043', 'BASCUGUIN, CHISTIAN R.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(610, '41046', 'BANGUITO, CHRISTOPHER', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(611, '41055', 'GUEVARRA, MANUEL AQUINO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-03-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(612, '41056', 'MORAGA, ERIC LAGRISOLA', 'N/A', 'N/A', 'Other', 'CODING TRIC.-N.C.O', 'Nasugbu, Batangas', '2020-03-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(613, '41057', 'CELSO, MARVIN MALINAY', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-03-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(614, '41061', 'CARANDANG, RUEL ALARAS', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-03-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(615, '41082', 'VISTO, EDWIN RIVERA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(616, '41084', 'CINCO, JOHN EDWARD .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(617, '41085', 'MALINAY, TEODORO LAPARAN', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(618, '41090', 'HUANG, ZHIZUO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; OBSTRUCTION', 'Nasugbu, Batangas', '2020-09-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(619, '41091', 'MERHAN, JAYSON.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2020-09-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(620, '41093', 'VALENCIA, KIER R.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(621, '41094', 'PAYTAREN, ALBERT V.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(622, '41095', 'GRIMPOLA, WILFRED .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(623, '41096', 'CONSIGO, JENNIFER .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(624, '41098', 'SOL, JAMES JULIUS VILLAREAL', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(625, '41099', 'RODRIGUEZ, ANTHONY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(626, '41109', 'PAGARA, MARVIN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(627, '41110', 'VERGARA, ERMAN ELIZAGA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(628, '41111', 'LAPARAN, EDWIN SANCHEZ', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(629, '41119', 'DELAYOLO, EVANGELINE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(630, '41120', 'REYES, JESUS CALINGASAN', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(631, '41121', 'BARTINA, MERLIN REYES', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(632, '41123', 'LIZARDO, JEFFREY CADAPAN', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(633, '41126', 'VILLALOBOS, ROBIN JOHN BASIT', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(634, '41128', 'SEDANO, KENNETH PEREZ', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(635, '41129', 'IBHAR, TORIBIO LAING', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(636, '41132', 'MAMPARO, MC MARVIN PANGANIBAN', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.; NO SIDE MIRROR; OBSTRUCTION; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(637, '41134', 'MONTEALEGRE, DELMAR .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(638, '41203', 'MALONZO, ALDRIN LUCES', 'N/A', 'N/A', 'Other', 'ILLEGAL TERMINAL', 'Nasugbu, Batangas', '2020-09-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(639, '41204', 'CARAIG, JULIUS D.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(640, '41205', 'BANNUA, JESSA I.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(641, '41214', 'BULAKLAK, RODRIGO ROSEL', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(642, '41215', 'DE PAZ, RONEL L.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-17', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(643, '41217', 'JALICJIC, DANILO M.', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(644, '41218', 'JOEL, SAMONTE OGERIO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(645, '41219', 'DIMAFELIX, CRISPULO JR AQUINO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(646, '41220', 'HERNANDEZ, MA. CICILIA B.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(647, '41221', 'RAMOS, FRANCISCA M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(648, '41224', 'MENDOZA, RYAN REY .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(649, '41225', 'BAYANI, JONABETH', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(650, '41227', 'HERNANDEZ, RANDY A.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(651, '41228', 'MACALINDONG, VIRGILIO SIERRA', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; DRIVING NOT WEARING SHOES; DRIVING W/SLEEVELESS SHIRT & SHORT; OPERATING OUT OF LINE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(652, '41229', 'HERNANDEZ, ERNESTO L.', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(653, '41230', 'PAMA, BRYAN', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(654, '41231', 'MALINAY, FLORANTE B.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(655, '41232', 'MADRIGAL, BILLY JANE M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(656, '41238', 'DELEOLA, RAMON CABASIS', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; DRIVING NOT WEARING SHOES; DRIVING UNDER THE INFLUENCE OF LIQUOR; DRIVING W/SLEEVELESS SHIRT & SHORT; ILLEGAL PARKING; OBSTRUCTION; REFUSAL TO SIGN TRAFFIC CIT.TICKET', 'Nasugbu, Batangas', '2020-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(657, '41239', 'OBRADOR, JAYSON D.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(658, '41240', 'DIKIT, EMMANUEL I', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(659, '41242', 'FAMERONAG, DAVE M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(660, '41243', 'AVELINO, MARVIN A', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(661, '41244', 'MAGTIBAY, ROMAN OGERIO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(662, '41245', 'BELTRAN, RAYMUNDO A.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(663, '41246', 'CAJAYON, REWAL L', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; ILLEGAL PARKING; NO DRIVERS LICENSE; REFUSAL TO SIGN TRAFFIC CIT. TICKET', 'Nasugbu, Batangas', '2020-09-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(664, '41250', 'BARLOSO, WILLIAM S.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(665, '41251', 'TIN, ALFREDO CAUSAY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(666, '41253', 'BUISING, ANTHONY .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(667, '41255', 'BENJERA, ALLAN P.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-18', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(668, '41256', 'CUDIAMAT, BERNARDO AGKIS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(669, '41257', 'CONTRERAS, ERENIA .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(670, '41257-2', 'CONTRERAS, ERENIA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(671, '41258', 'GUTIERREZ, JAY R M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(672, '41259', 'MARASIGAN, AMELITA GABILO', 'N/A', 'N/A', 'Other', '2ND OFFENSE - ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(673, '41260', 'NOBINO, JETHLIE BIO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(674, '41261', 'ESPENILE, MARK ANTHONY SAPITAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(675, '41264', 'MALIJAN, JOHN MICHAEL VINALES', 'N/A', 'N/A', 'Other', 'RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(676, '41266', 'LAMANO, PHILIP JR. MARANAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(677, '41269', 'AGUILA, LENY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(678, '41270', 'MALABANAN, ZOILO B.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(679, '41271', 'AVENA, CRISANTO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(680, '41272', 'ALVAREZ, VALERIANO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OBSTRUCTION', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(681, '41274', 'MAGSINO, MARK LOUIBEARO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09');
INSERT INTO `violations` (`violation_id`, `ticket_number`, `driver_name`, `license_number`, `plate_number`, `vehicle_type`, `violation_type`, `violation_location`, `violation_date`, `violation_time`, `penalty_amount`, `input_method`, `encoded_by`, `status`, `created_at`, `updated_at`) VALUES
(682, '41276', 'CARAIG, MA. SOLITA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-22', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(683, '41280', 'CAHAYON, FELICISIMO ADONA', 'N/A', 'N/A', 'Other', '2ND OFFENSE - OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(684, '41282', 'GUEVARRA, SIMPLICIO MACALALAD', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(685, '41283', 'PACIONA, DEMETRIC COSTACIO', 'N/A', 'N/A', 'Other', 'OBSTRUCTION', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(686, '41284', 'SACYAN, MICHAEL V.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(687, '41285', 'POLO, NOEL .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(688, '41288', 'DELA VEGA, WILFRED OCTA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(689, '41291', 'SILVERIO, EJERCITO CASTRO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(690, '41292', 'JONSON, ANACITO JARA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(691, '41293', 'HERNANDEZ, CHRISTOPHER VILLADELREY', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(692, '41294', 'CARANDANG, ROMEO ALAER', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(693, '41301', 'DELA CRUZ, LEA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(694, '41302', 'CAPACIA, RONALD QUINCY M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(695, '41303', 'AMON, ANGEL', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-23', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(696, '41305', 'DE VILLA, MANOLITO.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(697, '41306', 'DIGNO, GERALDO LIAMZON', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(698, '41307', 'BETIS, BETIS BELME', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-25', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(699, '41308', 'VILLANUEVA, RALPH ABIOG', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(700, '41310', 'BASIT, JOHN MARK DEMECILLO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(701, '41311', 'SEVILLA, ELLEN CAUCERAN', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(702, '41312', 'BAUTISTA, FERNANDO MORALES', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(703, '41314', 'BILAN, REYGAN', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(704, '41315', 'LAGUARDIA, ROSANO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-09-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(705, '41316', 'VASQUEZ, TEODORO BAGUNAS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-09-30', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(706, '41326', 'ATA, MANUEL', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(707, '41327', 'DINGOL, FRANCIS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(708, '41328', 'ALIX, CRIS', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(709, '41330', 'GAZINGAN, MYLENE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(710, '41331', 'ENRIQUEZ, REYMUND ROMA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(711, '41333', 'ORDONIA, VIRGINIA T.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(712, '41334', 'AYLES, TEODORA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(713, '41336', 'CARAIG, ANGELICA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(714, '41337', 'CUNANAN, ANDY VILLANUEVA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(715, '41338', 'CORPIN, EMMAN JR. DEMAFELIX', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(716, '41339', 'LAGUARDIA, RAMON C', 'N/A', 'N/A', 'Other', 'LOI 1482; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(717, '41341', 'DONOR, JASON MAGNO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(718, '41342', 'ORTEGA, ARNEL', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(719, '41343', 'BENEBECE, BENJAMIN.', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(720, '41351', 'BASCO, RAFFY PEREZ', 'N/A', 'N/A', 'Other', 'DRIVING UNDER THE INFLUENCE OF LIQUOR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-09-28', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(721, '41356', 'VILLENA, RAINFER C.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(722, '41358', 'VIADO, ROMEO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(723, '41360', 'SULIMAN, HURLIE P', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(724, '41406', 'RILLORAZA, JOSEPH ROMARATE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-02', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(725, '41407', 'ZACARIAS, MAURO CAPACIA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-05', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(726, '41409', 'BACOMO, ALBERT.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(727, '41410', 'CASTANO, JEMART.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(728, '41411', 'SEVILLA, GARRY.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(729, '41412', 'DELAS ALAS, LEANDRO.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(730, '41413', 'AQUINO, ROLIRICK MARANAN', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(731, '41414', 'MARISTELA, JULIAN SANCHEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(732, '41417', 'MARANAN, MANUEL MARTINEZ', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE; REFUSAL TO SIGN TRAFFIC CIT. TICKET', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(733, '41418', 'VALEROS, DESIDERIO MILLARE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(734, '41421', 'SALE, ERICA SOBREMONTE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(735, '41422', 'JONSON, LUISITO .', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(736, '41423', 'HERNANDEZ, MARRY JOY .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(737, '41424', 'ATENTAR, ALDRIN ZAMORA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(738, '41429', 'COCHINGCO, FERNANDO ARRIOLA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(739, '41431', 'GATDULA, ROVIC M.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(740, '41432', 'GAANAN, ROMELITO IGOS', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(741, '41433', 'MARANAN, VOSEPH .', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(742, '41434', 'HERNANDEZ, RONEL OLIVAR', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(743, '41435', 'LAGTU, MARK ANTHONY .', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(744, '41439', 'BAUTISTA, VIVENCIO DIOQUINO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(745, '41440', 'OCOMA, JESSEN.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(746, '41441', 'BACIT, MARVIN ALDAY', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(747, '41446', 'GUIRIBA, ALFRED L', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRIED', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(748, '41448', 'DELIOLA, BERNADETH', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(749, '41449', 'QUIJANO, ANGEL MARK', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(750, '41450', 'BALA, FREDDIE APORDO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(751, '41451', 'HERNANDEZ, CARLO.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(752, '41452', 'VILLALUNA, LEONARD R.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(753, '41454', 'PILAPIL, ORLANDO N.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO SIDE MIRROR', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(754, '41455', 'ALDAY, ANTHONY P.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE; NO SIDE MIRROR', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(755, '41456', 'CUYAGON, ELMER A', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(756, '41457', 'CUDIAMAT, GREG', 'N/A', 'N/A', 'Other', 'DISCOURTEOUS/ARROGANT DRIVER; ILLEGAL PARKING; NO DRIVERS LICENSE; REFUSAL TO SIGN TRAFFIC CIT.TICKET', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(757, '41458', 'AQUINO, SAMUEL M.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(758, '41459', 'PALENOLA, JUVILLE GAMEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(759, '41460', 'MAGANA, ARMANDO T.', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(760, '41461', 'SANCHEZ, JOHN JOSEPH.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(761, '41462', 'VIADOR, CECILE C.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-09', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(762, '41464', 'JONSON, ROLANDO S.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(763, '41465', 'MADILLON, ALIKHAN P', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(764, '41467', 'CONTRERAS, REYMART', 'N/A', 'N/A', 'Other', '2ND OFFENSE - DISREGARDING TRAFFIC SIGN/OFFICER; 2ND OFFENSE - NO DRIVERS LICENSE; DISCOURTEOUS/ARROGANT DRIVER; NO SIDE MIRROR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(765, '41468', 'RUSSEL, PATRICK C', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(766, '41469', 'MARANAN, MICHAEL D.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(767, '41470', 'VILLAFANIA, CRISPILO I', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(768, '41471', 'HERNANDEZ, GRAN R.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(769, '41474', 'ESGUERRA, LEO HERNANDEZ', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(770, '41475', 'DIMAFELIX, RAMON R.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(771, '41476', 'MORELANO, JERRY VILLANUEVA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; DRIVING W/INVALID DRIVERS LIC.; REFUSAL TO SIGN TRAFFIC CIT. TICKET', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(772, '41477', 'MORCO, ALLAN NAVARRO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(773, '41479', 'DORIMON, LORETO A.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(774, '41480', 'COMBALICER, JAY MIOT', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(775, '41481', 'SALAZAR, CLIFFORD PITAO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(776, '41482', 'MENDOZA, RENATO A.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(777, '41483', 'DIOCAREZA, ELMER V.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(778, '41484', 'PAUIG, TEDDYSON C.', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(779, '41486', 'ANZALDO, MARIVIC DE VERO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(780, '41489', 'CABUNGAN, ALBERTO.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(781, '41490', 'MALINGIN, HERMES L.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(782, '41491', 'CATADA, ALBERTO G.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(783, '41492', 'DESACOLA, MARIO CAISIP', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(784, '41493', 'LOPEZ, RAMMEL BENTIR', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(785, '41497', 'DUENAS, ERWIN F.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NO SIDE MIRROR; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(786, '41499', 'GARCIA, EDUARDO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(787, '41502', 'ARCILLA, ENGILBERT DIAZ', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(788, '41503', 'CASILIHAN, REYNALDO .', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(789, '41504', 'PANAO, CEAZAR DIMALALUAN', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(790, '41507', 'CAWALING, BIENVENIDO .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(791, '41508', 'FLORES, OLIVER B.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(792, '41510', 'RODIGUEZ, MARIANO JR VILLANUEVA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(793, '41513', 'AGRAVIO, JESSIE ARNOZA', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(794, '41514', 'CERADO, MARK', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(795, '41515', 'DACILLO, ARIEL B.', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(796, '41516', 'DE CHAVEZ, MARK E.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(797, '41517', 'MICALLER, JAYLORD JONSON', 'N/A', 'N/A', 'Other', 'LOI 1482; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(798, '41518', 'ABIAD, JERBY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(799, '41519', 'BASIC, JULITO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(800, '41520', 'BANAYAD, JAY BOY', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(801, '41522', 'DOÑA, DARWIN', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(802, '41522-2', 'DONA, DARWIN.', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(803, '41523', 'DELA CRUZ, ROBERT.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(804, '41524', 'BORRERO, DANNEL.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(805, '41528', 'BIGAY, ARVIN SALAZAR', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(806, '41529', 'ESTIVIS, ERNESTO VASQUEZ', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(807, '41530', 'POSIO, RONNIE PILLA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(808, '41531', 'UMANDAL, JAYSON PANTOJA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(809, '41532', 'DE JESUS, PAULINO.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(810, '41536', 'GAL, CHRISTIAN ARIENZA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(811, '41537', 'BAGUNAS, JIMBOY.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(812, '41538', 'ESPINIDA, RUEL DELARMENTE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(813, '41539', 'ABELLADA, SONNY BOY.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(814, '41540', 'DE JESUS, JOHN PROHNEIL LAGUARDIA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(815, '41551', 'MAULLON, MARLON LAMANO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(816, '41552', 'DE LOS REYES, JOHN EDWARD LAGTO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(817, '41553', 'DE CASTRO, ORIEL HARRY ORIONDO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(818, '41554', 'RODRIGUEZ, ZEUS BENSON', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(819, '41555', 'DE JESUS, JOHN ALLEN DURREL M', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(820, '41556', 'HERJAS, LARRY ALEROZA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(821, '41558', 'UMALI, MARK ALVIN LEJANO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(822, '41560', 'MONTEALEGRE, JAKE D.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-13', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(823, '41561', 'RAFIZ, MARLON HERNANDEZ', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(824, '41562', 'YABUT, GENARO', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(825, '41563', 'PENA, MARVIN MARDO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(826, '41565', 'CLETE, RONALD MONDIGO', 'N/A', 'N/A', 'Other', 'RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(827, '41567', 'GONZALES, JAYSON REYES', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(828, '41568', 'CABINGAN, ROLANDO S.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(829, '41569', 'ILAO, JARWIN CARAIG', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-14', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(830, '41571', 'MALONZO, ALDRIN LUCES', 'N/A', 'N/A', 'Other', '2ND OFFENSE - ILLEGAL TERMINAL', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(831, '41573', 'ULARTE, JOEL.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(832, '41576', 'MINA, JONAS', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(833, '41577', 'CONSTANTINO, JOHN MARK.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(834, '41578', 'TENORIO, ALVIN DELOS REYES', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-15', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(835, '41579', 'SURIO, ROBERTO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(836, '41582', 'BRAGADO, PONCIANO JR. B', 'N/A', 'N/A', 'Other', 'UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-16', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(837, '41583', 'SISON, CARLITO MENDOZA', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(838, '41585', 'CAHAYON, PATRICIA CAÑETE', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NUISANCE MUFFLER/34J', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(839, '41586', 'VILLARUEL, JIMMY SANCHEZ', 'N/A', 'N/A', 'Other', 'OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(840, '41587', 'DE JESUS, ROLAND LIQUE', 'N/A', 'N/A', 'Other', 'DRIVING NOT WEARING SHOES; DRIVING W/SLEEVELESS SHIRT & SHORT; OPERATING OUT OF LINE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(841, '41588', 'ORTEGA, ARNEL', 'N/A', 'N/A', 'Other', '2ND OFFENSE - NO DRIVERS LICENSE; DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(842, '41590', 'LIMJOCO, MARK LAGUS', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(843, '41591', 'APUHIN, ROLDAN MONTANO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(844, '41593', 'LOPEZ, ERWIN CRUZADO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(845, '41594', 'LANDICHO, ANTONIO MAGTIBAY', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(846, '41595', 'MERCADO, DANILO DE OCAMPO', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN', 'Nasugbu, Batangas', '2020-10-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(847, '41596', 'ZAMORA, JAMES .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(848, '41597', 'GARDOSE, BENJIE GRACIADAS', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(849, '41598', 'BERINGULA, NOLI .', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING; NO DRIVERS LICENSE', 'Nasugbu, Batangas', '2020-10-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(850, '41600', 'BACIT, ANDRIAN LISBOA', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(851, '41601', 'TAGUDIN, NOEL B.', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN/OFCR; NO DRIVERS LICENSE; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(852, '41602', 'MADRIGAL, KALVIN M.', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-20', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(853, '41603', 'CABRAL, ANTONIO SAMONTEZA', 'N/A', 'N/A', 'Other', 'DISREGARDING TRAFFIC SIGN', 'Nasugbu, Batangas', '2020-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(854, '41604', 'EROMA, ANGELICA SAMONTE', 'N/A', 'N/A', 'Other', 'ILLEGAL PARKING', 'Nasugbu, Batangas', '2020-10-21', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(855, '41651', 'ALAMAG, FRANCIS R.', 'N/A', 'N/A', 'Other', 'RECKLESS DRIVING', 'Nasugbu, Batangas', '2020-10-06', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(856, '41652', 'ARCAYOS, ANDREA N.', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; OR/CR NOT CARRRIED; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2020-10-07', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(857, '41654', 'APACIBLE, JACINTA M.', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(858, '41655', 'SERMANIA, NELMA D.', 'N/A', 'N/A', 'Other', 'DRIVING W/INVALID DRIVERS LIC.', 'Nasugbu, Batangas', '2020-10-12', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(859, '64750', 'SANRIO, ANGELITO MATUOG', 'N/A', 'N/A', 'Other', 'NO SIDE MIRROR', 'Nasugbu, Batangas', '2026-06-08', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(860, '64843', 'LETRAN, NICO MAR VEROYA', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NO SIDE MIRROR; RECKLESS DRIVING; UNREG MOTOR VEHICLE', 'Nasugbu, Batangas', '2026-06-19', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(861, '65083', 'BAUSAS, KEVEN CONTRERAS', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NO SIDE MIRROR', 'Nasugbu, Batangas', '2026-06-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(862, '65152', 'PAVILANDO, MA CHARINE URETA', 'N/A', 'N/A', 'Other', 'NO SIDE MIRROR', 'Nasugbu, Batangas', '2026-06-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(863, '65154', 'ROLLAN, JEROME ABANAG', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NO SIDE MIRROR', 'Nasugbu, Batangas', '2026-06-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(864, '65156', 'MACEDA, CLARK STEVEN SALORSANO', 'N/A', 'N/A', 'Other', 'NO SIDE MIRROR', 'Nasugbu, Batangas', '2026-06-24', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(865, '65181', 'GUTIERREZ, JOHN VINCENT BUHAY', 'N/A', 'N/A', 'Other', 'OVERLOADING', 'Nasugbu, Batangas', '2026-06-29', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09'),
(866, '65195', 'MIÑOZA, LEONARD BORROMEO', 'N/A', 'N/A', 'Other', 'NO DRIVERS LICENSE; NO SIDE MIRROR', 'Nasugbu, Batangas', '2026-07-01', '00:00:00', 0.00, 'manual', NULL, 'paid', '2026-07-10 23:23:09', '2026-07-10 23:23:09');

-- --------------------------------------------------------

--
-- Table structure for table `violation_hotspots`
--

CREATE TABLE `violation_hotspots` (
  `hotspot_id` bigint(20) UNSIGNED NOT NULL,
  `cluster_label` varchar(80) NOT NULL,
  `location` varchar(255) NOT NULL,
  `violation_type` varchar(120) DEFAULT NULL,
  `frequency_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `risk_level` enum('low','medium','high','critical') NOT NULL DEFAULT 'medium',
  `model_type` enum('k-means','other') NOT NULL DEFAULT 'k-means',
  `generated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `additional_info` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cameras`
--
ALTER TABLE `cameras`
  ADD PRIMARY KEY (`camera_id`),
  ADD UNIQUE KEY `uq_cameras_ip_address` (`ip_address`);

--
-- Indexes for table `camera_monitoring_logs`
--
ALTER TABLE `camera_monitoring_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_camera_monitoring_logs_camera_id` (`camera_id`),
  ADD KEY `idx_monitoring_logs_recorded_at` (`recorded_at`);

--
-- Indexes for table `ml_predictions`
--
ALTER TABLE `ml_predictions`
  ADD PRIMARY KEY (`prediction_id`);

--
-- Indexes for table `monitoring_alerts`
--
ALTER TABLE `monitoring_alerts`
  ADD PRIMARY KEY (`alert_id`),
  ADD KEY `fk_alerts_camera_log` (`camera_log_id`),
  ADD KEY `fk_alerts_acknowledged_by` (`acknowledged_by`);

--
-- Indexes for table `officers`
--
ALTER TABLE `officers`
  ADD PRIMARY KEY (`officer_id`),
  ADD KEY `idx_officers_zone_id` (`zone_id`);

--
-- Indexes for table `officer_duty_schedules`
--
ALTER TABLE `officer_duty_schedules`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `idx_officer_duty_schedules_officer_id` (`officer_id`);

--
-- Indexes for table `officer_presence_logs`
--
ALTER TABLE `officer_presence_logs`
  ADD PRIMARY KEY (`presence_id`),
  ADD KEY `idx_officer_presence_officer_id` (`officer_id`),
  ADD KEY `idx_officer_presence_zone_id` (`zone_id`),
  ADD KEY `fk_presence_recorded_by` (`recorded_by`),
  ADD KEY `idx_officer_presence_date` (`presence_date`);

--
-- Indexes for table `officer_zones`
--
ALTER TABLE `officer_zones`
  ADD PRIMARY KEY (`zone_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `idx_payments_violation_id` (`violation_id`),
  ADD KEY `idx_payments_received_by` (`received_by`),
  ADD KEY `idx_payments_date` (`payment_date`);

--
-- Indexes for table `public_announcements`
--
ALTER TABLE `public_announcements`
  ADD PRIMARY KEY (`announcement_id`),
  ADD KEY `idx_announcements_created_by` (`created_by`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `idx_reports_generated_by` (`generated_by`),
  ADD KEY `idx_reports_generated_at` (`generated_at`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Indexes for table `violations`
--
ALTER TABLE `violations`
  ADD PRIMARY KEY (`violation_id`),
  ADD UNIQUE KEY `uq_violations_ticket_number` (`ticket_number`),
  ADD KEY `idx_violations_encoded_by` (`encoded_by`),
  ADD KEY `idx_violations_date` (`violation_date`);

--
-- Indexes for table `violation_hotspots`
--
ALTER TABLE `violation_hotspots`
  ADD PRIMARY KEY (`hotspot_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cameras`
--
ALTER TABLE `cameras`
  MODIFY `camera_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `camera_monitoring_logs`
--
ALTER TABLE `camera_monitoring_logs`
  MODIFY `log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ml_predictions`
--
ALTER TABLE `ml_predictions`
  MODIFY `prediction_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `monitoring_alerts`
--
ALTER TABLE `monitoring_alerts`
  MODIFY `alert_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `officers`
--
ALTER TABLE `officers`
  MODIFY `officer_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `officer_duty_schedules`
--
ALTER TABLE `officer_duty_schedules`
  MODIFY `schedule_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `officer_presence_logs`
--
ALTER TABLE `officer_presence_logs`
  MODIFY `presence_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `officer_zones`
--
ALTER TABLE `officer_zones`
  MODIFY `zone_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `public_announcements`
--
ALTER TABLE `public_announcements`
  MODIFY `announcement_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `violations`
--
ALTER TABLE `violations`
  MODIFY `violation_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=867;

--
-- AUTO_INCREMENT for table `violation_hotspots`
--
ALTER TABLE `violation_hotspots`
  MODIFY `hotspot_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `camera_monitoring_logs`
--
ALTER TABLE `camera_monitoring_logs`
  ADD CONSTRAINT `fk_monitoring_logs_camera` FOREIGN KEY (`camera_id`) REFERENCES `cameras` (`camera_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `monitoring_alerts`
--
ALTER TABLE `monitoring_alerts`
  ADD CONSTRAINT `fk_alerts_acknowledged_by` FOREIGN KEY (`acknowledged_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_alerts_camera_log` FOREIGN KEY (`camera_log_id`) REFERENCES `camera_monitoring_logs` (`log_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `officers`
--
ALTER TABLE `officers`
  ADD CONSTRAINT `fk_officers_zone` FOREIGN KEY (`zone_id`) REFERENCES `officer_zones` (`zone_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `officer_duty_schedules`
--
ALTER TABLE `officer_duty_schedules`
  ADD CONSTRAINT `fk_duty_schedules_officer` FOREIGN KEY (`officer_id`) REFERENCES `officers` (`officer_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `officer_presence_logs`
--
ALTER TABLE `officer_presence_logs`
  ADD CONSTRAINT `fk_presence_officer` FOREIGN KEY (`officer_id`) REFERENCES `officers` (`officer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_presence_recorded_by` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_presence_zone` FOREIGN KEY (`zone_id`) REFERENCES `officer_zones` (`zone_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_received_by` FOREIGN KEY (`received_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payments_violation` FOREIGN KEY (`violation_id`) REFERENCES `violations` (`violation_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `public_announcements`
--
ALTER TABLE `public_announcements`
  ADD CONSTRAINT `fk_announcements_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `fk_reports_generated_by` FOREIGN KEY (`generated_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `violations`
--
ALTER TABLE `violations`
  ADD CONSTRAINT `fk_violations_encoded_by` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
