# les transactions

START TRANSACTION;
INSERT INTO Continents (nom_cont) VALUES ('Europe');
INSERT INTO Pays (nom_pays, FK_cont) VALUES ('Belgique', 1);
INSERT INTO personne (nom_pers, prenom_pers, sexe_pers, FK_pays) VALUES ('Gravy', 'Thomas', 'M', 1);
COMMIT;

