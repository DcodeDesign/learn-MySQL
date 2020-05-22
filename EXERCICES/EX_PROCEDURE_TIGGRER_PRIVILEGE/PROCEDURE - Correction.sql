-- Exercices

-- ******************************************************************
-- 1. Créer une procédure qui affiche en une fois les nombres impairs
-- ******************************************************************

USE Monde;
DROP PROCEDURE IF EXISTS Impair;

DELIMITER |
CREATE PROCEDURE Impair()
BEGIN
	DECLARE _i INT;
	DECLARE _texte VARCHAR(100) DEFAULT '';
		
	SET _i = 1;
	WHILE (_i < 20) DO
		IF (_i % 2) THEN
			SET _texte = CONCAT(_texte, ' ', _i);
		END IF;

		SET _i = _i + 1;		
	END WHILE;
	
	SELECT _texte AS Impair;
END |
DELIMITER ;

CALL Impair();

DROP PROCEDURE IF EXISTS Impair;

-- ******************************************************************
-- 2. Créer une procédure qui affiche les noms et prénoms dont la clé est impaire.
-- ******************************************************************

USE Monde;
DROP PROCEDURE IF EXISTS PKImpair;

DELIMITER |
CREATE PROCEDURE PKImpair()
BEGIN
	SELECT id_pers, nom, prenom 
	FROM Personne 
	WHERE id_pers % 2;	-- WHERE NOT id_pers % 2;
	
END |
DELIMITER ;

CALL PKImpair();

DROP PROCEDURE IF EXISTS PKImpair;

-- ******************************************************************
-- 3. Créer une procédure qui prendra l'ID d'une voiture en paramètre (Table Voitures)
--		o	Si KM <= 50 : Neuf
--		o	Si KM <= 3000 : Rodé 
--		o	Si KM <= 4000 : Fiable
--		o	Si KM > 4000 : A remplacer
-- ******************************************************************
USE locaVoit;
DROP PROCEDURE IF EXISTS EtatVoit;

DELIMITER |
CREATE PROCEDURE EtatVoit(IN _plaque VARCHAR(8))
BEGIN
	DECLARE _nbKm INT;

	SELECT kmVoit INTO _nbKm
	FROM Voitures
	WHERE idVoit = _plaque;

	CASE 
		WHEN _nbKm <= 50 THEN 
			SELECT 'Neuf' AS Etat;
		WHEN _nbKm <= 3000 THEN 
			SELECT 'Rodé' AS Etat;
		WHEN _nbKm <= 4000 THEN 
			SELECT 'Fiable' AS Etat;
		ELSE 							
			SELECT 'A remplacer' AS Etat;
	END CASE;
END|
DELIMITER ;

CALL EtatVoit('1-AAA001');
CALL EtatVoit('1-AAA003');
CALL EtatVoit('1-CCC001');
CALL EtatVoit('1-CCC002');

DROP PROCEDURE IF EXISTS EtatVoit;

-- ******************************************************************
-- 4. Créer une procédure stockée qui prendra en paramètres le nombre maximum de participants 
--    et qui affichera "Complet" si le nombre d'inscrit est atteint.
-- ******************************************************************

USE ecole;

DROP PROCEDURE IF EXISTS Sit_Inscription_Cours;

DELIMITER |
CREATE PROCEDURE Sit_Inscription_Cours (IN p_nb_max INT)
BEGIN
	SELECT branche , 
		   COUNT(FK_Pers) AS Incrits, 
		   IF(COUNT(FK_Pers)>= p_nb_max, 'COMPLET', '') AS Situation 
	FROM T_branche INNER JOIN t_inscription 
		ON  t_inscription.fk_cours = T_branche.PK_Branche
	GROUP BY t_branche.branche
	ORDER BY t_branche.branche;
END|
DELIMITER ;

CALL Sit_Inscription_Cours(21);

DROP PROCEDURE IF EXISTS Sit_Inscription_Cours;


-- ******************************************************************
-- 5. Création d’une procédure qui contrôlera qu’aucun prof n’est étudiant dans la section
-- ******************************************************************

USE Ecole;

DROP PROCEDURE IF EXISTS CtlProfEtudiant;

DELIMITER |
CREATE PROCEDURE CtlProfEtudiant()
BEGIN
	DECLARE _existe INT;
	
	SELECT COUNT(*) INTO _existe
	FROM T_inscription INNER JOIN T_prof
		ON ((T_inscription.FK_Pers = T_prof.FK_Pers) AND 
		    (T_inscription.FK_Cours = T_prof.FK_Branche));
	 
	IF _existe THEN
		SELECT CONCAT('Il y a ', _existe, ' personne(s) concernée(s)') AS Message;
	ELSE		
		SELECT 'Tout est OK' AS Message;
	END IF;
END|
DELIMITER ;

CALL CtlProfEtudiant();

INSERT INTO T_Prof VALUES 
	(5, 'PHOT', 1);
	
INSERT INTO T_Prof VALUES 
	(891, 'CARR', 1);
	
CALL CtlProfEtudiant();
	
DELETE FROM T_Prof
WHERE (FK_Pers = 5) AND (FK_Branche = 'PHOT') AND (NB_Heure = 1);


DROP PROCEDURE IF EXISTS CtlProfEtudiant;


-- ******************************************************************
-- 6. Est-il possible qu'il y ait un juron a la page 58 du "Le Lotus Bleu" (A04)
-- ******************************************************************

USE Tintin;

DROP PROCEDURE IF EXISTS CtlJuronPageAlbum;

DELIMITER |
CREATE PROCEDURE CtlJuronPageAlbum (IN _page INT, IN _titre VARCHAR(50))
BEGIN
	DECLARE _existe INT;
	
	SELECT COUNT(*) INTO _existe 
	FROM juron_album INNER JOIN album 
		ON  juron_album.idAlb = album.idAlb
	WHERE numPage = _page AND titreAlb = _titre;
	
	IF _existe THEN
		SELECT 'Il y en a au moins 1';
	ELSE
		SELECT 'Il n''y en a pas';
	END IF;
END|
DELIMITER ;

CALL CtlJuronPageAlbum(58, 'Le Lotus Bleu');

DROP PROCEDURE IF EXISTS CtlJuronPageAlbum;


-- ******************************************************************
-- Extra 7. Certains albums n'auraient pas été écrit par Hergé.
-- 		    Ils ne devraient donc pas se trouver dans la DB.
--			Pour ne pas supprimer les enregistrements, il est demadé de
--				- Ajouter un champ booléen "Doute" dans les tables Pays et Albums
-- 				- Créer une procédure qui prendra le titre de l'album concerné en paramètre IN.
-- 				  Elle "flaguera" le titre dans la table album ainsi que tous les pays visités 
--				  durant ces aventures
-- ******************************************************************

USE Tintin;

ALTER TABLE Pays
	ADD COLUMN Doute TINYINT(1) DEFAULT 0;
	
ALTER TABLE Pays
	MODIFY Doute TINYINT(1) NOT NULL;
	
ALTER TABLE Album
	ADD COLUMN Doute TINYINT(1) NOT NULL DEFAULT 0;
	
DROP PROCEDURE IF EXISTS DouteAlbumPays;

DELIMITER |
CREATE PROCEDURE DouteAlbumPays(IN _titre VARCHAR(50))
BEGIN
	UPDATE Album
	SET Doute = 1
	WHERE titreAlb = _titre;
	
	UPDATE Pays
	SET Doute = 1
	WHERE idPays IN
	(
		SELECT Pays_Album.idPays
		FROM Album 
			INNER JOIN Pays_Album
				ON Album.idAlb = Pays_Album.idAlb
--			INNER JOIN Pays
--				ON Pays.idPays = Pays_Album.idPays			
		WHERE titreAlb = _titre
	);	
END|
DELIMITER ;

CALL DouteAlbumPays('TINTIN AU CONGO');

SELECT * FROM Album;
SELECT * FROM Pays;

ALTER TABLE Pays
	DROP COLUMN Doute;
	
ALTER TABLE Album
	DROP COLUMN Doute;



-- ******************************************************************
-- Extra 8. DB dog_racing
-- 		    Ajouter un champ "Prix" à la table Resultat
--			Créer une procédure qui mettra à jour le champ "Prix" 
--			(1er => 500, 2eme => 250, 3eme => 50)
-- ******************************************************************

USE dog_racing;

-- Ajout du champ
ALTER TABLE resultat
		ADD COLUMN prix INT DEFAULT 0;
		

DROP PROCEDURE IF EXISTS maj_prime;

DELIMITER |

CREATE PROCEDURE maj_prime()
BEGIN

	DECLARE _idCourse INT(3);
	DECLARE _leChien BIGINT(20);
	
	DECLARE Fin BOOLEAN DEFAULT FALSE;

	DECLARE cursor_courses CURSOR FOR
		SELECT DISTINCT idC FROM resultat;

	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET Fin = TRUE;

	OPEN cursor_courses;
		Loop_Curs : LOOP
			FETCH cursor_courses INTO _idCourse;			
			IF Fin THEN
				LEAVE Loop_Curs;
			END IF;
			
			SELECT idCh INTO _leChien 
				FROM resultat 
				WHERE idC = _idCourse 
				ORDER BY temps ASC  
				LIMIT 1;
			UPDATE resultat 
				SET prix = 500
				WHERE idC = _idCourse AND idCh = _leChien;			
			
			SELECT idCh INTO _leChien 
				FROM resultat 
				WHERE idC = _idCourse 
				ORDER BY temps ASC
				LIMIT 1 
				OFFSET 1;
			UPDATE resultat 
				SET prix = 250
				WHERE idC = _idCourse AND idCh = _leChien;
			
			
			SELECT idCh INTO _leChien 
				FROM resultat 
				WHERE idC = _idCourse 
				ORDER BY temps ASC 
				LIMIT 1 
				OFFSET 2;
			UPDATE resultat 
				SET prix = 50
				WHERE idC = _idCourse AND idCh = _leChien;							
		END LOOP;
	CLOSE cursor_courses;

END |

DELIMITER ;
	
CALL maj_prime;

SELECT * FROM resultat ORDER BY idC ASC, temps ASC;

ALTER TABLE resultat
	DROP COLUMN prix;


	
-- ******************************************************************
-- Extra 9. DB dog_racing
-- 		    Créer une procédure qui prendra le nom d'un chien 
--			ainsi que le nom d'une course en IN.
--		    La procédure renverra dans un paramètre OUT le montant du prix gagné
-- ******************************************************************

USE dog_racing;

DROP PROCEDURE IF EXISTS PrixChien;

DELIMITER |
CREATE PROCEDURE PrixChien (IN _chien VARCHAR(30), 
							IN _course VARCHAR(30), 
							OUT _montant INT)
BEGIN
	SELECT prix INTO _montant
	FROM chien 
		INNER JOIN resultat USING(idCh)
		INNER JOIN course USING(idC)	
	WHERE (nomC = _course) AND (nomCh = _chien);
END|
DELIMITER ;

CALL PrixChien('Idefix', 'IEPSCF, du C308 au C313', @totalPrix);

SELECT @totalPrix;

DROP PROCEDURE IF EXISTS PrixChien;


-- ******************************************************************
-- Extra 10. DB dog_racing
-- 		     Créer une procédure qui prendra le nom de 2 chiens en IN.
--		     La procédure renverra dans un paramètre OUT le montant total gagné par ces 2 chiens
-- ******************************************************************

USE dog_racing;

DROP PROCEDURE IF EXISTS PrixDeuxChien;

DELIMITER |
CREATE PROCEDURE PrixDeuxChien (IN _chien1 VARCHAR(30), IN _chien2 VARCHAR(30), OUT _montant INT)
BEGIN
	SELECT SUM(prix) INTO _montant
	FROM chien 
		INNER JOIN resultat USING(idCh)
	WHERE nomCh = _chien1 OR nomCh = _chien2;
END|
DELIMITER ;

CALL PrixDeuxChien('Idefix', 'Pif', @totalPrix);

SELECT @totalPrix;

DROP PROCEDURE IF EXISTS PrixDeuxChien;


