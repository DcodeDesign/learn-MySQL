# ALTER_TABLE

# CREATE DATA for exemple
USE Personnes;

CREATE TABLE IF NOT EXISTS Localite(
  PK_Loc INT(255) NOT NULL auto_increment,
  nom VARCHAR(24) NOT NULL DEFAULT 'X',
  PRIMARY KEY (PK_Loc)
)ENGINE = INNODB;

DROP database db;

# ACTION ALTER TABLE
USE Personnes;

ALTER TABLE Personnes.Personne
  ADD COLUMN FK_Loc INT(255) NOT NULL;

ALTER TABLE Personnes.Personne
  ADD CONSTRAINT fk_Pers_Localite FOREIGN KEY (FK_Loc) REFERENCES Localite (PK_Loc);

# Exemples

ALTER TABLE `tableName`
  ADD CONSTRAINT fk_Pers_Localite FOREIGN KEY (FK_Loc) REFERENCES LOCALITE (PK_Loc) ON UPDATE CASCADE;

ALTER TABLE tableName
  ADD CONSTRAINT fk_Pers_Cours FOREIGN KEY (FK_Loc, FK_Pers, FK_Cours) REFERENCES LOCALITE (PK_Loc);

ALTER TABLE tableName DROP FOREIGN KEY fk_Pers_Localite;

ALTER TABLE tableName
  ADD COLUMN champs_1 varchar(15) not null DEFAULT 'Coucou';

ALTER TABLE tableName
  DROP COLUMN champs_1, DROP COLUMN champs_2;

ALTER TABLE tableName
  MODIFY champs_1 varchar(45);

ALTER TABLE tableName
  MODIFY champs_1 varchar(45);

ALTER TABLE tableName
  CHANGE nom NAME varchar(10);

ALTER TABLE tableName
  ADD INDEX idefix (nom);

ALTER TABLE tableName
  ADD UNIQUE un1 (nom);

ALTER TABLE tableName
  ADD UNIQUE un1 (nom);
