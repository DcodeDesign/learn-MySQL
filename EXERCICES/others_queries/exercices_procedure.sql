-- ************************************************************************************
--
--                              EXERCICES
--
-- ************************************************************************************

-- ************************************************************************
--                              PROCEDURES
-- ************************************************************************

-- ******************************************************************
-- 1. Créer une procédure qui affiche en une fois les nombres impairs
-- ******************************************************************

USE World;
DROP PROCEDURE IF EXISTS ShowImpair;

DELIMITER |
CREATE PROCEDURE ShowImpair()
  BEGIN
    DECLARE _i INT;
    DECLARE _txt VARCHAR(100) DEFAULT '';

    SET _i = 1;

    WHILE (_i <= 20) DO
      if (_i % 2)
      THEN
        SET _txt = CONCAT(_txt, ' ', _i);
      END IF;

      SET _i = _i +1;
    end while;

    SELECT _txt AS Impair;

  end |
DELIMITER ;

CALL ShowImpair();

-- ******************************************************************
-- 2. Créer une procédure qui affiche les noms et prénoms dont la clé est impaire.
-- ******************************************************************

USE World;
DROP PROCEDURE IF EXISTS ShowNameImpair;

DELIMITER |
CREATE PROCEDURE ShowNameImpair()
  BEGIN
    SELECT id_pers, nom_pers, prenom_pers FROM World.personne WHERE id_pers % 2;

  end |
DELIMITER ;

CALL ShowNameImpair();

-- ******************************************************************
-- 3. Créer une procédure qui prendra l'ID d'une voiture en paramètre (Table Voitures)
--		o	Si KM <= 50 : Neuf
--		o	Si KM <= 3000 : Rodé
--		o	Si KM <= 4000 : Fiable
--		o	Si KM > 4000 : A remplacer
-- ******************************************************************

USE locavoit;
DROP PROCEDURE IF EXISTS ShowCar;

DELIMITER |
CREATE PROCEDURE ShowCar(IN _idVoit VARCHAR(9))
  BEGIN
    DECLARE _nbrResult INT(255);
    DECLARE _KM INT(10);
    DECLARE _txt VARCHAR(64) DEFAULT '';

    SET _nbrResult = (SELECT COUNT(*) FROM locavoit.voitures WHERE idVoit = _idVoit);
    SET _KM = (SELECT kmVoit FROM locavoit.voitures WHERE idVoit = _idVoit);

    IF (_nbrResult < 1)
    THEN

      SELECT 'Aucun résultat trouvé';

    ELSE

      CASE
        WHEN _KM <= 50
        THEN SET _txt = 'Neuf';
        WHEN _KM <= 3000
        THEN SET _txt = 'Rodé';
        WHEN _KM <= 4000
        THEN SET _txt = 'Fiable';
      ELSE SET _txt = 'A remplacer';
      END CASE;

      SELECT idVoit, modVoit, catVoit, kmVoit, _txt FROM locavoit.voitures WHERE idVoit = _idVoit;

    END IF;
  end |
DELIMITER ;

set @idVoit1 = '1-AAA001';
set @idVoit2 = '1-AAA003';
CALL ShowCar(@idVoit2);

-- ******************************************************************
-- 4. Créer une procédure stockée qui prendra en paramètres le nombre maximum de participants
--    et qui affichera "Complet" si le nombre d'inscrit est atteint.
-- ******************************************************************
USE ecole;
DROP PROCEDURE IF EXISTS nbrParticipants;

DELIMITER |
CREATE PROCEDURE nbrParticipants(IN _nbrMax INT)
  BEGIN
    SELECT COUNT(FK_Pers),
           FK_Cours,
           (CASE
              WHEN COUNT(FK_Pers) = _nbrMax THEN 'Nombre Maximum atteint'
              WHEN COUNT(FK_Pers) >= _nbrMax THEN 'Nombre Maximum dépassé'
              ELSE 'Nombre Maximum non atteint'
               END)                                                    AS nbr,
           (IF(_nbrMax > COUNT(FK_Pers), _nbrMax - COUNT(FK_Pers), 0)) As Reste
    FROM ecole.t_inscription
             GROUPE
    GROUP BY FK_Cours
    ORDER BY nbr ASC;

  END |
DELIMITER ;

SET @nbrMax = 20;
CALL nbrParticipants(@nbrMax);

-- ******************************************************************
-- 5. Création d’une procédure qui contrôlera qu’aucun prof n’est étudiant dans la section
-- ******************************************************************

-- ******************************************************************
-- 6. Est-il possible qu'il y ait un juron a la page 58 du "Le Lotus Bleu" (A04)
-- ******************************************************************

-- ******************************************************************
-- Extra 7. Certains albums n'auraient pas été écrit par Hergé.
-- 		    Ils ne devraient donc pas se trouver dans la DB.
--			Pour ne pas supprimer les enregistrements, il est demadé de
--				- Ajouter un champ booléen "Doute" dans les tables Pays et Albums
-- 				- Créer une procédure qui prendra le titre de l'album concerné en paramètre IN.
-- 				  Elle "flaguera" le titre dans la table album ainsi que tous les pays visités
--				  durant ces aventures
-- ******************************************************************

-- ******************************************************************
-- Extra 8. DB dog_racing
-- 		    Ajouter un champ "Prix" à la table Resultat
--			Créer une procédure qui mettra à jour le champ "Prix"
--			(1er => 500, 2eme => 250, 3eme => 50)
-- ******************************************************************

-- ******************************************************************
-- Extra 9. DB dog_racing
-- 		    Créer une procédure qui prendra le nom d'un chien
--			ainsi que le nom d'une course en IN.
--		    La procédure renverra dans un paramètre OUT le montant du prix gagné
-- ******************************************************************

-- ******************************************************************
-- Extra 10. DB dog_racing
-- 		     Créer une procédure qui prendra le nom de 2 chiens en IN.
--		     La procédure renverra dans un paramètre OUT le montant total gagné par ces 2 chiens
-- ******************************************************************

-- ******************************************************************
-- DB Ecole
-- 1.	Créez une procédure stockée qui renvoie 3 paramètres.
-- 		* Le nombre de Femme
--		* Le nombre d'Homme
-- 		* Un commentaire donnant la situation ("H majoritaire", "F majoritaire", "Egalite")
-- ******************************************************************

USE ecole;
DROP PROCEDURE IF EXISTS NbrFH;

DELIMITER |
CREATE PROCEDURE NbrFH()
  BEGIN
    DECLARE _nbrF INT;
    DECLARE _nbrH INT;

    SET _nbrF = (SELECT COUNT(PK_Pers) FROM ecole.t_pers WHERE Sexe = 'F' GROUP BY Sexe);
    SET _nbrH = (SELECT COUNT(PK_Pers) FROM ecole.t_pers WHERE Sexe = 'M' GROUP BY Sexe);

    CASE
      WHEN _nbrF > _nbrH THEN SELECT 'Femme majoritaire' AS Majoritaire, CONCAT('Homme : ', _nbrH, ' < ', 'Femme : ', _nbrF  ) as Nombre;
      WHEN _nbrF < _nbrH THEN SELECT 'Homme majoritaire' AS Majoritaire, CONCAT('Homme : ', _nbrH, ' > ', 'Femme : ', _nbrF  ) as Nombre;
      ELSE SELECT 'Egalite' AS Majoritaire, CONCAT('Homme : ', _nbrH, ' = ', 'Femme : ', _nbrF  ) as Nombre;
    END CASE;

  end |
DELIMITER ;
CALL NbrFH();

-- ****************************************************************
-- DB Tintin
-- 2.	Créez une procédure stockée qui prendra en paramètre le titre d'un album et un numéro de page.
-- 		La procédure renverra dans une variable le nombre de jurons écrits à cette page.
--		Appelez ensuite cette procédure en lui passant les paramètres nécessaires.
-- ****************************************************************

USE tintin;
DROP PROCEDURE IF EXISTS NbrJurons;

DELIMITER |
CREATE PROCEDURE NbrJurons(IN _titreAlb VARCHAR(255), IN _numPage INT(3), OUT _nbrJuron INT)
  BEGIN
   SELECT COUNT(tintin.juron_album.idJur) INTO _nbrJuron FROM tintin.juron_album
       INNER JOIN album ON tintin.juron_album.idAlb = tintin.album.idAlb
        WHERE tintin.juron_album.numPage = _numPage  AND tintin.album.titreAlb = _titreAlb
    GROUP BY tintin.album.idAlb;

  end |
DELIMITER ;

SET @titreAlb = 'TINTIN AU CONGO';
SET @numPage =  5;
CALL NbrJurons(@titreAlb, @numPage, @nbrJuron);
SELECT CONCAT('l Album ', @titreAlb , ' page ', @numPage, ' contient ', @nbrJuron, ' juron(s)');

-- ****************************************************************
-- DB Tintin
-- 3.	Créez une procédure stockée qui vous donnera le nombre de pays fréquentés, le nombre de personnages intervenant
--		et le nombre de jurons écrits dans l'album dont le titre est passé en paramètre.
-- ****************************************************************

-- ****************************************************************
-- DB Tintin
-- 4.	Tous les albums ont un pays commun non-renseigné dans la DB.
--		Mettez en place une procédure stockée qui :
--      * Ajoute le pays "Wallonie" ("WAL") dans la table PAYS.
--      * Ajoute ensuite ce pays à chaque album.
-- ****************************************************************

-- ****************************************************************
-- DB Tintin
-- 5.	Les pays "Egypte", "Nepal" et "Perou" sont infectés par le COVID-19
--		* Ajouter un champ booléen à la table "Personnage"
--		* Flaguer tous les personnages ayant voyagé dans ces pays
-- ****************************************************************

-- ************************************************************************
--                              TRIGGER
-- ************************************************************************

-- ****************************************************************
-- DB Monde
-- 6.	Mettre en place un trigger qui, lors d'un encodage, veillera a ce que le nom
--		complet ainsi que la premiere lettre du prenom soient mis en majuscule
-- ****************************************************************
USE World;
DROP TRIGGER IF EXISTS before_insert_MajusculePers;
DELIMITER |
CREATE TRIGGER before_insert_MajusculePers BEFORE INSERT
ON World.personne FOR EACH ROW
BEGIN
   SET NEW.nom_pers = UCASE(nom_pers);
   SET NEW.prenom_pers = CONCAT(UPPER(LEFT(NEW.prenom_pers,1)),LOWER(SUBSTRING(NEW.prenom_pers,2)));
END |
DELIMITER ;

