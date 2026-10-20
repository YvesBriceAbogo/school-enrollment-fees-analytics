# Indicateurs scolaires et financiers — DAX

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce dossier documente les définitions DAX utilisées pour analyser
les effectifs comptabilisés, les frais de scolarité constatés,
les règlements et les soldes.

Il complète les transformations Power Query, les relations du modèle
et les contrôles de préparation des données.

Les scénarios DAX exécutés sur la version `suivi-scolarite-tests`
sont consignés dans le
[journal de contrôle qualité](../docs/controle-qualite.md).

Leurs conclusions concernent cette version et les scénarios examinés.
Elles ne valident pas automatiquement tous les filtres, toutes les
interactions ou une autre version du modèle.

GitHub conserve les définitions et leur documentation.
Il ne les exécute pas et ne met pas automatiquement à jour
le modèle publié dans Power BI Service.

---

## 1. Objectifs

- Compter les élèves distincts à partir des comptes tiers.
- Distinguer les mouvements mensuels des cumuls académiques.
- Calculer les frais constatés, règlements et soldes à date.
- Produire un taux de recouvrement sur un périmètre cohérent.
- Permettre une analyse par classe, niveau et section.
- Documenter le fonctionnement des filtres et des périodes disponibles.
- Faciliter la reproduction et la maintenance des indicateurs.

Les indicateurs comptables doivent rester distincts des inscriptions
administratives, de la présence quotidienne et des retards de paiement.

---

## 2. Organisation des définitions

Le catalogue documenté utilise les fichiers suivants :

| Fichier | Contenu |
|---|---|
| `00_calendrier.dax` | Table calendrier et attributs temporels |
| `01_mesures_base.dax` | Montants, lignes comptables et mouvements D/C |
| `02_effectifs.dax` | Élèves distincts et effectif cumulé |
| `03_cumuls_scolaires.dax` | Cumuls académiques, solde et taux de recouvrement |
| `04_parametre_mesures.dax` | Sélection de l’indicateur présenté dans les visuels |

Les préfixes numériques organisent les fichiers du dépôt.
Ils ne font pas partie des noms des tables ou des mesures Power BI.

Ces fichiers constituent un catalogue de définitions.
Ils ne doivent pas être collés intégralement dans une seule mesure
ni considérés comme des requêtes DAX exécutables en bloc.

Les objets doivent être créés ou modifiés selon leur nature :
table calculée, colonne calculée, mesure ou paramètre de champs.

---

## 3. Prérequis du modèle

Les formules reposent sur les conventions suivantes :

- Ecritures contient les mouvements retenus sur les comptes tiers élèves.
- Les contreparties de produits et de trésorerie ont été exclues.
- Un Compte T correspond à un seul élève.
- Les comptes sont des identifiants textuels.
- Les montants sont non négatifs selon la convention source confirmée.
- Le type documenté de la colonne Montants est le nombre entier.
- Sens contient D pour les constatations et C pour les règlements.
- La colonne Date des écritures est de type Date.

Les anomalies de clés, de dates, de sens ou de montants doivent être
examinées dans les contrôles de préparation.

### Relations documentées

| Relation | Cardinalité |
|---|---|
| Calendrier[Date] → Ecritures[Date] | Un à plusieurs |
| Comptes T[Compte T] → Ecritures[Compte T] | Un à plusieurs |
| Comptes G[Compte G] → Ecritures[Compte G] | Un à plusieurs |

Les relations doivent être actives pour les usages concernés,
avec un filtrage simple des dimensions vers les écritures,
sans chemin ambigu.

Les clés doivent être uniques du côté « un ».

La table Calendrier doit contenir des dates uniques, continues
et non vides, et être marquée comme table de dates
avec `Calendrier[Date]`.

Le paramètre de champs `Mesures` reste déconnecté des tables métier.

### Informations scolaires

La classe de l’écriture provient du quatrième champ de E.txt.
Le niveau est ajouté par rapprochement avec Comptes T.
La section est disponible dans le référentiel élèves.

Le choix des champs utilisés dans les segments doit être cohérent
avec les relations et le périmètre analysé.

`Ecritures[Classe]` et `Comptes T[Classe]` décrivent deux sources
de rattachement. Une différence doit être examinée avant correction.

---

## 4. Mesures financières et conventions comptables

### Mesures de base

| Mesure | Signification |
|---|---|
| Total Montants | Somme technique des montants dans le contexte courant |
| Total lignes écritures | Nombre de lignes comptables dans le contexte courant |
| Total Pension | Montants au débit dans la période sélectionnée |
| Total Réglé | Montants au crédit dans la période sélectionnée |

Sans filtre de sens, `Total Montants` additionne les débits et crédits.
Ce n’est ni un solde ni le montant des seuls frais de scolarité.

`Total lignes écritures` ne mesure pas un effectif.
L’export ne comporte pas d’identifiant unique de mouvement :
le nombre de lignes ne doit pas non plus être présenté automatiquement
comme un nombre d’opérations uniques.

### Conventions D/C

Dans le périmètre confirmé :

```text
Débit du compte tiers élève = constatation de la scolarité

Crédit du compte tiers élève = règlement pour l’élève
```

Les contreparties de produits et de trésorerie ne sont pas ajoutées
aux montants analysés.

Après leur exclusion, il n’est pas attendu que le total débit
soit égal au total crédit dans la table analytique.

### Mesures cumulatives

| Mesure | Signification |
|---|---|
| Pensions déjà Constatées | Scolarité constatée cumulée depuis le début du cycle |
| Règlements déjà perçus | Règlements cumulés sur le même cycle |
| Solde restant | Différence entre constatations et règlements cumulés |
| % Recouvrement Global | Règlements cumulés divisés par constatations cumulées |

Les mesures suivantes réutilisent les indicateurs cumulatifs documentés :

| Mesure de restitution | Indicateur réutilisé |
|---|---|
| Cumul Mensuel Pensions | Pensions déjà Constatées |
| Cumul Mensuel Réglé | Règlements déjà perçus |
| Cumul Mensuel Solde | Solde restant |

### Solde restant

```text
Scolarité constatée cumulée − Règlements cumulés
```

Les deux composantes doivent être évaluées sur les mêmes bornes
et avec les mêmes filtres métier.

Le libellé « Solde dû » utilisé dans certains graphiques ne signifie
pas que toutes les sommes sont échues.

Un solde positif n’est pas automatiquement un retard de paiement.
Un éventuel solde créditeur doit être examiné, et non ramené
arbitrairement à zéro.

### Taux de recouvrement

```text
Règlements cumulés / Scolarité constatée cumulée
```

Le numérateur et le dénominateur doivent utiliser les mêmes bornes
temporelles et le même périmètre.

Une division non calculable reste vide selon la convention documentée.
Elle ne doit pas être remplacée arbitrairement par un taux nul.

Les ratios inhabituels doivent être examinés à partir des sources,
du contexte et des conventions comptables.

---

## 5. Définition des effectifs

| Mesure | Périmètre du comptage distinct |
|---|---|
| Effectif | Comptes élèves ayant une constatation dans la période sélectionnée |
| Effectif actuel | Comptes élèves ayant une constatation depuis le début du cycle jusqu’à l’arrêté mensuel |

### Comptage distinct

Le comptage porte sur `Compte T`, et non sur le nom de l’élève
ou le nombre de lignes au débit.

Si un élève possède plusieurs constatations dans la période,
il reste compté une seule fois dans le contexte évalué.

### Effectif cumulé

L’effectif à date est recalculé sur l’ensemble de la période académique
jusqu’à l’arrêté retenu.

Il ne correspond pas à l’addition des effectifs distincts mensuels :
un même élève peut apparaître dans plusieurs mois.

### Limites d’interprétation

Cet indicateur décrit les élèves représentés dans les constatations
comptables du périmètre.

Il ne constitue ni un suivi de présence quotidienne
ni un rapprochement automatique avec le registre des inscriptions.

Les élèves ayant une constatation pendant un mois ne sont pas
nécessairement de nouveaux inscrits.

Les inscriptions nouvelles, départs et annulations nécessitent
des données et des règles spécifiques pour être analysés.

---

## 6. Conventions temporelles

### Cycle académique

Le cycle analytique commence le **1er août** et se termine
le **31 juillet** suivant.

Les cumuls se poursuivent jusqu’à la fin du mois sélectionné.
Ils ne recommencent pas à zéro en janvier.

| Mois sélectionné | Période cumulée |
|---|---|
| Octobre 2025 | 01/08/2025 au 31/10/2025 |
| Février 2026 | 01/08/2025 au 28/02/2026 |
| Avril 2026 | 01/08/2025 au 30/04/2026, selon les écritures disponibles |

Octobre 2025 est une situation de référence,
pas une date inscrite en dur dans les mesures cumulatives.

### Sélections et filtres

Les règles documentées prévoient :

- une seule année académique dans le contexte ;
- le dernier mois comme arrêté si plusieurs mois du même cycle
  sont sélectionnés ;
- la prise en compte des mois antérieurs du même cycle pour les cumuls ;
- la conservation des filtres métier pertinents selon les relations
  du modèle.

Les filtres de classe, niveau, section et compte élève ne doivent pas
être supprimés sans justification lors de la reconstruction
du contexte temporel.

Une sélection explicite de l’année académique et du mois
est recommandée pour les cartes de situation.

Les sélections couvrant plusieurs cycles restent à tester
et à consigner. Elles ne doivent pas être interprétées implicitement
comme un cumul académique continu.

### Disponibilité des données

La règle documentée s’appuie sur la dernière date d’écriture globale
des données chargées.

Les mesures cumulatives renvoient une valeur vide si le mois
sélectionné dépasse le dernier mois contenant des écritures.

Lors de la campagne documentée, la dernière date affichée était :

```text
02/04/2026
```

Le test avec mai 2026 a produit des mesures cumulées vides.

Ce résultat ne signifie ni qu’aucune opération réelle n’a eu lieu
en mai, ni que l’effectif est nul, ni que le solde a été réglé.

Le dernier mois disponible peut être incomplet.
La disponibilité d’avril ne démontre pas son exhaustivité.

Un mois disponible sans mouvement pour un filtre particulier
constitue un cas distinct d’un mois situé au-delà des données.
Ce comportement doit être examiné selon les mesures utilisées.

### Absence de sélection mensuelle

Si le contexte s’étend jusqu’à la fin du calendrier mais que les données
s’arrêtent plus tôt, les cartes cumulées peuvent rester vides
selon la règle de disponibilité retenue.

Une carte vide ne doit donc pas être assimilée automatiquement
à une erreur de calcul ou à un échec d’actualisation.

### Analyse journalière

Les mouvements d’une journée utilisent les mesures de base,
filtrées sur la date concernée.

Les cartes arrêtées en fin de mois ne représentent pas une situation
à la fin de la journée sélectionnée.

Une situation cumulée à fin de journée nécessiterait une convention
et une mesure dédiées.

### Totaux

Les totaux DAX sont évalués dans leur propre contexte.

Il ne faut pas additionner les situations cumulées de chaque ligne
mensuelle pour obtenir un total annuel.

Les effectifs distincts et les ratios doivent également être recalculés
dans le contexte du total, plutôt que sommés mécaniquement.

---

## 7. Calendrier et attributs d’affichage

Le calendrier couvre les cycles académiques complets correspondant
aux dates des écritures disponibles.

Pour le périmètre documenté, il s’étend du **1er août 2025
au 31 juillet 2026**.

Il distingue notamment :

- l’année civile ;
- l’année de début du cycle académique ;
- le libellé de l’année académique ;
- le mois civil et son ordre dans le cycle ;
- l’année-mois ;
- la date et les attributs de la vue journalière.

### Réglages de tri documentés

| Colonne affichée | Colonne de tri |
|---|---|
| Année académique | AnneeDebutAcademique |
| Mois | Mois académique num |
| Year-month | AnneeMoisTri |
| Date_jour | Date |
| Day Name | Week Day_num |

La table doit être marquée comme table de dates
avec `Calendrier[Date]`.

Les relations et les calculs temporels utilisent cette véritable
colonne Date.

Les colonnes produites avec `FORMAT`, telles que les libellés
de présentation, ne remplacent pas la date utilisée pour les relations.

La numérotation `Year Week_num` documentée utilise un début de semaine
le lundi. Elle ne constitue pas une numérotation ISO ni une clé unique
sur plusieurs années.

La présence de dates sans écritures ne crée pas de mouvements
ni de données prévisionnelles.

---

## 8. Paramètre de champs et restitution

La table `Mesures` permet de sélectionner l’indicateur présenté
dans les graphiques de synthèse.

| Ordre documenté | Libellé proposé | Mesure référencée |
|---:|---|---|
| 0 | Pensions déjà Constatées | Pensions déjà Constatées |
| 1 | Règlements déjà perçus | Règlements déjà perçus |
| 2 | Solde restant | Solde restant |
| 3 | Effectif actuel | Effectif actuel |

### Création du paramètre

Le paramètre doit être créé avec la fonctionnalité Power BI :

```text
Modélisation → Nouveau paramètre → Champs
```

Les intitulés peuvent varier selon la version de Desktop.

Une simple table contenant les mêmes textes ne reproduit pas
nécessairement la configuration d’un paramètre de champs.

Les références doivent correspondre aux mesures et à leurs tables
d’accueil réelles.

Le paramètre reste déconnecté des tables métier.
Il sélectionne des mesures existantes sans effectuer leur calcul.

Une sélection unique est recommandée afin de ne pas mélanger
montants et effectifs sur une même échelle.

### Présentation dans la galerie

Dashboard 1 est présenté sous quatre variantes correspondant
aux quatre choix du sélecteur.

Les graphiques changent d’indicateur, tandis que les cinq cartes
de synthèse restent visibles.

Avec une capture pour chacun des dashboards 2 à 5, la galerie comprend
huit captures représentant cinq pages du rapport.

### Interactions et axes temporels

Un calcul cumulatif ne rétablit pas automatiquement les mois
retirés de l’axe d’un graphique par un segment.

L’affichage de plusieurs mois dépend également des champs d’axe
et des interactions configurées dans le rapport.

Dans les captures de référence :

- les cartes présentent la situation au 31 octobre 2025 ;
- les visuels d’évolution présentent plusieurs mois disponibles,
  selon les explications de la galerie.

Les résultats postérieurs à octobre sont rétrospectifs.
Ils ne sont pas présentés comme une prévision connue en octobre.

Les captures sont statiques et ne permettent pas de tester
les interactions depuis GitHub.

[Consulter la galerie commentée](../images/README.md)

---

## 9. Utilisation des fichiers

Les instructions suivantes s’appliquent lorsqu’une définition doit
être intégrée ou modifiée dans le modèle.

Une actualisation de ce README ne nécessite pas, à elle seule,
de recréer les objets DAX.

Dans une copie autorisée du fichier Power BI Desktop :

1. Vérifier les tables, colonnes et relations utilisées.
2. Créer ou modifier le calendrier avec « Nouvelle table ».
3. Créer séparément les colonnes calculées uniquement lorsque
   le catalogue les définit comme des objets distincts.
4. Créer chaque mesure avec « Nouvelle mesure » ou modifier
   la mesure existante.
5. Respecter l’ordre des dépendances entre mesures.
6. Créer ou vérifier le paramètre de champs avec la fonctionnalité dédiée.
7. Définir les formats numériques et les règles de tri.
8. Exécuter les scénarios de contrôle concernés.
9. Consigner les résultats avant d’intégrer la version retenue.

Si la définition du calendrier crée déjà ses attributs,
ne pas les recréer une seconde fois comme colonnes indépendantes.

Si les objets existent, examiner leurs dépendances avant
de les supprimer ou de les renommer.

Ne pas coller plusieurs définitions dans une seule mesure.

Les intitulés métier conservés dans le rapport, notamment
« Effectif actuel », doivent rester cohérents avec leur définition
documentée.

---

## 10. Formats et lecture des résultats

| Élément | Format |
|---|---|
| Montants | Valeurs numériques avec séparateur de milliers et unité FCFA explicite |
| Effectifs et nombres de lignes | Nombres entiers |
| Taux de recouvrement | Pourcentage, deux décimales |
| Dates | Date lisible avec année non ambiguë |
| Année académique | Libellé tel que 2025/2026 |

La fonction `FORMAT` transforme une valeur en texte.
Elle est adaptée aux libellés, mais ne doit pas remplacer le format
numérique des mesures utilisées dans les calculs ou les graphiques.

Les titres et unités doivent suivre l’indicateur choisi
dans le paramètre de champs.

Dans les graphiques :

- K représente des milliers ;
- M représente des millions ;
- les étiquettes peuvent être arrondies.

Les comparaisons de contrôle doivent utiliser les valeurs suffisamment
précises, et non uniquement des étiquettes abrégées.

Une valeur vide, un zéro et une erreur ne doivent pas être considérés
comme équivalents.

---

## 11. Validation des indicateurs

La validation DAX est distincte des contrôles de conservation
effectués dans Power Query.

La conservation des lignes et montants lors d’une jointure
ne démontre pas automatiquement que toutes les mesures DAX
sont correctes.

### Campagne consignée

| Élément | Information |
|---|---|
| Date réelle d’exécution | 19/10/2026 |
| Version ou date d’extraction des fichiers | 07/10/2026 |
| Version du modèle testé | suivi-scolarite-tests |
| Situation principale contrôlée | Arrêté au 31 octobre 2025 |
| Référence du commit correspondant | À renseigner dans le journal |

### Scénarios exécutés

| ID | Test | Résultat consigné |
|---|---|---|
| DAX-01 | Situation d’octobre 2025 | Montants mensuels et cumulés conformes aux repères sur la version testée |
| DAX-02 | Comptage distinct | 58 élèves sur octobre ; 221 en cumul à fin octobre |
| DAX-03 | Passage décembre-janvier | Conservation des mouvements antérieurs dans les cumuls |
| DAX-04 | Situation de février 2026 | Cumuls et solde conformes aux repères testés |
| DAX-05 | Mai 2026, au-delà du dernier mois d’écritures | Mesures cumulées vides selon la règle de disponibilité |
| DAX-06 | Filtre de section | Réaction des résultats confirmée par l’auteur |

Ces conclusions reposent sur les exécutions et confirmations
de l’auteur consignées dans le journal.

Aucun écart ni message d’erreur n’a été signalé pour ces scénarios.

### Résultats d’octobre 2025

| Indicateur | Résultat consigné |
|---|---:|
| Élèves distincts ayant une constatation en octobre | 58 |
| Scolarité constatée pendant octobre | 3 805 000 FCFA |
| Règlements enregistrés pendant octobre | 3 286 000 FCFA |
| Effectif actuel — élèves distincts cumulés à fin octobre | 221 |
| Scolarité constatée cumulée | 15 220 000 FCFA |
| Règlements cumulés | 7 488 000 FCFA |
| Solde restant | 7 732 000 FCFA |
| Taux de recouvrement cumulé | 49,20 % |

Rapprochements à partir des valeurs consignées :

```text
15 220 000 − 7 488 000 = 7 732 000 FCFA

7 488 000 / 15 220 000 ≈ 49,20 %
```

Les 58 élèves du mois ne doivent pas être assimilés automatiquement
à de nouvelles inscriptions.

Les résultats sont liés à la version, aux données et aux filtres du test.
Ils ne doivent pas être imposés artificiellement à un autre jeu
ou à une version corrigée.

### Vérifications complémentaires

Les scénarios consignés ne couvrent pas automatiquement :

- tous les filtres de classe et de niveau ;
- tous les contextes de total ;
- le comportement complet du paramètre de champs et des formats ;
- les interactions de la page journalière ;
- les mois sans mouvement à l’intérieur de la période disponible ;
- les sélections couvrant plusieurs cycles ;
- le tri chronologique des axes et tableaux ;
- la concordance avec le modèle publié dans Power BI Service.

Les rapprochements avec le registre des inscriptions
et la vérification de l’exhaustivité des exports restent
des contrôles métier distincts.

Le suivi des contrôles exécutés et des références manquantes
est centralisé dans le
[journal de contrôle qualité](../docs/controle-qualite.md).

---

## 12. Versions et traçabilité

Pour chaque modification fonctionnelle, conserver :

- la nature et la version des données ;
- la version des définitions DAX ;
- la version du modèle ;
- les filtres appliqués ;
- les résultats attendus et observés ;
- les conclusions et les preuves de test ;
- les corrections et les nouveaux tests ;
- la référence du commit du code concerné.

Une modification des données, des relations ou des mesures
nécessite de réexaminer les contrôles affectés.

Les références doivent distinguer :

- le code documenté dans GitHub ;
- le modèle utilisé pour la campagne de tests ;
- le modèle actuellement publié dans Power BI Service ;
- les supports de présentation de la galerie.

La publication du rapport dans Power BI Service a été confirmée
par l’auteur. La correspondance exacte avec la version testée
reste à consigner.

Un commit GitHub ne modifie pas automatiquement le modèle publié.
Une actualisation des données ne récupère pas non plus
les modifications DAX d’un fichier Desktop local.

Les modalités de mise à jour sont décrites dans la
[documentation de déploiement](../docs/deploiement.md).

---

## 13. Confidentialité et démonstration

Les fichiers DAX publics ne doivent contenir aucune valeur réelle
identifiante : nom d’élève, compte tiers personnel ou correspondance
avec une identité.

Les résultats individuels des tests métier restent dans l’environnement
interne autorisé.

La galerie publique distingue :

- les restitutions agrégées des dashboards 1 à 3 ;
- les lignes entièrement synthétiques des dashboards 4 et 5,
  selon la confirmation de l’auteur.

Ces lignes synthétiques ne reproduisent aucune situation réelle d’élève.
Elles ne résultent pas seulement du remplacement des noms.

Cette adaptation de présentation ne requalifie pas les sources réelles
ni la version ayant servi à la campagne de tests.

Les conclusions de cette campagne ne sont pas automatiquement
transposées à une version synthétique différente.

Les captures illustrent le rendu du rapport.
Elles ne constituent ni un jeu de données téléchargeable
ni une preuve complète de validation des calculs.

Les exports réels et les modèles contenant les données détaillées
restent hors du dépôt public.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Galerie du rapport](../images/README.md)
- [Méthodologie](../docs/methodologie.md)
- [Dictionnaire des données](../docs/dictionnaire-donnees.md)
- [Préparation Power Query](../powerquery/README.md)
- [Plan de contrôle qualité](../quality/README.md)
- [Journal des contrôles exécutés](../docs/controle-qualite.md)
- [Données et conditions de diffusion](../data/README.md)
- [Confidentialité](../docs/confidentialite.md)
- [Déploiement](../docs/deploiement.md)
