package org.sge.service;
//Cette classe servira à gérer la remontée des anomalies et des alertes de l'entrepôt, faisant le lien avec l'IHM des Paramètres/Rapports.
import org.sge.model.RapportException;

public class IncidentService {

    // Traite un rapport saisi depuis l'IHM
    public boolean enregistrerAnomalie(RapportException rapport) {
        if (rapport.getTypeAnomalie() == null || rapport.getTypeAnomalie().isEmpty()) {
            return false;
        }
        // Simule la notification automatique définie dans ton modèle
        rapport.notifierResponsable();
        return true;
    }
}