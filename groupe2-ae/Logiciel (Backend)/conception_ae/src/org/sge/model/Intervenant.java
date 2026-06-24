package org.sge.model;
//Cette classe comme Individu et Organisation vont juste afficher une fiche Contact avec des informations
public class Intervenant {
    //Les attributs en private pour respecter l'encapsulation
    private int idIntervenant;
    private String nom;
    private String telephone; //String est meilleure pour être en accord avec la base de données qui met le téléphone en VARCHAR(30)
    private String email;
    private String adresse;

    //Constructeur
    public Intervenant(int idIntervenant, String nom, String telephone, String email, String adresse){
        this.idIntervenant = idIntervenant;
        this.nom = nom;
        this.telephone = telephone;
        this.email = email;
        this.adresse = adresse;
    }
    //Getter, pour permettre la lecture des objects
    public int getIdIntervenant(){ return this.idIntervenant; }
    public String getNom(){ return this.nom; }
    public String getTelephone(){ return this.telephone; }
    public String getEmail(){ return this.email; }
    public String getAdresse(){ return this.adresse; }

    //Setter, pour permettre la modification des objects (Sauf les ID)
    public void setNom(String nom){ this.nom=nom; }
    public void setTelephone(String telephone){ this.telephone=telephone; }
    public void setEmail(String email){ this.email=email; }
    public void setAdresse(String adresse){ this.adresse=adresse; }

    //La méthode d'affichage
    @Override
    public String toString(){
        return "INTERVENANT [Id= "+ idIntervenant +" | Nom: " + nom +" | Téléphone: " + telephone +" | Email:" + email + " | Adresse:" + adresse + "]";
    }
}