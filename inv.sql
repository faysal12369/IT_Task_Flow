-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 21 juil. 2025 à 08:05
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `inv`
--

DELIMITER $$
--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `generate_depense_ref` () RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE today_str VARCHAR(8);
    DECLARE prefix VARCHAR(20);
    DECLARE count_today INT;
    DECLARE new_ref VARCHAR(20);

    -- Format today's date as YYYYMMDD
    SET today_str = DATE_FORMAT(CURDATE(), '%Y%m%d');

    -- Prefix part
    SET prefix = CONCAT('DEP-', today_str);

    -- Count how many refs already exist for today in depense
    SELECT COUNT(*) INTO count_today
    FROM depense
    WHERE ref LIKE CONCAT(prefix, '%');

    -- Create the new reference with count + 1
    SET new_ref = CONCAT(prefix, '-', LPAD(count_today + 1, 3, '0'));

    RETURN new_ref;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_code` (`p_division` VARCHAR(255), `p_designation` VARCHAR(255), `p_floor` VARCHAR(50), `p_bureau` VARCHAR(50)) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE division_code VARCHAR(10);
    DECLARE job_code VARCHAR(10);

    SET division_code = CASE LOWER(p_division)
        WHEN 'dg' THEN '3101'
        WHEN 'ds' THEN '3102'
        WHEN 'optique' THEN '3103'
        WHEN 'acuitis' THEN '3104'
        WHEN 'biotug' THEN '5500'
        WHEN 'khm' THEN '3106'
        WHEN 'tiz' THEN '1500'
        WHEN 'stf' THEN '1900'
        WHEN 'alg' THEN '1600'
        WHEN 'bej' THEN '0600'
        ELSE '0000'
    END;

    -- FIX: All WHEN clauses are now lowercase to prevent logic errors
   SET job_code = CASE LOWER(p_designation)
        -- 1xx Technical & Production
        WHEN 'service maintenance' THEN '101'
        WHEN 'service production' THEN '102'
        WHEN 'service controle qualité' THEN '103'
        WHEN 'service coloration et traitement' THEN '104'
        WHEN 'service sav' THEN '105'
        WHEN 'laboratoire' THEN '106'
        WHEN 'architecte' THEN '107'
        WHEN 'génie electrique' THEN '108'
        WHEN 'génie mécanique' THEN '109'
        WHEN 'sercie hse' THEN '110'
        
        -- 2xx Commercial & Supply
        WHEN 'commercial' THEN '201'
        WHEN 'supplay chain' THEN '202'
        WHEN 'procurement' THEN '203'
        WHEN 'import' THEN '204'
        WHEN 'service call' THEN '205'
        WHEN 'prise de commande' THEN '206'
        WHEN 'livraison' THEN '207'
        WHEN 'distrubtion' THEN '208'
        WHEN 'techniqo commercial' THEN '209'
        
        -- 3xx Support & Administration
        WHEN 'rh' THEN '301'
        WHEN 'chef de site' THEN '302'
        WHEN 'dia' THEN '303'
        WHEN 'sdm' THEN '304'
        WHEN 'mgx' THEN '305'
        WHEN 'service cdg' THEN '306'
        WHEN 'dag' THEN '307'
        WHEN 'rf' THEN '308'
        WHEN 'dfc' THEN '309'
        WHEN 'it' THEN '310'
        WHEN 'smq' THEN '311'
        WHEN 'connnseiller' THEN '312'
        WHEN 'batinorm' THEN '313'
        WHEN 'service ordonanacement' THEN '314'
        WHEN 'service deligué' THEN '315'
        WHEN 'service stock' THEN '316'

        -- 4xx Finance & Accounting
        WHEN 'comptabilité' THEN '401'
        WHEN 'créance et recouvrement' THEN '402'
        WHEN 'service caisse' THEN '403'

        -- 5xx Security & Logistics
        WHEN 'agent de sécurité' THEN '501'
        WHEN 'expidition' THEN '502'
        WHEN 'stock' THEN '503'
        WHEN 'chauffeur' THEN '504'

        ELSE '999'
    END;

    -- This is the final, correct concatenation with padding for the bureau number
    RETURN CONCAT(division_code, p_floor, LPAD(p_bureau, 2, '0'), job_code);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_ref` () RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE today_str VARCHAR(8);
    DECLARE prefix VARCHAR(20);
    DECLARE count_today INT;
    DECLARE new_ref VARCHAR(20);

    -- Format today's date as YYYYMMDD
    SET today_str = DATE_FORMAT(CURDATE(), '%Y%m%d');

    -- Prefix part
    SET prefix = CONCAT('SIN-', today_str);

    -- Count how many refs already exist for today
    SELECT COUNT(*) INTO count_today
    FROM stk
    WHERE ref LIKE CONCAT(prefix, '%');

    -- Create the new reference with count + 1
    SET new_ref = CONCAT(prefix, '-', LPAD(count_today + 1, 3, '0'));

    RETURN new_ref;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `depense`
--

CREATE TABLE `depense` (
  `id_depense` int(11) NOT NULL,
  `nom_depense` varchar(255) NOT NULL,
  `ref` varchar(30) DEFAULT NULL,
  `date_dac` date NOT NULL,
  `fournisseur` varchar(255) DEFAULT NULL,
  `division` varchar(200) NOT NULL,
  `person` varchar(100) NOT NULL,
  `job` varchar(30) NOT NULL,
  `adresse` text DEFAULT NULL,
  `commentaire` text DEFAULT NULL,
  `description` text NOT NULL,
  `statut` enum('pas_encore','en_cours','terminé') NOT NULL,
  `stat_dep` enum('actif','inactif') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `depense`
--

INSERT INTO `depense` (`id_depense`, `nom_depense`, `ref`, `date_dac`, `fournisseur`, `division`, `person`, `job`, `adresse`, `commentaire`, `description`, `statut`, `stat_dep`) VALUES
(1, 'achat de 5 jeux de cartouches GL57', 'SIN-20250707-001', '2025-07-18', 'hp123456', 'DS', 'ali', 'IT', 'russie', 'Pour rédha', '4+2', 'terminé', 'actif'),
(2, 'paiement de la facture algerie télécom', 'N123456789', '2025-07-14', 'alger', 'DG', 'Lakhdar', 'IT', 'alger', 'pas payer', 'df', 'pas_encore', 'inactif'),
(3, 'paiement de  facture algerie télécom', 'N123456789', '2025-07-14', 'algertélécom', 'DG', 'ali', 'IT', 'alger', 'pas payer', 'oo', 'pas_encore', 'actif'),
(4, 'achat d\'un pc portable lenovo', 'LNV12237456', '2025-07-29', 'rue pc', 'DG', 'faysal', 'IT', 'oran', 'tsts', '1+2', 'terminé', 'actif'),
(5, 'achat de 4 toner d\'imprimante canon 3025i', 'SIN-20250720-001', '2025-07-21', 'admin informatique', 'DG', 'faysal', 'IT', 'oran', 'tsts', '1+2', 'terminé', 'actif');

--
-- Déclencheurs `depense`
--
DELIMITER $$
CREATE TRIGGER `after_depense_insert` AFTER INSERT ON `depense` FOR EACH ROW BEGIN
    DECLARE v_text_to_parse VARCHAR(255);
    DECLARE v_detected_type VARCHAR(100) DEFAULT NULL;
    DECLARE v_matched_keyword VARCHAR(100) DEFAULT NULL;
    DECLARE v_equip_text VARCHAR(255);
    DECLARE v_inserted_stk_id INT;
    DECLARE v_stk_code VARCHAR(100);
    DECLARE v_floor_num VARCHAR(10) DEFAULT '0';
    DECLARE v_bureau_num VARCHAR(10) DEFAULT '0';
    DECLARE v_quantity INT DEFAULT 1;
    DECLARE v_first_word VARCHAR(10);
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_new_ref VARCHAR(100);

    IF NEW.statut = 'terminé' THEN

        -- extract floor/bureau
        SET v_floor_num := SUBSTRING_INDEX(NEW.description, '+', 1);
        SET v_bureau_num := SUBSTRING_INDEX(NEW.description, '+', -1);

        -- clean expense name
        SET v_text_to_parse := LOWER(TRIM(NEW.nom_depense));
        IF LOCATE('achat d''un ', v_text_to_parse) = 1 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 12);
        ELSEIF LOCATE('achat d''une ', v_text_to_parse) = 1 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 13);
        ELSEIF LOCATE('achat de ', v_text_to_parse) = 2 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 9);
        ELSEIF LOCATE('commande de ', v_text_to_parse) = 1 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 12);
        END IF;
        SET v_text_to_parse := TRIM(v_text_to_parse);

        -- detect quantity if first word is number
        SET v_first_word := SUBSTRING_INDEX(v_text_to_parse, ' ', 1);
        IF v_first_word REGEXP '^[0-9]+$' THEN
            SET v_quantity := CAST(v_first_word AS UNSIGNED);
            SET v_text_to_parse := TRIM(SUBSTRING(v_text_to_parse, LENGTH(v_first_word)+1));
        END IF;

        -- detect type (priority order)
        -- toner color
        IF LOCATE('toner de l''imprimante noir', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner noir';
            SET v_matched_keyword = 'toner de l''imprimante noir';
        ELSEIF LOCATE('toner de l''imprimante blue', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner blue';
            SET v_matched_keyword = 'toner de l''imprimante blue';
        ELSEIF LOCATE('toner de l''imprimante jaune', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner jaune';
            SET v_matched_keyword = 'toner de l''imprimante jaune';
        ELSEIF LOCATE('toner de l''imprimante magenta', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner magenta';
            SET v_matched_keyword = 'toner de l''imprimante magenta';
        ELSEIF LOCATE('toner de l''imprimante', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner';
            SET v_matched_keyword = 'toner de l''imprimante';
        -- jeux de cartouches (plural and singular)
        ELSEIF LOCATE('jeux de cartouches', v_text_to_parse) > 0 OR LOCATE('jeu de cartouches', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer cartridge set';
            SET v_matched_keyword = IF(LOCATE('jeux de cartouches', v_text_to_parse) > 0, 'jeux de cartouches', 'jeu de cartouches');
        ELSEIF LOCATE('cartouches', v_text_to_parse) > 0 OR LOCATE('cartouche', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer cartridge';
            SET v_matched_keyword = IF(LOCATE('cartouches', v_text_to_parse) > 0, 'cartouches', 'cartouche');
        ELSEIF LOCATE('pcs portables', v_text_to_parse) > 0 OR LOCATE('pc portable', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'laptop';
            SET v_matched_keyword = IF(LOCATE('pcs portables', v_text_to_parse) > 0, 'pcs portables', 'pc portable');
        ELSEIF LOCATE('unités centrales', v_text_to_parse) > 0 OR LOCATE('unité centrale', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'central unit';
            SET v_matched_keyword = IF(LOCATE('unités centrales', v_text_to_parse) > 0, 'unités centrales', 'unité centrale');
        ELSEIF LOCATE('disques durs externes', v_text_to_parse) > 0 OR LOCATE('disque dur externe', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'external hard drive';
            SET v_matched_keyword = IF(LOCATE('disques durs externes', v_text_to_parse) > 0, 'disques durs externes', 'disque dur externe');
        ELSEIF LOCATE('imprimantes', v_text_to_parse) > 0 OR LOCATE('imprimante', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer';
            SET v_matched_keyword = IF(LOCATE('imprimantes', v_text_to_parse) > 0, 'imprimantes', 'imprimante');
        ELSEIF LOCATE('écrans', v_text_to_parse) > 0 OR LOCATE('écran', v_text_to_parse) > 0 OR LOCATE('moniteurs', v_text_to_parse) > 0 OR LOCATE('moniteur', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'monitor';
            SET v_matched_keyword = IF(LOCATE('écrans', v_text_to_parse) > 0, 'écrans',
                IF(LOCATE('moniteurs', v_text_to_parse) > 0, 'moniteurs',
                IF(LOCATE('moniteur', v_text_to_parse) > 0, 'moniteur', 'écran')));
        -- etc: add other keywords as needed
        END IF;

        IF v_detected_type IS NOT NULL THEN
            SET v_equip_text = v_text_to_parse;

            -- remove "pour ..."
            IF LOCATE(' pour ', CONCAT(' ', v_equip_text, ' ')) > 0 THEN
                SET v_equip_text := TRIM(SUBSTRING_INDEX(v_equip_text, 'pour', 1));
            END IF;

            -- remove matched keyword
            IF v_matched_keyword IS NOT NULL AND v_matched_keyword != '' THEN
                SET v_equip_text := TRIM(REPLACE(v_equip_text, v_matched_keyword, ''));
            END IF;

            -- loop quantity times
            SET v_i := 0;
            WHILE v_i < v_quantity DO
                SET v_new_ref := get_ref();
                INSERT INTO stk (division, user, equip, type, designation, statut, stk_stat, origine, ref, floor, bureau)
                VALUES (NEW.division, NEW.person, v_equip_text, v_detected_type, NEW.job, 'bon_état', 'actif', 'expense', v_new_ref, v_floor_num, v_bureau_num);

                SET v_inserted_stk_id := LAST_INSERT_ID();

                IF v_inserted_stk_id IS NOT NULL THEN
                    SELECT code_stk INTO v_stk_code FROM stk WHERE id = v_inserted_stk_id;
                    INSERT INTO trk (name, id_stk, movement_date, movement_type, responsable, service, floor, bureau, type, division, ref, code_stk)
                    VALUES (CONCAT(v_equip_text, ' ', v_detected_type), v_inserted_stk_id, CURDATE(), 'in', NEW.person, NEW.job, v_floor_num, v_bureau_num, v_detected_type, NEW.division, v_new_ref, v_stk_code);
                END IF;
                SET v_i := v_i + 1;
            END WHILE;
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_depense_update` AFTER UPDATE ON `depense` FOR EACH ROW BEGIN
    DECLARE v_text_to_parse VARCHAR(255);
    DECLARE v_detected_type VARCHAR(100) DEFAULT NULL;
    DECLARE v_matched_keyword VARCHAR(100) DEFAULT NULL;
    DECLARE v_equip_text VARCHAR(255);
    DECLARE v_inserted_stk_id INT;
    DECLARE v_stk_code VARCHAR(100);
    DECLARE v_floor_num VARCHAR(10) DEFAULT '0';
    DECLARE v_bureau_num VARCHAR(10) DEFAULT '0';
    DECLARE v_quantity INT DEFAULT 1;
    DECLARE v_first_word VARCHAR(10);
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_new_ref VARCHAR(100);

    IF NEW.statut = 'terminé' THEN

        -- extract floor/bureau
        SET v_floor_num := SUBSTRING_INDEX(NEW.description, '+', 1);
        SET v_bureau_num := SUBSTRING_INDEX(NEW.description, '+', -1);

        -- clean expense name
        SET v_text_to_parse := LOWER(TRIM(NEW.nom_depense));
        IF LOCATE('achat d''un ', v_text_to_parse) = 1 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 12);
        ELSEIF LOCATE('achat d''une ', v_text_to_parse) = 1 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 13);
        ELSEIF LOCATE('achat de ', v_text_to_parse) = 1 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 9);
        ELSEIF LOCATE('commande de ', v_text_to_parse) = 1 THEN 
            SET v_text_to_parse := SUBSTRING(v_text_to_parse, 12);
        END IF;
        SET v_text_to_parse := TRIM(v_text_to_parse);

        -- detect quantity if first word is number
        SET v_first_word := SUBSTRING_INDEX(v_text_to_parse, ' ', 1);
        IF v_first_word REGEXP '^[0-9]+$' THEN
            SET v_quantity := CAST(v_first_word AS UNSIGNED);
            SET v_text_to_parse := TRIM(SUBSTRING(v_text_to_parse, LENGTH(v_first_word)+1));
        END IF;

        -- detect type (priority order)
        -- toner color
        IF LOCATE('toner de l''imprimante noir', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner noir';
            SET v_matched_keyword = 'toner de l''imprimante noir';
        ELSEIF LOCATE('toner de l''imprimante blue', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner blue';
            SET v_matched_keyword = 'toner de l''imprimante blue';
        ELSEIF LOCATE('toner de l''imprimante jaune', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner jaune';
            SET v_matched_keyword = 'toner de l''imprimante jaune';
        ELSEIF LOCATE('toner de l''imprimante magenta', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner magenta';
            SET v_matched_keyword = 'toner de l''imprimante magenta';
        ELSEIF LOCATE('toner de l''imprimante', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer toner';
            SET v_matched_keyword = 'toner de l''imprimante';
        -- jeux de cartouches (plural and singular)
        ELSEIF LOCATE('jeux de cartouches', v_text_to_parse) > 0 OR LOCATE('jeu de cartouches', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer cartridge set';
            SET v_matched_keyword = IF(LOCATE('jeux de cartouches', v_text_to_parse) > 0, 'jeux de cartouches', 'jeu de cartouches');
        ELSEIF LOCATE('cartouches', v_text_to_parse) > 0 OR LOCATE('cartouche', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer cartridge';
            SET v_matched_keyword = IF(LOCATE('cartouches', v_text_to_parse) > 0, 'cartouches', 'cartouche');
        ELSEIF LOCATE('pcs portables', v_text_to_parse) > 0 OR LOCATE('pc portable', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'laptop';
            SET v_matched_keyword = IF(LOCATE('pcs portables', v_text_to_parse) > 0, 'pcs portables', 'pc portable');
        ELSEIF LOCATE('unités centrales', v_text_to_parse) > 0 OR LOCATE('unité centrale', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'central unit';
            SET v_matched_keyword = IF(LOCATE('unités centrales', v_text_to_parse) > 0, 'unités centrales', 'unité centrale');
        ELSEIF LOCATE('disques durs externes', v_text_to_parse) > 0 OR LOCATE('disque dur externe', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'external hard drive';
            SET v_matched_keyword = IF(LOCATE('disques durs externes', v_text_to_parse) > 0, 'disques durs externes', 'disque dur externe');
        ELSEIF LOCATE('imprimantes', v_text_to_parse) > 0 OR LOCATE('imprimante', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'printer';
            SET v_matched_keyword = IF(LOCATE('imprimantes', v_text_to_parse) > 0, 'imprimantes', 'imprimante');
        ELSEIF LOCATE('écrans', v_text_to_parse) > 0 OR LOCATE('écran', v_text_to_parse) > 0 OR LOCATE('moniteurs', v_text_to_parse) > 0 OR LOCATE('moniteur', v_text_to_parse) > 0 THEN
            SET v_detected_type = 'monitor';
            SET v_matched_keyword = IF(LOCATE('écrans', v_text_to_parse) > 0, 'écrans',
                IF(LOCATE('moniteurs', v_text_to_parse) > 0, 'moniteurs',
                IF(LOCATE('moniteur', v_text_to_parse) > 0, 'moniteur', 'écran')));
        -- etc: add other keywords as needed
        END IF;

        IF v_detected_type IS NOT NULL THEN
            SET v_equip_text = v_text_to_parse;

            -- remove "pour ..."
            IF LOCATE(' pour ', CONCAT(' ', v_equip_text, ' ')) > 0 THEN
                SET v_equip_text := TRIM(SUBSTRING_INDEX(v_equip_text, 'pour', 1));
            END IF;

            -- remove matched keyword
            IF v_matched_keyword IS NOT NULL AND v_matched_keyword != '' THEN
                SET v_equip_text := TRIM(REPLACE(v_equip_text, v_matched_keyword, ''));
            END IF;

            -- loop quantity times
            SET v_i := 0;
            WHILE v_i < v_quantity DO
                SET v_new_ref := get_ref();
                INSERT INTO stk (division, user, equip, type, designation, statut, stk_stat, origine, ref, floor, bureau)
                VALUES (NEW.division, NEW.person, v_equip_text, v_detected_type, NEW.job, 'Neuf', 'actif', 'expense', v_new_ref, v_floor_num, v_bureau_num);

                SET v_inserted_stk_id := LAST_INSERT_ID();

                IF v_inserted_stk_id IS NOT NULL THEN
                    SELECT code_stk INTO v_stk_code FROM stk WHERE id = v_inserted_stk_id;
                    INSERT INTO trk (name, id_stk, movement_date, movement_type, responsable, service, floor, bureau, type, division, ref, code_stk)
                    VALUES (CONCAT(v_equip_text, ' ', v_detected_type), v_inserted_stk_id, CURDATE(), 'in', NEW.person, NEW.job, v_floor_num, v_bureau_num, v_detected_type, NEW.division, v_new_ref, v_stk_code);
                END IF;
                SET v_i := v_i + 1;
            END WHILE;
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_dep_ref` BEFORE INSERT ON `depense` FOR EACH ROW BEGIN
IF NEW.ref IS NULL
   OR TRIM(NEW.ref) = ''
   OR LOWER(TRIM(NEW.ref)) = 'pns'
   OR LOWER(TRIM(NEW.ref)) = 'pas de numéro de série'
THEN
    SET NEW.ref = get_ref();
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `depense_after_delete` AFTER DELETE ON `depense` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('depense', 'DELETE', OLD.id_depense, CONCAT('Événement avec l''ID : ', OLD.id_depense, ' a été supprimé définitivement.'), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `depense_after_insert` AFTER INSERT ON `depense` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('depense', 'INSERT', NEW.id_depense, CONCAT('Événement ajouté sous Le Nom : ', NEW.nom_depense), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `depense_after_update` AFTER UPDATE ON `depense` FOR EACH ROW BEGIN
    DECLARE log_details_text TEXT DEFAULT '';

    IF OLD.statut != 'inactif' AND NEW.statut = 'inactif' THEN
        INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
        VALUES ('depense', 'DELETE', NEW.nom_depense, CONCAT('Dépense avec Le Nom : ', NEW.id_depense, ' a été marquée comme inactive.'), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
    ELSE
        IF NOT (OLD.nom_depense <=> NEW.nom_depense) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''nom_depense'' changé de ''', IFNULL(OLD.nom_depense, 'NULL'), ''' à ''', IFNULL(NEW.nom_depense, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.ref <=> NEW.ref) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''ref'' changé de ''', IFNULL(OLD.ref, 'NULL'), ''' à ''', IFNULL(NEW.ref, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.date_dac <=> NEW.date_dac) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''date_dac'' changé de ''', IFNULL(OLD.date_dac, 'NULL'), ''' à ''', IFNULL(NEW.date_dac, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.fournisseur <=> NEW.fournisseur) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''fournisseur'' changé de ''', IFNULL(OLD.fournisseur, 'NULL'), ''' à ''', IFNULL(NEW.fournisseur, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.division <=> NEW.division) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''division'' changé de ''', IFNULL(OLD.division, 'NULL'), ''' à ''', IFNULL(NEW.division, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.person <=> NEW.person) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''person'' changé de ''', IFNULL(OLD.person, 'NULL'), ''' à ''', IFNULL(NEW.person, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.job <=> NEW.job) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''job'' changé de ''', IFNULL(OLD.job, 'NULL'), ''' à ''', IFNULL(NEW.job, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.adresse <=> NEW.adresse) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''adresse'' changé. ');
        END IF;
        IF NOT (OLD.commentaire <=> NEW.commentaire) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''commentaire'' changé. ');
        END IF;
        IF NOT (OLD.description <=> NEW.description) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''description'' changé. ');
        END IF;
        IF NOT (OLD.statut <=> NEW.statut) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''statut'' changé de ''', IFNULL(OLD.statut, 'NULL'), ''' à ''', IFNULL(NEW.statut, 'NULL'), '''. ');
        END IF;

        IF log_details_text != '' THEN
            INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
            VALUES ('depense', 'UPDATE', NEW.id_depense, CONCAT('Mise à jour pour la dépense ID ', NEW.id_depense, ': ', log_details_text), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `events_log`
--

CREATE TABLE `events_log` (
  `log_id` int(11) NOT NULL,
  `table_name` varchar(50) NOT NULL,
  `action_type` varchar(10) NOT NULL,
  `record_id` int(11) DEFAULT NULL,
  `log_details` text DEFAULT NULL,
  `user_who_changed` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `action_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `events_log`
--

INSERT INTO `events_log` (`log_id`, `table_name`, `action_type`, `record_id`, `log_details`, `user_who_changed`, `user_name`, `action_time`) VALUES
(1, 'stk', 'DELETE', 176, 'L\'équipement \'4  gl57\' avec le statut \'Neuf\' (ID: 176) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(2, 'stk', 'DELETE', 177, 'L\'équipement \'lbp6030\' avec le statut \'Neuf\' (ID: 177) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(3, 'stk', 'DELETE', 178, 'L\'équipement \'lbp6030\' avec le statut \'Neuf\' (ID: 178) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(4, 'stk', 'DELETE', 179, 'L\'équipement \'lbp6030\' avec le statut \'Neuf\' (ID: 179) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(5, 'stk', 'DELETE', 180, 'L\'équipement \'dell\' avec le statut \'Neuf\' (ID: 180) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(6, 'stk', 'DELETE', 181, 'L\'équipement \'dell\' avec le statut \'Neuf\' (ID: 181) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(7, 'stk', 'DELETE', 182, 'L\'équipement \'dell\' avec le statut \'Neuf\' (ID: 182) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(8, 'stk', 'DELETE', 183, 'L\'équipement \'dell\' avec le statut \'Neuf\' (ID: 183) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(9, 'stk', 'DELETE', 184, 'L\'équipement \'dell\' avec le statut \'Neuf\' (ID: 184) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(10, 'stk', 'DELETE', 185, 'L\'équipement \'lenovo thinkpadl340\' avec le statut \'Neuf\' (ID: 185) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(11, 'stk', 'DELETE', 186, 'L\'équipement \'lenovo thinkpadl340\' avec le statut \'Neuf\' (ID: 186) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(12, 'stk', 'DELETE', 187, 'L\'équipement \'lenovo thinkpadl340\' avec le statut \'Neuf\' (ID: 187) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(13, 'stk', 'DELETE', 188, 'L\'équipement \'lenovo thinkpadl340\' avec le statut \'Neuf\' (ID: 188) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(14, 'stk', 'DELETE', 189, 'L\'équipement \'lenovo thinkpadl340\' avec le statut \'Neuf\' (ID: 189) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(15, 'stk', 'DELETE', 190, 'L\'équipement \'asus tufgaming16\' avec le statut \'Neuf\' (ID: 190) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(16, 'stk', 'DELETE', 191, 'L\'équipement \'asus tufgaming16\' avec le statut \'Neuf\' (ID: 191) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(17, 'stk', 'DELETE', 192, 'L\'équipement \'asus tufgaming16\' avec le statut \'Neuf\' (ID: 192) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(18, 'stk', 'DELETE', 193, 'L\'équipement \'asus tufgaming16\' avec le statut \'Neuf\' (ID: 193) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(19, 'stk', 'DELETE', 194, 'L\'équipement \'asus tufgaming16\' avec le statut \'Neuf\' (ID: 194) a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:33'),
(20, 'trk', 'DELETE', 176, 'Enregistrement trk avec l\'ID : 176 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(21, 'trk', 'DELETE', 177, 'Enregistrement trk avec l\'ID : 177 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(22, 'trk', 'DELETE', 178, 'Enregistrement trk avec l\'ID : 178 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(23, 'trk', 'DELETE', 179, 'Enregistrement trk avec l\'ID : 179 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(24, 'trk', 'DELETE', 180, 'Enregistrement trk avec l\'ID : 180 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(25, 'trk', 'DELETE', 181, 'Enregistrement trk avec l\'ID : 181 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(26, 'trk', 'DELETE', 182, 'Enregistrement trk avec l\'ID : 182 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(27, 'trk', 'DELETE', 183, 'Enregistrement trk avec l\'ID : 183 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(28, 'trk', 'DELETE', 184, 'Enregistrement trk avec l\'ID : 184 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(29, 'trk', 'DELETE', 185, 'Enregistrement trk avec l\'ID : 185 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(30, 'trk', 'DELETE', 186, 'Enregistrement trk avec l\'ID : 186 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(31, 'trk', 'DELETE', 187, 'Enregistrement trk avec l\'ID : 187 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(32, 'trk', 'DELETE', 188, 'Enregistrement trk avec l\'ID : 188 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(33, 'trk', 'DELETE', 189, 'Enregistrement trk avec l\'ID : 189 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(34, 'trk', 'DELETE', 190, 'Enregistrement trk avec l\'ID : 190 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(35, 'trk', 'DELETE', 191, 'Enregistrement trk avec l\'ID : 191 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(36, 'trk', 'DELETE', 192, 'Enregistrement trk avec l\'ID : 192 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(37, 'trk', 'DELETE', 193, 'Enregistrement trk avec l\'ID : 193 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(38, 'trk', 'DELETE', 194, 'Enregistrement trk avec l\'ID : 194 a été supprimé.', 'root@localhost', NULL, '2025-07-07 07:26:47'),
(39, 'depense', 'INSERT', 1, 'Événement ajouté sous Le Nom : achat de 5 jeux de cartouches GL57', '41', 'faysal', '2025-07-07 07:27:47'),
(40, 'stk', 'INSERT', 195, 'Un nouvel équipement a été ajouté : \'gl57\' avec le statut \'Neuf\'.', '41', 'faysal', '2025-07-07 07:27:47'),
(41, 'trk', 'INSERT', 195, 'Nouvel enregistrement trk ajouté sous l\'ID : 195', '41', 'faysal', '2025-07-07 07:27:47'),
(42, 'stk', 'INSERT', 196, 'Un nouvel équipement a été ajouté : \'gl57\' avec le statut \'Neuf\'.', '41', 'faysal', '2025-07-07 07:27:47'),
(43, 'trk', 'INSERT', 196, 'Nouvel enregistrement trk ajouté sous l\'ID : 196', '41', 'faysal', '2025-07-07 07:27:47'),
(44, 'stk', 'INSERT', 197, 'Un nouvel équipement a été ajouté : \'gl57\' avec le statut \'Neuf\'.', '41', 'faysal', '2025-07-07 07:27:47'),
(45, 'trk', 'INSERT', 197, 'Nouvel enregistrement trk ajouté sous l\'ID : 197', '41', 'faysal', '2025-07-07 07:27:47'),
(46, 'stk', 'INSERT', 198, 'Un nouvel équipement a été ajouté : \'gl57\' avec le statut \'Neuf\'.', '41', 'faysal', '2025-07-07 07:27:47'),
(47, 'trk', 'INSERT', 198, 'Nouvel enregistrement trk ajouté sous l\'ID : 198', '41', 'faysal', '2025-07-07 07:27:47'),
(48, 'stk', 'INSERT', 199, 'Un nouvel équipement a été ajouté : \'gl57\' avec le statut \'Neuf\'.', '41', 'faysal', '2025-07-07 07:27:47'),
(49, 'trk', 'INSERT', 199, 'Nouvel enregistrement trk ajouté sous l\'ID : 199', '41', 'faysal', '2025-07-07 07:27:47'),
(50, 'stk', 'INSERT', 200, 'Un nouvel équipement a été ajouté : \'changer toner jaune de l\' canon 3025i\' avec le statut \'DF\'.', '41', 'faysal', '2025-07-07 12:03:52'),
(51, 'taches', 'INSERT', 1, 'Nouvelle tâche ajoutée sous Le Nom De : changer toner Jaune de l\'imprimante canon 3025I', '41', 'faysal', '2025-07-07 12:03:52'),
(52, 'taches', 'DELETE', 1, 'Tâche avec l\'ID : 1 a été supprimée définitivement.', 'root@localhost', NULL, '2025-07-07 12:07:02'),
(53, 'stk', 'INSERT', 201, 'Un nouvel équipement a été ajouté : \'changer  blue de l\'imprimante canon 3025i\' avec le statut \'DF\'.', '41', 'faysal', '2025-07-07 12:49:25'),
(54, 'taches', 'INSERT', 2, 'Nouvelle tâche ajoutée sous Le Nom De : changer toner blue de l\'imprimante canon 3025I', '41', 'faysal', '2025-07-07 12:49:25'),
(55, 'stk', 'INSERT', 202, 'Un nouvel équipement a été ajouté : \'changer  blue de l\'imprimante canon 3025i\' avec le statut \'DF\'.', '41', 'faysal', '2025-07-07 12:50:29'),
(56, 'taches', 'INSERT', 3, 'Nouvelle tâche ajoutée sous Le Nom De : changer toner blue de l\'imprimante canon 3025I', '41', 'faysal', '2025-07-07 12:50:29'),
(57, 'stk', 'INSERT', 203, 'Un nouvel équipement a été ajouté : \'canon 3025i\' avec le statut \'DF\'.', '41', 'faysal', '2025-07-07 13:01:59'),
(58, 'taches', 'INSERT', 4, 'Nouvelle tâche ajoutée sous Le Nom De : changer toner magenta de l\'imprimante canon 3025I', '41', 'faysal', '2025-07-07 13:01:59'),
(59, 'stk', 'UPDATE', 73, 'L\'équipement \'APC\' (statut: \'bon état\') a été mis à jour. Nouvelles valeurs -> Équipement: \'xigmatex\', Statut: \'bon état\'.', 'root@localhost', NULL, '2025-07-07 13:43:16'),
(60, 'stk', 'UPDATE', 74, 'L\'équipement \'xigmatex\' (statut: \'bon état\') a été mis à jour. Nouvelles valeurs -> Équipement: \'apc\', Statut: \'bon état\'.', 'root@localhost', NULL, '2025-07-07 13:43:22'),
(61, 'stk', 'INSERT', 204, 'Un nouvel équipement a été ajouté : \'eaton 650va\' avec le statut \'2+1\'.', '41', 'faysal', '2025-07-07 13:43:42'),
(62, 'taches', 'INSERT', 5, 'Nouvelle tâche ajoutée sous Le Nom De : changer onduleur Eaton 650VA', '41', 'faysal', '2025-07-07 13:43:42'),
(63, 'stk', 'DELETE', 204, 'L\'équipement \'eaton 650va\' avec le statut \'2+1\' (ID: 204) a été supprimé.', 'root@localhost', NULL, '2025-07-07 13:45:41'),
(64, 'stk', 'INSERT', 205, 'Un nouvel équipement a été ajouté : \'eaton 650va\' avec le statut \'2+1\'.', '41', 'faysal', '2025-07-07 13:46:17'),
(65, 'taches', 'INSERT', 6, 'Nouvelle tâche ajoutée sous Le Nom De : changer onduleur Eaton 650VA', '41', 'faysal', '2025-07-07 13:46:17'),
(66, 'taches', 'DELETE', 5, 'Tâche avec l\'ID : 5 a été supprimée définitivement.', 'root@localhost', NULL, '2025-07-07 13:49:01'),
(67, 'stk', 'INSERT', 206, 'Un nouvel équipement a été ajouté : \'eaton 650va\' avec le statut \'2+1\'.', '41', 'faysal', '2025-07-07 13:49:34'),
(68, 'taches', 'INSERT', 7, 'Nouvelle tâche ajoutée sous Le Nom De : changer onduleur Eaton 650VA', '41', 'faysal', '2025-07-07 13:49:34'),
(69, 'stk', 'DELETE', 195, 'L\'équipement \'gl57\' avec le statut \'Neuf\' (ID: 195) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(70, 'stk', 'DELETE', 196, 'L\'équipement \'gl57\' avec le statut \'Neuf\' (ID: 196) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(71, 'stk', 'DELETE', 197, 'L\'équipement \'gl57\' avec le statut \'Neuf\' (ID: 197) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(72, 'stk', 'DELETE', 198, 'L\'équipement \'gl57\' avec le statut \'Neuf\' (ID: 198) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(73, 'stk', 'DELETE', 199, 'L\'équipement \'gl57\' avec le statut \'Neuf\' (ID: 199) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(74, 'stk', 'DELETE', 200, 'L\'équipement \'changer toner jaune de l\' canon 3025i\' avec le statut \'DF\' (ID: 200) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(75, 'stk', 'DELETE', 201, 'L\'équipement \'changer  blue de l\'imprimante canon 3025i\' avec le statut \'DF\' (ID: 201) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(76, 'stk', 'DELETE', 202, 'L\'équipement \'changer  blue de l\'imprimante canon 3025i\' avec le statut \'DF\' (ID: 202) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(77, 'stk', 'DELETE', 203, 'L\'équipement \'canon 3025i\' avec le statut \'DF\' (ID: 203) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(78, 'stk', 'DELETE', 205, 'L\'équipement \'eaton 650va\' avec le statut \'2+1\' (ID: 205) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(79, 'stk', 'DELETE', 206, 'L\'équipement \'eaton 650va\' avec le statut \'2+1\' (ID: 206) a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:17'),
(80, 'trk', 'DELETE', 195, 'Enregistrement trk avec l\'ID : 195 a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:35'),
(81, 'trk', 'DELETE', 196, 'Enregistrement trk avec l\'ID : 196 a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:35'),
(82, 'trk', 'DELETE', 197, 'Enregistrement trk avec l\'ID : 197 a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:35'),
(83, 'trk', 'DELETE', 198, 'Enregistrement trk avec l\'ID : 198 a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:35'),
(84, 'trk', 'DELETE', 199, 'Enregistrement trk avec l\'ID : 199 a été supprimé.', 'root@localhost', NULL, '2025-07-07 14:03:35'),
(85, 'stk', 'INSERT', 176, 'Un nouvel équipement a été ajouté : \'canon 3025i\' avec le statut \'DF\'.', '41', 'faysal', '2025-07-07 14:11:25'),
(86, 'taches', 'INSERT', 1, 'Nouvelle tâche ajoutée sous Le Nom De : changer toner blue de l\'imprimante canon 3025I', '41', 'faysal', '2025-07-07 14:11:25'),
(87, 'stk', 'UPDATE', 66, 'L\'équipement \'D_Link\' (statut: \'bon état\') a été mis à jour. Nouvelles valeurs -> Équipement: \'QX411F5500665\', Statut: \'QX411F5500665\'.', 'root@localhost', NULL, '2025-07-08 07:25:56'),
(88, 'stk', 'UPDATE', 69, 'L\'équipement \'bon ?tat\' (statut: \'printer\') a été mis à jour. Nouvelles valeurs -> Équipement: \'HP W2072A\', Statut: \'HP W2072A\'.', 'root@localhost', NULL, '2025-07-08 07:25:56'),
(89, 'stk', 'UPDATE', 70, 'L\'équipement \'bon ?tat\' (statut: \'monitor\') a été mis à jour. Nouvelles valeurs -> Équipement: \'APC:650VA\', Statut: \'APC:650VA\'.', 'root@localhost', NULL, '2025-07-08 07:25:56'),
(90, 'stk', 'UPDATE', 71, 'L\'équipement \'bon ?tat\' (statut: \'ups\') a été mis à jour. Nouvelles valeurs -> Équipement: \'HP Compaq\', Statut: \'HP Compaq\'.', 'root@localhost', NULL, '2025-07-08 07:25:56'),
(91, 'stk', 'UPDATE', 68, 'L\'équipement \'bon ?tat\' (statut: \'Remplacement demandé\') a été mis à jour. Nouvelles valeurs -> Équipement: \'canon\', Statut: \'Remplacement demandé\'.', 'root@localhost', NULL, '2025-07-08 07:34:00'),
(92, 'stk', 'UPDATE', 68, 'L\'équipement \'canon\' (statut: \'Remplacement demandé\') a été mis à jour. Nouvelles valeurs -> Équipement: \'canon\', Statut: \'bon état\'.', 'root@localhost', NULL, '2025-07-08 08:52:48'),
(93, 'stk', 'UPDATE', 69, 'L\'équipement \'HP W2072A\' (statut: \'HP W2072A\') a été mis à jour. Nouvelles valeurs -> Équipement: \'HP W2072A\', Statut: \'bon état\'.', 'root@localhost', NULL, '2025-07-08 08:52:50'),
(94, 'stk', 'UPDATE', 70, 'L\'équipement \'APC:650VA\' (statut: \'APC:650VA\') a été mis à jour. Nouvelles valeurs -> Équipement: \'APC:650VA\', Statut: \'bon état\'.', 'root@localhost', NULL, '2025-07-08 08:52:52'),
(95, 'stk', 'UPDATE', 71, 'L\'équipement \'HP Compaq\' (statut: \'HP Compaq\') a été mis à jour. Nouvelles valeurs -> Équipement: \'HP Compaq\', Statut: \'bon état\'.', 'root@localhost', NULL, '2025-07-08 08:52:55'),
(96, 'stk', 'UPDATE', 66, 'L\'équipement \'QX411F5500665\' (statut: \'QX411F5500665\') a été mis à jour. Nouvelles valeurs -> Équipement: \'hp\', Statut: \'QX411F5500665\'.', 'root@localhost', NULL, '2025-07-08 08:54:31'),
(97, 'stk', 'UPDATE', 66, 'L\'équipement \'hp\' (statut: \'QX411F5500665\') a été mis à jour. Nouvelles valeurs -> Équipement: \'hp\', Statut: \'bon état\'.', 'root@localhost', NULL, '2025-07-08 08:54:38'),
(98, 'stk', 'INSERT', 177, 'Un nouvel équipement a été ajouté : \'samsung galaxy tab a\' avec le statut \'Démission\'.', '41', 'faysal', '2025-07-09 06:10:47'),
(99, 'taches', 'INSERT', 2, 'Nouvelle tâche ajoutée sous Le Nom De : acquisition D\'une Tablette Samsung Galaxy Tab A', '41', 'faysal', '2025-07-09 06:10:47'),
(100, 'taches', 'DELETE', 2, 'Tâche avec l\'ID : 2 a été supprimée définitivement.', 'root@localhost', NULL, '2025-07-09 06:35:06'),
(101, 'stk', 'DELETE', 177, 'L\'équipement \'samsung galaxy tab a\' avec le statut \'Démission\' (ID: 177) a été supprimé.', 'root@localhost', NULL, '2025-07-09 06:35:15'),
(102, 'stk', 'INSERT', 178, 'Un nouvel équipement a été ajouté : \'samsung galaxy tab a\' avec le statut \'bon état\'.', '41', 'faysal', '2025-07-09 06:49:25'),
(103, 'trk', 'INSERT', 176, 'Nouvel enregistrement trk ajouté sous l\'ID : 176', '41', 'faysal', '2025-07-09 06:49:25'),
(104, 'taches', 'INSERT', 3, 'Nouvelle tâche ajoutée sous Le Nom De : acquisition D\'une Tablette Samsung Galaxy Tab A', '41', 'faysal', '2025-07-09 06:49:25'),
(105, 'trk', 'UPDATE', 13, 'Enregistrement trk avec l\'ID : 13 a été mis à jour.', 'root@localhost', NULL, '2025-07-09 06:59:23'),
(106, 'trk', 'UPDATE', 14, 'Enregistrement trk avec l\'ID : 14 a été mis à jour.', 'root@localhost', NULL, '2025-07-09 06:59:28'),
(107, 'trk', 'UPDATE', 18, 'Enregistrement trk avec l\'ID : 18 a été mis à jour.', 'root@localhost', NULL, '2025-07-09 06:59:33'),
(108, 'trk', 'UPDATE', 17, 'Enregistrement trk avec l\'ID : 17 a été mis à jour.', 'root@localhost', NULL, '2025-07-09 06:59:37'),
(109, 'trk', 'UPDATE', 16, 'Enregistrement trk avec l\'ID : 16 a été mis à jour.', 'root@localhost', NULL, '2025-07-09 06:59:42'),
(110, 'trk', 'UPDATE', 15, 'Enregistrement trk avec l\'ID : 15 a été mis à jour.', 'root@localhost', NULL, '2025-07-09 06:59:47'),
(111, 'depense', 'INSERT', 2, 'Événement ajouté sous Le Nom : paiement de la facture algerie télécom', '41', 'faysal', '2025-07-09 07:16:53'),
(112, 'depense', 'INSERT', 3, 'Événement ajouté sous Le Nom : paiement de  facture algerie télécom', '41', 'faysal', '2025-07-09 07:22:15'),
(114, 'stk', 'INSERT', 180, 'Un nouvel équipement a été ajouté : \'blue limprimante canon 3025i\' avec le statut \'DF\'.', '41', 'faysal', '2025-07-09 07:28:18'),
(115, 'trk', 'INSERT', 177, 'Nouvel enregistrement trk ajouté sous l\'ID : 177', '41', 'faysal', '2025-07-09 07:28:18'),
(116, 'taches', 'INSERT', 4, 'Nouvelle tâche ajoutée sous Le Nom De : changer toner blue de l\'imprimante canon 3025I', '41', 'faysal', '2025-07-09 07:28:18'),
(117, 'taches', 'INSERT', 5, 'Nouvelle tâche ajoutée sous Le Nom De : acquisition D\'un scanner CodeBare Netum', '41', 'faysal', '2025-07-09 07:29:37'),
(118, 'stk', 'INSERT', 181, 'Un nouvel équipement a été ajouté : \'changer toner blue de l\' canon 3025i\' avec le statut \'Neuf\'.', 'root@localhost', NULL, '2025-07-09 08:14:37'),
(119, 'trk', 'INSERT', 178, 'Nouvel enregistrement trk ajouté sous l\'ID : 178', 'root@localhost', NULL, '2025-07-09 08:14:37'),
(120, 'stk', 'INSERT', 182, 'Un nouvel équipement a été ajouté : \'changer toner blue de l\' canon 3025i\' avec le statut \'Neuf\'.', 'root@localhost', NULL, '2025-07-09 08:14:37'),
(121, 'trk', 'INSERT', 179, 'Nouvel enregistrement trk ajouté sous l\'ID : 179', 'root@localhost', NULL, '2025-07-09 08:14:37'),
(122, 'taches', 'INSERT', 6, 'Nouvelle tâche ajoutée sous Le Nom De : acquisition D\'un Scaner Code bare', '41', 'faysal', '2025-07-09 08:20:38'),
(123, 'taches', 'INSERT', 7, 'Nouvelle tâche ajoutée sous Le Nom De : acquisition D\'un Scanner Code bare NETUM', '41', 'faysal', '2025-07-09 08:21:47'),
(124, 'taches', 'INSERT', 8, 'Nouvelle tâche ajoutée sous Le Nom De : acquisition D\'un scanner CodeBare Netum', '41', 'faysal', '2025-07-09 08:26:02'),
(125, 'taches', 'INSERT', 9, 'Nouvelle tâche ajoutée sous Le Nom De : acqusition d\'un scanner codebar NETUM', 'root@localhost', NULL, '2025-07-09 08:28:00'),
(126, 'taches', 'INSERT', 10, 'Nouvelle tâche ajoutée sous Le Nom De : acqusition d\'un scanner codebar NETUM', 'root@localhost', NULL, '2025-07-09 08:28:06'),
(127, 'stk', 'DELETE', 176, 'L\'équipement \'canon 3025i\' avec le statut \'DF\' (ID: 176) a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:28'),
(128, 'stk', 'DELETE', 178, 'L\'équipement \'samsung galaxy tab a\' avec le statut \'bon état\' (ID: 178) a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:28'),
(129, 'stk', 'DELETE', 180, 'L\'équipement \'blue limprimante canon 3025i\' avec le statut \'DF\' (ID: 180) a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:28'),
(130, 'stk', 'DELETE', 181, 'L\'équipement \'changer toner blue de l\' canon 3025i\' avec le statut \'Neuf\' (ID: 181) a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:28'),
(131, 'stk', 'DELETE', 182, 'L\'équipement \'changer toner blue de l\' canon 3025i\' avec le statut \'Neuf\' (ID: 182) a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:28'),
(132, 'trk', 'DELETE', 176, 'Enregistrement trk avec l\'ID : 176 a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:50'),
(133, 'trk', 'DELETE', 177, 'Enregistrement trk avec l\'ID : 177 a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:50'),
(134, 'trk', 'DELETE', 178, 'Enregistrement trk avec l\'ID : 178 a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:50'),
(135, 'trk', 'DELETE', 179, 'Enregistrement trk avec l\'ID : 179 a été supprimé.', 'root@localhost', NULL, '2025-07-09 08:35:50'),
(136, 'stk', 'INSERT', 176, 'Un nouvel équipement a été ajouté : \'codebare netum\' avec le statut \'bon état\'.', '41', 'faysal', '2025-07-09 08:36:29'),
(137, 'trk', 'INSERT', 176, 'Nouvel enregistrement trk ajouté sous l\'ID : 176', '41', 'faysal', '2025-07-09 08:36:29'),
(138, 'taches', 'INSERT', 1, 'Nouvelle tâche ajoutée sous Le Nom De : acquisition D\'un scanner CodeBare Netum', '41', 'faysal', '2025-07-09 08:36:29'),
(139, 'depense', 'INSERT', 4, 'Événement ajouté sous Le Nom : achat d\'un pc portable lenovo', '40', 'fayçal', '2025-07-17 11:43:23'),
(140, 'stk', 'INSERT', 177, 'Un nouvel équipement a été ajouté : \'lenovo\' avec le statut \'Neuf\'.', '40', 'fayçal', '2025-07-17 11:50:50'),
(141, 'trk', 'INSERT', 177, 'Nouvel enregistrement trk ajouté sous l\'ID : 177', '40', 'fayçal', '2025-07-17 11:50:50'),
(142, 'depense', 'UPDATE', 4, 'Mise à jour pour la dépense ID 4: Champ \'statut\' changé de \'pas_encore\' à \'terminé\'. ', '40', 'fayçal', '2025-07-17 11:50:50'),
(143, 'stk', 'INSERT', 178, 'Un nouvel équipement a été ajouté : \'toner d\' canon 3025i\' avec le statut \'Neuf\'.', '40', 'fayçal', '2025-07-20 06:24:34'),
(144, 'trk', 'INSERT', 178, 'Nouvel enregistrement trk ajouté sous l\'ID : 178', '40', 'fayçal', '2025-07-20 06:24:34'),
(145, 'stk', 'INSERT', 179, 'Un nouvel équipement a été ajouté : \'toner d\' canon 3025i\' avec le statut \'Neuf\'.', '40', 'fayçal', '2025-07-20 06:24:34'),
(146, 'trk', 'INSERT', 179, 'Nouvel enregistrement trk ajouté sous l\'ID : 179', '40', 'fayçal', '2025-07-20 06:24:34'),
(147, 'stk', 'INSERT', 180, 'Un nouvel équipement a été ajouté : \'toner d\' canon 3025i\' avec le statut \'Neuf\'.', '40', 'fayçal', '2025-07-20 06:24:34'),
(148, 'trk', 'INSERT', 180, 'Nouvel enregistrement trk ajouté sous l\'ID : 180', '40', 'fayçal', '2025-07-20 06:24:34'),
(149, 'stk', 'INSERT', 181, 'Un nouvel équipement a été ajouté : \'toner d\' canon 3025i\' avec le statut \'Neuf\'.', '40', 'fayçal', '2025-07-20 06:24:34'),
(150, 'trk', 'INSERT', 181, 'Nouvel enregistrement trk ajouté sous l\'ID : 181', '40', 'fayçal', '2025-07-20 06:24:34'),
(151, 'depense', 'INSERT', 5, 'Événement ajouté sous Le Nom : achat de 4 toner d\'imprimante canon 3025i', '40', 'fayçal', '2025-07-20 06:24:34');

-- --------------------------------------------------------

--
-- Structure de la table `stk`
--

CREATE TABLE `stk` (
  `id` int(11) NOT NULL,
  `division` varchar(20) DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `user` varchar(50) DEFAULT NULL,
  `floor` int(11) DEFAULT NULL,
  `bureau` varchar(5) DEFAULT NULL,
  `code_stk` varchar(20) DEFAULT NULL,
  `ref` varchar(50) DEFAULT NULL,
  `equip` varchar(50) DEFAULT NULL,
  `statut` varchar(20) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `stk_stat` varchar(10) DEFAULT NULL,
  `origine` varchar(10) DEFAULT NULL,
  `toner_counter` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `stk`
--

INSERT INTO `stk` (`id`, `division`, `designation`, `user`, `floor`, `bureau`, `code_stk`, `ref`, `equip`, `statut`, `type`, `stk_stat`, `origine`, `toner_counter`) VALUES
(1, 'DS', 'agent accueil', 'AKKACHA', 0, '1', '310200102', 'INFU009', 'hp', 'bon état', 'central unit', 'actif', NULL, NULL),
(2, 'DS', 'agent accueil', 'AKKACHA', 0, '1', '310200102', 'HPCNC943PY7X', 'HP', 'bon état', 'monitor', 'actif', NULL, NULL),
(3, 'DS', 'agent accueil', 'AKKACHA', 0, '1', '310200102', '245512', 'Parasonic', 'bon état', 'landline phone', 'actif', NULL, NULL),
(4, 'DS', 'Recouvrement', 'BOUBAKAR', 0, '1', '310200151', 'SIN-20250505-2494', 'HP PRO', 'bon état', 'central unit', 'actif', NULL, NULL),
(5, 'DS', 'Recouvrement', 'BOUBAKAR', 0, '1', '310200151', 'CNC324NWWZ', 'HP', 'bon état', 'monitor', 'actif', NULL, NULL),
(6, 'DS', 'Recouvrement', 'BOUBAKAR', 0, '1', '310200151', 'KX-TS500MX', 'Parasonic', 'bon état', 'landline phone', 'actif', NULL, NULL),
(7, 'DS', 'Recouvrement', 'BOUBAKAR', 0, '1', '310200151', 'E7973012137001147', 'tenda', 'bon état', 'wi-fi access point', 'actif', NULL, NULL),
(8, 'DS', 'Directrice Adjointe', 'LEKHAL', 0, '1', '310200199', 'SIN-20250505-0091', 'LENOVO', 'bon état', 'central unit', 'actif', NULL, NULL),
(9, 'DS', 'Directrice Adjointe', 'LEKHAL', 0, '1', '310200199', 'SIN-20250505-2973', 'EPSON', 'bon état', 'printer', 'actif', NULL, NULL),
(10, 'DS', 'Directrice Adjointe', 'LEKHAL', 0, '1', '310200199', 'S2631-4193V201', 'FAJITSU', 'bon état', 'monitor', 'actif', NULL, NULL),
(11, 'DS', 'Directrice Adjointe', 'LEKHAL', 0, '1', '310200199', 'SIN-20250505-4593', 'ALCATEL', 'bon état', 'landline phone', 'actif', NULL, NULL),
(12, 'DS', 'Directrice Adjointe', 'LEKHAL', 0, '1', '310200199', 'SIN-20250505-4045', 'ETON', 'bon état', 'ups', 'actif', NULL, NULL),
(13, 'DS', 'Secrétaire PDG', 'Sarah', 0, '1', '310200199', 'SIN-20250505-6450', 'HP', 'bon état', 'central unit', 'actif', NULL, NULL),
(14, 'DS', 'Secrétaire PDG', 'Sarah', 0, '1', '310200199', '6CM345055C', 'HP', 'bon état', 'monitor', 'actif', NULL, NULL),
(15, 'DS', 'Secrétaire PDG', 'Sarah', 0, '1', '310200199', 'E2010047890', 'EAST', 'bon état', 'ups', 'actif', NULL, NULL),
(16, 'DS', 'Secrétaire PDG', 'Sarah', 0, '1', '310200199', 'KPJY445925', 'EPSON BX300F', 'bon état', 'printer', 'actif', NULL, NULL),
(17, 'DS', 'Secrétaire PDG', 'Sarah', 0, '1', '310200199', 'FCN0092170060', 'ALCATEL', 'bon état', 'landline phone', 'actif', NULL, NULL),
(18, 'DS', 'Secrétaire PDG', 'Sarah', 0, '1', '310200199', 'KX-FT988FX', 'PANASONIC', 'bon état', 'landline phone', 'actif', NULL, NULL),
(19, 'DS', 'DIA', 'KAMEL', 0, '2', '310200213', '4CE80607KD', 'HP', 'bon état', 'central unit', 'actif', NULL, NULL),
(20, 'DS', 'DIA', 'KAMEL', 0, '2', '310200213', '6CM34NDR1', 'HP', 'bon état', 'monitor', 'actif', NULL, NULL),
(21, 'DS', 'DIA', 'ZINE ELABIDINE', 0, '2', '310200213', 'BX650CI', 'APC', 'bon état', 'ups', 'actif', NULL, NULL),
(22, 'DS', 'DIA', 'ZINE ELABIDINE', 0, '2', '310200213', 'CZC5351NGN', 'hp elite desk', 'bon état', 'central unit', 'actif', NULL, NULL),
(23, 'DS', 'DIA', 'ZINE ELABIDINE', 0, '2', '310200213', 'FCN00921700160', 'HP', 'bon état', 'monitor', 'actif', NULL, NULL),
(24, 'DS', 'DIA', 'PNS', 0, '2', '310200213', '8CG8372ZJ6', 'HP Elite DESK', 'bon état', 'central unit', 'actif', NULL, NULL),
(25, 'DS', 'DIA', 'PNS', 0, '2', '310200213', '3B1236X24134', 'HP', 'bon état', 'monitor', 'actif', NULL, NULL),
(26, 'DS', 'DIA', 'ZAKI', 0, '2', '310200213', '8CG8349JBG', 'HP ELITE DESK', 'bon état', 'monitor', 'actif', NULL, NULL),
(27, 'DS', 'DIA', 'ZAKI', 0, '2', '310200213', '30089004264', 'HIKVISION', 'bon état', 'central unit', 'actif', NULL, NULL),
(28, 'DS', 'DIA', 'MANSOURI ASMAA', 0, '2', '310200213', '3CQ6163949', 'HP', 'bon état', 'monitor', 'actif', NULL, NULL),
(29, 'DS', 'DIA', 'MANSOURI ASMAA', 0, '2', '310200213', 'CZC0098LLD', 'HP PRO', 'bon état', 'monitor', 'actif', NULL, NULL),
(30, 'DS', 'DIA', 'LILYA', 0, '2', '310200213', 'CZC4122658', 'US HP ELITE DESK', 'bon état', 'central unit', 'actif', NULL, NULL),
(31, 'DS', 'DIA', 'LILYA', 0, '2', '310200213', '3CQ61639W1', 'HP V194', 'bon état', 'central unit', 'actif', NULL, NULL),
(32, 'DS', 'DIA', 'LILYA', 0, '2', '310200213', 'SIN-20250505-0112', 'APC 650VA', 'bon état', 'monitor', 'actif', NULL, NULL),
(33, 'DS', 'DIA', 'LATEFA', 0, '2', '310200213', '4CE8122MRQ', 'HP 290G1', 'bon état', 'ups', 'actif', NULL, NULL),
(34, 'DS', 'DIA', 'LATEFA', 0, '2', '310200213', '36Q618173L', 'ECRAN HP', 'bon état', 'central unit', 'actif', NULL, NULL),
(35, 'DS', 'DIA', 'LATEFA', 0, '2', '310200213', '289220', 'fix alcatel', 'bon état', 'monitor', 'actif', NULL, NULL),
(36, 'DS', 'DIA', 'imen', 0, '2', '310200213', 'czc4023bs2', 'un hp', 'bon état', 'landline phone', 'actif', NULL, NULL),
(37, 'DS', 'DIA', 'imen', 0, '2', '310200213', 'cnc804061t', 'ecran hp v214a', 'bon état', 'central unit', 'actif', NULL, NULL),
(38, 'DS', 'DIA', 'imen', 0, '2', '310200213', '9b1736a00874', 'anduleur apc', 'bon état', 'monitor', 'actif', NULL, NULL),
(39, 'DS', 'DIA', 'Noussaiba', 0, '2', '310200213', '4ce8122124', 'uc hp h290', 'bon état', 'ups', 'actif', NULL, NULL),
(40, 'DS', 'DIA', 'Noussaiba', 0, '2', '310200213', 'cnc8080sp8', 'hpv214', 'bon état', 'central unit', 'actif', NULL, NULL),
(41, 'DS', 'DIA', 'mohamed', 0, '4', '310200413', '30088916111', 'HIKVISION', 'bon état', 'monitor', 'actif', NULL, NULL),
(42, 'DS', 'DIA', 'mohamed', 0, '4', '310200413', '8cg8362bkb', 'HP ELITE DESK', 'bon état', 'monitor', 'actif', NULL, NULL),
(43, 'DS', 'DIA', 'mohamed', 0, '4', '310200413', 'SIN-20250505-1210', 'APC', 'bon état', 'central unit', 'actif', NULL, NULL),
(44, 'DS', 'DIA', 'abdelkader', 0, '4', '310200413', 'cnc440ph7f', 'hp w8072a', 'bon état', 'ups', 'actif', NULL, NULL),
(45, 'DS', 'DIA', 'abdelkader', 0, '4', '310200413', '4ce806075x', 'hp w290g1', 'Impressions bloquées', 'monitor', 'actif', NULL, 100),
(46, 'DS', 'DIA', 'abdelkader', 0, '4', '310200413', '5cp338bmq', 'hp', 'bon état', 'central unit', 'actif', NULL, NULL),
(47, 'DS', 'DIA', 'abdelkader', 0, '4', '310200413', '290549', 'alcatel', 'bon état', 'laptop', 'actif', NULL, NULL),
(48, 'DS', 'DIA', 'fathi', 0, '4', '310200413', '4ce8122nyd', 'hp290g1', 'bon état', 'landline phone', 'actif', NULL, NULL),
(49, 'DS', 'DIA', 'fathi', 0, '4', '310200413', 'cnc943pz4r', 'hp', 'bon état', 'central unit', 'actif', NULL, NULL),
(50, 'DS', 'DIA', 'mohamed', 0, '4', '310200413', 'czc508254c', 'hp281g1', 'bon état', 'monitor', 'actif', NULL, NULL),
(51, 'DS', 'DIA', 'mohamed', 0, '4', '310200413', 'cnc8080rjr', 'hp214a', 'bon état', 'central unit', 'actif', NULL, NULL),
(52, 'DS', 'DIA', 'wail', 0, '4', '310200413', 'SIN-20250505-5714', 'HP ELITE DESK', 'Niveaux bas reportés', 'monitor', 'actif', NULL, 20),
(53, 'DS', 'DIA', 'wail', 0, '4', '310200413', 'cnc915058r', 'hp 19ka', 'Maintenance couleur', 'central unit', 'actif', NULL, 100),
(54, 'DS', 'DIA', 'wail', 0, '4', '310200413', 'e201047358', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(55, 'DS', 'DIA', 'haul dia', 0, '0', '310200013', 'rvp1z20086', 'kyocera 25540', 'bon état', 'ups', 'actif', NULL, NULL),
(56, 'DS', 'DIA', 'boubaker', 0, '5', '310200513', 'czc42621ps', 'HP PRO', 'bon état', 'printer', 'actif', NULL, NULL),
(57, 'DS', 'DIA', 'boubaker', 0, '5', '310200513', '2021tkfh13', 'hp197', 'bon état', 'central unit', 'actif', NULL, NULL),
(58, 'DS', 'fin fond dia', 'amine', 0, '5', '310200599', '3cq9141byo', 'hp197', 'bon état', 'monitor', 'actif', NULL, NULL),
(59, 'DS', 'fin fond dia', 'amine', 0, '5', '310200599', '9b1916a06002', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(60, 'DS', 'fin fond dia', 'amine', 0, '5', '310200599', 'trf4380n4d', 'HP PRO 7500', 'bon état', 'ups', 'actif', NULL, NULL),
(61, 'DS', 'fin fond dia', 'amine', 0, '5', '310200599', '226324', 'ip40 alcatel', 'bon état', 'central unit', 'actif', NULL, NULL),
(62, 'DG', 'Batinorm', 'Rachid', 0, '1', '310100172', 'CZC9205YQ5', 'HP Compaq', 'bon état', 'landline phone', 'actif', NULL, NULL),
(63, 'DG', 'Batinorm', 'Rachid', 0, '1', '310100172', 'CNC438P3FY', 'HP W2072A', 'bon état', 'central unit', 'actif', NULL, NULL),
(64, 'DG', 'Batinorm', 'Rachid', 0, '1', '310100172', 'E1911064150', 'EAST 650VA', 'bon état', 'monitor', 'actif', NULL, NULL),
(65, 'DG', 'Batinorm', 'Rachid', 0, '1', '310100172', 'NNCA303126', 'Canon LBP6030', 'bon état', 'ups', 'actif', NULL, NULL),
(66, 'DG', 'Batinorm', 'Rachid', 0, '1', '310100172', 'QX411F5500665', 'hp', 'bon état', 'monitor', 'actif', NULL, NULL),
(67, 'DG', 'DAG', 'Nouredine', 0, '2', '310100271', 'parocd68948064E0200', 'Acer Aspire 5', 'bon état', 'wi-fi access point', 'actif', NULL, NULL),
(68, 'DG', 'comptabilité;CPT Nacéra', 'nacera', 0, '2', '310123199', NULL, 'canon', 'bon état', 'printer', 'actif', NULL, 100),
(69, 'DG', 'comptabilité;CPT Nacéra', 'nacera', 0, '2', '310123199', NULL, 'HP W2072A', 'bon état', 'monitor', 'actif', NULL, NULL),
(70, 'DG', 'comptabilité;CPT Nacéra', 'nacera', 0, '2', '310123199', NULL, 'APC:650VA', 'bon état', 'ups', 'actif', NULL, NULL),
(71, 'DG', 'comptabilité;CPT Nacéra', 'nacera', 0, '2', '310123199', NULL, 'HP Compaq', 'bon état', 'central Unit', 'actif', NULL, NULL),
(72, 'DG', 'Architecte', 'Adbelkader', 2, '1', '310120131', '506250015400R', 'BENQ', 'bon état', 'central unit', 'actif', NULL, NULL),
(73, 'DG', 'Architecte', 'Adbelkader', 2, '1', '310120131', '9BA736A00785', 'xigmatex', 'bon état', 'monitor', 'actif', NULL, NULL),
(74, 'DG', 'Architecte', 'Adbelkader', 2, '1', '310120131', 'SIN-20250505-7574', 'apc', 'bon état', 'ups', 'actif', NULL, NULL),
(75, 'DG', 'Génie Electrique', 'Fatima', 2, '2', '310120299', 'VNV005Q7VW', 'HP Compaq', 'bon état', 'central unit', 'actif', NULL, NULL),
(76, 'DG', 'Génie Electrique', 'Fatima', 2, '2', '310120299', 'BB9K48075', 'EATON', 'bon état', 'monitor', 'actif', NULL, NULL),
(77, 'DG', 'Génie Electrique', 'Fatima', 2, '2', '310120299', 'CZC0112QTT', 'HP COMPAQ 6000', 'bon état', 'ups', 'actif', NULL, NULL),
(78, 'DG', 'Génie Electrique', 'Sabrine', 2, '2', '310120299', 'CZC4124ZHN', 'HP PRO Desk 600G1', 'bon état', 'central unit', 'actif', NULL, NULL),
(79, 'DG', 'Génie Electrique', 'Sabrine', 2, '2', '310120299', 'CNC005Q762', 'HPCompaq LE1711', 'bon état', 'central unit', 'actif', NULL, NULL),
(80, 'DG', 'Génie Electrique', 'Sabrine', 2, '2', '310120299', 'CE29416', 'Thomson', 'Marche Pas', 'monitor', 'actif', NULL, NULL),
(81, 'DG', 'Génie Electrique', 'Sabrine', 2, '2', '310120299', '1LCMN029055', 'Pansonic', 'bon état', 'landline phone', 'actif', NULL, NULL),
(82, 'DG', 'Génie Electrique', 'Sabrine', 2, '2', '310120299', '9BA1916106001', 'APC', 'bon état', 'landline phone', 'actif', NULL, NULL),
(83, 'DG', 'Génie Electrique', 'Meriem', 2, '2', '310120299', 'CZC5351NBB', 'HP EliteDesk 800G1', 'bon état', 'ups', 'actif', NULL, NULL),
(84, 'DG', 'Génie Electrique', 'Meriem', 2, '2', '310120299', '3CQ90901MC', 'HP Compaq LE1711', 'bon état', 'central unit', 'actif', NULL, NULL),
(85, 'DG', 'G?nie M?canique', 'Azzouz', 2, '3', '310120399', '3CQ90901HS', 'HP L17', 'bon état', 'monitor', 'actif', NULL, NULL),
(86, 'DG', 'G?nie M?canique', 'Azzouz', 2, '3', '310120399', 'CZC0112QT3', 'HP COMPAQ 6000 Pro', 'bon état', 'monitor', 'actif', NULL, NULL),
(87, 'DG', 'G?nie M?canique', 'Azzouz', 2, '3', '310120399', '247285', 'Thomson', 'bon état', 'central unit', 'actif', NULL, NULL),
(88, 'DG', 'G?nie M?canique', 'Kassraoui', 2, '3', '310120399', '3CQ90900C4', 'HP L1710', 'bon état', 'landline phone', 'actif', NULL, NULL),
(89, 'DG', 'G?nie M?canique', 'Kassraoui', 2, '3', '310120399', '9B1810A18186', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(90, 'DG', 'G?nie M?canique', 'Kassraoui', 2, '3', '310120399', '4CE8061F3N', 'HP290G1', 'bon état', 'ups', 'actif', NULL, NULL),
(91, 'DG', 'G?nie M?canique', 'Sofiane Benzeama', 2, '3', '310120399', '4CE8122MRN', 'HP290G1', 'Traces sur les derni', 'central unit', 'actif', NULL, NULL),
(92, 'DG', 'G?nie M?canique', 'Sofiane Benzeama', 2, '3', '310120399', 'CNC8080SYT', 'HP V2140', 'bon état', 'central unit', 'actif', NULL, NULL),
(93, 'DG', 'G?nie M?canique', 'Mansour', 2, '3', '310120399', 'CZC0112QT3', 'HP COMPAQ 6000 Pro', 'bon état', 'monitor', 'actif', NULL, NULL),
(94, 'DG', 'G?nie M?canique', 'Mansour', 2, '3', '310120399', 'CN-0P1446-71618-41F', 'Dell Nc', 'bon état', 'central unit', 'actif', NULL, NULL),
(95, 'DG', 'G?nie M?canique', 'Mansour', 2, '3', '310120399', 'SIN-20250505-3041', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(96, 'DG', 'Laboratoire', 'Nehal', 2, '4', '310120434', '247279', 'Alcatel', 'bon état', 'ups', 'actif', NULL, NULL),
(97, 'DG', 'Laboratoire', 'Nehal', 2, '4', '310120434', '4CE8122NFN', 'HP290G1', 'bon état', 'landline phone', 'actif', NULL, NULL),
(98, 'DG', 'Laboratoire', 'Nehal', 2, '4', '310120434', 'CNC004P8D4', 'hp', 'bon état', 'central unit', 'actif', NULL, NULL),
(99, 'DG', 'Laboratoire', 'Manel', 2, '4', '310120434', 'CNC943PY21', 'HP LE1851', 'bon état', 'monitor', 'actif', NULL, NULL),
(100, 'DG', 'Laboratoire', 'Manel', 2, '4', '310120434', '4CE8122NOL', 'HP290G1', 'bon état', 'monitor', 'actif', NULL, NULL),
(101, 'DG', 'Laboratoire', 'Manel', 2, '4', '310120434', '9B1810A18252', 'APC', 'bon état', 'central unit', 'actif', NULL, NULL),
(102, 'DG', 'Laboratoire', 'Manel', 2, '4', '310120434', 'SIN-20250505-2484', 'HP COMPAQ 6000 Pro', 'bon état', 'ups', 'actif', NULL, NULL),
(103, 'DG', 'Laboratoire', 'Ilhem', 2, '4', '310120434', '4CE80607CB', 'HP 290G1', 'bon état', 'central unit', 'actif', NULL, NULL),
(104, 'DG', 'Laboratoire', 'Ilhem', 2, '4', '310120434', '202NTSUM1198', 'Lg22MP410', 'bon état', 'central unit', 'actif', NULL, NULL),
(105, 'DG', 'Laboratoire', 'Ilhem', 2, '4', '310120434', 'E2101028191', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(106, 'DG', 'Laboratoire', 'Ilhem', 2, '4', '310120434', 'SIN-20250505-3299', 'HP Elite', 'bon état', 'ups', 'actif', NULL, NULL),
(107, 'DG', 'Commercial', 'Haul', 2, '0', '310120040', 'SIN-20250505-9041', 'HP LaserJet Pro M201n', 'bon état', 'central unit', 'actif', NULL, NULL),
(108, 'DG', 'Commercial', 'Faysal(Commercial)', 2, '5', '310120540', 'CZC0112QT8', 'HP COMPAQ 6000 Pro', 'bon état', 'printer', 'actif', NULL, NULL),
(109, 'DG', 'Commercial', 'Faysal(Commercial)', 2, '5', '310120540', 'CNC005Q81N', 'HP compaq LE1711', 'bon état', 'central unit', 'actif', NULL, NULL),
(110, 'DG', 'Commercial', 'Asma', 2, '5', '310120540', '6CM3451PR2', 'W197', 'bon état', 'monitor', 'actif', NULL, NULL),
(111, 'DG', 'Commercial', 'Asma', 2, '5', '310120540', 'SIN-20250505-5308', 'EATON', 'Marche Pas', 'monitor', 'actif', NULL, NULL),
(112, 'DG', 'Commercial', 'Asma', 2, '5', '310120540', 'CZC0113QFD', 'HP COMPAQ 6000 Pro', 'bon état', 'ups', 'actif', NULL, NULL),
(113, 'DG', 'Commercial', 'Amel', 2, '5', '310120540', 'BB9K4800113', 'EATON', 'bon état', 'central unit', 'actif', NULL, NULL),
(114, 'DG', 'Commercial', 'Amel', 2, '5', '310120540', '6CM3450555', 'HPW19720', 'bon état', 'ups', 'actif', NULL, NULL),
(115, 'DG', 'Commercial', 'Amel', 2, '5', '310120540', 'CW202ES71ABF', 'HP COMPAQ 6000 Pro', 'bon état', 'monitor', 'actif', NULL, NULL),
(116, 'DG', 'Commercial', 'Nawal Arab', 2, '5', '310120540', 'CW202ES71F5S', 'HP COMPAQ', 'bon état', 'central unit', 'actif', NULL, NULL),
(117, 'DG', 'Commercial', 'Nawal Arab', 2, '5', '310120540', '6CM7853SSS', 'HPW19720', 'bon état', 'central unit', 'actif', NULL, NULL),
(118, 'DG', 'Commercial', 'Nawal Arab', 2, '5', '310120540', 'CB1550A07319', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(119, 'DG', 'Commercial', 'Commercial', 2, '5', '310120540', 'SIN-20250505-9417', 'Canon LBP 6030', 'Marche Pas', 'ups', 'actif', NULL, NULL),
(120, 'DG', 'Commercial', 'Commercial', 2, '5', '310120540', '7LAWM017697', 'Parasonic', 'bon état', 'printer', 'actif', NULL, NULL),
(121, 'DG', 'SDM', 'Salle De R?union', 2, '1', '310120141', '5CG43515XV', 'HP350G1', 'bon état', 'landline phone', 'actif', NULL, NULL),
(122, 'DG', 'Service De March?;Haul', '2', 0, '0', '310100099', 'imprimante', 'HP_ProDesk', NULL, 'laptop', 'actif', NULL, NULL),
(123, 'DG', 'SDM', 'LiLa', 2, '2', '310120241', 'SIN-20250505-1163', 'Canon 3025I', 'bon état', 'printer', 'actif', NULL, NULL),
(124, 'DG', 'SDM', 'LiLa', 2, '2', '310120241', 'E2110098924', 'APC', 'bon état', 'ups', 'actif', NULL, NULL),
(125, 'DG', 'SDM', 'LiLa', 2, '2', '310120241', 'CNC005Q7PB', 'HP Compac LE1711', 'bon état', 'ups', 'actif', NULL, NULL),
(126, 'DG', 'SDM', 'LiLa', 2, '2', '310120241', 'SIN-20250505-7565', 'Epson:L3110', 'bon état', 'monitor', 'actif', NULL, NULL),
(127, 'DG', 'SDM', 'LiLa', 2, '2', '310120241', '3FCMN066179', 'Parasonic', 'bon état', 'printer', 'actif', NULL, NULL),
(128, 'DG', 'SDM', 'Haul', 2, '0', '310120041', 'FQQ47550', 'Canon:Image Runner 25250', 'bon état', 'landline phone', 'actif', NULL, NULL),
(129, 'DG', 'SDM', 'Haul', 2, '0', '310120041', 'RML36599', 'Canon:Image Runner 25250', 'bon état', 'printer', 'actif', NULL, NULL),
(130, 'DG', 'SDM', 'Yasmine', 2, '3', '310120341', 'CZC4023HRD', 'HP Pro3500', 'bon état', 'Central Unit', 'actif', NULL, NULL),
(131, 'DG', 'SDM', 'Yasmine', 2, '3', '310120341', 'cnc005q7jp', 'HP Compac LE1711', 'bon état', 'central unit', 'actif', NULL, NULL),
(132, 'DG', 'SDM', 'Yasmine', 2, '3', '310120341', '3FC61666178', 'Parasonic', 'bon état', 'monitor', 'actif', NULL, NULL),
(133, 'DG', 'SDM', 'Amel', 2, '3', '310120341', '9B2402AQ2370', 'APC', 'bon état', 'landline phone', 'actif', NULL, NULL),
(134, 'DG', 'SDM', 'Amel', 2, '3', '310120341', 'SIN-20250505-4334', 'LG', 'bon état', 'ups', 'actif', NULL, NULL),
(135, 'DG', 'SDM', 'Amel', 2, '3', '310120341', '6CM34505DA', 'HP:W1972A', 'bon état', 'central unit', 'actif', NULL, NULL),
(136, 'DG', 'SDM', 'Amel', 2, '3', '310120341', 'CN49BB70FG', 'HP500052', 'bon état', 'monitor', 'actif', NULL, NULL),
(137, 'DG', 'SDM', 'Hadjer', 2, '3', '310120341', '3.31E+12', 'Unit? Central HP', 'bon état', 'scanner', 'actif', NULL, NULL),
(138, 'DG', 'SDM', 'Hadjer', 2, '3', '310120341', 'CNI24260DRG', 'HP P22VG5', 'bon état', 'central unit', 'actif', NULL, NULL),
(139, 'DG', 'SDM', 'Hadjer', 2, '3', '310120341', '9B2402A02370', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(140, 'DG', 'SDM', 'Kheira', 2, '3', '310120341', '6CM34505D7', 'HP W1972a', 'bon état', 'ups', 'actif', NULL, NULL),
(141, 'DG', 'SDM', 'Kheira', 2, '3', '310120341', 'CZC0112QV5', 'HP CompaQ 6000 Pro', 'bon état', 'monitor', 'actif', NULL, NULL),
(142, 'DG', 'SDM', 'Kheira', 2, '3', '310120341', 'BB9K490C0', 'Eaton', 'bon état', 'central unit', 'actif', NULL, NULL),
(143, 'DG', 'SDM', 'Kheira', 2, '3', '310120341', '4FBFNOO8745', 'Parasonic', 'bon état', 'ups', 'actif', NULL, NULL),
(144, 'DG', 'SDM', 'Ghania', 2, '3', '310120341', '912INWA80169', 'LG L174257', 'bon état', 'landline phone', 'actif', NULL, NULL),
(145, 'DG', 'SDM', 'Ghania', 2, '3', '310120341', 'CZC4023HRW', 'HP PRO 3500', 'bon état', 'monitor', 'actif', NULL, NULL),
(146, 'DG', 'SDM', 'Ghania', 2, '3', '310120341', '21421548205', 'Plus 3E-5600G', 'bon état', 'central unit', 'actif', NULL, NULL),
(147, 'DG', 'SDM', 'Ghania', 2, '3', '310120341', '3lbll802145', 'Parasonic', 'bon état', 'ups', 'actif', NULL, NULL),
(148, 'DG', 'procurment', 'Faiza', 2, '4', '310120442', '3CQ9120THY', 'HP 194V', 'bon état', 'landline phone', 'actif', NULL, NULL),
(149, 'DG', 'procurment', 'Faiza', 2, '4', '310120442', '1JCMN004068', 'Parasonic', 'bon état', 'monitor', 'actif', NULL, NULL),
(150, 'DG', 'procurment', 'Faiza', 2, '4', '310120442', 'BX650LI', 'APC', 'bon état', 'landline phone', 'actif', NULL, NULL),
(151, 'DG', 'procurment', 'Faiza', 2, '4', '310120442', 'BB9K5101A', 'Eaton', 'bon état', 'ups', 'actif', NULL, NULL),
(152, 'DG', 'procurment', 'Thouria', 2, '4', '310120442', 'CZC9263380', 'HPcompaqdx2420', 'bon état', 'ups', 'actif', NULL, NULL),
(153, 'DG', 'procurment', 'Thouria', 2, '4', '310120442', '1JCMN004133', 'Parasonic', 'bon état', 'central unit', 'actif', NULL, NULL),
(154, 'DG', 'procurment', 'Thouria', 2, '4', '310120442', '3CQ6210Q0T', 'HP194V', 'bon état', 'landline phone', 'actif', NULL, NULL),
(155, 'DG', 'procurment', 'Amel Danouni', 2, '4', '310120442', 'CZC0098LKQ', 'Unit? Central HP CompaQ 6000 Pro', 'bon état', 'monitor', 'actif', NULL, NULL),
(156, 'DG', 'procurment', 'Amel Danouni', 2, '4', '310120442', '9B2013A05414', 'APC', 'bon état', 'central unit', 'actif', NULL, NULL),
(157, 'DG', 'procurment', 'Amel Danouni', 2, '4', '310120442', '3CQ0480029C', 'Ecran:HP P19B', 'bon état', 'ups', 'actif', NULL, NULL),
(158, 'DG', 'procurment', 'Ikhlas', 2, '4', '310120442', 'SIN-20250505-8977', 'clone', 'bon état', 'monitor', 'actif', NULL, NULL),
(159, 'DG', 'procurment', 'Ikhlas', 2, '4', '310120442', 'SIN-20250505-1882', 'APC', 'bon état', 'central unit', 'actif', NULL, NULL),
(160, 'DG', 'procurment', 'Ikhlas', 2, '4', '310120442', 'HB011021901176', 'LCD (Clone)', 'bon état', 'ups', 'actif', NULL, NULL),
(161, 'DG', 'procurment', 'Ikhlas', 2, '4', '310120442', 'CZC0112R9T', 'HP LE1851', 'bon état', 'monitor', 'actif', NULL, NULL),
(162, 'DG', 'procurment', 'Mohammed', 2, '4', '310120442', 'CNC945P6TB', 'Hp P19B', 'bon état', 'central unit', 'actif', NULL, NULL),
(163, 'DG', 'procurment', 'Mohammed', 2, '4', '310120442', '9B1643A03091', 'APC 650VA', 'bon état', 'monitor', 'actif', NULL, NULL),
(164, 'DG', 'Import', 'Hamza', 2, '5', '310120543', 'CND72173N6', 'HP250G6', 'bon état', 'ups', 'actif', NULL, NULL),
(165, 'DG', 'Import', 'Sofiane', 2, '5', '310120543', 'CZC0098LKX', 'HP CompaQ 6000 Pro', 'bon état', 'laptop', 'actif', NULL, NULL),
(166, 'DG', 'Import', 'Sofiane', 2, '5', '310120543', '3CQ93858TC', 'HP Compaq LE1711', 'bon état', 'central unit', 'actif', NULL, NULL),
(167, 'DG', 'Import', 'Sofiane', 2, '5', '310120543', '9B1810A17887', 'APC', 'bon état', 'monitor', 'actif', NULL, NULL),
(168, 'DG', 'Import', 'Sofiane', 2, '5', '310120543', 'SIN-20250505-2479', 'Kyocera M2030DN', 'bon état', 'ups', 'actif', NULL, NULL),
(169, 'DG', 'Import', 'Sofiane', 2, '5', '310120543', '3CQ938591G', 'HP Compaq LE1711', 'bon état', 'printer', 'actif', NULL, NULL),
(170, 'DG', 'Import', 'DJAMILA', 2, '5', '310120543', '8CG8372ZNZ', 'HP ELITE DESK 800', 'bon état', 'monitor', 'actif', NULL, NULL),
(171, 'DG', 'Import', 'DJAMILA', 2, '5', '310120543', 'ZLCWN022520', 'Parasonic', 'bon état', 'central unit', 'actif', NULL, NULL),
(172, 'DG', 'Import', 'DJAMILA', 2, '5', '310120543', '3CQ9385916', 'HP Compaq LE1711', 'bon état', 'landline phone', 'actif', NULL, NULL),
(173, 'DG', 'Import', 'DJAMILA', 2, '5', '310120543', 'CZC011QVP', 'HP CompaQ 6000 Pro', 'bon état', 'monitor', 'actif', NULL, NULL),
(174, 'DG', 'Import', 'DJAMILA', 2, '5', '310120543', 'E1902012237', 'EAST', 'bon état', 'central unit', 'actif', NULL, NULL),
(175, 'DG', 'IT', 'faysal', 2, '3', '310120324', 'HP1234578', 'hp15', 'lillllllz', 'laptop', 'actif', 'expense', NULL),
(176, 'DG', 'IT', 'faysal', 4, '0', '3101400310', 'SIN-20250709-001', 'codebare netum', 'bon état', 'scanner', 'actif', 'task', 0),
(177, 'DG', 'IT', 'faysal', 1, '2', '3101102310', 'SIN-20250717-001', 'lenovo', 'Neuf', 'laptop', 'actif', 'expense', NULL),
(178, 'DG', 'IT', 'faysal', 1, '2', '3101102310', 'SIN-20250720-001', 'toner d\' canon 3025i', 'Neuf', 'printer', 'actif', 'expense', NULL),
(179, 'DG', 'IT', 'faysal', 1, '2', '3101102310', 'SIN-20250720-002', 'toner d\' canon 3025i', 'Neuf', 'printer', 'actif', 'expense', NULL),
(180, 'DG', 'IT', 'faysal', 1, '2', '3101102310', 'SIN-20250720-003', 'toner d\' canon 3025i', 'Neuf', 'printer', 'actif', 'expense', NULL),
(181, 'DG', 'IT', 'faysal', 1, '2', '3101102310', 'SIN-20250720-004', 'toner d\' canon 3025i', 'Neuf', 'printer', 'actif', 'expense', NULL);

--
-- Déclencheurs `stk`
--
DELIMITER $$
CREATE TRIGGER `before_insert_stk_ref` BEFORE INSERT ON `stk` FOR EACH ROW BEGIN
    IF NEW.ref IS NULL
    OR LOWER(TRIM(NEW.ref)) = 'pns'
    OR LOWER(TRIM(NEW.ref)) = 'pas de numéro de série' THEN
        SET NEW.ref = get_ref();
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `call_get_code_on_insert` BEFORE INSERT ON `stk` FOR EACH ROW BEGIN
    SET NEW.code_stk = get_code(NEW.division, NEW.designation, NEW.floor, NEW.bureau);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `log_manual_stk_insert` AFTER INSERT ON `stk` FOR EACH ROW BEGIN
    IF NEW.origine IS NULL THEN
        INSERT INTO trk (
            name, 
            id_stk, 
            movement_date, 
            movement_type, 
            responsable,
            service, 
            floor, 
            bureau, 
            type, 
            division, 
            ref, 
            code_stk
        ) VALUES (
            -- On construit un nom simple pour les ajouts manuels
            CONCAT(NEW.type, ' ', NEW.equip),
            NEW.id,
            CURDATE(), -- On utilise la date du jour
            'ajout_initial',
            NEW.user,
            NEW.designation,
            NEW.floor,
            NEW.bureau,
            NEW.type,
            NEW.division,
            NEW.ref,
            NEW.code_stk
        );
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_stk_after_insert` AFTER INSERT ON `stk` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES (
        'stk',
        'INSERT',
        NEW.id,
        CONCAT('Un nouvel équipement a été ajouté : ''', NEW.equip, ''' avec le statut ''', NEW.statut, '''.'),
        IFNULL(@app_user_id, CURRENT_USER()),
        @app_user_name
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_stk_after_update` AFTER UPDATE ON `stk` FOR EACH ROW BEGIN
    -- On n'insère un log que si les colonnes qui nous intéressent ont changé
    IF OLD.equip <> NEW.equip OR OLD.statut <> NEW.statut THEN
        INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
        VALUES (
            'stk',
            'UPDATE',
            NEW.id,
            CONCAT(
                'L''équipement ''', OLD.equip, ''' (statut: ''', OLD.statut, ''') a été mis à jour. ',
                'Nouvelles valeurs -> Équipement: ''', NEW.equip, ''', Statut: ''', NEW.statut, '''.'
            ),
            IFNULL(@app_user_id, CURRENT_USER()),
            @app_user_name
        );
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_stk_before_delete` BEFORE DELETE ON `stk` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES (
        'stk',
        'DELETE',
        OLD.id,
        CONCAT('L''équipement ''', OLD.equip, ''' avec le statut ''', OLD.statut, ''' (ID: ', OLD.id, ') a été supprimé.'),
        IFNULL(@app_user_id, CURRENT_USER()),
        @app_user_name
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `taches`
--

CREATE TABLE `taches` (
  `id_tache` int(11) NOT NULL,
  `nom_tache` varchar(255) NOT NULL,
  `date_debut` date NOT NULL,
  `date_fin` date NOT NULL,
  `demandeur` varchar(255) NOT NULL,
  `division` varchar(50) NOT NULL,
  `realisateur` varchar(255) NOT NULL,
  `local` varchar(12) NOT NULL,
  `description` text DEFAULT NULL,
  `toner_counter` int(11) DEFAULT 0,
  `movement_task` enum('In','Out') NOT NULL,
  `statut_de_la_tache` varchar(50) DEFAULT NULL,
  `task_stat` varchar(255) DEFAULT NULL,
  `id_stk` int(11) DEFAULT NULL,
  `name_stk` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `taches`
--

INSERT INTO `taches` (`id_tache`, `nom_tache`, `date_debut`, `date_fin`, `demandeur`, `division`, `realisateur`, `local`, `description`, `toner_counter`, `movement_task`, `statut_de_la_tache`, `task_stat`, `id_stk`, `name_stk`) VALUES
(1, 'acquisition D\'un scanner CodeBare Netum', '2025-07-08', '2025-07-09', 'ismain', 'DG', 'faysal', '0', 'bon état', 0, 'In', 'terminé', 'actif', 176, NULL);

--
-- Déclencheurs `taches`
--
DELIMITER $$
CREATE TRIGGER `after_taches_update` AFTER UPDATE ON `taches` FOR EACH ROW BEGIN
    -- Declarations
    DECLARE v_detected_type VARCHAR(100) DEFAULT NULL;
    DECLARE v_matched_keyword VARCHAR(100);
    DECLARE v_equip_text VARCHAR(255);
    DECLARE v_text_to_parse TEXT;
    DECLARE v_final_user VARCHAR(255);
    DECLARE v_final_division VARCHAR(255);
    DECLARE v_final_designation VARCHAR(255);
    DECLARE v_final_floor VARCHAR(50);
    DECLARE v_final_bureau VARCHAR(50);
    DECLARE v_existing_floor VARCHAR(50) DEFAULT NULL;
    DECLARE v_existing_bureau VARCHAR(50) DEFAULT NULL;
    DECLARE v_existing_designation VARCHAR(255) DEFAULT NULL;
    DECLARE v_inserted_stk_id INT;
    DECLARE v_stk_code VARCHAR(100);
DECLARE v_ref VARCHAR(50) DEFAULT NULL;

    -- Only run if the task is now 'terminé'
    IF NEW.statut_de_la_tache = 'terminé' AND OLD.statut_de_la_tache != 'terminé' THEN
        SET v_text_to_parse := LOWER(NEW.nom_tache);

        -- Full Keyword Detection with Plural Handling
        IF LOCATE('toner de l''imprimante noir', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner noir'; SET v_matched_keyword = 'toner de l''imprimante noir';
        ELSEIF LOCATE('toner de l''imprimante blue', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner blue'; SET v_matched_keyword = 'toner de l''imprimante blue';
        ELSEIF LOCATE('toner de l''imprimante jaune', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner jaune'; SET v_matched_keyword = 'toner de l''imprimante jaune';
        ELSEIF LOCATE('toner de l''imprimante magenta', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner magenta'; SET v_matched_keyword = 'toner de l''imprimante magenta';
        ELSEIF LOCATE('toner de l''imprimante', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner'; SET v_matched_keyword = 'toner de l''imprimante';
ELSEIF LOCATE('scanner', v_text_to_parse) > 0 OR LOCATE('scanners', v_text_to_parse) > 0 THEN SET v_detected_type = 'scaner'; SET v_matched_keyword = IF(LOCATE('scanners', v_text_to_parse) > 0, 'scanners', 'scanner');
        ELSEIF LOCATE('jeu de cartouches', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer cartridge set'; SET v_matched_keyword = 'jeu de cartouches';
        ELSEIF LOCATE('kit de nettoyage', v_text_to_parse) > 0 OR LOCATE('kits de nettoyage', v_text_to_parse) > 0 THEN SET v_detected_type = 'cleaning kit'; SET v_matched_keyword = IF(LOCATE('kits de nettoyage', v_text_to_parse) > 0, 'kits de nettoyage', 'kit de nettoyage');
        ELSEIF LOCATE('ordinateur portable', v_text_to_parse) > 0 OR LOCATE('pc portable', v_text_to_parse) > 0 OR LOCATE('ordinateurs portables', v_text_to_parse) > 0 OR LOCATE('pcs portables', v_text_to_parse) > 0 THEN SET v_detected_type = 'laptop'; SET v_matched_keyword = IF(LOCATE('ordinateurs portables', v_text_to_parse) > 0, 'ordinateurs portables', IF(LOCATE('pcs portables', v_text_to_parse) > 0, 'pcs portables', IF(LOCATE('pc portable', v_text_to_parse) > 0, 'pc portable', 'ordinateur portable')));
        ELSEIF LOCATE('unité centrale', v_text_to_parse) > 0 OR LOCATE('unités centrales', v_text_to_parse) > 0 THEN SET v_detected_type = 'central unit'; SET v_matched_keyword = IF(LOCATE('unités centrales', v_text_to_parse) > 0, 'unités centrales', 'unité centrale');
        ELSEIF LOCATE('disque dur externe', v_text_to_parse) > 0 OR LOCATE('disques durs externes', v_text_to_parse) > 0 THEN SET v_detected_type = 'external hard drive'; SET v_matched_keyword = IF(LOCATE('disques durs externes', v_text_to_parse) > 0, 'disques durs externes', 'disque dur externe');
        ELSEIF LOCATE('point d''accès wi-fi', v_text_to_parse) > 0 OR LOCATE('points d''accès wi-fi', v_text_to_parse) > 0 THEN SET v_detected_type = 'wi-fi access point'; SET v_matched_keyword = IF(LOCATE('points d''accès wi-fi', v_text_to_parse) > 0, 'points d''accès wi-fi', 'point d''accès wi-fi');
        ELSEIF LOCATE('caméra de surveillance', v_text_to_parse) > 0 OR LOCATE('caméras de surveillance', v_text_to_parse) > 0 THEN SET v_detected_type = 'surveillance camera'; SET v_matched_keyword = IF(LOCATE('caméras de surveillance', v_text_to_parse) > 0, 'caméras de surveillance', 'caméra de surveillance');
        ELSEIF LOCATE('baie de stockage', v_text_to_parse) > 0 OR LOCATE('baies de stockage', v_text_to_parse) > 0 THEN SET v_detected_type = 'storage bay'; SET v_matched_keyword = IF(LOCATE('baies de stockage', v_text_to_parse) > 0, 'baies de stockage', 'baie de stockage');
        ELSEIF LOCATE('baie de brassage', v_text_to_parse) > 0 OR LOCATE('baies de brassage', v_text_to_parse) > 0 THEN SET v_detected_type = 'patch panel'; SET v_matched_keyword = IF(LOCATE('baies de brassage', v_text_to_parse) > 0, 'baies de brassage', 'baie de brassage');
        ELSEIF LOCATE('imprimante', v_text_to_parse) > 0 OR LOCATE('imprimantes', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer'; SET v_matched_keyword = IF(LOCATE('imprimantes', v_text_to_parse) > 0, 'imprimantes', 'imprimante');
        ELSEIF LOCATE('écran', v_text_to_parse) > 0 OR LOCATE('moniteur', v_text_to_parse) > 0 OR LOCATE('écrans', v_text_to_parse) > 0 OR LOCATE('moniteurs', v_text_to_parse) > 0 THEN SET v_detected_type = 'monitor'; SET v_matched_keyword = IF(LOCATE('écrans', v_text_to_parse) > 0, 'écrans', IF(LOCATE('écran', v_text_to_parse) > 0, 'écran', IF(LOCATE('moniteurs', v_text_to_parse) > 0, 'moniteurs', 'moniteur')));
        ELSEIF LOCATE('adaptateur', v_text_to_parse) > 0 OR LOCATE('adaptateurs', v_text_to_parse) > 0 THEN SET v_detected_type = 'adapter'; SET v_matched_keyword = IF(LOCATE('adaptateurs', v_text_to_parse) > 0, 'adaptateurs', 'adaptateur');
        ELSEIF LOCATE('onduleur', v_text_to_parse) > 0 OR LOCATE('ups', v_text_to_parse) > 0 OR LOCATE('onduleurs', v_text_to_parse) > 0 THEN SET v_detected_type = 'ups'; SET v_matched_keyword = IF(LOCATE('onduleurs', v_text_to_parse) > 0, 'onduleurs', IF(LOCATE('onduleur', v_text_to_parse) > 0, 'onduleur', 'ups'));
        ELSEIF LOCATE('routeur', v_text_to_parse) > 0 OR LOCATE('router', v_text_to_parse) > 0 OR LOCATE('routeurs', v_text_to_parse) > 0 THEN SET v_detected_type = 'router'; SET v_matched_keyword = IF(LOCATE('routeurs', v_text_to_parse) > 0, 'routeurs', IF(LOCATE('routeur', v_text_to_parse) > 0, 'routeur', 'router'));
        ELSEIF LOCATE('téléphone fixe', v_text_to_parse) > 0 OR LOCATE('téléphones fixes', v_text_to_parse) > 0 THEN SET v_detected_type = 'landline phone'; SET v_matched_keyword = IF(LOCATE('téléphones fixes', v_text_to_parse) > 0, 'téléphones fixes', 'téléphone fixe');
        ELSEIF LOCATE('smartphone', v_text_to_parse) > 0 OR LOCATE('smartphones', v_text_to_parse) > 0 THEN SET v_detected_type = 'mobile phone'; SET v_matched_keyword = IF(LOCATE('smartphones', v_text_to_parse) > 0, 'smartphones', 'smartphone');
        ELSEIF LOCATE('téléphone mobile', v_text_to_parse) > 0 OR LOCATE('téléphones mobiles', v_text_to_parse) > 0 THEN SET v_detected_type = 'mobile phone'; SET v_matched_keyword = IF(LOCATE('téléphones mobiles', v_text_to_parse) > 0, 'téléphones mobiles', 'téléphone mobile');
        ELSEIF LOCATE('clé usb', v_text_to_parse) > 0 OR LOCATE('clés usb', v_text_to_parse) > 0 THEN SET v_detected_type = 'usb drive'; SET v_matched_keyword = IF(LOCATE('clés usb', v_text_to_parse) > 0, 'clés usb', 'clé usb');
        ELSEIF LOCATE('projecteur', v_text_to_parse) > 0 OR LOCATE('projecteurs', v_text_to_parse) > 0 THEN SET v_detected_type = 'projector'; SET v_matched_keyword = IF(LOCATE('projecteurs', v_text_to_parse) > 0, 'projecteurs', 'projecteur');
        ELSEIF LOCATE('ruban', v_text_to_parse) > 0 OR LOCATE('rubans', v_text_to_parse) > 0 THEN SET v_detected_type = 'ribbon'; SET v_matched_keyword = IF(LOCATE('rubans', v_text_to_parse) > 0, 'rubans', 'ruban');
ELSEIF LOCATE('scanner', v_text_to_parse) > 0 OR LOCATE('scanners', v_text_to_parse) > 0 THEN SET v_detected_type = 'scaner'; SET v_matched_keyword = IF(LOCATE('scanners', v_text_to_parse) > 0, 'scanners', 'scanner');
        END IF;

        IF v_detected_type IS NOT NULL THEN
            SET v_equip_text = v_text_to_parse;
            IF LOCATE(' pour ', CONCAT(' ', v_equip_text, ' ')) > 0 THEN SET v_equip_text = TRIM(SUBSTRING_INDEX(v_equip_text, 'pour', 1)); END IF;
            IF v_matched_keyword != '' AND v_matched_keyword IS NOT NULL THEN SET v_equip_text = TRIM(REPLACE(v_equip_text, v_matched_keyword, '')); END IF;

            SET v_final_user = NEW.demandeur;
            SET v_final_division = NEW.division;

            IF NEW.movement_task = 'in' THEN
                SET v_final_designation = 'IT';
                SET v_final_floor = '4';
                SET v_final_bureau = '00';
            ELSE
                SELECT floor, bureau, designation INTO v_existing_floor, v_existing_bureau, v_existing_designation FROM stk WHERE user = NEW.demandeur LIMIT 1;
                SET v_final_floor = IFNULL(v_existing_floor, 'N/A');
                SET v_final_bureau = IFNULL(v_existing_bureau, 'N/A');
                SET v_final_designation = IFNULL(v_existing_designation, 'Attribution Directe');
            END IF;

            INSERT INTO stk (division, user, equip, type, designation, statut, stk_stat, origine, toner_counter, floor, bureau)
            VALUES (v_final_division, v_final_user, v_equip_text, v_detected_type, v_final_designation, 'Neuf', 'actif', 'task', IFNULL(NEW.toner_counter, 0), v_final_floor, v_final_bureau);

            SET v_inserted_stk_id = LAST_INSERT_ID();

            IF v_inserted_stk_id IS NOT NULL THEN
                SELECT code_stk INTO v_stk_code FROM stk WHERE id = v_inserted_stk_id;
             
             SET v_ref := get_ref();

                INSERT INTO trk (
    name, id_stk, movement_date, movement_type, responsable,
    service, floor, bureau, type, division, ref, code_stk, toner_counter
) VALUES (
    CONCAT(v_equip_text, ' ', v_detected_type),
    v_inserted_stk_id,
    CURDATE(),
    NEW.movement_task,
    v_final_user,
    v_final_designation,
    v_final_floor,
    v_final_bureau,
    v_detected_type,
    v_final_division,
    v_ref,
    v_stk_code,
    IFNULL(NEW.toner_counter, 0)
);
            END IF;
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_taches_insert` BEFORE INSERT ON `taches` FOR EACH ROW BEGIN
    DECLARE v_detected_type     VARCHAR(100) DEFAULT NULL;
    DECLARE v_matched_keyword   VARCHAR(100) DEFAULT '';
    DECLARE v_equip_text        VARCHAR(255) DEFAULT '';
    DECLARE v_floor_num         VARCHAR(50)  DEFAULT NULL;
    DECLARE v_bureau_num        VARCHAR(50)  DEFAULT NULL;
    DECLARE v_code_stk          VARCHAR(50)  DEFAULT NULL;
    DECLARE v_text_to_parse     TEXT;
    DECLARE v_final_designation VARCHAR(255);
    DECLARE v_final_user        VARCHAR(255);
DECLARE v_ref VARCHAR(50) DEFAULT NULL;

    SET v_text_to_parse := LOWER(NEW.nom_tache);

    -- Step 1: depense if achat/commande/demande
    IF LOCATE('achat', v_text_to_parse) > 0
        OR LOCATE('commande', v_text_to_parse) > 0
        OR LOCATE('demande', v_text_to_parse) > 0 THEN

        INSERT INTO depense (
            nom_depense, person, division, description,
            date_dac, statut, stat_dep, ref, commentaire
        ) VALUES (
            NEW.nom_tache, NEW.demandeur, NEW.division, NEW.description,
            CURDATE(), 'en cours', 'actif', '',
            IF(NEW.movement_task='in','Pour Stock IT','Pour Attribution Directe')
        );

    ELSE
        -- Step 2: keyword detection (29)
        IF LOCATE('toner', v_text_to_parse)>0 AND LOCATE('imprimante', v_text_to_parse)>0 THEN
            IF LOCATE('jaune', v_text_to_parse)>0 THEN
                SET v_detected_type='printer toner jaune'; SET v_matched_keyword='toner';
            ELSEIF LOCATE('magenta', v_text_to_parse)>0 THEN
                SET v_detected_type='printer toner magenta'; SET v_matched_keyword='toner';
            ELSEIF LOCATE('blue', v_text_to_parse)>0 THEN
                SET v_detected_type='printer toner blue'; SET v_matched_keyword='toner';
            ELSEIF LOCATE('noir', v_text_to_parse)>0 THEN
                SET v_detected_type='printer toner noir'; SET v_matched_keyword='toner';
            ELSE
                SET v_detected_type='printer toner'; SET v_matched_keyword='toner';
            END IF;

        ELSEIF LOCATE('jeu de cartouches', v_text_to_parse)>0 THEN
            SET v_detected_type='printer cartridge set'; SET v_matched_keyword='jeu de cartouches';
        ELSEIF LOCATE('tablette', v_text_to_parse)>0 THEN
            SET v_detected_type='tablet'; SET v_matched_keyword='tablette';
        ELSEIF LOCATE('kit de nettoyage', v_text_to_parse)>0 OR LOCATE('kits de nettoyage', v_text_to_parse)>0 THEN
            SET v_detected_type='cleaning kit';
            SET v_matched_keyword=IF(LOCATE('kits de nettoyage',v_text_to_parse)>0,'kits de nettoyage','kit de nettoyage');
        ELSEIF LOCATE('ordinateur portable',v_text_to_parse)>0 OR LOCATE('ordinateurs portables',v_text_to_parse)>0
            OR LOCATE('pc portable',v_text_to_parse)>0 OR LOCATE('pcs portables',v_text_to_parse)>0 THEN
            SET v_detected_type='laptop';
            SET v_matched_keyword=IF(LOCATE('ordinateurs portables',v_text_to_parse)>0,'ordinateurs portables',
                IF(LOCATE('pcs portables',v_text_to_parse)>0,'pcs portables',
                IF(LOCATE('pc portable',v_text_to_parse)>0,'pc portable','ordinateur portable')));
        ELSEIF LOCATE('unité centrale',v_text_to_parse)>0 OR LOCATE('unités centrales',v_text_to_parse)>0 THEN
            SET v_detected_type='central unit';
            SET v_matched_keyword=IF(LOCATE('unités centrales',v_text_to_parse)>0,'unités centrales','unité centrale');
        ELSEIF LOCATE('disque dur externe',v_text_to_parse)>0 OR LOCATE('disques durs externes',v_text_to_parse)>0 THEN
            SET v_detected_type='external hard drive';
            SET v_matched_keyword=IF(LOCATE('disques durs externes',v_text_to_parse)>0,'disques durs externes','disque dur externe');
        ELSEIF LOCATE('point d''accès wi-fi',v_text_to_parse)>0 OR LOCATE('points d''accès wi-fi',v_text_to_parse)>0 THEN
            SET v_detected_type='wi-fi access point';
            SET v_matched_keyword=IF(LOCATE('points d''accès wi-fi',v_text_to_parse)>0,'points d''accès wi-fi','point d''accès wi-fi');
        ELSEIF LOCATE('caméra de surveillance',v_text_to_parse)>0 OR LOCATE('caméras de surveillance',v_text_to_parse)>0 THEN
            SET v_detected_type='surveillance camera';
            SET v_matched_keyword=IF(LOCATE('caméras de surveillance',v_text_to_parse)>0,'caméras de surveillance','caméra de surveillance');
        ELSEIF LOCATE('baie de stockage',v_text_to_parse)>0 OR LOCATE('baies de stockage',v_text_to_parse)>0 THEN
            SET v_detected_type='storage bay';
            SET v_matched_keyword=IF(LOCATE('baies de stockage',v_text_to_parse)>0,'baies de stockage','baie de stockage');
        ELSEIF LOCATE('baie de brassage',v_text_to_parse)>0 OR LOCATE('baies de brassage',v_text_to_parse)>0 THEN
            SET v_detected_type='patch panel';
            SET v_matched_keyword=IF(LOCATE('baies de brassage',v_text_to_parse)>0,'baies de brassage','baie de brassage');
        ELSEIF LOCATE('imprimante',v_text_to_parse)>0 OR LOCATE('imprimantes',v_text_to_parse)>0 THEN
            SET v_detected_type='printer';
            SET v_matched_keyword=IF(LOCATE('imprimantes',v_text_to_parse)>0,'imprimantes','imprimante');
        ELSEIF LOCATE('écran',v_text_to_parse)>0 OR LOCATE('écrans',v_text_to_parse)>0
            OR LOCATE('moniteur',v_text_to_parse)>0 OR LOCATE('moniteurs',v_text_to_parse)>0 THEN
            SET v_detected_type='monitor';
            SET v_matched_keyword=IF(LOCATE('écrans',v_text_to_parse)>0,'écrans',
                IF(LOCATE('moniteurs',v_text_to_parse)>0,'moniteurs',
                IF(LOCATE('moniteur',v_text_to_parse)>0,'moniteur','écran')));
        ELSEIF LOCATE('adaptateur',v_text_to_parse)>0 OR LOCATE('adaptateurs',v_text_to_parse)>0 THEN
            SET v_detected_type='adapter';
            SET v_matched_keyword=IF(LOCATE('adaptateurs',v_text_to_parse)>0,'adaptateurs','adaptateur');
        ELSEIF LOCATE('onduleur',v_text_to_parse)>0 OR LOCATE('onduleurs',v_text_to_parse)>0 OR LOCATE('ups',v_text_to_parse)>0 THEN
            SET v_detected_type='ups';
            SET v_matched_keyword=IF(LOCATE('onduleurs',v_text_to_parse)>0,'onduleurs',
                IF(LOCATE('ups',v_text_to_parse)>0,'ups','onduleur'));
        ELSEIF LOCATE('routeur',v_text_to_parse)>0 OR LOCATE('routeurs',v_text_to_parse)>0 OR LOCATE('router',v_text_to_parse)>0 THEN
            SET v_detected_type='router';
            SET v_matched_keyword=IF(LOCATE('routeurs',v_text_to_parse)>0,'routeurs',
                IF(LOCATE('router',v_text_to_parse)>0,'router','routeur'));
        ELSEIF LOCATE('téléphone fixe',v_text_to_parse)>0 OR LOCATE('téléphones fixes',v_text_to_parse)>0 THEN
            SET v_detected_type='landline phone';
            SET v_matched_keyword=IF(LOCATE('téléphones fixes',v_text_to_parse)>0,'téléphones fixes','téléphone fixe');
        ELSEIF LOCATE('smartphone',v_text_to_parse)>0 OR LOCATE('smartphones',v_text_to_parse)>0
            OR LOCATE('téléphone mobile',v_text_to_parse)>0 OR LOCATE('téléphones mobiles',v_text_to_parse)>0 THEN
            SET v_detected_type='mobile phone';
            SET v_matched_keyword=IF(LOCATE('smartphones',v_text_to_parse)>0,'smartphones',
                IF(LOCATE('téléphones mobiles',v_text_to_parse)>0,'téléphones mobiles',
                IF(LOCATE('téléphone mobile',v_text_to_parse)>0,'téléphone mobile','smartphone')));
        ELSEIF LOCATE('clé usb',v_text_to_parse)>0 OR LOCATE('clés usb',v_text_to_parse)>0 THEN
            SET v_detected_type='usb drive';
            SET v_matched_keyword=IF(LOCATE('clés usb',v_text_to_parse)>0,'clés usb','clé usb');
        ELSEIF LOCATE('projecteur',v_text_to_parse)>0 OR LOCATE('projecteurs',v_text_to_parse)>0 THEN
            SET v_detected_type='projector';
            SET v_matched_keyword=IF(LOCATE('projecteurs',v_text_to_parse)>0,'projecteurs','projecteur');
        ELSEIF LOCATE('ruban',v_text_to_parse)>0 OR LOCATE('rubans',v_text_to_parse)>0 THEN
            SET v_detected_type='ribbon';
            SET v_matched_keyword=IF(LOCATE('rubans',v_text_to_parse)>0,'rubans','ruban');
ELSEIF LOCATE('scanner', v_text_to_parse) > 0 OR LOCATE('scanners', v_text_to_parse) > 0 
THEN SET v_detected_type = 'scanner'; 
SET v_matched_keyword = IF(LOCATE('scanners', v_text_to_parse) > 0, 'scanners', 'scanner');
        END IF;

        -- Step 3: if found
        IF v_detected_type IS NOT NULL THEN
            -- clean equip text
            SET v_equip_text = LOWER(NEW.nom_tache);
            IF v_matched_keyword <> '' THEN
                SET v_equip_text = TRIM(SUBSTRING(v_equip_text, LOCATE(v_matched_keyword, v_equip_text) + CHAR_LENGTH(v_matched_keyword)));
            END IF;
            SET v_equip_text = TRIM(REPLACE(REPLACE(REPLACE(v_equip_text,' de ',' '),' d''',' '),' du ',' '));
            SET v_equip_text = TRIM(REPLACE(REPLACE(v_equip_text, '''', ''), '"', ''));

            -- fallback
            SELECT floor, bureau, code_stk
            INTO v_floor_num, v_bureau_num, v_code_stk
            FROM stk WHERE user = NEW.demandeur LIMIT 1;

            -- assign
            IF NEW.movement_task='in' THEN
                SET v_final_designation='IT';
                SET v_final_user=NEW.realisateur;
                SET v_floor_num='4';
                SET v_bureau_num='00';
            ELSEIF NEW.movement_task='out' THEN
                SET v_final_designation=NEW.division;
                SET v_final_user=NEW.demandeur;
                IF LOCATE('+',NEW.local)>0 THEN
                    SET v_floor_num=SUBSTRING_INDEX(NEW.local,'+',1);
                    SET v_bureau_num=SUBSTRING_INDEX(NEW.local,'+',-1);
                END IF;
            ELSE
                SET v_final_designation=NEW.division;
                SET v_final_user=NEW.demandeur;
            END IF;
            -- generate_ref
SET v_ref = get_ref();

            -- stk insert
            INSERT INTO stk (
                division,user,equip,type,designation,
                statut,stk_stat,origine,toner_counter,
                floor,bureau,code_stk
            ) VALUES (
                NEW.division,
                v_final_user,
                v_equip_text,
                v_detected_type,
                v_final_designation,
                IFNULL(NEW.description,'Aucune description'),
                'actif',
                'task',
                IF(v_detected_type LIKE 'printer toner%', NEW.toner_counter,0),
                v_floor_num,
                v_bureau_num,
                v_code_stk
            );
            SET NEW.id_stk=LAST_INSERT_ID();

            -- trk insert
INSERT INTO trk (
    name,id_stk,movement_date,movement_type,responsable,
    service,floor,bureau,type,division,ref,code_stk
) VALUES (
    CONCAT(v_detected_type,' ',v_equip_text),
    NEW.id_stk,
    CURDATE(),
    NEW.movement_task,
    v_final_user,
    v_final_designation,
    v_floor_num,
    v_bureau_num,
    v_detected_type,
    NEW.division,
    v_ref,
    v_code_stk
);
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `taches_after_delete` AFTER DELETE ON `taches` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('taches', 'DELETE', OLD.id_tache, CONCAT('Tâche avec l''ID : ', OLD.id_tache, ' a été supprimée définitivement.'), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `taches_after_insert` AFTER INSERT ON `taches` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('taches', 'INSERT', NEW.id_tache, CONCAT('Nouvelle tâche ajoutée sous Le Nom De : ', NEW.nom_tache), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `taches_after_update` AFTER UPDATE ON `taches` FOR EACH ROW BEGIN
    -- Declarations
    DECLARE v_detected_type VARCHAR(100);
    DECLARE v_matched_keyword VARCHAR(100);
    DECLARE v_equip_text VARCHAR(255);
    DECLARE v_designation_text VARCHAR(255);
    DECLARE v_inserted_stk_id INT;
    DECLARE v_existing_stk_id INT;
    DECLARE v_stk_ref VARCHAR(100);
    DECLARE v_stk_code VARCHAR(100);
    DECLARE v_text_to_parse VARCHAR(255);
    DECLARE v_final_toner_count INT DEFAULT 0;
    DECLARE v_user_for_lookup VARCHAR(255);
    DECLARE v_floor_num VARCHAR(50);
    DECLARE v_bureau_num VARCHAR(50);

    IF OLD.movement_task != NEW.movement_task OR OLD.description != NEW.description OR OLD.toner_counter != NEW.toner_counter THEN
        IF NEW.id_stk IS NOT NULL THEN
            SET v_inserted_stk_id = NEW.id_stk;
            IF NEW.movement_task = 'out' THEN
                SET v_user_for_lookup = NEW.demandeur;
                SELECT floor, bureau INTO v_floor_num, v_bureau_num FROM stk WHERE user = v_user_for_lookup AND stk_stat = 'actif' LIMIT 1;
                UPDATE stk SET user = v_user_for_lookup, floor = IFNULL(v_floor_num, 'N/A'), bureau = IFNULL(v_bureau_num, 'N/A'), statut = NEW.description WHERE id = v_inserted_stk_id;
            ELSEIF NEW.movement_task = 'in' THEN
                UPDATE stk SET user = 'IT', floor = '4', bureau = 'IT', statut = NEW.description, stk_stat = 'actif' WHERE id = v_inserted_stk_id;
            ELSE
                UPDATE stk SET statut = NEW.description, toner_counter = IF(NEW.toner_counter > 0, NEW.toner_counter, toner_counter) WHERE id = v_inserted_stk_id;
            END IF;
        ELSE
            SET v_text_to_parse := LOWER(NEW.nom_tache);

            -- Keyword Detection (Corrected Order)
            IF LOCATE('toner de l''imprimante noir', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner noir'; SET v_matched_keyword = 'toner de l''imprimante noir';
            ELSEIF LOCATE('toner de l''imprimante blue', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner blue'; SET v_matched_keyword = 'toner de l''imprimante blue';
            ELSEIF LOCATE('toner de l''imprimante jaune', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner jaune'; SET v_matched_keyword = 'toner de l''imprimante jaune';
            ELSEIF LOCATE('toner de l''imprimante magenta', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner magenta'; SET v_matched_keyword = 'toner de l''imprimante magenta';
            ELSEIF LOCATE('toner de l''imprimante', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer toner'; SET v_matched_keyword = 'toner de l''imprimante';
            ELSEIF LOCATE('jeu de cartouches', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer cartridge set'; SET v_matched_keyword = 'jeu de cartouches';
            ELSEIF LOCATE('kit de nettoyage', v_text_to_parse) > 0 THEN SET v_detected_type = 'cleaning kit'; SET v_matched_keyword = 'kit de nettoyage';
            ELSEIF LOCATE('point d''accès wi-fi', v_text_to_parse) > 0 THEN SET v_detected_type = 'wi-fi access point'; SET v_matched_keyword = 'point d''accès wi-fi';
            ELSEIF LOCATE('disque dur externe', v_text_to_parse) > 0 THEN SET v_detected_type = 'external hard drive'; SET v_matched_keyword = 'disque dur externe';
            ELSEIF LOCATE('téléphone mobile', v_text_to_parse) > 0 THEN SET v_detected_type = 'mobile phone'; SET v_matched_keyword = 'téléphone mobile';
            ELSEIF LOCATE('téléphone fixe', v_text_to_parse) > 0 THEN SET v_detected_type = 'landline phone'; SET v_matched_keyword = 'téléphone fixe';
            ELSEIF LOCATE('unité centrale', v_text_to_parse) > 0 THEN SET v_detected_type = 'central unit'; SET v_matched_keyword = 'unité centrale';
            ELSEIF LOCATE('ordinateur portable', v_text_to_parse) > 0 OR LOCATE('pc portable', v_text_to_parse) > 0 THEN SET v_detected_type = 'laptop'; SET v_matched_keyword = IF(LOCATE('ordinateur portable', v_text_to_parse) > 0, 'ordinateur portable', 'pc portable');
            ELSEIF LOCATE('caméra de surveillance', v_text_to_parse) > 0 THEN SET v_detected_type = 'surveillance camera'; SET v_matched_keyword = 'caméra de surveillance';
            ELSEIF LOCATE('baie de stockage', v_text_to_parse) > 0 THEN SET v_detected_type = 'storage bay'; SET v_matched_keyword = 'baie de stockage';
            ELSEIF LOCATE('baie de brassage', v_text_to_parse) > 0 THEN SET v_detected_type = 'patch panel'; SET v_matched_keyword = 'baie de brassage';
            ELSEIF LOCATE('imprimante', v_text_to_parse) > 0 THEN SET v_detected_type = 'printer'; SET v_matched_keyword = 'imprimante';
            ELSEIF LOCATE('écran', v_text_to_parse) > 0 OR LOCATE('moniteur', v_text_to_parse) > 0 THEN SET v_detected_type = 'monitor'; SET v_matched_keyword = IF(LOCATE('écran', v_text_to_parse) > 0, 'écran', 'moniteur');
            ELSEIF LOCATE('routeur', v_text_to_parse) > 0 OR LOCATE('router', v_text_to_parse) > 0 THEN SET v_detected_type = 'router'; SET v_matched_keyword = IF(LOCATE('routeur', v_text_to_parse) > 0, 'routeur', 'router');
            ELSEIF LOCATE('onduleur', v_text_to_parse) > 0 OR LOCATE('ups', v_text_to_parse) > 0 THEN SET v_detected_type = 'ups'; SET v_matched_keyword = IF(LOCATE('onduleur', v_text_to_parse) > 0, 'onduleur', 'ups');
            ELSEIF LOCATE('smartphone', v_text_to_parse) > 0 THEN SET v_detected_type = 'mobile phone'; SET v_matched_keyword = 'smartphone';
            ELSEIF LOCATE('projecteur', v_text_to_parse) > 0 THEN SET v_detected_type = 'projecteur'; SET v_matched_keyword = 'projecteur';
            ELSEIF LOCATE('adaptateur', v_text_to_parse) > 0 THEN SET v_detected_type = 'adapter'; SET v_matched_keyword = 'adaptateur';
            ELSEIF LOCATE('clé usb', v_text_to_parse) > 0 THEN SET v_detected_type = 'usb drive'; SET v_matched_keyword = 'clé usb';
            ELSEIF LOCATE('ruban', v_text_to_parse) > 0 THEN SET v_detected_type = 'ribbon'; SET v_matched_keyword = 'ruban';
ELSEIF LOCATE('scanner', v_text_to_parse) > 0 OR LOCATE('scanners', v_text_to_parse) > 0 
THEN SET v_detected_type = 'scanner'; 
SET v_matched_keyword = IF(LOCATE('scanners', v_text_to_parse) > 0, 'scanners', 'scanner');
            ELSE SET v_detected_type = 'other'; SET v_matched_keyword = '';

            END IF;

            IF v_matched_keyword != '' AND v_matched_keyword IS NOT NULL THEN
                SET v_equip_text = TRIM(SUBSTRING(v_text_to_parse, LOCATE(v_matched_keyword, v_text_to_parse) + CHAR_LENGTH(v_matched_keyword)));
            ELSE
                SET v_equip_text = v_text_to_parse;
            END IF;

            SELECT id INTO v_existing_stk_id FROM stk WHERE user = NEW.demandeur AND equip LIKE CONCAT('%', v_equip_text, '%') AND type = v_detected_type AND stk_stat = 'actif' ORDER BY id DESC LIMIT 1;

            IF v_existing_stk_id IS NOT NULL THEN
                SET v_inserted_stk_id = v_existing_stk_id;
                UPDATE stk SET statut = NEW.description, toner_counter = IF(NEW.toner_counter > 0, NEW.toner_counter, toner_counter) WHERE id = v_inserted_stk_id;
            ELSE
                INSERT INTO stk (division, user, equip, type, statut, stk_stat, origine, toner_counter) VALUES (NEW.division, NEW.demandeur, v_equip_text, v_detected_type, NEW.description, 'actif', 'task', IFNULL(NEW.toner_counter, 0));
                SET v_inserted_stk_id = LAST_INSERT_ID();
            END IF;

            UPDATE taches SET id_stk = v_inserted_stk_id WHERE id_tache = NEW.id_tache;
        END IF;

        IF v_inserted_stk_id IS NOT NULL THEN
            SELECT equip, type, designation, ref, code_stk, toner_counter, floor, bureau INTO v_equip_text, v_detected_type, v_designation_text, v_stk_ref, v_stk_code, v_final_toner_count, v_floor_num, v_bureau_num FROM stk WHERE id = v_inserted_stk_id;
            INSERT INTO trk (name, id_stk, movement_date, movement_type, responsable, service, type, division, ref, code_stk, toner_counter, floor, bureau) VALUES (CONCAT('Mise à jour: ', v_detected_type, ' ', v_equip_text), v_inserted_stk_id, NEW.date_debut, NEW.movement_task, NEW.demandeur, v_designation_text, v_detected_type, NEW.division, v_stk_ref, v_stk_code, v_final_toner_count, v_floor_num, v_bureau_num);
        END IF;

    END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `trk`
--

CREATE TABLE `trk` (
  `id_trk` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `id_stk` int(11) NOT NULL,
  `movement_date` date NOT NULL,
  `movement_type` varchar(50) NOT NULL,
  `responsable` varchar(100) DEFAULT NULL,
  `service` varchar(100) NOT NULL,
  `floor` int(11) NOT NULL,
  `bureau` varchar(70) DEFAULT NULL,
  `ref` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `division` varchar(50) DEFAULT NULL,
  `code_stk` int(11) DEFAULT NULL,
  `toner_counter` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `trk`
--

INSERT INTO `trk` (`id_trk`, `name`, `id_stk`, `movement_date`, `movement_type`, `responsable`, `service`, `floor`, `bureau`, `ref`, `type`, `division`, `code_stk`, `toner_counter`) VALUES
(1, 'central unit hp', 1, '2025-07-02', 'ajout_initial', 'AKKACHA', 'agent accueil', 0, '1', 'INFU009', 'central unit', 'DS', 310200102, NULL),
(2, 'monitor HP', 2, '2025-07-02', 'ajout_initial', 'AKKACHA', 'agent accueil', 0, '1', 'HPCNC943PY7X', 'monitor', 'DS', 310200102, NULL),
(3, 'landline phone Parasonic', 3, '2025-07-02', 'ajout_initial', 'AKKACHA', 'agent accueil', 0, '1', '245512', 'landline phone', 'DS', 310200102, NULL),
(4, 'central unit HP PRO', 4, '2025-07-02', 'ajout_initial', 'BOUBAKAR', 'Recouvrement', 0, '1', 'SIN-20250505-2494', 'central unit', 'DS', 310200151, NULL),
(5, 'monitor HP', 5, '2025-07-02', 'ajout_initial', 'BOUBAKAR', 'Recouvrement', 0, '1', 'CNC324NWWZ', 'monitor', 'DS', 310200151, NULL),
(6, 'landline phone Parasonic', 6, '2025-07-02', 'ajout_initial', 'BOUBAKAR', 'Recouvrement', 0, '1', 'KX-TS500MX', 'landline phone', 'DS', 310200151, NULL),
(7, 'wi-fi access point tenda', 7, '2025-07-02', 'ajout_initial', 'BOUBAKAR', 'Recouvrement', 0, '1', 'E7973012137001147', 'wi-fi access point', 'DS', 310200151, NULL),
(8, 'central unit LENOVO', 8, '2025-07-02', 'ajout_initial', 'LEKHAL', 'Directrice Adjointe', 0, '1', 'SIN-20250505-0091', 'central unit', 'DS', 310200199, NULL),
(9, 'printer EPSON', 9, '2025-07-02', 'ajout_initial', 'LEKHAL', 'Directrice Adjointe', 0, '1', 'SIN-20250505-2973', 'printer', 'DS', 310200199, NULL),
(10, 'monitor FAJITSU', 10, '2025-07-02', 'ajout_initial', 'LEKHAL', 'Directrice Adjointe', 0, '1', 'S2631-4193V201', 'monitor', 'DS', 310200199, NULL),
(11, 'landline phone ALCATEL', 11, '2025-07-02', 'ajout_initial', 'LEKHAL', 'Directrice Adjointe', 0, '1', 'SIN-20250505-4593', 'landline phone', 'DS', 310200199, NULL),
(12, 'ups ETON', 12, '2025-07-02', 'ajout_initial', 'LEKHAL', 'Directrice Adjointe', 0, '1', 'SIN-20250505-4045', 'ups', 'DS', 310200199, NULL),
(13, 'central unit HP', 13, '2025-07-02', 'ajout_initial', 'Sarah', 'Secrétaire PDG', 0, '1', 'SIN-20250505-6450', 'central unit', 'DS', 310200199, NULL),
(14, 'monitor HP', 14, '2025-07-02', 'ajout_initial', 'Sarah', 'Secrétaire PDG', 0, '1', '6CM345055C', 'monitor', 'DS', 310200199, NULL),
(15, 'ups EAST', 15, '2025-07-02', 'ajout_initial', 'Sarah', 'Secrétaire PDG', 0, '1', 'E2010047890', 'ups', 'DS', 310200199, NULL),
(16, 'printer EPSON BX300F', 16, '2025-07-02', 'ajout_initial', 'Sarah', 'Secrétaire PDG', 0, '1', 'KPJY445925', 'printer', 'DS', 310200199, NULL),
(17, 'landline phone ALCATEL', 17, '2025-07-02', 'ajout_initial', 'Sarah', 'Secrétaire PDG', 0, '1', 'FCN0092170060', 'landline phone', 'DS', 310200199, NULL),
(18, 'fax PANASONIC', 18, '2025-07-02', 'ajout_initial', 'Sarah', 'Secrétaire PDG', 0, '1', 'KX-FT988FX', 'fax', 'DS', 310200199, NULL),
(19, 'central unit HP', 19, '2025-07-02', 'ajout_initial', 'KAMEL', 'DIA', 0, '2', '4CE80607KD', 'central unit', 'DS', 310200213, NULL),
(20, 'monitor HP', 20, '2025-07-02', 'ajout_initial', 'KAMEL', 'DIA', 0, '2', '6CM34NDR1', 'monitor', 'DS', 310200213, NULL),
(21, 'ups APC', 21, '2025-07-02', 'ajout_initial', 'ZINE ELABIDINE', 'DIA', 0, '2', 'BX650CI', 'ups', 'DS', 310200213, NULL),
(22, 'central unit hp elite desk', 22, '2025-07-02', 'ajout_initial', 'ZINE ELABIDINE', 'DIA', 0, '2', 'CZC5351NGN', 'central unit', 'DS', 310200213, NULL),
(23, 'monitor HP', 23, '2025-07-02', 'ajout_initial', 'ZINE ELABIDINE', 'DIA', 0, '2', 'FCN00921700160', 'monitor', 'DS', 310200213, NULL),
(24, 'central unit HP Elite DESK', 24, '2025-07-02', 'ajout_initial', 'PNS', 'DIA', 0, '2', '8CG8372ZJ6', 'central unit', 'DS', 310200213, NULL),
(25, 'monitor HP', 25, '2025-07-02', 'ajout_initial', 'PNS', 'DIA', 0, '2', '3B1236X24134', 'monitor', 'DS', 310200213, NULL),
(26, 'monitor HP ELITE DESK', 26, '2025-07-02', 'ajout_initial', 'ZAKI', 'DIA', 0, '2', '8CG8349JBG', 'monitor', 'DS', 310200213, NULL),
(27, 'central unit HIKVISION', 27, '2025-07-02', 'ajout_initial', 'ZAKI', 'DIA', 0, '2', '30089004264', 'central unit', 'DS', 310200213, NULL),
(28, 'monitor HP', 28, '2025-07-02', 'ajout_initial', 'MANSOURI ASMAA', 'DIA', 0, '2', '3CQ6163949', 'monitor', 'DS', 310200213, NULL),
(29, 'monitor HP PRO', 29, '2025-07-02', 'ajout_initial', 'MANSOURI ASMAA', 'DIA', 0, '2', 'CZC0098LLD', 'monitor', 'DS', 310200213, NULL),
(30, 'central unit US HP ELITE DESK', 30, '2025-07-02', 'ajout_initial', 'LILYA', 'DIA', 0, '2', 'CZC4122658', 'central unit', 'DS', 310200213, NULL),
(31, 'central unit HP V194', 31, '2025-07-02', 'ajout_initial', 'LILYA', 'DIA', 0, '2', '3CQ61639W1', 'central unit', 'DS', 310200213, NULL),
(32, 'monitor APC 650VA', 32, '2025-07-02', 'ajout_initial', 'LILYA', 'DIA', 0, '2', 'SIN-20250505-0112', 'monitor', 'DS', 310200213, NULL),
(33, 'ups HP 290G1', 33, '2025-07-02', 'ajout_initial', 'LATEFA', 'DIA', 0, '2', '4CE8122MRQ', 'ups', 'DS', 310200213, NULL),
(34, 'central unit ECRAN HP', 34, '2025-07-02', 'ajout_initial', 'LATEFA', 'DIA', 0, '2', '36Q618173L', 'central unit', 'DS', 310200213, NULL),
(35, 'monitor fix alcatel', 35, '2025-07-02', 'ajout_initial', 'LATEFA', 'DIA', 0, '2', '289220', 'monitor', 'DS', 310200213, NULL),
(36, 'landline phone un hp', 36, '2025-07-02', 'ajout_initial', 'imen', 'DIA', 0, '2', 'czc4023bs2', 'landline phone', 'DS', 310200213, NULL),
(37, 'central unit ecran hp v214a', 37, '2025-07-02', 'ajout_initial', 'imen', 'DIA', 0, '2', 'cnc804061t', 'central unit', 'DS', 310200213, NULL),
(38, 'monitor anduleur apc', 38, '2025-07-02', 'ajout_initial', 'imen', 'DIA', 0, '2', '9b1736a00874', 'monitor', 'DS', 310200213, NULL),
(39, 'ups uc hp h290', 39, '2025-07-02', 'ajout_initial', 'Noussaiba', 'DIA', 0, '2', '4ce8122124', 'ups', 'DS', 310200213, NULL),
(40, 'central unit hpv214', 40, '2025-07-02', 'ajout_initial', 'Noussaiba', 'DIA', 0, '2', 'cnc8080sp8', 'central unit', 'DS', 310200213, NULL),
(41, 'monitor HIKVISION', 41, '2025-07-02', 'ajout_initial', 'mohamed', 'DIA', 0, '4', '30088916111', 'monitor', 'DS', 310200413, NULL),
(42, 'monitor HP ELITE DESK', 42, '2025-07-02', 'ajout_initial', 'mohamed', 'DIA', 0, '4', '8cg8362bkb', 'monitor', 'DS', 310200413, NULL),
(43, 'central unit APC', 43, '2025-07-02', 'ajout_initial', 'mohamed', 'DIA', 0, '4', 'SIN-20250505-1210', 'central unit', 'DS', 310200413, NULL),
(44, 'ups hp w8072a', 44, '2025-07-02', 'ajout_initial', 'abdelkader', 'DIA', 0, '4', 'cnc440ph7f', 'ups', 'DS', 310200413, NULL),
(45, 'monitor hp w290g1', 45, '2025-07-02', 'ajout_initial', 'abdelkader', 'DIA', 0, '4', '4ce806075x', 'monitor', 'DS', 310200413, NULL),
(46, 'central unit hp', 46, '2025-07-02', 'ajout_initial', 'abdelkader', 'DIA', 0, '4', '5cp338bmq', 'central unit', 'DS', 310200413, NULL),
(47, 'laptop alcatel', 47, '2025-07-02', 'ajout_initial', 'abdelkader', 'DIA', 0, '4', '290549', 'laptop', 'DS', 310200413, NULL),
(48, 'landline phone hp290g1', 48, '2025-07-02', 'ajout_initial', 'fathi', 'DIA', 0, '4', '4ce8122nyd', 'landline phone', 'DS', 310200413, NULL),
(49, 'central unit hp', 49, '2025-07-02', 'ajout_initial', 'fathi', 'DIA', 0, '4', 'cnc943pz4r', 'central unit', 'DS', 310200413, NULL),
(50, 'monitor hp281g1', 50, '2025-07-02', 'ajout_initial', 'mohamed', 'DIA', 0, '4', 'czc508254c', 'monitor', 'DS', 310200413, NULL),
(51, 'central unit hp214a', 51, '2025-07-02', 'ajout_initial', 'mohamed', 'DIA', 0, '4', 'cnc8080rjr', 'central unit', 'DS', 310200413, NULL),
(52, 'monitor HP ELITE DESK', 52, '2025-07-02', 'ajout_initial', 'wail', 'DIA', 0, '4', 'SIN-20250505-5714', 'monitor', 'DS', 310200413, NULL),
(53, 'central unit hp 19ka', 53, '2025-07-02', 'ajout_initial', 'wail', 'DIA', 0, '4', 'cnc915058r', 'central unit', 'DS', 310200413, NULL),
(54, 'monitor APC', 54, '2025-07-02', 'ajout_initial', 'wail', 'DIA', 0, '4', 'e201047358', 'monitor', 'DS', 310200413, NULL),
(55, 'ups kyocera 25540', 55, '2025-07-02', 'ajout_initial', 'haul dia', 'DIA', 0, '0', 'rvp1z20086', 'ups', 'DS', 310200013, NULL),
(56, 'printer HP PRO', 56, '2025-07-02', 'ajout_initial', 'boubaker', 'DIA', 0, '5', 'czc42621ps', 'printer', 'DS', 310200513, NULL),
(57, 'central unit hp197', 57, '2025-07-02', 'ajout_initial', 'boubaker', 'DIA', 0, '5', '2021tkfh13', 'central unit', 'DS', 310200513, NULL),
(58, 'monitor hp197', 58, '2025-07-02', 'ajout_initial', 'amine', 'fin fond dia', 0, '5', '3cq9141byo', 'monitor', 'DS', 310200599, NULL),
(59, 'monitor APC', 59, '2025-07-02', 'ajout_initial', 'amine', 'fin fond dia', 0, '5', '9b1916a06002', 'monitor', 'DS', 310200599, NULL),
(60, 'ups HP PRO 7500', 60, '2025-07-02', 'ajout_initial', 'amine', 'fin fond dia', 0, '5', 'trf4380n4d', 'ups', 'DS', 310200599, NULL),
(61, 'central unit ip40 alcatel', 61, '2025-07-02', 'ajout_initial', 'amine', 'fin fond dia', 0, '5', '226324', 'central unit', 'DS', 310200599, NULL),
(62, 'landline phone HP Compaq', 62, '2025-07-02', 'ajout_initial', 'Rachid', 'Batinorm', 0, '1', 'CZC9205YQ5', 'landline phone', 'DG', 310100172, NULL),
(63, 'central unit HP W2072A', 63, '2025-07-02', 'ajout_initial', 'Rachid', 'Batinorm', 0, '1', 'CNC438P3FY', 'central unit', 'DG', 310100172, NULL),
(64, 'monitor EAST 650VA', 64, '2025-07-02', 'ajout_initial', 'Rachid', 'Batinorm', 0, '1', 'E1911064150', 'monitor', 'DG', 310100172, NULL),
(65, 'ups Canon LBP6030', 65, '2025-07-02', 'ajout_initial', 'Rachid', 'Batinorm', 0, '1', 'NNCA303126', 'ups', 'DG', 310100172, NULL),
(66, 'printer D_Link', 66, '2025-07-02', 'ajout_initial', 'Rachid', 'Batinorm', 0, '1', 'QX411F5500665', 'printer', 'DG', 310100172, NULL),
(67, 'wi-fi access point Acer Aspire 5', 67, '2025-07-02', 'ajout_initial', 'Nouredine', 'DAG', 0, '2', 'parocd68948064E0200', 'wi-fi access point', 'DG', 310100271, NULL),
(68, 'actif bon ?tat', 68, '2025-07-02', 'ajout_initial', '0', 'comptabilit?;CPT Nac?ra', 2, '310100252', 'Canon', 'actif', 'DG', 310123199, NULL),
(69, 'actif bon ?tat', 69, '2025-07-02', 'ajout_initial', '0', 'comptabilit?;CPT Nac?ra', 2, '310100252', 'HP W2072A', 'actif', 'DG', 310123199, NULL),
(70, 'actif bon ?tat', 70, '2025-07-02', 'ajout_initial', '0', 'comptabilit?;CPT Nac?ra', 2, '310100252', 'APC:650VA', 'actif', 'DG', 310123199, NULL),
(71, 'actif bon ?tat', 71, '2025-07-02', 'ajout_initial', '0', 'comptabilit?;CPT Nac?ra', 2, '310100252', 'HP Compaq', 'actif', 'DG', 310123199, NULL),
(72, 'central unit BENQ', 72, '2025-07-02', 'ajout_initial', 'Adbelkader', 'Architecte', 2, '1', '506250015400R', 'central unit', 'DG', 310120131, NULL),
(73, 'monitor APC', 73, '2025-07-02', 'ajout_initial', 'Adbelkader', 'Architecte', 2, '1', '9BA736A00785', 'monitor', 'DG', 310120131, NULL),
(74, 'ups xigmatex', 74, '2025-07-02', 'ajout_initial', 'Adbelkader', 'Architecte', 2, '1', 'SIN-20250505-7574', 'ups', 'DG', 310120131, NULL),
(75, 'central unit HP Compaq', 75, '2025-07-02', 'ajout_initial', 'Fatima', 'G?nie Electrique', 2, '2', 'VNV005Q7VW', 'central unit', 'DG', 310120299, NULL),
(76, 'monitor EATON', 76, '2025-07-02', 'ajout_initial', 'Fatima', 'G?nie Electrique', 2, '2', 'BB9K48075', 'monitor', 'DG', 310120299, NULL),
(77, 'ups HP COMPAQ 6000', 77, '2025-07-02', 'ajout_initial', 'Fatima', 'G?nie Electrique', 2, '2', 'CZC0112QTT', 'ups', 'DG', 310120299, NULL),
(78, 'central unit HP PRO Desk 600G1', 78, '2025-07-02', 'ajout_initial', 'Sabrine', 'G?nie Electrique', 2, '2', 'CZC4124ZHN', 'central unit', 'DG', 310120299, NULL),
(79, 'central unit HPCompaq LE1711', 79, '2025-07-02', 'ajout_initial', 'Sabrine', 'G?nie Electrique', 2, '2', 'CNC005Q762', 'central unit', 'DG', 310120299, NULL),
(80, 'monitor Thomson', 80, '2025-07-02', 'ajout_initial', 'Sabrine', 'G?nie Electrique', 2, '2', 'CE29416', 'monitor', 'DG', 310120299, NULL),
(81, 'landline phone Pansonic', 81, '2025-07-02', 'ajout_initial', 'Sabrine', 'G?nie Electrique', 2, '2', '1LCMN029055', 'landline phone', 'DG', 310120299, NULL),
(82, 'landline phone APC', 82, '2025-07-02', 'ajout_initial', 'Sabrine', 'G?nie Electrique', 2, '2', '9BA1916106001', 'landline phone', 'DG', 310120299, NULL),
(83, 'ups HP EliteDesk 800G1', 83, '2025-07-02', 'ajout_initial', 'Meriem', 'G?nie Electrique', 2, '2', 'CZC5351NBB', 'ups', 'DG', 310120299, NULL),
(84, 'central unit HP Compaq LE1711', 84, '2025-07-02', 'ajout_initial', 'Meriem', 'G?nie Electrique', 2, '2', '3CQ90901MC', 'central unit', 'DG', 310120299, NULL),
(85, 'monitor HP L17', 85, '2025-07-02', 'ajout_initial', 'Azzouz', 'G?nie M?canique', 2, '3', '3CQ90901HS', 'monitor', 'DG', 310120399, NULL),
(86, 'monitor HP COMPAQ 6000 Pro', 86, '2025-07-02', 'ajout_initial', 'Azzouz', 'G?nie M?canique', 2, '3', 'CZC0112QT3', 'monitor', 'DG', 310120399, NULL),
(87, 'central unit Thomson', 87, '2025-07-02', 'ajout_initial', 'Azzouz', 'G?nie M?canique', 2, '3', '247285', 'central unit', 'DG', 310120399, NULL),
(88, 'landline phone HP L1710', 88, '2025-07-02', 'ajout_initial', 'Kassraoui', 'G?nie M?canique', 2, '3', '3CQ90900C4', 'landline phone', 'DG', 310120399, NULL),
(89, 'monitor APC', 89, '2025-07-02', 'ajout_initial', 'Kassraoui', 'G?nie M?canique', 2, '3', '9B1810A18186', 'monitor', 'DG', 310120399, NULL),
(90, 'ups HP290G1', 90, '2025-07-02', 'ajout_initial', 'Kassraoui', 'G?nie M?canique', 2, '3', '4CE8061F3N', 'ups', 'DG', 310120399, NULL),
(91, 'central unit HP290G1', 91, '2025-07-02', 'ajout_initial', 'Sofiane Benzeama', 'G?nie M?canique', 2, '3', '4CE8122MRN', 'central unit', 'DG', 310120399, NULL),
(92, 'central unit HP V2140', 92, '2025-07-02', 'ajout_initial', 'Sofiane Benzeama', 'G?nie M?canique', 2, '3', 'CNC8080SYT', 'central unit', 'DG', 310120399, NULL),
(93, 'monitor HP COMPAQ 6000 Pro', 93, '2025-07-02', 'ajout_initial', 'Mansour', 'G?nie M?canique', 2, '3', 'CZC0112QT3', 'monitor', 'DG', 310120399, NULL),
(94, 'central unit Dell Nc', 94, '2025-07-02', 'ajout_initial', 'Mansour', 'G?nie M?canique', 2, '3', 'CN-0P1446-71618-41F', 'central unit', 'DG', 310120399, NULL),
(95, 'monitor APC', 95, '2025-07-02', 'ajout_initial', 'Mansour', 'G?nie M?canique', 2, '3', 'SIN-20250505-3041', 'monitor', 'DG', 310120399, NULL),
(96, 'ups Alcatel', 96, '2025-07-02', 'ajout_initial', 'Nehal', 'Laboratoire', 2, '4', '247279', 'ups', 'DG', 310120434, NULL),
(97, 'landline phone HP290G1', 97, '2025-07-02', 'ajout_initial', 'Nehal', 'Laboratoire', 2, '4', '4CE8122NFN', 'landline phone', 'DG', 310120434, NULL),
(98, 'central unit hp', 98, '2025-07-02', 'ajout_initial', 'Nehal', 'Laboratoire', 2, '4', 'CNC004P8D4', 'central unit', 'DG', 310120434, NULL),
(99, 'monitor HP LE1851', 99, '2025-07-02', 'ajout_initial', 'Manel', 'Laboratoire', 2, '4', 'CNC943PY21', 'monitor', 'DG', 310120434, NULL),
(100, 'monitor HP290G1', 100, '2025-07-02', 'ajout_initial', 'Manel', 'Laboratoire', 2, '4', '4CE8122NOL', 'monitor', 'DG', 310120434, NULL),
(101, 'central unit APC', 101, '2025-07-02', 'ajout_initial', 'Manel', 'Laboratoire', 2, '4', '9B1810A18252', 'central unit', 'DG', 310120434, NULL),
(102, 'ups HP COMPAQ 6000 Pro', 102, '2025-07-02', 'ajout_initial', 'Manel', 'Laboratoire', 2, '4', 'SIN-20250505-2484', 'ups', 'DG', 310120434, NULL),
(103, 'central unit HP 290G1', 103, '2025-07-02', 'ajout_initial', 'Ilhem', 'Laboratoire', 2, '4', '4CE80607CB', 'central unit', 'DG', 310120434, NULL),
(104, 'central unit Lg22MP410', 104, '2025-07-02', 'ajout_initial', 'Ilhem', 'Laboratoire', 2, '4', '202NTSUM1198', 'central unit', 'DG', 310120434, NULL),
(105, 'monitor APC', 105, '2025-07-02', 'ajout_initial', 'Ilhem', 'Laboratoire', 2, '4', 'E2101028191', 'monitor', 'DG', 310120434, NULL),
(106, 'ups HP Elite', 106, '2025-07-02', 'ajout_initial', 'Ilhem', 'Laboratoire', 2, '4', 'SIN-20250505-3299', 'ups', 'DG', 310120434, NULL),
(107, 'central unit HP LaserJet Pro M201n', 107, '2025-07-02', 'ajout_initial', 'Haul', 'Commercial', 2, '0', 'SIN-20250505-9041', 'central unit', 'DG', 310120040, NULL),
(108, 'printer HP COMPAQ 6000 Pro', 108, '2025-07-02', 'ajout_initial', 'Faysal(Commercial)', 'Commercial', 2, '5', 'CZC0112QT8', 'printer', 'DG', 310120540, NULL),
(109, 'central unit HP compaq LE1711', 109, '2025-07-02', 'ajout_initial', 'Faysal(Commercial)', 'Commercial', 2, '5', 'CNC005Q81N', 'central unit', 'DG', 310120540, NULL),
(110, 'monitor W197', 110, '2025-07-02', 'ajout_initial', 'Asma', 'Commercial', 2, '5', '6CM3451PR2', 'monitor', 'DG', 310120540, NULL),
(111, 'monitor EATON', 111, '2025-07-02', 'ajout_initial', 'Asma', 'Commercial', 2, '5', 'SIN-20250505-5308', 'monitor', 'DG', 310120540, NULL),
(112, 'ups HP COMPAQ 6000 Pro', 112, '2025-07-02', 'ajout_initial', 'Asma', 'Commercial', 2, '5', 'CZC0113QFD', 'ups', 'DG', 310120540, NULL),
(113, 'central unit EATON', 113, '2025-07-02', 'ajout_initial', 'Amel', 'Commercial', 2, '5', 'BB9K4800113', 'central unit', 'DG', 310120540, NULL),
(114, 'ups HPW19720', 114, '2025-07-02', 'ajout_initial', 'Amel', 'Commercial', 2, '5', '6CM3450555', 'ups', 'DG', 310120540, NULL),
(115, 'monitor HP COMPAQ 6000 Pro', 115, '2025-07-02', 'ajout_initial', 'Amel', 'Commercial', 2, '5', 'CW202ES71ABF', 'monitor', 'DG', 310120540, NULL),
(116, 'central unit HP COMPAQ', 116, '2025-07-02', 'ajout_initial', 'Nawal Arab', 'Commercial', 2, '5', 'CW202ES71F5S', 'central unit', 'DG', 310120540, NULL),
(117, 'central unit HPW19720', 117, '2025-07-02', 'ajout_initial', 'Nawal Arab', 'Commercial', 2, '5', '6CM7853SSS', 'central unit', 'DG', 310120540, NULL),
(118, 'monitor APC', 118, '2025-07-02', 'ajout_initial', 'Nawal Arab', 'Commercial', 2, '5', 'CB1550A07319', 'monitor', 'DG', 310120540, NULL),
(119, 'ups Canon LBP 6030', 119, '2025-07-02', 'ajout_initial', 'Commercial', 'Commercial', 2, '5', 'SIN-20250505-9417', 'ups', 'DG', 310120540, NULL),
(120, 'printer Parasonic', 120, '2025-07-02', 'ajout_initial', 'Commercial', 'Commercial', 2, '5', '7LAWM017697', 'printer', 'DG', 310120540, NULL),
(121, 'landline phone HP350G1', 121, '2025-07-02', 'ajout_initial', 'Salle De R?union', 'SDM', 2, '1', '5CG43515XV', 'landline phone', 'DG', 310120141, NULL),
(122, 'laptop HP_ProDesk', 122, '2025-07-02', 'ajout_initial', '2', 'Service De March?;Haul', 0, '0', 'imprimante', 'laptop', 'DG', 310100099, NULL),
(123, 'printer Canon 3025I', 123, '2025-07-02', 'ajout_initial', 'LiLa', 'SDM', 2, '2', 'SIN-20250505-1163', 'printer', 'DG', 310120241, NULL),
(124, 'ups APC', 124, '2025-07-02', 'ajout_initial', 'LiLa', 'SDM', 2, '2', 'E2110098924', 'ups', 'DG', 310120241, NULL),
(125, 'ups HP Compac LE1711', 125, '2025-07-02', 'ajout_initial', 'LiLa', 'SDM', 2, '2', 'CNC005Q7PB', 'ups', 'DG', 310120241, NULL),
(126, 'monitor Epson:L3110', 126, '2025-07-02', 'ajout_initial', 'LiLa', 'SDM', 2, '2', 'SIN-20250505-7565', 'monitor', 'DG', 310120241, NULL),
(127, 'printer Parasonic', 127, '2025-07-02', 'ajout_initial', 'LiLa', 'SDM', 2, '2', '3FCMN066179', 'printer', 'DG', 310120241, NULL),
(128, 'landline phone Canon:Image Runner 25250', 128, '2025-07-02', 'ajout_initial', 'Haul', 'SDM', 2, '0', 'FQQ47550', 'landline phone', 'DG', 310120041, NULL),
(129, 'printer Canon:Image Runner 25250', 129, '2025-07-02', 'ajout_initial', 'Haul', 'SDM', 2, '0', 'RML36599', 'printer', 'DG', 310120041, NULL),
(130, 'printer Unit? Central:HP Pro3500', 130, '2025-07-02', 'ajout_initial', 'Yasmine', 'SDM', 2, '3', 'CZC4023HRD', 'printer', 'DG', 310120341, NULL),
(131, 'central unit HP Compac LE1711', 131, '2025-07-02', 'ajout_initial', 'Yasmine', 'SDM', 2, '3', 'cnc005q7jp', 'central unit', 'DG', 310120341, NULL),
(132, 'monitor Parasonic', 132, '2025-07-02', 'ajout_initial', 'Yasmine', 'SDM', 2, '3', '3FC61666178', 'monitor', 'DG', 310120341, NULL),
(133, 'landline phone APC', 133, '2025-07-02', 'ajout_initial', 'Amel', 'SDM', 2, '3', '9B2402AQ2370', 'landline phone', 'DG', 310120341, NULL),
(134, 'ups LG', 134, '2025-07-02', 'ajout_initial', 'Amel', 'SDM', 2, '3', 'SIN-20250505-4334', 'ups', 'DG', 310120341, NULL),
(135, 'central unit HP:W1972A', 135, '2025-07-02', 'ajout_initial', 'Amel', 'SDM', 2, '3', '6CM34505DA', 'central unit', 'DG', 310120341, NULL),
(136, 'monitor HP500052', 136, '2025-07-02', 'ajout_initial', 'Amel', 'SDM', 2, '3', 'CN49BB70FG', 'monitor', 'DG', 310120341, NULL),
(137, 'scanner Unit? Central HP', 137, '2025-07-02', 'ajout_initial', 'Hadjer', 'SDM', 2, '3', '3.31E+12', 'scanner', 'DG', 310120341, NULL),
(138, 'central unit HP P22VG5', 138, '2025-07-02', 'ajout_initial', 'Hadjer', 'SDM', 2, '3', 'CNI24260DRG', 'central unit', 'DG', 310120341, NULL),
(139, 'monitor APC', 139, '2025-07-02', 'ajout_initial', 'Hadjer', 'SDM', 2, '3', '9B2402A02370', 'monitor', 'DG', 310120341, NULL),
(140, 'ups HP W1972a', 140, '2025-07-02', 'ajout_initial', 'Kheira', 'SDM', 2, '3', '6CM34505D7', 'ups', 'DG', 310120341, NULL),
(141, 'monitor HP CompaQ 6000 Pro', 141, '2025-07-02', 'ajout_initial', 'Kheira', 'SDM', 2, '3', 'CZC0112QV5', 'monitor', 'DG', 310120341, NULL),
(142, 'central unit Eaton', 142, '2025-07-02', 'ajout_initial', 'Kheira', 'SDM', 2, '3', 'BB9K490C0', 'central unit', 'DG', 310120341, NULL),
(143, 'ups Parasonic', 143, '2025-07-02', 'ajout_initial', 'Kheira', 'SDM', 2, '3', '4FBFNOO8745', 'ups', 'DG', 310120341, NULL),
(144, 'landline phone LG L174257', 144, '2025-07-02', 'ajout_initial', 'Ghania', 'SDM', 2, '3', '912INWA80169', 'landline phone', 'DG', 310120341, NULL),
(145, 'monitor HP PRO 3500', 145, '2025-07-02', 'ajout_initial', 'Ghania', 'SDM', 2, '3', 'CZC4023HRW', 'monitor', 'DG', 310120341, NULL),
(146, 'central unit Plus 3E-5600G', 146, '2025-07-02', 'ajout_initial', 'Ghania', 'SDM', 2, '3', '21421548205', 'central unit', 'DG', 310120341, NULL),
(147, 'ups Parasonic', 147, '2025-07-02', 'ajout_initial', 'Ghania', 'SDM', 2, '3', '3lbll802145', 'ups', 'DG', 310120341, NULL),
(148, 'landline phone HP 194V', 148, '2025-07-02', 'ajout_initial', 'Faiza', 'procurment', 2, '4', '3CQ9120THY', 'landline phone', 'DG', 310120442, NULL),
(149, 'monitor Parasonic', 149, '2025-07-02', 'ajout_initial', 'Faiza', 'procurment', 2, '4', '1JCMN004068', 'monitor', 'DG', 310120442, NULL),
(150, 'landline phone APC', 150, '2025-07-02', 'ajout_initial', 'Faiza', 'procurment', 2, '4', 'BX650LI', 'landline phone', 'DG', 310120442, NULL),
(151, 'ups Eaton', 151, '2025-07-02', 'ajout_initial', 'Faiza', 'procurment', 2, '4', 'BB9K5101A', 'ups', 'DG', 310120442, NULL),
(152, 'ups HPcompaqdx2420', 152, '2025-07-02', 'ajout_initial', 'Thouria', 'procurment', 2, '4', 'CZC9263380', 'ups', 'DG', 310120442, NULL),
(153, 'central unit Parasonic', 153, '2025-07-02', 'ajout_initial', 'Thouria', 'procurment', 2, '4', '1JCMN004133', 'central unit', 'DG', 310120442, NULL),
(154, 'landline phone HP194V', 154, '2025-07-02', 'ajout_initial', 'Thouria', 'procurment', 2, '4', '3CQ6210Q0T', 'landline phone', 'DG', 310120442, NULL),
(155, 'monitor Unit? Central HP CompaQ 6000 Pro', 155, '2025-07-02', 'ajout_initial', 'Amel Danouni', 'procurment', 2, '4', 'CZC0098LKQ', 'monitor', 'DG', 310120442, NULL),
(156, 'central unit APC', 156, '2025-07-02', 'ajout_initial', 'Amel Danouni', 'procurment', 2, '4', '9B2013A05414', 'central unit', 'DG', 310120442, NULL),
(157, 'ups Ecran:HP P19B', 157, '2025-07-02', 'ajout_initial', 'Amel Danouni', 'procurment', 2, '4', '3CQ0480029C', 'ups', 'DG', 310120442, NULL),
(158, 'monitor clone', 158, '2025-07-02', 'ajout_initial', 'Ikhlas', 'procurment', 2, '4', 'SIN-20250505-8977', 'monitor', 'DG', 310120442, NULL),
(159, 'central unit APC', 159, '2025-07-02', 'ajout_initial', 'Ikhlas', 'procurment', 2, '4', 'SIN-20250505-1882', 'central unit', 'DG', 310120442, NULL),
(160, 'ups LCD (Clone)', 160, '2025-07-02', 'ajout_initial', 'Ikhlas', 'procurment', 2, '4', 'HB011021901176', 'ups', 'DG', 310120442, NULL),
(161, 'monitor HP LE1851', 161, '2025-07-02', 'ajout_initial', 'Ikhlas', 'procurment', 2, '4', 'CZC0112R9T', 'monitor', 'DG', 310120442, NULL),
(162, 'central unit Hp P19B', 162, '2025-07-02', 'ajout_initial', 'Mohammed', 'procurment', 2, '4', 'CNC945P6TB', 'central unit', 'DG', 310120442, NULL),
(163, 'monitor APC 650VA', 163, '2025-07-02', 'ajout_initial', 'Mohammed', 'procurment', 2, '4', '9B1643A03091', 'monitor', 'DG', 310120442, NULL),
(164, 'ups HP250G6', 164, '2025-07-02', 'ajout_initial', 'Hamza', 'Import', 2, '5', 'CND72173N6', 'ups', 'DG', 310120543, NULL),
(165, 'laptop HP CompaQ 6000 Pro', 165, '2025-07-02', 'ajout_initial', 'Sofiane', 'Import', 2, '5', 'CZC0098LKX', 'laptop', 'DG', 310120543, NULL),
(166, 'central unit HP Compaq LE1711', 166, '2025-07-02', 'ajout_initial', 'Sofiane', 'Import', 2, '5', '3CQ93858TC', 'central unit', 'DG', 310120543, NULL),
(167, 'monitor APC', 167, '2025-07-02', 'ajout_initial', 'Sofiane', 'Import', 2, '5', '9B1810A17887', 'monitor', 'DG', 310120543, NULL),
(168, 'ups Kyocera M2030DN', 168, '2025-07-02', 'ajout_initial', 'Sofiane', 'Import', 2, '5', 'SIN-20250505-2479', 'ups', 'DG', 310120543, NULL),
(169, 'printer HP Compaq LE1711', 169, '2025-07-02', 'ajout_initial', 'Sofiane', 'Import', 2, '5', '3CQ938591G', 'printer', 'DG', 310120543, NULL),
(170, 'monitor HP ELITE DESK 800', 170, '2025-07-02', 'ajout_initial', 'DJAMILA', 'Import', 2, '5', '8CG8372ZNZ', 'monitor', 'DG', 310120543, NULL),
(171, 'central unit Parasonic', 171, '2025-07-02', 'ajout_initial', 'DJAMILA', 'Import', 2, '5', 'ZLCWN022520', 'central unit', 'DG', 310120543, NULL),
(172, 'landline phone HP Compaq LE1711', 172, '2025-07-02', 'ajout_initial', 'DJAMILA', 'Import', 2, '5', '3CQ9385916', 'landline phone', 'DG', 310120543, NULL),
(173, 'monitor HP CompaQ 6000 Pro', 173, '2025-07-02', 'ajout_initial', 'DJAMILA', 'Import', 2, '5', 'CZC011QVP', 'monitor', 'DG', 310120543, NULL),
(174, 'central unit EAST', 174, '2025-07-02', 'ajout_initial', 'DJAMILA', 'Import', 2, '5', 'E1902012237', 'central unit', 'DG', 310120543, NULL),
(175, 'hp15 laptop', 175, '2025-07-02', 'in', 'faysal', 'IT', 2, '3', 'HP1234578', 'laptop', 'DG', 310120324, NULL),
(176, 'scanner codebare netum', 176, '2025-07-09', 'In', 'faysal', 'IT', 4, '00', 'SIN-20250709-001', 'scanner', 'DG', NULL, NULL),
(177, 'lenovo laptop', 177, '2025-07-17', 'in', 'faysal', 'IT', 1, '2', 'SIN-20250717-001', 'laptop', 'DG', 2147483647, NULL),
(178, 'toner d\' canon 3025i printer', 178, '2025-07-20', 'in', 'faysal', 'IT', 1, '2', 'SIN-20250720-001', 'printer', 'DG', 2147483647, NULL),
(179, 'toner d\' canon 3025i printer', 179, '2025-07-20', 'in', 'faysal', 'IT', 1, '2', 'SIN-20250720-002', 'printer', 'DG', 2147483647, NULL),
(180, 'toner d\' canon 3025i printer', 180, '2025-07-20', 'in', 'faysal', 'IT', 1, '2', 'SIN-20250720-003', 'printer', 'DG', 2147483647, NULL),
(181, 'toner d\' canon 3025i printer', 181, '2025-07-20', 'in', 'faysal', 'IT', 1, '2', 'SIN-20250720-004', 'printer', 'DG', 2147483647, NULL);

--
-- Déclencheurs `trk`
--
DELIMITER $$
CREATE TRIGGER `trk_after_delete` AFTER DELETE ON `trk` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('trk', 'DELETE', OLD.id_trk, CONCAT('Enregistrement trk avec l''ID : ', OLD.id_trk, ' a été supprimé.'), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trk_after_insert` AFTER INSERT ON `trk` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('trk', 'INSERT', NEW.id_trk, CONCAT('Nouvel enregistrement trk ajouté sous l''ID : ', NEW.id_trk), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trk_after_update` AFTER UPDATE ON `trk` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('trk', 'UPDATE', NEW.id_trk, CONCAT('Enregistrement trk avec l''ID : ', NEW.id_trk, ' a été mis à jour.'), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `ID_De_Compte` int(11) NOT NULL,
  `Nom_Complet` varchar(255) NOT NULL,
  `Username` varchar(100) NOT NULL,
  `Password` varchar(70) NOT NULL,
  `passbh` varchar(12) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Date_D_Integration` date NOT NULL,
  `Permission` enum('administrateur','modérateur','compte standard') NOT NULL,
  `stat_user` enum('actif','inactif') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`ID_De_Compte`, `Nom_Complet`, `Username`, `Password`, `passbh`, `Email`, `Date_D_Integration`, `Permission`, `stat_user`) VALUES
(1, 'faysal fafa', 'opiy', '123456', '', 'lol@exmaple.com', '2025-01-08', 'administrateur', 'actif'),
(2, 'Sophie Martin', 'smartin', '$2y$10$LnphHlEKl32Ul4ZTl.3VJefKYezZjJbxLmE7h3Rx/8SFEqYsxAOR6', '', 'smartin@example.com', '2024-02-15', 'modérateur', 'actif'),
(3, 'Alex Durand', 'adurand', '12369', '', 'adurand@example.com', '2024-01-10', 'compte standard', 'inactif'),
(4, 'Emma Lefevre', 'elefevre', '', '', 'elefevre@example.com', '2023-12-22', 'modérateur', 'actif'),
(5, 'Lucas Moreau', 'lmoreau', '', '', 'lmoreau@example.com', '2023-11-30', 'administrateur', 'actif'),
(6, 'Camille Robert', 'crobert', '1234', '', 'crobert@example.com', '2023-10-25', 'administrateur', 'inactif'),
(7, 'Léo Bernard', 'lbernard', '', '', 'lbernard@example.com', '2023-09-14', 'modérateur', 'actif'),
(8, 'Julie Petit', 'jpetit', '123456', '', 'jpetit@example.com', '2023-08-05', 'administrateur', 'actif'),
(9, 'Nathan Rousseau', 'nrousseau', '', '', 'nrousseau@example.com', '2023-07-20', 'administrateur', 'actif'),
(10, 'Clara Vincent', 'cvincent', '', '', 'cvincent@example.com', '2023-06-18', 'compte standard', 'actif'),
(11, 'Mathieu Thomas', 'mthomas', '', '', 'mthomas@example.com', '2023-05-09', 'compte standard', 'actif'),
(12, 'Anaïs Richarsq', 'arichard', '', '', 'arichard@example.com', '2023-04-12', 'administrateur', 'actif'),
(13, 'Bastien Leroy', 'bleroy', '', '', 'bleroy@example.com', '2023-03-03', 'modérateur', 'actif'),
(14, 'Élodie Simon', 'esimon', '', '', 'esimon@example.com', '2023-02-15', 'administrateur', 'actif'),
(15, 'Maxime Girard', 'mgirard', '', '', 'mgirard@example.com', '2023-01-07', 'administrateur', 'inactif'),
(16, 'Nadia Said', 'nsaid', 'secure987', '', 'nadia.said@email.dz', '2024-05-10', 'compte standard', 'actif'),
(17, 'Ahmed Yacoubi', 'ayacoubi', 'passwordsafe', '', 'ahmed.yacoubi@example.com', '2023-11-01', 'administrateur', 'inactif'),
(18, 'Leila Mansouri', 'lmansouri', 'azertyuiop', '', 'leila.mansouri@domain.org', '2024-02-15', 'modérateur', 'actif'),
(19, 'Karim Ziani', 'kziani', 'mysecret12', '', 'karim.ziani@mail.net', '2023-08-25', 'compte standard', 'actif'),
(20, 'Sarah Dubois', 'sdubois', 'topsecret45', '', 'sarah.dubois@provider.fr', '2024-04-20', 'compte standard', 'actif'),
(21, 'Yacine Haddad', 'yhaddad', 'strongpass123', '', 'yacine.haddad@another.com', '2024-06-01', 'modérateur', 'inactif'),
(22, 'Manon Leclerc', 'mleclerc', 'secretcode', '', 'manon.leclerc@email.ca', '2023-12-05', 'compte standard', 'actif'),
(23, 'Rayan Benali', 'rbenali', 'verysecurepass', '', 'rayan.benali@sample.org', '2024-03-25', 'administrateur', 'actif'),
(24, 'Ines Ferhat', 'iferhat', 'pass654321', '', 'ines.ferhat@test.fr', '2024-01-05', 'compte standard', 'inactif'),
(25, 'Hugo Moreau', 'hmoreau', 'ultrasecure', '', 'hugo.moreau@online.com', '2023-09-15', 'modérateur', 'inactif'),
(40, 'GHEROUFELLA FAYCAL', 'fayçal', '$2y$10$UxIO2Y3xx3cYs84UI08xlubomudMUtiVXL0zWB/ncDSLIXHE53L6a', '123456', 'gheroufellafaycal@gmail.com', '2025-05-21', 'administrateur', 'actif'),
(41, 'faysal boss', 'faysal', '$2y$10$M/VHMgKmjHLPsL.WhTEzfeVZ1UjIEop9oAUzPpEy2n8Bhw.MngvUC', '', 'faysalbosa@gmail.com', '2024-08-25', 'modérateur', 'actif'),
(43, 'FayçalBoss', 'FuFu', '$2y$10$MJ/EeZT0CTaqjiY0Na9lyufVnzTBldAQ5fmc4U3LECaokQhjNYK4m', '', 'ccx@gmail.com', '2025-04-25', 'modérateur', 'actif'),
(44, 'faysal boss', 'LiFo', '$2y$10$KjBxYNrEekoJqDnStkChlu8rUczx04AZq1aAhelJMUuh2KI/khOFK', '123456', 'ccs@gmail.com', '2024-05-25', 'compte standard', 'actif'),
(46, 'Imrane', 'imrane98', '$2y$10$bbLf3ZDIl/.mJ.FtPsGq6Omt9UQ5fG0h1v1q22jyZHAXyJsOTBYaK', '', 'benhaddouche@gmail.com', '2025-06-22', 'administrateur', 'actif'),
(48, 'Imranesq', 'fifisfsqdqsd', '$2y$10$6m39S0NYymZj6IC6GwBfGOHuBCMIXqYB8NjWSmLP7CZJTaW1UVM.i', '', 'mail@gmail.com', '2025-02-24', 'compte standard', 'actif');

--
-- Déclencheurs `users`
--
DELIMITER $$
CREATE TRIGGER `users_after_delete` AFTER DELETE ON `users` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('users', 'DELETE', OLD.ID_De_Compte, CONCAT('Utilisateur Sous Le Nom De : ', OLD.Username, ' a été supprimé définitivement.'), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `users_after_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
    VALUES ('users', 'INSERT', NEW.ID_De_Compte, CONCAT('Nouvel utilisateur ajouté avec le nom d''utilisateur : ', NEW.username), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `users_after_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    DECLARE log_details_text TEXT DEFAULT '';

    IF OLD.stat_user != 'inactif' AND NEW.stat_user = 'inactif' THEN
        INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
        VALUES ('users', 'DELETE', NEW.ID_De_Compte, CONCAT('Utilisateur avec Le Username: ', NEW.Username, ' a été marqué Suppérimé.'), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
    ELSE
        IF NOT (OLD.Nom_Complet <=> NEW.Nom_Complet) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''Nom_Complet'' changé de ''', IFNULL(OLD.Nom_Complet, 'NULL'), ''' à ''', IFNULL(NEW.Nom_Complet, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.Username <=> NEW.Username) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''Username'' changé de ''', IFNULL(OLD.Username, 'NULL'), ''' à ''', IFNULL(NEW.Username, 'NULL'), '''. ');
        END IF;
        
        -- !!! SECURITY WARNING !!!
        IF NOT (OLD.Password <=> NEW.Password) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''Password'' a été modifié. ');
        END IF;
        IF NOT (OLD.passbh <=> NEW.passbh) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''passbh'' a été modifié. ');
        END IF;
        
        IF NOT (OLD.Email <=> NEW.Email) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''Email'' changé de ''', IFNULL(OLD.Email, 'NULL'), ''' à ''', IFNULL(NEW.Email, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.Date_D_Integration <=> NEW.Date_D_Integration) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''Date_D_Integration'' changé de ''', IFNULL(OLD.Date_D_Integration, 'NULL'), ''' à ''', IFNULL(NEW.Date_D_Integration, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.Permission <=> NEW.Permission) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''Permission'' changé de ''', IFNULL(OLD.Permission, 'NULL'), ''' à ''', IFNULL(NEW.Permission, 'NULL'), '''. ');
        END IF;
        IF NOT (OLD.stat_user <=> NEW.stat_user) THEN
            SET log_details_text = CONCAT(log_details_text, 'Champ ''stat_user'' changé de ''', IFNULL(OLD.stat_user, 'NULL'), ''' à ''', IFNULL(NEW.stat_user, 'NULL'), '''. ');
        END IF;

        IF log_details_text != '' THEN
            INSERT INTO events_log (table_name, action_type, record_id, log_details, user_who_changed, user_name)
            VALUES ('users', 'UPDATE', NEW.ID_De_Compte, CONCAT('Mise à jour pour l''utilisateur ID ', NEW.ID_De_Compte, ': ', log_details_text), IFNULL(@app_user_id, CURRENT_USER()), @app_user_name);
        END IF;
    END IF;
END
$$
DELIMITER ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `depense`
--
ALTER TABLE `depense`
  ADD PRIMARY KEY (`id_depense`);

--
-- Index pour la table `events_log`
--
ALTER TABLE `events_log`
  ADD PRIMARY KEY (`log_id`);

--
-- Index pour la table `stk`
--
ALTER TABLE `stk`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `taches`
--
ALTER TABLE `taches`
  ADD PRIMARY KEY (`id_tache`),
  ADD KEY `fk_taches_id_stk` (`id_stk`);

--
-- Index pour la table `trk`
--
ALTER TABLE `trk`
  ADD PRIMARY KEY (`id_trk`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID_De_Compte`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `ID_De_Compte` (`ID_De_Compte`),
  ADD UNIQUE KEY `Username_2` (`Username`),
  ADD UNIQUE KEY `Username_3` (`Username`),
  ADD UNIQUE KEY `Username_4` (`Username`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `depense`
--
ALTER TABLE `depense`
  MODIFY `id_depense` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `events_log`
--
ALTER TABLE `events_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT pour la table `stk`
--
ALTER TABLE `stk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT pour la table `taches`
--
ALTER TABLE `taches`
  MODIFY `id_tache` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `trk`
--
ALTER TABLE `trk`
  MODIFY `id_trk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `ID_De_Compte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

DELIMITER $$
--
-- Évènements
--
CREATE DEFINER=`root`@`localhost` EVENT `log_advents_activity` ON SCHEDULE EVERY 1 MINUTE STARTS '2025-06-22 09:27:11' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO `advents_log` (`log_message`) VALUES ('An advent event occurred via SQL command!')$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
