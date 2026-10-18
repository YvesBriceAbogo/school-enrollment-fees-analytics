# Méthodologie de traitement et d’analyse

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document présente la démarche utilisée pour transformer les exports
comptables Sage Saari en un modèle analytique et un rapport Power BI.

Il précise les choix de préparation, les conventions métier,
les règles temporelles et les contrôles nécessaires à l’interprétation
des résultats.

Les contrôles Power Query ont été déclarés exécutés par l’auteur.
La validation des mesures DAX révisées constitue une étape distincte,
dont les résultats doivent être consignés dans le journal de contrôle.

---

## 1. Finalité du projet

Le projet vise à fournir une lecture structurée :

- des élèves représentés dans les constatations comptables ;
- des frais de scolarité constatés ;
- des règlements enregistrés ;
- des soldes restant à recouvrer ;
- des répartitions par classe, niveau et section ;
- des évolutions mensuelles et cumulées.

La démarche associe connaissance comptable et traitement des données.

Les indicateurs doivent être suffisamment documentés pour distinguer
une inscription comptabilisée, un mouvement financier, un cumul
et une situation arrêtée à une date donnée.

---

## 2. Cadrage

| Élément | Convention retenue |
|---|---|
| Source | Exports TXT de Sage Saari version 15 |
| Nature des données | Réelles |
| Périmètre comptable | Comptabilité exclusivement consacrée à la scolarité |
| Année académique étudiée | 2025/2026 |
| Données disponibles | Août 2025 à avril 2026 |
| Début analytique du cycle | 1er août |
| Situation de référence illustrée | Arrêté au 31 octobre 2025 |
| Devise | FCFA |

La date du 31 octobre 2025 sert d’illustration.
Elle n’est pas inscrite en dur dans les mesures cumulatives.

Les données ultérieures sont utilisées pour une analyse rétrospective,
et non comme une prévision connue à cette date.

---

## 3. Chaîne de traitement

```text
Sage Saari version 15
        ↓
Exports G.txt, T.txt et E.txt
        ↓
Lecture et préparation dans Power Query
        ↓
Comptes G → Comptes T → enrichissement d’Ecritures
        ↓
Contrôles des référentiels, rapprochements et montants
        ↓
Modèle Power BI et calendrier académique
        ↓
Mesures DAX et paramètre de champs
        ↓
Rapport de synthèse et analyses détaillées
```

L’export depuis Sage est une étape distincte de l’actualisation Power BI.

L’actualisation du modèle lit les fichiers disponibles.
Elle ne produit pas automatiquement de nouveaux exports Sage
si aucun mécanisme dédié n’a été mis en place.

---

## 4. Extraction et paramétrage

Les traitements exploitent :

| Fichier | Contenu |
|---|---|
| G.txt | Référentiel des comptes généraux |
| T.txt | Référentiel des comptes tiers élèves |
| E.txt | Écritures comptables |

Le paramètre `pDossierSource` indique le dossier contenant les exports.

Les scripts publiés ne comportent pas de chemin personnel.
L’utilisateur renseigne le chemin réel dans son environnement.

Les formats documentés sont :

- séparateur : virgule ;
- absence d’en-tête dans les structures fournies ;
- G.txt et E.txt annoncés en ANSI, lus en Windows-1252 dans les scripts ;
- T.txt en UTF-8 ;
- dates de E.txt au format JJMMAA.

La restitution des accents et l’interprétation des dates doivent
rester contrôlées après chaque changement de format d’export.

---

## 5. Préparation des référentiels

### 5.1. Comptes généraux

La requête `Comptes G` :

1. Lit G.txt.
2. Conserve les identifiants au type Texte.
3. Nettoie les champs.
4. Sélectionne le périmètre documenté.
5. Exclut explicitement les deux comptes divers hors périmètre.
6. Vérifie les libellés et l’unicité de Compte G.

La suppression initiale des deux dernières lignes a été remplacée
par une exclusion fondée sur les codes des comptes concernés.

Cette règle ne dépend donc plus de leur position dans le fichier.

Les regroupements utiles, tels que PRIMAIRE ou PRIMARY SCHOOL,
ne sont pas supprimés au seul motif qu’ils ne désignent pas
une classe précise.

### 5.2. Comptes tiers élèves

La requête `Comptes T` :

1. Lit T.txt en UTF-8.
2. Prépare Compte T, Nom et Compte G.
3. Vérifie les champs obligatoires.
4. Contrôle l’unicité de Compte T.
5. Rapproche le compte général avec Comptes G.
6. Récupère la classe du référentiel.
7. Détermine Niveau+ et Section.

La convention métier confirmée est :

```text
Un compte tiers correspond à un seul élève.
```

Les classifications scolaires reposent sur des correspondances explicites.

Une classe inconnue est signalée au lieu d’être affectée automatiquement
au primaire francophone.

---

## 6. Préparation des écritures

### 6.1. Structure de l’export

E.txt contient les champs suivants :

```text
Code, Date, Compte G, Classe, Compte T, Montant, Sens
```

Le quatrième champ représente la classe portée par l’écriture.
Il n’est pas remplacé par la classe du référentiel élèves.

### 6.2. Conversion des dates

La méthode initiale est conservée :

1. Découper le texte en groupes de deux caractères.
2. Recomposer la date avec `/`.
3. Convertir le résultat en Date avec la culture `fr-FR`.

Exemple :

```text
200825 → 20 / 08 / 25 → 20/08/2025
```

L’interprétation des années sur deux chiffres doit être vérifiée,
notamment lors du passage de 2025 à 2026.

### 6.3. Sélection comptable

Les traitements retiennent les lignes des comptes commençant par `4`,
selon le périmètre scolaire confirmé.

Les contreparties de produits et de trésorerie sont exclues avant
les calculs analytiques.

Dans les lignes retenues :

| Sens | Signification |
|---|---|
| D | Constatation de la scolarité sur le compte élève |
| C | Règlement sur le compte élève |

Cette sélection évite d’additionner les contreparties avec les mouvements
des comptes élèves.

Le préfixe `4` n’est pas présenté comme une règle universelle pour
identifier des élèves dans une autre comptabilité.

### 6.4. Typage

Les comptes généraux et tiers sont conservés en texte.

Les montants restent des nombres entiers, conformément à la structure
confirmée de l’export et au traitement retenu.

Le sens reste une colonne textuelle contenant D ou C.

### 6.5. Enrichissement

Une jointure gauche sur Compte T permet d’ajouter uniquement Niveau+
depuis le référentiel Comptes T.

La classe de l’écriture est conservée.
La section reste disponible dans le référentiel.

La jointure ne doit ni supprimer les écritures retenues ni multiplier
leurs montants.

Les comptes non rapprochés sont examinés dans les contrôles.

### 6.6. Absence de déduplication automatique

Deux lignes similaires peuvent correspondre à deux opérations réelles.

L’export présenté ne comporte pas d’identifiant unique de mouvement.
Aucune suppression automatique des écritures similaires n’est donc réalisée.

---

## 7. Contrôles de préparation

Quatre requêtes de contrôle sont documentées :

| Contrôle | Objet |
|---|---|
| CONTROLE_NiveauxManquants | Repérer les écritures sans Niveau+ |
| CONTROLE_CoherenceClasses | Comparer la classe de l’écriture à celle du référentiel |
| CONTROLE_ValiditeEcritures | Vérifier les champs, types, sens et montants |
| CONTROLE_ConservationJointure | Comparer les lignes et montants avant et après enrichissement |

### Résultats communiqués

L’auteur a indiqué avoir exécuté les contrôles dans son modèle
avec des résultats satisfaisants.

Le contrôle de conservation a été déclaré conforme pour :

- le nombre total de lignes ;
- le nombre de lignes au débit ;
- le nombre de lignes au crédit ;
- le total des montants au débit ;
- le total des montants au crédit.

Les dates, versions et valeurs détaillées doivent être conservées
dans le journal de contrôle.

### Portée

La conservation est vérifiée entre le périmètre scolaire préparé
avant jointure et la table enrichie.

Il n’est pas attendu que le total débit soit égal au total crédit
après exclusion des contreparties.

La conformité des agrégats ne prouve pas, à elle seule, l’exhaustivité
des exports ni l’exactitude de chaque affectation.

---

## 8. Modélisation Power BI

Le modèle s’appuie sur :

- Ecritures : table de faits ;
- Comptes T : référentiel élèves ;
- Comptes G : référentiel comptable ;
- Calendrier : dimension temporelle ;
- Mesures : paramètre de champs.

### Relations attendues

| Relation | Cardinalité |
|---|---|
| Calendrier[Date] → Ecritures[Date] | Un à plusieurs |
| Comptes T[Compte T] → Ecritures[Compte T] | Un à plusieurs |
| Comptes G[Compte G] → Ecritures[Compte G] | Un à plusieurs |

Le filtrage simple part des dimensions vers les écritures.

Les clés du côté « un » doivent être uniques.
Les chemins de filtrage ambigus doivent être évités.

### Deux sources de classe

- Ecritures[Classe] décrit la classe portée par le mouvement.
- Comptes T[Classe] décrit le rattachement du référentiel.

Une différence doit être expliquée avant correction.

Si le référentiel évolue entre plusieurs années académiques,
l’analyse historique peut nécessiter une gestion des rattachements
par période. La version courante ne doit pas être supposée valable
pour toutes les périodes sans contrôle.

---

## 9. Définition des indicateurs

### Mouvements de période

- Total Pension : montants des constatations au débit.
- Total Réglé : montants des règlements au crédit.
- Total lignes écritures : nombre de mouvements sélectionnés.
- Total Montants : somme technique des montants sélectionnés.

Sans filtre de sens, Total Montants additionne les débits et crédits.
Cette mesure n’est donc ni un solde ni le montant des seuls frais.

### Effectifs

L’effectif repose sur le nombre distinct de Compte T ayant
une constatation de scolarité.

Un élève ayant plusieurs écritures reste compté une seule fois
dans le périmètre évalué.

Le cumul doit recalculer les comptes distincts sur toute la période.
Il ne doit pas additionner les effectifs distincts mensuels.

Cet indicateur ne mesure pas la présence quotidienne.

### Montants cumulés

Les frais constatés et les règlements sont cumulés sur les mêmes
bornes académiques.

Le solde est calculé par différence :

```text
Scolarité constatée cumulée − Règlements cumulés
```

Le taux de recouvrement est :

```text
Règlements cumulés / Scolarité constatée cumulée
```

Une division non calculable reste vide.
Les soldes négatifs et ratios inhabituels doivent être examinés,
et non corrigés arbitrairement.

Un solde positif ne constitue pas automatiquement un retard :
les échéances de paiement doivent être connues pour établir
cette qualification.

---

## 10. Gestion de l’année académique

Le cycle retenu commence le 1er août et se termine le 31 juillet suivant.

Les mesures de situation s’arrêtent à la fin du mois sélectionné.

| Sélection | Période cumulée |
|---|---|
| Octobre 2025 | 01/08/2025 au 31/10/2025 |
| Février 2026 | 01/08/2025 au 28/02/2026 |
| Avril 2026 | 01/08/2025 au 30/04/2026 |

Le cumul ne repart pas à zéro en janvier.

### Comportement documenté des sélections

- Une seule année académique doit être présente dans le contexte.
- Si plusieurs mois du même cycle sont sélectionnés, le dernier mois
  définit l’arrêté.
- Un mois postérieur au dernier mois contenant des écritures renvoie
  une valeur vide.
- La dernière date d’écriture est déterminée globalement.
- Les filtres scolaires restent applicables aux calculs selon le modèle.

Le dernier mois disponible peut être incomplet.
La présence d’une écriture ne garantit pas son exhaustivité.

### Calendrier complet

Le calendrier couvre les cycles académiques complets correspondant
aux données disponibles.

Il peut donc contenir des dates sans opérations.
Ces dates ne constituent ni des prévisions ni des résultats confirmés.

### Absence de sélection mensuelle

Si le contexte va jusqu’à la fin du calendrier mais que les données
s’arrêtent plus tôt, les cartes cumulées peuvent rester vides
selon la règle de disponibilité retenue.

Le rapport doit proposer une sélection temporelle claire.

### Mouvements journaliers

Les tableaux journaliers utilisent les mesures de base filtrées
sur le jour concerné.

Les cartes cumulées en fin de mois ne doivent pas être présentées
comme une situation arrêtée à la fin du jour sélectionné.

---

## 11. Paramètre de champs et restitution

La table Mesures permet de sélectionner :

- Pensions déjà Constatées ;
- Règlements déjà perçus ;
- Solde restant ;
- Effectif actuel.

Le paramètre sélectionne des mesures existantes.
Il ne réalise pas leur calcul.

Une sélection unique est recommandée pour ne pas mélanger
les montants en FCFA et les nombres d’élèves sur une même échelle.

Les titres, unités et formats des graphiques doivent correspondre
à l’indicateur sélectionné.

### Organisation du rapport

1. Vue de synthèse.
2. Progression académique.
3. Analyse des mouvements mensuels.
4. Situation individuelle.
5. Suivi journalier.

Les interactions entre segments et visuels doivent être contrôlées.

Une mesure cumulative ne force pas un graphique à afficher des mois
retirés de son axe par un segment.

Une vue rétrospective août-avril peut être présentée à côté d’un arrêté
d’octobre, à condition que les titres et interactions rendent
cette différence explicite.

---

## 12. Validation DAX prévue

Les formules révisées sont documentées, mais leur validation reste
à consigner séparément des contrôles Power Query.

Les tests doivent notamment couvrir :

- le comptage distinct des élèves ;
- les mouvements du mois d’octobre ;
- les cumuls au 31 octobre 2025 ;
- le passage de décembre à janvier ;
- la situation à fin février 2026 ;
- les filtres de classe, niveau et section ;
- les mois sans mouvement ;
- les sélections de plusieurs cycles ;
- les mois postérieurs à la dernière donnée ;
- le paramètre de champs et les formats des visuels.

### Repères de l’export fourni

| Indicateur au 31 octobre 2025 | Valeur affichée |
|---|---:|
| Effectif | 221, à confirmer après comptage distinct |
| Scolarité constatée cumulée | 15 220 000 FCFA |
| Règlements cumulés | 7 488 000 FCFA |
| Solde restant | 7 732 000 FCFA |
| Taux de recouvrement | 49,20 % |

Ces valeurs servent de repères à données et filtres identiques.

Les résultats ne doivent pas être forcés pour reproduire un ancien
export si une correction justifiée modifie le calcul.

---

## 13. Reproductibilité et versions

Pour reproduire une analyse, conserver :

- la version des exports ;
- les formats de lecture ;
- les paramètres ;
- les scripts Power Query ;
- les relations du modèle ;
- les formules DAX ;
- les filtres appliqués ;
- les résultats des contrôles.

Après une modification fonctionnelle :

1. Tester dans une copie du modèle.
2. Comparer les résultats à périmètre identique.
3. Expliquer les écarts.
4. Documenter les corrections.
5. Mettre à jour le rapport.
6. Remplacer les captures et PDF devenus obsolètes.
7. Enregistrer la nouvelle version dans GitHub.

Un commit GitHub ne met pas automatiquement à jour le modèle Power BI.

---

## 14. Limites et confidentialité

- Les écritures ne constituent pas un registre de présence.
- Le comptage comptable doit être rapproché du périmètre d’inscription.
- L’exhaustivité des exports conditionne les résultats.
- Un solde non réglé n’est pas nécessairement échu.
- Les évolutions de classes ou de référentiels doivent être documentées.
- Les analyses rétrospectives ne sont pas des prévisions.
- Aucun gain de recouvrement ou de productivité n’est revendiqué
  sans mesure de résultat.

Les exports nominatifs et modèles contenant les données réelles
restent hors du dépôt public.

Les vues individuelles destinées à la démonstration doivent utiliser
des exemples fictifs ou une présentation empêchant l’identification
des élèves.

Masquer une colonne dans un rapport ne retire pas son contenu
du modèle.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Journal de contrôle qualité](controle-qualite.md)
- [Préparation Power Query](../powerquery/README.md)
- [Paramètres d’importation](../powerquery/parameters.example.md)
- [Contrôles de qualité](../quality/README.md)
- [Indicateurs DAX](../dax/README.md)
- [Données et conditions de diffusion](../data/README.md)
