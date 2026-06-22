//C'est la fiche technique universelle d'un article. Elle ne contient pas de quantité, 
//juste ses propriétés physiques fixes.
package org.sge.model;

public class Produit {
    private String idProduit;
    private String designation;
    private String description;
    private String categorie;
    private double hauteur;
    private double largeur;
    private double profondeur;
    private double poidsUnitaire;

    //Constructeur
    public Produit(String idProduit, String designation, String description, String categorie, double hauteur, double largeur, double profondeur, double poidsUnitaire){
        this.idProduit=idProduit;
        this.designation=designation;
        this.description=description;
        this.categorie=categorie;
        this.hauteur=hauteur;
        this.largeur=largeur;
        this.profondeur=profondeur;
        this.poidsUnitaire=poidsUnitaire;
    }
    //Getter
    public String getIdProduit(){ return this.idProduit; }
    public String getDesignation(){ return this.designation; }
    public String getDescription(){ return this.description; }
    public String getCategorie(){ return this.categorie; }
    public double getHauteur(){ return this.hauteur; }
    public double getLargeur(){ return this.largeur; }
    public double getProfondeur(){ return this.profondeur; }
    public double getPoidsUnitaire(){ return this.poidsUnitaire; }
    //Setter
    public void setDesignation(String designation){ this.designation=designation; }
    public void setDescription(String description){ this.description=description; }
    public void setCategorie(String categorie){ this.categorie=categorie; }
    public void setHauteur(double hauteur){ this.hauteur=hauteur; }
    public void setLargeur(double largeur){ this.largeur=largeur; }
    public void setProfondeur(double profondeur){ this.profondeur=profondeur; }
    public void setPoidsUnitaire(double poidsUnitaire){ this.poidsUnitaire=poidsUnitaire; }

    public double calculerVolume(){
        return this.hauteur * this.largeur * this.profondeur;
    }
}
