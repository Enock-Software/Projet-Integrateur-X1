-- =====================================================================
-- SGE_cre.sql  -  Creation du schema (domaines via CHECK, et tables)
-- Projet SGE - Groupe 1 (Base de donnees) - dialecte SQLite
-- Ordre des tables respecte les dependances de cles etrangeres.
-- =====================================================================
PRAGMA foreign_keys = ON;

-- ---------- INTERVENANTS ----------
CREATE TABLE organisation (
    id_organisation  INTEGER PRIMARY KEY,
    nom              TEXT    NOT NULL,
    adresse          TEXT,
    telephone        TEXT,
    type             TEXT    NOT NULL
                     CHECK (type IN ('fournisseur','transporteur','destinataire','interne'))
);

CREATE TABLE individu (
    id_individu  INTEGER PRIMARY KEY,
    nom          TEXT NOT NULL,
    adresse      TEXT,
    telephone    TEXT
);

CREATE TABLE role (
    id_role  INTEGER PRIMARY KEY,
    libelle  TEXT NOT NULL UNIQUE
);

CREATE TABLE repertoire (
    id_individu      INTEGER NOT NULL,
    id_organisation  INTEGER NOT NULL,
    id_role          INTEGER NOT NULL,
    PRIMARY KEY (id_individu, id_organisation, id_role),
    FOREIGN KEY (id_individu)     REFERENCES individu(id_individu),
    FOREIGN KEY (id_organisation) REFERENCES organisation(id_organisation),
    FOREIGN KEY (id_role)         REFERENCES role(id_role)
);

-- ---------- PRODUITS ----------
CREATE TABLE produit (
    id_produit     INTEGER PRIMARY KEY,
    nom            TEXT NOT NULL,
    description    TEXT,
    marque         TEXT,
    modele         TEXT,
    est_emballage  INTEGER NOT NULL DEFAULT 0 CHECK (est_emballage IN (0,1)),
    id_fournisseur INTEGER,
    FOREIGN KEY (id_fournisseur) REFERENCES organisation(id_organisation)
);

CREATE TABLE produit_materiel (
    id_produit  INTEGER PRIMARY KEY,
    longueur    REAL,
    largeur     REAL,
    hauteur     REAL,
    masse       REAL,
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

CREATE TABLE lot (
    id_lot      INTEGER PRIMARY KEY,
    id_produit  INTEGER NOT NULL,
    quantite    INTEGER NOT NULL CHECK (quantite >= 0),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

-- ---------- ENTREPOT ----------
CREATE TABLE zone (
    id_zone  INTEGER PRIMARY KEY,
    libelle  TEXT NOT NULL UNIQUE
);

CREATE TABLE cellule (
    id_cellule      INTEGER PRIMARY KEY,
    id_zone         INTEGER NOT NULL,
    position        TEXT,
    longueur        REAL,
    largeur         REAL,
    hauteur         REAL,
    masse_maximale  REAL,
    FOREIGN KEY (id_zone) REFERENCES zone(id_zone)
);

CREATE TABLE inventaire_emplacement (
    id_cellule  INTEGER NOT NULL,
    id_lot      INTEGER NOT NULL,
    quantite    INTEGER NOT NULL CHECK (quantite >= 0),
    PRIMARY KEY (id_cellule, id_lot),
    FOREIGN KEY (id_cellule) REFERENCES cellule(id_cellule),
    FOREIGN KEY (id_lot)     REFERENCES lot(id_lot)
);

-- ---------- COLIS ----------
CREATE TABLE colis (
    id_colis       INTEGER PRIMARY KEY,
    type           TEXT NOT NULL CHECK (type IN ('entrant','sortant')),
    etat           TEXT NOT NULL DEFAULT 'en_attente'
                   CHECK (etat IN ('en_attente','en_cours','traite')),
    date_creation  TEXT NOT NULL,
    id_zone        INTEGER,
    FOREIGN KEY (id_zone) REFERENCES zone(id_zone)
);

CREATE TABLE contenu_colis (
    id_colis    INTEGER NOT NULL,
    id_produit  INTEGER NOT NULL,
    quantite    INTEGER NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (id_colis, id_produit),
    FOREIGN KEY (id_colis)   REFERENCES colis(id_colis),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

-- ---------- ARTEFACTS ----------
CREATE TABLE bon_reception (
    id_bon          INTEGER PRIMARY KEY,
    date_emission   TEXT NOT NULL,
    id_fournisseur  INTEGER NOT NULL,
    etat            TEXT NOT NULL DEFAULT 'en_attente'
                    CHECK (etat IN ('en_attente','verifie','stocke','clos')),
    FOREIGN KEY (id_fournisseur) REFERENCES organisation(id_organisation)
);

CREATE TABLE ligne_bon_reception (
    id_bon            INTEGER NOT NULL,
    id_produit        INTEGER NOT NULL,
    quantite_attendue INTEGER NOT NULL CHECK (quantite_attendue > 0),
    PRIMARY KEY (id_bon, id_produit),
    FOREIGN KEY (id_bon)     REFERENCES bon_reception(id_bon),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

CREATE TABLE bon_expedition (
    id_bon          INTEGER PRIMARY KEY,
    date_emission   TEXT NOT NULL,
    id_destinataire INTEGER NOT NULL,
    etat            TEXT NOT NULL DEFAULT 'en_attente'
                    CHECK (etat IN ('en_attente','prepare','expedie','clos')),
    FOREIGN KEY (id_destinataire) REFERENCES organisation(id_organisation)
);

CREATE TABLE ligne_bon_expedition (
    id_bon       INTEGER NOT NULL,
    id_produit   INTEGER NOT NULL,
    quantite     INTEGER NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (id_bon, id_produit),
    FOREIGN KEY (id_bon)     REFERENCES bon_expedition(id_bon),
    FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

CREATE TABLE rapport_exception (
    id_rapport    INTEGER PRIMARY KEY,
    date_emission TEXT NOT NULL,
    type          TEXT NOT NULL,
    description   TEXT NOT NULL,
    id_bon_rec    INTEGER,
    id_bon_exp    INTEGER,
    FOREIGN KEY (id_bon_rec) REFERENCES bon_reception(id_bon),
    FOREIGN KEY (id_bon_exp) REFERENCES bon_expedition(id_bon)
);

-- ---------- PROCEDES : mouvements (tracabilite) ----------
CREATE TABLE mouvement (
    id_mouvement  INTEGER PRIMARY KEY,
    type          TEXT NOT NULL CHECK (type IN ('entree','sortie')),
    date_mvt      TEXT NOT NULL,
    id_produit    INTEGER NOT NULL,
    id_cellule    INTEGER,
    quantite      INTEGER NOT NULL CHECK (quantite > 0),
    id_individu   INTEGER,
    FOREIGN KEY (id_produit)  REFERENCES produit(id_produit),
    FOREIGN KEY (id_cellule)  REFERENCES cellule(id_cellule),
    FOREIGN KEY (id_individu) REFERENCES individu(id_individu)
);
