# Paramètres d’importation des exports Sage

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document décrit le paramétrage utilisé pour lire les exports
Sage Saari dans Power Query.

Les chemins présentés sont des exemples non sensibles.
Les valeurs effectives restent configurées dans l’environnement
Power BI autorisé.

La mise à jour de ce fichier Markdown ne crée ni ne modifie
les paramètres du modèle, les connexions de passerelle
ou la planification d’actualisation.

Aucun export nominatif, mot de passe, jeton ou identifiant
de connexion sensible ne doit être ajouté à ce document.

---

## 1. Paramètre principal

| Propriété | Configuration documentée |
|---|---|
| Nom | pDossierSource |
| Type | Texte |
| Obligatoire | Oui |
| Valeurs suggérées | Toute valeur |
| Fonction | Indiquer le dossier contenant les trois exports Sage |

### Valeur d’exemple

```text
C:\PowerBI\school-fees\data
```

Le paramètre contient uniquement le chemin du dossier.

Il ne doit pas contenir :

- le nom d’un fichier particulier ;
- une expression telle que `File.Contents` ;
- des guillemets ajoutés autour du chemin dans le champ de saisie ;
- un lien vers une page GitHub.

Pour la convention documentée, saisir le chemin sans séparateur
de chemin final.

Cette convention doit rester cohérente avec la construction
des chemins dans les requêtes.

Si le paramètre existe et fonctionne déjà, sa valeur ne doit pas
être remplacée par le chemin d’exemple.

Le caractère obligatoire du paramètre ne garantit ni l’existence
du dossier ni les autorisations de lecture des fichiers.

---

## 2. Organisation attendue des fichiers

Le dossier configuré contient :

```text
G.txt
T.txt
E.txt
```

| Fichier | Fonction | Requête Power BI |
|---|---|---|
| G.txt | Référentiel des comptes généraux | Comptes G |
| T.txt | Référentiel des comptes tiers élèves | Comptes T |
| E.txt | Écritures comptables | Ecritures |

Exemple d’organisation locale :

```text
C:\PowerBI\school-fees\data\
├── G.txt
├── T.txt
└── E.txt
```

Ce chemin représente un emplacement de travail d’exemple.
Il ne constitue pas une instruction pour copier les exports
dans le dossier `data/` du dépôt GitHub.

Les sources réelles restent dans un emplacement autorisé,
hors du dépôt public.

### Construction des chemins

Dans la convention documentée, les requêtes construisent
le chemin complet de chaque fichier à partir de `pDossierSource`.

Exemple d’expression pour accéder à G.txt :

```powerquery
File.Contents(pDossierSource & "\G.txt")
```

Cette expression illustre l’accès au fichier.
Elle ne remplace pas le script complet de lecture et de préparation.

Les lectures de T.txt et E.txt utilisent les noms de fichiers
correspondants.

Les guillemets sont nécessaires autour des chaînes de caractères
dans le code M. Ils ne doivent pas être ajoutés à la valeur du dossier
dans le champ de saisie du paramètre.

### Cohérence de l’extraction

Les trois fichiers doivent former un ensemble cohérent
pour le périmètre analysé.

Leur enregistrement doit être terminé avant l’actualisation.
Éviter leur modification pendant la lecture par Power BI.

Les scripts lisent les fichiers désignés.
Ils ne combinent pas automatiquement plusieurs extractions successives.

---

## 3. Créer ou vérifier le paramètre dans Power BI Desktop

Cette procédure concerne une installation ou un changement
de configuration.

Si `pDossierSource` existe déjà, utiliser le paramètre existant
plutôt que le supprimer et le recréer.

### Création si nécessaire

Dans une copie autorisée du modèle :

1. Ouvrir « Transformer les données ».
2. Dans l’éditeur Power Query, ouvrir « Gérer les paramètres ».
3. Sélectionner « Nouveau paramètre ».
4. Renseigner :

```text
Nom : pDossierSource
Type : Texte
Valeurs suggérées : Toute valeur
Valeur actuelle : chemin réel du dossier contenant G.txt, T.txt et E.txt
```

5. Activer « Obligatoire » si cette option est proposée.
6. Valider.
7. Vérifier les chemins évalués par les requêtes.

Le nom `pDossierSource` doit être reproduit exactement.
Les références du langage M sont sensibles à la casse.

Le paramètre doit exister avant l’exécution des requêtes
qui l’utilisent.

L’ordre documenté des dépendances est :

```text
Paramètres
    ↓
Comptes G
    ↓
Comptes T
    ↓
Ecritures
    ↓
Contrôles
```

La création de ce document dans GitHub n’exécute aucune
de ces opérations.

---

## 4. Options de lecture documentées

Les options suivantes correspondent à la version préparée
et documentée du projet.

Elles doivent être réexaminées avant l’utilisation d’un export
dont le format a changé.

| Fichier | Séparateur | Nombre de champs | En-tête dans la structure fournie | Encodage utilisé |
|---|---|---:|---|---|
| G.txt | Virgule | 3 | Aucun | Windows-1252 — code 1252 |
| T.txt | Virgule | 3 | Aucun | UTF-8 — code 65001 |
| E.txt | Virgule | 7 | Aucun | Windows-1252 — code 1252 |

Les requêtes utilisent `Csv.Document` pour interpréter
le contenu des fichiers.

### Ordre des champs

**G.txt**

```text
Compte G, Libellé de regroupement, Marqueur d’export
```

**T.txt**

```text
Compte T, Nom, Compte G
```

**E.txt**

```text
Code, Date, Compte G, Classe, Compte T, Montant, Sens
```

Ces lignes décrivent l’ordre des champs.
Ce ne sont pas des en-têtes à ajouter aux exports.

La première ligne de données ne doit pas être promue
en en-tête si le fichier n’en contient pas.

Le marqueur d’export de G.txt n’est pas le sens D/C utilisé
dans E.txt. Il n’est pas conservé dans la table finale.

### Encodages

G.txt et E.txt ont été annoncés en ANSI.
La version documentée utilise Windows-1252 pour leur lecture.

L’appellation ANSI ne constitue pas un encodage universel.

La restitution des accents et des autres caractères doit rester
contrôlée, notamment après un changement de format ou d’outil
d’extraction.

### Dates

La date source de E.txt utilise le format **JJMMAA**.

Le traitement documenté :

1. conserve une représentation textuelle adaptée au découpage ;
2. découpe la valeur en groupes de deux caractères ;
3. recompose la date avec `/` ;
4. convertit le résultat en Date avec la culture `fr-FR`.

Exemples :

```text
200825 → 20/08/25 → 20/08/2025
010925 → 01/09/25 → 01/09/2025
```

Les contrôles doivent notamment examiner les zéros initiaux,
les jours supérieurs à 12 et l’interprétation des années
sur deux chiffres.

Une date invalide doit être signalée plutôt que remplacée
silencieusement par une date par défaut.

### Comptes et montants

Les comptes généraux et tiers sont conservés comme identifiants textuels.

Le type final documenté de la colonne `Montants` est
le **nombre entier**, en FCFA.

Les montants sont non négatifs selon la convention source confirmée.
Le champ `Sens` distingue les constatations D des règlements C.

Une valeur vide, un zéro et une erreur de conversion
ne sont pas équivalents.

Si une nouvelle extraction introduit des montants fractionnaires
ou un autre format numérique, le typage et les contrôles doivent
être réexaminés sans arrondi silencieux.

### Exclusions dans G.txt

La version documentée de `Comptes G` exclut explicitement
les deux comptes divers hors périmètre par leur code.

La suppression positionnelle des deux dernières lignes
n’est plus la règle documentée.

Ces comptes ne doivent pas être assimilés automatiquement
à des marqueurs de fin d’export.

Toute nouvelle ligne de structure ou de total doit être identifiée
par son contenu avant de définir une règle de retrait.

---

## 5. Paramétrage et périmètre académique

`pDossierSource` est un paramètre technique d’accès aux fichiers.
Il ne détermine pas le mois analysé dans le rapport.

Les données documentées couvrent août 2025 à avril 2026.

La préparation conserve ce périmètre disponible.
Elle ne limite pas l’importation à octobre 2025.

### Conventions temporelles

- Début des cumuls académiques : 1er août.
- Fin du cycle analytique : 31 juillet.
- Situation de référence illustrée : arrêté au 31 octobre 2025.
- Sélection d’autres mois : gérée dans le modèle et les mesures DAX.

Aucun paramètre Power Query fixant systématiquement l’analyse
à octobre 2025 n’est prévu dans cette configuration.

Les fichiers utilisés doivent conserver l’historique nécessaire
aux cumuls. Une extraction limitée aux nouveaux mouvements
ne remplace pas, à elle seule, cet historique.

Des exports couvrant les mêmes opérations ne doivent pas être
concaténés sans règle explicite, au risque de dupliquer
les écritures.

La dernière date d’écriture ne garantit pas, à elle seule,
que le dernier mois disponible soit complet.

---

## 6. Modification du dossier source

Pour utiliser une autre source ou déplacer les fichiers :

1. Préparer un dossier autorisé contenant les trois fichiers compatibles.
2. Identifier la nature et la version des données utilisées.
3. Modifier la valeur de `pDossierSource` dans l’environnement concerné.
4. Vérifier les noms et les chemins complets des fichiers.
5. Vérifier les formats d’export.
6. Actualiser les requêtes.
7. Examiner les erreurs et les résultats.
8. Exécuter les contrôles concernés.
9. Consigner la nouvelle configuration et les conclusions.

Un changement de chemin ne suffit pas si la structure
ou le format des exports a également changé.

Le remplacement des sources par un jeu synthétique constitue
un changement de données à identifier et à tester séparément.

Ne pas modifier les données uniquement pour reproduire
un ancien résultat.

### Contrôles après modification

Les contrôles documentés comprennent :

- `CONTROLE_NiveauxManquants` ;
- `CONTROLE_CoherenceClasses` ;
- `CONTROLE_ValiditeEcritures` ;
- `CONTROLE_ConservationJointure`.

Les trois premières requêtes retournent les lignes à examiner.

Le contrôle de conservation retourne cinq lignes de synthèse.
La conformité dépend des écarts avant/après, et non
de l’absence de lignes.

Les modalités d’exécution et d’interprétation figurent
dans le [plan de contrôle qualité](../quality/README.md).

Si aucun paramètre, fichier ou traitement ne change,
la seule mise à jour de ce document n’impose pas
une nouvelle configuration.

---

## 7. Utilisation avec la passerelle standard

La publication du rapport dans Power BI Service et la configuration
d’une passerelle standard ont été confirmées par l’auteur.

Il n’est pas nécessaire de recréer cette passerelle
pour harmoniser la documentation.

### Sources détectées

Les trois lectures par `File.Contents` restent des lectures
de fichiers distincts.

Le fait d’utiliser un paramètre commun de dossier ne les transforme
pas automatiquement en une seule source de type Dossier.

Les connexions doivent correspondre au connecteur et aux chemins
effectivement détectés dans le modèle.

Après une modification de source, vérifier :

- la valeur effective du paramètre dans l’environnement concerné ;
- les chemins évalués ;
- les connexions de fichiers ;
- l’association du modèle sémantique à ces connexions ;
- les droits d’utilisation et de lecture.

### Accès depuis la machine de la passerelle

Lors d’une actualisation par la passerelle, un chemin commençant
par `C:\` désigne le disque de la machine qui l’héberge.

La présence des fichiers sur le poste utilisant Power BI Desktop
ne suffit pas si la passerelle fonctionne sur une autre machine.

Les conditions comprennent notamment :

- une machine disponible, non en veille ;
- un service de passerelle en fonctionnement ;
- un accès Internet ;
- des fichiers accessibles ;
- des identifiants et autorisations de lecture valides.

### Fichiers synchronisés

Un fichier lu par son chemin local dans un dossier OneDrive synchronisé
reste une source locale pour cette configuration.

Il doit être réellement disponible pour la lecture,
et pas seulement représenté par un fichier à télécharger à la demande.

### Limites de l’automatisation

La passerelle ne produit pas les exports Sage.

La documentation du paramètre ne crée ni les connexions
ni la planification d’actualisation.

Une modification dans GitHub ne modifie pas automatiquement
le modèle publié.

Les réglages effectifs et la dernière actualisation réussie
doivent être consignés dans le suivi du
[déploiement](../docs/deploiement.md).

---

## 8. Liste de vérification lors d’une installation ou d’un changement

- [ ] Le paramètre `pDossierSource` existe avec le nom exact et le type Texte.
- [ ] Sa valeur contient uniquement le chemin du dossier.
- [ ] La convention de séparateur final correspond aux requêtes.
- [ ] Le dossier est accessible depuis l’environnement qui lit les fichiers.
- [ ] G.txt, T.txt et E.txt sont présents et complètement enregistrés.
- [ ] Les fichiers forment un ensemble cohérent pour la période analysée.
- [ ] La structure, le séparateur et les encodages correspondent aux imports.
- [ ] Les dates sont interprétées correctement.
- [ ] Les montants et les comptes conservent les types attendus.
- [ ] Les exclusions reposent sur les règles de contenu documentées.
- [ ] Les contrôles concernés ont été exécutés et leurs résultats consignés.
- [ ] Les sources et connexions du Service ont été vérifiées, si concernées.
- [ ] Les exports réels restent hors du dépôt public.
- [ ] La nature réelle ou synthétique du jeu utilisé est identifiée.

Cette liste s’applique à une installation ou à une modification.

Les cases doivent être cochées après vérification effective,
dans le contexte et la version concernés.

Une liste non renseignée dans ce document ne signifie pas
que la configuration existante est absente.

La présence d’un paramètre ou une actualisation techniquement réussie
ne démontre pas, à elle seule, la qualité métier des données.

---

## 9. Reproductibilité et traçabilité

Pour chaque version analysée, consigner :

- la nature des données : réelles ou synthétiques ;
- la date d’extraction ou la version du jeu d’exemple ;
- la période couverte par les fichiers ;
- les formats et options de lecture ;
- la version des scripts ;
- la version du modèle ;
- la configuration de source utilisée, dans un suivi interne si sensible ;
- les filtres et la période de restitution ;
- les contrôles exécutés et leurs résultats ;
- la référence du code utilisée pour les tests.

Les chemins sensibles et les identifiants techniques ne doivent pas
être recopiés dans la documentation publique.

La consultation du code sur GitHub ne nécessite pas l’accès
aux exports nominatifs.

Les captures synthétiques des dashboards 4 et 5 ne constituent pas
la mise à disposition des fichiers ayant servi à leur création.

À ce stade, cette documentation n’annonce pas de jeu compatible
E.txt, T.txt et G.txt téléchargeable.

Si un jeu synthétique est publié ultérieurement, sa structure,
ses conditions de réutilisation et ses résultats de contrôle
devront être documentés séparément.

Les résultats d’un autre jeu ne sont pas automatiquement validés
par la campagne réalisée sur le modèle métier.

Les références et conclusions sont centralisées dans le
[journal de contrôle qualité](../docs/controle-qualite.md).

---

## Documentation associée

- [Traitements Power Query](README.md)
- [Présentation générale du projet](../README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Méthodologie](../docs/methodologie.md)
- [Dictionnaire des données](../docs/dictionnaire-donnees.md)
- [Plan de contrôle qualité](../quality/README.md)
- [Journal de contrôle qualité](../docs/controle-qualite.md)
- [Mesures DAX](../dax/README.md)
- [Déploiement](../docs/deploiement.md)
- [Confidentialité](../docs/confidentialite.md)
- [Règles d’exclusion Git](../.gitignore)
