# CREATE DATABASE

CREATE DATABASE IF NOT EXISTS Personnes;

USE Personnes;

CREATE TABLE IF NOT EXISTS Continents (
  id_cont  int(255) NOT NULL auto_increment,
  nom_cont VARCHAR(24) UNIQUE,
  PRIMARY KEY (id_cont)
)
  ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Pays (
  id_pays  int(255) NOT NULL auto_increment,
  nom_pays VARCHAR(24) UNIQUE,
  FK_cont  int(255) NOT NULL,
  PRIMARY KEY (id_pays),
  FOREIGN KEY (FK_cont) REFERENCES Continents (id_cont)
)
  ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Personne (
  id_pers     int(255)             NOT NULL auto_increment,
  nom_pers    VARCHAR(24)          NOT NULL,
  prenom_pers VARCHAR(24)          NOT NULL,
  sexe_pers   ENUM ('F', 'M', 'A') NOT NULL DEFAULT 'M',
  FK_pays     int(255)             NOT NULL,
  PRIMARY KEY (id_pers),
  FOREIGN KEY (FK_pays) REFERENCES Pays (id_pays)
)
  ENGINE = INNODB;

# ACTION ON DATABASE

INSERT INTO Continents (nom_cont) VALUES ('Europe');
INSERT INTO Pays (nom_pays, FK_cont) VALUES ('Belgique', 1);
INSERT INTO personne (nom_pers, prenom_pers, sexe_pers, FK_pays) VALUES ('Gravy', 'Thomas', 'M', 1);

DROP DATABASE Personnes;