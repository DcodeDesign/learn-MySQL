# CURSOR

```
DECLARE cursor_name CURSOR FOR select_statement
```

Cette instruction déclare un curseur et l'associe à une SELECT instruction qui récupère les lignes à parcourir par le curseur. 
Pour récupérer les lignes ultérieurement, utilisez une FETCH instruction. Le nombre de colonnes récupérées par SELECT 
instruction doit correspondre au nombre de variables de sortie spécifiées dans FETCH instruction.

SELECT instruction ne peut pas contenir de INTO clause.

Les déclarations de curseur doivent apparaître avant les déclarations de gestionnaire et après les déclarations de 
variable et de condition.

Un programme stocké peut contenir plusieurs déclarations de curseur, mais chaque curseur déclaré dans un bloc donné doit 
avoir un nom unique.

Pour les informations disponibles via les SHOW instructions, il est possible dans de nombreux cas d'obtenir des informations 
équivalentes en utilisant un curseur avec une INFORMATION_SCHEMA table.