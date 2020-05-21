# les transactions

## Exemple 1
START TRANSACTION;
INSERT INTO Continents (nom_cont) VALUES ('Europe');
INSERT INTO Pays (nom_pays, FK_cont) VALUES ('Belgique', 1);
INSERT INTO personne (nom_pers, prenom_pers, sexe_pers, FK_pays) VALUES ('Gravy', 'Thomas', 'M', 1);
COMMIT;


## Exemple 2
START TRANSACTION;
USE World;
INSERT INTO Continent (nom_cont) VALUES
('Europe'),
('Amerique'),
('Afrique'),
('Asie');

USE World;
INSERT INTO Pays (nom_pays, FK_cont) VALUES
('Belgique', 1),
('Congo', 2),
('Chine', 3),
('Californie', 4);

USE World;
INSERT INTO personne (nom_pers, prenom_pers, sexe_pers, FK_pays) VALUES
('Thomas', 'Gravy', 'M', 1),
('Lucie', 'Lyne', 'F', 2);
COMMIT;
