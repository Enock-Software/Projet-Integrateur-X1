-- =====================================================================
-- SGE_test-neg.sql  -  Tests unitaires NEGATIFS
-- Scenarios qui DOIVENT etre BLOQUES par la base.
-- Chaque instruction ci-dessous doit PROVOQUER UNE ERREUR.
-- A executer une par une (l'execution s'arrete a la 1re erreur).
-- A appliquer sur une base creee + invariants + jeu de donnees.
-- =====================================================================
PRAGMA foreign_keys = ON;

-- N1 : type d'organisation hors domaine -> CHECK refuse
INSERT INTO organisation (nom, type) VALUES ('Bidon','client');

-- N2 : produit rattache a un fournisseur inexistant -> cle etrangere refuse
INSERT INTO produit (nom, id_fournisseur) VALUES ('Fantome', 999);

-- N3 : quantite de lot negative -> CHECK refuse
INSERT INTO lot (id_produit, quantite) VALUES (2, -5);

-- N4 : ranger plus que la quantite du lot -> trigger trg_inventaire_coherent
INSERT INTO inventaire_emplacement (id_cellule, id_lot, quantite) VALUES (3, 1, 999);

-- N5 : sortie superieure au stock disponible -> trigger trg_sortie_stock_suffisant
INSERT INTO mouvement (type, date_mvt, id_produit, quantite) VALUES ('sortie','2026-06-20',4,10);

-- N6 : colis entrant place en zone d'expedition -> trigger trg_colis_zone_coherente
INSERT INTO colis (type, etat, date_creation, id_zone) VALUES ('entrant','en_attente','2026-06-20',2);

-- N7 : doublon de cle primaire -> contrainte PRIMARY KEY
INSERT INTO organisation (id_organisation, nom, type) VALUES (1,'Doublon','interne');