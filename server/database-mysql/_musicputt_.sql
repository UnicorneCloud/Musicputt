-- phpMyAdmin SQL Dump
-- version 3.5.5
-- http://www.phpmyadmin.net
--
-- Host: sql3.freemysqlhosting.net
-- Generation Time: Jan 25, 2015 at 02:42 PM
-- Server version: 5.5.40-0ubuntu0.12.04.1
-- PHP Version: 5.3.28

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `sql365248`
--
CREATE DATABASE `sql365248` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `sql365248`;

-- --------------------------------------------------------

--
-- Table structure for table `listening`
--

CREATE TABLE IF NOT EXISTS `listening` (
  `trackId` varchar(256) NOT NULL,
  `artistId` varchar(256) NOT NULL,
  `collectionId` varchar(256) NOT NULL,
  `artistName` varchar(256) NOT NULL,
  `collectionName` varchar(256) NOT NULL,
  `trackName` varchar(256) NOT NULL,
  `previewUrl` varchar(1024) NOT NULL,
  `artworkUrl100` varchar(1024) NOT NULL,
  `listeningDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`trackId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `listening`
--

INSERT INTO `listening` (`trackId`, `artistId`, `collectionId`, `artistName`, `collectionName`, `trackName`, `previewUrl`, `artworkUrl100`, `listeningDate`) VALUES
('900672609', '342260741', '900672435', 'Hozier', 'Hozier (Bonus Tracks Version)', 'Take Me to Church', 'http://a329.phobos.apple.com/us/r1000/004/Music4/v4/db/44/8a/db448a18-9f5f-9295-8754-0755a327acba/mzaf_2990011022289621510.plus.aac.p.m4a', 'http://a3.mzstatic.com/us/r30/Music5/v4/48/fc/94/48fc9401-088c-18bd-8d9e-26767c8d8acb/886444718820.100x100-75.jpg', '2015-01-24 12:18:13');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
