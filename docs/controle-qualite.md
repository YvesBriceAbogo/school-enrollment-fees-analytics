# Journal de contrôle qualité

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document consigne les contrôles réalisés sur la préparation des données
et les indicateurs du modèle Power BI.

Les résultats reposent sur les exécutions effectuées par l’auteur,
ses confirmations et la capture de la page de contrôle DAX.

Ils concernent la version testée. Ils ne constituent pas une certification
de l’ensemble des données sources ni de tous les usages possibles du rapport.

---

## 1. Identification de la campagne

| Élément | Information |
|---|---|
| Responsable | Brice Abogo |
| Date réelle d’exécution | À renseigner |
| Version ou date d’extraction des fichiers | À renseigner |
| Version du modèle testé | À renseigner |
| Référence du commit correspondant | À renseigner |
| Année académique | 2025/2026 |
| Début des cumuls | 1er août 2025 |
| Dernière date d’écriture affichée lors du test | 02/04/2026 |
| Situation principale contrôlée | Arrêté au 31 octobre 2025 |

La date d’exécution du test, la date d’extraction et la dernière date
d’écriture sont des informations distinctes.

La présence d’une écriture au 2 avril 2026 ne démontre pas
l’exhaustivité du mois d’avril.

---

## 2. Périmètre comptable

Les contrôles portent sur les écritures des comptes tiers élèves.

Dans ce périmètre :

- D représente la constatation de la scolarité ;
- C représente le règlement pour l’élève.

Les contreparties de produits et de trésorerie sont exclues
par les traitements Power Query.

Il n’est donc pas attendu que le total débit soit égal au total crédit
dans la table analytique.

La classe de l’écriture provient de E.txt.
Le niveau scolaire est ajouté depuis le référentiel Comptes T.

---

## 3. Contrôles Power Query

| Contrôle | Requête | Conclusion communiquée |
|---|---|---|
| Niveaux manquants | CONTROLE_NiveauxManquants | Exécuté ; aucune anomalie signalée |
| Cohérence des classes | CONTROLE_CoherenceClasses | Exécuté ; aucune anomalie signalée |
| Validité des écritures | CONTROLE_ValiditeEcritures | Exécuté ; aucune anomalie signalée |
| Conservation de la jointure | CONTROLE_ConservationJointure | Conforme sur le périmètre testé |

Les trois premiers contrôles restituent les lignes à examiner.
Un résultat sans anomalie doit donc être vide.

Le contrôle de conservation présente cinq lignes de synthèse,
même lorsque tout est conforme.

### Conservation avant et après enrichissement

| Indicateur | Avant | Après | Écart confirmé |
|---|---:|---:|---:|
| Nombre total de lignes | À renseigner | À renseigner | 0 |
| Nombre de lignes au débit | À renseigner | À renseigner | 0 |
| Nombre de lignes au crédit | À renseigner | À renseigner | 0 |
| Total débit — FCFA | À renseigner | À renseigner | 0 |
| Total crédit — FCFA | À renseigner | À renseigner | 0 |

Les valeurs Avant et Après doivent être recopiées depuis le résultat
du contrôle, sans les reconstituer à partir des cartes du rapport.

La conformité des agrégats ne remplace pas la vérification de chaque
affectation et ne démontre pas l’exhaustivité de l’export Sage.

---

## 4. Tests DAX exécutés

| ID | Test | Résultat observé | Conclusion |
|---|---|---|---|
| DAX-01 | Situation d’octobre 2025 | Montants mensuels et cumulés conformes aux repères | Conforme sur la version testée |
| DAX-02 | Comptage distinct | 58 pour octobre ; 221 en cumul à fin octobre | Résultats consignés |
| DAX-03 | Passage décembre-janvier | Les mouvements antérieurs restent inclus | Conforme |
| DAX-04 | Situation de février 2026 | Cumuls et solde conformes aux repères | Conforme |
| DAX-05 | Mois futur : mai 2026 | Mesures cumulées vides | Conforme à la règle de disponibilité |
| DAX-06 | Filtre de section | Les résultats réagissent au filtre | Fonctionnement confirmé par l’auteur |

Aucun écart ni message d’erreur n’a été signalé par l’auteur
pour ces tests.

Les conclusions concernent les scénarios effectivement examinés.
Elles ne valent pas validation automatique de tous les filtres,
paramètres et interactions du rapport.

---

## 5. Résultats détaillés d’octobre 2025

### Contexte

```text
Année académique : 2025/2026
Mois sélectionné : octobre 2025
Période cumulée  : 01/08/2025 au 31/10/2025
```

### Valeurs observées

| Indicateur | Résultat |
|---|---:|
| Scolarité constatée pendant octobre | 3 805 000 FCFA |
| Règlements enregistrés pendant octobre | 3 286 000 FCFA |
| Élèves distincts ayant une constatation en octobre | 58 |
| Élèves distincts cumulés à fin octobre | 221 |
| Scolarité constatée cumulée | 15 220 000 FCFA |
| Règlements cumulés | 7 488 000 FCFA |
| Solde restant | 7 732 000 FCFA |
| Taux de recouvrement cumulé | 49,20 % |

### Rapprochements

```text
15 220 000 − 7 488 000 = 7 732 000 FCFA
```

```text
7 488 000 / 15 220 000 ≈ 49,20 %
```

Le nombre de 58 ne doit pas être présenté automatiquement comme
le nombre de nouvelles inscriptions.

Il désigne les élèves distincts ayant une constatation de scolarité
dans le mois sélectionné.

L’effectif cumulé est recalculé sur l’ensemble de la période.
Il n’est pas obtenu en additionnant les effectifs mensuels.

Le rapprochement avec un registre administratif d’inscription
constitue une vérification distincte.

---

## 6. Continuité du cumul académique

| Arrêté | Scolarité cumulée | Règlements cumulés | Solde |
|---|---:|---:|---:|
| Décembre 2025 | 15 447 500 | 11 493 000 | 3 954 500 |
| Janvier 2026 | 15 447 500 | 12 807 500 | 2 640 000 |
| Février 2026 | 15 447 500 | 13 833 000 | 1 614 500 |

Montants en FCFA.

Les cumuls ne recommencent pas à zéro en janvier.
Ils conservent les mouvements depuis août 2025.

À février, le taux calculé à partir des montants est d’environ 89,55 %.

Les totaux des mesures cumulatives sont recalculés dans leur contexte.
Ils ne doivent pas additionner les cumuls affichés sur chaque ligne.

---

## 7. Disponibilité des données et période future

La mesure de test affiche comme dernière date disponible :

```text
02/04/2026
```

Avec mai 2026 sélectionné, les mesures cumulées restent vides,
conformément à la règle documentée.

Ce résultat ne signifie pas :

- qu’aucune opération n’a eu lieu en mai ;
- que l’effectif est nul en mai ;
- que le solde a été intégralement réglé.

Il signifie que le mois sélectionné dépasse le dernier mois
contenant des écritures dans les données chargées.

Le dernier mois disponible peut être incomplet.

---

## 8. Vérifications complémentaires restant à consigner

- Rapprochement des élèves distincts avec le registre des inscriptions.
- Vérification de l’exhaustivité des exports par rapport à Sage.
- Tests détaillés par classe et niveau.
- Comportement du paramètre de champs pour les quatre indicateurs.
- Vérification des interactions avec la page journalière.
- Comportement des sélections couvrant plusieurs cycles académiques.
- Tri chronologique des axes et tableaux.
- Concordance de la version testée avec celle publiée dans Power BI Service.
- Préparation et vérification des supports publics.

Ces éléments ne sont pas déclarés réalisés uniquement parce que
les tests précédents sont satisfaisants.

---

## 9. Preuves et traçabilité

La page de contrôle DAX rassemble des résultats agrégés.
Elle peut servir de preuve de test après vérification de son contenu
avant diffusion.

Pour chaque preuve, conserver :

- la date d’exécution ;
- la version des fichiers ;
- la version du modèle ;
- les filtres appliqués ;
- le résultat et la conclusion.

Les résultats individuels contenant des comptes élèves restent
dans l’environnement interne autorisé.

### Fiche pour les prochains tests

```text
Contrôle :
Date :
Version des données :
Version du modèle ou référence du commit :

Périmètre et filtres :
Résultat attendu :
Résultat observé :
Conclusion :

Action corrective éventuelle :
Résultat du nouveau test :
Référence de la preuve :
```

---

## 10. Traitement des anomalies

Lorsqu’un écart est détecté :

1. Identifier le périmètre et les lignes concernés.
2. Vérifier les sources et les référentiels.
3. Examiner les transformations, relations et filtres.
4. Vérifier la définition de la mesure.
5. Documenter la cause et la correction.
6. Actualiser et rejouer le test.
7. Consigner la nouvelle conclusion.

Ne pas modifier les données uniquement pour obtenir un résultat attendu.

Ne pas supprimer les écritures similaires sans démontrer
qu’elles correspondent réellement à des doublons.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Méthodologie](methodologie.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Plan de contrôle qualité](../quality/README.md)
- [Mesures DAX](../dax/README.md)
- [Confidentialité](confidentialite.md)
- [Déploiement](deploiement.md)
