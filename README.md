# SQL_COURS

Le cours complet est disponible dans [`docs/COURS_SQL_COMPLET.md`](docs/COURS_SQL_COMPLET.md).

Les scripts exécutables MySQL et PostgreSQL sont dans [`sql/`](sql/). Le reste de ce fichier contient le cahier des charges original.

---

# PROMPT — Cours SQL Complet (MySQL & PostgreSQL) : Du Zero au Mini-Expert

Tu es un formateur expert en bases de donnees relationnelles, MySQL et PostgreSQL. Tu dois creer un cours **complet, progressif et structure en modules** pour un developpeur debutant qui ne connait **absolument rien** de SQL ni des bases de donnees. Chaque concept doit etre explique clairement, avec des analogies simples, des schemas ASCII, des requetes fonctionnelles et un mini-projet pratique par module.

**Important** : chaque fois qu'une syntaxe differe entre MySQL et PostgreSQL, montre les **deux versions cote a cote** avec un encadre comparatif.

---

## REGLES PEDAGOGIQUES

- **Aucun prerequis SQL** : explique chaque terme comme si c'etait la premiere fois (table, colonne, cle primaire, jointure, index, transaction, etc.)
- **Chaque module est autonome** : on peut le relire seul et comprendre
- **Chaque concept** : 1) Explication simple avec analogie -> 2) Schema ASCII quand pertinent -> 3) Syntaxe detaillee (MySQL ET PostgreSQL) -> 4) Exemple de requete commentee -> 5) Mini-exercice pratique
- **Montre les erreurs courantes** : erreurs de syntaxe, erreurs logiques, pieges de performance
- **Bonnes pratiques des le depart** : nommage, normalisation, securite (injections SQL), performance
- **Un mini-projet fil rouge** qui evolue a chaque module : un **systeme de gestion de bibliotheque** (livres, auteurs, emprunts, membres)
- **Comparaison MySQL vs PostgreSQL** systematique quand les differences sont significatives

---

## STRUCTURE DES MODULES

### MODULE 1 — Comprendre les Bases de Donnees Relationnelles
- Qu'est-ce qu'une base de donnees ? (analogie : un classeur avec des feuilles de calcul reliees entre elles)
- Base de donnees relationnelle vs non-relationnelle (SQL vs NoSQL) : quand choisir quoi
- Vocabulaire fondamental :
  - **Table** = une feuille de calcul (lignes et colonnes)
  - **Ligne (row/tuple)** = un enregistrement (une fiche)
  - **Colonne (column/attribut)** = un champ (nom, age, email)
  - **Cle primaire (PRIMARY KEY)** = le numero unique d'identification
  - **Cle etrangere (FOREIGN KEY)** = le lien entre deux tables
  - **Schema** = la structure de la base (toutes les tables et leurs relations)
- Schema ASCII d'une relation :
```
Table: livres                    Table: auteurs
┌────┬──────────────┬──────────┐ ┌────┬─────────────┐
│ id │ titre        │auteur_id │ │ id │ nom         │
├────┼──────────────┼──────────┤ ├────┼─────────────┤
│  1 │ Le Petit...  │    1     │──│  1 │ Saint-Ex    │
│  2 │ L'Etranger   │    2     │──│  2 │ Camus       │
│  3 │ La Peste     │    2     │──│    │             │
└────┴──────────────┴──────────┘ └────┴─────────────┘
        auteur_id = FK ──────────── id = PK
```
- MySQL vs PostgreSQL : presentation, histoire, forces de chacun
  - **MySQL** : populaire, simple, web (WordPress, PHP), appartient a Oracle
  - **PostgreSQL** : robuste, conforme SQL, extensible, open source pur, types avances
- SGBD (Systeme de Gestion de Base de Donnees) : le logiciel qui gere tout
- Le langage SQL : DDL, DML, DCL, TCL — les 4 familles de commandes
- **Mini-projet** : dessiner le schema de la base bibliotheque (tables, colonnes, relations)

### MODULE 2 — Installation et Premiers Pas
- Installer MySQL :
  - Linux : `sudo apt install mysql-server`
  - Windows : MySQL Installer
  - Mac : `brew install mysql`
  - Demarrer le service, se connecter : `mysql -u root -p`
- Installer PostgreSQL :
  - Linux : `sudo apt install postgresql`
  - Windows : installer depuis postgresql.org
  - Mac : `brew install postgresql`
  - Se connecter : `psql -U postgres`
- Outils graphiques : DBeaver (les deux), MySQL Workbench, pgAdmin
- Commandes de base pour naviguer :

| Action | MySQL | PostgreSQL |
|---|---|---|
| Lister les bases | `SHOW DATABASES;` | `\l` |
| Utiliser une base | `USE nom_base;` | `\c nom_base` |
| Lister les tables | `SHOW TABLES;` | `\dt` |
| Decrire une table | `DESCRIBE table;` | `\d table` |
| Quitter | `EXIT;` | `\q` |

- Creer une base de donnees : `CREATE DATABASE bibliotheque;`
- Jeux de caracteres : `UTF8` / `utf8mb4` (MySQL) vs `UTF8` (PostgreSQL)
- **Mini-projet** : installer MySQL ET PostgreSQL, creer la base `bibliotheque` sur les deux

### MODULE 3 — Types de Donnees
- Pourquoi choisir le bon type est crucial (espace, performance, integrite)
- Types numeriques :

| Type | MySQL | PostgreSQL | Usage |
|---|---|---|---|
| Entier petit | `TINYINT` | `SMALLINT` | ages, quantites |
| Entier standard | `INT` | `INTEGER` | identifiants, compteurs |
| Grand entier | `BIGINT` | `BIGINT` | timestamps, gros compteurs |
| Decimal exact | `DECIMAL(10,2)` | `NUMERIC(10,2)` | argent, prix |
| Flottant | `FLOAT`, `DOUBLE` | `REAL`, `DOUBLE PRECISION` | calculs scientifiques |
| Auto-increment | `INT AUTO_INCREMENT` | `SERIAL` / `GENERATED ALWAYS AS IDENTITY` | cles primaires |

- Types texte :

| Type | MySQL | PostgreSQL | Usage |
|---|---|---|---|
| Texte court fixe | `CHAR(10)` | `CHAR(10)` | codes postaux, codes pays |
| Texte court variable | `VARCHAR(255)` | `VARCHAR(255)` | noms, emails |
| Texte long | `TEXT` | `TEXT` | descriptions, articles |

- Types date/heure :

| Type | MySQL | PostgreSQL | Usage |
|---|---|---|---|
| Date | `DATE` | `DATE` | dates de naissance |
| Heure | `TIME` | `TIME` | horaires |
| Date+Heure | `DATETIME` | `TIMESTAMP` | creation, modification |
| Avec fuseau | `TIMESTAMP` | `TIMESTAMPTZ` | applications internationales |

- Types specifiques a PostgreSQL : `UUID`, `JSONB`, `ARRAY`, `INET`, `HSTORE`, `ENUM` (type reel)
- Types specifiques a MySQL : `ENUM('val1','val2')` (stocke comme entier), `SET`
- Booleans : MySQL utilise `TINYINT(1)`, PostgreSQL a un vrai `BOOLEAN`
- **Mini-projet** : concevoir les types de chaque colonne pour les tables de la bibliotheque

### MODULE 4 — Creer des Tables (DDL)
- `CREATE TABLE` : syntaxe complete
```sql
-- MySQL
CREATE TABLE auteurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE,
    nationalite VARCHAR(50) DEFAULT 'Inconnue',
    biographie TEXT,
    cree_le DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- PostgreSQL
CREATE TABLE auteurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE,
    nationalite VARCHAR(50) DEFAULT 'Inconnue',
    biographie TEXT,
    cree_le TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
- Contraintes :
  - `PRIMARY KEY` : identifiant unique obligatoire
  - `NOT NULL` : interdire les valeurs vides
  - `UNIQUE` : pas de doublons
  - `DEFAULT` : valeur par defaut
  - `CHECK` : condition de validation (ex : `CHECK (annee > 0)`)
  - `FOREIGN KEY ... REFERENCES` : lien entre tables
- Actions referentielles : `ON DELETE CASCADE`, `ON DELETE SET NULL`, `ON DELETE RESTRICT`
- `ALTER TABLE` : ajouter/modifier/supprimer des colonnes
- `DROP TABLE` : supprimer une table (attention !)
- `TRUNCATE TABLE` : vider une table sans la supprimer
- Conventions de nommage : `snake_case`, noms de tables au pluriel, cles etrangeres `table_id`
- **Mini-projet** : creer toutes les tables de la bibliotheque (auteurs, livres, membres, emprunts)

### MODULE 5 — Inserer des Donnees (INSERT)
- `INSERT INTO ... VALUES` : inserer une ligne
- `INSERT INTO ... (colonnes) VALUES` : inserer en specifiant les colonnes (recommande)
- Insertion multiple : inserer plusieurs lignes en une seule requete
- `INSERT ... SELECT` : inserer depuis une autre requete
- Gestion des conflits :
  - MySQL : `INSERT ... ON DUPLICATE KEY UPDATE`
  - PostgreSQL : `INSERT ... ON CONFLICT DO UPDATE` (UPSERT)
- Sequences et auto-increment : recuperer le dernier ID insere
  - MySQL : `LAST_INSERT_ID()`
  - PostgreSQL : `RETURNING id`
- Bonnes pratiques : toujours lister les colonnes, ne pas inserer d'ID manuellement
- **Mini-projet** : peupler la bibliotheque avec 10 auteurs, 20 livres, 15 membres, 10 emprunts

### MODULE 6 — Lire des Donnees (SELECT) — Partie 1 : Fondamentaux
- `SELECT` : la requete la plus utilisee
- Anatomie d'un SELECT :
```sql
SELECT colonnes        -- quoi afficher
FROM table             -- ou chercher
WHERE condition        -- filtrer les lignes
ORDER BY colonne       -- trier
LIMIT nombre           -- limiter le nombre de resultats
OFFSET debut;          -- sauter les N premiers
```
- `SELECT *` vs `SELECT col1, col2` : pourquoi eviter l'etoile en production
- `WHERE` : conditions de filtrage
  - Comparaisons : `=`, `!=` / `<>`, `<`, `>`, `<=`, `>=`
  - Logiques : `AND`, `OR`, `NOT`
  - `BETWEEN ... AND ...`
  - `IN (val1, val2, val3)`
  - `LIKE` et `ILIKE` (PostgreSQL) : recherche par motif (`%` = n'importe quoi, `_` = un caractere)
  - `IS NULL` / `IS NOT NULL` — attention : `= NULL` ne marche PAS
- `ORDER BY` : `ASC` (defaut) et `DESC`, tri multi-colonnes
- `LIMIT` / `OFFSET` :
  - MySQL : `LIMIT 10 OFFSET 20`
  - PostgreSQL : `LIMIT 10 OFFSET 20` (ou `FETCH FIRST 10 ROWS ONLY`)
- Alias : `SELECT nom AS nom_auteur`
- `DISTINCT` : eliminer les doublons
- **Mini-projet** : 10 requetes de recherche sur la bibliotheque (livres par auteur, membres actifs, etc.)

### MODULE 7 — Lire des Donnees (SELECT) — Partie 2 : Fonctions et Agregation
- Fonctions scalaires :
  - Texte : `UPPER()`, `LOWER()`, `CONCAT()` / `||` (PostgreSQL), `TRIM()`, `SUBSTRING()`, `LENGTH()`
  - Nombres : `ROUND()`, `CEIL()`, `FLOOR()`, `ABS()`, `MOD()`
  - Dates : `NOW()`, `CURRENT_DATE`, `DATE_PART()` (PostgreSQL) / `YEAR()`, `MONTH()` (MySQL), `AGE()` (PostgreSQL)
  - Conditionnelles : `CASE WHEN ... THEN ... ELSE ... END`, `COALESCE()`, `NULLIF()`
  - MySQL : `IF()`, `IFNULL()`
- Fonctions d'agregation :
  - `COUNT(*)` / `COUNT(colonne)` : compter
  - `SUM()` : sommer
  - `AVG()` : moyenne
  - `MIN()` / `MAX()` : extremes
  - `GROUP_CONCAT()` (MySQL) / `STRING_AGG()` (PostgreSQL) : concatener les valeurs d'un groupe
- `GROUP BY` : grouper les resultats
- `HAVING` : filtrer apres le regroupement (WHERE filtre avant, HAVING apres)
- Ordre d'execution d'un SELECT :
```
FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
(pas dans l'ordre d'ecriture !)
```
- **Mini-projet** : statistiques de la bibliotheque (livres par auteur, emprunts par mois, membres les plus actifs)

### MODULE 8 — Jointures (JOIN)
- Qu'est-ce qu'une jointure ? (analogie : relier deux feuilles Excel par une colonne commune)
- Schema ASCII des types de jointures :
```
Table A        Table B         INNER JOIN      LEFT JOIN       RIGHT JOIN      FULL JOIN
┌───┐         ┌───┐           ┌───┐           ┌───┐           ┌───┐           ┌───┐
│ 1 │─────────│ 1 │           │ 1 │           │ 1 │           │ 1 │           │ 1 │
│ 2 │─────────│ 2 │           │ 2 │           │ 2 │           │ 2 │           │ 2 │
│ 3 │         │ 4 │                           │ 3 │           │ 4 │           │ 3 │
└───┘         └───┘                           └───┘           └───┘           │ 4 │
                                               (3=NULL B)     (4=NULL A)      └───┘
```
- `INNER JOIN` : seulement les lignes qui correspondent dans les deux tables
- `LEFT JOIN` : toutes les lignes de gauche + correspondances de droite (NULL sinon)
- `RIGHT JOIN` : toutes les lignes de droite + correspondances de gauche
- `FULL OUTER JOIN` : toutes les lignes des deux cotes (PostgreSQL natif, MySQL necessite UNION)
- `CROSS JOIN` : produit cartesien (chaque ligne avec chaque ligne)
- `SELF JOIN` : une table jointe avec elle-meme
- Jointures multiples : enchainer 3, 4 tables ou plus
- Jointures avec conditions complexes
- Piege : jointures qui multiplient les lignes (relations N:N)
- **Mini-projet** : requetes multi-tables (livres avec noms d'auteurs, emprunts avec noms de membres et titres de livres)

### MODULE 9 — Sous-Requetes et CTE
- Sous-requete dans `WHERE` :
  - `IN (SELECT ...)` : valeur dans une liste
  - `EXISTS (SELECT ...)` : verifie l'existence
  - Sous-requete scalaire : une seule valeur
- Sous-requete dans `FROM` (table derivee) :
```sql
SELECT * FROM (SELECT ... ) AS sous_requete;
```
- Sous-requete correlee : reference la requete externe (attention a la performance)
- CTE (Common Table Expressions) — `WITH` :
```sql
WITH emprunts_actifs AS (
    SELECT membre_id, COUNT(*) AS nb
    FROM emprunts
    WHERE date_retour IS NULL
    GROUP BY membre_id
)
SELECT m.nom, ea.nb
FROM membres m
JOIN emprunts_actifs ea ON m.id = ea.membre_id;
```
- CTE recursif : hierarchies (categories, organigrammes)
- Quand utiliser sous-requete vs JOIN vs CTE : guide de decision
- **Mini-projet** : requetes complexes (membres n'ayant jamais emprunte, livres les plus populaires, retards d'emprunt)

### MODULE 10 — Modifier et Supprimer (UPDATE / DELETE)
- `UPDATE ... SET ... WHERE` : modifier des donnees
  - **Regle d'or** : TOUJOURS mettre un `WHERE` (sinon toute la table est modifiee !)
  - Astuce securite : d'abord ecrire le `SELECT` correspondant, verifier, puis transformer en `UPDATE`
- `UPDATE` avec jointure :
  - MySQL : `UPDATE t1 JOIN t2 ON ... SET t1.col = ...`
  - PostgreSQL : `UPDATE t1 SET col = ... FROM t2 WHERE t1.id = t2.id`
- `DELETE FROM ... WHERE` : supprimer des lignes
  - Meme regle : TOUJOURS un `WHERE`
  - Difference `DELETE` vs `TRUNCATE` : DELETE est transactionnel, TRUNCATE est plus rapide
- Soft delete : ne pas supprimer mais marquer (`deleted_at TIMESTAMP NULL`)
- `RETURNING` (PostgreSQL) : voir ce qui a ete modifie/supprime
- **Mini-projet** : operations de mise a jour sur la bibliotheque (retour de livre, changement d'email, suppression de membre)

### MODULE 11 — Index et Performance
- Qu'est-ce qu'un index ? (analogie : l'index a la fin d'un livre — chercher "chapitre 12" sans lire tout le livre)
- Sans index : scan sequentiel (lire TOUTE la table)
- Avec index : recherche rapide (arbre B-tree)
- Schema ASCII d'un B-tree simplifie :
```
                    [M]
                   /   \
              [D, H]    [R, V]
             / | \      / | \
           [A-C][E-G][I-L][N-Q][S-U][W-Z]
           
Rechercher "K" : M→gauche→H→droite→[I-L]→trouve !
3 etapes au lieu de 26
```
- `CREATE INDEX` : creer un index
- Types d'index :
  - `B-tree` : le plus courant (egalite, comparaisons, ORDER BY)
  - `Hash` : egalite uniquement (PostgreSQL)
  - `GIN` : texte integral, JSONB, tableaux (PostgreSQL)
  - `GiST` : donnees spatiales, recherche de proximite (PostgreSQL)
  - `FULLTEXT` : recherche textuelle (MySQL)
- Index composite : sur plusieurs colonnes — l'ordre compte !
- `EXPLAIN` / `EXPLAIN ANALYZE` : comprendre le plan d'execution
  - Lire un plan : Seq Scan vs Index Scan vs Index Only Scan
  - Cout, lignes estimees, temps reel
- Quand ne PAS mettre d'index : petites tables, colonnes rarement filtrees, trop d'ecritures
- Index et `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`
- **Mini-projet** : ajouter les index pertinents a la bibliotheque, comparer les performances avec EXPLAIN

### MODULE 12 — Transactions et Integrite
- Qu'est-ce qu'une transaction ? (analogie : un virement bancaire — tout passe ou rien ne passe)
- Proprietes ACID :
  - **Atomicite** : tout ou rien
  - **Coherence** : la base reste valide
  - **Isolation** : les transactions ne se genent pas
  - **Durabilite** : une fois validee, c'est permanent
- Syntaxe :
```sql
BEGIN;  -- ou START TRANSACTION
-- requetes...
COMMIT;    -- valider
-- ou
ROLLBACK;  -- annuler tout
```
- `SAVEPOINT` : points de sauvegarde intermediaires
- Niveaux d'isolation :
  - `READ UNCOMMITTED` : lit les donnees non commitees (dirty reads)
  - `READ COMMITTED` : defaut PostgreSQL
  - `REPEATABLE READ` : defaut MySQL InnoDB
  - `SERIALIZABLE` : le plus strict
- Phenomenes : dirty read, non-repeatable read, phantom read
- Deadlocks : deux transactions qui s'attendent mutuellement — detection et resolution
- Autocommit : MySQL et PostgreSQL l'activent par defaut (chaque requete = 1 transaction)
- **Mini-projet** : implementer le processus d'emprunt comme transaction (verifier disponibilite + creer emprunt + marquer livre indisponible)

### MODULE 13 — Vues, Fonctions et Procedures Stockees
- **Vues** : une requete sauvegardee comme une table virtuelle
```sql
CREATE VIEW emprunts_en_cours AS
SELECT m.nom, l.titre, e.date_emprunt
FROM emprunts e
JOIN membres m ON e.membre_id = m.id
JOIN livres l ON e.livre_id = l.id
WHERE e.date_retour IS NULL;

-- Utilisation :
SELECT * FROM emprunts_en_cours;
```
- Vues materialisees (PostgreSQL) : cache de la requete, `REFRESH MATERIALIZED VIEW`
- **Fonctions** :
  - MySQL : `CREATE FUNCTION`
  - PostgreSQL : `CREATE FUNCTION` avec `PL/pgSQL`
```sql
-- PostgreSQL
CREATE OR REPLACE FUNCTION jours_retard(date_emprunt DATE, duree_max INT)
RETURNS INT AS $$
BEGIN
    RETURN GREATEST(0, CURRENT_DATE - date_emprunt - duree_max);
END;
$$ LANGUAGE plpgsql;
```
- **Procedures stockees** :
  - MySQL : `CREATE PROCEDURE` avec `DELIMITER`
  - PostgreSQL : `CREATE PROCEDURE` (depuis v11) ou fonctions avec `VOID`
- **Triggers** : declencheurs automatiques (BEFORE/AFTER INSERT/UPDATE/DELETE)
```sql
-- Mettre a jour automatiquement "modifie_le"
CREATE TRIGGER maj_date_modification
BEFORE UPDATE ON livres
FOR EACH ROW
SET NEW.modifie_le = CURRENT_TIMESTAMP;  -- MySQL

-- PostgreSQL : necessite une fonction trigger
```
- Quand utiliser quoi : vues pour la lisibilite, fonctions pour la logique reutilisable, triggers avec parcimonie
- **Mini-projet** : creer une vue des emprunts en retard, une fonction de calcul d'amende, un trigger de mise a jour automatique

### MODULE 14 — Securite et Controle d'Acces
- **Injections SQL** : la vulnerabilite #1
  - Exemple dangereux : `SELECT * FROM users WHERE name = '` + input + `'`
  - Si input = `' OR 1=1 --` → acces a tout
  - Solution : **requetes preparees** (prepared statements) — TOUJOURS
  - Cote application : parametres lies (`$1`, `?`, `:nom`)
- Gestion des utilisateurs :
```sql
-- Creer un utilisateur
CREATE USER app_user WITH PASSWORD 'motdepasse_fort';

-- Donner des droits
GRANT SELECT, INSERT, UPDATE ON livres TO app_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_admin;

-- Retirer des droits
REVOKE DELETE ON livres FROM app_user;
```
- Roles (PostgreSQL) : grouper les permissions
- Principe du moindre privilege : chaque utilisateur n'a que les droits necessaires
- Chiffrement : connexions SSL, mots de passe haches
- Bonnes pratiques : ne jamais utiliser root/postgres en production, auditer les acces
- **Mini-projet** : creer 3 roles (admin, bibliothecaire, lecteur) avec permissions adaptees

### MODULE 15 — Fonctionnalites Avancees
- **JSON** :
  - MySQL : type `JSON`, fonctions `JSON_EXTRACT()`, `->`, `->>`
  - PostgreSQL : `JSON` et `JSONB` (indexable), operateurs `->`, `->>`, `@>`, `?`
```sql
-- PostgreSQL : stocker et requeter du JSON
CREATE TABLE livres_meta (
    id SERIAL PRIMARY KEY,
    livre_id INT REFERENCES livres(id),
    metadata JSONB
);

SELECT metadata->>'editeur' FROM livres_meta WHERE metadata @> '{"langue": "fr"}';
```
- **Recherche plein texte** :
  - MySQL : `FULLTEXT INDEX` + `MATCH ... AGAINST`
  - PostgreSQL : `tsvector`, `tsquery`, `to_tsvector()`, `@@`
- **Window Functions** (fonctions de fenetre) :
  - `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`
  - `LAG()`, `LEAD()` : valeur precedente/suivante
  - `SUM() OVER()`, `AVG() OVER()` : agregation sans GROUP BY
```sql
SELECT nom, nombre_emprunts,
       RANK() OVER (ORDER BY nombre_emprunts DESC) AS classement
FROM membres;
```
- **Partitionnement** : diviser une grande table en sous-tables
- **LATERAL JOIN** (PostgreSQL) : sous-requetes correlees dans FROM
- **COPY** (PostgreSQL) / **LOAD DATA** (MySQL) : import/export massif CSV
- **Mini-projet** : ajouter des metadonnees JSON aux livres, implementer une recherche plein texte, classer les membres par activite

### MODULE 16 — Modelisation et Normalisation
- Les 3 formes normales expliquees simplement :
  - **1NF** : chaque cellule contient une seule valeur (pas de listes)
  - **2NF** : chaque colonne depend de TOUTE la cle primaire
  - **3NF** : aucune colonne ne depend d'une autre colonne non-cle
- Denormalisation : quand et pourquoi casser les regles (performance en lecture)
- Relations :
  - **1:1** (un a un) : une personne a un passeport
  - **1:N** (un a plusieurs) : un auteur a plusieurs livres
  - **N:N** (plusieurs a plusieurs) : livres ↔ categories → table de liaison
- Table de liaison pour les relations N:N :
```
livres ←── livres_categories ──→ categories
  id            livre_id              id
                categorie_id
```
- Diagramme Entite-Relation (ERD) : comment le dessiner
- Outils de modelisation : dbdiagram.io, draw.io, pgModeler
- Anti-patterns courants :
  - Stocker des listes dans une colonne (violation 1NF)
  - Table "fourre-tout" avec 50 colonnes
  - ID numerique partout sans reflexion (cle naturelle vs synthetique)
- **Mini-projet** : concevoir le schema complet normalise de la bibliotheque avec diagramme ERD

### MODULE 17 — Sauvegarde, Restauration et Maintenance
- **Sauvegarde** :
  - MySQL : `mysqldump -u root -p bibliotheque > backup.sql`
  - PostgreSQL : `pg_dump bibliotheque > backup.sql` ou `pg_dump -Fc` (format compresse)
- **Restauration** :
  - MySQL : `mysql -u root -p bibliotheque < backup.sql`
  - PostgreSQL : `psql bibliotheque < backup.sql` ou `pg_restore`
- Sauvegarde physique vs logique
- Sauvegarde incrementale et Point-In-Time Recovery (PITR) avec WAL (PostgreSQL)
- Maintenance :
  - MySQL : `OPTIMIZE TABLE`, `ANALYZE TABLE`, `CHECK TABLE`
  - PostgreSQL : `VACUUM`, `VACUUM FULL`, `ANALYZE`, `REINDEX`
  - Autovacuum (PostgreSQL) : comment ca marche
- Monitoring : taille des tables, requetes lentes (slow query log)
- **Mini-projet** : mettre en place un script de sauvegarde automatique quotidienne

### MODULE 18 — Migration et Versioning de Schema
- Pourquoi versionner le schema ? (analogie : Git mais pour la structure de ta base)
- Outils de migration :
  - Generic : Flyway, Liquibase
  - Python : Alembic (SQLAlchemy)
  - Node.js : Knex.js, Prisma
- Ecrire des migrations reversibles : `UP` (appliquer) et `DOWN` (annuler)
- Convention de nommage : `001_create_auteurs.sql`, `002_add_email_to_membres.sql`
- Gestion des donnees lors des migrations (data migrations)
- Migrations sans interruption (zero-downtime) :
  - Ajouter une colonne nullable → remplir → rendre NOT NULL
  - Ne jamais renommer directement une colonne en production
- **Mini-projet** : creer 5 fichiers de migration pour construire la base bibliotheque de zero

### MODULE 19 — Optimisation et Bonnes Pratiques en Production
- Les 10 requetes les plus lentes : comment les identifier
  - MySQL : `slow_query_log`, `performance_schema`
  - PostgreSQL : `pg_stat_statements`, `auto_explain`
- `EXPLAIN ANALYZE` avance : lire chaque noeud du plan
- Optimisations courantes :
  - Eviter `SELECT *` en production
  - Utiliser `EXISTS` au lieu de `COUNT(*)` pour verifier l'existence
  - Preferer `JOIN` aux sous-requetes correlees
  - Pagination par curseur (keyset) au lieu de `OFFSET` pour les grandes tables
  - Batch inserts au lieu d'inserts individuels
  - Connection pooling : PgBouncer (PostgreSQL), ProxySQL (MySQL)
- Configuration :
  - MySQL : `innodb_buffer_pool_size`, `max_connections`
  - PostgreSQL : `shared_buffers`, `work_mem`, `effective_cache_size`
- Replication : maitre-esclave (lecture scaling)
- **Mini-projet** : auditer et optimiser 5 requetes lentes sur la base bibliotheque

### MODULE 20 — Projet Final Complet
- Schema final de la bibliotheque :
```
bibliotheque/
├── migrations/
│   ├── 001_create_auteurs.sql
│   ├── 002_create_livres.sql
│   ├── 003_create_membres.sql
│   ├── 004_create_emprunts.sql
│   ├── 005_create_categories.sql
│   └── 006_create_index.sql
├── views/
│   ├── emprunts_en_cours.sql
│   └── statistiques_mensuelles.sql
├── functions/
│   ├── calcul_amende.sql
│   └── jours_retard.sql
├── triggers/
│   └── maj_date_modification.sql
├── seed/
│   └── donnees_test.sql
├── queries/
│   ├── recherche_avancee.sql
│   └── rapports.sql
└── backup/
    └── backup.sh
```
- Fonctionnalites completes :
  - CRUD complet sur toutes les tables
  - Recherche avancee (plein texte, filtres combines)
  - Rapports statistiques (emprunts par mois, livres populaires, membres actifs)
  - Gestion des retards et amendes
  - Systeme de categories avec relation N:N
  - Vues pour les requetes frequentes
  - Index optimises avec benchmarks
  - Sauvegardes automatisees
- Les deux versions : MySQL ET PostgreSQL, avec les differences documentees
- **Livrable** : base de donnees complete, peuplee, optimisee, avec documentation

---

## CONTRAINTES DE QUALITE

1. **Chaque requete SQL** doit etre testable directement dans un terminal MySQL ou PostgreSQL
2. **Chaque nouveau terme** doit etre defini la premiere fois qu'il apparait
3. **Chaque module** commence par "Ce que tu vas apprendre" et finit par "Ce que tu sais maintenant"
4. **Les differences MySQL vs PostgreSQL** doivent etre presentees cote a cote dans un tableau comparatif
5. **Les erreurs frequentes** doivent etre listees : erreur → message du SGBD → cause → correction
6. **Chaque module** ne doit pas depasser 30 minutes de lecture
7. **Les requetes doivent suivre un style coherent** : mots-cles SQL en MAJUSCULES, noms en snake_case minuscule
8. **Chaque concept de performance** doit inclure un `EXPLAIN ANALYZE` montrant la difference

---

## FORMAT DE SORTIE ATTENDU

Pour chaque module, produis :
- **Titre et objectifs** (3-5 bullet points)
- **Explication theorique** avec analogies et schemas ASCII
- **Syntaxe** MySQL et PostgreSQL cote a cote quand elles different
- **Requetes commentees** etape par etape (executables telles quelles)
- **Erreurs courantes** (tableau : erreur → message → cause → correction)
- **Mini-projet** avec enonce et solution complete (versions MySQL ET PostgreSQL)
- **Quiz** de 3 questions pour verifier la comprehension
- **Transition** vers le module suivant

---


