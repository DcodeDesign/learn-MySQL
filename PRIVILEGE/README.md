# GESTION DES PRIVILEGES

## CREATE USER

```
CREATE USER [name]@[hot] IDENTIFIED BY [name];
```

**Exemple:**
```
CREATE USER 'non-root'@'localhost' IDENTIFIED BY '123';
```

## ACCORDER DES PRIVILEGE

```
GRANT [permission type] ON [database name].[table name] TO ‘non-root’@'localhost’;
```

**[permission type]**

- CREATE – Permet aux utilisateurs de créer des bases de données/tableaux
- SELECT – Permet aux utilisateurs de récupérer des données
- INSERT – Permet aux utilisateurs d’ajouter de nouvelles entrées dans les tableaux
- UPDATE – Permet aux utilisateurs de modifier les entrées existantes dans les tableaux
- DELETE – Permet aux utilisateurs de supprimer les entrées de la tableau
- DROP – Permet aux utilisateurs de supprimer des bases de données/tableaux entiers

**Exemple :**
```
GRANT CREATE, SELECT ON * . * TO 'non-root'@'localhost';
```

## REVOQUER DES PRIVILEGES

```
REVOKE [permission type] ON [database name].[table name] FROM ‘non-root’@‘localhost’;
```
or
```
REVOKE ALL PRIVILEGES ON *.* FROM 'non-root'@'localhost';
```

## SUPPRIMER UN USER

```
DROP USER ‘non-root’@‘localhost’;
```

### ATTENTION

N’oubliez pas, pour exécuter l’une de ces commandes, vous devez avoir un accès root. 
De plus, assurez-vous d’exécuter FLUSH PRIVILEGES après toute modification 
apportée aux privilèges.
