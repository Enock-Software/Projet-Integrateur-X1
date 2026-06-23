-- =====================================================================
-- SGE_inv.sql  -  Invariants : declencheurs (triggers)
-- A appliquer APRES SGE_cre.sql.
-- Note SQLite : ni CREATE DOMAIN ni routines stockees ; les domaines
-- sont assures par les CHECK (SGE_cre.sql) et les regles metier par
-- les triggers ci-dessous.
-- =====================================================================
PRAGMA foreign_keys = ON;

-- Invariant 1 : interdire une sortie superieure au stock disponible
CREATE TRIGGER IF NOT EXISTS trg_sortie_stock_suffisant
BEFORE INSERT ON mouvement
FOR EACH ROW
WHEN NEW.type = 'sortie'
BEGIN
    SELECT CASE
        WHEN COALESCE((
            SELECT SUM(ie.quantite)
            FROM inventaire_emplacement ie
            JOIN lot l ON l.id_lot = ie.id_lot
            WHERE l.id_produit = NEW.id_produit
        ), 0) < NEW.quantite
        THEN RAISE(ABORT, 'Stock insuffisant pour cette sortie')
    END;
END;

-- Invariant 2 : on ne range pas plus d'un lot que sa quantite totale
CREATE TRIGGER IF NOT EXISTS trg_inventaire_coherent
BEFORE INSERT ON inventaire_emplacement
FOR EACH ROW
BEGIN
    SELECT CASE
        WHEN NEW.quantite + COALESCE((
            SELECT SUM(quantite) FROM inventaire_emplacement WHERE id_lot = NEW.id_lot
        ), 0) > (SELECT quantite FROM lot WHERE id_lot = NEW.id_lot)
        THEN RAISE(ABORT, 'Quantite rangee superieure a la quantite du lot')
    END;
END;

-- Invariant 3 : coherence colis / zone
--   un colis entrant doit etre en zone 'reception',
--   un colis sortant en zone 'expedition'.
CREATE TRIGGER IF NOT EXISTS trg_colis_zone_coherente
BEFORE INSERT ON colis
FOR EACH ROW
WHEN NEW.id_zone IS NOT NULL
BEGIN
    SELECT CASE
        WHEN NEW.type = 'entrant'
             AND (SELECT libelle FROM zone WHERE id_zone = NEW.id_zone) <> 'reception'
        THEN RAISE(ABORT, 'Un colis entrant doit etre en zone de reception')
        WHEN NEW.type = 'sortant'
             AND (SELECT libelle FROM zone WHERE id_zone = NEW.id_zone) <> 'expedition'
        THEN RAISE(ABORT, 'Un colis sortant doit etre en zone d''expedition')
    END;
END;