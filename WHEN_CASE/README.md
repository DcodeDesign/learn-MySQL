# WHEN CASE

```
CASE case_value
    WHEN when_value THEN statement_list
    [WHEN when_value THEN statement_list] ...
    [ELSE statement_list]
END CASE
```

or

```
CASE
    WHEN search_condition THEN statement_list
    [WHEN search_condition THEN statement_list] ...
    [ELSE statement_list]
END CASE
```

Pour la première syntaxe, case_value est une expression. Cette valeur est comparée à when_value expression de chaque WHEN 
clause jusqu'à ce que l'une d'entre elles soit égale. Lorsqu'un égal when_value est trouvé, la THEN clause correspondante 
statement_lists exécute. Si no when_value est égal, la ELSE clause statement_lists exécute, s'il y en a une.

Cette syntaxe ne peut pas être utilisée pour tester l'égalité avec NULL car NULL = NULL est faux. 

Pour la deuxième syntaxe, chaque expression de WHEN clause search_condition est évaluée jusqu'à ce qu'une soit vraie, 
auquel point sa THEN clause correspondante statement_lists exécute. Si no search_condition est égal, la ELSE clause 
statement_lists'exécute, s'il y en a une.

Si non when_value ou search_condition correspond à la valeur testée et que CASE instruction ne contient aucune ELSE clause, 
un cas est introuvable pour l'erreur de l' instruction CASE.

Chacun se statement_list compose d'une ou plusieurs instructions SQL; un vide statement_list n'est pas autorisé.