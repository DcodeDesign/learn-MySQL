# ERROR MANAGEMENT

# Exemple

USE world;
DELIMITER |
CREATE PROCEDURE insertErreur()
  BEGIN
    DECLARE EXIT HANDLER FOR 1062
      SELECT 'Il y a doublon' AS Alert;
    DECLARE EXIT HANDLER FOR 1452
      SELECT 'Erreur de Foreign Key' AS Alert;

    INSERT INTO Pays values (1, 'test', 2);

  end |
DELIMITER ;

CALL insertErreur();

DROP PROCEDURE insertErreur;