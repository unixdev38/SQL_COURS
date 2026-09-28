CREATE INDEX idx_livres_auteur ON livres(auteur_id);
CREATE INDEX idx_emprunts_membre_date ON emprunts(membre_id,date_emprunt);
CREATE INDEX idx_emprunts_retour ON emprunts(date_retour);
