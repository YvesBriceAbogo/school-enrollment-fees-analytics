# Données sources et conditions de diffusion

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur du projet : Brice Abogo**

Ce document présente la provenance des données, leur structure,
leur signification comptable et les conditions retenues pour
leur utilisation dans le portfolio.

Le modèle métier repose sur des exports Sage réels.
La présentation du projet est autorisée, selon les informations
communiquées par l’auteur.

Cette autorisation est distincte de la redistribution des exports
individuels et des modèles contenant les données détaillées.

La version publique distingue les restitutions agrégées des dashboards
1 à 3 et les lignes entièrement synthétiques des dashboards 4 et 5.

Les exports Sage réels restent hors du périmètre de publication.

---

## 1. Identification des données sources

| Élément | Description |
|---|---|
| Origine | Comptabilité de la scolarité d’un établissement scolaire |
| Application source | Sage Saari version 15 |
| Mode d’extraction | Exports réalisés à l’aide des fonctions d’export de l’application |
| Format des sources | Fichiers TXT séparés par des virgules |
| Nature des données sources | Réelles |
| Année académique étudiée | 2025/2026 |
| Cycle analytique | Du 1er août au 31 juillet |
| Période disponible | Août 2025 à avril 2026 |
| Dernière date d’écriture affichée lors des tests | 02/04/2026 |
| Situation de référence illustrée | Arrêté au 31 octobre 2025 |
| Début des cumuls académiques | 1er août |
| Devise | FCFA |
| Présentation du projet | Autorisée selon les informations communiquées par l’auteur |
| Identification de l’établissement | Non publiée dans la version portfolio |

La situation d’octobre constitue un exemple d’analyse.
Elle n’est pas une date figée dans les calculs.

La période disponible ne doit pas être assimilée à une année
académique complète.

La dernière date d’écriture, la date d’extraction et la date
d’exécution des contrôles sont des informations distinctes.
Les références de la campagne figurent dans le
[journal de contrôle qualité](../docs/controle-qualite.md).

---

## 2. Fichiers sources et formats documentés

### Rôle des fichiers

| Fichier | Contenu | Usage |
|---|---|---|
| E.txt | Écritures comptables | Analyse des constatations de scolarité et des règlements |
| T.txt | Référentiel des comptes tiers | Identification des comptes élèves et rattachement comptable |
| G.txt | Référentiel des comptes généraux | Regroupements comptables et correspondances de classes |

Ces noms correspondent aux exports référencés dans les traitements
du projet. Leur mention ne signifie pas que les fichiers réels
sont disponibles au téléchargement.

Les sources réelles restent dans un emplacement autorisé.
Leur présence dans GitHub n’est pas nécessaire pour présenter
le code et la démarche analytique.

### Caractéristiques techniques

Les traitements documentés utilisent `Csv.Document` avec la virgule
comme séparateur.

| Fichier | Nombre de champs | En-tête dans la structure fournie | Encodage utilisé |
|---|---:|---|---|
| E.txt | 7 | Aucun | Windows-1252 |
| T.txt | 3 | Aucun | UTF-8 |
| G.txt | 3 | Aucun | Windows-1252 |

L’encodage de E.txt et G.txt a été annoncé comme ANSI.
Les scripts documentés utilisent Windows-1252.

L’appellation ANSI ne constitue pas un encodage universel :
la restitution des accents doit rester contrôlée lors des imports.

### E.txt — Ordre des champs

```text
Code, Date, Compte G, Classe, Compte T, Montant, Sens
```

La date source utilise le format **JJMMAA**.

Exemples de conversion attendue :

```text
200825 → 20/08/2025
010925 → 01/09/2025
```

La préparation documentée recompose la date avant sa conversion
avec la culture `fr-FR`.

Les montants sont non négatifs selon la convention confirmée
pour les exports. La colonne finale `Montants` du modèle est
documentée comme un nombre entier exprimé en FCFA.

Les comptes sont conservés comme identifiants textuels.

### T.txt — Ordre des champs

```text
Compte T, Nom, Compte G
```

La colonne `Nom` appartient au référentiel métier interne.
Elle n’est pas utilisée comme clé de jointure.

### G.txt — Ordre des champs

```text
Compte G, Libellé de regroupement, Marqueur d’export
```

Le troisième champ n’est pas conservé dans la table finale.

Ce marqueur d’export est distinct du sens débit/crédit utilisé
dans E.txt.

### Adaptation à un autre export

Ces caractéristiques décrivent la structure documentée pour ce projet.

Pour un nouvel export, vérifier notamment le séparateur, l’encodage,
l’ordre des colonnes, les dates, les montants et la présence éventuelle
d’en-têtes ou de lignes de total avant de réutiliser les traitements.

Les détails de préparation sont décrits dans le
[dictionnaire des données](../docs/dictionnaire-donnees.md)
et la documentation [Power Query](../powerquery/README.md).

---

## 3. Signification comptable

La comptabilité exploitée est consacrée à la scolarité.

Selon la convention du projet, un compte tiers correspond à un seul élève.

| Mouvement sur le compte tiers élève | Signification |
|---|---|
| Débit — D | Constatation des frais de scolarité |
| Crédit — C | Règlement pour l’élève |

Une constatation comptable ne démontre pas, à elle seule,
une nouvelle inscription administrative.

### Sélection du périmètre analytique

Les exports comprennent les mouvements des comptes élèves
et leurs contreparties de produits ou de trésorerie.

Les traitements Power Query retiennent les comptes commençant
par `4`, selon le périmètre scolaire confirmé pour ce projet,
et écartent les contreparties hors de ce périmètre.

Cette règle doit être réexaminée avant toute adaptation à un autre
plan comptable ou à une autre source.

La sélection évite d’additionner les contreparties aux indicateurs
de scolarité et de règlement.

Après ce retraitement, la table analytique ne représente plus
l’intégralité des écritures en partie double.

**Il n’est donc pas attendu que le total débit soit égal au total crédit
dans cette table.**

### Classes, niveaux et sections

La classe portée par l’écriture provient de E.txt et reste conservée
dans `Ecritures[Classe]`.

Le référentiel `Comptes T` est enrichi à partir de `Comptes G`.
Il fournit les attributs scolaires documentés, notamment le niveau
et la section.

L’enrichissement de `Ecritures` depuis `Comptes T` ajoute le niveau
scolaire. La section reste disponible dans le référentiel `Comptes T`.

Un libellé général de regroupement ne doit pas être assimilé
automatiquement à une classe précise.

Les différences entre la classe d’une écriture et celle du référentiel
doivent être examinées avant correction.

---

## 4. Tables utilisées dans Power BI

| Table | Fonction |
|---|---|
| Ecritures | Mouvements comptables retenus après préparation |
| Comptes T | Référentiel des comptes élèves et attributs associés |
| Comptes G | Référentiel des regroupements comptables |
| Calendrier | Dimension temporelle |
| Mesures | Paramètre de champs pour sélectionner l’indicateur affiché |

Les tables `Calendrier` et `Mesures` sont des objets du modèle Power BI.
Elles ne correspondent pas à des exports comptables distincts.

Le paramètre de champs `Mesures` reste déconnecté des tables métier.
Il ne contient pas de montants à additionner.

### Granularité et intégrité

Une ligne d’écriture n’est pas nécessairement un élève distinct.

L’export présenté ne comporte pas d’identifiant unique de mouvement.
Deux lignes similaires peuvent correspondre à des opérations différentes :
aucune déduplication automatique n’est appliquée.

Les jointures doivent préserver les lignes et les montants
du périmètre retenu, sauf transformation explicitement justifiée.

L’unicité des clés des référentiels doit être contrôlée avant
le développement des colonnes issues des jointures.

Les relations du modèle et les règles de préparation sont détaillées
dans le [dictionnaire des données](../docs/dictionnaire-donnees.md).

---

## 5. Périodes d’analyse

### Situations cumulées

Les cumuls commencent au début du cycle académique et se poursuivent
jusqu’à la fin du mois sélectionné.

| Mois sélectionné | Période cumulée |
|---|---|
| Octobre 2025 | 01/08/2025 au 31/10/2025 |
| Février 2026 | 01/08/2025 au 28/02/2026 |
| Avril 2026 | 01/08/2025 au 30/04/2026, selon les écritures disponibles |

Le cumul ne recommence pas à zéro en janvier.

Les mesures cumulatives documentées exigent une seule année académique
dans le contexte. Lorsque plusieurs mois de ce même cycle sont
sélectionnés, elles retiennent le dernier mois.

### Lecture des captures

Les cartes de synthèse de la galerie présentent la situation
de référence au **31 octobre 2025**.

Les visuels d’évolution des dashboards 2 et 3 présentent plusieurs
mois disponibles, selon le fonctionnement expliqué dans la galerie.

Les données postérieures à octobre permettent une analyse rétrospective.
Elles ne constituent ni une prévision ni des informations présentées
comme déjà connues à l’arrêté d’octobre 2025.

### Disponibilité des écritures

Le calendrier couvre le cycle académique complet nécessaire au modèle.
La présence d’une date dans ce calendrier ne crée pas de mouvement
comptable.

Les mesures cumulatives documentées renvoient une valeur vide
si le mois sélectionné dépasse le dernier mois contenant des écritures.

Cette valeur vide ne signifie ni un effectif nul ni un solde
intégralement réglé.

La présence d’une écriture au 2 avril 2026 ne démontre pas
l’exhaustivité du mois d’avril.

---

## 6. Définition des effectifs et des soldes

### Effectifs comptables

L’indicateur d’effectif repose sur le nombre distinct de comptes élèves
ayant une constatation de scolarité dans la période.

Le comptage porte sur `Compte T`, et non sur le nombre de lignes au débit.

Les effectifs distincts mensuels ne doivent pas être additionnés
mécaniquement pour obtenir le cumul académique.

La mesure `Effectif actuel` recalcule ce comptage sur l’ensemble
de la période depuis le début du cycle jusqu’à l’arrêté mensuel.

Cet indicateur ne constitue ni une mesure de présence quotidienne
ni un rapprochement automatique avec le registre administratif
des inscriptions.

### Solde restant

Le solde correspond à la différence entre la scolarité constatée
et les règlements sur le même périmètre temporel.

Un règlement du mois peut concerner une constatation antérieure :
les flux mensuels doivent être distingués des situations cumulées.

Le solde restant ne constitue pas automatiquement un retard
de paiement. L’identification des sommes échues nécessite
les échéances applicables.

[Consulter les mesures DAX](../dax/README.md)

---

## 7. Conditions de diffusion et de réutilisation

La présentation du projet est autorisée selon les informations
communiquées par l’auteur.

Cette autorisation ne constitue pas une autorisation générale
de redistribution des sources individuelles ou des modèles
contenant les données réelles.

### Périmètre public

| Ressource | Condition retenue |
|---|---|
| Code et documentation | Publication après examen des éléments sensibles |
| Dashboards 1 à 3 | Restitutions agrégées dans le périmètre autorisé |
| Dashboards 4 et 5 | Lignes individuelles entièrement synthétiques |
| Exports Sage réels | Hors du dépôt public |
| Correspondances avec les identités réelles | Hors du dépôt public |
| Modèle contenant les données détaillées réelles | Hors du périmètre de publication |

La galerie comprend huit captures PNG accompagnées de descriptions.

Les agrégats doivent rester dans le périmètre de diffusion autorisé.
Les groupes de faible effectif et les combinaisons de données
susceptibles de permettre une réidentification doivent être examinés.

### Informations exclues des supports publics

- Identités réelles des élèves.
- Comptes tiers réels et correspondances d’identité.
- Coordonnées des familles.
- Situations financières individuelles réelles identifiables.
- Mots de passe, jetons et autres secrets techniques.
- Paramètres ou chemins révélant des informations sensibles.

Masquer une colonne dans Power BI ne retire pas sa valeur du modèle.
Un rectangle ajouté à un PDF ne garantit pas la suppression du texte
sous-jacent.

Les conditions éventuelles de réutilisation du code ne valent pas
autorisation de redistribuer les données sources réelles.

Toute publication future d’un jeu synthétique téléchargeable devra
préciser ses propres conditions de réutilisation.

[Consulter les règles de confidentialité](../docs/confidentialite.md)

---

## 8. Démonstrations synthétiques et éventuels fichiers d’exemple

### Démonstrations déjà présentées

Les lignes individuelles des dashboards 4 et 5 sont entièrement
synthétiques, conformément à la confirmation de l’auteur.

Elles ne reproduisent aucune situation réelle d’élève.
Il ne s’agit pas seulement d’un remplacement des noms :
les attributs et les opérations individuels sont des exemples
de démonstration.

Cette qualification concerne la version de présentation de ces pages.
Elle ne requalifie pas les données sources réelles ni la version
ayant servi à la campagne de tests métier.

### Disponibilité d’un jeu téléchargeable

Les captures des dashboards 4 et 5 ne constituent pas la mise
à disposition des fichiers ayant servi à leur création.

À ce stade, cette documentation n’annonce pas de jeu synthétique
E.txt, T.txt et G.txt téléchargeable.

La disponibilité d’un tel jeu devra être documentée séparément
s’il est publié.

### Exigences pour un futur jeu d’exemple

Un jeu compatible destiné à la diffusion devra :

- respecter la structure attendue par les scripts ;
- utiliser des identifiants et des identités fictifs ;
- ne pas reproduire de situations individuelles réelles ;
- conserver la cohérence des références entre les fichiers ;
- respecter l’unicité des clés des référentiels ;
- couvrir des cas utiles, notamment les règlements partiels
  et la continuité du cumul académique ;
- être accompagné de sa version, de ses règles de génération
  et de ses résultats attendus ;
- être explicitement présenté comme synthétique.

Les résultats obtenus avec ce jeu pourront différer de ceux
du modèle métier.

Ils devront être calculés et contrôlés séparément, sans modifier
arbitrairement les données dans le seul but de reproduire
les anciens totaux.

Les conclusions de la campagne sur les sources réelles
ne valident pas automatiquement un jeu de démonstration différent.

---

## 9. Reproductibilité et limites

Pour reconstruire une analyse, il faut disposer :

- d’un jeu de données compatible et autorisé ;
- des formats d’export documentés ;
- des paramètres de source adaptés à l’environnement ;
- des transformations Power Query ;
- des relations du modèle ;
- du calendrier et des mesures DAX ;
- du paramètre de champs Power BI ;
- des règles de regroupement scolaire ;
- de la période et des filtres à appliquer.

La reconstruction nécessite Power BI Desktop.
Le dépôt ne se connecte pas automatiquement à Sage et n’exécute pas
les traitements Power BI.

En l’absence d’un jeu compatible diffusable, le dépôt permet
d’examiner le code, la méthode et les résultats documentés,
mais pas de reproduire intégralement les résultats du modèle métier.

Une capture ou un PDF ne remplace pas les données sources.

Toute adaptation à un autre export ou à un jeu synthétique nécessite
de rejouer les contrôles concernés.

Les résultats du contrôle de conservation et des tests DAX
sont consignés dans le
[journal de contrôle qualité](../docs/controle-qualite.md).
Ils ne démontrent pas, à eux seuls, l’exhaustivité des sources Sage.

---

## 10. Règles de stockage dans le dépôt

Le dépôt GitHub est déjà public, d’après l’état communiqué
par l’auteur.

Les exports réels doivent rester hors du dépôt.
Ils ne doivent pas être téléversés temporairement dans une branche,
une pull request ou un autre emplacement public.

### Rôle du dossier data

Ce dossier documente les sources et leurs conditions de diffusion.

La description des fichiers E.txt, T.txt et G.txt ne constitue pas
une instruction pour y déposer les exports réels.

Si des exemples synthétiques sont publiés ultérieurement,
leur emplacement, leur contenu et leur statut devront être précisés.

### Règles d’exclusion Git

Le fichier [`.gitignore`](../.gitignore) constitue la référence
des règles d’exclusion du projet.

Les exclusions à maintenir concernent notamment les exports réels,
les fichiers de travail contenant des données détaillées,
les archives de ces fichiers et les configurations locales sensibles.

Un fichier `.gitignore` :

- ne retire pas les fichiers déjà suivis ;
- ne nettoie pas l’historique Git ;
- ne détecte pas le contenu sensible ;
- ne protège pas contre toutes les méthodes d’ajout, notamment
  les téléversements manuels dans l’interface web.

Une éventuelle exception pour des fichiers synthétiques doit être
ciblée et ajoutée après leur préparation et leur contrôle.

### Modèles Power BI

Un PBIX en mode Import peut contenir les tables détaillées,
y compris des colonnes absentes des visuels.

Un PBIT ne contient pas le cache des données importées, mais peut
conserver des requêtes, paramètres, chemins ou valeurs inscrites
dans les définitions.

La publication éventuelle de ces formats nécessite un examen distinct.
Le caractère synthétique des lignes visibles de deux pages ne démontre
pas que l’ensemble du modèle est prêt à être diffusé.

Les précautions détaillées figurent dans la
[documentation de confidentialité](../docs/confidentialite.md).

---

## 11. Vérifications avant publication d’une ressource

- [ ] Ressource autorisée à être diffusée publiquement.
- [ ] Absence d’identité réelle d’élève.
- [ ] Absence de compte tiers réel ou de correspondance d’identité.
- [ ] Absence de situation financière individuelle réelle identifiable.
- [ ] Groupes de faible effectif et risques de réidentification examinés.
- [ ] Absence de mot de passe ou de paramètre sensible.
- [ ] Nature des données clairement précisée : agrégats issus du modèle métier ou données synthétiques.
- [ ] Période et devise indiquées.
- [ ] Cohérence avec les scripts et la version du rapport documentés.
- [ ] Métadonnées et contenus masqués examinés, si applicables.
- [ ] Conditions de réutilisation précisées pour tout jeu d’exemple publié.
- [ ] Version et référence de publication consignées.

Les cases doivent être cochées après vérification effective.

La confirmation d’un téléversement ou la présence d’une capture
dans la galerie ne suffit pas à déclarer ces contrôles réalisés.

Les références de publication sont à consigner dans le
[journal de contrôle qualité](../docs/controle-qualite.md),
séparément des références de la campagne de tests métier.

---

## Documentation associée

- [Présentation générale du projet](../README.md)
- [Galerie du rapport](../images/README.md)
- [Méthodologie](../docs/methodologie.md)
- [Dictionnaire des données](../docs/dictionnaire-donnees.md)
- [Préparation Power Query](../powerquery/README.md)
- [Mesures DAX](../dax/README.md)
- [Plan de contrôle qualité](../quality/README.md)
- [Journal de contrôle qualité](../docs/controle-qualite.md)
- [Confidentialité](../docs/confidentialite.md)
- [Règles d’exclusion Git](../.gitignore)
