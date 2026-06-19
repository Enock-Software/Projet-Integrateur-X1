-- =====================================================================
-- SGE_tra.sql  -  Interface machine-machine : TRAITEMENTS
--                 (mises a jour de plus haut niveau pour les applications)
-- Instructions SQL parametrees (les "?" sont fournis par l'application).
-- Chaque traitement correspond a une operation metier du SGE.
-- =====================================================================

-- ----- TRAITEMENT 1 : enregistrer une ENTREE de stock -----
-- (1) tracer le mouvement d'entree
INSERT INTO mouvement (type, date_mvt, id_produit, id_cellule, quantite, id_individu)
VALUES ('entree', ?, ?, ?, ?, ?);
-- (2) ranger la quantite dans la cellule (cree ou complete l'emplacement)
INSERT INTO inventaire_emplacement (id_cellule, id_lot, quantite)
VALUES (?, ?, ?)
ON CONFLICT(id_cellule, id_lot) DO UPDATE SET quantite = quantite + excluded.quantite;

-- ----- TRAITEMENT 2 : enregistrer une SORTIE de stock -----
-- (1) tracer le mouvement de sortie (le trigger verifie le stock dispo)
INSERT INTO mouvement (type, date_mvt, id_produit, id_cellule, quantite, id_individu)
VALUES ('sortie', ?, ?, ?, ?, ?);
-- (2) retirer la quantite de l'emplacement
UPDATE inventaire_emplacement SET quantite = quantite - ?
WHERE id_cellule = ? AND id_lot = ?;

-- ----- TRAITEMENT 3 : faire avancer l'etat d'un bon de reception -----
UPDATE bon_reception SET etat = ? WHERE id_bon = ?;

-- ----- TRAITEMENT 4 : faire avancer l'etat d'un bon d'expedition -----
UPDATE bon_expedition SET etat = ? WHERE id_bon = ?;

-- ----- TRAITEMENT 5 : marquer un colis comme traite -----
UPDATE colis SET etat = 'traite' WHERE id_colis = ?;

-- ----- TRAITEMENT 6 : enregistrer un rapport d'exception -----
INSERT INTO rapport_exception (date_emission, type, description, id_bon_rec, id_bon_exp)
VALUES (?, ?, ?, ?, ?);