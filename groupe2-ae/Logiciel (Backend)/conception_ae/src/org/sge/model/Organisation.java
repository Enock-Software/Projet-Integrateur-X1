package org.sge.model;
//Cette classe comme Individu et Intervenant vont juste afficher une fiche Contact avec des informations
public class Organisation extends Intervenant{
    private String registreCommerce; //Numéro d'immatriculation ou RC
    private String typeOrganisation; // Nature de l'netité (Fournisseur, transporteur, Client Entreprise)

    //constructeur
    public Organisation(String idIntervenant, String nom, int telephone, String email, String adresse, String registreCommerce, String typeOrganisation){
        super(idIntervenant, nom, telephone, email, adresse);
        this.registreCommerce=registreCommerce;
        this.typeOrganisation=typeOrganisation;
    }
    //Getter
    public String getRegistreCommerce(){ return this.registreCommerce; }
    public String getTypeOrganisation(){ return this.typeOrganisation; }
    //Setter
    public void setRegistreCommerce(String registreCommerce){ this.registreCommerce=registreCommerce; }
    public void setTypeOrganisation(String typeOrganisation){ this.typeOrganisation=typeOrganisation; }

    @Override
    public String toString() {
        return "Organisation [ ID: " + getIdIntervenant() + " | Nom: " + getNom() + " | Registre de Commerce: " + registreCommerce + " | Téléphone: " + getTelephone() + " | Email: " + getEmail() + " | Adresse: " + getAdresse() + " | Type d'organisation: " + typeOrganisation + "]";
    }
}
