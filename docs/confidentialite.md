# Confidentialité et préparation de la version publique

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document définit les précautions retenues pour présenter le projet
sans exposer les informations individuelles des élèves.

Le projet repose sur des données réelles et sa présentation est autorisée,
selon les informations communiquées par l’auteur.

Cette autorisation est distinguée de la redistribution des exports
nominatifs et des modèles contenant les données détaillées.

Les vérifications ci-dessous doivent être effectuées avant diffusion.
Leur documentation ne signifie pas qu’elles ont toutes déjà été réalisées.

---

## 1. Principe de publication

La version publique privilégie :

- les scripts Power Query et DAX ;
- les règles comptables et méthodologiques ;
- les contrôles et leurs conclusions non nominatives ;
- les indicateurs agrégés autorisés ;
- des exemples fictifs pour démontrer les vues individuelles.

Le nom de l’établissement n’est pas utilisé dans la présentation publique.

Les noms réels des élèves et leurs situations financières individuelles
ne sont pas destinés au dépôt public.

---

## 2. Version interne et version portfolio

| Élément | Version interne | Version portfolio |
|---|---|---|
| Identité des élèves | Disponible aux utilisateurs autorisés | Absente |
| Comptes tiers réels | Utilisés pour les rapprochements | Non publiés |
| Situations financières individuelles | Utilisées pour le suivi comptable | Remplacées par des exemples fictifs si nécessaires |
| Agrégats par classe ou niveau | Utilisés pour le pilotage | Diffusés uniquement dans le périmètre autorisé |
| Exports Sage réels | Conservés dans l’environnement autorisé | Non déposés |
| Code et documentation | Utilisés pour le traitement | Publiables après vérification |
| Rapport interactif nominatif | Accès contrôlé | Non accessible publiquement |

La version publique doit être préparée séparément afin de ne pas
modifier accidentellement les données ou le rapport de travail.

---

## 3. Informations sensibles à examiner

Les données du projet peuvent permettre d’identifier des élèves,
notamment mineurs, et de connaître leur situation financière.

Les éléments à examiner comprennent :

- noms et prénoms ;
- comptes tiers et autres identifiants individuels ;
- classe associée à une identité ;
- dates et montants de paiements individuels ;
- soldes restant à payer par élève ;
- coordonnées des familles, si présentes ;
- libellés ou commentaires contenant des informations personnelles ;
- chemins locaux, paramètres de connexion et métadonnées.

Un compte tiers peut rester identifiant même si le nom n’est pas affiché.

Des combinaisons de classe, date et montant peuvent également permettre
une réidentification dans certains contextes.

---

## 4. Masquage, pseudonymisation et données fictives

### Masquage visuel

Masquer une colonne ou superposer une forme dans un rapport ne supprime
pas les données du modèle.

Une annotation placée sur un PDF peut laisser le texte sous-jacent
consultable ou récupérable.

Le masquage visuel ne doit donc pas constituer l’unique protection
d’un fichier diffusé.

### Pseudonymisation

Remplacer les noms par des codes réduit l’identification directe,
mais ne garantit pas l’anonymat.

Si une correspondance avec les identités réelles existe, elle doit rester
hors du dépôt public et dans un environnement autorisé.

### Données fictives

Pour les vues individuelles, un jeu entièrement fictif est préférable.

Il peut utiliser des identifiants tels que :

```text
ELEVE_DEMO_001
ELEVE_DEMO_002
ELEVE_DEMO_003
```

Les montants, dates et situations individuelles de démonstration doivent
être préparés sans reproduire inutilement des dossiers réels identifiables.

Les exemples doivent être explicitement présentés comme fictifs.

---

## 5. Traitement des pages du rapport

| Page | Préparation publique attendue |
|---|---|
| Vue de synthèse | Indicateurs agrégés autorisés, sans identité individuelle |
| Progression académique | Évolutions agrégées, périodes et unités explicites |
| Analyse mensuelle | Montants par période et regroupement, sans détail identifiant |
| Situation individuelle | Démonstration sur données fictives |
| Suivi journalier | Démonstration fictive ou restitution agrégée non identifiante |

Même pour les vues agrégées, examiner les groupes de très faible effectif
et les combinaisons permettant de reconnaître un élève.

Si nécessaire, regrouper davantage les catégories ou ne pas diffuser
certaines cellules.

Les segments de recherche, listes déroulantes, infobulles et pages
de détail doivent également être vérifiés.

---

## 6. Préparation des captures

Avant d’enregistrer une capture destinée à GitHub :

1. Ouvrir la version préparée pour le portfolio.
2. Vérifier l’absence du nom de l’établissement.
3. Vérifier les tableaux, segments, infobulles et titres.
4. Retirer les identités et identifiants réels.
5. Vérifier l’absence de notifications ou d’informations personnelles
   provenant de l’environnement de travail.
6. Enregistrer l’image.
7. Rouvrir le fichier obtenu et l’examiner.

Ne pas réutiliser une ancienne capture nominative simplement parce
qu’une nouvelle version du rapport a été anonymisée.

Le fichier image effectivement déposé doit être contrôlé.

---

## 7. Préparation du PDF

Le PDF public doit être exporté depuis la version préparée pour diffusion.

Avant publication :

1. Vérifier toutes les pages.
2. Examiner les tableaux individuels et les listes de sélection.
3. Rechercher, dans le PDF, des identités connues de la version interne,
   sans publier ces recherches.
4. Vérifier le texte sélectionnable et copiable.
5. Examiner les propriétés et métadonnées.
6. Confirmer la cohérence avec les captures publiques.

Un simple rectangle ajouté après export n’est pas une méthode suffisante
si le texte original reste présent dans le document.

Les pages individuelles peuvent être remplacées par des exemples fictifs
ou retirées de l’export public.

---

## 8. Fichiers de données et modèles Power BI

### Exports Sage

Les fichiers réels E.txt, T.txt et G.txt restent hors du dépôt public,
selon la convention retenue pour ce projet.

Des fichiers d’exemple compatibles pourront être préparés séparément.

### PBIX

Un fichier PBIX en mode Import peut contenir les tables détaillées,
y compris les colonnes masquées et les données absentes des visuels.

Ne pas publier le modèle réel en supposant que les seules pages visibles
définissent son contenu.

### PBIT

Un fichier PBIT ne contient pas les données importées, mais il peut
contenir des requêtes, paramètres, chemins et valeurs inscrites
dans certaines définitions.

Il doit également être inspecté avant diffusion.

### Scripts et configuration

Les fichiers de code doivent utiliser des paramètres et des exemples
non sensibles.

Ne pas publier :

- mots de passe ;
- clés de récupération de passerelle ;
- jetons d’authentification ;
- chaînes de connexion contenant des secrets ;
- chemins révélant inutilement des informations personnelles.

---

## 9. Publication GitHub et Power BI

### GitHub

Le dépôt reste privé pendant la préparation.

Un dépôt public peut être consulté, téléchargé ou copié.
Le passage en public doit donc intervenir après vérification des fichiers
et de l’historique.

Un dépôt privé ne doit pas être utilisé comme coffre-fort pour
les mots de passe ou secrets techniques.

### Limites de .gitignore

Le fichier .gitignore définit des exclusions pour certains ajouts
effectués avec Git.

Il :

- ne retire pas les fichiers déjà suivis ;
- ne nettoie pas l’historique ;
- ne détecte pas le contenu sensible ;
- n’empêche pas toutes les méthodes d’ajout, notamment un téléversement
  manuel dans l’interface web.

Chaque fichier doit donc être vérifié avant son dépôt.

### Power BI

Le partage contrôlé et la publication publique sont différents.

Un lien « Share » dépend des autorisations et des licences.
Il ne doit pas être présenté comme un accès public anonyme.

La fonctionnalité « Publier sur le web », lorsqu’elle est disponible,
ne doit pas être utilisée pour le rapport interne nominatif.

Le code, les captures et le PDF suffisent à présenter le projet
sans rendre publiques les données individuelles.

---

## 10. Traçabilité des versions publiques

Pour chaque version diffusée, consigner :

| Information | À renseigner |
|---|---|
| Date de préparation | Date réelle |
| Version du rapport | Référence du modèle |
| Nature du support | Capture, PDF, code ou jeu fictif |
| Période illustrée | Période et date d’arrêté |
| Préparation réalisée | Retrait, agrégation ou remplacement fictif |
| Vérification effectuée | Points examinés |
| Référence GitHub | Commit ou version publiée |

Les captures contenant des données fictives doivent être distinguées
des indicateurs agrégés issus des données réelles.

Un jeu de démonstration peut produire des résultats différents.
Il ne doit pas être artificiellement ajusté pour reproduire
les résultats du rapport interne.

---

## 11. En cas de publication accidentelle

Si une information sensible est publiée :

1. Limiter immédiatement sa diffusion.
2. Identifier les fichiers, liens et versions concernés.
3. Informer les responsables compétents de l’établissement.
4. Retirer ou remplacer le contenu concerné.
5. Vérifier l’historique Git, pas seulement la version courante.
6. Révoquer les identifiants ou secrets éventuellement exposés.
7. Documenter l’incident et les actions correctives.

Supprimer un fichier de la dernière version ne le supprime pas
nécessairement de l’historique.

Des copies, téléchargements ou forks peuvent subsister après retrait.
Il ne faut donc pas supposer que la suppression annule toute exposition.

---

## 12. Liste de validation avant diffusion

- [ ] Périmètre de l’autorisation de publication vérifié.
- [ ] Nom de l’établissement retiré des supports publics prévus.
- [ ] Absence d’identité réelle d’élève.
- [ ] Absence de compte tiers réel directement identifiant.
- [ ] Absence de situation financière nominative réelle.
- [ ] Groupes de faible effectif et risques de réidentification examinés.
- [ ] Segments, infobulles et pages de détail vérifiés.
- [ ] PDF contrôlé, y compris le texte sous-jacent.
- [ ] Fichiers Power BI examinés avant diffusion éventuelle.
- [ ] Absence de secrets et de paramètres sensibles.
- [ ] Données fictives clairement identifiées.
- [ ] Historique du dépôt vérifié avant passage en public.
- [ ] Versions publiques cohérentes avec leur documentation.

Les cases sont à cocher après vérification effective.

Cette liste est un dispositif de préparation et de contrôle.
Elle ne constitue pas, à elle seule, une certification de conformité
à toutes les obligations applicables.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Méthodologie](methodologie.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Journal de contrôle qualité](controle-qualite.md)
- [Règles d’exclusion Git](../.gitignore)
