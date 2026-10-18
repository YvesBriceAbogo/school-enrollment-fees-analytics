# Paramètres d’importation des exports Sage

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document décrit la configuration nécessaire à la lecture des exports
Sage Saari dans Power Query.

Les chemins présentés sont des exemples.
Les valeurs réelles doivent être renseignées dans l’environnement
Power BI de l’utilisateur.

Aucun export nominatif, mot de passe ou identifiant de connexion
ne doit être ajouté à ce fichier.

---

## 1. Paramètre principal

| Propriété | Configuration |
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
- une expression comme File.Contents ;
- des guillemets ajoutés autour du chemin dans le champ de saisie ;
- un lien vers une page GitHub.

Pour la configuration documentée, saisir le chemin sans barre oblique
finale.

---

## 2. Organisation attendue des fichiers

Le dossier configuré doit contenir :

```text
G.txt
T.txt
E.txt
```

| Fichier | Fonction | Requête Power BI |
|---|---|---|
| G.txt | Référentiel des comptes généraux | Comptes G |
| T.txt | Référentiel des comptes tiers | Comptes T |
| E.txt | Écritures comptables | Ecritures |

Exemple d’organisation locale :

```text
C:\PowerBI\school-fees\data\
├── G.txt
├── T.txt
└── E.txt
```

Les scripts utiliseront pDossierSource pour construire le chemin
de chaque fichier.

Les fichiers réels doivent rester hors du dépôt destiné à devenir public.

---

## 3. Création du paramètre dans Power BI Desktop

Cette procédure sera utilisée au moment de l’intégration et des tests.
La création du présent fichier Markdown dans GitHub ne l’exécute pas.

1. Ouvrir une copie du fichier Power BI Desktop.
2. Cliquer sur « Transformer les données ».
3. Dans l’éditeur Power Query, ouvrir « Gérer les paramètres ».
4. Cliquer sur « Nouveau paramètre ».
5. Renseigner :

```text
Nom : pDossierSource
Type : Texte
Valeurs suggérées : Toute valeur
Valeur actuelle : chemin réel du dossier contenant G.txt, T.txt et E.txt
```

6. Activer « Obligatoire » si cette option est proposée.
7. Valider.

Le nom pDossierSource doit être reproduit exactement :
les scripts y feront référence.

Le paramètre doit exister avant l’exécution des requêtes qui l’utilisent.

---

## 4. Options de lecture à confirmer

Les requêtes initiales utilisent une virgule comme séparateur.
Les autres caractéristiques doivent être vérifiées sur les exports
avant de finaliser les scripts.

| Élément | État ou règle |
|---|---|
| Séparateur | Virgule dans les requêtes initiales |
| Encodage | À confirmer sur les exports |
| Présence d’en-têtes | À confirmer |
| Ordre des champs | À vérifier pour chaque fichier |
| Format de la date dans E.txt | À confirmer avant conversion |
| Format des montants | À vérifier : décimales et séparateurs éventuels |
| Lignes de fin dans G.txt | À identifier par leur contenu |

### Encodage

L’encodage doit permettre de restituer correctement les accents
et les caractères présents dans les fichiers.

Il ne doit pas être choisi uniquement parce qu’il s’agit de la valeur
par défaut d’un outil.

### Dates

La requête initiale découpe le champ de date en groupes de deux caractères.

Avant de remplacer ce traitement, il faut confirmer :

- l’ordre du jour, du mois et de l’année ;
- le nombre de caractères ;
- la présence éventuelle de séparateurs ;
- la règle d’interprétation d’une année sur deux chiffres.

Une date invalide doit être signalée plutôt que remplacée
silencieusement par une date par défaut.

### Lignes de fin

Le traitement initial retire les deux dernières lignes de G.txt.

La version professionnelle doit identifier leur nature avant de définir
une règle de suppression fondée sur le contenu.

Leur position seule ne constitue pas un critère suffisamment fiable.

---

## 5. Paramétrage et périmètre académique

pDossierSource est un paramètre technique d’accès aux fichiers.
Il ne détermine pas le mois analysé dans le rapport.

Les données disponibles couvrent août 2025 à avril 2026.

La préparation doit conserver ce périmètre disponible.
Elle ne doit pas limiter l’importation à octobre 2025.

### Convention temporelle du projet

- Début des cumuls académiques : 1er août.
- Situation illustrée : arrêté au 31 octobre 2025.
- Fonctionnement attendu : sélection dynamique d’un autre mois.

Les bornes des cumuls sont gérées dans les mesures DAX et le modèle.

Aucun paramètre Power Query fixant systématiquement l’analyse
à octobre 2025 n’est prévu dans cette configuration.

La dernière date disponible ne garantit pas, à elle seule,
que le dernier mois d’extraction soit complet.

---

## 6. Modification du dossier source

Pour utiliser les scripts sur un autre ordinateur :

1. Préparer un dossier accessible contenant les trois fichiers compatibles.
2. Modifier la valeur de pDossierSource.
3. Vérifier les noms des fichiers.
4. Vérifier les formats d’export.
5. Actualiser les requêtes.
6. Examiner les résultats et les erreurs éventuelles.
7. Effectuer les contrôles de cohérence.

Une modification du chemin ne suffit pas si la structure ou le format
des exports a également changé.

Ne pas modifier les données pour les faire correspondre artificiellement
à un ancien résultat.

---

## 7. Utilisation avec une passerelle standard

Si le modèle est actualisé dans Power BI Service à partir de fichiers
locaux, leur accès doit être configuré dans la passerelle.

Les conditions comprennent notamment :

- une machine de passerelle disponible ;
- un chemin accessible depuis cette machine ;
- des identifiants autorisés à lire les fichiers ;
- des connexions correspondant aux sources réellement détectées
  dans le modèle.

Un chemin commençant par C:\ désigne le disque de la machine
qui exécute l’accès aux fichiers.

Le fait d’utiliser un paramètre commun de dossier ne transforme pas
automatiquement trois sources File.Contents en une seule source Dossier.

Les connexions doivent correspondre au connecteur et aux chemins
effectivement utilisés.

Un fichier lu par son chemin local dans un dossier OneDrive synchronisé
reste une source locale pour cette configuration.

La documentation du paramètre ne crée ni la connexion de passerelle
ni la planification d’actualisation.

---

## 8. Contrôles avant exécution

- [ ] Le paramètre pDossierSource existe et est de type Texte.
- [ ] Le chemin désigne un dossier accessible.
- [ ] G.txt, T.txt et E.txt sont présents.
- [ ] Les formats d’export ont été confirmés.
- [ ] L’encodage restitue correctement les caractères.
- [ ] Les dates sont interprétées sans ambiguïté.
- [ ] Les montants sont convertis correctement.
- [ ] Les lignes de structure ou de fin sont identifiées.
- [ ] Les données réelles restent hors du dépôt public.

Les cases doivent être cochées après vérification effective.

---

## 9. Informations à conserver pour la reproductibilité

Pour chaque version analysée, consigner :

- la date d’extraction Sage ;
- la période couverte par les exports ;
- le format d’export utilisé ;
- les options de lecture retenues ;
- la version des scripts ;
- les filtres et la période de restitution ;
- les résultats des contrôles.

La consultation du code sur GitHub ne nécessite pas l’accès
aux exports nominatifs.

Pour une démonstration publique reproductible, des fichiers fictifs
compatibles pourront être préparés séparément.

---

## Documentation associée

- [Traitements Power Query](README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Présentation générale du projet](../README.md)
- [Règles d’exclusion Git](../.gitignore)
