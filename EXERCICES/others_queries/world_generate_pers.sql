USE World;
DROP PROCEDURE IF EXISTS InsertPers;

DELIMITER |
CREATE PROCEDURE InsertPers(IN nbrRand INT )
  BEGIN
    DECLARE _i INT;
    DECLARE _nom VARCHAR(100) DEFAULT '';
    DECLARE _prenom VARCHAR(100) DEFAULT '';
    DECLARE _sex VARCHAR(100) DEFAULT '';
    DECLARE _FK_pays INT;

    SET _i = 1;

    WHILE (_i <= nbrRand) DO

      SET _nom = ELT(FLOOR(1 + (RAND() * (100 - 1))), "James", "Mary", "John", "Patricia", "Robert", "Linda", "Michael",
               "Barbara", "William", "Elizabeth", "David", "Jennifer", "Richard", "Maria", "Charles", "Susan", "Joseph",
               "Margaret", "Thomas", "Dorothy", "Christopher", "Lisa", "Daniel", "Nancy", "Paul", "Karen", "Mark",
               "Betty", "Donald", "Helen", "George", "Sandra", "Kenneth", "Donna", "Steven", "Carol", "Edward", "Ruth",
               "Brian", "Sharon", "Ronald", "Michelle", "Anthony", "Laura", "Kevin", "Sarah", "Jason", "Kimberly",
               "Matthew", "Deborah", "Gary", "Jessica", "Timothy", "Shirley", "Jose", "Cynthia", "Larry", "Angela",
               "Jeffrey", "Melissa", "Frank", "Brenda", "Scott", "Amy", "Eric", "Anna", "Stephen", "Rebecca", "Andrew",
               "Virginia", "Raymond", "Kathleen", "Gregory", "Pamela", "Joshua", "Martha", "Jerry", "Debra", "Dennis",
               "Amanda", "Walter", "Stephanie", "Patrick", "Carolyn", "Peter", "Christine", "Harold", "Marie",
               "Douglas", "Janet", "Henry", "Catherine", "Carl", "Frances", "Arthur", "Ann", "Ryan", "Joyce", "Roger",
               "Diane");

      SET _prenom = ELT(FLOOR(1 + (RAND() * (100 - 1))), "Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller",
               "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson",
               "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen",
               "Young", "Hernandez", "King", "Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez",
               "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans",
               "Edwards", "Collins", "Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell",
               "Murphy", "Bailey", "Rivera", "Cooper", "Richardson", "Cox", "Howard", "Ward", "Torres", "Peterson",
               "Gray", "Ramirez", "James", "Watson", "Brooks", "Kelly", "Sanders", "Price", "Bennett", "Wood", "Barnes",
               "Ross", "Henderson", "Coleman", "Jenkins", "Perry", "Powell", "Long", "Patterson", "Hughes", "Flores",
               "Washington", "Butler", "Simmons", "Foster", "Gonzales", "Bryant", "Alexander", "Russell", "Griffin",
               "Diaz", "Hayes");

      SET _sex = ELT(FLOOR(1 + (RAND() * (3 - 0))), "M", "F", "A");

      SET _FK_pays = FLOOR(RAND()*(8-1+1)+1);

      INSERT INTO personne (nom_pers, prenom_pers, sexe_pers, FK_pays)
      VALUES (_nom, _prenom, _sex, _FK_pays);


      SET _i = _i + 1;
    end while;

    -- SELECT _txt AS Impair;

  end |
DELIMITER ;

CALL InsertPers(10);
