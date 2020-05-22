# ERROR MANAGEMENT

### Déclarer un gestionnaire

Pour déclarer un gestionnaire, vous utilisez DECLARE HANDLER instruction comme suit:

```
DECLARE action HANDLER FOR condition_value statement;
```

Si une condition dont la valeur correspond à la  condition_value, MySQL exécutera la statementet continuera 
ou quittera le bloc de code actuel basé sur la action.

### Exemple

Le gestionnaire suivant indique la valeur de la  hasErrorvariable 1 et continuer l'exécution si une SQLEXCEPTIONsurvient
```
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
SET hasError = 1;
```

Le gestionnaire suivant annule les opérations précédentes, émet un message d'erreur et quitte le bloc de code actuel 
en cas d'erreur. Si vous le déclarez dans le BEGIN ENDbloc d'une procédure stockée, il mettra immédiatement fin à la 
procédure stockée.
```
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SELECT 'An error has occurred, operation rollbacked and the stored procedure was terminated';
END;
```

Le gestionnaire suivant définit la valeur de la  RowNotFoundvariable sur 1 et poursuit l'exécution s'il n'y a plus de ligne 
à récupérer en cas de curseur ou d' SELECT INTOinstruction:
```
DECLARE CONTINUE HANDLER FOR NOT FOUND 
SET RowNotFound = 1;
```

Si une erreur de clé en double se produit, le gestionnaire suivant émet un message d'erreur et poursuit l'exécution
```
DECLARE CONTINUE HANDLER FOR 1062
SELECT 'Error, duplicate key occurred';
```

### Exemple de gestionnaire MySQL dans les procédures stockées

**Exemple :**

Créer une nouvelle table :
```
CREATE TABLE SupplierProducts (
    supplierId INT,
    productId INT,
    PRIMARY KEY (supplierId , productId)
);
```

Créez une procédure stockée :

```
CREATE PROCEDURE InsertSupplierProduct(IN inSupplierId INT, IN inProductId INT)
BEGIN
    -- quitter si la clé en double se produit
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
 	    SELECT CONCAT('Duplicate key (',inSupplierId,',',inProductId,') occurred') AS message;
    END;
    
    -- insérer une nouvelle ligne dans les produits des fournisseurs
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- retourner les produits fournis par l'identifiant du fournisseur
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;
    
END$$

DELIMITER ;
```

