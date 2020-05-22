# WHEN CASE


# Exemples

USE tintin;
DELIMITER |
CREATE PROCEDURE gentilPers(in _id VARCHAR(7))
  BEGIN

    DECLARE _gentil INT;
    SELECT gentilPers into  _gentil
    FROM personnage
    WHERE idPers = _id;

    CASE (_gentil)
      WHEN 1 THEN SELECT 'Gentil';
      WHEN 0 THEN SELECT 'Méchant';
      ELSE SELECT 'Inconnu';
    END CASE;

  end |
DELIMITER ;
#set @id = 'PAHME';
set @id = 'PABDA';
CALL gentilPers(@id);

# Exercices

## si date < 1940 = album avant guerre
## si date < 1961 = album apres guerre
## si date > 1961 = album apres prof

USE tintin;
DELIMITER |
CREATE PROCEDURE albumEvent(in _idAlbum char(3), OUT _date year(4), OUT _titreAlbum char(255))
  BEGIN
    SELECT dateAlb into _date
    FROM album
    WHERE idAlb = _idAlbum;

    SELECT titreAlb into _titreAlbum
    FROM album
    WHERE idAlb = _idAlbum;

    CASE
      WHEN _date < 1940 THEN SELECT 'Album avant guerre';
      WHEN _date < 1961 THEN SELECT 'Album après guerre';
      ELSE SELECT 'Album après prof';
    END CASE;

  end |
DELIMITER ;

set @idAlbum = 'A14';
call albumEvent(@idAlbum, @dateAlbum, @titreAlbum);
SELECT @idAlbum, @dateAlbum, @titreAlbum;

DROP PROCEDURE albumEvent;