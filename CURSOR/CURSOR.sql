# CURSOR

***************************************************************
ERREUR
***************************************************************

USE monde;

DROP PROCEDURE IF EXISTS TestErreur;

DELIMITER |
CREATE PROCEDURE TestErreur ()
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
		SELECT 'Oups';
	DECLARE CONTINUE HANDLER FOR 1062
		SELECT 'Doublon' AS Msg;

	INSERT INTO Pays VALUES
		(5, 'France', 78);
END|
DELIMITER ;

CALL TestErreur();

DROP PROCEDURE IF EXISTS TestErreur;

***************************************************************
CONDITION
***************************************************************


USE monde;

DROP PROCEDURE IF EXISTS TestErreur;

DELIMITER |
CREATE PROCEDURE TestErreur ()
BEGIN
	DECLARE doublon CONDITION FOR 1062;

	DECLARE EXIT HANDLER FOR doublon
		SELECT 'pompompom' AS 'Erreur !!';

	INSERT INTO Pays VALUES
		(5, 'France', 78);
END|
DELIMITER ;

CALL TestErreur();

DROP PROCEDURE IF EXISTS TestErreur;


***************************************************************
SQLEXCEPTION, NOT FOUND
***************************************************************


USE monde;

DROP PROCEDURE IF EXISTS TestErreur;

DELIMITER |
CREATE PROCEDURE TestErreur ()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION , SQLWARNING
		SELECT 'Zut !' AS 'Erreur !!';

	INSERT INTO Pays VALUES
		(5, 'France', 78);
END|
DELIMITER ;

CALL TestErreur();


DROP PROCEDURE IF EXISTS TestErreur;


***************************************************************
CURSEUR - NOT FOUND
***************************************************************

USE Monde;

DROP PROCEDURE IF EXISTS AjoutMoisRonaldo;

DELIMITER |
CREATE PROCEDURE AjoutMoisRonaldo()
BEGIN
    DECLARE _nom, _prenom VARCHAR(20);
    DECLARE fin TINYINT(1) DEFAULT 0;

    DECLARE curs_pers CURSOR FOR
        SELECT nom, prenom
        FROM personne;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET fin = 1;

    OPEN curs_pers;

    loop_curseur: LOOP
        FETCH curs_pers INTO _nom, _prenom;

        IF fin = 1 THEN
            LEAVE loop_curseur;
        END IF;

		IF (_nom = 'Ronaldo') THEN
			UPDATE personne
			SET dateNaissance = dateNaissance + INTERVAL 5 MONTH
			WHERE nom = 'Ronaldo';
		END IF;

    END LOOP;

    CLOSE curs_pers;
END|
DELIMITER ;

CALL AjoutMoisRonaldo();

***************************************************************
DECLENCHER SON ERREUR
***************************************************************


USE Monde;

DROP PROCEDURE IF EXISTS ErreurPerso;

DELIMITER |
CREATE PROCEDURE ErreurPerso()
BEGIN
    DECLARE _nom, _prenom VARCHAR(20);
    DECLARE fin TINYINT(1) DEFAULT 0;
	DECLARE errorMessage VARCHAR(100);

    DECLARE curs_pers CURSOR
        FOR SELECT nom, prenom
        FROM personne;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET fin = 1;

    OPEN curs_pers;

    loop_curseur: LOOP
        FETCH curs_pers INTO _nom, _prenom;

        IF fin = 1 THEN
            LEAVE loop_curseur;
        END IF;

		IF (_nom = 'Ronaldo') THEN
			SET errorMessage = CONCAT(_prenom, ' ', _nom, ' est bien dans la DB');
			SIGNAL SQLSTATE '99999' SET MESSAGE_TEXT = errorMessage;
		END IF;

    END LOOP;

    CLOSE curs_pers;
END|
DELIMITER ;

CALL ErreurPerso();


***************************************************************
CURSEUR - Version 2
***************************************************************
--  Utilisation d'un booléen pour les allergiques aux TINYINT(1)

DECLARE Fin BOOLEAN DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET Fin = TRUE;


-- 	Exemple avec COUNT() et WHILE()
--	Certains étudiants sont inscrits à plus d'une formation.
--	Afin d'avoir une situation rapide :
-- 		- Ajouter un champ "Nombre_Formation" dans la table "T_Pers",
--		- Mettre à jour ce champ avec le nombre de formations suivies

ALTER TABLE T_Pers
    ADD COLUMN Nb_Formation TINYINT NOT NULL DEFAULT 0;

DROP PROCEDURE IF EXISTS Update_nbFormation_Pers;

DELIMITER |
CREATE PROCEDURE Update_nbFormation_Pers()
	BEGIN
		-- Variables internes
		DECLARE _PKPers, _NbCours, NbRecord SMALLINT;
		DECLARE _i SMALLINT DEFAULT 0;

		-- Pas de condition
		-- Curseur
		DECLARE curs_pers CURSOR FOR
			SELECT FK_Pers, COUNT(FK_Cours)
			FROM T_Inscription
			GROUP BY FK_Pers;
		-- Pas de gestionnaire d'erreur

		-- Combien de ligne dans le curseur ?
		SELECT COUNT(*) INTO NbRecord
		FROM
			(
			   SELECT FK_Pers, COUNT(FK_Cours)
			   FROM T_Inscription
			   GROUP BY FK_Pers
			) AS temp;

		-- Ouverture du curseur
		OPEN curs_pers;

			-- Traitement
			WHILE (_i < NbRecord) DO
				FETCH Curs_Pers INTO _PKPers, _NbCours;

				UPDATE T_Pers
				SET Nb_Formation = _NbCours
				WHERE PK_Pers = _PKPers;

				SET _i = _i + 1;
			END WHILE;

		-- Fermeture du curseur
		CLOSE curs_pers;
	END |
DELIMITER ;

CALL Update_nbFormation_Pers();

SELECT PK_Pers, nom, prenom, Nb_Formation
FROM T_Pers
LIMIT 50;

ALTER TABLE T_Pers
    DROP COLUMN Nb_Formation;

DROP PROCEDURE IF EXISTS Update_nbFormation_Pers;

# ***************************************************************
# EXERCICES
# ***************************************************************
##
# DATABASE Dog_Racing
# Classement des chiens avec prix
# 1 - 500
# 2 - 250
# 3 - 50

USE Dog_Racing;
DROP PROCEDURE IF EXISTS ErreurPerso;

DELIMITER |
CREATE PROCEDURE ChiensPrix()
BEGIN
    DECLARE _var VARCHAR(20);
		DECLARE _var VARCHAR(20);

		DECLARE _var VARCHAR(20);




END|
DELIMITER ;

CALL ErreurPerso();