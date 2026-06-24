package org.sge.model;

// Cette classe comme Intervenant et Organisation vont juste afficher une fiche Contact avec des informations
public class Individu extends Intervenant {
    private String prenom;
    private String role; // Ex: Magasinier, Chef d'entrepôt, Client individuel

    // Constructeur complet 
    public Individu(int idIntervenant, String nom, String telephone, String email, String adresse, String prenom, String role) {
        super(idIntervenant, nom, telephone, email, adresse); // Appel obligatoire au constructeur de la mère
        this.prenom = prenom;
        this.role = role;
    }

    // Getters
    public String getPrenom() { return this.prenom; }
    public String getRole() { return this.role; }

    // Setters
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public void setRole(String role) { this.role = role; }

    // Méthode d'affichage combinant les méthodes de la mère et les attributs de la fille
    @Override
    public String toString() {
        return "Individu [ ID: " + getIdIntervenant() + " | Nom: " + getNom() + " | Prénom: " + prenom + " | Téléphone: " + getTelephone() + " | Email: " + getEmail() + " | Adresse: " + getAdresse() + " | Rôle: " + role + "]";
    }
}