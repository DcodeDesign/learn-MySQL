-- 1.	Créez une procédure stockée qui renvoit 3 paramètres.
-- 		* Le nombre de F
--		* Le nombre de M
-- 		* Un message donnant la situation (Ex : "Il y a plus d'homme dans la DB")

USE tintin;

DELIMITER |

CREATE PROCEDURE MF(OUT msg VARCHAR(100), OUT NbF INT, OUT NbM INT )
BEGIN	
	SELECT COUNT(*) INTO nbF
	FROM Personnage
	WHERE sexePers = 'F';
	
	SELECT COUNT(*) INTO nbM
	FROM Personnage
	WHERE sexePers = 'M';
	
	IF nbF > nbM THEN
		SET msg = 'Plus de Femme !';
	ELSEIF (nbF < nbM) THEN
		SET msg = 'Plus d''Homme !';
	ELSE	
		SET msg = 'Stricte égalité !';
	END IF;
	
END |

DELIMITER ;

CALL MF(@msg, @nbF, @nbH);

SELECT @msg AS Message, @nbH AS Homme, @nbF AS Femme ;

DROP PROCEDURE MF;

****************************************************************
****************************************************************

-- 2.	Créez une procédure stockée qui prendra en paramètre le titre d'un album et un numéro de page. 
-- 		La procédure renverra dans une variable le nombre de jurons écrits à cette page.
--		Appelez ensuite cette procédure en lui passant les paramètres nécessaires. 		

USE tintin; 
 
DELIMITER |
CREATE PROCEDURE nb_juron (IN p_album VARCHAR(50), IN p_page INT, OUT p_nb_juron INT)
BEGIN
	SELECT COUNT(*) INTO p_nb_juron
	FROM juron_album INNER JOIN album USING (idAlb)
	WHERE ((titreAlb = p_album) AND (numPage = p_page));
END |
DELIMITER ;

SET @nb_jur :=0;
CALL nb_juron('LE TEMPLE DU SOLEIL', 9, @nb_jur);

SELECT @nb_jur AS 'Nombre de jurons';

DROP PROCEDURE nb_juron;

****************************************************************
****************************************************************

-- 3.	Créez une procédure stockée qui vous donnera le nombre de pays fréquentés, le nombre de personnages intervenant 
--		et le nombre de jurons écrits dans l'album dont le titre est passé en paramètre.

USE tintin; 
 
DELIMITER |
CREATE PROCEDURE stat (IN p_album VARCHAR(50))
BEGIN
	SELECT titreAlb AS Titre,
		(SELECT COUNT(idPays) 
		 FROM pays_album INNER JOIN album USING (idAlb)
		 WHERE titreAlb ='LES CIGARES DU PHARAON') AS Pays,
		(SELECT COUNT(idPers) 
		 FROM pers_album INNER JOIN album USING (idAlb)
		 WHERE titreAlb ='LES CIGARES DU PHARAON') AS Personnages,
		(SELECT COUNT(idJur) 
		 FROM juron_album INNER JOIN album USING (idAlb)
		 WHERE titreAlb ='LES CIGARES DU PHARAON') AS Jurons
	FROM album
	WHERE titreAlb = p_album;
END |
DELIMITER ;

CALL stat('LE TEMPLE DU SOLEIL');

DROP PROCEDURE stat;

****************************************************************
****************************************************************

-- 4.	Tous les albums ont un pays commun non-renseigné dans la DB.  
--		Mettez en place une procédure stockée qui : 
--      * Ajoute le pays "Wallonie" ("WAL") dans la table PAYS. 
--      * Ajoute ensuite ce pays à chaque album.

USE tintin;
-- DELETE FROM Pays WHERE idpays = 'WAL'; 

DELIMITER |
CREATE PROCEDURE Wal ()
BEGIN
	DECLARE _IDalbum VARCHAR(50);    
    DECLARE fin TINYINT(1) DEFAULT 0; 
    		
	DECLARE doublon CONDITION FOR 1062;
	
	DECLARE curs_album CURSOR FOR
        SELECT IdAlb
        FROM Album;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET fin = 1;
		
	DECLARE EXIT HANDLER FOR doublon 
		SELECT 'WALLONIE deja dans la DB - Arret de la procédure' AS 'Erreur';

	INSERT INTO Pays VALUES ('WAL', 'WALLONIE');
		
	OPEN curs_album;                                    

    loop_curseur: LOOP                                                
        FETCH curs_album INTO _IDalbum;

        IF fin = 1 THEN 
            LEAVE loop_curseur;
        END IF;
        
		INSERT INTO pays_album VALUES (_IDalbum,'WAL');		
    END LOOP;

    CLOSE curs_album;
	
END |
DELIMITER ;

CALL Wal();

DROP PROCEDURE Wal;


****************************************************************
****************************************************************

-- DB Tintin
-- 5.	Les pays "Egypte", "Nepal" et "Perou" sont infectés par le COVID-19
--		* Ajouter un champ booléen à la table "Personnage" 
--		* Flaguer tous les personnages ayant voyagé dans ces pays

ALTER TABLE Personnage
	ADD COLUMN Covid TINYINT(1) DEFAULT 0;

UPDATE Personnage
SET Covid = 1
WHERE idPers IN 
	(
		SELECT DISTINCT idPers
		FROM pers_album 
			INNER JOIN album USING (idAlb)
			INNER JOIN pays_album USING (idAlb)
			INNER JOIN pays USING (idPays)
		WHERE NomPays = 'Egypte' OR 
			  NomPays = 'Nepal' OR 	
			  NomPays = 'Perou'
	)
;

***************
***************
* -- TRIGGER 
***************
***************

-- DB Monde
-- 6.	Mettre en place un trigger qui, lors d'un encodage, veillera a ce que le nom
--		complet ainsi que la premiere lettre du prenom soient mis en majuscule

USE Monde;

DROP TRIGGER IF EXISTS before_insert_MajusculePers;

DELIMITER |

CREATE TRIGGER before_insert_MajusculePers BEFORE INSERT 
	ON personne FOR EACH ROW	
BEGIN			
	SET NEW.nom = UCASE(NEW.nom);	
	SET NEW.prenom = CONCAT(UPPER(LEFT(NEW.prenom,1)),LOWER(SUBSTRING(NEW.prenom,2)));	
END |

DELIMITER ;

INSERT INTO personne (nom, prenom, fk_pays) VALUES
	('bowie', 'david', 1);


****************************************************************
****************************************************************

-- DB Tintin
-- 7.	Après relecture des albums de Tintin, on a remarqué des oublis quant à l'encodage des jurons.  
-- 		On va donc les ajouter. Mettez en place un trigger qui vérifiera que le personnage concerné 
--		apparait bien dans l'album mis en cause.  
-- 		En cas d'erreur, aucune insertion ne sera réalisée.	

USE tintin;

DROP TRIGGER IF EXISTS juronAlb_Before_Insert;

DELIMITER |

CREATE TRIGGER juronAlb_Before_Insert BEFORE INSERT ON juron_album FOR EACH ROW
BEGIN	
	DECLARE v_pers_dans_alb INT;
	
	SELECT COUNT(*) INTO v_pers_dans_alb
	FROM pers_album
	WHERE ((pers_album.idAlb = NEW.idAlb) AND (pers_album.idPers = NEW.idPers));
	
	IF v_pers_dans_alb = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Le personnage est inexistant dans l''album. Aucune insertion effectuée';
	END IF;	
END |

DELIMITER ;	


****************************************************************
****************************************************************

-- DB Tintin
-- 8.	La clé primaire d'une personne est une chaine de 5 caractères. Il est dès lors possible d'introduire
---		2 fois la même personne (nom et prénom). Mettez en place un trigger qui vérifiera lors de l'ajout 
---		d'une personne qu'on n'essaie pas d'encoder la même personne (nom et prénom) avec un clé différente. 
-- 		En cas d'erreur, aucune insertion ne sera réalisée et un message d'erreur sera affiché.

USE TINTIN;

DROP TRIGGER IF EXISTS Before_Insert_Pers;


DELIMITER |

CREATE TRIGGER Before_Insert_Pers BEFORE INSERT ON Personnage FOR EACH ROW 
	BEGIN
		DECLARE PersExist TINYINT DEFAULT 0;
		DECLARE errorMessage VARCHAR(100);

		DECLARE doublon CONDITION FOR SQLSTATE '98765';

		SELECT COUNT(*) INTO PersExist FROM Personnage
		WHERE ((nomPers = NEW.nomPers) AND (prenomPers = NEW.prenomPers));

		IF PersExist THEN
			SET errorMessage = CONCAT(NEW.nomPers, ' ', NEW.prenomPers, ' est déjà encodé');
			SIGNAL doublon SET MESSAGE_TEXT = errorMessage;
		END IF;

	END |
	
DELIMITER ;

INSERT INTO Personnage(idPers, nomPers, prenomPers)
VALUES ('ADCDE','BOWIE','David');


***************
***************
* -- COMPLET 
***************
***************

-- DB Ecole
-- 9.	Créer une table T_SitInscription (PK_Cours, Nombre) 
--		Insérer y les différentes formations en mettant le nombre à 0 AVANT TOUTE CHOSE
--		Ensuite
--		* Créer une procédure stockée qui donnera la situation actuelle des inscriptions
--		* Mettre en place un trigger qui, à chaque insertion dans la table T_Inscription, ajoutera une unité 
--		  au nombre afin d'avoir une situation à jour sans devoir recompter à chaque fois le nombre d'inscrits
--

USE ecole;

CREATE TABLE IF NOT EXISTS T_SitInscription (
	PK_Cours VARCHAR(4) NOT NULL,
	Nombre INT UNSIGNED DEFAULT 0,
	PRIMARY KEY (PK_Cours)
) ENGINE = InnoDB;

INSERT INTO T_SitInscription (PK_Cours)
SELECT DISTINCT PK_Branche FROM T_Branche;

DELIMITER |
CREATE TRIGGER Aft_Ins_Pers_CompteInscrit AFTER INSERT
ON T_Inscription FOR EACH ROW
	BEGIN
		UPDATE T_SitInscription
		SET Nombre = Nombre + 1
		WHERE PK_Cours = NEW.FK_Cours;
	END |
DELIMITER ;

INSERT INTO T_Inscription (FK_Pers, FK_Cours)
VALUES (1, 'INFO'),
       (2, 'INFO'),
       (3, 'MENU'),
       (4, 'INFO'),
       (4, 'CONS'),
       (6, 'CONS'),
       (8, 'INFO');



****************************************************************
****************************************************************

-- 10.	* Créer une DB "Gestion_Stock"
--		* Créer une table "Produit" (PK, Nom_Produit, Quantite, Limite, Recommande, Nombre_A_Recomander) 
--			- Quantite : Entier => nombre en stock
--			- Limite : Entier => nombre MINIMUM de pièce à détenir
--			- Recommande : Booléen => si un produit est en dessous du seuil "Limite"
--			- Nombre_A_Recomander : Entier => nombre à recommander afin de disposer de 10 pieces au dessus de la limite
--		* Mettre en place un trigger qui, lors d'un UPDATE de la table, évalue la quantité en f(x) de la limite
--			- Si la limite est SUPERIEURE à la quantité 
--				=> Recommande = TRUE 
--				=> Nombre_A_Recomander = (limite + 10) - quantité encore disponible 
--			- Si la limite est INFERIEURE à la quantité 
--				=> Recommande = FALSE 
--				=> Nombre_A_Recomander = 0
-- 		Rem :  Les Update peuvent donc se faire dans les 2 sens (positif ou négatif)			

CREATE DATABASE IF NOT EXISTS Gestion_Stock;
USE Gestion_Stock;

CREATE TABLE IF NOT EXISTS Produit (
	PK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	Nom_Produit VARCHAR(20) NOT NULL,
	Quantite INT NOT NULL,
	Limite INT NOT NULL,
	Recommande VARCHAR(3) DEFAULT 'NO',
	Nombre_A_Recomander INT DEFAULT 0,
	PRIMARY KEY (PK)
) ENGINE = InnoDB;

INSERT INTO Produit (Nom_Produit, Quantite, Limite)
VALUES ('BIC', 125, 100),
	   ('LATTE', 13, 10),
	   ('GOMME', 64, 60);

DELIMITER |
CREATE TRIGGER Bef_Upd_Stock_Recommande BEFORE UPDATE
ON Produit FOR EACH ROW
	BEGIN
		IF NEW.Quantite < 0 THEN
			SET NEW.Quantite = OLD.Quantite;
		ELSEIF NEW.Quantite < OLD.Limite THEN
			SET NEW.Recommande = 'YES';
			SET NEW.Nombre_A_Recomander = OLD.Limite - NEW.Quantite + 10;
		ELSE
			SET NEW.Recommande = 'NO';
			SET NEW.Nombre_A_Recomander = 0;
		END IF;
	END |
DELIMITER ;

-- Test
UPDATE Produit
SET Quantite = Quantite - 20
WHERE Nom_Produit = 'BIC';

UPDATE Produit
SET Quantite = Quantite - 70
WHERE Nom_Produit = 'BIC';


***************
***************
* -- DIVERS 
***************
***************

--  DB LocaVoit
--  11. 	Ecrire une requête qui donne pour chaque client :
--    			- le nombre de locations
--    			- total des km parcourus
--    			- nombre moyen de km parcourus par location
--    			- durée totale des locations
--    			- prix total des locations

SELECT clients.*, 
	   COUNT(idLoc) AS `nombre de locations`,
       SUM(kmFinLoc-kmDebLoc) AS `km total parcourus`,
       AVG(kmFinLoc-kmDebLoc) AS `km moyen / location`,
       SUM(dFinLoc-dDebLoc +1) AS `durée totale des locations`,
       SUM(prixLoc) AS `prix total`
FROM clients
  LEFT JOIN locations ON clients.idCli = locations.clientLoc
GROUP BY clients.idCli
ORDER BY clients.nomCli ASC, clients.prenomCli ASC
;
