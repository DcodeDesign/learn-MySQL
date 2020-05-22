-- Exercices donné en classe

-- 1.	Mettre en place un trigger qui paliera l'absence de contrainte "AUTO_INCREMENT" 
--		suite à la copie de la table Personne

USE Monde;

DROP TABLE IF EXISTS PersBis;

CREATE TABLE IF NOT EXISTS PersBis AS SELECT * FROM personne;

DROP TRIGGER IF EXISTS bi_Pk_Sexe;

DELIMITER |
CREATE TRIGGER bi_Pk_Sexe BEFORE INSERT ON PersBis FOR EACH ROW
BEGIN

	DECLARE _pk int;

	SELECT MAX(id_pers) INTO _pk FROM PersBis; 		
	SET NEW.id_pers = _pk + 1;
	
	IF NEW.sexe != 'M' AND NEW.sexe != 'F' THEN
	SET NEW.sexe = '?';
	END IF;

END |
DELIMITER ;


INSERT INTO PersBis(nom, prenom, sexe, fk_pays) VALUES
('Leblanc', 'Luc', 'M', 1),
('Leroux', 'Pol', 'H', 1),
('Lenoir', 'Zoe', 'F', 1);


-- 2.	Création d'un champ "date_inscription" dans la table T_Inscription.
--		Création d'un trigger qui ajoutera automatiquement la date du jour ainsi que l'heure lors d'une inscription

USE ecole;

ALTER TABLE T_Inscription
	ADD COLUMN date_inscription DATETIME;

DROP TRIGGER IF EXISTS bi_date_Inscr;

DELIMITER |
CREATE TRIGGER bi_date_Inscr BEFORE INSERT ON T_Inscription FOR EACH ROW
BEGIN
	SET NEW.date_inscription = NOW();
END |
DELIMITER ;



INSERT INTO T_Inscription(FK_Pers, FK_Cours) VALUES
(1, 'INFO');

ALTER TABLE T_Inscription
	DROP COLUMN date_inscription;

-- 3.	Cr�ation d'une table "Log" (PK, NomTable, TypeModif, Date, PK_Affect�e, User). 
--		Chaque Update de la table "Monde.Personne" fera l'objet d'une ligne dans la table "Log"


USE Monde;

DROP TABLE IF EXISTS Mouchard;

CREATE TABLE IF NOT EXISTS Mouchard 
(
	PK SMALLINT unsigned NOT NULL AUTO_INCREMENT,  
	NomTable VARCHAR(25) NOT NULL, 
	TypeModif VARCHAR(10) NOT NULL, 
	Date_Upd DATETIME NOT NULL, 
	PK_Upd SMALLINT unsigned NOT NULL, 
	Pers VARCHAR(30),
	PRIMARY KEY (PK)
)ENGINE = InnoDB ;

DROP TRIGGER IF EXISTS au_Mouchard;

DELIMITER |
CREATE TRIGGER au_Mouchard AFTER UPDATE ON Personne FOR EACH ROW
BEGIN
	INSERT INTO Mouchard (NomTable, TypeModif, Date_Upd, PK_Upd, Pers)

	VALUES("Personne", 'UPDATE', NOW(), OLD.ID_Pers, USER());

END |

DELIMITER ;

UPDATE Personne
	SET prenom = 'Mitch'
	WHERE ID_Pers = 1;
	

-- 4.	Refuser l'inscription � plus de 2 cours => Message personnel

USE ecole;

DROP TRIGGER IF EXISTS bi_double_Inscription;

DELIMITER |
CREATE TRIGGER bi_double_Inscription BEFORE INSERT ON T_Inscription FOR EACH ROW
BEGIN

	DECLARE _errorMessage VARCHAR(100);	
	DECLARE _nb SMALLINT;	

	SELECT COUNT(*) INTO _nb 
		FROM t_inscription
		WHERE FK_Pers = NEW.FK_Pers;
		
	IF (_nb > 0) THEN
			SET _errorMessage = CONCAT('Maximum 2 Inscription !');
			SIGNAL SQLSTATE '99999' SET MESSAGE_TEXT = _errorMessage;
		END IF;

END |
DELIMITER ;

SELECT * FROM T_Inscription;

INSERT INTO T_Inscription (FK_Pers, FK_Cours) VALUES
(893, 'INFO');

INSERT INTO T_Inscription (FK_Pers, FK_Cours) VALUES
(893, 'LANG');







