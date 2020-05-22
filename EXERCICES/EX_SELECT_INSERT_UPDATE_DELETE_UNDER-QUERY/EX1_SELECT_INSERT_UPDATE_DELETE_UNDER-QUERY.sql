-- ******************************************************
-- ******************************************************
-- 						         DOG_RACING
-- ******************************************************
-- ******************************************************

-- 1.
-- Pays avec ‘U’
USE Dog_Racing;
SELECT *
FROM pays
WHERE pays.nomP LIKE '%U%';
-- 2.
-- Pays sans ‘U’
USE Dog_Racing;
SELECT *
FROM Dog_Racing.pays
where nomP NOT LIKE '%U%';

-- 3.
-- Combien de pays sans ‘U’

USE Dog_Racing;
SELECT count(nomP)
FROM Dog_Racing.pays
WHERE nomP NOT LIKE '%U%';

-- 4.
-- Nom des chiens sans description
USE Dog_Racing;
SELECT *
FROM Dog_Racing.chien
WHERE descCh IS NULL;

-- 5.
-- ID, Nom et description des chiens ‘BE’
USE Dog_Racing;
SELECT idCh, nomCh, descCh
FROM chien
WHERE nationCh = 'BE'
ORDER BY nomCh ASC;

-- 6.
-- Combien de pays en tout
USE Dog_Racing;
SELECT count(nomP)
FROM Dog_Racing.pays
ORDER BY nomP ASC;

-- 7.
-- Course en 2014
USE Dog_Racing;
SELECT nomC, YEAR(dateC) AS ANNEE
FROM Dog_Racing.course
HAVING ANNEE = '2014'
ORDER BY nomC ASC;

-- 8.
-- Combien de pays DIFFÉRENTs accueillent des courses
USE Dog_Racing;
SELECT DISTINCT nomP
FROM Dog_Racing.course
       INNER JOIN Dog_Racing.pays ON Dog_Racing.course.lieuC = Dog_Racing.pays.codeP
ORDER BY nomP ASC;

-- ******************************************************
-- ******************************************************
-- 						           TINTIN
-- ******************************************************
-- ******************************************************

-- 9.
-- Pers (Nom, Prénom) ASC
USE tintin;
SELECT nomPers, prenomPers
FROM personnage
ORDER BY nomPers ASC;

-- 10.
-- Pers F sans prénom DESC
USE tintin;
SELECT nomPers, prenomPers, sexePers
FROM personnage
WHERE sexePers = 'F'
  AND prenomPers IS NULL
ORDER BY nomPers DESC;

-- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.
-- Affichez la liste (par ordre alphabétique sur le nom)
-- des personnages féminins ne possédant pas de prénom.
USE tintin;
SELECT nomPers
FROM personnage
WHERE sexePers = 'F'
  and prenomPers IS NULL
ORDER BY nomPers ASC;

-- 2.
-- Affichez la liste des personnages (Nom et Prénom) présents
-- dans l'album "L'ILE NOIRE" classés par idPers.
USE tintin;
SELECT nomPers, prenomPers
FROM personnage
       INNER JOIN pers_album on personnage.idPers = pers_album.idPers
       INNER JOIN album on pers_album.idAlb = album.idAlb
WHERE titreAlb = 'L''ILE NOIRE'
ORDER BY personnage.idPers;

-- 3.
-- Quelles sont les dates de début et de fin des aventures de Tintin ?
SELECT (SELECT dateAlb FROM album ORDER BY dateAlb ASC LIMIT 1)  AS dateMin,
       (SELECT dateAlb FROM album ORDER BY dateAlb DESC LIMIT 1) AS dateMax;

       -- other solution
       SELECT MIN(dateAlb) AS dateMin, MAX(dateAlb) AS dateMax
       FROM album;

-- 4.
-- Quelle est l'année durant laquelle les personnages ont été les plus "grossiers" ?
-- Indiquez le nombre de jurons prononcés durant cette année-là.
SELECT count(juron_album.idJur) AS nbrJuron, dateAlb
FROM album
       inner JOIN juron_album ON album.idAlb = juron_album.idAlb
GROUP BY dateAlb
ORDER BY nbrJuron DESC
LIMIT 1;

-- 5.
-- Quel(s) est(sont) le(s) juron(s) qui est(sont) prononcés exactement 15 fois
-- durant les aventures de Tintin ?
SELECT count(juron_album.idJur) AS NbrJur, nomJur
FROM juron_album
       inner JOIN juron ON juron_album.idJur = juron.idJur
GROUP BY juron_album.idJur
HAVING NbrJur = 15
ORDER BY NbrJur DESC;

-- 6.
-- Affichez le nom et la fonction des personnages féminins gentils classés par nom
SELECT nomPers, fonctPers
FROM personnage
WHERE sexePers = 'F'
  AND gentilPers = 1
ORDER BY nomPers ASC;

-- 7.
-- Combien de personnage ont visité la Belgique, le Congo, le Népal ou l'Islande ?
-- Affichez la réponse en détaillant le nombre pour chaque pays
SELECT count(DISTINCT nomPers) AS nbrPers, GROUP_CONCAT(DISTINCT nomPays)
FROM personnage
       INNER JOIN pers_album ON personnage.idPers = pers_album.idPers
       INNER JOIN album ON pers_album.idAlb = album.idAlb
       INNER JOIN pays_album ON album.idAlb = pays_album.idAlb
       INNER JOIN pays ON pays_album.idPays = pays.idPays
WHERE nomPays in ('BELGIQUE', 'CONGO', 'NEPAL', 'ISLANDE')
GROUP BY pays.idPays
ORDER BY nbrPers DESC;

-- 8.
-- Liste des albums classés par idAlb
-- + pays associés à chaque album classés par ordre alphabétique
-- (titreAlb, dateAlb, nomPays)
SELECT titreAlb, dateAlb, nomPays
FROM album
       INNER JOIN pays_album ON album.idAlb = pays_album.idAlb
       INNER JOIN pays ON pays_album.idPays = pays.idPays
ORDER BY titreAlb ASC;

-- 9.
-- Quelles sont les dates des 2ème et avant-dernier albums
-- des aventures de Tintin en considérant un ordre chronologique ?
SELECT 2EME.titreAlb, 2EME.dateAlb, AVTDERN.titreAlb, AVTDERN.dateAlb
FROM (SELECT * FROM album ORDER BY dateAlb ASC LIMIT 1,1) AS 2EME,
     (SELECT * FROM album ORDER BY dateAlb DESC LIMIT 1,1) AS AVTDERN;

-- 10.
-- Plusieurs albums de Tintin se déroulent dans plusieurs pays.
-- Si le nombre de pays fréquentés est au nombre de 3,
-- affichez ces pays ainsi que le titre de l'album.
USE tintin;
SELECT GROUP_CONCAT(DISTINCT nomPays), titreAlb
FROM album
       INNER JOIN pays_album ON album.idAlb = pays_album.idAlb
       INNER JOIN pays ON pays_album.idPays = pays.idPays
GROUP BY pays_album.idAlb
HAVING COUNT(DISTINCT nomPays) = 3;

       -- other solution
       USE tintin;
       SELECT nomPays, titreAlb
       FROM album
              INNER JOIN pays_album ON album.idAlb = pays_album.idAlb
              INNER JOIN pays ON pays_album.idPays = pays.idPays
       HAVING titreAlb in (SELECT titreAlb
                           FROM album
                                  INNER JOIN pays_album ON album.idAlb = pays_album.idAlb
                                  INNER JOIN pays ON pays_album.idPays = pays.idPays
                           GROUP BY pays_album.idAlb
                           HAVING COUNT(DISTINCT nomPays) = 3);

-- 11.
-- Liste des jurons (nom,id) commençant par "Espece de" classés par nom
SELECT nomJur, idJur
FROM juron
WHERE nomJur LIKE 'Espece de%'
ORDER BY nomJur ASC;

-- 12. Liste des 5 plus grands jurons (nom, id, longueur)
-- classés par longueur ( length() = longueur d’une chaîne de caractères)
SELECT nomJur, idJur, LENGTH(nomJur) as TAILLE
FROM juron
ORDER BY TAILLE DESC
LIMIT 5;

-- 13. Pour chaque album (id, titre),
-- le nom, le prénom et la fonction des personnages féminins
SELECT album.idAlb, album.titreAlb, group_concat('nom : ',personnage.nomPers, ' prénom : ',personnage.nomPers, ' function : ', personnage.fonctPers, '\n'  )
FROM album
INNER JOIN pers_album
       ON album.idAlb = pers_album.idAlb
INNER JOIN personnage
       ON pers_album.idPers = personnage.idPers
WHERE personnage.sexePers = 'F'
GROUP BY album.idAlb;

       -- other solution
       SELECT album.idAlb, album.titreAlb, personnage.nomPers, personnage.nomPers, personnage.fonctPers
       FROM album
       INNER JOIN pers_album
              ON album.idAlb = pers_album.idAlb
       INNER JOIN personnage
              ON pers_album.idPers = personnage.idPers
       WHERE personnage.sexePers = 'F'
       ORDER BY titreAlb;


-- 14.
-- Liste des gentils personnages féminins classé nom
SELECT nomPers
FROM personnage
WHERE gentilPers = 1
  and sexePers = 'F'
ORDER BY nomPers;

-- 15.
-- liste des albums classé par id + Nombre de pays associé à chaque album
-- (idalb, titre, année, Nb pays visités)
SELECT album.idAlb, album.titreAlb, album.dateAlb, COUNT(DISTINCT nomPays) AS CPT
FROM album
            INNER JOIN pays_album on album.idAlb = pays_album.idAlb
            INNER JOIN pays ON pays_album.idPays = pays.idPays
GROUP BY album.idAlb
ORDER BY CPT, dateAlb, titreAlb ASC;


-- 16.
-- Année de réalisation de "Tintin au Congo"
SELECT dateAlb
FROM album
WHERE titreAlb = 'Tintin au Congo';

-- 17.
-- Prénom du Capitaine Haddock
SELECT prenomPers
FROM personnage
WHERE nomPers = 'Haddock';

-- 18.
-- Dans quel(s) pays se déroule(nt) "On a marche sur la lune"
SELECT nomPays
FROM pays
       INNER JOIN pays_album ON pays.idPays = pays_album .idPays
       INNER JOIN album ON pays_album.idAlb = album.idAlb
WHERE titreAlb = 'On a marche sur la lune';

-- 19.
-- La "Castafiore" pronnonce-t-elle des jurons ?
SELECT CONCAT('La Castafiore a prononcé : ', COUNT(idJur), ' juron(s)')
FROM personnage
       INNER JOIN juron_album on personnage.idPers = juron_album.idPers
WHERE nomPers = 'Castafiore';

       -- others solutions
       USE tintin;
       SELECT IF((SELECT COUNT(idJur) AS CPT
                  FROM personnage
                              INNER JOIN juron_album on personnage.idPers = juron_album.idPers
                  WHERE nomPers = 'Castafiore') > 0, 'Oui', 'non');

-- 20.
-- Nom des albums dans lesquels Tintin voyage en Chine
SELECT DISTINCT titreAlb
FROM personnage
       INNER JOIN pers_album ON pers_album.idPers = personnage.idPers
       INNER JOIN album ON album.idAlb = pers_album.idAlb
       INNER JOIN pays_album ON album.idAlb = pays_album.idAlb
       INNER JOIN pays ON pays_album.idPays = pays.idPays
WHERE nomPays = 'CHINE';

-- 21.
-- Quels sont les personnages non anonyme ayant prononcé plus de 100 jurons
-- durant les aventures de Tintin
SELECT nomPers, count(DISTINCT juron_album.idJur) AS CPT
FROM personnage
       INNER JOIN juron_album on personnage.idPers = juron_album.idPers
WHERE nomPers != 'anonyme' OR prenomPers != 'anonyme'
GROUP BY personnage.idPers
HAVING CPT > 100
ORDER BY CPT DESC;

       -- other solution
       SELECT nomPers
       FROM personnage
              INNER JOIN juron_album on personnage.idPers = juron_album.idPers
       WHERE nomPers != 'anonyme' OR prenomPers != 'anonyme'
       GROUP BY personnage.idPers
       HAVING count(DISTINCT juron_album.idJur) > 100;

-- 22.
-- Quel est le nombre de jurons prononcé par les personnages figurant
-- dans "Le Lotus Bleu"
SELECT nomPers, prenomPers, count(juron_album.idJur)
FROM personnage
            INNER JOIN juron_album ON personnage.idPers = juron_album.idPers
            INNER JOIN album ON juron_album.idAlb = album.idAlb
WHERE titreAlb = 'Le Lotus Bleu'
GROUP BY personnage.idPers;

-- 23.
-- Quel est l'album ou haddock a prononce le plus de juron
SELECT titreAlb, count(DISTINCT idJur) AS CPT
FROM album
       INNER JOIN juron_album on album.idAlb = juron_album.idAlb
       INNER JOIN personnage on juron_album.idPers = personnage.idPers
WHERE nomPers = 'haddock'
GROUP BY album.idAlb
ORDER BY CPT DESC
LIMIT 1;

-- 24.
-- Album et N° Page où on peut lire :
-- "REVOLUTIONNAIRE EN PEAU DE LAPIN"
SELECT album.titreAlb, juron_album.numPage
FROM album
       INNER JOIN juron_album ON album.idAlb = juron_album.idAlb
       INNER JOIN juron ON juron_album.idJur = juron.idJur
WHERE nomJur = 'REVOLUTIONNAIRE EN PEAU DE LAPIN';

-- 25.
-- Liste des pays visités par le Prof TOURNESOL
SELECT DISTINCT nomPays
FROM pays
       INNER JOIN pays_album ON pays.idPays = pays_album.idPays
       INNER JOIN album ON pays_album.idAlb = album.idAlb
       INNER JOIN pers_album ON album.idAlb = pers_album.idAlb
       INNER JOIN personnage ON pers_album.idPers = personnage.idPers
WHERE nomPers = 'TOURNESOL'
ORDER BY nomPays ASC;

-- -- -- -- -- -- -- -- -- -- OTHERS

-- 1.
-- Affichez les albums de Tintin classés par ordre chronologique décroissant.
SELECT titreAlb
FROM album
ORDER BY titreAlb DESC;

-- 2.
-- Affichez les personnages féminins dont la fonction dans les aventures de TINTIN est connue.
SELECT nomPers, prenomPers, fonctPers
FROM personnage
WHERE sexePers= 'F' AND fonctPers IS NOT NULL
ORDER BY nomPers ASC;

-- 3.
-- Affichez la liste des jurons prononcés dans l'album "OBJECTIF LUNE" à la dixième page.
SELECT nomJur
FROM juron
       INNER JOIN juron_album ON juron.idJur = juron_album.idJur
       INNER JOIN album ON juron_album.idAlb = album.idAlb
WHERE titreAlb = 'OBJECTIF LUNE' AND numPage = 10
ORDER BY nomJur ASC;

-- 4.
-- Affichez la liste des jurons (sans doublons) prononcés par les bandits et les perroquets
-- dans les albums "TINTIN EN AMERIQUE" et "L'OREILLE CASSEE". Seul le nom des jurons sera affiché
-- et ils seront classés alphabétiquement.
SELECT DISTINCT nomJur
FROM juron
       INNER JOIN juron_album ON juron.idJur = juron_album.idJur
       INNER JOIN album ON juron_album.idAlb = album.idAlb
       INNER JOIN pers_album pa ON album.idAlb = pa.idAlb
       INNER JOIN personnage ON juron_album.idPers = personnage.idPers
WHERE fonctPers in('bandit', 'perroquet') AND titreAlb IN('TINTIN EN AMERIQUE', 'L''OREILLE CASSEE')
ORDER BY nomJur ASC;

-- 5.
-- Affichez le nom des personnages différents ayant prononcé un ou plusieurs jurons dans les 2 premières pages des albums.
SELECT DISTINCT nomPers
FROM juron
       INNER JOIN juron_album ON juron.idJur = juron_album.idJur
       INNER JOIN album ON juron_album.idAlb = album.idAlb
       INNER JOIN pers_album pa ON album.idAlb = pa.idAlb
       INNER JOIN personnage ON juron_album.idPers = personnage.idPers
WHERE numPage = 2
GROUP BY personnage.idPers
HAVING count(DISTINCT juron.idJur) > 0;

-- 6.
-- Combien de juron ont été prononcé par les 2 héros (Tintin et le capitaine Haddock) dans les albums "LE SECRET DE LA LICORNE" et
-- "ON A MARCHE SUR LA LUNE". Présentez le rapport en indiquant le nombre par album et par personne.
SELECT album.titreAlb, personnage.nomPers, count(juron_album.idJur) AS nb
FROM personnage
            INNER JOIN juron_album ON personnage.idPers = juron_album.idPers
            INNER JOIN album ON juron_album.idAlb = album.idAlb
WHERE (personnage.nomPers = 'tintin' OR personnage.nomPers = 'Haddock')
  and (album.titreAlb = 'LE SECRET DE LA LICORNE' or album.titreAlb = 'ON A MARCHE SUR LA LUNE')
GROUP BY personnage.idPers, album.idAlb;

-- 7.
-- Affichez le nombre de personnages différents renseignés dans la DB pour tous les albums de Tintin encodés.
-- Classez le rapport de manière décroissante sur le nombre.
SELECT titreAlb, count(DISTINCT pers_album.idPers) AS nbPers
FROM album
       INNER JOIN pers_album ON album.idAlb = pers_album.idAlb
       INNER JOIN personnage ON pers_album.idPers = personnage.idPers
GROUP BY album.idAlb
ORDER BY nbPers DESC;

-- 8.
-- Quelle est l'année et le titre de l'album dans lequel la "CASTAFIORE" est apparue pour la 1ere fois
SELECT titreAlb
FROM album
       INNER JOIN pers_album ON album.idAlb = pers_album.idAlb
       INNER JOIN personnage ON pers_album.idPers = personnage.idPers
WHERE nomPers = 'CASTAFIORE'
ORDER BY dateAlb
LIMIT 1;

-- 9. Quel(s) est(sont) le(s) personnage(s) qui participe(nt) à 5 aventures de Tintin uniquement
SELECT nomPers, count(DISTINCT titreAlb) as NbrAlb
FROM personnage
            INNER JOIN pers_album ON personnage.idPers = pers_album.idPers
            INNER JOIN album ON pers_album.idAlb = album.idAlb
GROUP BY personnage.idPers
HAVING NbrAlb = 5
ORDER BY NbrAlb DESC;

-- 10.
-- La DB renseigne que le juron "SCOLOPENDRE" a été prononcé par le capitaine Archibald Haddock dans "LE SECRET DE LA LICORNE"
-- à la page 20. Vérifiez cette info à l'aide d'une requête
SELECT count(nomJur)
FROM personnage
            INNER JOIN pers_album ON personnage.idPers = pers_album.idPers
            INNER JOIN album ON pers_album.idAlb = album.idAlb
            INNER JOIN juron_album ON album.idAlb = juron_album.idAlb
            INNER JOIN juron ON juron_album.idJur = juron.idJur
WHERE nomPers = 'Haddock'
  AND titreAlb = 'LE SECRET DE LA LICORNE'
  AND numPage = 20
  AND nomJur = 'SCOLOPENDRE';

       -- other solution
       SELECT IF((SELECT count(nomJur)
                  FROM personnage
                              INNER JOIN pers_album ON personnage.idPers = pers_album.idPers
                              INNER JOIN album ON pers_album.idAlb = album.idAlb
                              INNER JOIN juron_album ON album.idAlb = juron_album.idAlb
                              INNER JOIN juron ON juron_album.idJur = juron.idJur
                  WHERE nomPers = 'Haddock'
                    AND titreAlb = 'LE SECRET DE LA LICORNE'
                    AND numPage = 20
                    AND nomJur = 'SCOLOPENDRE') > 0, 'Oui', 'non');


-- 11.
-- Quel(s) est(sont) le(s) titre(s) de(s) albums de Tintin dont l'aventure réunit plus de 15 personnages "gentils" ?
-- Indiquez également le nombre de personnage dans la réponse.
SELECT titreAlb, count(pers_album.idPers) nbrPers
FROM album
            INNER JOIN pers_album ON album.idAlb = pers_album.idAlb
            INNER JOIN personnage ON pers_album.idPers = personnage.idPers
WHERE gentilPers = '1'
GROUP BY album.idAlb
HAVING nbrPers > 15
ORDER BY nbrPers DESC;

-- 12.
-- Quel(s) est(sont) le(s) titre(s) des albums de Tintin dont l'aventure se déroule dans UN SEUL pays ?
SELECT titreAlb
FROM album
            INNER JOIN pays_album ON album.idAlb = pays_album.idAlb
            INNER JOIN pays ON pays_album.idPays = pays.idPays
GROUP BY album.titreAlb
HAVING count(nomPays) = 1
ORDER BY titreAlb ASC;

-- 13. Combien d'années séparent le premier album de Tintin du dernier ? Faites-en sorte que l'affichage soit complet (Ex : 52 ans)
SELECT concat(max(dateAlb) - min(dateAlb), ' ans')
FROM album;

       -- other solution
       SELECT concat(
                     (
                         (SELECT dateAlb FROM album order by dateAlb desc LIMIT 1)
                                -
                         (SELECT dateAlb FROM album order by dateAlb asc LIMIT 1)
                     ), ' ans');


-- 14.
-- Regroupez et affichez par pays, le(les) ID du(des) pays fréquenté(s) dans chaque album de Tintin.
SELECT titreAlb, GROUP_CONCAT(DISTINCT pays_album.idPays)
FROM pays
       INNER JOIN pays_album ON pays.idPays = pays_album.idPays
       INNER JOIN album ON pays_album.idAlb = album.idAlb
GROUP BY album.titreAlb;

-- 15.
-- Combien de jurons sont prononcés au total dans les albums écrits avant 1945 ? Affichez la réponse en détaillant pour
-- chaque album. Soignez la lecture du rapport.
SELECT coalesce(titreAlb, 'Nombre Total de jurons') AS 'Titre des Albums',
       count(juron_album.idJur)                     AS 'Nombre de jurons par album'
FROM juron
            INNER JOIN juron_album ON juron.idJur = juron_album.idJur
            INNER JOIN album ON juron_album.idAlb = album.idAlb
WHERE dateAlb < 1945
GROUP BY album.titreAlb WITH ROLLUP;

-- 16.
-- Affichez la liste (clé, nom et prénom) sans doublons des personnages méchants présents dans les albums "TINTIN AU CONGO"
-- et "TINTIN ET LES PICAROS" classés par clé.
SELECT DISTINCT personnage.idPers, personnage.nomPers, personnage.prenomPers
FROM personnage
            INNER JOIN pers_album ON personnage.idPers = pers_album.idPers
            INNER JOIN album ON pers_album.idAlb = album.idAlb
WHERE album.titreAlb in('TINTIN AU CONGO','TINTIN ET LES PICAROS')
             AND personnage.gentilPers = 0
ORDER BY personnage.idPers;

-- 17.
-- Dans la requête 16, quels sont les doublons qui ont été masqué ainsi que le nombre de fois qu’ils auraient dû apparaitre ?
SELECT concat(personnage.nomPers, ' apparaît ', coalesce(personnage.prenomPers, '')) AS personnage,
       count(personnage.idPers)                                                      AS DOUBLON
FROM personnage
            INNER JOIN pers_album ON personnage.idPers = pers_album.idPers
            INNER JOIN album ON pers_album.idAlb = album.idAlb
WHERE album.titreAlb in ('TINTIN AU CONGO', 'TINTIN ET LES PICAROS')
  AND personnage.gentilPers = 0
GROUP BY personnage.idPers
HAVING DOUBLON > 1
ORDER BY personnage.idPers;

       -- other solution
       SELECT idPers, nomPers, count(nomPers) nb
       FROM personnage
                   INNER JOIN pers_album USING (idPers)
                   INNER JOIN album USING (idAlb)
       WHERE gentilPers = 0
         AND titreAlb in ('tintin au congo', 'tintin et les picaros')
       GROUP BY idPers
       HAVING nb > 1
       ORDER BY idPers;

-- 18.
-- Affichez les pays visités lors des aventures de Tintin entre 1955 et 1962 (années incluses)
SELECT titreAlb
FROM album
WHERE dateAlb BETWEEN 1955 AND 1962
ORDER BY titreAlb ASC;

       -- other solution
       SELECT titreAlb
       FROM album
       WHERE dateAlb >= 1955 AND dateAlb <= 1962
       ORDER BY titreAlb ASC;

-- 19.
-- Affichez les personnages "non anonyme" ayant participés aux albums dont le titre comporte le mot "Tintin"
SELECT nomPers, titreAlb
FROM album
       INNER JOIN pers_album ON album.idAlb = pers_album.idAlb
       INNER JOIN personnage ON pers_album.idPers = personnage.idPers
WHERE titreAlb like '%Tintin%' AND nomPers != 'ANONYME';

-- 20.
-- Un impoli se voit infliger une amende de 0,10 € par juron s'il en a prononcé plus de 20.
-- D'après les jurons répertoriés, quelle sera l'amende à payer par les inconvenants ?
-- Etant donné qu'on ne sait poursuivre un "Anonyme", ils seront retirés de la liste
SELECT nomPers, 0.10 * count(juron_album.idJur) AS Amande
FROM personnage
            INNER JOIN juron_album ON personnage.idPers = juron_album.idPers
WHERE nomPers != 'ANONYME'
GROUP BY personnage.idPers
HAVING count(juron_album.idJur) > 20
ORDER BY Amande DESC;

-- 21.
-- Affichez le podium (3 premiers) des jurons les plus prononcés.
SELECT nomJur, count(juron_album.idJur) AS nbrJur
FROM juron
            INNER JOIN juron_album ON juron.idJur = juron_album.idJur
GROUP BY juron.idJur
ORDER BY nbrJur DESC
LIMIT 3;

-- 22.
-- Affichez le nombre de personnage n'ayant pas de prénom connu en détaillant le nombre pour chaque album

-- ******************************************************
-- ******************************************************
-- 						           LOCAVOIT
-- ******************************************************
-- ******************************************************

-- 23.
-- Affichez la liste des clients (id, nom, prenom) classée par ordre alphabétique
USE locavoit;
SELECT idCli, nomCli, prenomCli
FROM clients
ORDER BY nomCli ASC;

-- 24.
-- Affichez les voitures toujours en service de catégorie A ou B
SELECT * from voitures 
WHERE catvoit IN ('A','B') AND dfinvoit IS NULL;

-- 25.
-- Affichez la liste des voitures en location (id, modele, categ, carbu, km, dDebLoc)
SELECT idVoit, modVoit, catVoit, carbvoit, kmVoit, dDebloc from voitures 
       INNER JOIN locations 
       ON voitures.idvoit = locations.voitureLoc
WHERE ddebloc IS NOT NULL AND dfinloc IS NULL;

-- 26. NOT END
-- Affichez la liste des voitures disponibles à la location (en service et pas de location en cours) - (id, modele, categ, carbu, km, nbPortes, nbPlaces, nbBaggages)
SELECT idVoit, modVoit, catVoit, carbVoit, kmVoit, nbportescat, nbplacescat, nbbagcat FROM voitures

       LEFT JOIN locations ON voitureLoc=idvoit    --ATTENTION OBLIGATOIRE LEFT(pour avoir meme les-- 
       LEFT JOIN categories ON idcat=catvoit                                              --FK null-- 
       
WHERE dfinvoit IS NULL 
GROUP BY idvoit 
HAVING (COUNT(ddebloc)-COUNT(dfinloc))= 0 --pas de locations en cours--;


-- 27.
-- Pour chaque catégorie : id, desc, nb voitures en service, nb voitures pas en service
SELECT idvoit, desccat, 
       COUNT(idvoit)-COUNT(dfinvoit) as NbvoitOK, COUNT(dfinvoit) as nbvoitOUT from categories  
       
       INNER JOIN voitures  
       ON voitures.catvoit = categories.idcat
       
GROUP BY idcat;
-- 28.
-- Affichez la liste des voitures (id, modele, categ, carbu, km) qui n'ont jamais été louées
SELECT idvoit, modvoit, catvoit, carbvoit, kmvoit from Voitures

       LEFT JOIN locations 
              ON voitures.idvoit = locations.voitureloc 

WHERE idloc IS NULL;
-- 29.
-- Affichez la liste des locations en cours: idLoc, dDebLoc, voiture, nomCli, prenomCli, nb de jours de location
SELECT idloc, ddebloc, voitureLoc, nomcli, prenomcli, 
                     DATEDIFF(CURDATE(), ddebloc)+1 as nbjourloc from locations 

       INNER JOIN clients 
              ON locations.clientloc = clients.idcli 

WHERE dfinloc IS NULL;

-- 30.
-- Quel est le meilleur client (plus grand nombre de locations) ? (id, nom, prénom, nbre de locations, prix total des locations)
SELECT idcli, Nomcli, prenomcli, COUNT(clientloc) as nombreloc, SUM(prixloc) as TOTLOC from locations
       INNER JOIN clients 
              ON locations.clientloc = clients.idcli 
GROUP BY idcli
ORDER BY nombreloc desc
LIMIT 1;

-- 31.
-- Affichez la liste des clients ayant loué pour plus de 1000 € (id, nom, prénom)
SELECT idcli, Nomcli, prenomcli, SUM(prixloc) as TOTLOC from locations
       INNER JOIN clients 
              ON locations.clientloc = clients.idcli 
GROUP BY idcli
HAVING TOTLOC>1000;

-- 32.
-- Affichez toutes les locations du client 1, la durée de location et les km parcourus
SELECT idloc, voitureloc as voiture,
              (dfinloc-ddebloc +1) as durée, 
              (kmfinloc-kmdebloc) as km, prixloc,remloc  FROM locations
       INNER JOIN voitures 
       ON idvoit= voitureloc 
WHERE clientloc=1;

-- 33.
-- Affichez le nombre de locations pour tous les clients
SELECT idcli, nomcli, prenomcli, COUNT(idloc) as nbloc from clients 
       INNER JOIN locations ON idcli = clientloc
GROUP BY idcli;

-- 34.
-- Affichez la liste des clients ayant plus d’une location en cours
SELECT idcli, nomcli, prenomcli, COUNT(idloc) from clients 
       INNER JOIN locations ON idcli = clientloc      
WHERE dfinloc is NULL
GROUP BY idcli 
HAVING COUNT(idloc)>1;

-- 35.
-- Affichez le nombre de locations pour tous les clients, le km total parcouru, la durée totale
SELECT idcli, nomcli, prenomcli, COUNT(clientloc) as nbloc, SUM(kmfinloc-kmdebloc) as kmparcouru,
              SUM(DATEDIFF(dfinloc,dDebloc)) as dureetot
from locations
       INNER JOIN clients ON clientloc=idcli
GROUP BY idcli
ORDER BY nomcli;

-- -- -- -- -- -- -- EVALUATION PERSONNEL

-- 1.
-- Donnez les noms et prénoms des personnages méchants présent dans l'album "Le Lotus Bleu".
select nomPers, prenomPers, gentilPers
from personnage 
    inner join pers_album 
        on personnage.idPers = pers_album.idPers 
    inner join album 
        on pers_album.idAlb = album.idAlb 
WHERE titreAlb = 'le Lotus Bleu' and gentilPers = 0
ORDER BY nomPers;

-- 2.
-- Etablissez la liste des différents jurons prononcés par Milou.
select nomPers, nomJur
from personnage 
    inner join juron_album
        on personnage.idPers = juron_album.idPers 
    inner join juron
        on juron_album.idJur = juron.idJur
WHERE nomPers = 'Milou'
GROUP BY juron.idJur;


-- 3.
-- Donnez le nombre de jurons prononcés par chaque personnage non anonyme.
-- Le rapport sera classé de manière décroissante en fonction du nombre.
select nomPers, count(juron_album.idJur) AS nbrJur
from personnage 
    inner join juron_album
        on personnage.idPers = juron_album.idPers 
    inner join juron
        on juron_album.idJur = juron.idJur
WHERE nomPers != 'ANONYME'
GROUP BY juron_album.idPers
ORDER BY nbrJur DESC;

-- 4. WRONG !
-- Quels sont les personnages (id, Nom et prénom) n'ayant pas prononcé de juron dans les album de tintin.
select personnage.idPers, nomPers, prenomPers
from personnage 
    INNER JOIN juron_album
        on personnage.idPers = juron_album.idPers
    INNER JOIN juron
        on juron_album.idJur = juron.idJur
WHERE juron_album.idJur IS NULL
GROUP BY juron_album.idPers;

-- 5.
-- Etablissez la liste des 10 personnages non anonyme prononçant le plus de jurons différents et
-- classez la par le nombre de jurons décroissant.
select nomPers, group_concat(nomJur), count(DISTINCT juron_album.idJur) nbrJur
from personnage 
    inner join juron_album
        on personnage.idPers = juron_album.idPers 
    inner join juron
        on juron_album.idJur = juron.idJur
WHERE nomPers != 'ANONYME'
GROUP BY juron_album.idPers
ORDER BY nbrJur DESC 
limit 10;


-- 6.
-- Lequel des 2 Dupont (T ou D) a prononcé le plus souvant des jurons ? Combien ?
select nomPers, count(juron_album.idJur) AS nbrJur
from personnage 
    inner join juron_album
        on personnage.idPers = juron_album.idPers 
    inner join juron
        on juron_album.idJur = juron.idJur
WHERE nomPers = 'DUPONT' OR nomPers = 'DUPOND'
GROUP BY juron_album.idPers
ORDER BY nbrJur DESC;

-- 7.
-- En quelle année et dans quel album le capitaine HADDOCK apparaît il pour la premère fois ?
select nomPers, titreAlb, dateAlb
from personnage 
    inner join pers_album 
        on personnage.idPers = pers_album.idPers 
    inner join album 
        on pers_album.idAlb = album.idAlb
WHERE nomPers = 'HADDOCK'
ORDER BY dateAlb
LIMIT 1;

-- 8. WRONG !
-- Pour les jurons "FORBAN" et "GREDIN", donnez le nom du juron, l'année durant laquelle il a été
-- écrit pour la première fois ainsi que le nombre de personnage différent les ayant prononcés.
SELECT DISTINCT nomJur, MIN(dateAlb), count(juron_album.idPers)
from juron 
    INNER JOIN juron_album USING (idJur)
    INNER JOIN personnage USING (idPers)
    INNER JOIN pers_album USING (idPers)
    INNER JOIN album 
        on pers_album.idAlb = album.idAlb
WHERE nomJur = 'FORBAN' OR nomJur = 'GREDIN' 
GROUP BY juron_album.idJur;


-- 9.
-- Quels sont les personnages différents non anonyme autre que milou, HADDOCK, Tintin, Dupont et Dupond,
-- présent dans les aventures de Tintin entre 1937 et 1940. On retrouve la date, ID et le nom du personnage dans le rapport.
select personnage.idPers, nomPers, prenomPers, dateAlb, titreAlb
    from personnage 
    inner join pers_album 
        on personnage.idPers = pers_album.idPers 
    inner join album 
        on pers_album.idAlb = album.idAlb 
WHERE nomPers != 'Milou' 
    and nomPers != 'HADDOCK' 
    and nomPers != 'TINTIN' 
    and nomPers != 'Dupont' 
    and nomPers != 'Dupond' 
    and nomPers != 'ANONYME' 
    and dateAlb BETWEEN '1937' AND '1940'
ORDER BY dateAlb;



-- ******************************************************
-- ******************************************************
-- 						       ECOLE / DOG_RACING
-- ******************************************************
-- ******************************************************

-- 1.

        -- a.
        -- Dans la table "pays", ajouter un enregistrement dont le "codeP" sera 'XX' et le "nomP" sera 'Indéterminé'
        DELETE FROM Dog_Racing.pays
        WHERE codeP = 'XX';

        USE Dog_Racing;
        INSERT INTO Dog_Racing.pays (codeP, nomP) VALUES ('XX', 'Indéterminé');

        UPDATE Dog_Racing.pays
        SET codeP= 'XX'
        WHERE codeP = 'XY';

        -- b.
        -- Dans la table "chien", mettre à jour la valeur du champ "nationCh".
        -- Si "nationCh" est NULL, il prendra la valeur 'XX'.
        UPDATE Dog_Racing.chien
        SET descCh = 'Indéterminé'
        WHERE descCh IS NULL;

       -- c.
       -- Créer une requête préparée qui permettra d'afficher le nom des chiens et leur pays
       -- d'origine en toutes lettres ainsi que le temps qu'ils ont mis lors d'une course rentrée en
       -- paramètre. La requête présentera les données en classant les enregistrements par ordre
       -- croissant de leurs résultats.

        PREPARE P_details_Courses
        FROM 'SELECT nomCh, nomP, temps
        FROM chien
          INNER JOIN resultat ON resultat.idCh = chien.idCh
          INNER JOIN course ON course.idC = resultat.idC
          INNER JOIN pays ON pays.codeP = chien.nationCh
        WHERE nomC = ?
        ORDER BY temps ASC';

        SET @course = "IEPSCF, du C308 au C313";

        EXECUTE P_details_Courses USING @course

-- 2. 
-- Créer une vue qui affichera la course la plus rapide en fonction du temps mis par le 1er.
drop view v_courserapide;

CREATE VIEW V_courseRapide AS
SELECT nomC
FROM course
WHERE idC = (
              SELECT idC
              FROM resultat
              ORDER BY temps ASC
              LIMIT 1
            )
;

SELECT *
FROM V_courseRapide;

-- 3. 
-- Créez une vue qui permettra d'afficher le nom et le pays d'origine en toutes lettres des chiens
-- n'ayant participés à aucune course.

CREATE VIEW V_chien_noCourse AS
SELECT nomCh, nomP
FROM chien
  LEFT JOIN resultat ON chien.idCh = resultat.idCh
  LEFT JOIN course ON resultat.idC = course.idC
  LEFT JOIN pays ON chien.nationCh = pays.codeP
WHERE temps IS NULL
ORDER BY nomCh ASC;

SELECT *
FROM V_chien_noCourse;

-- 4. 
-- Créer une requête préparée qui prendra en paramètre le nom d'une course ainsi que le nom
-- d'un chien (les 2 en toutes lettres).
-- La vue renverra le temps mis par ce chien lors de cette course s' il y a participé.
SELECT *
FROM course
  LEFT JOIN resultat ON course.idC = resultat.idC
  LEFT JOIN chien ON resultat.idC = chien.idCh
WHERE nomCh = "Bill"
  AND nomC = "ami de Boule";

SELECT nomCh, nomC, temps
FROM chien
  LEFT JOIN resultat ON chien.idCh = resultat.idCh
  LEFT JOIN course ON resultat.idC = course.idC
WHERE nomCh = "Bill"
  AND nomC = "Paris en motocrotte";

PREPARE V_dog_course
FROM
'SELECT temps
FROM chien
  LEFT JOIN resultat ON chien.idCh = resultat.idCh
  LEFT JOIN course ON resultat.idC = course.idC
WHERE nomCh = ?
  AND nomC = ?'
;

SET @nomChien = 'Bill', SET
SET @nomCourse = 'Paris en motocrotte';
SELECT @nomChien, @nomCourse;


EXECUTE V_dog_course USING @nomChien, @nomCourse;

-- 5. 
-- Affichez la clé primaire, le nom et le prénom des étudiants et des professeurs de la formation «Fleuriste » (FLEU).
USE ecole;
SELECT PK_Pers, Nom, Prenom
FROM t_pers
  INNER JOIN t_inscription ON t_pers.PK_Pers = t_inscription.FK_pers
  INNER JOIN t_branche ON t_inscription.FK_Cours = t_branche.PK_Branche
WHERE PK_Branche = 'FLEU'
UNION ALL
SELECT PK_Pers, Nom, Prenom
FROM t_pers
  INNER JOIN t_Prof ON t_pers.PK_Pers = t_Prof.FK_pers
  INNER JOIN t_branche ON t_Prof.FK_Branche = t_branche.PK_Branche
WHERE PK_Branche = 'FLEU'

-- 6. 
-- Combien y a-t-il d'étudiants masculins par niveau d’étude inscrits dans l’établissement ?
-- L’affichage nous donnera également le nombre total.
SELECT  COALESCE(Etude, '-- Total --') AS total, count(DISTINCT FK_Pers) AS nbr
FROM t_pers
  INNER JOIN t_inscription ON PK_Pers = FK_Pers
WHERE Sexe= 'M'
GROUP BY Etude
WITH ROLLUP;

-- 7. 
-- Combien y a-t-il de localité différente abritant un professeur ou un étudiant faisant partie de l'établissement.


SELECT count(*)
FROM (
SELECT DISTINCT PK_Loc
FROM t_loc
  INNER JOIN t_pers ON t_loc.PK_Loc = t_pers.FK_Loc
  INNER JOIN t_inscription ON t_pers.PK_Pers = t_inscription.FK_Pers

union

SELECT DISTINCT PK_Loc
FROM t_loc
  INNER JOIN t_pers ON t_loc.PK_Loc = t_pers.FK_Loc
  INNER JOIN t_prof ON t_pers.PK_Pers = t_prof.FK_Pers

) AS nbr

-- 8. 
-- Quelle est la durée totale de la formation d’un étudiant désirant suivre les cours de Carrosserie, Horlogerie et Construction.
SELECT SUM(Duree)
FROM (
        SELECT Duree
        FROM t_branche
        WHERE branche in('Carrosserie', 'Horlogerie', 'Construction')
      ) AS nbr;

      -- other Solution
      USE ecole;
      SELECT SUM(
               (SELECT Duree FROM t_branche WHERE Branche = 'Carrosserie')
                 +
               (SELECT Duree FROM t_branche WHERE Branche = 'Horlogerie')
                 +
               (SELECT Duree FROM t_branche WHERE Branche = 'Construction')
      );

-- 9.
       -- a.
       -- Quelle est(sont) la(les) localité(s) la(les) mieux représentée(s) dans l'école en
       -- tenant compte des étudiants uniquement.
        SELECT count(FK_Loc) AS nbr, localite
        FROM t_loc
              INNER JOIN t_pers ON t_loc.PK_Loc = t_pers.FK_Loc
              INNER JOIN t_inscription ON t_pers.PK_Pers = t_inscription.FK_Pers
        GROUP BY PK_loc
        HAVING nbr >= ( SELECT count(FK_Loc) AS nbrLoc
                            FROM t_loc
                              INNER JOIN t_pers ON t_loc.PK_Loc = t_pers.FK_Loc
                              INNER JOIN t_inscription ON t_pers.PK_Pers = t_inscription.FK_Pers
                        GROUP BY PK_loc
                        ORDER BY nbrLoc DESC
                        LIMIT 1,1
                      )
        ORDER BY nbr DESC;

       -- b.
       -- Cela change-t-il si on tient compte des professeurs également ?
        SELECT count(FK_Loc) AS nbr, localite
        FROM t_loc
              INNER JOIN t_pers ON t_loc.PK_Loc = t_pers.FK_Loc
              INNER JOIN t_inscription ON t_pers.PK_Pers = t_inscription.FK_Pers
        GROUP BY PK_loc
        HAVING nbr >= (
                        SELECT count(FK_Loc) AS nbrLoc
                              FROM t_loc
                                INNER JOIN t_pers ON t_loc.PK_Loc = t_pers.FK_Loc
                                INNER JOIN t_inscription ON t_pers.PK_Pers = t_inscription.FK_Pers
                        GROUP BY PK_loc

                        UNION ALL

                        SELECT count(FK_Loc) AS nbrLoc
                              FROM t_loc
                                INNER JOIN t_pers ON t_loc.PK_Loc = t_pers.FK_Loc
                                INNER JOIN t_prof ON t_pers.PK_Pers = t_prof.FK_Pers
                        GROUP BY PK_loc
                        ORDER BY nbrLoc DESC
                        LIMIT 1,1
                      )
        ORDER BY nbr DESC;
-- 10. 
-- Quelle est(sont) la(les) localité(s) qui ont le même nombre de représentants que la localité de "BOUGE"
SELECT count(PK_Pers) AS nbr , localite
FROM t_pers
  INNER JOIN t_loc ON t_pers.FK_Loc = t_loc.PK_Loc
GROUP BY PK_Loc
HAVING nbr = (
              SELECT count(PK_Pers)
              FROM t_pers
                INNER JOIN t_loc ON t_pers.FK_Loc = t_loc.PK_Loc
              WHERE localite = 'BOUGE'
              GROUP BY PK_Loc
            )
;

-- 11. 
-- Quelles sont les étudiants (clé primaire, nom et prénom) inscrits à plus de 2 formations ?
SELECT PK_Pers, Nom, prenom
FROM t_pers
  INNER JOIN t_inscription ON t_pers.PK_Pers = t_inscription.FK_Pers
GROUP BY PK_Pers
HAVING count(FK_Cours) > 2;

-- ******************************************************
-- ******************************************************
-- 						      Exercices 17/12/2019
-- ******************************************************
-- ******************************************************

-- 1.
-- Afficher les initiales des professeurs (M.V.)
SELECT DISTINCT Nom, Prenom, CONCAT(LEFT(Nom,1), '.', LEFT(Prenom,1), '.' )AS Initiales
FROM T_Pers
	INNER JOIN T_Prof ON T_Prof.FK_Pers = T_Pers.PK_Pers
;


SELECT DISTINCT Nom, Prenom, CONCAT(SUBSTRING(Nom FROM 1 FOR 1), '.', SUBSTRING(Prenom FROM 1 FOR 1), '.' )AS Initiales
FROM T_Pers
	INNER JOIN T_Prof ON T_Prof.FK_Pers = T_Pers.PK_Pers
ORDER BY Nom
;


SELECT DISTINCT Nom, Prenom, CONCAT(SUBSTRING(Nom FROM 2 FOR 3), '.', SUBSTRING(Prenom FROM 1 FOR 1), '.' )AS Initiales
FROM T_Pers
	INNER JOIN T_Prof ON T_Prof.FK_Pers = T_Pers.PK_Pers
;


-- 2.
--  Afficher les intitulés des cours qui ne sont suivis par personne
SELECT branche
FROM T_Branche
	LEFT JOIN T_Inscription ON T_Inscription.FK_Cours = T_Branche.PK_Branche
WHERE FK_Pers IS NULL
;


-- 3.
-- Afficher les intitulés des cours qui sont donnés par plus d'un professeur
SELECT branche, COUNT(FK_Pers) AS Prof
FROM T_Branche
	INNER JOIN T_Prof ON T_Prof.FK_Branche = T_Branche.PK_Branche
GROUP BY PK_Branche
HAVING Prof > 1
;

-- 4. NOT END
-- Afficher les noms et prénoms des étudiants inscrits à au moins un cours qui ont moins de 30 ans
UPDATE T_Pers
SET DateNaissance =
(
	SELECT FROM_UNIXTIME(FLOOR(RAND()*UNIX_TIMESTAMP()))
);


UPDATE T_Pers
SET DateNaissance =
(
	SELECT ADDDATE(DateNaissance, INTERVAL -18 YEAR)
)
;


SELECT CURRENT_DATE;
SELECT CURRENT_DATE();
SELECT CURRENT_TIMESTAMP;
SELECT CURRENT_TIMESTAMP();

SELECT Prenom, DateNaissance, TIMESTAMPDIFF(YEAR, DateNaissance, CURDATE()) AS age
FROM T_Pers
WHERE PK_Pers <= 10;


SELECT '1994-03-13', TIMESTAMPDIFF(second, '1994-03-13', CURDATE()) AS age;


SELECT Prenom, DateNaissance, TIMESTAMPDIFF(SECOND, DateNaissance, CURDATE()) AS age
FROM T_Pers
WHERE PK_Pers <= 10;


SELECT Nom, Prenom, DateNaissance, CONCAT(TIMESTAMPDIFF(YEAR, DateNaissance, CURDATE()), ' ans') AS age
FROM T_Pers
	INNER JOIN T_Inscription ON T_Inscription.FK_Pers = T_Pers.PK_Pers
HAVING age < 30
ORDER BY age;

  -- other
  UPDATE t_pers
  SET t_pers.DateNaissance = (SELECT FROM_UNIXTIME(FLOOR(RAND()*UNIX_TIMESTAMP())));

  UPDATE t_pers
  SET DateNaissance = (SELECT ADDDATE(DateNaissance, INTERVAL -18 YEAR));


-- 5.
-- Afficher les noms et prénoms des professeurs qui donnent un cours de plus de 70 heures
SELECT Nom, Prenom, Nb_Heure
FROM T_Pers
	INNER JOIN T_Prof ON T_Prof.FK_Pers = T_Pers.PK_Pers
	INNER JOIN T_Branche ON T_Prof.FK_Branche = T_Branche.PK_Branche
WHERE Nb_Heure > 70
;


-- 6. NOT END
-- Afficher le nombre d’élèves qui suivent les cours de Corentin PIGEON

SELECT COUNT(DISTINCT PK_Pers) AS Nb_Etudiant
FROM T_Pers
	INNER JOIN T_Inscription ON T_Inscription.FK_Pers = T_Pers.PK_Pers
WHERE FK_Cours IN
(
	SELECT PK_Branche
	FROM T_Branche
		INNER JOIN T_Prof ON T_Prof.FK_Branche = T_Branche.PK_Branche
		INNER JOIN T_Pers ON T_Prof.FK_Pers = T_Pers.PK_Pers
	WHERE nom = 'Pigeon' AND Prenom = 'Corentin' AND Nb_Heure IS NOT NULL
)
;

SELECT COUNT(DISTINCT PK_Pers) AS Nb_Etudiant
FROM T_Pers
	INNER JOIN T_Inscription ON T_Inscription.FK_Pers = T_Pers.PK_Pers
WHERE FK_Cours IN
(
	SELECT PK_Branche
	FROM T_Branche
		INNER JOIN T_Prof ON T_Prof.FK_Branche = T_Branche.PK_Branche
		INNER JOIN T_Pers ON T_Prof.FK_Pers = T_Pers.PK_Pers
	WHERE nom = 'Pigeon' AND Prenom = 'Corentin'
)
;

-- 7.
-- Afficher les élèves qui suivent les cours d’un professeur qui a un âge supérieur à la moyenne des
-- âges des élèves

    -- Explication d'une solution possible

    -- a :  1ère Sous-requête
    -- 		Afin de ne pas fausser la moyenne, il faut éliminer les doublons "Etudiant"
    -- b :  2de Sous-requête
    -- 		Calcul de la moyenne d'age de ces "Etudiant"
    -- c :  3ème Sous-requête
    -- 		PK des Profs plus agé que cette moyenne
    -- d :  4ème Sous-requête
    -- 		Détermination des cours donnés par ces profs
    -- e :  Requête finale
    -- 		Affichage des étudiants


SELECT DISTINCT PK_Pers, Nom, Prenom
FROM T_Pers
	INNER JOIN T_Inscription ON T_Pers.PK_Pers = T_Inscription.FK_Pers
WHERE FK_Cours IN
(
	SELECT DISTINCT FK_Branche
	FROM T_Prof
	WHERE FK_Pers IN
	(
		SELECT DISTINCT PK_Pers
		FROM T_Prof
			INNER JOIN T_Pers ON T_Pers.PK_Pers = T_Prof.FK_Pers
		WHERE TIMESTAMPDIFF(YEAR, DateNaissance, CURDATE()) >
		(
			SELECT AVG(TIMESTAMPDIFF(YEAR, DateNaissance, CURDATE())) AS age
			FROM T_Pers
			WHERE PK_Pers IN
				(
					SELECT DISTINCT PK_Pers
					FROM T_Pers
						INNER JOIN T_Inscription ON T_Pers.PK_Pers = T_Inscription.FK_Pers
				)
		)
	)
)
;
