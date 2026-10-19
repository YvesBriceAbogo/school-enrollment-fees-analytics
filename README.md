# Suivi des effectifs et du recouvrement des frais de scolarité

**De Sage Saari à Power BI : analyse comptable et pilotage scolaire**

**Auteur : Brice Abogo**  
Comptable, analyste financier et analyste de données.

**Technologies :** Sage Saari version 15 · Power Query M · DAX · Power BI

> **État du projet :** traitements et modèle documentés, résultats de
> contrôle consignés et galerie de huit captures couvrant les cinq
> dashboards du rapport.

[Voir la galerie complète](images/README.md) ·
[Consulter la méthodologie](docs/methodologie.md) ·
[Consulter le journal de contrôle qualité](docs/controle-qualite.md)

---

## 1. Présentation du projet

Ce projet transforme des exports comptables Sage Saari en un rapport
Power BI consacré au suivi des effectifs comptabilisés, des frais
de scolarité constatés, des règlements et des soldes restant à recouvrer.

Il associe la compréhension des opérations comptables à la préparation,
à la modélisation et à la visualisation des données.

Le rapport comporte cinq pages, allant d’une synthèse des indicateurs
à des analyses mensuelles, individuelles et journalières.

### Questions métier

- Combien d’élèves distincts ont fait l’objet d’une constatation
  de scolarité sur la période ?
- Quels montants ont été constatés et réglés à la date retenue ?
- Quel solde reste à recouvrer ?
- Comment ces indicateurs se répartissent-ils par classe, niveau
  et section ?
- Comment évoluent les mouvements et les cumuls au cours
  de l’année académique ?
- Quels comptes nécessitent une vérification ou un suivi complémentaire
  dans l’environnement interne autorisé ?

### Objectifs

- Structurer les exports Sage pour l’analyse.
- Distinguer les mouvements mensuels des situations cumulées.
- Compter les élèves à partir de leurs comptes tiers distincts.
- Faciliter la lecture des frais constatés, des règlements et des soldes.
- Documenter les règles métier et les contrôles de cohérence.
- Présenter les fonctionnalités du rapport dans un portfolio public,
  sans exposer de situations individuelles réelles.

---

## 2. Aperçu du rapport et galerie

### Vue de synthèse — Situation au 31 octobre 2025

[![Vue de synthèse des effectifs et du recouvrement au 31 octobre 2025](images/01-overview.png)](images/01-overview.png)

La page de synthèse présente cinq cartes et une répartition
des indicateurs par niveau, section et classe.

Le sélecteur **« Mesures »** permet de changer l’indicateur représenté
dans les graphiques, tandis que les cinq cartes de synthèse restent
visibles.

### Dashboard 1 — Quatre variantes

| Indicateur sélectionné | Capture |
|---|---|
| Effectif actuel | [Voir la répartition des effectifs](images/01-overview.png) |
| Pensions déjà Constatées | [Voir la scolarité constatée](images/01-overview-scolarite.png) |
| Règlements déjà perçus | [Voir les règlements](images/01-overview-reglements.png) |
| Solde restant | [Voir les soldes](images/01-overview-solde.png) |

### Dashboards 2 à 5

| Page | Fonction | Capture |
|---|---|---|
| Dashboard 2 — Évolution mensuelle | Progression des cumuls de scolarité, des règlements et du solde | [Voir la page](images/02-evolution-mensuelle.png) |
| Dashboard 3 — Détails mensuels | Mouvements du mois par niveau et classe, accompagnés des tendances mensuelles | [Voir la page](images/03-details-mensuels.png) |
| Dashboard 4 — Situation individuelle | Suivi par élève, avec des lignes de démonstration entièrement synthétiques | [Voir la page](images/04-situation-individuelle.png) |
| Dashboard 5 — Suivi journalier | Exploration par date et élève, avec des lignes de démonstration entièrement synthétiques | [Voir la page](images/05-suivi-journalier.png) |

**[Ouvrir la galerie commentée — 8 captures](images/README.md)**

Les captures sont statiques. Les filtres, boutons, recherches et
défilements du rapport Power BI ne sont pas utilisables depuis GitHub.

---

## 3. Périmètre et conventions temporelles

| Élément | Description |
|---|---|
| Année académique étudiée | 2025/2026 |
| Cycle analytique | Du 1er août au 31 juillet |
| Période disponible dans les données | Août 2025 à avril 2026 |
| Situation de référence illustrée | Arrêté au 31 octobre 2025 |
| Dernière date d’écriture affichée lors des tests | 02/04/2026 |
| Devise | FCFA |
| Application source | Sage Saari version 15 |
| Origine du modèle métier | Exports comptables réels |
| Détails publics des dashboards 4 et 5 | Situations entièrement synthétiques |

Octobre 2025 est une situation de référence, et non une date figée
dans les calculs.

Les cartes des captures présentent cette situation de référence.
Les visuels d’évolution des dashboards 2 et 3 peuvent présenter
plusieurs mois disponibles, comme expliqué dans la galerie.

Les données postérieures à octobre sont utilisées pour une lecture
rétrospective. Elles ne sont pas présentées comme des informations
déjà connues en octobre 2025.

La période disponible ne couvre pas nécessairement tout le cycle
académique. La présence d’écritures en avril ne démontre pas
l’exhaustivité de ce mois.

---

## 4. Résultats de référence — Octobre 2025

Les valeurs suivantes sont consignées dans le
[journal de contrôle qualité](docs/controle-qualite.md)
pour la version testée.

### Situation cumulée du 1er août au 31 octobre 2025

| Indicateur | Résultat consigné |
|---|---:|
| Effectif actuel — élèves distincts cumulés | 221 |
| Scolarité constatée cumulée | 15 220 000 FCFA |
| Règlements cumulés | 7 488 000 FCFA |
| Solde restant | 7 732 000 FCFA |
| Taux de recouvrement cumulé | 49,20 % |

### Rapprochements arithmétiques

```text
15 220 000 − 7 488 000 = 7 732 000 FCFA

7 488 000 / 15 220 000 ≈ 49,20 %
```

### Mouvements du seul mois d’octobre

| Indicateur | Résultat consigné |
|---|---:|
| Élèves distincts ayant une constatation en octobre | 58 |
| Scolarité constatée pendant le mois | 3 805 000 FCFA |
| Règlements enregistrés pendant le mois | 3 286 000 FCFA |
| Différence des flux mensuels | 519 000 FCFA |

Les **58 élèves** ne doivent pas être assimilés automatiquement
à de nouvelles inscriptions administratives.

Les **221 élèves** correspondent au comptage distinct cumulé.
Ce cumul n’est pas obtenu en additionnant les effectifs mensuels.

Les règlements d’octobre peuvent concerner des frais constatés
pendant les mois précédents. La différence de **519 000 FCFA**
entre les flux du mois n’est donc pas le solde cumulé restant.

---

## 5. Sources et modèle de données

### Fichiers sources

| Fichier | Contenu |
|---|---|
| E.txt | Écritures comptables |
| T.txt | Référentiel des comptes tiers élèves |
| G.txt | Référentiel des comptes généraux |

Ces fichiers sont produits à l’aide des fonctions d’export de Sage Saari.

Leur structure, les formats de date, les encodages et les règles
de préparation sont décrits dans le
[dictionnaire des données](docs/dictionnaire-donnees.md)
et la documentation [Power Query](powerquery/README.md).

### Chaîne de traitement

```text
Exports Sage Saari : E.txt, T.txt et G.txt
                    ↓
Power Query : préparation, sélection du périmètre et enrichissement
                    ↓
Contrôles de qualité et de conservation des écritures
                    ↓
Modèle Power BI : écritures, référentiels et calendrier
                    ↓
DAX : mouvements, comptage distinct et cumuls académiques
                    ↓
Rapport : cinq dashboards et quatre variantes de synthèse
```

### Tables du modèle

| Table | Rôle |
|---|---|
| Ecritures | Mouvements comptables retenus pour l’analyse |
| Comptes T | Référentiel des comptes élèves et attributs associés |
| Comptes G | Référentiel des regroupements comptables |
| Calendrier | Dimension temporelle |
| Mesures | Paramètre de champs pour sélectionner l’indicateur des graphiques |

Un compte tiers correspond à un seul élève. Le nom n’est pas utilisé
comme clé de jointure.

Le schéma documenté prévoit des relations un-à-plusieurs des dimensions
vers les écritures :

- `Calendrier[Date]` → `Ecritures[Date]` ;
- `Comptes T[Compte T]` → `Ecritures[Compte T]` ;
- `Comptes G[Compte G]` → `Ecritures[Compte G]`.

Le filtrage simple va des dimensions vers les écritures.
Le paramètre de champs `Mesures` reste déconnecté des tables métier.

Les clés des référentiels doivent être uniques afin d’éviter
la multiplication des lignes lors des enrichissements.

---

## 6. Préparation comptable avec Power Query

La comptabilité étudiée est consacrée à la scolarité.

Les exports comprennent les mouvements sur les comptes élèves ainsi
que leurs contreparties de produits ou de trésorerie.

La préparation retient les comptes tiers du périmètre scolaire confirmé
et exclut ces contreparties avant le calcul des indicateurs.

### Convention comptable

| Sens sur le compte élève | Interprétation retenue |
|---|---|
| D — Débit | Constatation des frais de scolarité |
| C — Crédit | Règlement pour l’élève |

Après cette sélection, la table analytique ne représente plus
l’intégralité des écritures en partie double.

**Il n’est donc pas attendu que le total débit soit égal au total crédit
dans cette table.**

### Principaux traitements

- Lecture des exports TXT avec leurs encodages documentés.
- Préparation des dates et typage des colonnes.
- Conservation des comptes comme identifiants textuels.
- Sélection des comptes commençant par `4`, selon le périmètre confirmé.
- Enrichissement de `Comptes T` à partir de `Comptes G`.
- Enrichissement de `Ecritures` avec le niveau scolaire provenant
  de `Comptes T`.
- Contrôle des correspondances et de la conservation des lignes
  et des montants.

La classe de l’écriture reste celle portée par `E.txt`.
La section est disponible dans le référentiel `Comptes T`.

Aucune déduplication automatique des écritures n’est appliquée :
deux lignes similaires peuvent correspondre à deux opérations distinctes.

[Consulter les traitements Power Query](powerquery/README.md)

---

## 7. Conventions des indicateurs DAX

| Mesure | Signification |
|---|---|
| Effectif | Comptes élèves distincts ayant une constatation dans la période sélectionnée |
| Effectif actuel | Comptes élèves distincts ayant une constatation depuis le début du cycle jusqu’à l’arrêté mensuel |
| Total Pension | Scolarité constatée sur la période sélectionnée |
| Total Réglé | Règlements sur la période sélectionnée |
| Pensions déjà Constatées | Scolarité constatée cumulée sur le cycle |
| Règlements déjà perçus | Règlements cumulés sur le même cycle |
| Solde restant | Scolarité constatée cumulée moins règlements cumulés |
| % Recouvrement Global | Règlements cumulés divisés par scolarité constatée cumulée |

### Comptage distinct

Le comptage porte sur `Compte T`, et non sur le nombre de lignes
comptables.

Un élève ayant plusieurs constatations reste compté une seule fois
sur la période cumulée.

Cet effectif comptable ne constitue ni un suivi de présence quotidienne
ni un rapprochement automatique avec le registre administratif
des inscriptions.

### Cumuls académiques

Les cumuls commencent au **1er août** et se poursuivent jusqu’à la fin
du mois sélectionné.

| Mois sélectionné | Période cumulée |
|---|---|
| Octobre 2025 | 01/08/2025 au 31/10/2025 |
| Février 2026 | 01/08/2025 au 28/02/2026 |
| Avril 2026 | 01/08/2025 au 30/04/2026, selon les écritures disponibles |

Le cumul ne recommence pas à zéro en janvier.

Les mesures cumulatives documentées :

- exigent une seule année académique dans le contexte ;
- retiennent le dernier mois si plusieurs mois du même cycle
  sont sélectionnés ;
- renvoient une valeur vide si le mois sélectionné dépasse le dernier
  mois contenant des écritures.

Une valeur vide au-delà des données disponibles ne signifie
ni un effectif nul ni un solde intégralement réglé.

Les cumuls des différentes lignes mensuelles ne doivent pas être
additionnés pour obtenir un total annuel.

### Interprétation financière

Le taux de recouvrement utilise le même périmètre et les mêmes bornes
temporelles au numérateur et au dénominateur.

Le **solde restant**, également intitulé « Solde dû » dans certains
graphiques, n’est pas automatiquement une somme échue.

L’identification des retards de paiement nécessite les échéances
applicables et la vérification des situations individuelles.

Les tableaux journaliers utilisent les mesures de mouvements.
Les cartes arrêtées en fin de mois ne représentent pas une situation
à la fin de la journée sélectionnée.

[Consulter les mesures DAX](dax/README.md)

---

## 8. Contrôles de qualité et limites

Les résultats reposent sur les exécutions effectuées par l’auteur,
ses confirmations et les éléments consignés dans le journal.

**Campagne documentée :** 19/10/2026  
**Version du modèle testé :** `suivi-scolarite-tests`

### Synthèse des contrôles consignés

| Domaine | Contrôle | Résultat documenté |
|---|---|---|
| Power Query | Niveaux manquants, cohérence des classes et validité des écritures | Exécutés ; aucune anomalie signalée |
| Power Query | Conservation des lignes et des montants avant et après enrichissement | Écarts nuls confirmés sur le périmètre testé |
| DAX | Situation d’octobre et comptage distinct | Montants consignés ; 58 élèves sur le mois et 221 en cumul |
| DAX | Continuité décembre-janvier et situation de février | Conformes aux repères testés |
| DAX | Mai 2026, au-delà du dernier mois d’écritures | Mesures cumulées vides selon la règle de disponibilité |
| DAX | Filtre de section | Réaction des résultats confirmée par l’auteur |

Ces conclusions concernent la version et les scénarios effectivement
examinés. Elles ne constituent pas une certification de l’ensemble
des données sources ni de toutes les interactions possibles.

### Vérifications complémentaires

Le journal recense notamment les vérifications restant à consigner :

- rapprochement avec le registre administratif des inscriptions ;
- exhaustivité des exports par rapport à Sage ;
- tests détaillés par classe et niveau ;
- comportement complet du paramètre de champs et des interactions
  de la page journalière ;
- sélections couvrant plusieurs cycles académiques ;
- tri chronologique et concordance avec la version du rapport
  publiée dans Power BI Service.

Les captures illustrent le rendu du rapport. Elles ne remplacent pas
les tests du modèle.

Aucune amélioration du recouvrement ni économie de temps n’est
revendiquée sans mesure de résultat.

[Plan de contrôle qualité](quality/README.md) ·
[Journal détaillé des contrôles](docs/controle-qualite.md)

---

## 9. Organisation et utilisation du dépôt

```text
school-enrollment-fees-analytics/
├── README.md
├── .gitignore
├── data/          # Documentation des sources et conditions de diffusion
├── powerquery/    # Préparation et contrôles Power Query M
├── dax/           # Mesures, calendrier et paramètre de champs
├── quality/       # Plan et documentation des contrôles
├── docs/          # Méthodologie, dictionnaire, journal et gouvernance
└── images/        # Galerie commentée et huit captures du rapport
```

### Parcours de consultation

1. Découvrir les fonctionnalités dans la [galerie](images/README.md).
2. Lire la [méthodologie](docs/methodologie.md) et le
   [dictionnaire des données](docs/dictionnaire-donnees.md).
3. Examiner les traitements [Power Query](powerquery/README.md)
   et les mesures [DAX](dax/README.md).
4. Consulter les [contrôles et résultats](docs/controle-qualite.md).
5. Adapter les traitements à des données autorisées ou synthétiques,
   puis rejouer les contrôles dans le nouvel environnement.

Le dépôt conserve le code, la documentation et les supports
de présentation. Il ne se connecte pas automatiquement à Sage
et n’exécute pas les traitements Power BI.

La reconstruction du modèle nécessite Power BI Desktop,
des données compatibles et la configuration des requêtes,
relations et mesures documentées.

Les exports réels et le PBIX contenant ces données restent
hors du périmètre de publication.

---

## 10. Documentation associée

| Ressource | Contenu |
|---|---|
| [Galerie du rapport](images/README.md) | Huit captures commentées et conventions de lecture |
| [Méthodologie](docs/methodologie.md) | Démarche et choix de traitement |
| [Dictionnaire des données](docs/dictionnaire-donnees.md) | Sources, tables, colonnes et indicateurs |
| [Données sources](data/README.md) | Provenance et conditions de diffusion |
| [Power Query](powerquery/README.md) | Préparation et enrichissement des données |
| [DAX](dax/README.md) | Mesures, calendrier et paramètre de champs |
| [Plan de contrôle qualité](quality/README.md) | Contrôles prévus et règles de vérification |
| [Journal de contrôle qualité](docs/controle-qualite.md) | Tests exécutés, résultats et limites |
| [Confidentialité](docs/confidentialite.md) | Protection des données et supports publics |
| [Déploiement](docs/deploiement.md) | Documentation de publication et d’exploitation |

---

## 11. Confidentialité et version de démonstration

Le projet métier repose sur des données comptables réelles.
Sa présentation est autorisée.

La version publique distingue :

- les restitutions agrégées des dashboards 1 à 3 ;
- les situations individuelles entièrement synthétiques
  des dashboards 4 et 5.

Les lignes de démonstration des pages 4 et 5 ne reproduisent aucune
situation réelle d’élève. Il ne s’agit pas seulement d’un remplacement
des noms.

Cette adaptation concerne la version de présentation de ces pages.
Elle ne requalifie pas les données sources ni la version ayant servi
aux contrôles documentés.

Les supports publics ne présentent ni nom d’établissement ni identité
réelle d’élève.

Les exports Sage réels, les correspondances avec les identités réelles
et le modèle contenant les données détaillées ne sont pas destinés
au dépôt public.

Masquer un champ dans un visuel ne retire pas sa valeur du modèle.
Un fichier PBIX en mode Import peut conserver les données détaillées.

Les règles de diffusion et de réutilisation sont décrites dans la
[documentation des sources](data/README.md) et les
[consignes de confidentialité](docs/confidentialite.md).

---

## 12. Compétences mises en valeur

| Domaine | Application dans le projet |
|---|---|
| Comptabilité | Lecture de la partie double et sélection du périmètre analytique |
| Analyse financière | Suivi des constatations, règlements, soldes et taux de recouvrement |
| Sage Saari | Exploitation des exports comptables |
| Power Query M | Lecture TXT, préparation des dates, typage, jointures et contrôles |
| Modélisation | Organisation des écritures, référentiels et dimension temporelle |
| DAX | Comptage distinct, cumuls académiques et gestion du contexte de filtre |
| Power BI | Navigation, sélecteur d’indicateur et analyses à plusieurs granularités |
| Gouvernance | Traçabilité des tests, documentation et distinction des supports publics |

---

## Auteur

**Brice Abogo**  
Comptable, analyste financier et analyste de données.

Mon approche consiste à transformer les données comptables en indicateurs
compréhensibles et contrôlables, en associant la maîtrise des outils
à une interprétation financière rigoureuse.
