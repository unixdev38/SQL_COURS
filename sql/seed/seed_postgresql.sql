INSERT INTO auteurs (nom, email) VALUES
 ('Albert Camus','camus@example.org'), ('Antoine de Saint-Exupéry','saintex@example.org'), ('Amin Maalouf','maalouf@example.org'), ('Mariama Bâ','mariama@example.org');
INSERT INTO membres (nom,email) VALUES ('Awa Ouédraogo','awa@example.org'), ('Blaise Kaboré','blaise@example.org'), ('Chantal Traoré','chantal@example.org');
INSERT INTO livres (titre,auteur_id,isbn,annee) VALUES
 ('L’Étranger',1,'9782070360024',1942), ('La Peste',1,'9782070360420',1947), ('Le Petit Prince',2,'9782070612758',1943), ('Les Désorientés',3,'9782253082875',2012), ('Une si longue lettre',4,'9782708701234',1979);
INSERT INTO categories (nom) VALUES ('Roman'), ('Classique'), ('Philosophie');
INSERT INTO livres_categories VALUES (1,1),(1,2),(2,1),(3,2),(4,1),(5,1);
INSERT INTO emprunts (livre_id,membre_id,date_emprunt) VALUES (1,1,CURRENT_DATE-10),(3,2,CURRENT_DATE-3);
UPDATE livres SET disponible = FALSE WHERE id IN (1,3);
