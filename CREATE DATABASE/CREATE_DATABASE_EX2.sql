CREATE DATABASE IF NOT EXISTS World;

USE World;
CREATE TABLE IF NOT EXISTS Continent (
  id_cont  int(255) NOT NULL auto_increment, ## indexer automatiquement
  nom_cont VARCHAR(24) UNIQUE,
  PRIMARY KEY (id_cont)
)
  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Pays (
  id_pays  int(255) NOT NULL auto_increment,  ## indexer automatiquement
  nom_pays VARCHAR(24),  ## indexer automatiquement
  FK_cont  int(255) NOT NULL,
  PRIMARY KEY (id_pays)
  ##FOREIGN KEY (FK_cont) REFERENCES Continents (id_cont)
)
  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS personne (
  id_pers     int(255)             NOT NULL auto_increment,  ## indexer automatiquement
  nom_pers    VARCHAR(24)          NOT NULL,
  prenom_pers VARCHAR(24)          NOT NULL,
  sexe_pers   ENUM ('F', 'M', 'A') NOT NULL DEFAULT 'M',
  FK_pays     int(255)             NOT NULL,
  PRIMARY KEY (id_pers)
  ##FOREIGN KEY (FK_pays) REFERENCES Pays (id_pays)
  ## KEY(nom_pers) ## index un champs
)
  ENGINE = InnoDB;

USE World;
ALTER TABLE Pays
  ADD CONSTRAINT fk_Pays_Continent FOREIGN KEY (FK_cont) REFERENCES Continent (id_cont);

USE World;
ALTER TABLE personne
  ADD CONSTRAINT fk_Pers_Pays FOREIGN KEY (FK_pays) REFERENCES Pays (id_pays);
