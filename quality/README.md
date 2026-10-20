# Plan de contrôle qualité des données et du modèle

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce dossier présente les contrôles destinés à vérifier la préparation
des exports Sage, la cohérence du modèle Power BI et l’interprétation
de ses indicateurs.

Ce document définit les règles et les résultats attendus.
L’historique des exécutions, les résultats observés et leurs limites
sont centralisés dans le
[journal de contrôle qualité](../docs/controle-qualite.md).

Les contrôles Power Query et les scénarios DAX déjà exécutés
y sont consignés.

La présence d’un script ou d’une capture dans GitHub ne prouve pas,
à elle seule, son exécution ni la conformité de tous les résultats.

---

## 1. Objectifs

- Vérifier les formats et les types de données.
- Sécuriser les rapprochements entre écritures et référentiels.
- Repérer les rattachements scolaires manquants.
- Prévenir les multiplications de lignes introduites par les jointures.
- Contrôler la conservation des montants sur un périmètre identique.
- Vérifier le comptage distinct et les cumuls académiques.
- Distinguer les anomalies réelles des différences justifiées.
- Conserver une trace des vérifications, corrections et nouveaux tests.

Les contrôles techniques complètent les vérifications comptables.
Ils ne remplacent pas le rapprochement avec Sage ou avec le registre
administratif des inscriptions.

---

## 2. Périmètre comptable

Les indicateurs sont calculés sur les lignes des comptes tiers élèves.

Dans le périmètre confirmé du projet :

- le débit représente la constatation de la scolarité ;
- le crédit représente le règlement pour l’élève.

Les contreparties de produits et de trésorerie sont exclues
par les traitements Power Query.

Les contrôles de conservation doivent donc comparer les lignes
et les montants sur le même périmètre comptable retenu.

Il n’est pas attendu que le total des débits soit égal au total
des crédits après exclusion des contreparties.

La différence entre constatations et règlements contribue au calcul
du solde des comptes élèves, à bornes et filtres identiques.

Le solde restant ne représente pas automatiquement une somme échue.
La qualification d’un retard nécessite les échéances applicables.

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

Elle peut résulter d’une erreur de rattachement, mais aussi
d’une évolution du référentiel ou d’un changement de classe
à documenter.

La classe de l’écriture ne doit pas être écrasée automatiquement
pour imposer une concordance.

Une classe inconnue ne doit pas être affectée arbitrairement
à une catégorie par défaut.

---

## 4. Plan de contrôle des données

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
| Q11 | Définition de l’effectif | Comptage distinct des comptes élèves ayant une constatation, sans assimilation aux lignes comptables |

Les identifiants Q01 à Q11 désignent les règles du plan.
Ils ne correspondent pas nécessairement à onze scripts distincts :
une requête peut contribuer à plusieurs contrôles.

Les contrôles d’unicité Q03 et Q04 sont également intégrés
aux requêtes de préparation documentées des référentiels.

Un échec de ces contrôles ne doit pas être contourné uniquement
pour permettre le chargement du rapport.

La liste des résultats attendus ne signifie pas que chaque règle
a fait l’objet d’un test indépendant déjà consigné.

---

## 5. Contrôle des formats et des dates

### Encodages documentés

| Fichier | Lecture utilisée |
|---|---|
| G.txt | Windows-1252 pour l’export annoncé ANSI |
| T.txt | UTF-8 |
| E.txt | Windows-1252 pour l’export annoncé ANSI |

L’appellation ANSI ne définit pas un encodage universel.
La restitution des accents doit être contrôlée après import.

Le séparateur, l’ordre des champs et l’absence d’en-tête doivent
correspondre aux structures documentées.

### Conversion des dates

La source E.txt présente les dates sous la forme JJMMAA.

Exemples de lecture attendue :

```text
200825 → 20/08/2025
010925 → 01/09/2025
```

Le traitement documenté découpe le texte en groupes de deux caractères,
recompose la date avec des barres obliques et applique une conversion
avec la culture `fr-FR`.

Les vérifications doivent couvrir notamment :

- les dates comportant un zéro initial ;
- les jours supérieurs à 12 ;
- le passage de décembre 2025 à janvier 2026 ;
- l’interprétation des années sur deux chiffres ;
- les valeurs invalides ou incomplètes ;
- la date minimale et la date maximale obtenues.

Le mois d’octobre est une situation de référence du rapport.
Il ne doit pas servir à supprimer les autres mois disponibles.

Une date présente dans le calendrier ne démontre pas l’existence
d’une opération comptable à cette date.

---

## 6. Contrôle des jointures et de la conservation

### Périmètre de comparaison

La comparaison porte sur :

1. les écritures retenues après sélection du périmètre scolaire,
   avant enrichissement ;
2. les mêmes écritures après enrichissement par jointure.

Elle ne doit pas comparer directement la table analytique
à l’intégralité de E.txt si celui-ci contient les contreparties exclues.

### Indicateurs à relever avant et après

| Indicateur | Écart attendu : Après − Avant |
|---|---:|
| Nombre total de lignes | 0 |
| Nombre de lignes au débit | 0 |
| Nombre de lignes au crédit | 0 |
| Total des montants au débit | 0 |
| Total des montants au crédit | 0 |

Les valeurs détaillées Avant et Après doivent être conservées
avec les résultats du contrôle.

Elles ne doivent pas être reconstituées à partir des cartes
du rapport, dont le contexte peut être différent.

### Points complémentaires

Vérifier également :

- l’unicité des clés du référentiel avant développement de la jointure ;
- les comptes non rapprochés ;
- les niveaux scolaires manquants ;
- les différences de classe à expliquer.

Une jointure gauche conserve les écritures sans correspondance.
Elle peut toutefois multiplier les lignes lorsque la clé
du référentiel n’est pas unique.

La conservation des totaux ne démontre pas, à elle seule,
l’exactitude de chaque affectation.

### Écritures similaires

Deux lignes identiques en apparence peuvent correspondre
à deux opérations distinctes.

L’export documenté ne comporte pas d’identifiant unique de mouvement.

Aucune suppression automatique ne doit être réalisée sans justification
permettant de démontrer le doublon.

---

## 7. Requêtes Power Query et interprétation des résultats

Quatre requêtes de contrôle sont documentées.

| Requête | Forme du résultat | Conclusion consignée |
|---|---|---|
| CONTROLE_NiveauxManquants | Lignes à examiner | Exécutée ; aucune anomalie signalée |
| CONTROLE_CoherenceClasses | Lignes à examiner | Exécutée ; aucune anomalie signalée |
| CONTROLE_ValiditeEcritures | Lignes à examiner | Exécutée ; aucune anomalie signalée |
| CONTROLE_ConservationJointure | Cinq lignes de synthèse | Écarts nuls confirmés sur le périmètre testé |

Ces conclusions reposent sur les confirmations de l’auteur
reprises dans le journal.

### Requêtes retournant les anomalies

Les trois premières requêtes doivent être vides lorsqu’aucune anomalie
n’est détectée selon leurs règles.

Une ligne retournée représente un élément à examiner.

Exemples :

- un Niveau+ vide peut signaler un compte tiers non rapproché ;
- une différence de classe peut nécessiter une vérification du référentiel ;
- un sens invalide peut provenir d’une valeur source inattendue ;
- une erreur de date peut provenir du format ou de son interprétation.

Un résultat vide ne constitue pas une validation globale du projet.

### Requête de conservation

`CONTROLE_ConservationJointure` retourne cinq lignes de synthèse,
même lorsque tout est conforme.

La conformité s’apprécie sur les valeurs comparées et leurs écarts,
et non sur l’absence de lignes.

Un résultat vide ou une erreur d’exécution ne doit pas être assimilé
à un contrôle de conservation réussi.

Les écarts nuls ont été confirmés par l’auteur.
Les valeurs détaillées Avant et Après restent à compléter
dans le journal.

### Valeurs à distinguer

Les champs numériques vides, les zéros et les erreurs de conversion
ne sont pas équivalents.

Une erreur technique empêchant l’exécution d’un contrôle
ne signifie pas qu’aucune anomalie métier n’existe.

---

## 8. Contrôles DAX et scénarios consignés

Les contrôles DAX vérifient les indicateurs dans un contexte
de dates et de filtres défini.

Ils sont distincts des contrôles de préparation Power Query.

### Campagne de référence

| Élément | Information consignée |
|---|---|
| Date réelle d’exécution | 19/10/2026 |
| Version ou date d’extraction des fichiers | 07/10/2026 |
| Version du modèle testé | suivi-scolarite-tests |
| Situation principale contrôlée | Arrêté au 31 octobre 2025 |
| Référence du commit correspondant | À renseigner dans le journal |

### Scénarios exécutés

| ID | Scénario | Résultat consigné |
|---|---|---|
| DAX-01 | Situation d’octobre 2025 | Montants mensuels et cumulés conformes aux repères sur la version testée |
| DAX-02 | Comptage distinct | 58 élèves sur octobre ; 221 en cumul à fin octobre |
| DAX-03 | Passage décembre-janvier | Conservation des mouvements antérieurs dans les cumuls |
| DAX-04 | Situation de février 2026 | Cumuls et solde conformes aux repères testés |
| DAX-05 | Mai 2026, au-delà du dernier mois d’écritures | Mesures cumulées vides selon la règle de disponibilité |
| DAX-06 | Filtre de section | Réaction des résultats confirmée par l’auteur |

Les montants détaillés et les rapprochements figurent dans le
[journal de contrôle qualité](../docs/controle-qualite.md).

Aucun écart ni message d’erreur n’a été signalé par l’auteur
pour ces scénarios.

### Règles d’interprétation

- L’effectif porte sur les comptes élèves distincts ayant une constatation.
- Les effectifs mensuels ne s’additionnent pas pour former le cumul.
- Les mouvements mensuels sont distincts des situations cumulées.
- Les cumuls commencent au 1er août et ne recommencent pas en janvier.
- Le taux de recouvrement utilise les mêmes bornes et filtres
  au numérateur et au dénominateur.
- Un mois au-delà des écritures disponibles peut produire une valeur vide,
  sans signifier un effectif nul ou un solde intégralement réglé.
- Les cartes arrêtées en fin de mois ne représentent pas une situation
  à la fin de la journée sélectionnée.

### Vérifications complémentaires

Les scénarios consignés ne couvrent pas automatiquement :

- tous les filtres de classe et de niveau ;
- le comportement complet du paramètre de champs ;
- les interactions de la page journalière ;
- les mois sans mouvement à l’intérieur de la période disponible ;
- les sélections couvrant plusieurs cycles académiques ;
- le tri chronologique des axes et tableaux ;
- l’ensemble des contextes de total ;
- la concordance avec la version publiée dans Power BI Service.

Le rapprochement des effectifs avec le registre administratif
et la vérification de l’exhaustivité des exports par rapport à Sage
restent des contrôles métier distincts.

Les résultats attendus doivent correspondre aux données et aux filtres
du test. Ils ne doivent pas être imposés artificiellement
à une nouvelle version.

---

## 9. Procédure de traitement des anomalies

Pour chaque anomalie :

1. Identifier les lignes et le périmètre concernés dans l’environnement interne.
2. Examiner la source et les règles de transformation.
3. Déterminer la cause.
4. Documenter la justification ou la correction proposée.
5. Faire valider la correction selon les responsabilités applicables.
6. Corriger la source, le référentiel ou le traitement approprié.
7. Actualiser les données.
8. Réexécuter le contrôle concerné et les tests affectés.
9. Consigner la nouvelle conclusion.

Les données ne doivent pas être modifiées uniquement pour retrouver
un ancien total ou obtenir un tableau d’anomalies vide.

Une différence expliquée doit conserver sa justification.
Elle ne doit pas disparaître de la traçabilité sans explication.

La création d’un jeu synthétique de démonstration est une démarche
distincte : elle ne constitue pas une correction des sources métier.

---

## 10. Exécution des contrôles

GitHub conserve le code, mais ne l’exécute pas.

Une mise à jour de ce document ne lance aucun contrôle
et ne modifie pas le modèle Power BI.

### Power Query dans Power BI Desktop

Pour installer ou réexécuter un contrôle dans une copie autorisée
du modèle :

1. Ouvrir « Transformer les données ».
2. Vérifier les paramètres de source et les requêtes métier.
3. Utiliser la requête de contrôle existante lorsqu’elle est déjà présente.
4. Si elle n’existe pas, créer une requête vide, lui attribuer le nom prévu
   et insérer le code dans l’« Éditeur avancé ».
5. Actualiser le résultat du contrôle.
6. Examiner les lignes ou la synthèse selon le type de requête.
7. Consigner le résultat, le périmètre et la version utilisée.

Ne pas conclure uniquement à partir d’un aperçu ancien
ou des seules lignes visibles à l’écran.

Les éléments de preuve doivent correspondre au périmètre effectivement
évalué par le contrôle.

### DAX dans Power BI Desktop

Pour rejouer un scénario :

1. Utiliser une version identifiée du modèle et des données.
2. Vérifier les mesures à tester.
3. Appliquer les filtres prévus par le scénario.
4. Relever les résultats mensuels et cumulés concernés.
5. Comparer les résultats aux attentes justifiées.
6. Consigner la conclusion et la preuve associée.

Une capture de présentation ne remplace pas ce protocole.

### Actualisation et Power BI Service

Une requête dont le chargement est désactivé et qui n’est utilisée
par aucune autre requête ne doit pas être considérée comme
automatiquement exécutée à chaque actualisation du modèle.

Un tableau retournant des anomalies n’interrompt pas automatiquement
le chargement : cela dépend de la logique du traitement
et du dispositif de suivi mis en place.

Pour une surveillance dans Power BI Service, définir explicitement :

- les contrôles exécutés ;
- leur mode d’exécution ;
- leur restitution ;
- les conditions d’alerte ou de blocage ;
- le responsable du suivi.

La publication du rapport et la configuration de la passerelle
ont été confirmées par l’auteur.

La correspondance entre la version testée et celle du Service,
ainsi que les contrôles après publication, restent à documenter
selon le [suivi du déploiement](../docs/deploiement.md).

Une actualisation réussie ne démontre pas à elle seule
la qualité métier ou la fraîcheur des exports chargés.

---

## 11. Traçabilité

Pour chaque test, conserver :

| Information | Contenu attendu |
|---|---|
| Identifiant du contrôle | Règle Q01 à Q11, scénario DAX ou nom de requête concerné |
| Date d’exécution | Date réelle du test |
| Nature des données | Réelles ou synthétiques |
| Version des données | Fichiers, date d’extraction ou référence du jeu d’exemple |
| Version du modèle | Référence de la version effectivement testée |
| Référence du code | Commit ou version des scripts, si applicable |
| Périmètre | Comptes, dates et filtres |
| Résultat attendu | Règle et valeurs attendues justifiées |
| Résultat observé | Comptage, montant, lignes retournées ou constat |
| Conclusion | Conforme, à examiner, non conforme ou contrôle non exécuté |
| Action et nouveau test | Correction, justification et résultat après intervention |
| Preuve | Référence du résultat ou de la capture de contrôle |

Ne pas inscrire « Conforme » simplement parce que le script
a été créé ou déposé dans GitHub.

Les résultats et les informations encore manquantes restent centralisés
dans le [journal de contrôle qualité](../docs/controle-qualite.md).

Les valeurs Avant et Après du contrôle de conservation et la référence
du commit de la campagne doivent notamment être complétées
à partir des éléments réels.

Les références du modèle testé doivent être distinguées
des commits de publication de la galerie.

---

## 12. Confidentialité et supports publics

Les contrôles peuvent faire apparaître des comptes élèves
ou d’autres informations individuelles.

Leurs résultats détaillés restent dans l’environnement interne autorisé.

Le dépôt public peut présenter :

- les scripts de contrôle préparés pour diffusion ;
- les règles appliquées ;
- des conclusions et résultats agrégés autorisés ;
- des exemples synthétiques clairement identifiés.

Les identités réelles, comptes tiers identifiants, situations financières
individuelles réelles et correspondances d’identité ne sont pas publiés.

### Galerie et preuves de test

La galerie comprend huit captures couvrant les cinq dashboards.

Les dashboards 1 à 3 présentent des restitutions agrégées.
Les lignes individuelles des dashboards 4 et 5 sont entièrement
synthétiques, selon la confirmation de l’auteur.

La galerie illustre le rendu et les usages du rapport.

Elle ne démontre pas à elle seule :

- l’exécution des contrôles ;
- la validité de toutes les interactions ;
- l’exhaustivité des exports ;
- la concordance entre les versions testées et publiées.

Les quatre variantes de Dashboard 1 ne constituent pas,
à elles seules, un test complet du paramètre de champs.

Les conclusions de la campagne sur les sources métier
ne sont pas automatiquement transposées à une version synthétique.

La préparation et la vérification des supports de diffusion
sont suivies séparément dans le journal et dans la
[documentation de confidentialité](../docs/confidentialite.md).

---

## Documentation associée

- [Présentation générale du projet](../README.md)
- [Galerie du rapport](../images/README.md)
- [Méthodologie](../docs/methodologie.md)
- [Dictionnaire des données](../docs/dictionnaire-donnees.md)
- [Journal de contrôle qualité](../docs/controle-qualite.md)
- [Préparation des exports Sage](../powerquery/README.md)
- [Paramètres d’importation](../powerquery/parameters.example.md)
- [Mesures DAX](../dax/README.md)
- [Données sources et conditions de diffusion](../data/README.md)
- [Confidentialité](../docs/confidentialite.md)
- [Déploiement](../docs/deploiement.md)
