# Déploiement et actualisation du rapport

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Le rapport métier est déjà publié dans Power BI Service.
Une passerelle de données locale en mode standard a été configurée
par l’auteur pour l’accès aux sources locales.

Ce document décrit le déploiement communiqué, son fonctionnement
et les opérations nécessaires à sa maintenance.

Il distingue :

- les contrôles exécutés sur la version testée du modèle ;
- les vérifications propres à la version publiée dans Power BI Service ;
- les supports de présentation du dépôt GitHub public.

Les informations de configuration non encore consignées doivent être
complétées à partir des paramètres et historiques réellement utilisés.

---

## 1. État du déploiement

| Élément | Situation documentée |
|---|---|
| Rapport Power BI | Publication dans Power BI Service confirmée par l’auteur |
| Modèle sémantique | Publié avec le rapport |
| Passerelle | Mode standard, configuration confirmée par l’auteur |
| Sources | Exports TXT locaux de Sage Saari version 15 |
| Contrôles Power Query | Exécutés sur la version testée ; résultats consignés dans le journal |
| Scénarios DAX | Exécutés sur `suivi-scolarite-tests` ; résultats consignés |
| Correspondance entre version testée et version publiée | À documenter |
| Actualisation planifiée | Paramètres effectifs à consigner, si utilisée |
| Dernière actualisation réussie | À renseigner depuis l’historique du Service |
| Publication publique anonyme | « Publier sur le web » non activé dans l’environnement communiqué |
| Partage du rapport opérationnel | Accès contrôlé, selon les autorisations et licences |
| Portfolio GitHub | Dépôt public avec documentation, code et galerie de huit captures |

La publication du rapport et la configuration de la passerelle
sont des étapes réalisées selon les confirmations de l’auteur.

Elles ne démontrent pas, à elles seules :

- la réussite de la dernière actualisation ;
- la fraîcheur des exports chargés ;
- l’identité entre le modèle testé et le modèle actuellement publié.

Les réglages non renseignés ne doivent pas être interprétés
comme absents de l’environnement.

---

## 2. Architecture en place

### Préparation et publication

```text
Sage Saari version 15
        ↓ Export
G.txt, T.txt et E.txt
        ↓
Power BI Desktop
Power Query → Modèle → DAX → Rapport
        ↓ Contrôles et tests
Version préparée pour publication
        ↓ Publication
Modèle sémantique et rapport dans Power BI Service
```

### Actualisation dans le Service

```text
Power BI Service
        ↓ Demande d’actualisation
Passerelle standard
        ↓ Lecture
Exports TXT accessibles depuis la machine de la passerelle
        ↓ Transfert et traitement
Modèle sémantique actualisé
        ↓
Rapport utilisant les dernières données chargées
```

La passerelle assure l’accès aux fichiers.
Elle ne génère pas les exports Sage et ne lance pas automatiquement
l’application comptable.

### Présentation publique

```text
Version préparée pour le portfolio
        ↓ Captures PNG
Galerie GitHub et descriptions
```

GitHub conserve le code, la documentation et les supports publics.
Il ne déclenche pas automatiquement l’export Sage, l’actualisation
du modèle ou la publication dans Power BI Service.

---

## 3. Sources et paramètres

### Fichiers utilisés

| Fichier | Contenu |
|---|---|
| G.txt | Référentiel des comptes généraux |
| T.txt | Référentiel des comptes tiers élèves |
| E.txt | Écritures comptables |

Le paramètre `pDossierSource` centralise l’emplacement des fichiers
dans les scripts documentés.

Exemple non sensible :

```text
C:\PowerBI\school-fees\data
```

Le chemin réel reste configuré dans l’environnement autorisé.
La construction des chemins complets doit correspondre aux requêtes
effectivement utilisées.

### Formats documentés

| Fichier | Format de lecture |
|---|---|
| G.txt | Virgule ; Windows-1252 pour l’export annoncé ANSI |
| T.txt | Virgule ; UTF-8 |
| E.txt | Virgule ; Windows-1252 ; date source JJMMAA |

Les structures fournies ne comportent pas d’en-tête.

Une évolution du séparateur, de l’encodage, de l’ordre des colonnes
ou du format des valeurs nécessite une vérification des transformations
avant actualisation de la version publiée.

### Préparation des nouveaux exports

Avant une actualisation :

1. Produire un ensemble cohérent d’exports depuis Sage.
2. Conserver la période nécessaire aux analyses et aux cumuls.
3. Terminer l’enregistrement des trois fichiers.
4. Vérifier leur emplacement et leur nom.
5. Confirmer leur disponibilité pour la passerelle.
6. Éviter leur modification pendant la lecture par Power BI.

Les scripts lisent des fichiers précis.
Ils ne combinent pas automatiquement plusieurs extractions successives.

Une extraction limitée aux nouveaux mouvements ne remplace pas,
à elle seule, l’historique nécessaire aux cumuls académiques.

Ne pas concaténer des exports couvrant les mêmes opérations sans règle
explicite, au risque de dupliquer les écritures.

---

## 4. Connexions de passerelle

### Configuration existante

La passerelle standard est déjà configurée.
Il n’est pas nécessaire de la recréer pour actualiser la documentation.

Les requêtes documentées utilisent `File.Contents` pour lire
les trois fichiers.

Le paramètre commun de dossier ne transforme pas ces lectures
en un connecteur unique de type Dossier.

Les associations doivent correspondre aux sources réellement détectées
par Power BI Service :

| Source documentée | Type de connexion attendu |
|---|---|
| Chemin complet de G.txt | Fichier |
| Chemin complet de T.txt | Fichier |
| Chemin complet de E.txt | Fichier |

Les trois connexions peuvent utiliser la même passerelle.

### Vérification des connexions

Dans Power BI Service, ouvrir :

```text
Paramètres
→ Gérer les connexions et les passerelles
```

Vérifier au besoin :

- l’état de la passerelle ;
- les connexions associées aux fichiers ;
- les chemins configurés ;
- les identifiants et autorisations de lecture ;
- les droits d’utilisation des connexions.

Dans les paramètres du modèle sémantique, examiner :

```text
Connexions de passerelle et connexions cloud
```

Vérifier l’association de chaque source à la connexion correspondante.

Les intitulés peuvent varier selon l’évolution de l’interface.

Une modification de `pDossierSource` nécessite de vérifier les chemins
évalués et leurs associations, pas seulement la valeur du paramètre
dans Power BI Desktop.

### Disponibilité des fichiers

Dans une actualisation effectuée par la passerelle, un chemin
commençant par `C:\` désigne le disque de la machine qui l’héberge.

Si Power BI Desktop et la passerelle fonctionnent sur des machines
différentes, la présence du fichier sur le poste de travail ne suffit pas.

Un fichier lu depuis un dossier OneDrive synchronisé par un chemin
local reste une source locale dans cette configuration.

Il doit être effectivement disponible pour la lecture,
et pas uniquement représenté par un fichier à télécharger à la demande.

La documentation publique ne doit contenir aucun identifiant Windows
sensible, mot de passe ou clé de récupération de passerelle.

---

## 5. Actualisation des données

### Actualisation manuelle

Pour mettre à jour ou vérifier le modèle :

1. Confirmer que les exports Sage ont été enregistrés.
2. Ouvrir le modèle sémantique concerné dans Power BI Service.
3. Sélectionner « Actualiser maintenant ».
4. Consulter l’historique des actualisations.
5. Vérifier le statut et les éventuels messages d’erreur.
6. Examiner les indicateurs attendus avec les filtres appropriés.
7. Consigner les éléments utiles dans le suivi d’exploitation.

La vérification porte sur le modèle de ce projet,
et non uniquement sur la disponibilité générale de la passerelle.

Une actualisation réussie ne remplace pas les contrôles métier
ni les tests des mesures et des interactions.

### Actualisation planifiée

Les réglages effectifs sont à consigner dans la fiche de déploiement :

- fréquence ;
- horaires ;
- fuseau horaire ;
- notifications d’échec.

Pour un environnement situé au Cameroun, le fuseau horaire
à prendre en compte est UTC+01:00.
Le réglage effectif du Service doit être vérifié.

Les horaires doivent être compatibles avec :

- la production des exports ;
- la disponibilité de la machine de la passerelle ;
- l’accès aux fichiers ;
- les limites applicables à la licence et à la capacité.

Si la planification fonctionne déjà, il n’est pas nécessaire
de la modifier pour correspondre à un exemple documentaire.

### Fraîcheur des données

Une actualisation Power BI réussie peut charger des données inchangées
si les exports Sage n’ont pas été renouvelés.

La date d’extraction des sources doit donc être distinguée
de la date d’actualisation du modèle.

La réussite technique ne démontre pas non plus l’exhaustivité
de la période chargée.

---

## 6. Conditions de fonctionnement

Pour actualiser les sources locales :

- la machine de la passerelle doit être allumée ;
- elle doit disposer d’un accès Internet ;
- elle ne doit pas être en veille ou en veille prolongée ;
- le service de passerelle doit fonctionner ;
- les fichiers doivent rester accessibles ;
- les identifiants configurés doivent être valides ;
- les droits de lecture nécessaires doivent être disponibles.

La passerelle standard fonctionne comme un service Windows.
Power BI Desktop n’a pas besoin de rester ouvert.

Une session interactive n’est normalement pas nécessaire au service.
Les dépendances à une synchronisation de fichiers ou à un accès réseau
doivent toutefois être vérifiées.

Lorsque la machine de la passerelle est éteinte,
les sources locales ne peuvent pas être actualisées par celle-ci.

Un rapport en mode Import peut rester consultable dans le Service
avec les dernières données chargées, sous réserve des autorisations
et de la disponibilité du service.

---

## 7. Gestion des versions et mises à jour fonctionnelles

La version publiée, la version testée et les scripts présents
dans GitHub doivent être rapprochés explicitement.

Un script révisé enregistré dans GitHub ne remplace pas automatiquement
la formule ou la requête du modèle déjà publié.

L’actualisation des données ne récupère pas non plus les modifications
DAX, les relations ou les visuels d’un fichier Desktop local.

### Procédure de mise à jour fonctionnelle

1. Conserver une copie de la version de travail dans un emplacement autorisé.
2. Intégrer les modifications dans Power BI Desktop.
3. Rejouer les contrôles concernés.
4. Tester les mesures et interactions affectées.
5. Consigner les résultats et expliquer les écarts éventuels.
6. Publier la version retenue dans l’espace de travail approprié.
7. Vérifier les connexions et l’actualisation après publication.
8. Vérifier les résultats dans la version du Service.
9. Mettre à jour les références de version et les supports publics concernés.

Les références du code, du modèle et des données doivent rester
distinctes des commits de publication des captures.

Le modèle contenant les données réelles reste dans l’environnement
autorisé ; il n’est pas déposé dans GitHub.

### Nature des modifications

| Modification | Action attendue |
|---|---|
| Nouvelles données, même structure | Renouveler les exports puis actualiser |
| Nouveau format TXT | Adapter et tester les requêtes avant mise en service |
| Changement de chemin | Vérifier les paramètres, les accès et les connexions |
| Modification DAX, relations ou visuels dans Desktop | Tester puis publier la version correspondante |
| Modification du référentiel scolaire | Vérifier les classifications et les effets historiques |
| Modification du code GitHub | Intégrer explicitement le changement dans Power BI si nécessaire |
| Modification de la documentation ou de la galerie | Aucun changement automatique du modèle publié |

Les captures PNG et les éventuels PDF sont statiques.
Ils ne se mettent pas automatiquement à jour avec le modèle sémantique.

Une mise à jour purement documentaire ne nécessite pas
de republier le rapport.

---

## 8. Dates et lecture du rapport

Le projet distingue :

- la date d’extraction Sage ;
- la dernière date d’écriture disponible ;
- la date d’exécution des tests ;
- la date d’actualisation Power BI ;
- le mois sélectionné pour l’analyse.

Ces dates ne sont pas nécessairement identiques.

Le calendrier couvre des cycles académiques complets.
Il peut contenir des dates sans opérations.

### Conventions des mesures cumulatives

Les mesures documentées prévoient :

- une seule année académique dans le contexte ;
- un cumul depuis le 1er août ;
- un arrêté à la fin du mois sélectionné ;
- le dernier mois comme arrêté si plusieurs mois du même cycle
  sont sélectionnés ;
- une valeur vide pour un mois postérieur au dernier mois
  contenant des écritures.

Une carte vide peut donc provenir du contexte de sélection,
et pas nécessairement d’un échec d’actualisation.

Les cartes arrêtées en fin de mois ne doivent pas être interprétées
comme une situation à la fin de la journée sélectionnée
sur la page journalière.

### Situation de référence et évolution

Les captures de la galerie utilisent octobre 2025 comme situation
de référence pour les cartes.

Les visuels d’évolution peuvent présenter plusieurs mois disponibles,
selon le fonctionnement documenté dans la galerie.

La date affichée dans une capture statique ne constitue pas
une preuve de fraîcheur du modèle actuellement publié.

La dernière date d’écriture relevée lors des tests était le 02/04/2026.
Ce repère ne doit pas être assimilé automatiquement au contenu
actuellement chargé dans Power BI Service.

La dernière date disponible ne garantit pas que le dernier mois
soit complet.

---

## 9. Partage et confidentialité

### Rapport opérationnel

Le rapport contenant les données réelles est destiné
à un environnement autorisé, avec des accès adaptés.

La publication dans Power BI Service n’équivaut pas
à une publication anonyme sur Internet.

La fonctionnalité « Publier sur le web » n’est pas activée
dans l’environnement communiqué par l’auteur.
Elle ne doit pas être utilisée pour le modèle métier contenant
des informations individuelles réelles.

Un partage via « Partager » dépend des autorisations et des licences.
La présence d’un lien ne garantit pas l’accès du destinataire.

### Portfolio GitHub

Le dépôt public présente le code, la documentation
et une galerie de huit captures :

| Pages | Présentation publique |
|---|---|
| Dashboard 1 | Quatre variantes agrégées de la vue de synthèse |
| Dashboards 2 et 3 | Évolutions et détails agrégés |
| Dashboards 4 et 5 | Lignes individuelles entièrement synthétiques |

L’auteur a confirmé que les lignes synthétiques ne reproduisent
aucune situation réelle d’élève.
Il ne s’agit pas seulement d’un remplacement des noms.

Cette qualification concerne les supports de démonstration.
Elle ne requalifie pas les sources métier ni la version testée.

Le PDF n’est pas nécessaire pour compléter la galerie.
S’il est publié ultérieurement, il doit être préparé et examiné
séparément, y compris son texte extractible et ses métadonnées.

### Fichiers Power BI

Un PBIX en mode Import peut contenir les données détaillées,
y compris les colonnes absentes des visuels.

Un PBIT ne contient pas le cache des données importées,
mais peut conserver des requêtes, paramètres, chemins
et valeurs inscrites dans les définitions.

Le caractère synthétique des lignes visibles de deux pages
ne démontre pas que l’ensemble du modèle est prêt à être diffusé.

Les exports réels, les correspondances d’identité et le modèle
contenant les données détaillées restent hors du dépôt public.

[Consulter les règles de confidentialité](confidentialite.md)

---

## 10. Suivi des incidents

| Symptôme | Vérifications prioritaires |
|---|---|
| Passerelle hors connexion | Machine, réseau, veille et service Windows |
| Fichier introuvable | Chemin évalué, nom et disponibilité sur la machine de la passerelle |
| Accès refusé | Identifiants, autorisations de lecture et droits d’utilisation des connexions |
| Source non associée après une modification | Paramètres, sources détectées et associations de passerelle |
| Accents incorrects | Encodage de l’export |
| Erreur de date | Format source, année sur deux chiffres et conversion |
| Erreur de montant | Valeur, format du champ et typage |
| Niveau manquant | Correspondance du compte tiers et classification |
| Lignes multipliées | Unicité des référentiels et jointures |
| Carte cumulative vide | Cycle, mois sélectionné et période disponible |
| Actualisation réussie mais données anciennes | Date et contenu des exports Sage |
| Résultats différents entre Desktop et Service | Versions, sources, paramètres, filtres et droits d’accès |

Les contrôles ne doivent pas être désactivés uniquement pour faire
réussir une actualisation.

Pour chaque incident, consigner le périmètre, le message d’erreur,
la cause identifiée, la correction et le résultat du nouveau contrôle.

Les éléments de diagnostic contenant des identités, chemins sensibles
ou secrets restent dans l’environnement interne autorisé.

---

## 11. Fiche du déploiement existant

### Version publiée et exploitation

| Élément | Situation ou information à compléter |
|---|---|
| Publication Power BI Service | Réalisée, confirmée par l’auteur |
| Passerelle standard | Configurée, confirmée par l’auteur |
| Date de publication ou de dernière republication | À renseigner |
| Version du modèle actuellement publié | À renseigner |
| Référence du commit du code correspondant | À renseigner |
| Espace de travail | Référence non sensible à renseigner |
| Modèle sémantique | Référence non sensible à renseigner |
| Sources | Exports locaux G.txt, T.txt et E.txt |
| Dernière extraction Sage utilisée dans le Service | À renseigner |
| Fréquence d’actualisation | À renseigner, si une planification est utilisée |
| Horaires et fuseau horaire | À renseigner |
| Notifications d’échec | Configuration à consigner |
| Dernière actualisation réussie | À renseigner depuis l’historique du Service |
| Contrôles après publication | Résultats à consigner |
| Accès au rapport | Contrôlé ; modalités à documenter |

### Référence de la campagne de tests

| Élément | Information consignée |
|---|---|
| Date réelle d’exécution | 19/10/2026 |
| Version ou date d’extraction des fichiers testés | 07/10/2026 |
| Version du modèle testé | suivi-scolarite-tests |
| Contrôles Power Query | Résultats consignés dans le journal |
| Scénarios DAX | DAX-01 à DAX-06 consignés dans le journal |
| Référence du commit de la campagne | À renseigner dans le journal |
| Correspondance avec la version actuellement publiée | À consigner |

Les résultats DAX documentés comprennent notamment :

- 58 élèves distincts sur octobre et 221 en cumul à fin octobre ;
- les montants mensuels et cumulés de référence ;
- la continuité décembre-janvier ;
- la situation de février 2026 ;
- les mesures cumulées vides pour mai 2026 ;
- la réaction au filtre de section.

Ces résultats concernent la version testée.
Ils ne suffisent pas à déclarer identique ou validée
la version actuellement publiée.

Les informations non renseignées ne doivent pas être inventées.

Les références internes sensibles peuvent être conservées
dans un suivi non public. Aucun mot de passe, clé de récupération,
cookie, jeton ou chaîne de connexion sensible ne doit figurer
dans cette fiche.

---

## 12. État des vérifications

Les éléments cochés reposent sur les confirmations de l’auteur
et les résultats consignés.

### Éléments réalisés ou consignés

- [x] Rapport publié dans Power BI Service.
- [x] Passerelle standard configurée.
- [x] Contrôles Power Query exécutés sur la version testée.
- [x] Scénarios DAX documentés exécutés sur `suivi-scolarite-tests` et résultats consignés.
- [x] Galerie de huit captures intégrée au dépôt public, selon la confirmation de l’auteur.
- [x] Distinction entre agrégats métier et lignes synthétiques expliquée dans la documentation.

### Vérifications ou références restant à consigner

- [ ] Référence exacte de la version publiée.
- [ ] Correspondance entre le code GitHub, la version testée et le modèle publié.
- [ ] Résultats des contrôles après publication dans le Service.
- [ ] Dernière actualisation réussie, attestée par l’historique.
- [ ] Paramètres de planification, si une planification est utilisée.
- [ ] Liens et accès des destinataires testés.
- [ ] Références des versions publiques et contrôles de diffusion consignés dans le journal.

Une case non cochée indique qu’une vérification ou sa documentation
reste à compléter. Elle ne prouve pas que la fonctionnalité est absente.

La publication des captures ne constitue pas un test du rapport
interactif ni une preuve d’actualisation du modèle.

Les vérifications complémentaires du modèle restent suivies
dans le [journal de contrôle qualité](controle-qualite.md).

---

## Documentation associée

- [Présentation générale](../README.md)
- [Galerie du rapport](../images/README.md)
- [Méthodologie](methodologie.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Journal de contrôle qualité](controle-qualite.md)
- [Confidentialité](confidentialite.md)
- [Préparation Power Query](../powerquery/README.md)
- [Paramètres Power Query](../powerquery/parameters.example.md)
- [Documentation DAX](../dax/README.md)
- [Données et conditions de diffusion](../data/README.md)
