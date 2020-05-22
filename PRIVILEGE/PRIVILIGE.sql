# PRIVILEGE

# VIEW USER connected
SELECT USER();

# CREATE USER
CREATE USER 'non-root'@'localhost' IDENTIFIED BY '123';

# Accorder des privilèges
GRANT ALL PRIVILEGES ON * . * TO 'non-root'@'localhost';
FLUSH PRIVILEGES;

# Accorder des privilège spécifique
# GRANT [permission type] ON [database name].[table name] TO ‘non-root’@'localhost’;

/*
CREATE – Permet aux utilisateurs de créer des bases de données/tableaux
SELECT – Permet aux utilisateurs de récupérer des données
INSERT – Permet aux utilisateurs d’ajouter de nouvelles entrées dans les tableaux
UPDATE – Permet aux utilisateurs de modifier les entrées existantes dans les tableaux
DELETE – Permet aux utilisateurs de supprimer les entrées de la tableau
DROP – Permet aux utilisateurs de supprimer des bases de données/tableaux entiers
*/