-- =============================================
-- SGE_jdd_01.sql - Données de test
-- =============================================

-- 1. Intervenants
INSERT INTO Intervenant (nom, telephone, email, adresse) VALUES
('Jean Dupont', '243 81 234 5678', 'jean.dupont@sac.com', 'Kinshasa, Gombe'),
('Marie Kabeya', '243 89 123 4567', 'marie.kabeya@sac.com', 'Kinshasa, Lingwala'),
('Société Amazones et Centaures', '243 82 111 2222', 'contact@sac.cd', 'Kinshasa, Gombe'),
('TransLog Congo', '243 84 555 6666', 'info@translog.cd', 'Lubumbashi');

INSERT INTO Individu (idIntervenant, prenom, role) VALUES
(1, 'Jean', 'Magasinier'),
(2, 'Marie', 'Responsable Stocks');

INSERT INTO Organisation (idIntervenant, registreCommerce, typeOrganisation) VALUES
(3, 'RC-001', 'Client'),
(4, 'RC-002', 'Fournisseur');

-- 2. Produits
INSERT INTO Produit (designation, description, categorie, hauteur, largeur, profondeur, poidsUnitaire) VALUES
('Carton A4 Standard', 'Carton ondulé pour documents', 'Emballage', 0.30, 0.22, 0.20, 0.5),
('Ordinateur Portable Dell', 'Laptop professionnel', 'Informatique', 0.25, 0.35, 0.02, 2.1),
('Imprimante HP Laser', 'Imprimante multifonction', 'Informatique', 0.40, 0.35, 0.45, 8.5);

-- 3. Lots
INSERT INTO Lot (idLot, idProduit, quantiteInitiale, quantiteActuelle, dateFabrication, datePeremption) VALUES
('LOT-EMP-202406', 1, 500, 480, '2024-05-01', NULL),
('LOT-PC-202405', 2, 50, 42, '2024-04-15', '2026-12-31'),
('LOT-IMP-202403', 3, 20, 18, '2024-03-10', NULL);

-- 4. Cellules
INSERT INTO Cellule (idCellule, zone, hauteurMax, largeurMax, profondeurMax, masseMax, statut) VALUES
('E1-001-A', 'E1', 2.0, 1.2, 1.0, 500, 'Partiellement occupée'),
('E2-012-B', 'E2', 1.5, 0.8, 0.6, 200, 'Partiellement occupée'),
('E0-005-C', 'E0', 3.0, 1.5, 1.2, 800, 'Vide');

-- 5. PositionStock
INSERT INTO PositionStock (idCellule, idLot, quantiteStockee) VALUES
('E1-001-A', 'LOT-EMP-202406', 480),
('E2-012-B', 'LOT-PC-202405', 42),
('E2-012-B', 'LOT-IMP-202403', 18);

-- 6. Bons et Colis
INSERT INTO BonReception (idBonReception, idFournisseur, statut) VALUES
('BR-20240620-001', 4, 'Validé');

INSERT INTO ColisEntrant (idColis, idBonReception, idProduit, quantite, estEndommage) VALUES
('COL-001', 'BR-20240620-001', 1, 500, FALSE),
('COL-002', 'BR-20240620-001', 2, 50, FALSE);

INSERT INTO BonExpedition (idBonExpedition, idClient, datePlanifiee, statut) VALUES
('BE-20240625-001', 3, '2024-06-25 10:00:00', 'En préparation');

-- 7. Matériel d'emballage
INSERT INTO MaterielEmballage (idEmballage, typeMateriel, estRecupere, quantiteStockee) VALUES
('EMB-CARTON-01', 'Carton A4 Standard', TRUE, 120),
('EMB-CARTON-02', 'Carton A4 Standard', FALSE, 80),
('EMB-BOURRAGE-01', 'Bourrage papier recyclé', TRUE, 200);

-- 8. Rapports d'exception
INSERT INTO RapportException (typeAnomalie, description, idAuteur) VALUES
('Écart de stock', '10 unités manquantes sur le lot LOT-PC-202405', 1),
('Colis endommagé', 'Carton écrasé lors du déchargement', 2);