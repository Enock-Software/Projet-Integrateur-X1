-- =====================================================================
-- SGE_imm.sql  -  Interface machine-machine : operations de BASE
--                 (insertion / retrait / modification des entites)
-- SQLite ne possede pas de procedures stockees : l'interface de base
-- est donc fournie sous forme d'instructions SQL parametrees (les "?"
-- sont remplaces par les valeurs fournies par l'application).
-- Reference utilisee par les applications AE et AA.
-- =====================================================================

-- ----- ORGANISATION -----
-- inserer
INSERT INTO organisation (nom, adresse, telephone, type) VALUES (?, ?, ?, ?);
-- modifier
UPDATE organisation SET nom = ?, adresse = ?, telephone = ?, type = ? WHERE id_organisation = ?;
-- retirer
DELETE FROM organisation WHERE id_organisation = ?;

-- ----- INDIVIDU -----
INSERT INTO individu (nom, adresse, telephone) VALUES (?, ?, ?);
UPDATE individu SET nom = ?, adresse = ?, telephone = ? WHERE id_individu = ?;
DELETE FROM individu WHERE id_individu = ?;

-- ----- PRODUIT -----
INSERT INTO produit (nom, description, marque, modele, est_emballage, id_fournisseur)
VALUES (?, ?, ?, ?, ?, ?);
UPDATE produit SET nom = ?, description = ?, marque = ?, modele = ?, est_emballage = ?, id_fournisseur = ?
WHERE id_produit = ?;
DELETE FROM produit WHERE id_produit = ?;

-- ----- LOT -----
INSERT INTO lot (id_produit, quantite) VALUES (?, ?);
UPDATE lot SET quantite = ? WHERE id_lot = ?;
DELETE FROM lot WHERE id_lot = ?;

-- ----- CELLULE -----
INSERT INTO cellule (id_zone, position, longueur, largeur, hauteur, masse_maximale)
VALUES (?, ?, ?, ?, ?, ?);
UPDATE cellule SET position = ?, masse_maximale = ? WHERE id_cellule = ?;
DELETE FROM cellule WHERE id_cellule = ?;

-- ----- COLIS -----
INSERT INTO colis (type, etat, date_creation, id_zone) VALUES (?, ?, ?, ?);
UPDATE colis SET etat = ?, id_zone = ? WHERE id_colis = ?;
DELETE FROM colis WHERE id_colis = ?;
-- contenu d'un colis
INSERT INTO contenu_colis (id_colis, id_produit, quantite) VALUES (?, ?, ?);
DELETE FROM contenu_colis WHERE id_colis = ? AND id_produit = ?;

-- ----- BON DE RECEPTION -----
INSERT INTO bon_reception (date_emission, id_fournisseur, etat) VALUES (?, ?, ?);
INSERT INTO ligne_bon_reception (id_bon, id_produit, quantite_attendue) VALUES (?, ?, ?);
DELETE FROM bon_reception WHERE id_bon = ?;

-- ----- BON D'EXPEDITION -----
INSERT INTO bon_expedition (date_emission, id_destinataire, etat) VALUES (?, ?, ?);
INSERT INTO ligne_bon_expedition (id_bon, id_produit, quantite) VALUES (?, ?, ?);
DELETE FROM bon_expedition WHERE id_bon = ?;