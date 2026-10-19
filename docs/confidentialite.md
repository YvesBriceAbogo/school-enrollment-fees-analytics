# Confidentialité et préparation de la version publique

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document définit les précautions retenues pour présenter le projet
sans exposer les informations individuelles réelles des élèves.

Il distingue le modèle métier alimenté par les exports Sage,
les restitutions agrégées et les situations synthétiques utilisées
pour la démonstration publique.

La présentation du projet est autorisée, selon les informations
communiquées par l’auteur. Cette autorisation est distincte de
la redistribution des exports nominatifs et des modèles contenant
les données détaillées.

Les états d’avancement mentionnés reposent sur les confirmations
de l’auteur. La documentation des règles ci-dessous ne signifie
pas que toutes les vérifications ont déjà été réalisées.

---

## 1. Périmètre de publication

La version publique présente :

- les scripts Power Query et DAX préparés pour diffusion ;
- les règles comptables et méthodologiques ;
- les contrôles et leurs conclusions non nominatives ;
- les indicateurs agrégés autorisés ;
- les lignes entièrement synthétiques des vues individuelles ;
- une galerie de huit captures représentant les cinq dashboards.

Le nom de l’établissement n’est pas utilisé dans la présentation publique.

Les identités réelles, les comptes tiers réels et les situations
financières individuelles réelles ne sont pas destinés au dépôt public.

La galerie repose sur des images PNG accompagnées de descriptions.
Elle ne nécessite pas la publication des exports Sage, du modèle métier
ou d’un accès interactif public.

[Consulter la galerie du rapport](../images/README.md)

---

## 2. Version interne et version portfolio

| Élément | Version interne | Version portfolio |
|---|---|---|
| Identités réelles des élèves | Accessibles aux utilisateurs autorisés | Non publiées |
| Comptes tiers réels | Utilisés pour les rapprochements | Non publiés |
| Situations financières individuelles | Utilisées pour le suivi comptable | Lignes entièrement synthétiques dans les dashboards 4 et 5 |
| Agrégats par classe, niveau ou section | Utilisés pour le pilotage | Diffusés dans le périmètre autorisé |
| Exports Sage réels | Conservés dans l’environnement autorisé | Non déposés |
| Code et documentation | Utilisés pour le traitement | Publiables après examen des éléments sensibles |
| Rapport interactif nominatif | Accès contrôlé | Non accessible publiquement |
| Captures de présentation | Selon les besoins internes | PNG préparés pour la galerie publique |

La version de présentation doit être préparée séparément afin de ne pas
modifier accidentellement les données ou le rapport de travail.

Les fichiers contenant des données réelles doivent rester dans
un emplacement autorisé, distinct des fichiers préparés pour publication.

Le remplacement des données de démonstration ne modifie pas rétroactivement
la nature des sources ni les résultats de la campagne de tests métier.

---

## 3. Informations sensibles à examiner

Les données du modèle métier peuvent permettre d’identifier des élèves,
notamment mineurs, et de connaître leur situation financière.

Les éléments à examiner comprennent :

- noms et prénoms réels ;
- comptes tiers et autres identifiants individuels ;
- classe associée à une identité ;
- dates et montants de paiements individuels ;
- soldes restant à payer par élève ;
- coordonnées des familles, si présentes ;
- libellés ou commentaires contenant des informations personnelles ;
- chemins locaux, paramètres de connexion et métadonnées ;
- tables ou fichiers de correspondance entre identités réelles
  et identifiants de présentation.

Un compte tiers peut rester identifiant même si le nom n’est pas affiché.

Des combinaisons de classe, date et montant peuvent également permettre
une réidentification dans certains contextes.

L’absence du nom de l’établissement ne suffit donc pas, à elle seule,
à rendre des données individuelles anonymes ou fictives.

---

## 4. Masquage, pseudonymisation et données synthétiques

### Masquage visuel

Masquer une colonne ou superposer une forme dans un rapport ne supprime
pas les données du modèle.

Une annotation placée sur un PDF peut laisser le texte sous-jacent
consultable ou récupérable.

Le masquage visuel ne doit donc pas constituer l’unique protection
d’un fichier diffusé.

### Pseudonymisation

Remplacer des noms par des codes ou des prénoms fictifs réduit
l’identification directe, mais ne transforme pas les autres données
en informations synthétiques.

Une situation réelle dont seul le nom a été remplacé reste une situation
réelle pseudonymisée.

Toute correspondance avec les identités réelles doit rester hors
du dépôt public et dans un environnement autorisé.

### Données synthétiques retenues pour la démonstration

L’auteur a confirmé que les lignes individuelles présentées dans
les dashboards 4 et 5 sont entièrement synthétiques.

Elles ne reproduisent aucune situation réelle d’élève.
Leur préparation ne se limite pas au remplacement des noms :
les attributs et opérations individuels constituent des exemples
de démonstration.

Le champ affiché sous le libellé « Noms » utilise des prénoms fictifs.
Ces prénoms sont des libellés de présentation, et non des clés
de jointure.

Si des identifiants de démonstration sont nécessaires, ils doivent
également être fictifs, par exemple :

```text
ELEVE_DEMO_001
ELEVE_DEMO_002
ELEVE_DEMO_003
```

Les descriptions publiques doivent identifier explicitement
les situations synthétiques et les distinguer des agrégats issus
du modèle métier.

---

## 5. Traitement des pages du rapport

La galerie constituée comprend huit captures.

| Page | Nombre de captures | Nature de la présentation publique |
|---|---:|---|
| Dashboard 1 — Vue de synthèse | 4 | Répartitions agrégées pour les quatre indicateurs du sélecteur « Mesures » |
| Dashboard 2 — Évolution mensuelle | 1 | Cumuls agrégés de scolarité, de règlements et de solde |
| Dashboard 3 — Détails mensuels | 1 | Mouvements par période, niveau et classe |
| Dashboard 4 — Situation individuelle | 1 | Lignes individuelles entièrement synthétiques |
| Dashboard 5 — Suivi journalier | 1 | Lignes individuelles et opérations entièrement synthétiques |
| **Total** | **8** | |

Les quatre variantes de Dashboard 1 représentent quatre sélections
d’indicateur sur une même page, et non quatre pages supplémentaires.

Même pour les vues agrégées, les groupes de très faible effectif
et les combinaisons permettant de reconnaître un élève doivent
être examinés.

Selon le contexte et le périmètre autorisé, il peut être nécessaire
de regrouper davantage les catégories ou de ne pas diffuser
certaines cellules.

Les segments de recherche, listes déroulantes, infobulles et pages
de détail font également partie du périmètre à examiner pour
tout support interactif ou nouvel export.

---

## 6. Préparation des captures PNG

Les captures de la galerie doivent provenir de la version préparée
pour la présentation publique.

Pour chaque nouvelle capture ou remplacement de fichier :

1. Ouvrir la version de présentation.
2. Vérifier les tableaux, segments, titres et éventuelles infobulles.
3. Vérifier l’absence du nom de l’établissement et des identités
   ou identifiants réels.
4. Utiliser les lignes synthétiques pour les vues individuelles.
5. Vérifier l’absence de notifications ou d’informations personnelles
   provenant de l’environnement de travail.
6. Enregistrer uniquement la zone utile au format PNG.
7. Rouvrir le fichier obtenu et examiner le support effectivement
   destiné au dépôt.

Ne pas réutiliser une ancienne capture nominative simplement parce
qu’une nouvelle version du rapport a été préparée pour diffusion.

La vérification porte sur le fichier déposé, et pas uniquement
sur l’apparence actuelle du rapport Power BI.

Les captures synthétiques doivent être identifiées comme telles
dans leur description. Si une image est diffusée indépendamment
de la galerie, cette indication doit l’accompagner.

---

## 7. Diffusion éventuelle d’un PDF

La galerie actuelle repose sur des PNG.
L’ajout d’un PDF n’est pas nécessaire pour la compléter.

Cette section s’applique si un PDF public est préparé ultérieurement.

Le PDF doit être exporté depuis la version destinée à la diffusion,
avec les lignes synthétiques pour les pages individuelles.

Avant publication :

1. Vérifier toutes les pages exportées.
2. Examiner les tableaux individuels et les listes de sélection.
3. Rechercher localement des identités connues de la version interne,
   sans publier ces recherches.
4. Vérifier le texte sélectionnable, copiable et extractible.
5. Examiner les propriétés et métadonnées.
6. Confirmer la cohérence avec la version publique documentée.

Un simple rectangle ajouté après export n’est pas une méthode suffisante
si le texte original reste présent dans le document.

Le contrôle visuel d’un PDF ne démontre pas, à lui seul,
l’absence d’informations récupérables dans le fichier.

---

## 8. Fichiers de données et modèles Power BI

### Exports Sage

Les fichiers réels E.txt, T.txt et G.txt restent hors du dépôt public,
selon le périmètre retenu pour ce projet.

Des fichiers d’exemple compatibles peuvent être préparés séparément
sur des données synthétiques.

La publication de tels exemples doit préciser leur nature,
leur structure et leurs limites d’utilisation.

### PBIX

Un fichier PBIX en mode Import peut contenir les tables détaillées,
y compris les colonnes masquées et les données absentes des visuels.

Le modèle métier contenant les données réelles n’est pas destiné
au dépôt public.

Le caractère synthétique des lignes visibles des dashboards 4 et 5
ne démontre pas que l’ensemble du modèle est prêt à être diffusé.

Si un PBIX de démonstration est publié ultérieurement, l’examen doit
porter sur l’ensemble des tables, requêtes, paramètres et propriétés,
et pas seulement sur les pages visibles.

### PBIT

Un fichier PBIT ne contient pas le cache des données importées,
mais conserve notamment la définition du modèle, les requêtes
et les paramètres.

Des chemins, valeurs sensibles ou données inscrites directement
dans des requêtes ou des tables saisies manuellement peuvent subsister.

Un PBIT doit donc également être inspecté avant diffusion.

### Scripts et configuration

Les fichiers de code doivent utiliser des paramètres et des exemples
non sensibles.

Ne pas publier :

- mots de passe ;
- clés de récupération de passerelle ;
- jetons d’authentification ;
- chaînes de connexion contenant des secrets ;
- identités ou comptes tiers réels inscrits dans le code ;
- chemins révélant inutilement des informations personnelles ;
- tables de correspondance avec les identités réelles.

La publication du code n’exige pas la publication des données
utilisées pour les tests métier.

---

## 9. Publication GitHub et Power BI

### GitHub — Dépôt déjà public

Le projet est présenté dans un dépôt GitHub public, d’après l’état
communiqué par l’auteur.

La préparation de nouveaux supports doit donc être effectuée
avant leur ajout au dépôt.

Un fichier enregistré dans une branche publique peut être consulté,
téléchargé ou copié. Une branche dédiée ou une pull request
dans ce dépôt ne constitue pas un espace confidentiel.

Il ne faut pas déposer temporairement des données sensibles
en prévoyant de les supprimer ensuite.

L’examen doit porter sur les fichiers courants et sur les versions
antérieures susceptibles de rester accessibles dans l’historique.

Un dépôt privé ne doit pas non plus être utilisé comme coffre-fort
pour les mots de passe ou secrets techniques.

### Limites de .gitignore

Le fichier .gitignore définit des exclusions pour certains fichiers
non suivis lors des opérations Git.

Il :

- ne retire pas les fichiers déjà suivis ;
- ne nettoie pas l’historique ;
- ne détecte pas le contenu sensible ;
- n’empêche pas toutes les méthodes d’ajout, notamment un téléversement
  manuel dans l’interface web.

Chaque fichier doit donc être examiné avant son dépôt.
Le seul fait qu’une règle d’exclusion existe ne démontre pas
l’absence du fichier concerné dans GitHub.

### Power BI

Le partage contrôlé et la publication publique sont différents.

Un lien de partage Power BI dépend des autorisations et des licences.
Il ne doit pas être présenté comme un accès public anonyme.

La fonctionnalité « Publier sur le web », lorsqu’elle est disponible,
ne doit pas être utilisée pour le modèle métier contenant
des informations individuelles réelles.

La présence des captures sur GitHub ne constitue pas un déploiement
du rapport dans Power BI Service.

La documentation, le code et la galerie suffisent à présenter
le projet sans rendre publiques les données individuelles réelles.

---

## 10. Traçabilité des versions publiques

### Avancement communiqué

| Élément | État consigné |
|---|---|
| Galerie de huit captures | Intégration confirmée par l’auteur |
| Descriptions dans `images/README.md` | Intégration confirmée par l’auteur |
| README principal et dictionnaire | Actualisation confirmée par l’auteur |
| Journal de contrôle qualité | Actualisation confirmée par l’auteur |
| Nature synthétique des lignes des dashboards 4 et 5 | Confirmée par l’auteur |

Ces confirmations documentent l’avancement.
Elles ne constituent pas un audit exhaustif du contenu du dépôt.

### Informations à conserver pour chaque version

| Information | Contenu attendu |
|---|---|
| Date de préparation ou de mise à jour | Date réelle |
| Version du rapport | Référence du modèle utilisé |
| Nature du support | PNG, documentation, code, PDF ou modèle de démonstration |
| Nature des données | Agrégats issus du modèle métier ou données synthétiques |
| Période illustrée | Période et date d’arrêté |
| Préparation réalisée | Agrégation, retrait d’informations ou création synthétique |
| Vérification effectuée | Périmètre examiné, résultat et responsable |
| Référence GitHub | Commit ou version publiée |

Les références de publication sont à consigner dans le
[journal de contrôle qualité](controle-qualite.md).

Les références de la campagne de tests métier doivent rester
distinctes des commits de publication de la galerie.

Les résultats d’un jeu synthétique peuvent différer de ceux
du modèle métier. Une similitude de totaux ne suffit pas à démontrer
l’identité des données ou la validation des calculs.

Les conclusions des tests métier ne sont pas automatiquement
transposées à la version de démonstration.

---

## 11. En cas de publication accidentelle

Si une information sensible est publiée :

1. Limiter immédiatement sa diffusion et suspendre les liens
   ou partages concernés lorsque cela est possible.
2. Identifier les fichiers, emplacements et versions exposés.
3. Informer les responsables compétents de l’établissement.
4. Révoquer ou renouveler sans attendre les secrets techniques
   éventuellement exposés.
5. Retirer ou remplacer les contenus concernés.
6. Examiner l’historique Git et traiter les versions antérieures,
   pas seulement la version courante.
7. Documenter l’incident, son périmètre et les actions correctives.

Un nettoyage de l’historique doit être préparé et coordonné,
notamment si d’autres personnes utilisent le dépôt.

Supprimer un fichier de la dernière version ne le supprime pas
nécessairement de l’historique.

Des copies, téléchargements ou forks peuvent subsister après retrait.
Il ne faut donc pas supposer que la suppression du fichier
ou le passage du dépôt en privé annule toute exposition.

---

## 12. Liste de validation des supports publics

Cette liste s’applique aux supports effectivement diffusés
et à leurs mises à jour.

- [ ] Périmètre de l’autorisation de publication vérifié.
- [ ] Nom de l’établissement absent des supports publics.
- [ ] Absence d’identité réelle d’élève.
- [ ] Absence de compte tiers réel ou de correspondance d’identité.
- [ ] Absence de situation individuelle réelle identifiable.
- [ ] Groupes de faible effectif et risques de réidentification examinés.
- [ ] Lignes des vues individuelles préparées sur des données synthétiques.
- [ ] Nature synthétique clairement indiquée dans les descriptions.
- [ ] Segments, infobulles et pages de détail examinés selon le support.
- [ ] Fichiers PNG effectivement déposés examinés.
- [ ] Absence de secrets et de paramètres sensibles dans le code.
- [ ] Historique du dépôt et versions antérieures examinés.
- [ ] Versions publiques cohérentes avec leur documentation.
- [ ] Références de publication consignées.

### Vérifications conditionnelles

À appliquer uniquement si les supports correspondants sont diffusés :

- [ ] PDF contrôlé, y compris le texte extractible et les métadonnées.
- [ ] Fichiers Power BI examinés dans leur ensemble avant publication.
- [ ] Jeux de données d’exemple contrôlés et identifiés comme synthétiques.
- [ ] Modalités d’accès interactif vérifiées avant tout partage public.

Pour un support non diffusé, noter « Non applicable » dans le suivi
plutôt que déclarer son contrôle réalisé.

Les cases sont à cocher après vérification effective.
La confirmation d’un téléversement ne suffit pas à les cocher
automatiquement.

Cette liste constitue un dispositif de préparation et de contrôle.
Elle ne représente pas, à elle seule, une certification de conformité
à toutes les obligations applicables.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Galerie du rapport](../images/README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Méthodologie](methodologie.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Journal de contrôle qualité](controle-qualite.md)
- [Déploiement](deploiement.md)
- [Règles d’exclusion Git](../.gitignore)
