# ALTER TABLE

ALTER TABLEmodifie la structure d'une table. Par exemple, vous pouvez ajouter ou supprimer des colonnes, 
créer ou détruire des index, modifier le type des colonnes existantes ou renommer des colonnes ou la table elle-même.
Vous pouvez également modifier des caractéristiques telles que le moteur de stockage utilisé pour la table ou le 
commentaire de table.

Pour utiliser ALTER TABLE, vous avez besoin ALTER, CREATE et des INSERT privilèges pour la table.
Modification du nom d' une table exige ALTER et DROP sur la vieille table, ALTER, CREATEet INSERT 
sur la nouvelle table.

**Exemple:**

```
ALTER TABLE t2 DROP COLUMN c, DROP COLUMN d;
ALTER TABLE t1 ENGINE = InnoDB;
ALTER TABLE t1 ROW_FORMAT = COMPRESSED;
ALTER TABLE t1 CHARACTER SET = utf8;
ALTER TABLE t1 AUTO_INCREMENT = 13;

```