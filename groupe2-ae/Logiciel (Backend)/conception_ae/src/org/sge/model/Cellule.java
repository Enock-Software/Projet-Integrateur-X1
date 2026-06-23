package org.sge.model;

public class Cellule {
    private String idCellule;
    private String zone; // Ex: Zone A (Frais), Zone B (Sec)
    private double hauteurMax;
    private double largeurMax;
    private double profondeurMax;
    private double masseMax;
    private String statut; // Ex: Vide, En cours de remplissage, Pleine, Bloquée

    // Constructeur
    public Cellule(String idCellule, String zone, double hauteurMax, double largeurMax, double profondeurMax, double masseMax, String statut) {
        this.idCellule = idCellule;
        this.zone = zone;
        this.hauteurMax = hauteurMax;
        this.largeurMax = largeurMax;
        this.profondeurMax = profondeurMax;
        this.masseMax = masseMax;
        this.statut = statut;
    }

    // Getters
    public String getIdCellule() { return this.idCellule; }
    public String getZone() { return this.zone; }
    public double getHauteurMax() { return this.hauteurMax; }
    public double getLargeurMax() { return this.largeurMax; }
    public double getProfondeurMax() { return this.profondeurMax; }
    public double getMasseMax() { return this.masseMax; }
    public String getStatut() { return this.statut; }

    // Setters (Pas de setter pour idCellule)
    public void setZone(String zone) { this.zone = zone; }
    public void setHauteurMax(double hauteurMax) { this.hauteurMax = hauteurMax; }
    public void setLargeurMax(double largeurMax) { this.largeurMax = largeurMax; }
    public void setProfondeurMax(double profondeurMax) { this.profondeurMax = profondeurMax; }
    public void setMasseMax(double masseMax) { this.masseMax = masseMax; }
    public void setStatut(String statut) { this.statut = statut; }

    // toString
    @Override
    public String toString() {
        return "Cellule [ID=" + idCellule + " | Zone=" + zone + " | Statut=" + statut + " | MasseMax=" + masseMax + "kg]";
    }

    // Méthode pour vérifier si un colis/produit respecte les dimensions et le poids max de la cellule avant de l'y placer
    public boolean peutContenir(double h, double l, double p, double poids) { 
        // On compare chaque dimension du colis avec le maximum de la cellule
        if (h <= this.hauteurMax && l <= this.largeurMax && p <= this.profondeurMax && poids <= this.masseMax) {
            return true;  // Le colis rentre parfaitement dans la cellule !
        } else {
            return false; // Le colis est trop grand ou trop lourd.
        }
    }

    // Méthode pour mettre à jour automatiquement le statut (ex: passe à "Pleine" si le poids max est presque atteint)
    public void mettreAJourStatut(double poidsActuel) {
        // Si le poids actuel atteint ou dépasse 90% de la masse max, on considère la cellule comme pleine
        if (poidsActuel >= this.masseMax * 0.9) {
            this.statut = "Pleine";
        } else if (poidsActuel == 0) {
            this.statut = "Vide";
        } else {
            this.statut = "En cours de remplissage";
        }
    }
}