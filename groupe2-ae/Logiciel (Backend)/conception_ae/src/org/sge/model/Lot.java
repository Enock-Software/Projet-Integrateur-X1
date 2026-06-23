package org.sge.model;

import java.time.LocalDateTime;

public class Lot {
    private String idLot;
    private int quantiteInitiale;
    private int quantiteActuelle;
    private LocalDateTime dateFabrication;
    private LocalDateTime datePeremption;

    // Constructeur
    public Lot(String idLot, int quantiteInitiale, int quantiteActuelle, LocalDateTime dateFabrication, LocalDateTime datePeremption) {
        this.idLot = idLot;
        this.quantiteInitiale = quantiteInitiale;
        this.quantiteActuelle = quantiteActuelle;
        this.dateFabrication = dateFabrication;
        this.datePeremption = datePeremption;
    }

    // Getters
    public String getIdLot() { return this.idLot; }
    public int getQuantiteInitiale() { return this.quantiteInitiale; }
    public int getQuantiteActuelle() { return this.quantiteActuelle; }
    public LocalDateTime getDateFabrication() { return this.dateFabrication; }
    public LocalDateTime getDatePeremption() { return this.datePeremption; }

    // Setters (Pas de setter pour idLot)
    public void setQuantiteInitiale(int quantiteInitiale) { this.quantiteInitiale = quantiteInitiale; }
    public void setQuantiteActuelle(int quantiteActuelle) { this.quantiteActuelle = quantiteActuelle; }
    public void setDateFabrication(LocalDateTime dateFabrication) { this.dateFabrication = dateFabrication; }
    public void setDatePeremption(LocalDateTime datePeremption) { this.datePeremption = datePeremption; }

    // toString
    @Override
    public String toString() {
        return "Lot [ID=" + idLot + " | Initial=" + quantiteInitiale + " | Actuel=" + quantiteActuelle + " | Exp=" + datePeremption + "]";
    }

    // --- MÉTHODES MÉTIER À CODER ---

    // Méthode pour diminuer la quantité actuelle lors d'une sortie de stock
    public void deduireQuantite(int quantiteSortante) {
        // On met à jour la quantité actuelle en lui retirant la quantité sortante
        this.quantiteActuelle = this.quantiteActuelle - quantiteSortante;
    }
    
    // Méthode pour vérifier si le lot actuel est vide (quantiteActuelle == 0)
    public boolean estEpuise() {
        // On teste si la quantité actuelle est tombée à 0
        if (this.quantiteActuelle == 0) {
            return true;  // Oui, le lot est épuisé !
        } else {
            return false; // Non, il reste encore des produits.
        }
    }
}