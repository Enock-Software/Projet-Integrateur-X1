-- =============================================
-- SGE_cre.sql - Création du schéma de base de données
-- Système de Gestion d'Entrepôt -  PDII-P1
-- =============================================

-- =============================================
-- 1. TABLE INTERVENANT
-- =============================================
CREATE TABLE Intervenant (
    idIntervenant SERIAL PRIMARY KEY,
    nom VARCHAR(150) NOT NULL,
    telephone VARCHAR(30),
    email VARCHAR(100),
    adresse TEXT
);

CREATE TABLE Individu (
    idIntervenant INTEGER PRIMARY KEY REFERENCES Intervenant(idIntervenant) ON DELETE CASCADE,
    prenom VARCHAR(80),
    role VARCHAR(60)  -- Magasinier, Conducteur, etc.
);

CREATE TABLE Organisation (
    idIntervenant INTEGER PRIMARY KEY REFERENCES Intervenant(idIntervenant) ON DELETE CASCADE,
    registreCommerce VARCHAR(50),
    typeOrganisation VARCHAR(50) CHECK (typeOrganisation IN ('Fournisseur', 'Transporteur', 'Client', 'Partenaire', 'Autre'))
);

-- =============================================
-- 2. PRODUITS & LOTS
-- =============================================
CREATE TABLE Produit (
    idProduit SERIAL PRIMARY KEY,
    designation VARCHAR(120) NOT NULL,
    description TEXT,
    categorie VARCHAR(60),
    hauteur DECIMAL(6,3),      -- en mètres
    largeur DECIMAL(6,3),
    profondeur DECIMAL(6,3),
    poidsUnitaire DECIMAL(8,3) -- en kg
);

CREATE TABLE Lot (
    idLot VARCHAR(50) PRIMARY KEY,   -- ex: LOT-2024-0789
    idProduit INTEGER NOT NULL REFERENCES Produit(idProduit),
    quantiteInitiale INTEGER NOT NULL CHECK (quantiteInitiale >= 0),
    quantiteActuelle INTEGER NOT NULL CHECK (quantiteActuelle >= 0),
    dateFabrication DATE,
    datePeremption DATE
);

-- =============================================
-- 3. ENTREPÔT & CELLULES
-- =============================================
CREATE TABLE Cellule (
    idCellule VARCHAR(20) PRIMARY KEY,   -- ex: E1-034-A
    zone VARCHAR(2) NOT NULL CHECK (zone IN ('E0','E1','E2','E3')),
    hauteurMax DECIMAL(6,3),
    largeurMax DECIMAL(6,3),
    profondeurMax DECIMAL(6,3),
    masseMax DECIMAL(8,3),
    statut VARCHAR(30) DEFAULT 'Vide' CHECK (statut IN ('Vide', 'Partiellement occupée', 'Pleine', 'Verrouillée'))
);

CREATE TABLE PositionStock (
    idCellule VARCHAR(20) REFERENCES Cellule(idCellule),
    idLot VARCHAR(50) REFERENCES Lot(idLot),
    quantiteStockee INTEGER NOT NULL CHECK (quantiteStockee > 0),
    PRIMARY KEY (idCellule, idLot)
);

-- =============================================
-- 4. ARTÉFACTS (Flux)
-- =============================================
CREATE TABLE BonReception (
    idBonReception VARCHAR(50) PRIMARY KEY,
    idFournisseur INTEGER REFERENCES Organisation(idIntervenant),
    dateReception TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(30) DEFAULT 'En attente'
);

CREATE TABLE ColisEntrant (
    idColis VARCHAR(50) PRIMARY KEY,
    idBonReception VARCHAR(50) REFERENCES BonReception(idBonReception),
    idProduit INTEGER REFERENCES Produit(idProduit),
    quantite INTEGER NOT NULL,
    estEndommage BOOLEAN DEFAULT FALSE
);

CREATE TABLE BonExpedition (
    idBonExpedition VARCHAR(50) PRIMARY KEY,
    idClient INTEGER REFERENCES Intervenant(idIntervenant),
    datePlanifiee TIMESTAMP,
    statut VARCHAR(30) DEFAULT 'Reçu'
);

CREATE TABLE MaterielEmballage (
    idEmballage VARCHAR(50) PRIMARY KEY,
    typeMateriel VARCHAR(80) NOT NULL,
    estRecupere BOOLEAN DEFAULT FALSE,   -- Priorité au recyclé
    quantiteStockee INTEGER DEFAULT 0 CHECK (quantiteStockee >= 0)
);

CREATE TABLE RapportException (
    idRapport SERIAL PRIMARY KEY,
    typeAnomalie VARCHAR(60) NOT NULL,
    description TEXT,
    dateSignalement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idAuteur INTEGER REFERENCES Individu(idIntervenant)
);

-- =============================================
-- INDEX (pour performances)
-- =============================================
CREATE INDEX idx_lot_produit ON Lot(idProduit);
CREATE INDEX idx_position_cellule ON PositionStock(idCellule);
CREATE INDEX idx_position_lot ON PositionStock(idLot);
CREATE INDEX idx_bon_reception ON ColisEntrant(idBonReception);