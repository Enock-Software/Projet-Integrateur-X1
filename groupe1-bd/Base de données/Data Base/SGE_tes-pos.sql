-- =============================================
-- SGE_test-pos.sql - Tests unitaires positifs
-- =============================================

-- Préparation : Charger le schéma + données
-- (À exécuter après SGE_cre.sql et SGE_jdd_01.sql)

-- ====================== TESTS VUES ======================

-- Test 1 : Vue Stock actuel
SELECT 'TEST_POS_01' AS test_id, * FROM Vue_Stock_Actuel;

-- Test 2 : Vue Matériel Emballage (priorité recyclé)
SELECT 'TEST_POS_02' AS test_id, * FROM Vue_Materiel_Emballage;

-- ====================== TESTS FONCTIONS ======================

-- Test 3 : Stockage d'un lot (succès)
SELECT 'TEST_POS_03' AS test_id, stocker_lot('E0-005-C', 'LOT-EMP-202406', 20) AS resultat;

-- Test 4 : Prélèvement normal (succès)
SELECT 'TEST_POS_04' AS test_id, prelever_stock('E1-001-A', 'LOT-EMP-202406', 30) AS resultat;

-- Test 5 : Création d'un rapport d'exception
SELECT 'TEST_POS_05' AS test_id, creer_rapport_exception(
    'Produit périmé',
    'Lot LOT-PC-202405 proche de la date de péremption',
    1
) AS new_rapport_id;

-- ====================== VÉRIFICATION APRÈS OPÉRATIONS ======================

SELECT 'TEST_POS_06' AS test_id, * FROM PositionStock WHERE idCellule = 'E0-005-C';
SELECT 'TEST_POS_07' AS test_id, * FROM PositionStock WHERE idCellule = 'E1-001-A';
SELECT 'TEST_POS_08' AS test_id, * FROM RapportException ORDER BY idRapport DESC LIMIT 3;

-- Test final : Comptage global
SELECT 'TEST_POS_09' AS test_id,
    (SELECT COUNT(*) FROM Lot) AS nb_lots,
    (SELECT COUNT(*) FROM PositionStock) AS nb_positions,
    (SELECT COUNT(*) FROM RapportException) AS nb_exceptions;