package org.sge.model;

import java.time.LocalDateTime;

public class RapportException {
    private String idRapport;
    private String typeAnomalie; // Ex: Produit cassé, Erreur de quantité, Retard livraison
    private String description;
    private LocalDateTime dateSignalement;
    private Individu auteur; // L'employé qui a signalé l'anomalie

    // Constructeur
    public RapportException(String idRapport, String typeAnomalie, String description, LocalDateTime dateSignalement, Individu auteur) {
        this.idRapport = idRapport;
        this.typeAnomalie = typeAnomalie;
        this.description = description;
        this.dateSignalement = dateSignalement;
        this.auteur = auteur;
    }

    // Getters
    public String getIdRapport() { return this.idRapport; }
    public String getTypeAnomalie() { return this.typeAnomalie; }
    public String getDescription() { return this.description; }
    public LocalDateTime getDateSignalement() { return this.dateSignalement; }
    public Individu getAuteur() { return this.auteur; }

    // Setters (Pas de setter pour idRapport)
    public void setTypeAnomalie(String typeAnomalie) { this.typeAnomalie = typeAnomalie; }
    public void setDescription(String description) { this.description = description; }
    public void setDateSignalement(LocalDateTime dateSignalement) { this.dateSignalement = dateSignalement; }
    public void setAuteur(Individu auteur) { this.auteur = auteur; }

    // toString
    @Override
    public String toString() {
        return "RapportException [ID=" + idRapport + " | Type=" + typeAnomalie + " | Auteur=" + auteur.getNom() + " " + auteur.getPrenom() + " | Date=" + dateSignalement + "]";
    }

    //Méthode pour envoyer une notification ou une alerte au responsable de la zone concernée
    public String genererRapportAlerte() {
        // On construit un gros bloc de texte en combinant nos variables et du texte brut
        String rapport = "=== ALERTE ANOMALIE ===\n"
                    + "Rapport ID : " + this.idRapport + "\n"
                    + "Type d'anomalie : " + this.typeAnomalie + "\n"
                    + "Date du signalement : " + this.dateSignalement + "\n"
                    + "Signalé par : " + this.auteur.getPrenom() + " " + this.auteur.getNom() + "\n"
                    + "Description : " + this.description + "\n"
                    + "=======================";
        
        // On renvoie la grande chaîne de caractères créée
        return rapport;
    }

    //Méthode pour générer un résumé textuel formaté de l'anomalie pour un e-mail
    public void notifierResponsable() {
        // On appelle notre méthode précédente pour générer le texte du mail
        String messageEmail = this.genererRapportAlerte();
        
        // On simule l'envoi au responsable en affichant le tout dans la console
        System.out.println("Notification envoyée au responsable de zone !");
        System.out.println(messageEmail);
    }
}