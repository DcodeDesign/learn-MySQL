# LES TRANSACTIONS

### autocommit, Commit, and Rollback

Dans InnoDB, toutes les activités des utilisateurs se produisent dans une transaction. 
Si le autocommitmode est activé, chaque instruction SQL forme à elle seule une transaction unique. 
Par défaut, MySQL démarre la session pour chaque nouvelle connexion avec autocommit activé, 
donc MySQL effectue une validation après chaque instruction SQL si cette instruction n'a pas renvoyé d'erreur. 
Si une instruction renvoie une erreur, le comportement de validation ou de restauration dépend de l'erreur. 


Une session qui a autocommit activé peut effectuer une transaction à instructions multiples en la commençant 
par une instruction explicite START TRANSACTION ou BEGIN et en la terminant par une instruction COMMIT ou ROLLBACK. 

Si le autocommitmode est désactivé dans une session avec SET autocommit = 0, la session a toujours une transaction ouverte. 
Une instruction COMMIT or ROLLBACK termine la transaction en cours et une nouvelle commence.

**Exemples :**

```
SET @@autocommit = 1;
START TRANSACTION; 
#se comporte comme si @@autocommit = 0
    > requete INSERT
    > requete UPDATE
    > requete SELECT
START TRANSACTION; 
#attention celui-ci fera le commit des requete ci-dessus, 
#c'est comme si @@autocommit = 1
    > requete INSERT
    > requete UPDATE
    > requete SELECT
```

```
START TRANSACTION;
    > requete INSERT
    > requete UPDATE
    > requete SELECT
SAVEPOINT sp1;
    > requete INSERT
    > requete UPDATE
SAVEPOINT sp1; ## écrase le premier savepoint
    > requete SELECT
    > requete INSERT
    > requete UPDATE
    > requete SELECT
ROLLBACK TO SAVEPOINT sp1;
RELEASE SAVEPOINT sp1; ## supprime un savepoint
COMMIT;
```

### Les propriétés ACID

**Atomicité, cohérence, isolation et durabilité sont un ensemble de propriétés 
qui garantissent qu'une transaction informatique est exécutée de façon fiable.**

**Atomicité**  (TOUT OU RIEN)

La propriété d'atomicité assure qu'une transaction se fait au complet ou pas 
du tout : si une partie d'une transaction ne peut être faite, il faut effacer 
toute trace de la transaction et remettre les données dans l'état où elles 
étaient avant la transaction.

**Coherence** (L'intégrité reférentielle)

La propriété de cohérence assure que chaque transaction amènera le système d'un 
état valide à un autre état valide. Tout changement à la base de données doit 
être valide selon toutes les règles définies, incluant mais non limitées 
aux contraintes d'intégrité, aux rollbacks en cascade, aux déclencheurs 
de base de données, et à toutes combinaisons d'événements.


**Isolation** (Verrou / lock)

Toute transaction doit s'exécuter comme si elle était la seule sur le système. 
Aucune dépendance possible entre les transactions. La propriété d'isolation 
assure que l'exécution simultanée de transactions produit le même état que 
celui qui serait obtenu par l'exécution en série des transactions. 
Chaque transaction doit s'exécuter en isolation totale : si T1 et T2 s'exécutent simultanément, alors chacune doit demeurer indépendante de l'autre.

**Durabilité** 

La propriété de durabilité assure que lorsqu'une transaction a été confirmée, 
elle demeure enregistrée même à la suite d'une panne d'électricité, d'une panne 
de l'ordinateur ou d'un autre problème. Par exemple, dans une base de données 
relationnelle, lorsqu'un groupe d'énoncés SQL a été exécuté, les résultats doivent 
être enregistrés de façon permanente, même dans le cas d'une panne immédiatement après 
l'exécution des énoncés.


### SAVEPOINT, ROLLBACK TO SAVEPOINT et RELEASE SAVEPOINT

```
SAVEPOINT identifier
ROLLBACK [WORK] TO [SAVEPOINT] identifier
RELEASE SAVEPOINT identifier
```

InnoDB prend en charge les instructions SQL SAVEPOINT, ROLLBACK TO SAVEPOINT, RELEASE SAVEPOINT et 
en option WORK mot - clé pour ROLLBACK.

**SAVEPOINT** instruction définit un point de sauvegarde de transaction nommé avec un nom de identifier. 
Si la transaction en cours a un point de sauvegarde du même nom, l'ancien point de sauvegarde est supprimé 
et un nouveau est défini.

**ROLLBACK TO SAVEPOINT** instruction annule une transaction vers le point de sauvegarde nommé sans mettre fin à la transaction. 
Les modifications que la transaction en cours a apportées aux lignes après la définition du point d'enregistrement sont 
annulées dans la restauration, mais InnoDBne libèrent pas les verrous de ligne qui ont été stockés en mémoire après le point d'enregistrement. 
(Pour une nouvelle ligne insérée, les informations de verrouillage sont portées par l'ID de transaction stocké dans la ligne; 
le verrou n'est pas stocké séparément dans la mémoire. Dans ce cas, le verrou de ligne est libéré lors de l'annulation.) 
Les points de sauvegarde qui ont été définis à un plus tard que le point de sauvegarde nommé sont supprimés.

Si **ROLLBACK TO SAVEPOINT** instruction renvoie l'erreur suivante, cela signifie qu'aucun point de sauvegarde avec le nom spécifié n'existe:

**RELEASE SAVEPOINT** instruction supprime le point de sauvegarde nommé de l'ensemble des points de sauvegarde de la transaction en cours. 
Aucune validation ou annulation ne se produit. Il s'agit d'une erreur si le point d'enregistrement n'existe pas.

Tous les points de sauvegarde de la transaction en cours sont supprimés si vous exécutez un COMMIT ou un ROLLBACK qui ne nomme pas un point de sauvegarde.

**Exemple :**

```
START TRANSACTION;
    > requete INSERT
    > requete UPDATE
    > requete SELECT
SAVEPOINT sp1;
    > requete INSERT
    > requete UPDATE
SAVEPOINT sp1; 
#écrase le premier savepoint
    > requete SELECT
    > requete INSERT
    > requete UPDATE
    > requete SELECT
ROLLBACK TO SAVEPOINT sp1;
RELEASE SAVEPOINT sp1; 
#supprime un savepoint
COMMIT;

```
