# Contrôles de qualité des données scolaires

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce dossier présente les contrôles destinés à vérifier la préparation
des exports Sage et la cohérence des données utilisées dans Power BI.

Les scripts sont ajoutés progressivement.

Leur présence dans GitHub ne prouve pas leur exécution ni la conformité
des résultats. Les tests doivent être réalisés et documentés séparément.

---

## 1. Objectifs

- Vérifier les formats et les types de données.
- Sécuriser les rapprochements entre écritures et référentiels.
- Repérer les rattachements scolaires manquants.
- Prévenir les doubles comptages introduits par les jointures.
- Rapprocher les montants préparés des exports comptables.
- Distinguer les anomalies réelles des différences justifiées.
- Conserver une trace des vérifications et des corrections.

---

## 2. Périmètre comptable

Les indicateurs sont calculés sur les lignes des comptes tiers élèves.

Dans le périmètre confirmé du projet :

- le débit représente la constatation de la scolarité ;
- le crédit représente le règlement pour l’élève.

Les contreparties de produits et de trésorerie sont exclues
par les traitements Power Query.

Les contrôles de conservation doivent donc comparer les montants
sur le même périmètre comptable retenu.

Il n’est pas attendu que le total des débits soit égal au total des
crédits après exclusion des contreparties.

La différence contribue à expliquer le solde des comptes élèves.

---

## 3. Répartition des informations scolaires

La version documentée conserve les règles suivantes :

| Information | Origine |
|---|---|
| Classe dans Ecritures | Quatrième champ de E.txt |
| Classe dans Comptes T | Rapprochement avec Comptes G |
| Niveau+ dans Ecritures | Jointure avec Comptes T |
| Section | Attribut du référentiel Comptes T |

Une différence entre la classe d’une écriture et celle du référentiel
doit être examinée avant toute correction.

Elle peut résulter d’une erreur de rattachement, mais aussi d’une évolution
du référentiel ou d’un changement de classe à documenter.

La classe de l’écriture ne doit pas être écrasée automatiquement
pour imposer une concordance.

---

## 4. Plan de contrôle

| ID | Contrôle | Résultat attendu |
|---|---|---|
| Q01 | Encodage des exports | Accents et caractères correctement restitués |
| Q02 | Conversion des dates | Dates conformes aux valeurs sources et au format JJMMAA |
| Q03 | Unicité des comptes généraux | Une ligne par Compte G dans le référentiel |
| Q04 | Unicité des comptes tiers | Une ligne par Compte T dans le référentiel élèves |
| Q05 | Rattachement des écritures | Chaque compte élève utilisé retrouve son référentiel |
| Q06 | Niveau scolaire | Niveau+ renseigné pour les écritures du périmètre |
| Q07 | Conservation des lignes | Aucun ajout ni retrait de lignes lors de l’enrichissement par jointure |
| Q08 | Conservation des montants | Totaux débit et crédit inchangés avant et après enrichissement |
| Q09 | Validité des valeurs | Champs nécessaires renseignés, sens D ou C, montants non négatifs selon la convention source |
| Q10 | Cohérence des classes | Différences entre écritures et référentiels identifiées et justifiées |
| Q11 | Définition de l’effectif | Comptage distinct des comptes élèves, sans assimilation automatique aux lignes comptables |

Les contrôles Q03 et Q04 sont également intégrés aux requêtes
professionnelles de préparation des référentiels.

Un échec de ces contrôles ne doit pas être contourné uniquement
pour permettre le chargement du rapport.

---

## 5. Contrôle des dates

La source présente les dates sous la forme JJMMAA.

Exemples de lecture attendue :

```text
200825 → 20/08/2025
010925 → 01/09/2025
```

Le traitement documenté découpe le texte en groupes de deux caractères,
recompose la date avec des barres obliques et applique une conversion
avec la culture fr-FR.

Les tests doivent vérifier notamment :

- les dates comportant un zéro initial ;
- les jours supérieurs à 12 ;
- le passage de décembre 2025 à janvier 2026 ;
- l’interprétation correcte des années sur deux chiffres ;
- la date minimale et la date maximale obtenues.

Le mois d’octobre est une situation de référence du rapport.
Il ne doit pas servir à supprimer les autres mois disponibles.

---

## 6. Contrôle des jointures

### Avant l’enrichissement

Relever dans le périmètre des comptes élèves :

- le nombre de lignes ;
- le total des montants au débit ;
- le total des montants au crédit.

### Après l’enrichissement

Vérifier :

- le maintien du nombre de lignes ;
- la conservation du total débit ;
- la conservation du total crédit ;
- l’absence de niveau scolaire manquant.

Une jointure gauche conserve les écritures sans correspondance,
mais elle peut aussi multiplier les lignes si la clé du référentiel
n’est pas unique.

Le contrôle d’unicité du référentiel est donc indispensable.

### Écritures similaires

Deux lignes identiques en apparence peuvent correspondre à deux
opérations réellement distinctes.

Aucune suppression automatique ne doit être réalisée sans identifiant
d’écriture ou justification permettant de démontrer le doublon.

---

## 7. Interprétation des résultats

Une ligne retournée par un contrôle représente un élément à examiner.

Exemples :

- un Niveau+ vide peut signaler un compte tiers non rapproché ;
- une différence de classe peut nécessiter une vérification du référentiel ;
- une hausse du nombre de lignes après jointure peut révéler une clé dupliquée ;
- une erreur de date peut provenir du format d’export ou de son interprétation.

Un résultat vide signifie seulement qu’aucune anomalie n’a été détectée
selon la règle et le périmètre utilisés.

Il ne constitue pas une validation globale du projet.

Les champs numériques vides, les zéros et les erreurs de conversion
ne doivent pas être considérés comme équivalents.

---

## 8. Procédure de traitement des anomalies

Pour chaque anomalie :

1. Identifier les lignes concernées dans l’environnement interne.
2. Examiner la source et les règles de transformation.
3. Déterminer la cause.
4. Documenter la justification ou la correction proposée.
5. Faire valider la correction selon les responsabilités applicables.
6. Corriger la source ou le traitement approprié.
7. Actualiser les données.
8. Réexécuter le contrôle.
9. Consigner le résultat.

Les données ne doivent pas être modifiées uniquement pour retrouver
un ancien total ou obtenir un tableau de contrôle vide.

---

## 9. Exécution des contrôles

GitHub conserve le code, mais ne l’exécute pas.

Dans une copie du fichier Power BI Desktop :

1. Ouvrir « Transformer les données ».
2. Vérifier que les requêtes métier sont disponibles.
3. Créer une requête vide pour le contrôle.
4. Lui attribuer le nom prévu dans le script.
5. Ouvrir « Éditeur avancé ».
6. Coller le code.
7. Actualiser l’aperçu.
8. Examiner et documenter le résultat.

Une requête dont le chargement est désactivé et qui n’est utilisée
par aucune autre requête ne doit pas être considérée comme un contrôle
automatiquement exécuté à chaque actualisation du modèle.

Pour un suivi dans Power BI Service, une méthode d’exécution et
de restitution des contrôles doit être définie explicitement.

---

## 10. Traçabilité

Pour chaque test, conserver :

| Information | À renseigner |
|---|---|
| Identifiant du contrôle | Q01, Q02… |
| Date d’exécution | Date réelle du test |
| Version des exports | Fichiers et date d’extraction |
| Version du modèle ou du script | Référence de version |
| Périmètre | Comptes, dates et filtres |
| Résultat attendu | Règle vérifiée |
| Résultat observé | Comptage, montant ou constat |
| Conclusion | Conforme, à examiner ou non conforme |
| Action et nouveau test | Si une correction est nécessaire |

Ne pas inscrire « Conforme » simplement parce que le script
a été créé ou déposé dans GitHub.

---

## 11. Confidentialité des contrôles

Les contrôles peuvent faire apparaître des comptes élèves
ou d’autres informations individuelles.

Leurs résultats détaillés doivent rester dans un environnement
interne autorisé.

Le dépôt public peut présenter :

- les scripts de contrôle ;
- les règles appliquées ;
- des résultats agrégés autorisés ;
- des exemples fictifs clairement identifiés.

Ne pas publier les noms réels, comptes tiers identifiants,
situations financières nominatives ou correspondances avec les élèves.

---

## Documentation associée

- [Présentation générale du projet](../README.md)
- [Préparation des exports Sage](../powerquery/README.md)
- [Paramètres d’importation](../powerquery/parameters.example.md)
- [Données sources et conditions de diffusion](../data/README.md)
