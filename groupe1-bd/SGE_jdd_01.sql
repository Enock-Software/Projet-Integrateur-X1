-- =====================================================================
-- SGE_jdd_01.sql  -  Jeu de donnees de demonstration
-- A appliquer APRES SGE_cre.sql et SGE_inv.sql.
-- Vide d'abord les tables pour etre rejouable sans doublon.
-- =====================================================================
PRAGMA foreign_keys = ON;

DELETE FROM mouvement;
DELETE FROM inventaire_emplacement;
DELETE FROM contenu_colis;
DELETE FROM colis;
DELETE FROM ligne_bon_expedition;
DELETE FROM ligne_bon_reception;
DELETE FROM rapport_exception;
DELETE FROM bon_expedition;
DELETE FROM bon_reception;
DELETE FROM lot;
DELETE FROM produit_materiel;
DELETE FROM produit;
DELETE FROM cellule;
DELETE FROM zone;
DELETE FROM repertoire;
DELETE FROM role;
DELETE FROM individu;
DELETE FROM organisation;

-- Intervenants
INSERT INTO organisation (id_organisation, nom, type, adresse) VALUES
 (1,'Fournitech','fournisseur','Yaounde'),
 (2,'TransLog','transporteur','Douala'),
 (3,'MegaStore','destinataire','Yaounde'),
 (4,'SAC','interne','Yaounde');

INSERT INTO individu (id_individu, nom, adresse) VALUES
 (1,'Awono Paul','Yaounde'),
 (2,'Mballa Sarah','Yaounde'),
 (3,'Nkeng Jean','Douala');

INSERT INTO role (id_role, libelle) VALUES
 (1,'magasinier'),(2,'conducteur'),(3,'emballeur'),(4,'acheteur');

INSERT INTO repertoire (id_individu, id_organisation, id_role) VALUES
 (1,4,1),(2,4,3),(3,2,2);

-- Produits
INSERT INTO produit (id_produit, nom, marque, est_emballage, id_fournisseur) VALUES
 (1,'Carton 60x40','EmballPro',1,1),
 (2,'Clavier USB','Logix',0,1),
 (3,'Souris optique','Logix',0,1),
 (4,'Ruban adhesif','EmballPro',1,1);

INSERT INTO produit_materiel (id_produit, longueur, largeur, hauteur, masse) VALUES
 (2,45,15,3,0.6),
 (3,11,6,4,0.1);

INSERT INTO lot (id_lot, id_produit, quantite) VALUES
 (1,2,50),
 (2,3,100);

-- Entrepot
INSERT INTO zone (id_zone, libelle) VALUES
 (1,'reception'),(2,'expedition'),(3,'emballage'),
 (4,'E0'),(5,'E1'),(6,'E2'),(7,'E3');

INSERT INTO cellule (id_cellule, id_zone, position, masse_maximale) VALUES
 (1,4,'E0-A1',200),
 (2,4,'E0-A2',200),
 (3,5,'E1-B1',150);

INSERT INTO inventaire_emplacement (id_cellule, id_lot, quantite) VALUES
 (1,1,30),
 (2,1,20),
 (3,2,100);

-- Colis (entrant en zone reception, sortant en zone expedition)
INSERT INTO colis (id_colis, type, etat, date_creation, id_zone) VALUES
 (1,'entrant','traite','2026-06-01',1),
 (2,'sortant','en_attente','2026-06-10',2);

INSERT INTO contenu_colis (id_colis, id_produit, quantite) VALUES
 (1,2,50),(1,3,100),(2,2,10);

-- Artefacts
INSERT INTO bon_reception (id_bon, date_emission, id_fournisseur, etat) VALUES
 (1,'2026-06-01',1,'stocke');
INSERT INTO ligne_bon_reception (id_bon, id_produit, quantite_attendue) VALUES
 (1,2,50),(1,3,100);

INSERT INTO bon_expedition (id_bon, date_emission, id_destinataire, etat) VALUES
 (1,'2026-06-10',3,'prepare');
INSERT INTO ligne_bon_expedition (id_bon, id_produit, quantite) VALUES
 (1,2,10);

-- Mouvements (entree puis sortie : stock suffisant)
INSERT INTO mouvement (type, date_mvt, id_produit, id_cellule, quantite, id_individu) VALUES
 ('entree','2026-06-01',2,1,30,1),
 ('sortie','2026-06-10',2,1,10,1);