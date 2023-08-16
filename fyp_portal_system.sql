-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 16, 2023 at 10:58 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fyp_portal_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `areas`
--

CREATE TABLE `areas` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` text DEFAULT NULL,
  `CREATED_AT` date NOT NULL,
  `CREATED_BY` int(11) NOT NULL,
  `IS_DELETED` bit(1) NOT NULL DEFAULT b'0',
  `INSTITUTEID` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `areas`
--

INSERT INTO `areas` (`ID`, `NAME`, `DESCRIPTION`, `CREATED_AT`, `CREATED_BY`, `IS_DELETED`, `INSTITUTEID`) VALUES
(1, 'AI Specialist', NULL, '2022-12-03', 0, b'0', 'szabist'),
(2, 'Natural Language Processing', NULL, '2022-12-03', 0, b'0', 'szabist'),
(3, 'Text Mining, Machine Learning', NULL, '2022-12-03', 0, b'0', 'szabist'),
(4, 'Data Science', NULL, '2022-12-03', 0, b'0', 'szabist'),
(5, 'Image Processing', NULL, '2022-12-03', 0, b'0', 'szabist'),
(6, 'Software Engineering', NULL, '2022-12-03', 0, b'0', 'szabist'),
(7, 'Machine Learning', NULL, '2022-12-03', 0, b'0', 'szabist'),
(8, 'Management Information System', NULL, '2022-12-03', 0, b'0', 'szabist'),
(9, 'Blockchain', NULL, '2022-12-03', 0, b'0', 'szabist'),
(10, 'Linux Virtualization', NULL, '2022-12-03', 0, b'0', 'szabist'),
(11, 'Cloud Computing', NULL, '2022-12-03', 0, b'0', 'szabist'),
(12, 'Networks', NULL, '2022-12-03', 0, b'0', 'szabist'),
(13, 'Blockchain Specialist', NULL, '2022-12-03', 3, b'0', 'szabist');

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `ID` int(11) NOT NULL,
  `IS_FINALIZED` tinyint(1) NOT NULL,
  `INSTITUTEID` varchar(50) NOT NULL,
  `ISDELETED` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`ID`, `IS_FINALIZED`, `INSTITUTEID`, `ISDELETED`) VALUES
(7, 1, 'szabist', 0),
(8, 1, 'szabist', 0);

-- --------------------------------------------------------

--
-- Table structure for table `group_invitation`
--

CREATE TABLE `group_invitation` (
  `ID` int(11) NOT NULL,
  `SENDER_USER_ID` int(11) NOT NULL,
  `RECEIVER_USER_ID` int(11) NOT NULL,
  `IS_ACCEPTED` tinyint(1) NOT NULL,
  `SENDED_AT` datetime NOT NULL,
  `IS_DELETED` tinyint(4) NOT NULL DEFAULT 0,
  `INSTITUTEID` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `group_invitation`
--

INSERT INTO `group_invitation` (`ID`, `SENDER_USER_ID`, `RECEIVER_USER_ID`, `IS_ACCEPTED`, `SENDED_AT`, `IS_DELETED`, `INSTITUTEID`) VALUES
(8, 8, 9, 1, '2023-07-05 15:07:30', 0, 'szabist'),
(9, 10, 1, 1, '2023-07-06 01:44:49', 0, 'szabist');

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

CREATE TABLE `group_members` (
  `ID` int(11) NOT NULL,
  `GROUP_ID` int(11) NOT NULL,
  `MEMBER_USER_ID` int(11) NOT NULL,
  `GROUP_INVITATION_ID` int(11) DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `CREATED_BY` int(11) DEFAULT NULL,
  `INSTITUTEID` varchar(50) NOT NULL,
  `ISDELETED` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `group_members`
--

INSERT INTO `group_members` (`ID`, `GROUP_ID`, `MEMBER_USER_ID`, `GROUP_INVITATION_ID`, `CREATED_AT`, `CREATED_BY`, `INSTITUTEID`, `ISDELETED`) VALUES
(13, 7, 8, 0, '2023-07-05 15:07:56', 9, 'szabist', b'0'),
(14, 7, 9, 8, '2023-07-05 15:07:56', 9, 'szabist', b'0'),
(15, 8, 10, 0, '2023-07-06 01:45:20', 1, 'szabist', b'0'),
(16, 8, 1, 9, '2023-07-06 01:45:20', 1, 'szabist', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `proposal_comments`
--

CREATE TABLE `proposal_comments` (
  `ID` int(11) NOT NULL,
  `PROPOSALID` int(11) NOT NULL,
  `COMMENT` text NOT NULL,
  `SENDEDAT` datetime NOT NULL,
  `ADVISORID` int(11) NOT NULL,
  `ISINTERESTED` int(11) NOT NULL,
  `INSTITUTEID` varchar(100) NOT NULL,
  `ISDELETED` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `proposal_comments`
--

INSERT INTO `proposal_comments` (`ID`, `PROPOSALID`, `COMMENT`, `SENDEDAT`, `ADVISORID`, `ISINTERESTED`, `INSTITUTEID`, `ISDELETED`) VALUES
(13, 7, 'Update the proposal and add some more classifications.', '2023-07-05 15:21:43', 3, 0, 'szabist', 0),
(14, 8, 'need improvements', '2023-07-05 17:37:44', 3, 0, 'szabist', 0),
(15, 9, 'I Like your project but something missing in this ', '2023-07-06 01:48:02', 6, 0, 'szabist', 0);

-- --------------------------------------------------------

--
-- Table structure for table `purposals`
--

CREATE TABLE `purposals` (
  `ID` int(11) NOT NULL,
  `TITLE` varchar(500) NOT NULL,
  `GROUP_ID` int(11) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `CREATED_BY` int(11) NOT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `UPDATED_BY` int(11) DEFAULT NULL,
  `INSTITUTEID` varchar(50) NOT NULL,
  `IS_DELETED` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purposals`
--

INSERT INTO `purposals` (`ID`, `TITLE`, `GROUP_ID`, `DESCRIPTION`, `CREATED_AT`, `CREATED_BY`, `UPDATED_AT`, `UPDATED_BY`, `INSTITUTEID`, `IS_DELETED`) VALUES
(7, 'szabist', 7, 'szabist karachi', '2023-07-05 15:11:01', 9, NULL, NULL, 'szabist', b'0'),
(8, 'SZAB FYP PORTAL', 7, 'szab fyp portal', '2023-07-05 17:27:29', 8, NULL, NULL, 'szabist', b'0'),
(9, 'New Proposal API', 8, 'Visit our API reference and examples page to explore this API using the limited data collection and the free calls of the test environment.If you don’t have an API key yet, you can get one by creating an app in My Self-Service Workspace. It will only take a few minutes.', '2023-07-06 01:46:08', 1, NULL, NULL, 'szabist', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `send_proposal`
--

CREATE TABLE `send_proposal` (
  `ID` int(11) NOT NULL,
  `ProposalID` int(11) NOT NULL,
  `AdvisorID` int(11) NOT NULL,
  `SendedAt` datetime NOT NULL,
  `Status` varchar(100) NOT NULL,
  `IS_DELETED` bit(1) NOT NULL,
  `INSTITUTEID` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `send_proposal`
--

INSERT INTO `send_proposal` (`ID`, `ProposalID`, `AdvisorID`, `SendedAt`, `Status`, `IS_DELETED`, `INSTITUTEID`) VALUES
(10, 7, 3, '2023-07-05 15:20:22', 'pending', b'0', 'szabist'),
(11, 7, 4, '2023-07-05 15:20:37', 'pending', b'0', 'szabist'),
(12, 8, 3, '2023-07-05 17:28:05', 'pending', b'0', 'szabist'),
(13, 8, 7, '2023-07-05 17:28:15', 'pending', b'0', 'szabist'),
(14, 9, 2, '2023-07-06 01:46:21', 'pending', b'0', 'szabist'),
(15, 9, 6, '2023-07-06 01:46:29', 'pending', b'0', 'szabist');

-- --------------------------------------------------------

--
-- Table structure for table `setting`
--

CREATE TABLE `setting` (
  `ID` int(11) NOT NULL,
  `SETTING_KEY` varchar(100) NOT NULL,
  `SETTING_VALUE` varchar(1000) NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `CREATED_BY` int(11) NOT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `UPDATED_BY` int(11) DEFAULT NULL,
  `INSTITUTEID` varchar(100) NOT NULL,
  `IS_DELETED` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `setting`
--

INSERT INTO `setting` (`ID`, `SETTING_KEY`, `SETTING_VALUE`, `CREATED_AT`, `CREATED_BY`, `UPDATED_AT`, `UPDATED_BY`, `INSTITUTEID`, `IS_DELETED`) VALUES
(1, 'LAST_INVITED_GROUP_MEMBERS_DATE', '2023-12-20', '2023-01-07 14:03:37', 0, NULL, NULL, 'Szabist', 0),
(2, 'MAX_GROUP_MEMBERS_COUNT', '3', '2023-01-15 20:17:11', 0, NULL, NULL, 'SZABIST', 0),
(3, 'MIN_GROUP_MEMBERS_COUNT', '2', '2023-01-15 20:18:10', 0, NULL, NULL, 'SZABIST', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `USERNAME` varchar(50) NOT NULL,
  `PASSWORD` varchar(200) NOT NULL,
  `FIRST_NAME` varchar(50) NOT NULL,
  `LAST_NAME` varchar(50) NOT NULL,
  `EMAIL` varchar(70) NOT NULL,
  `PHONE_NUMBER` varchar(20) NOT NULL,
  `STATUS` varchar(20) NOT NULL,
  `ROLE` varchar(20) NOT NULL,
  `IS_VERIFIED` tinyint(1) NOT NULL,
  `IS_LOCKED` tinyint(1) NOT NULL,
  `EXTRA_PROPERTIES` text DEFAULT NULL,
  `PROFILE_PIC` text DEFAULT NULL,
  `CREATED_AT` datetime DEFAULT NULL,
  `CREATED_BY` int(11) DEFAULT NULL,
  `UPDATED_AT` datetime DEFAULT NULL,
  `INSTITUTEID` varchar(100) DEFAULT NULL,
  `IS_DELETED` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`ID`, `USERNAME`, `PASSWORD`, `FIRST_NAME`, `LAST_NAME`, `EMAIL`, `PHONE_NUMBER`, `STATUS`, `ROLE`, `IS_VERIFIED`, `IS_LOCKED`, `EXTRA_PROPERTIES`, `PROFILE_PIC`, `CREATED_AT`, `CREATED_BY`, `UPDATED_AT`, `INSTITUTEID`, `IS_DELETED`) VALUES
(1, 'student', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Test', 'Student', 'Student@fyp.com', '+923322081274', 'Active', 'Student', 1, 0, '{\n  \"StudentID\": \"1912221\",\n  \"Section\": \"E\",\n  \"Program\": \"BSSE\"\n}', NULL, '2022-11-19 01:53:57', 0, NULL, 'szabist', 0),
(2, 'asim', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Asim', 'Riaz', 'asim@fyp.com', '+923399004453', 'Active', 'Advisor', 1, 0, '{\n  \"RoomNo\": \"301\",\n  \"Campus\": \"SZABIST 100 Campus\",\n  \"Designation\": \"Assistant Professor\"\n}', 'https://media.licdn.com/dms/image/C4E12AQEL7-KjkepHEA/article-cover_image-shrink_600_2000/0/1521506074997?e=2147483647&v=beta&t=8nDJM2jr4GbKNQIJj1t7G5roaU6974j_kZSehPa-IJM', '2022-12-03 21:04:04', 3, NULL, 'szabist', 0),
(3, 'adeel', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Adeel', ' Ahmed', 'adeel@fyp.com', '+923399004454', 'Active', 'Advisor', 1, 0, '{\n  \"RoomNo\": \"301\",\n  \"Campus\": \"SZABIST 100 Campus\",\n  \"Designation\": \"Assistant Professor\"\n}', NULL, '2022-12-03 21:04:04', 3, NULL, 'szabist', 0),
(4, 'asimali', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Asim', 'Ali', 'asimali@fyp.com', '+923399004455', 'Active', 'Advisor', 1, 0, '{\n  \"RoomNo\": \"201\",\n  \"Campus\": \"SZABIST 99 Campus\",\n  \"Designation\": \"Professor\"\n}', NULL, '2022-12-03 21:04:04', 3, NULL, 'szabist', 0),
(5, 'adeel', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Dr. Adeel', 'Ansari', 'adeel@fyp.com', '+923399004456', 'Active', 'Advisor', 1, 0, '{\n  \"RoomNo\": \"201\",\n  \"Campus\": \"SZABIST 100 Campus\",\n  \"Designation\": \"Professor\"\n}', 'https://lh3.googleusercontent.com/HmfHrhRJgOYRNxqhjWNdSUJ1tHwgpwzpzkB--zdHpB8e_QJAmUINvOcicYq2A_K7mkGkZCJEcVDtbrf5FYmmCBQ5zOQBTPspL382OoRK4Cs57G0PHD13UDgvttbi8Dl06Nd5cgzjTlxTcABCyj8mcQCUvks2bQf-5CVmPwfW01YBQOcQqtGXa6oF-I_sgdN3=w1280', '2022-12-03 21:04:04', 3, NULL, 'szabist', 0),
(6, 'hasnain', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Dr. Husnain', 'Mansoor Ali', 'hasnain@fyp.com', '+923399004456', 'Active', 'Advisor', 1, 0, '{\n  \"RoomNo\": \"301\",\n  \"Campus\": \"SZABIST 100 Campus\",\n  \"Designation\": \"Assistant Professor\"\n}', 'https://lahore.comsats.edu.pk/Images/employees/518-624-8585481345408530841.JPG', '2022-12-03 21:04:04', 3, NULL, 'szabist', 0),
(7, 'sadia', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Dr Sadia', 'Aziz', 'sadia@fyp.com', '+923399004458', 'Active', 'Advisor', 1, 0, '{\n  \"RoomNo\": \"301\",\n  \"Campus\": \"SZABIST 100 Campus\",\n  \"Designation\": \"Lecturer\"\n}', 'https://propakistani.pk/wp-content/uploads/2021/12/Arabic-teacher.jpg', '2022-12-03 21:04:04', 3, NULL, 'szabist', 0),
(8, 'Hassan', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Hassan', 'Ali', 'HassanAli@fyp.com', '+923322081274', 'Active', 'Student', 1, 0, '{\r\n  \"StudentID\": \"1912228\",\r\n  \"Section\": \"D\",\r\n  \"Program\": \"BSCS\"\r\n}', NULL, '2022-12-03 00:00:00', 0, NULL, 'Szabist', 0),
(9, 'Hussain', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Hussain', 'Rafiq', 'Hussaintabani@fyp.com', '+923322081273', 'Active', 'Student', 1, 0, '{\r\n  \"StudentID\": \"1912229\",\r\n  \"Section\": \"D\",\r\n  \"Program\": \"BSCS\"\r\n}', NULL, '2022-12-03 00:00:00', 0, NULL, 'Szabist', 0),
(10, 'Ubaid', '$2b$10$Ux4YTzMrCCOlHTsBPQygeeXFfu9HlwAK0k4p7j0TWIwqnG10b4iZW', 'Ubaid', 'Razaq', 'Ubaid@fyp.com', '+923322081270', 'Active', 'Student', 1, 0, '{\r\n  \"StudentID\": \"1912235\",\r\n  \"Section\": \"D\",\r\n  \"Program\": \"BSCS\"\r\n}', NULL, '2022-12-03 00:00:00', 0, NULL, 'Szabist', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users_areas`
--

CREATE TABLE `users_areas` (
  `ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `AREA_ID` int(11) NOT NULL,
  `CREATED_AT` datetime NOT NULL,
  `CREATED_BY` int(11) NOT NULL,
  `INSTITUTEID` varchar(100) NOT NULL,
  `IS_DELETED` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users_areas`
--

INSERT INTO `users_areas` (`ID`, `USER_ID`, `AREA_ID`, `CREATED_AT`, `CREATED_BY`, `INSTITUTEID`, `IS_DELETED`) VALUES
(1, 2, 1, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(2, 2, 2, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(3, 2, 3, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(4, 2, 4, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(5, 2, 5, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(6, 2, 6, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(7, 3, 7, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(8, 3, 8, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(9, 3, 9, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(10, 3, 10, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(11, 3, 11, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(12, 3, 12, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(13, 3, 1, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(14, 4, 2, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(15, 4, 3, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(16, 4, 4, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(17, 4, 5, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(18, 4, 6, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(19, 4, 7, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(20, 4, 8, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(21, 4, 9, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(22, 4, 10, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(23, 5, 11, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(24, 5, 12, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(25, 5, 1, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(26, 5, 2, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(27, 5, 3, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(28, 5, 4, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(29, 5, 5, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(30, 6, 6, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(31, 6, 7, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(32, 6, 8, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(33, 6, 9, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(34, 6, 10, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(35, 7, 11, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(36, 7, 12, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(37, 7, 1, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(38, 7, 2, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(39, 7, 3, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(40, 7, 4, '2022-12-03 17:31:48', 0, 'szabist', b'0'),
(41, 2, 13, '2023-05-04 07:11:46', 0, '', b'0'),
(42, 2, 13, '2023-05-04 07:11:46', 0, 'szabist', b'0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `group_invitation`
--
ALTER TABLE `group_invitation`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `proposal_comments`
--
ALTER TABLE `proposal_comments`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `purposals`
--
ALTER TABLE `purposals`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `send_proposal`
--
ALTER TABLE `send_proposal`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `users_areas`
--
ALTER TABLE `users_areas`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `areas`
--
ALTER TABLE `areas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `groups`
--
ALTER TABLE `groups`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `group_invitation`
--
ALTER TABLE `group_invitation`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `group_members`
--
ALTER TABLE `group_members`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `proposal_comments`
--
ALTER TABLE `proposal_comments`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `purposals`
--
ALTER TABLE `purposals`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `send_proposal`
--
ALTER TABLE `send_proposal`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `setting`
--
ALTER TABLE `setting`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users_areas`
--
ALTER TABLE `users_areas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
