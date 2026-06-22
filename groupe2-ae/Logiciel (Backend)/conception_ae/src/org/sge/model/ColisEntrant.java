package org.sge.model;

public class ColisEntrant {
    private String idColis;
    private Produit produit;
    private int quantite;
    private boolean estEndomage;

    // Constructeur
    public ColisEntrant(String idColis, Produit produit, int quantite, boolean estEndomage) {
        this.idColis = idColis;
        this.produit = produit;
        this.quantite = quantite;
        this.estEndomage = estEndomage;
    }

    // Getters
    public String getIdColis() { return this.idColis; }
    public Produit getProduit() { return this.produit; }
    public int getQuantite() { return this.quantite; }
    public boolean isEstEndomage() { return this.estEndomage; }

    // Setters (Pas de setter pour idColis)
    public void setProduit(Produit produit) { this.produit = produit; }
    public void setQuantite(int quantite) { this.quantite = quantite; }
    public void setEstEndomage(boolean estEndomage) { this.estEndomage = estEndomage; }

    // toString
    @Override
    public String toString() {
        return "ColisEntrant [ID=" + idColis + " | Produit=" + produit.getDesignation() + " | Qté=" + quantite + " | Endommagé=" + (estEndomage ? "Oui" : "Non") + "]";
    }

    // Méthode pour calculer le volume total du colis (Qté * volume unitaire du produit)
    public double calculerVolumeTotal() { 
        return this.quantite * this.produit.calculerVolume();
    }

    // Méthode pour calculer le poids total du colis (Qté * poids unitaire du produit)
    public double calculerPoidsTotal() { 
        return this.quantite * this.produit.getPoidsUnitaire();
    }
}