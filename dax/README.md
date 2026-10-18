# Indicateurs scolaires et financiers — DAX

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce dossier documente les formules DAX utilisées pour analyser les effectifs
comptabilisés, les frais de scolarité, les règlements et les soldes.

Il complète les transformations Power Query et les contrôles
de préparation des données.

Les fichiers sont ajoutés progressivement.
Les formules révisées doivent être testées dans le modèle avant
d’être présentées comme validées.

---

## 1. Objectifs

- Compter les élèves distincts à partir des comptes tiers.
- Distinguer les mouvements mensuels des cumuls académiques.
- Calculer les frais constatés, règlements et soldes à date.
- Produire un taux de recouvrement sur un périmètre cohérent.
- Permettre une analyse par classe, niveau et section.
- Documenter le fonctionnement des filtres.
- Faciliter la reproduction et la maintenance des indicateurs.

---

## 2. Organisation prévue

| Fichier | Contenu |
|---|---|
| `00_calendrier.dax` | Table calendrier et attributs temporels |
| `01_mesures_base.dax` | Montants, lignes comptables et mouvements D/C |
| `02_effectifs.dax` | Élèves distincts et effectif cumulé |
| `03_cumuls_scolaires.dax` | Cumuls académiques, solde et taux de recouvrement |
| `04_parametre_mesures.dax` | Sélection de l’indicateur présenté dans les visuels |

Les préfixes numériques organisent les fichiers du dépôt.
Ils ne font pas partie des noms des tables ou des mesures Power BI.

Les fichiers constituent un catalogue de définitions.
Ils ne sont pas des requêtes DAX exécutables en bloc.

---

## 3. Prérequis du modèle

Les formules reposent sur les conventions suivantes :

- Ecritures contient les mouvements retenus sur les comptes tiers élèves.
- Les contreparties de produits et de trésorerie ont été exclues.
- Un Compte T correspond à un seul élève.
- Les comptes sont des identifiants textuels.
- Les montants sont numériques et non négatifs dans le périmètre confirmé.
- Sens contient D pour les constatations et C pour les règlements.
- La colonne Date est de type Date.

### Relations attendues

| Relation | Cardinalité attendue |
|---|---|
| Calendrier[Date] → Ecritures[Date] | Un à plusieurs |
| Comptes T[Compte T] → Ecritures[Compte T] | Un à plusieurs |
| Comptes G[Compte G] → Ecritures[Compte G] | Un à plusieurs |

Les relations doivent être actives pour les usages concernés,
avec un filtrage simple depuis les référentiels vers les écritures,
sans chemin ambigu.

Les clés doivent être uniques du côté « un ».

La table Calendrier doit contenir des dates uniques et continues,
et être marquée comme table de dates.

### Informations scolaires

La classe de l’écriture provient du quatrième champ de E.txt.
Le niveau est ajouté par rapprochement avec Comptes T.
La section est disponible dans le référentiel élèves.

Le choix des champs utilisés dans les segments doit être cohérent
avec les relations et le périmètre de l’analyse.

---

## 4. Conventions comptables

### Scolarité constatée

Dans le périmètre confirmé :

```text
Débit du compte tiers élève = constatation de la scolarité
```

Les contreparties de produits ne sont pas ajoutées au montant analysé.

### Règlements

Dans le même périmètre :

```text
Crédit du compte tiers élève = règlement
```

Les contreparties de trésorerie ne sont pas additionnées aux crédits
des comptes élèves.

### Solde

```text
Solde = Scolarité constatée − Règlements
```

Les deux composantes doivent être évaluées sur le même périmètre.

Un solde positif n’est pas automatiquement une somme échue :
la qualification d’un retard nécessite les échéances applicables.

Un éventuel solde créditeur doit être examiné, et non ramené
automatiquement à zéro.

### Taux de recouvrement

```text
Règlements cumulés / Scolarité constatée cumulée
```

Le numérateur et le dénominateur doivent utiliser les mêmes bornes
temporelles et les mêmes filtres métier.

Une division non calculable ne doit pas être remplacée arbitrairement
par un taux nul.

---

## 5. Définition des effectifs

### Comptage distinct

L’indicateur d’effectif compte les comptes tiers distincts ayant
une constatation de scolarité dans la période analysée.

Il ne compte pas simplement les lignes au débit.

Si un élève possède plusieurs écritures de constatation dans la période,
il ne doit être compté qu’une seule fois dans cet indicateur.

### Effectif cumulé

L’effectif à date est recalculé sur l’ensemble de la période académique
jusqu’à la date d’arrêté retenue.

Il ne correspond pas à l’addition des effectifs distincts mensuels :
un même élève peut apparaître dans plusieurs mois.

### Limites

Cet indicateur décrit les élèves représentés dans les constatations
comptables du périmètre.

Il ne constitue pas un suivi de présence quotidienne.

Les inscriptions nouvelles, départs et annulations nécessitent
des règles spécifiques si ces informations doivent être analysées.

---

## 6. Conventions temporelles

### Cycle académique

Le début analytique retenu est le 1er août.

Les cumuls se poursuivent jusqu’à la fin du mois sélectionné.
Ils ne recommencent pas à zéro en janvier.

| Mois sélectionné | Période cumulée |
|---|---|
| Octobre 2025 | 01/08/2025 au 31/10/2025 |
| Février 2026 | 01/08/2025 au 28/02/2026 |
| Avril 2026 | 01/08/2025 au 30/04/2026 |

Octobre 2025 est une situation de référence du rapport,
pas une date inscrite en dur dans toutes les mesures.

### Filtres

Les mesures cumulatives doivent retrouver les mois antérieurs
de la même année académique, sans perdre les filtres métier pertinents.

Les filtres de classe, niveau, section et compte élève doivent donc
être conservés selon le modèle.

Pour une situation mensuelle, une sélection explicite de l’année
académique et du mois est recommandée.

Le comportement des sélections portant sur plusieurs années académiques
doit être défini et testé, et non laissé implicite.

### Analyse journalière

Les mouvements d’une journée utilisent les mesures de base,
filtrées sur la date concernée.

Les cartes arrêtées en fin de mois ne doivent pas être interprétées
comme une situation à la fin de la journée sélectionnée.

Une situation cumulée à fin de journée nécessiterait une convention
et une mesure dédiées.

### Données disponibles

Les sources couvrent août 2025 à avril 2026.

La présence de dates supplémentaires dans le calendrier ne signifie
pas que les opérations de ces dates existent ou sont complètes.

Les résultats ultérieurs à octobre doivent être présentés comme
une analyse rétrospective, et non comme une prévision connue en octobre.

---

## 7. Calendrier et affichage

Le calendrier doit permettre de distinguer :

- l’année civile ;
- l’année académique ;
- le mois ;
- l’ordre du mois dans le cycle académique ;
- l’année-mois ;
- la date et les attributs nécessaires à la vue journalière.

Les libellés de mois doivent être triés par une colonne numérique adaptée.

Les relations et calculs doivent utiliser une véritable colonne Date.

Les colonnes créées avec FORMAT sont des textes de présentation.
Elles ne remplacent pas la date utilisée pour les relations.

Les montants et taux doivent conserver leur type numérique.

---

## 8. Paramètre de champs

La table Mesures permet de sélectionner l’indicateur présenté
dans certains visuels.

Les indicateurs concernés sont notamment :

- les pensions déjà constatées ;
- les règlements déjà perçus ;
- le solde restant ;
- l’effectif actuel.

Un paramètre de champs possède une configuration spécifique
dans Power BI.

Il doit être créé avec la fonctionnalité « Nouveau paramètre > Champs »,
puis documenté ou adapté selon les besoins.

Une simple table contenant les mêmes textes ne reproduit pas
nécessairement son fonctionnement.

Les formules documentées doivent référencer les mesures et leurs
tables d’accueil réelles.

---

## 9. Utilisation des fichiers

GitHub conserve le code, mais ne l’exécute pas.

Dans une copie du fichier Power BI Desktop :

1. Créer ou modifier le calendrier avec « Nouvelle table ».
2. Créer séparément les colonnes calculées nécessaires.
3. Créer chaque mesure avec « Nouvelle mesure ».
4. Respecter l’ordre des dépendances.
5. Définir les formats numériques.
6. Tester les résultats et les interactions.
7. Mettre à jour les visuels après validation.

Si les objets existent déjà, examiner leurs dépendances avant
de les supprimer ou de les renommer.

Ne pas coller plusieurs définitions dans une seule mesure.

---

## 10. Formats recommandés

| Élément | Format |
|---|---|
| Montants | Nombre avec séparateur de milliers, unité FCFA explicite |
| Effectifs et nombres de lignes | Nombre entier |
| Taux de recouvrement | Pourcentage, deux décimales |
| Dates | Date lisible, avec année non ambiguë |
| Année académique | Libellé tel que 2025/2026 |

La fonction FORMAT est adaptée aux libellés de présentation,
mais transforme une valeur numérique en texte.

Elle ne doit pas remplacer le format numérique des mesures
utilisées dans les calculs ou les graphiques.

---

## 11. Validation des indicateurs

Les contrôles Power Query ont été exécutés par l’auteur sur son modèle,
avec des résultats déclarés satisfaisants et une conservation conforme
des lignes et montants sur le périmètre testé.

La validation DAX constitue une étape distincte.

Les tests devront notamment vérifier :

- le comptage distinct des comptes élèves ;
- les totaux mensuels de constatations et de règlements ;
- les cumuls au 31 octobre 2025 ;
- la continuité du cumul entre décembre et janvier ;
- une situation à fin février 2026 ;
- le solde et le taux de recouvrement ;
- les filtres par classe, niveau et section ;
- le fonctionnement du paramètre de champs ;
- les périodes sans mouvement et les données manquantes.

### Repères du rapport de référence

| Indicateur au 31 octobre 2025 | Valeur affichée |
|---|---:|
| Effectif présenté | 221, à rapprocher du comptage distinct |
| Scolarité constatée cumulée | 15 220 000 FCFA |
| Règlements cumulés | 7 488 000 FCFA |
| Solde restant | 7 732 000 FCFA |
| Taux de recouvrement | 49,20 % |

Ces valeurs sont des repères, pas des résultats à imposer
si une correction justifiée modifie les calculs.

La conservation des lignes lors d’une jointure ne démontre pas
automatiquement que tous les indicateurs DAX sont corrects.

---

## 12. Confidentialité

Les fichiers DAX ne doivent contenir aucun nom réel d’élève,
identifiant personnel ou information de connexion.

Les résultats individuels des tests doivent rester dans l’environnement
interne autorisé.

Les exemples publics doivent être fictifs ou suffisamment agrégés,
selon les conditions de diffusion du projet.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Préparation Power Query](../powerquery/README.md)
- [Contrôles de qualité](../quality/README.md)
- [Journal des contrôles exécutés](../docs/controle-qualite.md)
- [Données et conditions de diffusion](../data/README.md)
