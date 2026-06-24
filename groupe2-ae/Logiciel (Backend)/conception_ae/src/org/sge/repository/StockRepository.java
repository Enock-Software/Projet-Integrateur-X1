package org.sge.repository;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class StockRepository {

    // Appel de la fonction stocker_lot de ton collègue
    public String stockerLot(String idCellule, String idLot, int quantite) {
        String sql = "{ ? = call stocker_lot(?, ?, ?) }";
        
        try (Connection conn = DatabaseManager.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
            
            // Déclarer le type du paramètre de retour (TEXT -> VARCHAR)
            stmt.registerOutParameter(1, java.sql.Types.VARCHAR);
            
            //Injecter les arguments reçus
            stmt.setString(2, idCellule);
            stmt.setString(3, idLot);
            stmt.setInt(4, quantite);
            
            // Exécuter la procédure stockée
            stmt.execute();
            
            //écupérer le message de succès ou d'erreur renvoyé par PostgreSQL
            return stmt.getString(1); 
            
        } catch (SQLException e) {
            e.printStackTrace();
            return "Erreur technique : " + e.getMessage();
        }
    }
}