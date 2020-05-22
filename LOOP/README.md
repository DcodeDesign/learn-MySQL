# WHILE / LOOP / REPEAT

## WHILE

```
[begin_label:] WHILE search_condition DO
        statement_list
END WHILE [end_label]
```

La liste d'instructions dans une WHILE instruction est répétée tant que search_condition expression est vraie. 
statement_list se compose d'une ou plusieurs instructions SQL, chacune terminée par un ; délimiteur d'instruction.

**Exemple :**
```
CREATE PROCEDURE while()
BEGIN
  DECLARE v1 INT DEFAULT 5;

  WHILE v1 > 0 DO
    ...
    SET v1 = v1 - 1;
  END WHILE;
END;
```

## Loop

```
[begin_label:] LOOP
    statement_list
END LOOP [end_label]
```

LOOP implémente une construction de boucle simple, permettant l'exécution répétée de la liste d'instructions, 
qui consiste en une ou plusieurs instructions, chacune terminée par un ; délimiteur. 
Les instructions dans la boucle sont répétées jusqu'à la fin de la boucle. 
Habituellement, cela est accompli avec une LEAVE déclaration. 
Dans une fonction stockée, RETURN peut également être utilisé, ce qui ferme la fonction entièrement.

Négliger d'inclure une instruction de terminaison de boucle entraîne une boucle infinie.

```
CREATE PROCEDURE doiterate(p1 INT)
BEGIN
  label1: LOOP
    SET p1 = p1 + 1;
    IF p1 < 10 THEN
      ITERATE label1;
    END IF;
    LEAVE label1;
  END LOOP label1;
  SET @x = p1;
END;
```

## REPEAT

```
[begin_label:] REPEAT
    statement_list
UNTIL search_condition
END REPEAT [end_label]
```

La liste d'instructions dans une REPEAT instruction est répétée jusqu'à ce que l' search_condition expression soit vraie. 
Ainsi, a REPEAT entre toujours dans la boucle au moins une fois. statement_list se compose d'une ou plusieurs instructions, 
chacune terminée par un ; délimiteur.

```
CREATE PROCEDURE dorepeat(p1 INT)
BEGIN
 SET @x = 0;
 REPEAT
   SET @x = @x + 1;
 UNTIL @x > p1 END REPEAT;
END
```