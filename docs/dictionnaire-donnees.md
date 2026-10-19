# Dictionnaire des données

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document décrit les tables, colonnes et indicateurs du modèle
Power BI selon les traitements documentés dans le dépôt.

Il distingue les informations provenant des exports Sage, les données
ajoutées par Power Query et les objets calculés en DAX.

Les types indiqués correspondent à la version préparée et documentée.

Les contrôles exécutés et leurs résultats sont consignés dans le
[journal de contrôle qualité](controle-qualite.md).
Leurs conclusions concernent la version et les scénarios effectivement
testés ; elles ne constituent pas une validation de tous les usages
possibles du rapport.

Ce dictionnaire distingue le modèle métier alimenté par les exports
Sage de la version de démonstration utilisée pour les lignes
individuelles des dashboards 4 et 5.

---

## 1. Périmètre général

| Élément | Convention |
|---|---|
| Application source | Sage Saari version 15 |
| Format des exports | Fichiers TXT séparés par des virgules |
| Année académique étudiée | 2025/2026 |
| Période disponible | Août 2025 à avril 2026 |
| Situation de référence illustrée | Arrêté au 31 octobre 2025 |
| Début des cumuls académiques | 1er août |
| Devise | FCFA |
| Nature des données sources | Réelles, issues des exports Sage |
| Dashboards 1 à 3 — supports publics | Restitutions agrégées |
| Dashboards 4 et 5 — démonstration publique | Lignes individuelles entièrement synthétiques |
| Version publique | Sans identité réelle d’élève ni nom d’établissement |

Le mois d’octobre est une situation de référence, et non une date
figée dans les calculs.

Le périmètre comptable est exclusivement consacré à la scolarité.

---

## 2. Vue d’ensemble du modèle

| Table | Origine | Rôle | Granularité |
|---|---|---|---|
| Ecritures | E.txt et enrichissement Power Query | Mouvements comptables des comptes élèves | Une ligne par mouvement comptable retenu |
| Comptes T | T.txt et enrichissement Power Query | Référentiel des comptes élèves | Une ligne par Compte T |
| Comptes G | G.txt | Référentiel des regroupements comptables | Une ligne par Compte G retenu |
| Calendrier | Table calculée DAX | Dimension temporelle | Une ligne par jour |
| Mesures | Paramètre de champs Power BI | Sélection de l’indicateur affiché | Une ligne par indicateur proposé |

Une ligne d’Ecritures n’est pas nécessairement un élève distinct.

Le fichier source peut contenir plusieurs lignes pour une même opération
comptable. Les contreparties de produits et de trésorerie sont exclues
du périmètre analytique.

---

## 3. Sources TXT

### E.txt — Écritures

Ordre des champs :

```text
Code, Date, Compte G, Classe, Compte T, Montant, Sens
```

| Caractéristique | Description |
|---|---|
| En-tête | Aucun |
| Date source | JJMMAA |
| Montants | Non négatifs selon la convention confirmée |
| Encodage annoncé | ANSI |
| Encodage utilisé dans le script | Windows-1252 |
| Lignes de total ou de fin | Aucune signalée |

Exemples de conversion attendue :

```text
200825 → 20/08/2025
010925 → 01/09/2025
```

### T.txt — Comptes tiers

Ordre des champs :

```text
Compte T, Nom, Compte G
```

| Caractéristique | Description |
|---|---|
| En-tête | Aucun dans la structure fournie |
| Encodage | UTF-8 |
| Lignes de total | Aucune signalée |

### G.txt — Comptes généraux

Ordre des champs :

```text
Compte G, Libellé de regroupement, Marqueur d’export
```

| Caractéristique | Description |
|---|---|
| En-tête | Aucun dans la structure fournie |
| Encodage annoncé | ANSI |
| Encodage utilisé dans le script | Windows-1252 |
| Troisième champ | Non conservé dans la table finale |

Le marqueur d’export est distinct du sens D/C utilisé dans E.txt.

L’appellation ANSI ne constitue pas un encodage universel.
La restitution des accents doit rester contrôlée lors des imports.

---

## 4. Table Ecritures

### Colonnes

| Colonne | Type documenté | Origine | Signification |
|---|---|---|---|
| Code_J | Texte | Premier champ de E.txt | Code du journal comptable |
| Date | Date | Deuxième champ, transformé | Date du mouvement |
| Compte G | Texte | Troisième champ | Compte général de rattachement |
| Classe | Texte | Quatrième champ | Classe portée par l’écriture source |
| Compte T | Texte | Cinquième champ | Compte tiers correspondant à l’élève |
| Montants | Nombre entier | Sixième champ | Montant du mouvement en FCFA |
| Sens | Texte | Septième champ | D pour débit, C pour crédit |
| Niveau+ | Texte | Jointure avec Comptes T | Niveau scolaire associé au compte élève |

### Règles de préparation

- Les comptes sont conservés comme identifiants textuels.
- La date est découpée en groupes de deux caractères, recomposée
  avec le séparateur `/`, puis convertie avec la culture `fr-FR`.
- Les comptes commençant par `4` sont retenus selon le périmètre
  scolaire confirmé.
- Les contreparties de produits et de trésorerie sont exclues.
- La classe provenant de l’écriture est conservée.
- La jointure avec Comptes T ajoute uniquement Niveau+.
- La colonne Section reste disponible dans Comptes T.
- Aucune déduplication automatique des écritures n’est effectuée.

### Lecture comptable

| Sens sur le compte élève | Interprétation |
|---|---|
| D | Constatation des frais de scolarité |
| C | Règlement pour l’élève |

Après exclusion des contreparties, il n’est pas attendu que les totaux
débit et crédit soient égaux.

### Identifiant d’écriture

L’export présenté ne comporte pas d’identifiant unique de mouvement.

Code_J, Date ou Compte T ne doivent pas être utilisés seuls comme
identifiants uniques d’écriture.

Deux lignes similaires peuvent correspondre à deux opérations distinctes.

---

## 5. Table Comptes T

| Colonne | Type documenté | Origine | Signification |
|---|---|---|---|
| Compte T | Texte | T.txt | Identifiant unique du compte élève |
| Nom | Texte | T.txt | Nom de l’élève, destiné à l’usage interne |
| Compte G | Texte | T.txt | Compte général associé au compte tiers |
| Classe | Texte | Jointure avec Comptes G | Classe du référentiel élève |
| Niveau+ | Texte | Classification Power Query | Regroupement pédagogique et linguistique |
| Section | Texte | Classification Power Query | Section anglophone ou francophone |

### Règles

- Un Compte T correspond à un seul élève.
- Compte T doit être unique dans le référentiel.
- Chaque compte élève est rattaché à une classe précise.
- Un rattachement absent ou une classe inconnue doit être examiné.
- Le nom n’est pas utilisé comme clé de jointure.

La présence du nom dans le modèle interne ne justifie pas sa diffusion
dans le portfolio public.

### Présentation dans la version de démonstration

Le tableau de colonnes ci-dessus décrit le modèle métier interne.

Dans les dashboards 4 et 5 de la galerie, le champ affiché sous
le libellé « Noms » présente des prénoms fictifs.

Les lignes individuelles de cette version sont entièrement synthétiques,
conformément à la confirmation de l’auteur. Elles ne reproduisent
aucune situation réelle d’élève et ne résultent pas seulement
du remplacement des noms.

Les prénoms restent des libellés de présentation, et non des clés
de jointure.

### Classification documentée

| Classes | Niveau+ | Section |
|---|---|---|
| PETITE SECTION, MOYENNE SECTION, GRANDE SECTION | Maternelle Francophone | Section Francophone |
| PRE-NURSERY, NURSERY I, NURSERY II | Maternelle Anglophone | Section Anglophone |
| CLASS I à CLASS VI | Primaire Anglophone | Section Anglophone |
| CIL, CP, CE1, CE2, CM1, CM2 | Primaire Francophone | Section Francophone |

Les libellés réels doivent correspondre à la nomenclature contrôlée.

Une classe non reconnue ne doit pas être affectée automatiquement
à une catégorie par défaut.

---

## 6. Table Comptes G

| Colonne | Type documenté | Signification |
|---|---|---|
| Compte G | Texte | Identifiant du compte général retenu |
| Classe | Texte | Libellé de classe ou de regroupement comptable |

### Règles

- Compte G doit être unique.
- Le compte et son libellé doivent être renseignés.
- Les comptes hors périmètre sont exclus par leur identifiant,
  et non selon leur position dans le fichier.
- Les regroupements utiles sont conservés.

La colonne Classe peut contenir un libellé de regroupement général
comme PRIMAIRE ou PRIMARY SCHOOL.

Ces regroupements ne doivent pas être assimilés à une classe précise.
Les comptes élèves sont, selon la convention confirmée, rattachés
à des classes précises.

Le nom de colonne Classe est conservé pour rester compatible
avec les requêtes du modèle.

---

## 7. Table Calendrier

### Colonnes documentées

| Colonne | Type | Fonction |
|---|---|---|
| Date | Date | Jour unique du calendrier |
| Années | Nombre entier | Année civile |
| AnneeDebutAcademique | Nombre entier | Année de début du cycle académique |
| Année académique | Texte | Libellé du cycle, par exemple 2025/2026 |
| Mois | Texte | Libellé abrégé du mois en français |
| Mois num | Nombre entier | Numéro du mois civil, de 1 à 12 |
| Mois académique num | Nombre entier | Position du mois dans le cycle, août = 1 |
| Year-month | Texte | Libellé mois-année au format mm-yy |
| AnneeMoisTri | Nombre entier | Clé de tri chronologique AAAAMM |
| Date_jour | Texte | Date affichée au format dd-MM-yyyy |
| Year Week_num | Nombre entier | Numéro de semaine avec début le lundi |
| Week Day_num | Nombre entier | Jour de semaine, lundi = 1 |
| Day Name | Texte | Libellé abrégé du jour |
| Month Day_num | Nombre entier | Jour du mois, de 1 à 31 |

### Bornes

Le calendrier couvre les années académiques complètes contenant
les dates minimale et maximale des écritures.

Avec les données disponibles d’août 2025 à avril 2026,
la plage documentée va du 1er août 2025 au 31 juillet 2026.

Les dates ajoutées ne créent pas de mouvements comptables.

### Réglages

- Marquer Calendrier comme table de dates avec Date.
- Trier Année académique par AnneeDebutAcademique.
- Trier Mois par Mois académique num pour une présentation août-juillet.
- Trier Year-month par AnneeMoisTri.
- Trier Date_jour par Date.
- Trier Day Name par Week Day_num.

Date_jour est un texte de présentation.
La colonne Date reste la référence pour les relations et les calculs.

Year Week_num utilise WEEKNUM avec un début de semaine le lundi.
Il ne s’agit pas de la numérotation ISO et ce numéro ne constitue
pas une clé unique sur plusieurs années.

---

## 8. Table Mesures — Paramètre de champs

Cette table permet de sélectionner l’indicateur affiché dans
certains graphiques.

| Ordre | Libellé proposé | Mesure référencée |
|---:|---|---|
| 0 | Pensions déjà Constatées | Pensions déjà Constatées |
| 1 | Règlements déjà perçus | Règlements déjà perçus |
| 2 | Solde restant | Solde restant |
| 3 | Effectif actuel | Effectif actuel |

Power BI génère les colonnes du paramètre correspondant :

- au libellé affiché ;
- à la référence de champ ;
- à l’ordre de présentation.

Leurs noms exacts dépendent de la configuration du paramètre.

La table reste déconnectée des tables métier.
Elle ne contient pas de montants à additionner.

Le paramètre doit être créé avec la fonctionnalité de paramètres
de champs de Power BI, et non traité comme une simple table
de transactions.

Une sélection unique est recommandée pour éviter de mélanger
des montants en FCFA et des effectifs sur une même échelle.

---

## 9. Principales mesures DAX

| Mesure | Signification | Unité |
|---|---|---|
| Total Montants | Somme technique des montants sélectionnés, tous sens confondus sauf filtre | FCFA |
| Total lignes écritures | Nombre de lignes comptables dans le contexte | Lignes |
| Total Pension | Montants au débit sur la période sélectionnée | FCFA |
| Total Réglé | Montants au crédit sur la période sélectionnée | FCFA |
| Effectif | Comptes élèves distincts ayant une constatation dans la période | Élèves |
| Effectif actuel | Comptes élèves distincts ayant une constatation depuis le début du cycle jusqu’à l’arrêté mensuel | Élèves |
| Pensions déjà Constatées | Frais constatés cumulés sur le cycle | FCFA |
| Règlements déjà perçus | Règlements cumulés sur le même cycle | FCFA |
| Solde restant | Différence entre frais constatés et règlements cumulés | FCFA |
| % Recouvrement Global | Règlements cumulés divisés par frais constatés cumulés | Pourcentage |
| Cumul Mensuel Pensions | Réutilisation du cumul des frais constatés | FCFA |
| Cumul Mensuel Réglé | Réutilisation du cumul des règlements | FCFA |
| Cumul Mensuel Solde | Réutilisation du solde cumulé | FCFA |

### Interprétation

Total Montants, sans filtre de sens, additionne les débits et les crédits.
Ce n’est ni un solde ni le montant des seuls frais de scolarité.

Total lignes écritures ne mesure pas l’effectif.

L’effectif distinct n’est pas additif entre les mois :
un élève peut apparaître dans plusieurs périodes.

Le solde restant n’est pas automatiquement une somme échue.
L’identification des retards nécessite les échéances applicables.

---

## 10. Relations et jointures

### Préparation Power Query

- Comptes T est enrichie depuis Comptes G sur Compte G.
- Ecritures est enrichie depuis Comptes T sur Compte T.
- Les clés des référentiels doivent être uniques avant développement
  des colonnes issues des jointures.

### Relations du modèle attendues

| Relation | Cardinalité |
|---|---|
| Calendrier[Date] → Ecritures[Date] | Un à plusieurs |
| Comptes T[Compte T] → Ecritures[Compte T] | Un à plusieurs |
| Comptes G[Compte G] → Ecritures[Compte G] | Un à plusieurs |

Le filtrage simple va des dimensions vers les écritures.

Les relations doivent être vérifiées pour éviter les chemins ambigus.
Une jointure Power Query ne crée pas automatiquement une relation
dans le modèle Power BI.

### Deux sources de classe

Ecritures[Classe] conserve la classe portée par le mouvement.

Comptes T[Classe] représente la classe du référentiel élève.

Une différence doit être examinée avant correction.
Une évolution du rattachement peut nécessiter un traitement historique
si plusieurs périodes ou années sont analysées.

---

## 11. Conventions temporelles

Le cycle analytique va du 1er août au 31 juillet.

Les mesures de situation mensuelle cumulent depuis le début du cycle
jusqu’à la fin du mois sélectionné.

Exemples :

| Mois | Début du cumul | Date d’arrêté |
|---|---|---|
| Octobre 2025 | 01/08/2025 | 31/10/2025 |
| Février 2026 | 01/08/2025 | 28/02/2026 |
| Avril 2026 | 01/08/2025 | 30/04/2026 |

Les mesures cumulatives documentées :

- exigent une seule année académique dans le contexte ;
- retiennent le dernier mois si plusieurs mois du même cycle sont sélectionnés ;
- renvoient une valeur vide si la fin du mois dépasse le dernier mois
  contenant des écritures.

Cette dernière règle ne garantit pas que le dernier mois disponible
soit complet.

Les mouvements journaliers utilisent les mesures de base.
Les cartes arrêtées en fin de mois ne doivent pas être interprétées
comme une situation à la fin de la journée sélectionnée.

---

## 12. Qualité et limites

Les contrôles Power Query et les scénarios de test DAX sont consignés
dans le [journal de contrôle qualité](controle-qualite.md).

Les résultats reposent sur les exécutions effectuées par l’auteur,
ses confirmations et les éléments de preuve décrits dans ce journal.

### Synthèse des résultats documentés

| Contrôle | Conclusion consignée |
|---|---|
| Niveaux manquants, cohérence des classes et validité des écritures | Exécutés ; aucune anomalie signalée |
| Conservation des lignes et des montants après enrichissement | Écarts nuls confirmés sur le périmètre testé |
| Situation d’octobre 2025 | Montants mensuels et cumulés conformes aux repères |
| Comptage distinct | 58 élèves en octobre ; 221 en cumul à fin octobre |
| Continuité décembre-janvier et situation de février 2026 | Conformes aux repères testés |
| Sélection de mai 2026 | Mesures cumulées vides selon la règle de disponibilité |
| Filtre de section | Réaction des résultats confirmée par l’auteur |

### Portée des conclusions

Ces résultats concernent la version et les scénarios effectivement
examinés.

Ils ne démontrent pas automatiquement :

- l’exhaustivité des exports Sage ;
- la concordance avec le registre administratif des inscriptions ;
- la validité de toutes les affectations par classe et niveau ;
- le bon fonctionnement de tous les paramètres et interactions ;
- la concordance entre toutes les versions du rapport.

Les vérifications complémentaires restent détaillées dans le journal.

Toute modification des données, des transformations, des relations
ou des mesures nécessite de réexaminer les contrôles concernés.

La version synthétique de démonstration doit être distinguée
du modèle et des données de la campagne de tests documentée.

La galerie illustre le rendu du rapport. Elle ne remplace pas
les contrôles du modèle.

---

## 13. Confidentialité

Dans le modèle métier interne, la colonne Nom et les comptes tiers
peuvent identifier les élèves.

Leur présence dans le modèle n’autorise pas leur exposition
dans un dépôt public.

### Supports de présentation

La [galerie publique](../images/README.md) distingue :

- les restitutions agrégées des dashboards 1 à 3 ;
- les lignes individuelles entièrement synthétiques des dashboards 4 et 5.

Cette qualification concerne la version de démonstration de ces pages.
Elle ne requalifie pas les données sources réelles décrites
dans ce dictionnaire.

Les exports Sage réels, les correspondances avec les identités réelles
et le modèle contenant les données détaillées restent hors
du périmètre de publication.

Masquer un champ dans un visuel ne retire pas sa valeur du modèle.
Un fichier PBIX en mode Import peut conserver les données détaillées.

Les règles de diffusion sont précisées dans la
[documentation de confidentialité](confidentialite.md).

---

## Documentation associée

- [Présentation générale](../README.md)
- [Galerie du rapport](../images/README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Préparation Power Query](../powerquery/README.md)
- [Mesures DAX](../dax/README.md)
- [Contrôles de qualité](../quality/README.md)
- [Journal de contrôle qualité](controle-qualite.md)
