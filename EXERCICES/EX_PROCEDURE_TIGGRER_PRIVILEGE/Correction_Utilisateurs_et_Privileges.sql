-- 1.	Création Utilisateur :

CREATE USER 'Marcel'@'localhost' IDENTIFIED BY 'mar';
CREATE USER 'Lucien'@'localhost' IDENTIFIED BY 'luc';
-- Verification : SELECT user, host FROM mysql.user;


-- 2.	Droit à Marcel sur ecole.t_Pers avec propagation :
GRANT ALL ON ecole.t_pers TO Marcel@localhost WITH GRANT Option ;
FLUSH PRIVILEGES ;

-- 3.	Tester les droits des 2 utilisateurs sur T_Pers et T_Prof
USE ecole;
SELECT * FROM T_Pers WHERE PK_Pers < 10;
SELECT * FROM T_Prof WHERE PK_Pers < 10;
-- Seul Marcel a accès à la DB (USE ecole;)
-- Il ne peut voir que les data de la table T_Pers !

-- 4.	Marcel donne les droits sur T_Prof à Lucien :
GRANT ALL ON ecole.t_prof TO Lucien@localhost ;
-- Erreur car Marcel n'a aucun droit sur T_Prof

-- 5.	Marcel donne les droits sur T_Pers à Lucien :
GRANT SELECT (nom, prenom) ON ecole.t_pers TO Lucien@localhost ;
--  Lucien verra les nom et prenom SEULEMENT de la table Pers
--  SELECT * lui sera refusé car il n'a pas accès aux autres champs
--  Il ne peut faire aucune modification

-- 6.	Marcel retire les droits sur T_Pers à Lucien :
REVOKE ALL PRIVILEGES ON ecole.t_pers FROM Lucien@localhost ;
FLUSH PRIVILEGES ;

