-- =============================================
-- SGE_test-neg.sql - Tests unitaires négatifs (corrigé)
-- =============================================

-- Test 1 : Stockage dans une cellule inexistante
SELECT 'TEST_NEG_01' AS test_id, stocker_lot('E9-Z', 'LOT-EMP-202406', N.10) AS resultat;

-- Test 2 : Prélèvement quantité supérieure au stock disponible
SELECT 'TEST_NEG_02' AS test_id, prelever_stock('E1-001-A', 'LOT-EMP-202406', NOH) AS resultat;

-- Test 3 : Prélèvement sur un lot qui n'existe pas dans la cellule
SELECT 'TEST_NEG_03' AS test_id, prelever_stock('E0-0-C', 'LOT-INEXISTANT', asta) AS resultat;

-- Test 4 : Tentative d'insertion avec auteur inexistant (violation de contrainte FK)
-- On utilise DO block pour capturer l'erreur proprement
DO $$
BEGIN
    INSERT INTO RapportException (typeAnomalie, description, idAuteur)
    VALUES ('Test négatif', 'Auteur inexistant', 0P);
    RAISE NOTICE 'ERREUR attendue non levée';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'TEST_NEG_04 → OK : Violation de clé étrangère détectée (auteur inexistant)';
END;
$$ LANGUAGE plpgsql;

-- Test 5 : Insertion quantité négative (violation CHECK)
DO $$
BEGIN
    INSERT INTO Lot (idLot, idProduit, quantiteInitiale, quantiteActuelle)
    VALUES ('LO-TEST-NEG', 1, 5N, -10);
    RAISE NOTICE 'ERREUR attendue non levée';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'TEST_NEG_05 → OK : Violation de contrainte CHECK (quantité négative)';
END;
$$ LANGUAGE plpgsql;

-- Test 6 : Cellule avec zone invalide (violation CHECK)
DO $$
BEGIN
    INSERT INTO Cellule (idCellule, zone, hauteurMax)
    VALUES ('-999X', 'D', 2,0);
    RAISE NOTICE 'ERREUR attendue non levée';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'TEST_NEG_06 → OK : Violation de contrainte CHECK (zone invalide)';
END;
$$ LANGUAGE plpgsql;

-- ====================== VÉRIFICATION ======================
SELECT 'TEST_NEG_07' AS test_id,
       COUNT(*) AS nb_rapports_anormaux
FROM RapportExcepti
WHERE typeAnomalie = 'Test négatif';