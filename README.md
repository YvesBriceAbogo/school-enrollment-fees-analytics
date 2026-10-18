# Suivi des effectifs et du recouvrement des frais de scolarité

## De Sage Saari à Power BI : analyse comptable et pilotage scolaire

**Auteur : Brice Abogo**  
Comptable, analyste financier et analyste de données.

**Technologies :** Sage Saari version 15 · Power Query M · DAX · Power BI

> **État du dépôt :** documentation et ressources en cours de constitution.
> Les scripts, contrôles et supports de présentation sont ajoutés progressivement.

---

## 1. Présentation du projet

Ce projet transforme des exports comptables Sage Saari en un outil
de suivi des effectifs comptabilisés et des frais de scolarité.

Le rapport Power BI permet d’analyser les frais constatés, les règlements,
les soldes restant à recouvrer et leur répartition par classe, niveau
et section.

Il comporte cinq pages, allant d’une synthèse des indicateurs à une
analyse mensuelle, individuelle et journalière.

Le projet associe une compréhension des opérations comptables
à la préparation, à la modélisation et à la visualisation des données.

---

## 2. Problématique métier

Un établissement scolaire doit disposer d’une information fiable
pour suivre les inscriptions comptabilisées, les frais de scolarité
et les paiements.

Les exports comptables contiennent les mouvements nécessaires,
mais leur exploitation directe ne fournit pas toujours une présentation
adaptée aux besoins de la direction et du service de scolarité.

Le projet répond notamment aux questions suivantes :

- Combien d’élèves distincts ont fait l’objet d’une constatation de scolarité ?
- Quels montants ont été constatés et réglés à la date retenue ?
- Quel solde reste à recouvrer ?
- Comment ces indicateurs se répartissent-ils par classe, niveau et section ?
- Comment évoluent les règlements pendant l’année académique ?
- Quels comptes nécessitent une vérification ou un suivi complémentaire ?

---

## 3. Objectifs

- Exploiter les exports Sage dans un modèle analytique structuré.
- Faciliter le rapprochement des frais constatés et des règlements.
- Compter les élèves à partir de leurs comptes tiers distincts.
- Suivre les montants mensuels et cumulés.
- Présenter les soldes individuels dans un environnement interne autorisé.
- Fournir une synthèse utilisable pour le pilotage et le recouvrement.
- Documenter les règles de calcul et les contrôles de cohérence.

---

## 4. Périmètre

| Élément | Description |
|---|---|
| Année académique étudiée | 2025/2026 |
| Données disponibles | Août 2025 à avril 2026 |
| Situation de référence illustrée | Arrêté au 31 octobre 2025 |
| Début retenu pour les cumuls académiques | 1er août |
| Devise | FCFA |
| Source | Exports TXT issus de Sage Saari version 15 |
| Nature des données | Données réelles |
| Publication | Présentation du projet autorisée |
| Version publique | Sans nom d’établissement ni identité réelle d’élève |

Octobre 2025 est un exemple de situation analysée, et non une date
figée dans les calculs.

Le rapport doit permettre de sélectionner un autre mois, notamment
février 2026, tout en conservant le début de l’année académique
pour les cumuls.

La période disponible ne constitue pas nécessairement l’intégralité
de l’année scolaire.

Les données de novembre 2025 à avril 2026 servent à une analyse
rétrospective. Elles ne sont pas présentées comme des informations
déjà connues en octobre 2025.

---

## 5. Sources et modèle de données

### Fichiers sources

| Fichier | Contenu |
|---|---|
| E.txt | Écritures comptables |
| T.txt | Référentiel des comptes tiers |
| G.txt | Référentiel des comptes généraux |

Les fichiers sont produits à l’aide des fonctions d’export de Sage Saari.

Le format des dates, le séparateur, l’encodage et les règles d’export
seront documentés pour faciliter la reproduction des traitements.

### Tables du modèle

| Table | Rôle |
|---|---|
| Ecritures | Mouvements comptables retenus pour l’analyse |
| Comptes T | Référentiel des comptes élèves et attributs associés |
| Comptes G | Référentiel des regroupements comptables |
| Calendrier | Dimension temporelle |
| Mesures | Paramètre de champs pour sélectionner l’indicateur affiché |

Un compte tiers correspond à un seul élève.

Les comptes généraux constituent des regroupements associés aux
comptes tiers. Leur correspondance avec les classes, niveaux et sections
doit être explicite.

Les relations et les clés doivent être contrôlées afin d’éviter
la multiplication des écritures lors des rapprochements.

---

## 6. Préparation comptable avec Power Query

La comptabilité utilisée est exclusivement consacrée à la scolarité.

Les exports comprennent les écritures sur les comptes élèves ainsi
que leurs contreparties de produits ou de trésorerie.

Un retraitement Power Query sélectionne les lignes de comptes de tiers
et écarte notamment ces contreparties avant le calcul des indicateurs.

Dans le périmètre confirmé du projet :

| Sens du compte tiers | Signification |
|---|---|
| D — Débit | Constatation de la scolarité lors de l’inscription |
| C — Crédit | Règlement pour l’élève |

Cette sélection évite d’intégrer les contreparties comptables aux
montants analysés.

Les traitements comprennent également :

- la lecture des exports TXT ;
- la préparation des dates ;
- le renommage et le typage des colonnes ;
- le rapprochement avec les comptes tiers et généraux ;
- l’enrichissement par classe, niveau et section.

La documentation précisera les règles de sélection et les contrôles
appliqués aux jointures.

---

## 7. Conventions des indicateurs

### Effectif

L’effectif retenu correspond au nombre distinct de comptes élèves
ayant une constatation de scolarité dans la période analysée.

Le comptage porte sur `Compte T`, et non sur le nombre de lignes
comptables au débit.

Un élève ayant plusieurs écritures de constatation doit rester compté
une seule fois dans le cumul.

Cet indicateur comptable ne constitue pas un suivi de présence quotidienne.

### Frais de scolarité constatés

Ils correspondent aux montants au débit des comptes tiers élèves
dans le périmètre comptable retenu.

### Règlements

Ils correspondent aux montants au crédit de ces comptes tiers,
selon la convention confirmée pour les exports.

### Solde restant

```text
Scolarité constatée cumulée − Règlements cumulés
```

Le solde ne constitue pas automatiquement un retard de paiement :
l’exigibilité dépend des échéances contractuelles applicables.

### Taux de recouvrement

```text
Règlements cumulés / Scolarité constatée cumulée
```

Le numérateur et le dénominateur doivent utiliser les mêmes bornes
temporelles et le même périmètre.

### Cumuls académiques

Les cumuls commencent au 1er août et se poursuivent jusqu’à la fin
du mois sélectionné.

Exemples :

| Mois sélectionné | Période cumulée |
|---|---|
| Octobre 2025 | 1er août au 31 octobre 2025 |
| Février 2026 | 1er août 2025 au 28 février 2026 |
| Avril 2026 | 1er août 2025 au 30 avril 2026 |

Le cumul ne recommence pas en janvier.

La sélection d’un mois futur ne doit pas être interprétée comme
la disponibilité de données futures complètes.

---

## 8. Organisation du rapport

| Page | Fonction |
|---|---|
| Vue de synthèse | Indicateurs globaux et répartitions par classe, niveau et section |
| Progression académique | Cumuls des frais, règlements et soldes |
| Analyse mensuelle | Mouvements de constatation et de règlement du mois |
| Situation individuelle | Analyse du compte élève dans l’environnement interne |
| Suivi journalier | Exploration des opérations par date |

Un paramètre de champs permet de modifier l’indicateur présenté
dans les graphiques de synthèse.

Les vues individuelles publiées devront utiliser des exemples fictifs
ou une présentation ne permettant pas d’identifier les élèves réels.

---

## 9. Repères issus du rapport au 31 octobre 2025

| Indicateur | Valeur affichée |
|---|---:|
| Effectif présenté dans l’export | 221 |
| Scolarité constatée cumulée | 15 220 000 FCFA |
| Règlements cumulés | 7 488 000 FCFA |
| Solde restant | 7 732 000 FCFA |
| Taux de recouvrement | 49,20 % |

### Rapprochements arithmétiques

```text
15 220 000 − 7 488 000 = 7 732 000 FCFA

7 488 000 / 15 220 000 ≈ 49,20 %
```

Ces chiffres sont des repères issus du rapport fourni.
Le nombre de 221 doit être vérifié après application du comptage
distinct des comptes élèves.

Les scripts et leurs résultats ne doivent pas être considérés
comme validés uniquement parce qu’ils sont documentés sur GitHub.

### Mouvements du seul mois d’octobre

| Indicateur | Montant |
|---|---:|
| Scolarité constatée en octobre | 3 805 000 FCFA |
| Règlements enregistrés en octobre | 3 286 000 FCFA |
| Différence des flux mensuels | 519 000 FCFA |

Les règlements d’octobre peuvent concerner des frais constatés
au cours des mois précédents.

Les flux mensuels doivent être distingués des cumuls académiques.

---

## 10. Recommandations de pilotage

- Rapprocher les élèves distincts comptabilisés du registre des inscriptions.
- Contrôler les totaux avec les exports Sage.
- Vérifier les soldes individuels avant toute relance.
- Distinguer les sommes exigibles des soldes non encore échus.
- Suivre régulièrement les mouvements mensuels et les cumuls académiques.
- Maintenir une correspondance fiable entre comptes, classes, niveaux et sections.
- Réserver les informations nominatives aux utilisateurs internes autorisés.

Aucune amélioration du recouvrement ni économie de temps n’est attribuée
au tableau de bord sans mesure de résultat.

---

## 11. Compétences mises en valeur

| Domaine | Application |
|---|---|
| Comptabilité | Lecture de la partie double et sélection du périmètre analytique |
| Analyse financière | Suivi des constatations, règlements et soldes |
| Sage Saari | Exploitation des exports comptables |
| Power Query M | Lecture TXT, préparation, typage et jointures |
| Modélisation | Organisation des écritures et référentiels |
| DAX | Comptage distinct, cumuls académiques et filtres |
| Visualisation | Navigation entre synthèse, suivi mensuel et détail journalier |
| Gouvernance | Documentation, contrôles et confidentialité |

---

## 12. Organisation prévue du dépôt

```text
school-enrollment-fees-analytics/
├── README.md
├── powerquery/
├── dax/
├── quality/
├── docs/
├── images/
├── reports/
└── data/
```

Les fichiers seront ajoutés progressivement, avec leur rôle,
leurs dépendances et leurs instructions d’utilisation.

Le dépôt conserve le code et la documentation.
Il ne se connecte pas automatiquement à Sage et n’exécute pas
les traitements Power BI.

---

## 13. Confidentialité et conditions de diffusion

Le projet s’appuie sur des données réelles et sa présentation
est autorisée.

La version publique doit néanmoins limiter l’exposition des informations
individuelles, particulièrement lorsqu’elles concernent des élèves mineurs.

Les exports nominatifs et le modèle contenant les données réelles
ne sont pas destinés au dépôt public.

Pour démontrer les vues individuelles, des données fictives peuvent
être utilisées et doivent être clairement identifiées comme telles.

Masquer un champ dans un rapport ne retire pas son contenu du modèle.
Un fichier PBIX en mode Import peut contenir les données détaillées.

Les captures, PDF, données d’exemple et fichiers Power BI doivent être
vérifiés avant diffusion.

La provenance et les conditions de réutilisation seront précisées
dans la documentation des données.

---

## Auteur

**Brice Abogo**  
Comptable, analyste financier et analyste de données.

Mon approche consiste à transformer les données comptables en indicateurs
compréhensibles et contrôlables, en associant la maîtrise des outils
à une interprétation financière rigoureuse.
