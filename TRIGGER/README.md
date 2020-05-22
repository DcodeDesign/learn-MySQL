# TRIGGER

Pour créer un déclencheur ou supprimer un déclencheur, utilisez l' instruction CREATE TRIGGER or DROP TRIGGER.

```
DELIMITER |
CREATE TRIGGER [nom_trigger] [moment_trigger] [evenement_trigger]
ON [nom_table] FOR EACH ROW
BEGIN
   -- Instructions
END |
DELIMITER ;
```

- [CREATE TRIGGER] [nom_trigger]  : les triggers ont donc un nom.

- [moment_trigger] [evenement_trigger]  : servent à définir quand et comment le trigger est déclenché.

- ON [nom_table]  : c'est là que l'on définit à quelle table le trigger est attaché.

- FOR EACH ROW  : signifie littéralement "pour chaque ligne", sous-entendu "pour chaque ligne insérée/supprimée/modifiée" selon ce qui a déclenché le trigger.

- [corps_trigger]  : c'est le contenu du trigger. Comme pour les procédures stockées, il peut s'agir soit d'une seule instruction, soit d'un bloc d'instructions.

## OLD et NEW
Dans le corps du trigger, MySQL met à disposition deux mots-clés : **OLD  et NEW**.

**OLD**  représente les valeurs des colonnes de la ligne traitée avant qu'elle ne soit modifiée par l'événement déclencheur. **Ces valeurs peuvent être lues, mais pas modifiées**.

**NEW**  représente les valeurs des colonnes de la ligne traitée après qu'elle a été modifiée par l'événement déclencheur. **Ces valeurs peuvent être lues et modifiées**.

## Suppression des triggers
```
DROP TRIGGER [nom_trigger];

```

### Exemples :
```
-- Trigger déclenché par l'insertion
DELIMITER |
    CREATE TRIGGER before_insert_animal BEFORE INSERT
    ON Animal FOR EACH ROW
    BEGIN
        -- Instructions
END |

-- Trigger déclenché par la modification
CREATE TRIGGER before_update_animal BEFORE UPDATE
ON Animal FOR EACH ROW
    BEGIN
        -- Instructions
END |
DELIMITER ;
```