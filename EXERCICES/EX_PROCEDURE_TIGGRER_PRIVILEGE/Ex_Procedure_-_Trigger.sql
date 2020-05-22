*************************
*************************
* -- PROCEDURE STOCKEE 
*************************
*************************

-- DB Ecole
-- 1.	Créez une procédure stockée qui renvoie 3 paramètres.
-- 		* Le nombre de Femme
--		* Le nombre d'Homme
-- 		* Un commentaire donnant la situation ("H majoritaire", "F majoritaire", "Egalite")

****************************************************************

-- DB Tintin
-- 2.	Créez une procédure stockée qui prendra en paramètre le titre d'un album et un numéro de page. 
-- 		La procédure renverra dans une variable le nombre de jurons écrits à cette page.
--		Appelez ensuite cette procédure en lui passant les paramètres nécessaires. 		
 
****************************************************************

-- DB Tintin
-- 3.	Créez une procédure stockée qui vous donnera le nombre de pays fréquentés, le nombre de personnages intervenant 
--		et le nombre de jurons écrits dans l'album dont le titre est passé en paramètre.

****************************************************************

-- DB Tintin
-- 4.	Tous les albums ont un pays commun non-renseigné dans la DB.  
--		Mettez en place une procédure stockée qui : 
--      * Ajoute le pays "Wallonie" ("WAL") dans la table PAYS. 
--      * Ajoute ensuite ce pays à chaque album.

****************************************************************

-- DB Tintin
-- 5.	Les pays "Egypte", "Nepal" et "Perou" sont infectés par le COVID-19
--		* Ajouter un champ booléen à la table "Personnage" 
--		* Flaguer tous les personnages ayant voyagé dans ces pays




***************
***************
* -- TRIGGER 
***************
***************

-- DB Monde
-- 6.	Mettre en place un trigger qui, lors d'un encodage, veillera a ce que le nom
--		complet ainsi que la premiere lettre du prenom soient mis en majuscule

****************************************************************

-- DB Tintin
-- 7.	Après relecture des albums de Tintin, on a remarqué des oublis quant à l'encodage des jurons.  
-- 		On va donc les ajouter. Mettez en place un trigger qui vérifiera que le personnage concerné 
--		apparait bien dans l'album mis en cause.  
-- 		En cas d'erreur, aucune insertion ne sera réalisée.		

****************************************************************

-- DB Tintin
-- 8.	La clé primaire d'une personne est une chaine de 5 caractères. Il est dès lors possible d'introduire
---		2 fois la même personne (nom et prénom). Mettez en place un trigger qui vérifiera lors de l'ajout 
---		d'une personne qu'on n'essaie pas d'encoder la même personne (nom et prénom) avec un clé différente. 
-- 		En cas d'erreur, aucune insertion ne sera réalisée et un message d'erreur sera affiché.




***************
***************
* -- COMPLET 
***************
***************

-- DB Ecole
-- 9.	Créer une table T_SitInscription (PK_Cours, Nombre) 
--		Insérer y les différentes formations en mettant le nombre à 0 AVANT TOUTE CHOSE
--		Ensuite
--		* Créer une procédure stockée qui donnera la situation actuelle des inscriptions
--		* Mettre en place un trigger qui, à chaque insertion dans la table T_Inscription, ajoutera une unité 
--		  au nombre afin d'avoir une situation à jour sans devoir recompter à chaque fois le nombre d'inscrits
--

****************************************************************

-- 10.	* Créer une DB "Gestion_Stock"
--		* Créer une table "Produit" (PK, Nom_Produit, Quantite, Limite, Recommande, Nombre_A_Recomander) 
--			- Quantite : Entier => nombre en stock
--			- Limite : Entier => nombre MINIMUM de pièce à détenir
--			- Recommande : Booléen => si un produit est en dessous du seuil "Limite"
--			- Nombre_A_Recomander : Entier => nombre à recommander afin de disposer de 10 pieces au dessus de la limite
--		* Mettre en place un trigger qui, lors d'un UPDATE de la table, évalue la quantité en f(x) de la limite
--			- Si la limite est SUPERIEURE à la quantité 
--				=> Recommande = TRUE 
--				=> Nombre_A_Recomander = (limite + 10) - quantité encore disponible 
--			- Si la limite est INFERIEURE à la quantité 
--				=> Recommande = FALSE 
--				=> Nombre_A_Recomander = 0
-- 		Rem :  Les Update peuvent donc se faire dans les 2 sens (positif ou négatif)			




***************
***************
* -- DIVERS 
***************
***************

--  DB LocaVoit
--  11. 	Ecrire une requête qui donne pour chaque client :
--    			- le nombre de locations
--    			- total des km parcourus
--    			- nombre moyen de km parcourus par location
--    			- durée totale des locations
--    			- prix total des locations










	   
	   

