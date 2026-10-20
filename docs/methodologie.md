# Méthodologie de traitement et d’analyse

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document présente la démarche utilisée pour transformer les exports
comptables Sage Saari en un modèle analytique et un rapport Power BI.

Il précise les choix de préparation, les conventions métier,
les règles temporelles et les contrôles nécessaires à l’interprétation
des résultats.

Les contrôles Power Query et les scénarios DAX exécutés sont consignés
dans le [journal de contrôle qualité](controle-qualite.md).
Leurs conclusions concernent la version et les scénarios effectivement
examinés, et non tous les usages possibles du rapport.

La constitution de la galerie publique est une étape distincte.
Les captures illustrent le rendu du rapport sans remplacer
les tests du modèle.

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

Les indicateurs doivent permettre de distinguer :

- une constatation comptable et une inscription administrative ;
- un nombre de lignes et un nombre d’élèves distincts ;
- un mouvement de période et une situation cumulée ;
- un solde restant et une somme effectivement échue.

Le rapport soutient l’analyse et le suivi comptable.
Il ne remplace pas les vérifications métier nécessaires avant
une décision ou une relance.

---

## 2. Cadrage

| Élément | Convention retenue |
|---|---|
| Source du modèle métier | Exports TXT de Sage Saari version 15 |
| Nature des données sources | Réelles |
| Périmètre comptable | Comptabilité consacrée à la scolarité |
| Année académique étudiée | 2025/2026 |
| Données disponibles | Août 2025 à avril 2026 |
| Cycle analytique | Du 1er août au 31 juillet |
| Situation de référence illustrée | Arrêté au 31 octobre 2025 |
| Dernière date d’écriture affichée lors des tests | 02/04/2026 |
| Devise | FCFA |
| Dashboards 1 à 3 — supports publics | Restitutions agrégées |
| Dashboards 4 et 5 — démonstration publique | Lignes individuelles entièrement synthétiques, selon la confirmation de l’auteur |

La date du 31 octobre 2025 sert de situation de référence.
Elle n’est pas inscrite en dur dans les mesures cumulatives.

Les données ultérieures sont utilisées pour une analyse rétrospective,
et non comme une prévision connue à cette date.

La période disponible ne constitue pas nécessairement un cycle
académique complet. La présence d’écritures en avril ne démontre pas
l’exhaustivité de ce mois.

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
Contrôles des référentiels, jointures, lignes et montants
        ↓
Modèle Power BI et calendrier académique
        ↓
Mesures DAX et paramètre de champs
        ↓
Tests des scénarios métier et consignation des résultats
        ↓
Rapport de synthèse et analyses détaillées
```

L’export depuis Sage est une étape distincte de l’actualisation Power BI.

L’actualisation du modèle lit les fichiers disponibles.
Elle ne produit pas automatiquement de nouveaux exports Sage
si aucun mécanisme dédié n’a été mis en place.

La préparation des supports publics intervient séparément :
restitutions agrégées pour les premières pages et situations
synthétiques pour les démonstrations individuelles.

---

## 4. Extraction et paramétrage

Les traitements exploitent :

| Fichier | Contenu |
|---|---|
| G.txt | Référentiel des comptes généraux |
| T.txt | Référentiel des comptes tiers élèves |
| E.txt | Écritures comptables |

Le paramètre `pDossierSource` indique le dossier contenant les exports.

Le chemin réel est renseigné dans l’environnement local autorisé.
Les scripts destinés au dépôt public utilisent des paramètres
et ne doivent pas contenir de secrets ou de chemins personnels.

### Formats documentés

- Séparateur : virgule.
- Absence d’en-tête dans les structures fournies.
- G.txt et E.txt annoncés en ANSI, lus en Windows-1252 dans les scripts.
- T.txt lu en UTF-8.
- Dates de E.txt au format JJMMAA.
- Comptes conservés comme identifiants textuels.
- Montants préparés comme nombres entiers en FCFA.

L’appellation ANSI ne définit pas un encodage universel.

La restitution des accents, l’ordre des colonnes et l’interprétation
des dates doivent rester contrôlés après chaque changement
de format d’export.

La structure détaillée des fichiers est décrite dans le
[dictionnaire des données](dictionnaire-donnees.md)
et la documentation des [sources](../data/README.md).

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

Un regroupement général ne doit toutefois pas être assimilé
automatiquement à une classe précise.

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

Le nom n’est pas utilisé comme clé de jointure.

Les classifications scolaires reposent sur des correspondances explicites.

Une classe inconnue est signalée au lieu d’être affectée automatiquement
à une catégorie par défaut.

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

La méthode documentée est conservée :

1. Découper le texte en groupes de deux caractères.
2. Recomposer la date avec `/`.
3. Convertir le résultat en Date avec la culture `fr-FR`.

Exemple :

```text
200825 → 20/08/25 → 20/08/2025
```

L’interprétation des années sur deux chiffres doit être vérifiée,
notamment lors du passage de 2025 à 2026 ou de l’adaptation
à d’autres périodes.

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

Après exclusion des contreparties, il n’est pas attendu que
le total débit soit égal au total crédit dans la table analytique.

Le préfixe `4` n’est pas présenté comme une règle universelle
pour identifier des élèves dans une autre comptabilité.

### 6.4. Typage

Les comptes généraux et tiers sont conservés en texte.

Les montants restent des nombres entiers, conformément à la structure
confirmée de l’export et au traitement retenu.

Le sens reste une colonne textuelle contenant D ou C.

Les anomalies de format, de sens ou de montant doivent être examinées,
et non corrigées arbitrairement pour obtenir un résultat attendu.

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

Code_J, Date ou Compte T ne constituent pas, pris isolément,
des identifiants uniques d’écriture.

---

## 7. Contrôles de préparation

Quatre requêtes de contrôle sont documentées :

| Contrôle | Objet |
|---|---|
| CONTROLE_NiveauxManquants | Repérer les écritures sans Niveau+ |
| CONTROLE_CoherenceClasses | Comparer la classe de l’écriture à celle du référentiel |
| CONTROLE_ValiditeEcritures | Vérifier les champs, types, sens et montants |
| CONTROLE_ConservationJointure | Comparer les lignes et montants avant et après enrichissement |

Les trois premières requêtes restituent les lignes à examiner.
Un résultat sans anomalie doit donc être vide.

Le contrôle de conservation présente cinq lignes de synthèse,
même lorsque les écarts sont nuls.

### Résultats consignés

Selon les confirmations de l’auteur reprises dans le journal :

- les contrôles des niveaux, classes et écritures ont été exécutés,
  sans anomalie signalée ;
- le contrôle de conservation a présenté des écarts nuls
  sur le périmètre testé.

La conservation porte sur :

- le nombre total de lignes ;
- le nombre de lignes au débit ;
- le nombre de lignes au crédit ;
- le total des montants au débit ;
- le total des montants au crédit.

Les valeurs détaillées Avant et Après restent à renseigner
dans le journal à partir du résultat de la requête.

Elles ne doivent pas être reconstituées à partir des cartes du rapport.

### Portée des contrôles

La conservation est vérifiée entre le périmètre scolaire préparé
avant jointure et la table enrichie.

Elle ne démontre pas, à elle seule :

- l’exhaustivité des exports Sage ;
- l’exactitude de chaque affectation scolaire ;
- la conformité de toutes les opérations comptables.

[Consulter le journal de contrôle qualité](controle-qualite.md)

---

## 8. Modélisation Power BI

Le modèle s’appuie sur :

- Ecritures : table de faits ;
- Comptes T : référentiel élèves ;
- Comptes G : référentiel comptable ;
- Calendrier : dimension temporelle ;
- Mesures : paramètre de champs.

### Relations documentées

| Relation | Cardinalité |
|---|---|
| Calendrier[Date] → Ecritures[Date] | Un à plusieurs |
| Comptes T[Compte T] → Ecritures[Compte T] | Un à plusieurs |
| Comptes G[Compte G] → Ecritures[Compte G] | Un à plusieurs |

Le filtrage simple part des dimensions vers les écritures.

Les clés du côté « un » doivent être uniques.
Les chemins de filtrage ambigus doivent être évités.

Une jointure Power Query ne crée pas automatiquement une relation
dans le modèle Power BI.

Le paramètre de champs `Mesures` reste déconnecté des tables métier.

### Deux sources de classe

- Ecritures[Classe] décrit la classe portée par le mouvement.
- Comptes T[Classe] décrit le rattachement du référentiel.

Une différence doit être expliquée avant correction.

Si le référentiel évolue entre plusieurs années académiques,
l’analyse historique peut nécessiter une gestion des rattachements
par période.

Le rattachement courant ne doit pas être supposé valable
pour toutes les périodes sans contrôle.

---

## 9. Définition des indicateurs

### Mouvements de période

| Mesure | Signification |
|---|---|
| Total Pension | Montants des constatations au débit dans la période |
| Total Réglé | Montants des règlements au crédit dans la période |
| Total lignes écritures | Nombre de lignes comptables retenues dans le contexte |
| Total Montants | Somme technique des montants sélectionnés |

Sans filtre de sens, Total Montants additionne les débits et crédits.
Cette mesure n’est donc ni un solde ni le montant des seuls frais.

Le nombre de lignes comptables ne constitue ni un nombre d’élèves
ni nécessairement un nombre d’opérations uniques.

### Effectifs

L’effectif repose sur le nombre distinct de Compte T ayant
une constatation de scolarité.

- `Effectif` porte sur la période sélectionnée.
- `Effectif actuel` porte sur le cumul depuis le début du cycle
  jusqu’à l’arrêté mensuel.

Un élève ayant plusieurs écritures reste compté une seule fois
dans le périmètre évalué.

Le cumul recalcule les comptes distincts sur toute la période.
Il ne résulte pas de l’addition des effectifs distincts mensuels.

Cet indicateur ne mesure pas la présence quotidienne.
Il ne démontre pas non plus, à lui seul, une nouvelle inscription
administrative.

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

Une division non calculable reste vide selon la convention documentée.

Les soldes négatifs et ratios inhabituels doivent être examinés,
et non corrigés arbitrairement.

Un solde positif ne constitue pas automatiquement un retard :
les échéances de paiement doivent être connues pour établir
cette qualification.

Les totaux des mesures cumulatives doivent être recalculés
dans leur contexte, et non obtenus en additionnant les cumuls
de chaque ligne mensuelle.

---

## 10. Gestion de l’année académique

Le cycle retenu commence le 1er août et se termine le 31 juillet suivant.

Les mesures de situation s’arrêtent à la fin du mois sélectionné.

| Sélection | Période cumulée |
|---|---|
| Octobre 2025 | 01/08/2025 au 31/10/2025 |
| Février 2026 | 01/08/2025 au 28/02/2026 |
| Avril 2026 | 01/08/2025 au 30/04/2026, selon les écritures disponibles |

Le cumul ne repart pas à zéro en janvier.

### Comportement documenté des sélections

- Une seule année académique doit être présente dans le contexte.
- Si plusieurs mois du même cycle sont sélectionnés, le dernier mois
  définit l’arrêté.
- Un mois postérieur au dernier mois contenant des écritures renvoie
  une valeur vide.
- La dernière date d’écriture utilisée par la règle de disponibilité
  est déterminée globalement dans les données chargées.
- Les filtres scolaires restent applicables aux calculs selon le modèle.

Une valeur vide au-delà du dernier mois disponible ne signifie
ni un effectif nul ni un solde intégralement réglé.

Le dernier mois disponible peut être incomplet.
La présence d’une écriture ne garantit pas son exhaustivité.

### Calendrier complet

Le calendrier couvre les cycles académiques complets correspondant
aux dates des données disponibles.

Pour le périmètre documenté, il couvre le **1er août 2025
au 31 juillet 2026**.

Il peut donc contenir des dates sans opérations.
Ces dates ne constituent ni des prévisions ni des résultats confirmés.

### Absence de sélection mensuelle

Si le contexte va jusqu’à la fin du calendrier mais que les données
s’arrêtent plus tôt, les cartes cumulées peuvent rester vides
selon la règle de disponibilité retenue.

Le rapport doit proposer une sélection temporelle claire.

### Mouvements journaliers

Les tableaux journaliers utilisent les mesures de base dans le contexte
de date sélectionné.

Les cartes cumulées en fin de mois ne doivent pas être présentées
comme une situation arrêtée à la fin du jour sélectionné.

---

## 11. Paramètre de champs, restitution et galerie

### Sélection des indicateurs

La table `Mesures` permet de sélectionner :

- Pensions déjà Constatées ;
- Règlements déjà perçus ;
- Solde restant ;
- Effectif actuel.

Le paramètre est créé avec la fonctionnalité de paramètres de champs
de Power BI.

Il sélectionne des mesures existantes ; il ne réalise pas leur calcul.

Une sélection unique est recommandée pour ne pas mélanger
les montants en FCFA et les nombres d’élèves sur une même échelle.

Les titres, unités et formats doivent correspondre à l’indicateur
sélectionné.

### Organisation du rapport

| Page | Fonction | Présentation dans la galerie |
|---|---|---|
| Dashboard 1 | Synthèse et répartitions par niveau, section et classe | Quatre variantes du sélecteur d’indicateur |
| Dashboard 2 | Évolution des cumuls académiques | Une capture |
| Dashboard 3 | Détails et tendances des mouvements mensuels | Une capture |
| Dashboard 4 | Situation individuelle | Une capture avec des lignes entièrement synthétiques |
| Dashboard 5 | Suivi journalier | Une capture avec des lignes entièrement synthétiques |

La galerie comprend donc **huit captures pour cinq pages**.

Les quatre variantes de Dashboard 1 montrent les répartitions
des quatre indicateurs. Les cinq cartes de synthèse restent visibles
dans chacune de ces variantes.

### Périmètres temporels des visuels

Dans les captures de référence :

- les cartes présentent la situation cumulée au 31 octobre 2025 ;
- Dashboard 2 présente l’évolution des cumuls d’août 2025
  à avril 2026 ;
- les tableaux de Dashboard 3 présentent les mouvements d’octobre,
  tandis que les courbes présentent les mouvements mensuels
  sur plusieurs mois disponibles.

Cette distinction est expliquée dans les descriptions de la galerie.

Les interactions entre segments et visuels doivent être contrôlées
dans le rapport. Une mesure cumulative ne force pas un graphique
à afficher des mois retirés de son axe par un segment.

La présence d’une vue rétrospective à côté d’un arrêté d’octobre
n’implique pas que les opérations ultérieures étaient connues
à cet arrêté.

### Portée des captures

Les PNG illustrent un état du rapport avec des filtres précis.

Ils ne permettent pas d’utiliser les recherches, segments,
boutons ou défilements depuis GitHub.

Ils ne constituent pas une preuve de validation de toutes
les interactions.

[Consulter la galerie commentée](../images/README.md)

---

## 12. Validation DAX consignée et vérifications complémentaires

La validation DAX est distincte des contrôles de préparation Power Query.

Les résultats de la campagne documentée sont consignés dans
le [journal de contrôle qualité](controle-qualite.md).

| Élément | Référence consignée |
|---|---|
| Date réelle d’exécution des tests | 19/10/2026 |
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
| DAX-05 | Mai 2026, au-delà des données disponibles | Mesures cumulées vides selon la règle documentée |
| DAX-06 | Filtre de section | Réaction des résultats confirmée par l’auteur |

Aucun écart ni message d’erreur n’a été signalé par l’auteur
pour ces scénarios.

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

Ces valeurs correspondent au contexte documenté.
Elles ne sont pas des constantes à imposer à toute version du modèle.

### Portée et contrôles complémentaires

Les tests consignés ne valident pas automatiquement tous les filtres,
paramètres, formats et interactions.

Les vérifications complémentaires comprennent notamment :

- les analyses détaillées par classe et niveau ;
- le comportement complet du paramètre de champs ;
- les interactions de la page journalière ;
- les mois sans mouvement à l’intérieur de la période disponible ;
- les sélections couvrant plusieurs cycles ;
- le tri chronologique des axes et tableaux ;
- le rapprochement avec le registre administratif des inscriptions ;
- l’exhaustivité des exports par rapport à Sage ;
- la concordance avec une version déployée dans Power BI Service,
  le cas échéant.

La liste de suivi et les résultats complémentaires doivent être
tenus à jour dans le journal.

La version de démonstration utilisant des données synthétiques
doit être distinguée du modèle métier testé.

Les conclusions de la campagne métier ne sont pas automatiquement
transposées à cette version.

Les données et les résultats ne doivent pas être modifiés arbitrairement
pour reproduire un ancien export lorsqu’une correction justifiée
modifie le calcul.

---

## 13. Reproductibilité et gestion des versions

Pour reproduire une analyse, conserver :

- la nature des données : réelles ou synthétiques ;
- la version des exports ou du jeu d’exemple ;
- les formats de lecture ;
- les paramètres de source ;
- les scripts Power Query ;
- les relations du modèle ;
- le calendrier et les formules DAX ;
- la configuration du paramètre de champs ;
- les filtres appliqués ;
- les résultats et les preuves des contrôles.

### Après une modification fonctionnelle

1. Travailler dans une copie du modèle.
2. Identifier les traitements, mesures et visuels concernés.
3. Rejouer les contrôles adaptés à la modification.
4. Comparer les résultats à périmètre identique et expliquer les écarts.
5. Consigner les corrections et les nouvelles conclusions.
6. Mettre à jour la documentation et les supports devenus obsolètes.
7. Versionner dans GitHub uniquement le code, la documentation
   et les supports autorisés à la diffusion.

Les versions des sources et du modèle contenant les données réelles
restent dans l’environnement interne autorisé.

Un commit de publication des captures ne constitue pas, à lui seul,
une référence de validation du modèle.

Un commit GitHub ne met pas automatiquement à jour le rapport
Power BI Desktop ou une version déployée dans Power BI Service.

### Limite de reproduction depuis le dépôt public

La galerie ne constitue pas un jeu de données téléchargeable.

La reconstruction nécessite Power BI Desktop, des données compatibles
et autorisées, ainsi que la configuration des requêtes, relations,
mesures et paramètres documentés.

En l’absence de jeu compatible diffusable, le dépôt permet d’examiner
la méthode et le code, mais pas de reproduire intégralement
les résultats du modèle métier à partir des seuls fichiers publics.

Un futur jeu synthétique téléchargeable devra être documenté
et contrôlé séparément.

---

## 14. Limites et confidentialité

### Limites d’interprétation

- Les écritures ne constituent pas un registre de présence.
- L’effectif comptable doit être rapproché du registre des inscriptions.
- L’exhaustivité des exports conditionne les résultats.
- Un solde non réglé n’est pas nécessairement échu.
- Les évolutions de classes ou de référentiels doivent être documentées.
- Le dernier mois disponible peut être incomplet.
- Les analyses rétrospectives ne sont pas des prévisions.
- Aucun gain de recouvrement ou de productivité n’est revendiqué
  sans mesure de résultat.

### Préparation de la version publique

La présentation du projet est autorisée selon les informations
communiquées par l’auteur.

La version publique distingue :

- les restitutions agrégées des dashboards 1 à 3 ;
- les lignes individuelles entièrement synthétiques des dashboards 4 et 5.

L’auteur a confirmé que ces lignes synthétiques ne reproduisent aucune
situation réelle d’élève. Leur préparation ne se limite pas
au remplacement des noms.

Cette adaptation concerne la version de démonstration.
Elle ne requalifie pas les sources métier ni la campagne de tests.

Les exports réels, les correspondances avec les identités réelles
et les modèles contenant les données détaillées restent hors
du dépôt public.

Masquer une colonne dans un rapport ne retire pas son contenu
du modèle.

Les règles de diffusion, de stockage et de vérification des supports
sont détaillées dans la
[documentation de confidentialité](confidentialite.md).

---

## Documentation associée

- [Présentation générale](../README.md)
- [Galerie du rapport](../images/README.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Journal de contrôle qualité](controle-qualite.md)
- [Préparation Power Query](../powerquery/README.md)
- [Paramètres d’importation](../powerquery/parameters.example.md)
- [Contrôles de qualité](../quality/README.md)
- [Indicateurs DAX](../dax/README.md)
- [Données et conditions de diffusion](../data/README.md)
- [Confidentialité](confidentialite.md)
- [Déploiement](deploiement.md)
