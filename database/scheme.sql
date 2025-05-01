-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 01, 2025 at 05:29 PM
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
-- Database: `tpsi_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `corsi`
--

CREATE TABLE `corsi` (
  `id` int(11) NOT NULL,
  `titolo` varchar(100) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `docente` varchar(100) NOT NULL,
  `prezzo` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `corsi`
--

INSERT INTO `corsi` (`id`, `titolo`, `descrizione`, `docente`, `prezzo`) VALUES
(1, 'Programmazione in Java', 'Corso base di programmazione in Java', 'Prof. Rossi', 199.99),
(2, 'Database MySQL', 'Gestione e ottimizzazione di database MySQL', 'Dott.ssa Bianchi', 149.99),
(4, 'Programmazione Python', 'Fondamenti di programmazione con Python e sue applicazioni', 'Dott. Verdi', 179.50),
(5, 'Flutter Mobile Development', 'Creazione di app cross-platform con Flutter e Dart', 'Ing. Ferrari', 229.99),
(7, 'DevOps e CI/CD', 'Automazione dello sviluppo, testing e deployment del software', 'Dott. Marini', 249.99),
(8, 'Intelligenza Artificiale', 'Introduzione al machine learning e reti neurali', 'Prof. Russo', 299.99),
(9, 'UX/UI Design', 'Principi di design e usabilità per applicazioni moderne', 'Dott.ssa Ricci', 169.50),
(10, 'Cybersecurity', 'Principi di sicurezza informatica e protezione dei dati', 'Ing. Costa', 239.01);

-- --------------------------------------------------------

--
-- Table structure for table `iscrizioni`
--

CREATE TABLE `iscrizioni` (
  `id` int(11) NOT NULL,
  `studente_id` int(11) NOT NULL,
  `corso_id` int(11) NOT NULL,
  `data_iscrizione` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `iscrizioni`
--

INSERT INTO `iscrizioni` (`id`, `studente_id`, `corso_id`, `data_iscrizione`) VALUES
(1, 1, 1, '2025-02-25'),
(2, 2, 2, '2025-02-25');

-- --------------------------------------------------------

--
-- Table structure for table `studenti`
--

CREATE TABLE `studenti` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `data_nascita` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `studenti`
--

INSERT INTO `studenti` (`id`, `nome`, `cognome`, `email`, `data_nascita`) VALUES
(1, 'marco', 'francoforte', 'luca.verdi@gian.com', '2002-05-15'),
(2, 'francesco', 'emanuele', 'sara.neri@metros.com', '2001-09-22'),
(3, 'sdfsd', '.', 'sdf@dafgh', '2007-05-02');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `corsi`
--
ALTER TABLE `corsi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `iscrizioni`
--
ALTER TABLE `iscrizioni`
  ADD PRIMARY KEY (`id`),
  ADD KEY `studente_id` (`studente_id`),
  ADD KEY `corso_id` (`corso_id`);

--
-- Indexes for table `studenti`
--
ALTER TABLE `studenti`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `corsi`
--
ALTER TABLE `corsi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `iscrizioni`
--
ALTER TABLE `iscrizioni`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `studenti`
--
ALTER TABLE `studenti`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `iscrizioni`
--
ALTER TABLE `iscrizioni`
  ADD CONSTRAINT `iscrizioni_ibfk_1` FOREIGN KEY (`studente_id`) REFERENCES `studenti` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `iscrizioni_ibfk_2` FOREIGN KEY (`corso_id`) REFERENCES `corsi` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
