# Cours SQL complet — MySQL et PostgreSQL

> **Public:** débutant complet · **fil rouge:** gestion d’une bibliothèque · **versions ciblées:** MySQL 8+ et PostgreSQL 15+

## Comment utiliser ce cours

SQL est le langage qui permet de demander et de modifier des données. Un **SGBD** (système de gestion de base de données) exécute ces demandes, garantit la cohérence et contrôle les accès. Copiez chaque bloc dans le moteur indiqué, dans cet ordre. Les mots-clés sont en majuscules et les noms en `snake_case`.

### Règles de sécurité dès le départ

- Ne concaténez jamais une saisie utilisateur dans une requête : utilisez des paramètres (`?` en MySQL, `$1` en PostgreSQL).
- En production, utilisez un compte applicatif limité, jamais `root` ou `postgres`.
- Faites une sauvegarde avant `UPDATE`, `DELETE`, `DROP` ou migration.

---

## Module 1 — Comprendre le modèle relationnel

### Ce que tu vas apprendre
- distinguer base, table, ligne, colonne et schéma ;
- relier des tables avec une clé primaire et une clé étrangère ;
- choisir entre SQL et NoSQL.

Une base est comme un classeur : une **table** est une feuille, une **ligne** une fiche, une **colonne** un champ. Une **clé primaire (PK)** identifie une fiche une seule fois ; une **clé étrangère (FK)** contient la PK d’une autre table.

```text
auteurs (1) ───────< (N) livres (N) >───────< categories
                         |
                         v
                    emprunts >──── membres
```

Une base relationnelle convient lorsque les données ont des relations et doivent rester cohérentes. Un document NoSQL convient davantage à des données très variables ou distribuées. MySQL est très utilisé pour les applications web ; PostgreSQL offre un SQL riche, des types avancés et une extensibilité importante.

### Syntaxe et mini-exemple

```sql
CREATE TABLE auteurs (id INTEGER PRIMARY KEY, nom VARCHAR(100) NOT NULL);
CREATE TABLE livres (
    id INTEGER PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    auteur_id INTEGER NOT NULL REFERENCES auteurs(id)
);
```

La syntaxe de relation est commune. L’auto-incrémentation diffère :

| Besoin | MySQL | PostgreSQL |
|---|---|---|
| identifiant | `INT AUTO_INCREMENT PRIMARY KEY` | `INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY` |

**Mini-projet :** dessinez les tables `auteurs`, `livres`, `membres`, `emprunts` et leurs flèches FK.

### Erreurs courantes

| Erreur | Cause | Correction |
|---|---|---|
| `Unknown table` / `relation does not exist` | table absente ou mauvais schéma | créer la table, vérifier le nom |
| FK refusée | ligne parent inexistante | insérer l’auteur avant le livre |

### Quiz
1. Pourquoi une PK doit-elle être unique ? 2. Que représente une FK ? 3. Quand une base relationnelle est-elle préférable ?

### Ce que tu sais maintenant
Tu sais modéliser des fiches reliées et expliquer le rôle d’un SGBD. **Transition :** installons les outils.

---

## Module 2 — Installation et premiers pas

### Ce que tu vas apprendre
- installer et se connecter aux deux moteurs ;
- créer une base et naviguer dans un terminal ;
- utiliser DBeaver, outil graphique commun.

```bash
# Ubuntu/Debian
sudo apt install mysql-server postgresql
mysql -u root -p
psql -U postgres
```

| Action | MySQL | PostgreSQL |
|---|---|---|
| créer une base | `CREATE DATABASE bibliotheque;` | `CREATE DATABASE bibliotheque;` |
| choisir | `USE bibliotheque;` | `\c bibliotheque` |
| tables | `SHOW TABLES;` | `\dt` |
| décrire | `DESCRIBE livres;` | `\d livres` |
| quitter | `EXIT;` | `\q` |

**Mini-projet :** créez `bibliotheque` sur les deux moteurs et connectez-vous avec DBeaver.

### Erreurs courantes
`Access denied` signifie identifiants insuffisants : vérifiez l’utilisateur, le mot de passe et le service. `database does not exist` signifie qu’il faut exécuter `CREATE DATABASE` puis se reconnecter.

### Quiz
Quel outil est commun aux deux moteurs ? Quelle commande PostgreSQL change de base ? Pourquoi ne pas travailler en super-utilisateur ?

### Ce que tu sais maintenant
Tu peux créer une base et l’explorer. **Transition :** choisissons les types de colonnes.

---

## Module 3 — Types de données

### Ce que tu vas apprendre
Choisir un type adapté économise de l’espace et empêche des valeurs invalides.

| Usage | MySQL | PostgreSQL |
|---|---|---|
| entier | `INT` | `INTEGER` |
| argent exact | `DECIMAL(10,2)` | `NUMERIC(10,2)` |
| texte | `VARCHAR(200)` ou `TEXT` | `VARCHAR(200)` ou `TEXT` |
| date | `DATE` | `DATE` |
| date-heure | `DATETIME` | `TIMESTAMP` |
| booléen | `BOOLEAN` (alias TINYINT) | `BOOLEAN` |
| JSON | `JSON` | `JSONB` |

N’utilisez pas un flottant pour l’argent : `0.1 + 0.2` peut être imprécis. Utilisez `NUMERIC`/`DECIMAL`. `NULL` signifie « inconnu/absent », pas zéro ni chaîne vide.

```sql
CREATE TABLE membres (
    id INTEGER PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    actif BOOLEAN NOT NULL DEFAULT TRUE,
    inscrit_le DATE NOT NULL
);
```

**Mini-projet :** justifiez le type de chaque colonne des quatre tables de la bibliothèque.

### Erreurs courantes
| Erreur | Cause | Correction |
|---|---|---|
| date invalide | format incohérent | utiliser `YYYY-MM-DD` |
| `= NULL` ne renvoie rien | NULL n’est pas une valeur comparable | `IS NULL` |

### Quiz
Pourquoi `DECIMAL` pour un prix ? Quelle différence entre NULL et 0 ? Quel type pour une date de naissance ?

### Ce que tu sais maintenant
Tu sais définir des colonnes fiables. **Transition :** créons les tables.

---

## Module 4 — DDL : créer une structure

### Ce que tu vas apprendre
Utiliser `CREATE TABLE`, contraintes, modifications et suppressions contrôlées.

```sql
-- MySQL
CREATE TABLE auteurs (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nom VARCHAR(100) NOT NULL,
 email VARCHAR(255) UNIQUE,
 cree_le DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- PostgreSQL
CREATE TABLE auteurs (
 id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 nom VARCHAR(100) NOT NULL,
 email VARCHAR(255) UNIQUE,
 cree_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

`NOT NULL` interdit l’absence ; `UNIQUE` interdit les doublons ; `CHECK` valide une condition ; `DEFAULT` fournit une valeur. Créez les parents avant les enfants. Utilisez `ON DELETE RESTRICT` par défaut et `CASCADE` seulement si la suppression en chaîne est voulue.

```sql
CREATE TABLE livres (
 id INTEGER PRIMARY KEY,
 titre VARCHAR(200) NOT NULL,
 auteur_id INTEGER NOT NULL,
 annee SMALLINT CHECK (annee > 0),
 FOREIGN KEY (auteur_id) REFERENCES auteurs(id)
);
ALTER TABLE livres ADD COLUMN isbn VARCHAR(17) UNIQUE;
```

**Mini-projet :** créez les tables du fichier `sql/schema_postgresql.sql` et leur équivalent MySQL.

### Erreurs courantes
`Duplicate key` : violation de `UNIQUE`. `Cannot add foreign key` : type différent ou parent absent. `DROP TABLE` détruit la structure et les données : demandez confirmation et sauvegardez.

### Quiz
À quoi sert `CHECK` ? Que fait `TRUNCATE` ? Dans quel ordre créer les tables ?

### Ce que tu sais maintenant
Tu peux construire une structure protégée. **Transition :** ajoutons des données.

---

## Module 5 — INSERT et données de test

### Ce que tu vas apprendre
Insérer une ligne, plusieurs lignes et récupérer un identifiant.

```sql
INSERT INTO auteurs (nom, email) VALUES ('Camus', 'camus@example.org');
INSERT INTO auteurs (nom) VALUES ('Saint-Exupéry'), ('Maalouf');
```

Pour récupérer l’ID :

```sql
-- MySQL
INSERT INTO auteurs (nom) VALUES ('Duras');
SELECT LAST_INSERT_ID();

-- PostgreSQL
INSERT INTO auteurs (nom) VALUES ('Duras') RETURNING id;
```

UPSERT : `INSERT ... ON DUPLICATE KEY UPDATE` en MySQL ; `INSERT ... ON CONFLICT (email) DO UPDATE SET nom = EXCLUDED.nom` en PostgreSQL. Listez toujours les colonnes.

**Mini-projet :** insérez 10 auteurs, 20 livres et 15 membres avec les scripts du dossier `sql/seed`.

### Erreurs courantes
Une FK inconnue doit être insérée d’abord dans la table parent. Un `INSERT` sans liste de colonnes casse quand la structure évolue. Ne désactivez pas les contraintes pour masquer une erreur.

### Quiz
Pourquoi lister les colonnes ? À quoi sert `RETURNING` ? Qu’est-ce qu’un UPSERT ?

### Ce que tu sais maintenant
Tu sais peupler proprement une base. **Transition :** interrogeons-la.

---

## Module 6 — SELECT, filtrage et tri

### Ce que tu vas apprendre

```sql
SELECT l.titre, a.nom AS auteur
FROM livres AS l
JOIN auteurs AS a ON a.id = l.auteur_id
WHERE l.annee >= 2000
ORDER BY l.titre ASC
LIMIT 10 OFFSET 0;
```

Ordre logique : `FROM` → `WHERE` → `SELECT` → `ORDER BY` → `LIMIT`. Utilisez `IN`, `BETWEEN`, `LIKE`, `IS NULL`, `AND`, `OR` et des parenthèses. PostgreSQL propose `ILIKE`; en MySQL la casse dépend de la collation. Préférez les colonnes explicites à `SELECT *` en application.

**Mini-projet :** écrivez 10 recherches : livres d’un auteur, livres sans ISBN, membres actifs, titres commençant par `Le`, trois derniers inscrits.

### Erreurs courantes
`= NULL` est faux ; utilisez `IS NULL`. `OR` sans parenthèses élargit souvent trop le résultat. `LIMIT` sans `ORDER BY` ne garantit pas les mêmes lignes.

### Quiz
Que fait `DISTINCT` ? Différence entre `WHERE` et `ORDER BY` ? Pourquoi qualifier `l.titre` ?

### Ce que tu sais maintenant
Tu sais rechercher et paginer les lignes. **Transition :** résumons les résultats.

---

## Module 7 — Fonctions et agrégations

### Ce que tu vas apprendre
Compter, sommer, grouper et filtrer des groupes.

```sql
SELECT a.nom, COUNT(l.id) AS nombre_livres
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.id, a.nom
HAVING COUNT(l.id) >= 2
ORDER BY nombre_livres DESC;
```

`COUNT(*)` compte les lignes ; `COUNT(colonne)` ignore les NULL. `SUM`, `AVG`, `MIN`, `MAX` agrègent. `WHERE` filtre avant le regroupement, `HAVING` après. `COALESCE(valeur, 0)` remplace NULL.

| Besoin | MySQL | PostgreSQL |
|---|---|---|
| concaténer | `GROUP_CONCAT(titre)` | `STRING_AGG(titre, ', ')` |
| année | `YEAR(date_emprunt)` | `EXTRACT(YEAR FROM date_emprunt)` |

**Mini-projet :** rapport mensuel des emprunts, top 5 des auteurs et moyenne d’emprunts par membre.

### Quiz
Pourquoi grouper toutes les colonnes non agrégées ? Quand utiliser HAVING ? Que compte `COUNT(col)` ?

### Ce que tu sais maintenant
Tu sais produire des indicateurs. **Transition :** relions plusieurs tables.

---

## Module 8 — JOIN et sous-requêtes

### Ce que tu vas apprendre
`INNER JOIN` garde les correspondances ; `LEFT JOIN` garde aussi les lignes sans correspondance ; un `CROSS JOIN` produit toutes les combinaisons. Toujours écrire la condition `ON`.

```sql
SELECT m.nom, l.titre, e.date_emprunt
FROM emprunts e
JOIN membres m ON m.id = e.membre_id
JOIN livres l ON l.id = e.livre_id
WHERE e.date_retour IS NULL;
```

Pour « les livres jamais empruntés », utilisez `NOT EXISTS` plutôt qu’une comparaison fragile à NULL :

```sql
SELECT l.titre FROM livres l
WHERE NOT EXISTS (SELECT 1 FROM emprunts e WHERE e.livre_id = l.id);
```

**Mini-projet :** rapport complet des emprunts en cours et liste des membres n’ayant jamais emprunté.

### Erreurs courantes
Un JOIN sans `ON` multiplie les lignes. Une condition de table gauche dans `WHERE` peut transformer un `LEFT JOIN` en `INNER JOIN`. Vérifiez les cardinalités.

### Quiz
Différence INNER/LEFT ? Pourquoi EXISTS ? Comment éviter les doublons ?

### Ce que tu sais maintenant
Tu sais lire un modèle relationnel. **Transition :** modifions et supprimons sans danger.

---

## Module 9 — UPDATE, DELETE et transactions

### Ce que tu vas apprendre

```sql
UPDATE membres SET actif = FALSE WHERE id = 7;
DELETE FROM emprunts WHERE id = 42;
```

Toujours exécuter d’abord le `SELECT` avec le même `WHERE`. Une **transaction** est un groupe atomique : tout réussit ou tout est annulé.

```sql
BEGIN;
UPDATE livres SET disponible = FALSE WHERE id = 3 AND disponible = TRUE;
INSERT INTO emprunts (livre_id, membre_id, date_emprunt)
VALUES (3, 7, CURRENT_DATE);
COMMIT; -- ou ROLLBACK en cas d’erreur
```

Isolation, cohérence, atomicité et durabilité forment les propriétés ACID. MySQL exige un moteur transactionnel comme InnoDB.

**Mini-projet :** implémentez « emprunter un livre » dans une transaction, en refusant un livre déjà emprunté.

### Quiz
Pourquoi un WHERE est-il obligatoire ? Que fait ROLLBACK ? Que garantit l’atomicité ?

### Ce que tu sais maintenant
Tu peux modifier des données sans opération partielle. **Transition :** rendons les recherches rapides.

---

## Module 10 — Index et EXPLAIN

### Ce que tu vas apprendre
Un index est l’index d’un livre : recherche rapide, mais coût en espace et en écriture.

```sql
CREATE INDEX idx_livres_auteur ON livres (auteur_id);
CREATE INDEX idx_emprunts_membre_date ON emprunts (membre_id, date_emprunt);
EXPLAIN ANALYZE SELECT * FROM livres WHERE auteur_id = 2;
```

| MySQL | PostgreSQL |
|---|---|
| `EXPLAIN ANALYZE SELECT ...` | `EXPLAIN (ANALYZE, BUFFERS) SELECT ...` |

Lisez le plan : scan séquentiel, scan d’index, estimations, coût et lignes réelles. Un index ne sert pas toujours pour une petite table, une expression non indexée ou un motif `%mot`.

**Mini-projet :** mesurez avant/après un index sur `emprunts.date_retour` et conservez seulement l’index utile.

### Quiz
Pourquoi trop d’index ralentissent-ils les INSERT ? Qu’est-ce qu’un plan ? Pourquoi `LIKE '%x'` est difficile à indexer ?

### Ce que tu sais maintenant
Tu sais diagnostiquer une requête simple. **Transition :** modélisons correctement.

---

## Module 11 — Normalisation et relations N:N

### Ce que tu vas apprendre
1NF : une cellule, une valeur. 2NF : chaque colonne dépend de toute la clé. 3NF : aucune dépendance entre colonnes non-clés. Une relation plusieurs-à-plusieurs exige une table de liaison.

```sql
CREATE TABLE categories (id INTEGER PRIMARY KEY, nom VARCHAR(80) UNIQUE NOT NULL);
CREATE TABLE livres_categories (
 livre_id INTEGER REFERENCES livres(id) ON DELETE CASCADE,
 categorie_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
 PRIMARY KEY (livre_id, categorie_id)
);
```

**Mini-projet :** ajoutez catégories et étiquetez 10 livres. Ne stockez pas `"roman, historique"` dans une colonne.

### Quiz
Pourquoi une table de liaison ? Que corrige la 1NF ? Quand dénormaliser ?

### Ce que tu sais maintenant
Tu sais éviter les doublons structurels. **Transition :** encapsulons les requêtes.

---

## Module 12 — Vues, fonctions et triggers

### Ce que tu vas apprendre
Une vue est une requête nommée, pas forcément une copie des données.

```sql
CREATE VIEW emprunts_en_cours AS
SELECT m.nom, l.titre, e.date_emprunt
FROM emprunts e JOIN membres m ON m.id=e.membre_id JOIN livres l ON l.id=e.livre_id
WHERE e.date_retour IS NULL;
```

Les fonctions servent à réutiliser une logique ; les triggers exécutent automatiquement une action. Utilisez-les avec parcimonie : une règle invisible est difficile à déboguer. PostgreSQL nécessite une fonction trigger ; MySQL peut utiliser `NEW.colonne` directement dans le trigger.

**Mini-projet :** créez une vue des retards et un trigger qui renseigne `modifie_le`.

### Quiz
Une vue stocke-t-elle toujours les lignes ? Quand éviter un trigger ?

### Ce que tu sais maintenant
Tu sais réutiliser et centraliser une logique SQL. **Transition :** protégeons-la.

---

## Module 13 — Sécurité

### Ce que tu vas apprendre
Une injection survient quand une saisie devient du SQL. Ne faites jamais : `"... WHERE nom = '" + input + "'"`.

```sql
-- PostgreSQL
CREATE ROLE bibliothecaire LOGIN PASSWORD 'à-remplacer-par-un-secret';
GRANT SELECT, INSERT, UPDATE ON livres TO bibliothecaire;
REVOKE DELETE ON livres FROM bibliothecaire;
```

En MySQL, utilisez `CREATE USER 'bibliothecaire'@'localhost' IDENTIFIED BY '...'` puis `GRANT ... ON bibliotheque.livres`. Dans le code applicatif : `WHERE email = ?` (MySQL) ou `WHERE email = $1` (PostgreSQL). Les secrets ne doivent jamais être commités.

**Mini-projet :** créez les rôles admin, bibliothécaire et lecteur avec le moindre privilège.

### Quiz
Qu’est-ce qu’une requête préparée ? Pourquoi limiter DELETE ? Où stocker un mot de passe ?

### Ce que tu sais maintenant
Tu sais réduire le risque d’injection et d’accès excessif. **Transition :** exploitons les fonctions avancées.

---

## Module 14 — JSON, recherche et fonctions fenêtre

### Ce que tu vas apprendre
PostgreSQL préfère `JSONB` indexable ; MySQL possède un type `JSON`.

```sql
-- PostgreSQL
SELECT metadata->>'langue' FROM livres_meta
WHERE metadata @> '{"langue":"fr"}'::jsonb;
-- Classement sans perdre les lignes
SELECT membre_id, COUNT(*) AS total,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS classement
FROM emprunts GROUP BY membre_id;
```

MySQL utilise notamment `JSON_EXTRACT(metadata, '$.langue')`. Pour le plein texte : `FULLTEXT` + `MATCH ... AGAINST` en MySQL ; `to_tsvector(...) @@ plainto_tsquery(...)` en PostgreSQL.

**Mini-projet :** ajoutez des métadonnées JSON et classez les membres par activité.

### Quiz
Pourquoi JSONB ? Que fait `RANK` ? Différence entre `GROUP BY` et une fenêtre ?

### Ce que tu sais maintenant
Tu sais traiter des données semi-structurées et analytiques. **Transition :** sauvegardons.

---

## Module 15 — Sauvegarde, restauration et maintenance

### Ce que tu vas apprendre

```bash
mysqldump -u root -p bibliotheque > backup.sql
mysql -u root -p bibliotheque < backup.sql
pg_dump -Fc bibliotheque > backup.dump
pg_restore -d bibliotheque backup.dump
```

Une sauvegarde non testée n’est pas une sauvegarde. Planifiez, chiffrez et testez régulièrement la restauration. MySQL propose `ANALYZE TABLE`; PostgreSQL `VACUUM (ANALYZE)`. Ne lancez pas `VACUUM FULL` sans comprendre son verrouillage.

**Mini-projet :** script quotidien avec date dans le nom, rétention de 7 jours et journal d’erreur.

### Quiz
Différence logique/physique ? Pourquoi tester une restauration ? À quoi sert ANALYZE ?

### Ce que tu sais maintenant
Tu sais prévoir la perte et maintenir les statistiques. **Transition :** versionnons le schéma.

---

## Module 16 — Migrations

### Ce que tu vas apprendre
Une migration est une version reproductible de la structure, comme Git pour la base. Convention : `001_create_auteurs.sql`, `002_add_isbn.sql`.

Pour un changement sans interruption : ajouter nullable → déployer le code → remplir par lots → ajouter la contrainte. Évitez de renommer ou supprimer immédiatement une colonne utilisée par une ancienne version.

**Mini-projet :** écrivez six migrations correspondant au dossier `sql/migrations`, chacune testée sur une base vide et une base existante.

### Quiz
Pourquoi une migration doit-elle être rejouable ? Qu’est-ce qu’un rollback ? Pourquoi déployer en étapes ?

### Ce que tu sais maintenant
Tu sais faire évoluer une structure sans improvisation. **Transition :** optimisons en production.

---

## Module 17 — Production et optimisation

### Ce que tu vas apprendre
Mesurez avant d’optimiser. Activez le slow query log MySQL ou `pg_stat_statements` PostgreSQL, puis utilisez `EXPLAIN ANALYZE`.

Bonnes pratiques : colonnes explicites, `EXISTS` pour une présence, pagination par curseur (`WHERE id > :dernier_id`) plutôt que grands `OFFSET`, insertions par lots et pool de connexions. Surveillez temps, verrous, taille et taux d’erreur. Les réglages comme `shared_buffers` ou `innodb_buffer_pool_size` dépendent de la machine : ne copiez pas une valeur aveuglément.

**Mini-projet :** auditez cinq requêtes lentes et documentez la mesure avant/après.

### Quiz
Pourquoi mesurer ? Quand préférer keyset pagination ? Quel est le risque d’un pool trop grand ?

### Ce que tu sais maintenant
Tu sais passer d’une requête correcte à une requête observable et maintenable. **Transition :** réalisons le projet final.

---

## Module 18 — Projet final et corrigé

### Ce que tu vas construire
Une bibliothèque complète : auteurs, livres, membres, emprunts, catégories, contraintes, index, vue, données, rapports, sauvegarde et documentation.

### Critères d’acceptation
- un emprunt impossible si le livre est déjà sorti ;
- retour atomique et date contrôlée ;
- rapport des retards, livres populaires et membres actifs ;
- aucune requête concaténant une saisie ;
- `EXPLAIN ANALYZE` joint pour les cinq rapports ;
- sauvegarde restaurée avec succès sur MySQL et PostgreSQL.

### Requête de rapport finale

```sql
SELECT l.titre, COUNT(e.id) AS nombre_emprunts,
       MAX(e.date_emprunt) AS dernier_emprunt
FROM livres l
LEFT JOIN emprunts e ON e.livre_id = l.id
GROUP BY l.id, l.titre
ORDER BY nombre_emprunts DESC, l.titre
LIMIT 10;
```

**Solution :** utilisez `sql/schema_mysql.sql` ou `sql/schema_postgresql.sql`, puis le seed correspondant. Documentez chaque différence de dialecte dans `sql/README.md`.

### Quiz final
1. Expliquez PK, FK et index. 2. Écrivez une transaction d’emprunt. 3. Montrez comment prévenir une injection.

### Ce que tu sais maintenant
Tu sais concevoir, interroger, sécuriser, optimiser, sauvegarder et faire évoluer une base relationnelle dans les deux moteurs.

---

## Aide-mémoire

```sql
SELECT ... FROM ... WHERE ... GROUP BY ... HAVING ... ORDER BY ... LIMIT ...;
INSERT INTO table (col1, col2) VALUES (..., ...);
UPDATE table SET col = valeur WHERE id = ...;
DELETE FROM table WHERE id = ...;
BEGIN; ... COMMIT; -- ou ROLLBACK
```

**Checklist avant mise en production :** contraintes vérifiées · paramètres liés · compte moindre privilège · index justifiés par un plan · sauvegarde restaurée · migrations testées · logs et alertes actifs.
