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
