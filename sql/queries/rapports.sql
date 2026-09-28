-- Emprunts en cours
SELECT m.nom, l.titre, e.date_emprunt
FROM emprunts e JOIN membres m ON m.id=e.membre_id JOIN livres l ON l.id=e.livre_id
WHERE e.date_retour IS NULL ORDER BY e.date_emprunt;

-- Livres les plus empruntés
SELECT l.titre, COUNT(e.id) AS nombre_emprunts
FROM livres l LEFT JOIN emprunts e ON e.livre_id=l.id
GROUP BY l.id,l.titre ORDER BY nombre_emprunts DESC LIMIT 10;

-- Membres actifs
SELECT m.nom, COUNT(e.id) AS total
FROM membres m JOIN emprunts e ON e.membre_id=m.id
GROUP BY m.id,m.nom ORDER BY total DESC;

-- Livres jamais empruntés
SELECT l.titre FROM livres l
WHERE NOT EXISTS (SELECT 1 FROM emprunts e WHERE e.livre_id=l.id);
