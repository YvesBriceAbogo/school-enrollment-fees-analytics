# Journal de contrôle qualité

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document consigne les contrôles réalisés sur la préparation des données
et les indicateurs du modèle Power BI.

Les résultats reposent sur les exécutions effectuées par l’auteur,
ses confirmations et la capture de la page de contrôle DAX.

Ils concernent la version testée. Ils ne constituent pas une certification
de l’ensemble des données sources ni de tous les usages possibles du rapport.

Le suivi de la constitution des supports publics et de l’actualisation
de la documentation est présenté séparément en section 11.

---

## 1. Identification de la campagne

| Élément | Information |
|---|---|
| Responsable | Brice Abogo |
| Date réelle d’exécution des tests | 19/10/2026 |
| Version ou date d’extraction des fichiers | 07/10/2026 |
| Version du modèle testé | suivi-scolarite-tests |
| Référence du commit correspondant | À renseigner |
| Nature des données de la campagne | Données du modèle métier issues des exports Sage réels |
| Année académique | 2025/2026 |
| Début des cumuls | 1er août 2025 |
| Dernière date d’écriture affichée lors du test | 02/04/2026 |
| Situation principale contrôlée | Arrêté au 31 octobre 2025 |

La date d’exécution du test, la date d’extraction et la dernière date
d’écriture sont des informations distinctes.

La présence d’une écriture au 2 avril 2026 ne démontre pas
l’exhaustivité du mois d’avril.

La constitution ultérieure de la galerie et les mises à jour
documentaires ne modifient pas la date de cette campagne.

La référence du commit à compléter doit correspondre aux ressources
utilisées pour les tests. Un commit de publication des captures
ne constitue pas, à lui seul, cette référence.

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

Les résultats de cette campagne concernent le modèle métier.
Ils doivent être distingués des illustrations synthétiques utilisées
pour les lignes individuelles des dashboards 4 et 5 de la galerie.

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

Les écarts nuls ont été confirmés par l’auteur.
Les valeurs détaillées Avant et Après restent à consigner.

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
| DAX-05 | Mois au-delà des données disponibles : mai 2026 | Mesures cumulées vides | Conforme à la règle de disponibilité |
| DAX-06 | Filtre de section | Les résultats réagissent au filtre | Fonctionnement confirmé par l’auteur |

Aucun écart ni message d’erreur n’a été signalé par l’auteur
pour ces tests.

Les conclusions concernent les scénarios effectivement examinés.
Elles ne valent pas validation automatique de tous les filtres,
paramètres et interactions du rapport.

La présence de quatre variantes de Dashboard 1 dans la galerie
illustre les choix du paramètre de champs. Elle ne constitue pas,
à elle seule, un test complet de son comportement.

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

### Rapprochements arithmétiques

À partir des valeurs consignées :

```text
15 220 000 − 7 488 000 = 7 732 000 FCFA
```

```text
7 488 000 / 15 220 000 ≈ 49,20 %
```

La différence entre les mouvements du seul mois d’octobre est :

```text
3 805 000 − 3 286 000 = 519 000 FCFA
```

Cette différence mensuelle n’est pas le solde cumulé restant.
Les règlements d’octobre peuvent concerner des frais constatés
pendant les mois précédents.

### Interprétation des effectifs

Le nombre de 58 ne doit pas être présenté automatiquement comme
le nombre de nouvelles inscriptions.

Il désigne les élèves distincts ayant une constatation de scolarité
dans le mois sélectionné.

Le libellé « Effectif actuel » du rapport correspond ici aux
221 élèves distincts ayant une constatation depuis le début du cycle
jusqu’à fin octobre.

L’effectif cumulé est recalculé sur l’ensemble de la période.
Il n’est pas obtenu en additionnant les effectifs mensuels.

Le rapprochement avec un registre administratif d’inscription
constitue une vérification distincte.

### Interprétation du solde

Le solde restant ne représente pas automatiquement une somme échue
ou un retard de paiement.

L’identification des retards nécessite les échéances applicables
et la vérification des situations individuelles.

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

La notion de période future se rapporte ici à la disponibilité
des écritures, et non à la date réelle d’exécution des tests.

Le dernier mois disponible peut être incomplet.

---

## 8. Vérifications complémentaires restant à consigner

### Contrôles métier et du modèle

- Rapprochement des élèves distincts avec le registre des inscriptions.
- Vérification de l’exhaustivité des exports par rapport à Sage.
- Tests détaillés par classe et niveau.
- Comportement du paramètre de champs pour les quatre indicateurs.
- Vérification des interactions avec la page journalière.
- Comportement des sélections couvrant plusieurs cycles académiques.
- Tri chronologique des axes et tableaux.
- Concordance de la version testée avec la version déployée
  dans Power BI Service, le cas échéant.
- Contrôles applicables à la version de démonstration lorsqu’elle
  diffère de la version métier testée.

### Traçabilité à compléter

- Valeurs Avant et Après du contrôle de conservation.
- Référence du commit correspondant à la campagne de tests.
- Version du rapport utilisée pour les captures publiques.
- Date et références de publication de la galerie.
- Consignation du périmètre et du résultat des vérifications
  de diffusion des fichiers effectivement déposés.

La constitution de la galerie et l’actualisation du README principal
et du dictionnaire sont désormais consignées en section 11.
Elles ne sont plus présentées comme des supports restant à préparer.

Cette progression documentaire ne clôture pas les contrôles métier,
techniques ou de diffusion restant à consigner.

Ces éléments ne sont pas déclarés réalisés uniquement parce que
les tests précédents sont satisfaisants.

---

## 9. Preuves et traçabilité

### Preuves de test

La page de contrôle DAX rassemble des résultats agrégés.
Elle peut servir de preuve de test après vérification de son contenu
avant diffusion.

Pour chaque preuve, conserver :

- la date réelle d’exécution ;
- la nature et la version des données ;
- la version du modèle ;
- la référence des scripts utilisés, si applicable ;
- les filtres appliqués ;
- le résultat et la conclusion ;
- la référence de la capture ou du compte rendu associé.

Les résultats individuels contenant des comptes élèves restent
dans l’environnement interne autorisé.

### Supports de présentation

Les captures de la galerie illustrent le rendu du rapport.

Elles ne démontrent pas à elles seules :

- l’exécution d’un scénario de test ;
- l’exhaustivité des données ;
- le bon fonctionnement de toutes les interactions ;
- l’identité entre la version de présentation et la version testée.

Les lignes synthétiques des dashboards 4 et 5 ne constituent pas
des preuves de contrôle de situations individuelles réelles.

### Fiche pour les prochains tests

```text
Contrôle :
Date réelle d’exécution :
Nature des données : réelles / synthétiques
Version des données :
Version du modèle :
Référence du commit des scripts, si applicable :

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

Toute modification des données, des transformations, des relations
ou des mesures nécessite de réexaminer les contrôles concernés.

La création d’un jeu synthétique pour la démonstration constitue
une adaptation distincte. Elle ne doit pas être confondue avec
une correction des données sources de la campagne métier.

---

## 11. Supports publics et avancement documentaire

Cette section consigne l’avancement communiqué par l’auteur.
Elle ne constitue pas une nouvelle campagne de tests Power Query ou DAX.

### 11.1. État des livrables

| Livrable | État consigné |
|---|---|
| Galerie `images/README.md` | Création et intégration des huit captures confirmées par l’auteur |
| README principal | Actualisation avec la galerie et les résultats documentés confirmée par l’auteur |
| Dictionnaire des données | Actualisation des références aux tests et aux démonstrations synthétiques confirmée par l’auteur |

La confirmation d’intégration des fichiers ne vaut pas audit exhaustif
du contenu du dépôt ni validation de toutes les fonctionnalités
du rapport.

### 11.2. Inventaire de la galerie

La galerie comprend huit captures représentant cinq dashboards.

| Dashboard | Vue présentée | Fichier |
|---|---|---|
| Dashboard 1 | Effectif actuel | [01-overview.png](../images/01-overview.png) |
| Dashboard 1 | Scolarité constatée cumulée | [01-overview-scolarite.png](../images/01-overview-scolarite.png) |
| Dashboard 1 | Règlements cumulés | [01-overview-reglements.png](../images/01-overview-reglements.png) |
| Dashboard 1 | Solde restant | [01-overview-solde.png](../images/01-overview-solde.png) |
| Dashboard 2 | Évolution mensuelle des cumuls | [02-evolution-mensuelle.png](../images/02-evolution-mensuelle.png) |
| Dashboard 3 | Détails et tendances mensuels | [03-details-mensuels.png](../images/03-details-mensuels.png) |
| Dashboard 4 | Situation individuelle — démonstration synthétique | [04-situation-individuelle.png](../images/04-situation-individuelle.png) |
| Dashboard 5 | Suivi journalier — démonstration synthétique | [05-suivi-journalier.png](../images/05-suivi-journalier.png) |

Les quatre captures de Dashboard 1 représentent les quatre choix
du sélecteur « Mesures », et non quatre pages supplémentaires.

[Consulter la galerie commentée](../images/README.md)

### 11.3. Nature des données présentées

La version publique distingue :

- les restitutions agrégées des dashboards 1 à 3 ;
- les lignes individuelles entièrement synthétiques des dashboards 4 et 5.

Le caractère entièrement synthétique des lignes individuelles
a été confirmé par l’auteur. Elles ne reproduisent aucune situation
réelle d’élève et ne résultent pas seulement du remplacement des noms.

Cette qualification concerne la version de démonstration de ces pages.
Elle ne requalifie pas les données sources réelles ni la version
ayant servi à la campagne de tests.

Les conclusions de cette campagne ne sont pas automatiquement
transposées à la version de démonstration.

Les exports Sage réels, les correspondances avec les identités réelles
et le modèle contenant les données détaillées restent hors
du périmètre de publication.

### 11.4. Conventions de lecture documentées

La galerie et le README principal distinguent :

- la situation de référence des cartes au 31 octobre 2025 ;
- les évolutions présentées sur plusieurs mois disponibles ;
- les mouvements mensuels et les cumuls académiques ;
- les effectifs comptables distincts et les inscriptions administratives ;
- le solde restant et les sommes effectivement échues.

Les données postérieures à octobre sont présentées dans une lecture
rétrospective. Elles ne sont pas assimilées à des informations
déjà connues en octobre 2025.

Les cartes de situation mensuelle ne doivent pas être interprétées
comme une situation à la fin du jour sélectionné sur la page journalière.

Ces précisions documentaires facilitent la lecture des captures.
Elles ne constituent pas des tests supplémentaires des interactions.

### 11.5. Références de publication à compléter

| Élément | Référence |
|---|---|
| Version du rapport utilisée pour les captures | À renseigner |
| Date de finalisation de la galerie | À renseigner |
| Commit de référence de la galerie complète | À renseigner |
| Commit de référence du README principal actualisé | À renseigner |
| Commit de référence du dictionnaire actualisé | À renseigner |

Les références doivent être recopiées depuis les fichiers de travail
et l’historique GitHub, sans les déduire de la date des tests métier.

La publication de la galerie est un jalon documentaire.
Elle ne clôture pas les vérifications complémentaires de la section 8.

### 11.6. Jalon — Documentation et galerie harmonisées

| Élément | Référence |
|---|---|
| Date du commit communiquée par l’auteur | 20/10/2026 |
| Commit de référence | [`f49e19f`](https://github.com/YvesBriceAbogo/school-enrollment-fees-analytics/commit/f49e19f32e2bbff95fa392812d6c4120c750ac98) |
| Message du commit | `chore: harmonisation des exclusions et ajout des PDF` |
| Objet du jalon | Repère de l’état du dépôt après intégration de la galerie et harmonisation documentaire |

Le changement enregistré par ce commit concerne les règles d’exclusion,
notamment l’exclusion des PDF par défaut. Il ne correspond pas
à l’ajout de fichiers PDF dans la galerie.

Ce commit sert également de référence à l’ensemble de l’état versionné
du dépôt à cet instant, et pas uniquement au fichier `.gitignore`.

L’intégration des huit captures et les mises à jour documentaires
ont été confirmées par l’auteur au cours de la préparation du projet.

Ce jalon ne constitue ni une nouvelle campagne de tests,
ni une vérification de la concordance avec Power BI Service,
ni un audit exhaustif des fichiers et de l’historique du dépôt.

Il ne remplace pas les références encore manquantes de la campagne
de tests, du modèle utilisé pour les captures ou des publications
initiales des différents supports.

La date du jalon ne doit pas être interprétée comme la date
de création initiale de chaque document ou capture.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Galerie du rapport](../images/README.md)
- [Méthodologie](methodologie.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Plan de contrôle qualité](../quality/README.md)
- [Mesures DAX](../dax/README.md)
- [Confidentialité](confidentialite.md)
- [Déploiement](deploiement.md)
