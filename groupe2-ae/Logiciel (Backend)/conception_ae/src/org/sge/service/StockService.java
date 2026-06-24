package org.sge.service;
//Cette classe sert de pont entre l'IHM et ton StockRepository pour gérer les flux d'entrée et de sortie.
import org.sge.repository.StockRepository;

public class StockService {
    private final StockRepository stockRepository;

    public StockService() {
        this.stockRepository = new StockRepository();
    }

    // Gère l'entrée en stock via l'IHM Réception
    public String validerEntreeStock(String idCellule, String idLot, int quantite) {
        if (quantite <= 0) {
            return "Erreur : La quantité doit être supérieure à 0.";
        }
        return stockRepository.stockerLot(idCellule, idLot, quantite);
    }

    // Gère la sortie de stock via l'IHM Expédition
    public String validerSortieStock(String idCellule, String idLot, int quantite) {
        if (quantite <= 0) {
            return "Erreur : La quantité à prélever doit être supérieure à 0.";
        }
        // C'est ici qu'on appellera plus tard la fonction de prélèvement du Repository
        return "Prélèvement prêt à être envoyé."; 
    }
}