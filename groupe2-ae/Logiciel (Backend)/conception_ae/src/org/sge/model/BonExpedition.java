package org.sge.model;

import java.time.LocalDateTime;
import java.util.List;

public class BonExpedition {
    private String idBonExpedition;
    private Intervenant client;
    private LocalDateTime datePlanifiee;
    private String statut; // Ex: En préparation, Expédié, Annulé
    private List<ColisEntrant> listeColisDemandees;
    private LocalDateTime dateDeDepart;

    // Constructeur
    public BonExpedition(String idBonExpedition, Intervenant client, LocalDateTime datePlanifiee, String statut) {
        this.idBonExpedition = idBonExpedition;
        this.client = client;
        this.datePlanifiee = datePlanifiee;
        this.statut = statut;
    }

    // Getters
    public String getIdBonExpedition() { return this.idBonExpedition; }
    public Intervenant getClient() { return this.client; }
    public LocalDateTime getDatePlanifiee() { return this.datePlanifiee; }
    public String getStatut() { return this.statut; }

    // Setters (Pas de setter pour idBonExpedition)
    public void setClient(Intervenant client) { this.client = client; }
    public void setDatePlanifiee(LocalDateTime datePlanifiee) { this.datePlanifiee = datePlanifiee; }
    public void setStatut(String statut) { this.statut = statut; }

    // toString
    @Override
    public String toString() {
        return "BonExpedition [ID=" + idBonExpedition + " | Client=" + client.getNom() + " | Date=" + datePlanifiee + " | Statut=" + statut + "]";
    }
    
    //Méthode pour vérifier si tous les produits demandés sont disponibles en stock avant de lancer la préparation
    public boolean verifierDisponibiliteStock() {
        //La boucle for va parcourir toute la liste de produit un à un
       for (ColisEntrant colis : this.listeColisDemandees){
        //On récupère le produuit ainsi que la quantité de prosuits qu'il y a dans l'entrepot
        Produit p =  colis.getProduit();
        int QuantiteDemandee = colis.getQuantite();

        //On créé une méthode qui sera là pour nous dire quelle quantité il ya encore dans l'entrepot
        int stockeActuel = ObtenirstockeActuel(p);
        //Condition
        if (QuantiteDemandee > stockeActuel){
            return  false;
        }
       }
       return true;
    }

    // Méthode pour changer le statut du bon à "Expédié" et enregistrer la date réelle de départ
    public void validerExpedition() { 
        this.statut="Expédié";
        this.dateDeDepart = LocalDateTime.now();
    }

    private int ObtenirstockeActuel(Produit p) {
        return 100; // Simule qu'il y a toujours 100 produits en stock pour le test
    }
}