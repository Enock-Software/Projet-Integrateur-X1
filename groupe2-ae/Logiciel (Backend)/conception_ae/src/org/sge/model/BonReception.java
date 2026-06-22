package org.sge.model;

import java.time.LocalDateTime;
import java.util.List;

public class BonReception {
    private String idBonReception;
    private Organisation fournisseur;
    private LocalDateTime dateReception;
    private String statut; // Ex: En attente, Reçu, Conforme, Anomalie
    private List<ColisEntrant> listeColis; // Contiendra les colis associés à ce bon

    // Constructeur
    public BonReception(String idBonReception, Organisation fournisseur, LocalDateTime dateReception, String statut, List<ColisEntrant> listeColis) {
        this.idBonReception = idBonReception;
        this.fournisseur = fournisseur;
        this.dateReception = dateReception;
        this.statut = statut;
        this.listeColis = listeColis;
    }

    // Getters
    public String getIdBonReception() { return this.idBonReception; }
    public Organisation getFournisseur() { return this.fournisseur; }
    public LocalDateTime getDateReception() { return this.dateReception; }
    public String getStatut() { return this.statut; }
    public List<ColisEntrant> getListeColis() { return this.listeColis; }

    // Setters (Pas de setter pour idBonReception)
    public void setFournisseur(Organisation fournisseur) { this.fournisseur = fournisseur; }
    public void setDateReception(LocalDateTime dateReception) { this.dateReception = dateReception; }
    public void setStatut(String statut) { this.statut = statut; }
    public void setListeColis(List<ColisEntrant> listeColis) { this.listeColis = listeColis; }

    // toString
    @Override
    public String toString() {
        return "BonReception [ID=" + idBonReception + " | Fournisseur=" + fournisseur.getNom() + " | Date=" + dateReception + " | Statut=" + statut + "]";
    }

    // Méthode pour ajouter un nouveau colis à la liste reçue
    public void ajouterColis(ColisEntrant nouveauColis) {
        this.listeColis.add(nouveauColis);
    }

    // Méthode pour compter le nombre total de colis présents dans ce bon
    public int calculerNombreTotalColis() { 
        int total = 0; //On crée la boîte pour stocker le total général
        //On parcours la liste des colis
        for(ColisEntrant colis : this.listeColis){
            total = total + colis.getQuantite();
        }

        //On renvoie le résultat une fois le résultat final
        return total;
    }

    //Méthode pour passer le statut à "Conforme" si aucun colis n'est abîmé, ou "Anomalie" sinon
    public void verifierConformite() { 
        // On parcourt tous les colis du bon
        for (ColisEntrant colis : this.listeColis) {
            
            // SI le colis actuel est endommagé
            if (colis.isEstEndomage()) {
                this.statut = "Anomalie"; // on change le statut
                return; //et on arrête immédiatement la méthode (pas besoin de voir le reste)
            }
        }
        
        // Si la boucle s'est terminée sans trouver aucun problème :
        this.statut = "Conforme";
    }
}