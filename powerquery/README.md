# Préparation des exports Sage — Power Query M

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce dossier documente les traitements Power Query utilisés pour transformer
les exports comptables Sage Saari en tables exploitables dans Power BI.

Il décrit la lecture des fichiers, la sélection du périmètre comptable,
le nettoyage, le typage et l’enrichissement des écritures.

Les contrôles Power Query exécutés sur la version testée du modèle
sont consignés dans le
[journal de contrôle qualité](../docs/controle-qualite.md).

Ces conclusions concernent le périmètre et la version examinés.
Elles ne valident pas automatiquement une autre version des scripts
ou une nouvelle extraction.

GitHub conserve le code et sa documentation, mais ne les exécute pas.

---

## 1. Objectifs

- Paramétrer l’accès aux fichiers sources.
- Préparer les dates, identifiants et montants.
- Conserver le périmètre comptable consacré aux comptes élèves.
- Enrichir les écritures avec les référentiels.
- Organiser les regroupements par classe, niveau et section.
- Préserver les lignes et les montants lors des enrichissements.
- Identifier les anomalies sans les masquer.
- Faciliter la maintenance et la reproduction du projet.

Les traitements Power Query préparent les données.
Les comptages distincts et les cumuls dynamiques relèvent ensuite
du modèle et des mesures DAX.

---

## 2. Sources et formats documentés

Les traitements reposent sur trois fichiers texte exportés
de Sage Saari version 15.

| Fichier | Contenu | Requête Power BI |
|---|---|---|
| G.txt | Référentiel des comptes généraux | Comptes G |
| T.txt | Référentiel des comptes tiers élèves | Comptes T |
| E.txt | Écritures comptables | Ecritures |

Les requêtes documentées utilisent `File.Contents` pour accéder
aux fichiers et `Csv.Document` pour interpréter leur contenu.

### Caractéristiques de lecture

| Fichier | Séparateur | Nombre de champs | En-tête dans la structure fournie | Encodage utilisé |
|---|---|---:|---|---|
| G.txt | Virgule | 3 | Aucun | Windows-1252 |
| T.txt | Virgule | 3 | Aucun | UTF-8 |
| E.txt | Virgule | 7 | Aucun | Windows-1252 |

G.txt et E.txt ont été annoncés en ANSI.
Les scripts documentés utilisent Windows-1252.

L’appellation ANSI ne définit pas un encodage universel.
La restitution des accents doit rester contrôlée.

### Ordre des champs

**G.txt**

```text
Compte G, Libellé de regroupement, Marqueur d’export
```

Le troisième champ n’est pas conservé dans la table finale.
Il est distinct du sens débit/crédit de E.txt.

**T.txt**

```text
Compte T, Nom, Compte G
```

**E.txt**

```text
Code, Date, Compte G, Classe, Compte T, Montant, Sens
```

Ces descriptions indiquent l’ordre des champs.
Elles ne constituent pas des en-têtes à ajouter aux exports.

Les dates de E.txt sont au format JJMMAA.
Les comptes sont traités comme des identifiants textuels.

### Adaptation à une autre extraction

Ces formats décrivent les sources documentées pour ce projet.

Avant de réutiliser les traitements sur un autre export, vérifier
le séparateur, l’encodage, l’ordre des colonnes, les dates,
les montants et les éventuelles lignes de structure.

Les fichiers réels ne sont pas destinés au dépôt public.

[Consulter la documentation des sources](../data/README.md)

---

## 3. Sélection du périmètre comptable

La comptabilité source est consacrée à la scolarité.

Les exports contiennent les mouvements sur les comptes élèves
et leurs contreparties de produits ou de trésorerie.

Les traitements retiennent les comptes commençant par `4`,
selon le périmètre scolaire confirmé, et écartent les contreparties
hors de ce périmètre.

Dans les lignes retenues :

| Sens sur le compte tiers élève | Signification |
|---|---|
| D | Constatation des frais de scolarité |
| C | Règlement pour l’élève |

Cette sélection évite d’intégrer les contreparties aux indicateurs
de scolarité et de règlement.

Après ce retraitement, la table analytique ne représente plus
l’intégralité des écritures en partie double.

**Il n’est donc pas attendu que le total débit soit égal au total crédit
dans cette table.**

Le préfixe `4` n’est pas une règle universelle permettant d’identifier
des élèves dans n’importe quelle comptabilité.
Son utilisation doit être réexaminée lors d’une adaptation
à un autre périmètre.

Une constatation comptable ne démontre pas, à elle seule,
une nouvelle inscription administrative.

---

## 4. Organisation et dépendances des scripts

Le catalogue documenté utilise les références suivantes :

| Fichier | Nom de la requête Power BI | Fonction |
|---|---|---|
| `parameters.example.md` | Documentation des paramètres | Configuration des sources |
| `01_comptes_g.pq` | Comptes G | Préparation du référentiel des comptes généraux |
| `02_comptes_t.pq` | Comptes T | Préparation des comptes élèves et enrichissement |
| `03_ecritures.pq` | Ecritures | Préparation des mouvements comptables |

`parameters.example.md` est un document d’instructions.
Ce n’est pas une requête métier à créer sous ce nom.

Les préfixes numériques organisent les fichiers dans GitHub.
Ils ne font pas partie des noms des requêtes Power BI.

### Ordre de création

1. Créer les paramètres nécessaires.
2. Préparer `Comptes G` à partir de G.txt.
3. Préparer `Comptes T` à partir de T.txt et de `Comptes G`.
4. Préparer `Ecritures` à partir de E.txt et de `Comptes T`.
5. Exécuter les contrôles concernés.

Les contrôles sont décrits dans le
[plan de contrôle qualité](../quality/README.md).

Dans le langage M, un nom de requête contenant un espace
s’écrit notamment :

```powerquery
#"Comptes G"
```

ou :

```powerquery
#"Comptes T"
```

Les noms des requêtes et des colonnes doivent rester cohérents
avec les dépendances des scripts, relations, mesures et visuels.

---

## 5. Paramétrage des sources

Le paramètre `pDossierSource` centralise le dossier contenant les exports
dans la version documentée.

Exemple non sensible :

```text
C:\PowerBI\school-fees\data
```

L’utilisateur renseigne l’emplacement réel dans son environnement
autorisé.

Les trois fichiers attendus restent :

```text
G.txt
T.txt
E.txt
```

La construction des chemins complets doit correspondre aux expressions
utilisées dans les scripts, notamment pour le séparateur de chemin.

[Consulter les paramètres d’importation](parameters.example.md)

### Accès aux fichiers

Un paramètre de dossier ne transforme pas les lectures
par `File.Contents` en un connecteur unique de type Dossier.

Dans Power BI Service, les chemins évalués doivent correspondre
aux sources et aux connexions de passerelle configurées.

Un chemin local utilisé par la passerelle désigne un emplacement
sur la machine qui l’héberge, pas nécessairement sur le poste
utilisé pour Power BI Desktop.

Les modalités d’exploitation sont décrites dans la
[documentation de déploiement](../docs/deploiement.md).

### Confidentialité des paramètres

Les scripts publics ne doivent contenir aucun mot de passe,
jeton, identifiant sensible ou chemin personnel inutile.

L’export Sage et l’actualisation Power BI restent deux opérations
distinctes. Le paramétrage du dossier ne génère pas de nouveaux
exports comptables.

---

## 6. Principes de préparation

### 6.1. Comptes et références

Les comptes généraux et comptes tiers sont traités comme des identifiants.

Le type Texte préserve leur représentation, notamment les éventuels
zéros initiaux.

Le même type doit être utilisé de part et d’autre d’une jointure.

Le nom de l’élève n’est pas utilisé comme clé de rapprochement.

### 6.2. Dates

La conversion documentée repose sur le format source JJMMAA :

1. Découper le texte en groupes de deux caractères.
2. Recomposer la date avec `/`.
3. Convertir le résultat en Date avec la culture `fr-FR`.

Exemples :

```text
200825 → 20/08/25 → 20/08/2025
010925 → 01/09/25 → 01/09/2025
```

L’interprétation des années sur deux chiffres doit rester contrôlée,
notamment lors du passage à une autre année ou à un autre jeu de données.

Une date invalide ne doit pas être remplacée silencieusement
par une date par défaut.

### 6.3. Montants

La colonne finale `Montants` est documentée comme un **nombre entier**,
conformément à la structure retenue pour cette version.

Les montants sont non négatifs selon la convention confirmée
pour les exports. Leur interprétation dépend du champ `Sens`.

La devise est le FCFA.
Le choix du type numérique ne définit pas à lui seul cette devise.

Une valeur manquante, un zéro et une erreur de conversion
ne sont pas équivalents.

Si une évolution des sources introduit des montants fractionnaires,
le type et les contrôles doivent être réexaminés explicitement,
sans arrondi silencieux.

### 6.4. Textes

Le nettoyage peut porter sur :

- les espaces en début et fin ;
- les caractères non imprimables ;
- les espaces insécables ;
- les valeurs vides.

Les règles appliquées doivent préserver les identifiants
et les libellés nécessaires aux rapprochements.

Le nettoyage des textes ne constitue pas une anonymisation.

### 6.5. Exclusions fondées sur le contenu

Dans la préparation documentée de `Comptes G`, la suppression initiale
des deux dernières lignes a été remplacée par une exclusion explicite
des deux comptes divers hors périmètre.

L’exclusion repose sur les codes des comptes concernés,
et non sur leur position dans le fichier.

Ces comptes ne doivent pas être assimilés automatiquement
à des lignes de fin d’export.

Un regroupement utile ne doit pas être supprimé au seul motif
qu’il ne désigne pas une classe précise.

Toute nouvelle ligne de structure ou de total doit être identifiée
avant de définir une règle de retrait.

---

## 7. Référentiels et enrichissement

### Comptes G

La préparation du référentiel comprend :

- la lecture de G.txt ;
- la conservation de Compte G en texte ;
- le nettoyage des champs ;
- la sélection du périmètre documenté ;
- l’exclusion explicite des comptes divers hors périmètre ;
- la vérification des libellés et de l’unicité de Compte G.

Des regroupements tels que PRIMAIRE ou PRIMARY SCHOOL peuvent être
conservés lorsqu’ils sont utiles.

Ils ne permettent pas, à eux seuls, de déduire une classe plus précise.

### Comptes T

La convention métier est :

```text
Un compte tiers correspond à un seul élève.
```

La préparation comprend :

- la lecture de T.txt ;
- la préparation de Compte T, Nom et Compte G ;
- le contrôle des champs nécessaires ;
- le contrôle de l’unicité de Compte T ;
- le rapprochement avec `Comptes G` ;
- la récupération de la classe du référentiel ;
- la détermination de Niveau+ et Section.

Les clés du référentiel doivent être uniques avant développement
des colonnes issues des jointures.

### Ecritures

La table conserve les mouvements du périmètre comptable retenu.

Une ligne représente une ligne comptable, et non nécessairement
un élève distinct ou une opération unique.

La classe portée par le quatrième champ de E.txt est conservée
dans `Ecritures[Classe]`.

Une jointure gauche sur Compte T ajoute uniquement Niveau+
depuis `Comptes T`.

La section reste disponible dans le référentiel `Comptes T`.

Les écritures sans correspondance sont signalées pour examen,
et non supprimées automatiquement.

Une jointure gauche peut multiplier les lignes si la clé
du référentiel n’est pas unique. Elle doit donc être accompagnée
de contrôles de conservation.

### Deux sources de classe

- `Ecritures[Classe]` décrit la classe portée par le mouvement.
- `Comptes T[Classe]` décrit le rattachement du référentiel.

Une différence doit être expliquée avant correction.
Elle peut nécessiter un traitement historique lorsque les rattachements
évoluent entre plusieurs périodes.

---

## 8. Regroupements scolaires

La restitution utilise une organisation métier par section,
niveau, classe et élève.

La classification documentée repose sur les correspondances suivantes :

| Classes | Niveau+ | Section |
|---|---|---|
| PETITE SECTION, MOYENNE SECTION, GRANDE SECTION | Maternelle Francophone | Section Francophone |
| PRE-NURSERY, NURSERY I, NURSERY II | Maternelle Anglophone | Section Anglophone |
| CLASS I à CLASS VI | Primaire Anglophone | Section Anglophone |
| CIL, CP, CE1, CE2, CM1, CM2 | Primaire Francophone | Section Francophone |

Les libellés sources doivent correspondre à la nomenclature contrôlée.

Une valeur inconnue ne doit pas être affectée automatiquement
à une catégorie par défaut sans justification.

Les classifications non reconnues doivent être identifiées
pour vérification.

Les référentiels servent à filtrer et à agréger les écritures.
Ils ne constituent pas des montants supplémentaires à additionner
aux opérations des élèves.

---

## 9. Périmètre temporel et actualisation

Les données disponibles couvrent août 2025 à avril 2026.

La préparation ne doit pas supprimer les autres mois pour limiter
le modèle à octobre 2025.

Octobre est la situation de référence illustrée.
Les sélections temporelles et les cumuls sont gérés dans le modèle
et les mesures DAX.

La convention des cumuls académiques commence au 1er août.

Une sélection de février 2026 permet donc une lecture cumulée
depuis août 2025, sans remise à zéro en janvier.

### Renouvellement des sources

Les scripts lisent les fichiers désignés.
Ils ne combinent pas automatiquement plusieurs extractions successives.

Les exports utilisés doivent conserver la période nécessaire
aux analyses et aux cumuls.

Une extraction limitée aux nouveaux mouvements ne remplace pas,
à elle seule, l’historique requis.

Des exports couvrant les mêmes opérations ne doivent pas être concaténés
sans règle explicite, au risque de dupliquer les écritures.

### Moment d’exécution

Les traitements Power Query sont exécutés lors de l’actualisation,
et non à chaque changement de segment dans le rapport.

Une actualisation réussie peut charger des données inchangées
si les exports Sage n’ont pas été renouvelés.

La dernière date d’écriture ne démontre pas que le dernier mois
disponible est complet.

---

## 10. Contrôles et résultats consignés

### Règles à examiner

Les contrôles portent notamment sur :

- la structure et l’ordre des champs ;
- la conversion des dates et des montants ;
- l’unicité des référentiels ;
- les correspondances entre comptes ;
- les valeurs du champ Sens ;
- les classifications scolaires ;
- la conservation des lignes et des montants.

### Requêtes de contrôle documentées

| Requête | Restitution | Conclusion consignée |
|---|---|---|
| CONTROLE_NiveauxManquants | Lignes sans Niveau+ à examiner | Exécutée ; aucune anomalie signalée |
| CONTROLE_CoherenceClasses | Différences de classe à examiner | Exécutée ; aucune anomalie signalée |
| CONTROLE_ValiditeEcritures | Écritures ne respectant pas les règles contrôlées | Exécutée ; aucune anomalie signalée |
| CONTROLE_ConservationJointure | Cinq lignes de synthèse avant/après | Écarts nuls confirmés sur le périmètre testé |

Les conclusions reposent sur les confirmations de l’auteur
reprises dans le journal.

Les trois premières requêtes doivent être vides lorsqu’aucune anomalie
n’est détectée selon leurs règles.

Le contrôle de conservation retourne cinq lignes même lorsque
tout est conforme. La conclusion dépend des écarts, et non
de l’absence de lignes.

### Conservation avant et après enrichissement

Les comparaisons portent sur :

1. le nombre total de lignes ;
2. le nombre de lignes au débit ;
3. le nombre de lignes au crédit ;
4. le total des montants au débit ;
5. le total des montants au crédit.

La comparaison utilise le même périmètre comptable préparé,
avant et après la jointure.

Les écarts nuls ont été confirmés.
Les valeurs détaillées Avant et Après restent à renseigner
dans le journal depuis le résultat du contrôle.

### Limites des conclusions

La conservation des agrégats ne démontre pas automatiquement :

- l’exhaustivité des exports Sage ;
- l’exactitude de chaque affectation ;
- la validité de tous les indicateurs DAX.

Deux écritures similaires peuvent correspondre à deux opérations réelles.

L’export documenté ne comporte pas d’identifiant unique de mouvement :
aucune déduplication automatique des écritures n’est appliquée.

[Plan de contrôle qualité](../quality/README.md) ·
[Journal des résultats](../docs/controle-qualite.md)

---

## 11. Répartition des responsabilités

| Couche | Responsabilité |
|---|---|
| Sage Saari | Enregistrement et export des opérations comptables |
| Power Query | Lecture, nettoyage, sélection et enrichissement |
| Modèle Power BI | Relations entre les tables et propagation des filtres |
| DAX | Indicateurs, comptage distinct et cumuls dynamiques |
| Rapport | Présentation, filtres et navigation |
| Power BI Service et passerelle | Publication contrôlée et accès aux sources pour l’actualisation |
| GitHub | Documentation et suivi des versions du code et des supports publics |

Les effectifs sont calculés à partir des comptes élèves distincts
ayant une constatation de scolarité.

Ils ne doivent pas être obtenus par simple comptage des lignes
d’écritures ou addition des effectifs mensuels.

Les scripts Power Query ne remplacent ni les règles DAX
ni les relations du modèle.

Les résultats des tests DAX sont consignés séparément des contrôles
de préparation des données.

---

## 12. Utiliser les scripts

Les fichiers `.pq` contiennent du code Power Query M.
GitHub ne les exécute pas.

L’actualisation de ce README ne modifie pas les requêtes
déjà présentes dans Power BI.

### Installation ou mise à jour dans Desktop

Dans une copie autorisée du fichier Power BI Desktop :

1. Ouvrir « Transformer les données ».
2. Créer ou vérifier les paramètres nécessaires.
3. Respecter l’ordre des dépendances : Comptes G, Comptes T, Ecritures.
4. Sélectionner la requête existante ou la créer si elle est absente.
5. Utiliser le nom prévu dans le catalogue.
6. Ouvrir « Éditeur avancé ».
7. Insérer le script complet de la version retenue.
8. Actualiser les résultats.
9. Examiner les erreurs et exécuter les contrôles concernés.
10. Documenter les conclusions avant d’intégrer la modification
    dans la version utilisée.

Éviter de créer une seconde requête portant un nom différent
lorsqu’une requête métier existe déjà et doit être mise à jour.

Les colonnes ou tables utilisées par des relations, mesures ou visuels
ne doivent pas être supprimées ou renommées sans examen
de leurs dépendances.

### Exécution des contrôles

Un aperçu ancien ou les seules lignes visibles à l’écran
ne suffisent pas à établir la conclusion d’un contrôle.

Une requête dont le chargement est désactivé et qui n’est utilisée
par aucune autre requête ne doit pas être considérée comme
automatiquement exécutée à chaque actualisation du modèle.

Un tableau retournant des anomalies ne bloque pas nécessairement
l’actualisation. Le mécanisme d’exécution, de restitution et d’alerte
doit être défini explicitement.

Les modalités sont détaillées dans le
[plan de contrôle qualité](../quality/README.md).

---

## 13. Validation, versions et publication

Une modification fonctionnelle doit être testée avant son intégration
dans la version opérationnelle.

Les comparaisons doivent utiliser un périmètre explicite :

- mêmes fichiers et mêmes versions de données ;
- mêmes périodes ;
- mêmes comptes et règles de sélection ;
- mêmes filtres pour les comparaisons dans le modèle ;
- mêmes conventions de calcul.

Les écarts doivent être expliqués.
Les données ne doivent pas être modifiées arbitrairement
pour reproduire un ancien total.

### Traçabilité

Conserver notamment :

- la version des sources ;
- la version des scripts ;
- la version du modèle ;
- les contrôles exécutés ;
- les résultats observés ;
- les corrections et nouveaux tests ;
- la référence du commit associé au code utilisé.

Un commit de publication des captures ne constitue pas,
à lui seul, une référence de validation des scripts.

Une modification dans GitHub ne met pas automatiquement à jour
Power BI Desktop ou le modèle publié dans Power BI Service.

### Supports publics

La galerie comprend huit captures couvrant les cinq dashboards.

Elle distingue :

- les restitutions agrégées des dashboards 1 à 3 ;
- les lignes individuelles entièrement synthétiques des dashboards 4 et 5,
  selon la confirmation de l’auteur.

Cette adaptation de présentation ne requalifie pas les données sources
réelles ni les résultats de la campagne de tests métier.

Les captures ne constituent pas un jeu de données téléchargeable
et ne démontrent pas que l’ensemble du modèle est prêt à être publié.

Les exports réels, les correspondances d’identité et les modèles
contenant les données détaillées restent hors du dépôt public.

Un éventuel jeu synthétique téléchargeable devra être documenté
et contrôlé séparément.

---

## Documentation associée

- [Présentation générale du projet](../README.md)
- [Galerie du rapport](../images/README.md)
- [Paramètres d’importation](parameters.example.md)
- [Méthodologie](../docs/methodologie.md)
- [Dictionnaire des données](../docs/dictionnaire-donnees.md)
- [Plan de contrôle qualité](../quality/README.md)
- [Journal de contrôle qualité](../docs/controle-qualite.md)
- [Mesures DAX](../dax/README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Confidentialité](../docs/confidentialite.md)
- [Déploiement](../docs/deploiement.md)
- [Règles d’exclusion Git](../.gitignore)
