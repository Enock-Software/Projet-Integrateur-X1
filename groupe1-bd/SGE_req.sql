-- =====================================================================
-- SGE_req.sql  -  Requetes de consultation (interface IMM : selections)
-- En SQLite, une "routine equivalente a une selection" se realise par
-- une VUE (vue nommee et reutilisable par les applications).
-- A appliquer APRES SGE_cre.sql.
-- =====================================================================
PRAGMA foreign_keys = ON;

-- Etat des stocks en temps reel (produit, zone, emplacement, quantite)
CREATE VIEW IF NOT EXISTS v_etat_stock AS
SELECT  p.id_produit,
        p.nom            AS produit,
        z.libelle        AS zone,
        c.position       AS emplacement,
        SUM(ie.quantite) AS quantite
FROM    inventaire_emplacement ie
JOIN    lot     l ON l.id_lot = ie.id_lot
JOIN    produit p ON p.id_produit = l.id_produit
JOIN    cellule c ON c.id_cellule = ie.id_cellule
JOIN    zone    z ON z.id_zone = c.id_zone
GROUP BY p.id_produit, z.libelle, c.position;

-- Quantite totale en stock par produit (toutes cellules confondues)
CREATE VIEW IF NOT EXISTS v_stock_par_produit AS
SELECT  p.id_produit,
        p.nom                        AS produit,
        COALESCE(SUM(ie.quantite),0) AS quantite_totale
FROM    produit p
LEFT JOIN lot l                    ON l.id_produit = p.id_produit
LEFT JOIN inventaire_emplacement ie ON ie.id_lot = l.id_lot
GROUP BY p.id_produit, p.nom;

-- Historique des mouvements (entrees / sorties)
CREATE VIEW IF NOT EXISTS v_mouvements AS
SELECT  m.id_mouvement,
        m.date_mvt,
        m.type,
        p.nom       AS produit,
        m.quantite,
        c.position  AS emplacement,
        i.nom       AS effectue_par
FROM    mouvement m
JOIN    produit p ON p.id_produit = m.id_produit
LEFT JOIN cellule c  ON c.id_cellule = m.id_cellule
LEFT JOIN individu i ON i.id_individu = m.id_individu
ORDER BY m.date_mvt;

-- Colis encore en attente de traitement
CREATE VIEW IF NOT EXISTS v_colis_en_attente AS
SELECT  co.id_colis,
        co.type,
        co.etat,
        co.date_creation,
        z.libelle AS zone
FROM    colis co
LEFT JOIN zone z ON z.id_zone = co.id_zone
WHERE   co.etat <> 'traite';

-- Bons de reception non clos
CREATE VIEW IF NOT EXISTS v_bons_reception_ouverts AS
SELECT  b.id_bon,
        b.date_emission,
        o.nom AS fournisseur,
        b.etat
FROM    bon_reception b
JOIN    organisation o ON o.id_organisation = b.id_fournisseur
WHERE   b.etat <> 'clos';