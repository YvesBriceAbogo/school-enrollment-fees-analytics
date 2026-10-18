# Préparation des exports Sage — Power Query M

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce dossier documente les traitements Power Query utilisés pour transformer
les exports comptables Sage Saari en tables exploitables dans Power BI.

Il décrit la lecture des fichiers, la sélection du périmètre comptable,
le nettoyage, le typage et l’enrichissement des écritures.

Les scripts professionnels sont ajoutés progressivement.
Leur présence dans GitHub ne signifie pas qu’ils ont été exécutés
et validés dans le modèle Power BI.

---

## 1. Objectifs

- Paramétrer l’accès aux fichiers sources.
- Préparer les dates, identifiants et montants.
- Conserver le périmètre comptable consacré aux comptes élèves.
- Enrichir les écritures avec les référentiels.
- Organiser les regroupements par classe, niveau et section.
- Préserver la traçabilité des opérations.
- Identifier les anomalies sans les masquer.
- Faciliter la maintenance et la reproduction du projet.

---

## 2. Sources attendues

Les traitements reposent sur trois fichiers texte exportés
de Sage Saari version 15.

| Fichier | Contenu | Table Power BI |
|---|---|---|
| G.txt | Référentiel des comptes généraux | Comptes G |
| T.txt | Référentiel des comptes tiers | Comptes T |
| E.txt | Écritures comptables | Ecritures |

Les requêtes fournies utilisent `Csv.Document` avec une virgule
comme séparateur.

L’encodage, le format exact des dates, l’ordre des colonnes
et les éventuelles lignes de fin doivent être confirmés avant
de finaliser les scripts d’importation.

Les fichiers réels ne sont pas destinés au dépôt public.

---

## 3. Sélection comptable déjà réalisée

La comptabilité source est exclusivement consacrée à la scolarité.

Les exports contiennent les mouvements sur les comptes élèves
et leurs contreparties de produits ou de trésorerie.

Les traitements initiaux sélectionnent les comptes commençant par `4`
et écartent notamment ces contreparties.

Dans le périmètre confirmé du projet :

| Sens sur le compte tiers élève | Signification |
|---|---|
| D | Constatation des frais de scolarité |
| C | Règlement pour l’élève |

Cette sélection est une étape métier de préparation des données.
Elle évite d’intégrer les contreparties aux indicateurs analysés.

La version documentée conserve cette logique et explicite ses hypothèses.

Le préfixe `4` n’est pas présenté comme une règle universelle permettant
d’identifier des élèves dans n’importe quelle comptabilité.
Son utilisation dépend ici du périmètre scolaire confirmé.

---

## 4. Organisation et ordre des scripts

| Fichier prévu | Nom de la requête Power BI | Fonction |
|---|---|---|
| `parameters.example.md` | Paramètres documentés | Configuration des sources |
| `01_comptes_g.pq` | Comptes G | Préparation du référentiel des comptes généraux |
| `02_comptes_t.pq` | Comptes T | Préparation des comptes élèves et enrichissement |
| `03_ecritures.pq` | Ecritures | Préparation des mouvements comptables |

Les préfixes numériques organisent les fichiers dans GitHub.
Ils ne font pas partie des noms des requêtes Power BI.

L’ordre de création suit les dépendances :

```text
G.txt → Comptes G
             ↓
T.txt → Comptes T
             ↓
E.txt → Ecritures
```

Les paramètres doivent être créés avant les requêtes qui les utilisent.

Dans le langage M, un nom de requête contenant un espace s’écrit
par exemple :

```powerquery
#"Comptes G"
```

ou :

```powerquery
#"Comptes T"
```

---

## 5. Paramétrage des sources

Un paramètre de dossier, nommé `pDossierSource`, sera utilisé
pour éviter de répéter un chemin personnel dans les scripts.

Exemple de dossier :

```text
C:\PowerBI\school-fees\data
```

Ce chemin est un exemple.
L’utilisateur doit renseigner l’emplacement réel dans son environnement.

Les trois fichiers attendus restent :

```text
G.txt
T.txt
E.txt
```

Les modalités de création du paramètre seront décrites dans
`parameters.example.md`.

Aucun identifiant de connexion, mot de passe ou chemin personnel
ne doit être publié dans les scripts.

---

## 6. Principes de préparation

### 6.1. Comptes et références

Les comptes généraux et comptes tiers sont traités comme des identifiants.

Le type Texte permet de préserver leur représentation, notamment
les éventuels zéros initiaux.

Le même type doit être utilisé de part et d’autre d’une jointure.

### 6.2. Dates

La conversion doit reposer sur le format réellement produit par Sage.

Le traitement initial découpe le champ de date avant de le recomposer.
La version documentée devra rendre cette règle explicite et contrôlable.

Une date invalide ne doit pas être remplacée silencieusement
par une date par défaut.

### 6.3. Montants

Les montants doivent utiliser un type numérique adapté aux calculs financiers.

Le nombre décimal fixe est privilégié dans la version documentée.

La devise du projet est le FCFA.
Le choix du type numérique ne définit pas à lui seul cette devise.

Une valeur manquante ou une erreur de conversion doit être examinée,
et non assimilée automatiquement à zéro.

### 6.4. Textes

Le nettoyage peut porter sur :

- les espaces en début et fin ;
- les caractères non imprimables ;
- les espaces insécables ;
- les valeurs vides.

Le nettoyage des textes ne constitue pas une anonymisation.

### 6.5. Lignes de structure et lignes de fin

Le retrait des deux dernières lignes utilisé dans le traitement initial
doit être remplacé, dans la version professionnelle, par une règle
fondée sur le contenu réellement identifié.

Il ne faut pas supprimer les dernières lignes uniquement parce qu’elles
occupent une position donnée.

Si les marqueurs de fin ne sont pas connus, leur identification
doit précéder la définition de la règle.

---

## 7. Référentiels et enrichissement

### Comptes G

Ce référentiel porte les comptes de regroupement.

Leur correspondance avec les classes, niveaux et sections doit être
documentée selon la codification réellement utilisée.

Un compte associé à un niveau ou à une section ne permet pas,
à lui seul, de déterminer une classe plus précise.

### Comptes T

Un compte tiers correspond à un seul élève.

La préparation doit notamment vérifier :

- l’unicité de Compte T dans le référentiel ;
- la présence des rattachements nécessaires ;
- la cohérence avec les comptes généraux ;
- l’absence de multiplication des lignes après enrichissement.

### Ecritures

La table conserve les mouvements comptables retenus.

Une ligne représente une écriture, et non nécessairement un élève distinct.

Les jointures doivent enrichir les mouvements sans répéter leurs montants.

Les écritures sans correspondance doivent être signalées pour examen,
et non supprimées automatiquement.

---

## 8. Regroupements scolaires

La restitution utilise la hiérarchie métier :

```text
Section → Niveau → Classe → Élève
```

La correspondance doit être explicite et non ambiguë.

Le traitement initial utilise certains libellés tels que SECTION,
NURSERY et CLASS pour classer les comptes.

Dans la version documentée, une valeur inconnue ne doit pas être
affectée automatiquement à une catégorie par défaut sans justification.

Les classifications non reconnues doivent être identifiées
pour vérification.

Les tables de regroupement servent à filtrer et agréger les écritures.
Elles ne constituent pas des montants supplémentaires à additionner
aux opérations des élèves.

---

## 9. Périmètre temporel

Les données disponibles couvrent août 2025 à avril 2026.

La préparation ne doit pas supprimer les autres mois pour limiter
le modèle à octobre 2025.

Octobre est la situation de référence illustrée dans le rapport.
Les sélections temporelles et les cumuls académiques sont gérés
dans les mesures et dans le modèle.

La convention retenue pour les cumuls commence au 1er août.

Un mois sélectionné en février 2026 doit donc permettre une lecture
cumulée depuis août 2025, sans remise à zéro en janvier.

Les traitements Power Query sont exécutés à l’actualisation,
et non à chaque changement de segment dans le rapport.

---

## 10. Contrôles à réaliser

| Contrôle | Finalité |
|---|---|
| Structure des fichiers | Vérifier la présence et l’ordre des champs attendus |
| Conversion des dates et montants | Éviter les valeurs mal interprétées |
| Unicité des référentiels | Sécuriser les jointures |
| Correspondance des comptes | Repérer les rattachements manquants |
| Nombre de lignes avant et après jointure | Détecter une multiplication des écritures |
| Total des débits avant et après enrichissement | Vérifier la conservation des montants |
| Total des crédits avant et après enrichissement | Vérifier la conservation des règlements |
| Valeurs du champ Sens | Identifier les valeurs autres que D et C |
| Classification scolaire | Examiner les classes, niveaux ou sections non reconnus |

La conservation des lignes et montants se vérifie sur le périmètre
comptable retenu, après les exclusions métier justifiées.

Deux écritures identiques en apparence peuvent correspondre à deux
opérations réelles. Elles ne doivent pas être supprimées comme doublons
sans référence ou justification permettant de le démontrer.

---

## 11. Répartition des responsabilités

| Couche | Responsabilité |
|---|---|
| Sage Saari | Enregistrement et export des opérations comptables |
| Power Query | Lecture, nettoyage, sélection et enrichissement |
| Modèle Power BI | Relations entre les tables |
| DAX | Indicateurs, comptage distinct et cumuls dynamiques |
| Rapport | Présentation, filtres et navigation |
| GitHub | Documentation et suivi des versions du code |

Les effectifs sont calculés à partir des comptes élèves distincts,
et non par simple comptage des lignes d’écritures.

Les scripts Power Query ne remplacent pas les règles de calcul DAX
ni les relations du modèle.

---

## 12. Utiliser les scripts

Les fichiers `.pq` contiennent du code Power Query M.
GitHub ne les exécute pas.

Dans une copie du fichier Power BI Desktop :

1. Ouvrir « Transformer les données ».
2. Créer les paramètres nécessaires.
3. Créer ou sélectionner la requête concernée.
4. Utiliser le nom prévu dans le catalogue des scripts.
5. Ouvrir « Éditeur avancé ».
6. Coller le script complet.
7. Actualiser l’aperçu.
8. Examiner les erreurs et résultats.
9. Vérifier les rapprochements avant d’appliquer les modifications.

L’ordre de création des dépendances doit être respecté.

Les colonnes ou tables utilisées par des relations, mesures ou visuels
ne doivent pas être supprimées sans examen de leurs dépendances.

---

## 13. Validation et publication

Une modification fonctionnelle doit être testée avant son intégration
dans la version publiée du rapport.

Les résultats doivent être comparés à périmètre identique :

- mêmes fichiers ;
- mêmes dates ;
- mêmes comptes ;
- mêmes filtres ;
- mêmes conventions de calcul.

Les PDF et captures doivent correspondre à la version du modèle
effectivement utilisée.

Les exports nominatifs et modèles contenant les données réelles
restent hors du dépôt public.

Les éventuels exemples diffusables doivent être fictifs ou préparés
selon les conditions de diffusion documentées.

---

## Documentation associée

- [Présentation générale du projet](../README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Règles d’exclusion Git](../.gitignore)
