-- =====================================================================
-- SGE_test-pos.sql  -  Tests unitaires POSITIFS
-- Scenarios qui DOIVENT reussir (donnees valides, regles respectees).
-- A appliquer APRES SGE_cre.sql, SGE_inv.sql et SGE_jdd_01.sql.
-- Aucune erreur ne doit apparaitre lors de l'execution.
-- =====================================================================
PRAGMA foreign_keys = ON;

-- T1 : inserer une organisation valide
INSERT INTO organisation (nom, type, adresse) VALUES ('NouvoFour','fournisseur','Douala');

-- T2 : inserer un produit rattache a un fournisseur existant
INSERT INTO produit (nom, marque, est_emballage, id_fournisseur)
VALUES ('Ecran 24"','Visio',0,1);

-- T3 : creer un lot et le ranger SANS depasser sa quantite (trigger OK)
INSERT INTO lot (id_lot, id_produit, quantite) VALUES (10, 3, 40);
INSERT INTO inventaire_emplacement (id_cellule, id_lot, quantite) VALUES (2, 10, 40);

-- T4 : enregistrer une entree de stock
INSERT INTO mouvement (type, date_mvt, id_produit, id_cellule, quantite, id_individu)
VALUES ('entree','2026-06-15',3,2,40,1);

-- T5 : sortie INFERIEURE au stock disponible (doit passer)
INSERT INTO mouvement (type, date_mvt, id_produit, id_cellule, quantite, id_individu)
VALUES ('sortie','2026-06-16',3,2,20,1);

-- T6 : colis sortant correctement place en zone d'expedition
INSERT INTO colis (id_colis, type, etat, date_creation, id_zone)
VALUES (10,'sortant','en_attente','2026-06-16',2);

-- Verifications : ces requetes doivent renvoyer des lignes coherentes
SELECT 'etat_stock' AS controle, * FROM v_etat_stock;
SELECT 'stock_par_produit' AS controle, * FROM v_stock_par_produit;