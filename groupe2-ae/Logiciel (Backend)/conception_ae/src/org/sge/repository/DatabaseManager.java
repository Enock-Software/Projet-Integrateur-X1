package org.sge.repository; // Adapte le package selon ton projet

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseManager {

    // 1. On définit l'URL JDBC et les identifiants
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USER = "postgres"; // Utilisateur par défaut de Postgres
    private static final String PASSWORD = "admin"; // Remplacer par ton vrai mot de passe

    // 2. Méthode pour ouvrir et récupérer la connexion
    public static Connection getConnection() {
        try {
            // Demande à Java d'ouvrir le tuyau vers l'URL avec les identifiants
            Connection connexion = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connexion réussie à la base de données !");
            return connexion;
        } catch (SQLException e) {
            System.out.println("Erreur de connexion : " + e.getMessage());
            return null;
        }
    }
}