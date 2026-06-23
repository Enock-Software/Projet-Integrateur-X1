package org.sge.model;

public class MaterielEmballage {
    private String idEmballage;
    private String typeMateriel; // Ex: Palette, Carton, Film plastique
    private boolean estRecupere;

    // Constructeur
    public MaterielEmballage(String idEmballage, String typeMateriel, boolean estRecupere) {
        this.idEmballage = idEmballage;
        this.typeMateriel = typeMateriel;
        this.estRecupere = estRecupere;
    }

    // Getters
    public String getIdEmballage() { return this.idEmballage; }
    public String getTypeMateriel() { return this.typeMateriel; }
    public boolean isEstRecupere() { return this.estRecupere; }

    // Setters (Pas de setter pour idEmballage)
    public void setTypeMateriel(String typeMateriel) { this.typeMateriel = typeMateriel; }
    public void setEstRecupere(boolean estRecupere) { this.estRecupere = estRecupere; }

    // toString
    @Override
    public String toString() {
        return "MaterielEmballage [ID=" + idEmballage + " | Type=" + typeMateriel + " | Récupéré=" + (estRecupere ? "Oui" : "Non") + "]";
    }

    //Méthode pour marquer le matériel comme réutilisé après un retour de livraison
    public void marquerCommeRecupere() {
        // On change l'état de la boîte pour dire que le matériel est bien récupéré
        this.estRecupere = true;
    }

    //Méthode pour vérifier si l'emballage est jetable ou consigné selon son type
    public boolean estConsigne() {
        // On vérifie si le type de matériel est une Palette
        if (this.typeMateriel.equalsIgnoreCase("Palette")) {
            return true;  // Oui, c'est un matériel consigné qu'on doit récupérer
        } else {
            return false; // Non, c'est un emballage jetable (Carton, Film, etc.)
        }
    }
}