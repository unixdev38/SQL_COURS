# Scripts pratiques

## Démarrage

```bash
# PostgreSQL
createdb bibliotheque
psql -d bibliotheque -f schema_postgresql.sql

# MySQL
mysql -u root -p -e 'CREATE DATABASE IF NOT EXISTS bibliotheque CHARACTER SET utf8mb4'
mysql -u root -p bibliotheque < schema_mysql.sql
```

Puis exécutez le seed adapté au moteur. Les schémas sont volontairement séparés : `IDENTITY` et `AUTO_INCREMENT` ne sont pas interchangeables.

## Organisation

- `schema_*.sql` : structure complète et index ;
- `seed/` : données d’exercice ;
- `migrations/` : construction progressive ;
- `queries/` : rapports du projet final.
