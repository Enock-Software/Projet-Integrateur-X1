-- =============================================
-- SGE_imm.sql - Interface de Base
-- Vues et fonctions principales
-- =============================================
SET search_path TO public;

-- ==================== VUES ====================

-- Vue globale des stocks actuels
CREATE VIEW Vue_Stock_Actuel AS
SELECT
    c.idCellule,
    c.zone,
    p.designation,
    l.idLot,
    ps.quantiteStockee,
    l.quantiteActuelle,
    (ps.quantiteStockee::decimal / l.quantiteActuelle * 100) AS pourcentage_occupation_lot
FROM PositionStock ps
JOIN Cellule c ON ps.idCellule = c.idCellule
JOIN Lot l ON ps.idLot = l.idLot
JOIN Produit p ON l.idProduit = p.idProduit;

-- Vue des disponibilités d'emballage (avec priorité au recyclé)
CREATE VIEW Vue_Materiel_Emballage AS
SELECT
    typeMateriel,
    estRecupere,
    quantiteStockee,
    CASE WHEN estRecupere THEN 'PRIORITAIRE' ELSE 'Neuf' END AS priorite
FROM MaterielEmballage
ORDER BY estRecupere DESC, quantiteStockee DESC;

-- Vue des mouvements récents
CREATE VIEW Vue_Mouvements_Recents AS
SELECT
    'Réception' AS type_mouvement,
    br.idBonReception AS reference,
    br.dateReception,
    p.designation,
    ce.quantite
FROM BonReception br
JOIN ColisEntrant ce ON ce.idBonReception = br.idBonReception
JOIN Produit p ON ce.idProduit = p.idProduit
UNION ALL
SELECT
    'Exception' AS type_mouvement,
    re.idRapport::VARCHAR,
    re.dateSignalement,
    re.typeAnomalie,
    NULL
FROM RapportException re;

-- ==================== FONCTIONS ====================

-- Fonction pour mettre à jour le stock après stockage
CREATE OR REPLACE FUNCTION stocker_lot(
    p_idCellule VARCHAR,
    p_idLot VARCHAR,
    p_quantite INTEGER
) RETURNS TEXT AS $$
BEGIN
    -- Vérifier si la cellule existe et a assez d'espace
    IF NOT EXISTS (SELECT 1 FROM Cellule WHERE idCellule = p_idCellule) THEN
        RETURN 'ERREUR: Cellule inexistante';
    END IF;

    INSERT INTO PositionStock (idCellule, idLot, quantiteStockee)
    VALUES (p_idCellule, p_idLot, p_quantite)
    ON CONFLICT (idCellule, idLot)
    DO UPDATE SET quantiteStockee = PositionStock.quantiteStockee + p_quantite;

    RETURN 'Stockage effectué avec succès';
END;
$$ LANGUAGE plpgsql;

-- Fonction pour prélever du stock (expédition)
CREATE OR REPLACE FUNCTION prelever_stock(
    p_idCellule VARCHAR,
    p_idLot VARCHAR,
    p_quantite INTEGER
) RETURNS TEXT AS $$
DECLARE
    stock_dispo INTEGER;
BEGIN
    SELECT quantiteStockee INTO stock_dispo
    FROM PositionStock
    WHERE idCellule = p_idCellule AND idLot = p_idLot;

    IF stock_dispo IS NULL OR stock_dispo < p_quantite THEN
        RETURN 'ERREUR: Quantité insuffisante';
    END IF;

    UPDATE PositionStock
    SET quantiteStockee = quantiteStockee - p_quantite
    WHERE idCellule = p_idCellule AND idLot = p_idLot;

    RETURN 'Prélèvement effectué avec succès';
END;
$$ LANGUAGE plpgsql;

-- Fonction pour générer un rapport d'exception
CREATE OR REPLACE FUNCTION creer_rapport_exception(
    p_type VARCHAR,
    p_description TEXT,
    p_idAuteur INTEGER
) RETURNS INTEGER AS $$
DECLARE
    new_id INTEGER;
BEGIN
    INSERT INTO RapportException (typeAnomalie, description, idAuteur)
    VALUES (p_type, p_description, p_idAuteur)
    RETURNING idRapport INTO new_id;

    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Mise à jour de prelever_stock pour déduire également du Lot global
CREATE OR REPLACE FUNCTION prelever_stock_complet(
    p_idCellule VARCHAR,
    p_idLot VARCHAR,
    p_quantite INTEGER
) RETURNS TEXT AS $$
DECLARE
    stock_dispo INTEGER;
BEGIN
    -- Vérifier le stock dans la cellule
    SELECT quantiteStockee INTO stock_dispo
    FROM PositionStock
    WHERE idCellule = p_idCellule AND idLot = p_idLot;

    IF stock_dispo IS NULL OR stock_dispo < p_quantite THEN
        RETURN 'ERREUR: Quantité insuffisante dans cette cellule';
    END IF;

    -- Déduire de la cellule (PositionStock)
    UPDATE PositionStock
    SET quantiteStockee = quantiteStockee - p_quantite
    WHERE idCellule = p_idCellule AND idLot = p_idLot;

    -- Déduire de la quantité globale du Lot
    UPDATE Lot
    SET quantiteActuelle = quantiteActuelle - p_quantite
    WHERE idLot = p_idLot;

    RETURN 'Prélèvement effectué avec succès';
END;
$$ LANGUAGE plpgsql;


--Fonction pour valider un Bon de Réception et changer son statut
CREATE OR REPLACE FUNCTION valider_bon_reception(
    p_idBon VARCHAR,
    p_nouveauStatut VARCHAR
) RETURNS TEXT AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM BonReception WHERE idBonReception = p_idBon) THEN
        RETURN 'ERREUR: Bon de réception introuvable';
    END IF;

    UPDATE BonReception
    SET statut = p_nouveauStatut
    WHERE idBonReception = p_idBon;

    RETURN 'Statut du bon de réception mis à jour avec succès';
END;
$$ LANGUAGE plpgsql;


-- Fonction pour valider un Bon d'Expédition et changer son statut
CREATE OR REPLACE FUNCTION valider_bon_expedition(
    p_idBon VARCHAR,
    p_nouveauStatut VARCHAR
) RETURNS TEXT AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM BonExpedition WHERE idBonExpedition = p_idBon) THEN
        RETURN 'ERREUR: Bon d''expédition introuvable';
    END IF;

    UPDATE BonExpedition
    SET statut = p_nouveauStatut
    WHERE idBonExpedition = p_idBon;

    RETURN 'Statut du bon d''expédition mis à jour avec succès';
END;
$$ LANGUAGE plpgsql;