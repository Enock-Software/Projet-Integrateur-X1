//Before to execute always check that the file postgres-42.7.2.jar is always in the referenced libraries
package org.sge.model;

import java.sql.Connection;
import java.sql.SQLException;
import org.sge.repository.DatabaseManager;

public class main {
    public static void main(String[] args) {
        
        // On demande la connexion
        Connection maConnexion = DatabaseManager.getConnection();
        
        //Si elle est bonne on travaille avec, puis on la ferme toujours à la fin
        if (maConnexion != null) {
            try {
                // C'est ici que on fera les requêtes SQL plus tard
                
                maConnexion.close(); // Très important de refermer le tuyau
                System.out.println("Connexion fermée proprement.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}