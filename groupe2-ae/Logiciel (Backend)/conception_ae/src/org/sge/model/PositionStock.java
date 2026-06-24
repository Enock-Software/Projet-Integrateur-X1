package org.sge.model;

import java.time.LocalDateTime;

public class PositionStock {
    private Cellule cellule;
    private Lot lot;
    private int quantiteStockee;

    // Constructeur
    public PositionStock(Cellule cellule, Lot lot, int quantiteStockee) {
        this.cellule = cellule;
        this.lot = lot;
        this.quantiteStockee = quantiteStockee;
    }

    // Getters
    public Cellule getCellule() { return this.cellule; }
    public Lot getLot() { return this.lot; }
    public int getQuantiteStockee() { return this.quantiteStockee; }

    // Setters
    public void setCellule(Cellule cellule) { this.cellule = cellule; }
    public void setLot(Lot lot) { this.lot = lot; }
    public void setQuantiteStockee(int quantiteStockee) { this.quantiteStockee = quantiteStockee; }

    // toString
    @Override
    public String toString() {
        return "Inventaire [Cellule=" + cellule.getIdCellule() + " | Lot=" + lot.getIdLot() + " | Qté Stockée=" + quantiteStockee + "]";
    }

    // Méthode pour ajuster la quantité en stock après un écart constaté lors d'un comptage réel
    public void ajusterStock(int nouvelleQuantite) {
        // On prend la boîte "quantiteStockee" et on remplace son contenu par "nouvelleQuantite"
        this.quantiteStockee = nouvelleQuantite;
    }

    // Méthode pour vérifier si le lot stocké dans cette cellule a dépassé sa date de péremption
    public boolean verifierPeremption() {
        // On récupère la date actuelle (l'heure exacte de maintenant)
        LocalDateTime maintenant = LocalDateTime.now();
        
        // On ouvre l'objet lot pour récupérer sa date de péremption
        LocalDateTime dateLimite = this.lot.getDatePeremption();
        
        // On teste si la date limite est AVANT maintenant
        if (dateLimite.isBefore(maintenant)) {
            return true; // Oui, le lot est périmé !
        } else {
            return false; // Non, le lot est encore bon.
        }
    }
}