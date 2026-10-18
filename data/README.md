# Données sources et conditions de diffusion

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur du projet : Brice Abogo**

Ce document présente la provenance des données, leur signification
comptable et les conditions retenues pour leur utilisation dans le portfolio.

Les données sources sont réelles. La présentation du projet est autorisée.

La version publique ne doit toutefois pas exposer les identités des élèves
ni leurs situations financières nominatives.

Aucun fichier source réel n’est ajouté dans le cadre de cette étape
de documentation.

---

## 1. Identification du jeu de données

| Élément | Description |
|---|---|
| Origine | Comptabilité de la scolarité d’un établissement scolaire |
| Application source | Sage Saari version 15 |
| Mode d’extraction | Exports réalisés à l’aide des fichiers d’export de l’application |
| Format des sources | Fichiers texte TXT |
| Nature des données | Réelles |
| Année académique étudiée | 2025/2026 |
| Période disponible | Août 2025 à avril 2026 |
| Situation de référence illustrée | Arrêté au 31 octobre 2025 |
| Début retenu pour les cumuls académiques | 1er août |
| Devise | FCFA |
| Publication du projet | Autorisée selon les informations communiquées par l’auteur |
| Identification de l’établissement | Non publiée dans la version destinée au portfolio |

La situation d’octobre constitue un exemple d’analyse.
Le rapport doit permettre de sélectionner d’autres mois sans modifier
manuellement les formules.

La période disponible ne doit pas être assimilée à une année scolaire
complète.

---

## 2. Fichiers sources

| Fichier | Contenu | Usage |
|---|---|---|
| E.txt | Écritures comptables | Analyse des constatations de scolarité et des règlements |
| T.txt | Comptes tiers | Identification des comptes élèves et rattachement comptable |
| G.txt | Comptes généraux | Référentiel des regroupements comptables |

Ces noms correspondent aux exports utilisés dans les requêtes fournies.

Les fichiers réels restent dans un emplacement local autorisé.
Leur présence dans le dépôt GitHub n’est pas nécessaire pour présenter
les scripts et la démarche analytique.

### Caractéristiques techniques

Les requêtes initiales lisent les fichiers avec `Csv.Document`
et utilisent la virgule comme séparateur.

Les éléments suivants seront précisés lors de la documentation
technique des imports :

- encodage ;
- structure et ordre des colonnes ;
- format exact des dates ;
- présence éventuelle d’en-têtes ou de lignes de fin ;
- format des montants.

Ces caractéristiques doivent être vérifiées avant de figer
les paramètres d’importation.

---

## 3. Signification comptable

La comptabilité exploitée est exclusivement consacrée à la scolarité.

Un compte tiers correspond à un seul élève.

| Mouvement sur le compte tiers élève | Signification |
|---|---|
| Débit — D | Constatation des frais de scolarité lors de l’inscription |
| Crédit — C | Règlement effectué pour l’élève |

Les écritures de constatation comportent une contrepartie de produit.
Les écritures de règlement comportent une contrepartie de trésorerie.

### Sélection du périmètre analytique

Les retraitements Power Query sélectionnent les lignes relatives
aux comptes de tiers et écartent notamment les contreparties
de produits et de trésorerie.

Dans le périmètre confirmé du projet, cette sélection permet
d’analyser les mouvements des comptes élèves sans additionner
leurs contreparties aux indicateurs de scolarité et de règlement.

### Regroupements comptables

Les comptes généraux sont associés aux comptes tiers lors de la saisie.

Ils constituent des regroupements dont la signification peut correspondre
à une classe, un niveau ou une section.

Leur correspondance avec la hiérarchie scolaire doit être documentée,
sans déduire une classe précise d’un regroupement qui ne la renseigne pas.

---

## 4. Tables utilisées dans Power BI

| Table | Fonction |
|---|---|
| Ecritures | Mouvements comptables retenus après préparation |
| Comptes T | Référentiel des comptes élèves et attributs associés |
| Comptes G | Référentiel des regroupements comptables |
| Calendrier | Dimension temporelle |
| Mesures | Paramètre de champs pour sélectionner l’indicateur affiché |

Les tables Calendrier et Mesures sont des objets du modèle Power BI.
Elles ne correspondent pas à des exports comptables distincts.

Les jointures doivent préserver le nombre et le montant des écritures,
sauf transformation explicitement justifiée.

L’unicité des clés des référentiels doit être contrôlée avant
leur utilisation dans les rapprochements.

---

## 5. Périodes d’analyse

### Situation mensuelle

La situation de référence présentée correspond au 31 octobre 2025.

Les indicateurs cumulés portent sur la période :

```text
Du 1er août 2025 au 31 octobre 2025
```

### Fonctionnement dynamique

Le rapport doit permettre de sélectionner un autre mois.

Par exemple, pour février 2026 :

```text
Du 1er août 2025 au 28 février 2026
```

Le cumul ne recommence pas à zéro en janvier.
Il suit le cycle académique retenu.

### Analyse rétrospective

Les données disponibles jusqu’en avril 2026 permettent d’examiner
l’évolution ultérieure de la scolarité et des règlements.

Ces informations ne doivent pas être présentées comme une prévision
ou comme des résultats déjà connus à l’arrêté d’octobre 2025.

### Données futures

La présence de dates futures dans un calendrier ne signifie pas
que des opérations existent ou que le mois concerné est complet.

La dernière date disponible et la date d’extraction doivent être
prises en compte dans l’interprétation.

---

## 6. Définition des effectifs

L’indicateur comptable d’effectif repose sur le nombre distinct
de comptes élèves ayant une constatation de scolarité dans la période.

Il ne doit pas être calculé par simple addition des lignes au débit
si un élève peut apparaître dans plusieurs écritures.

Les effectifs distincts de chaque mois ne doivent pas non plus être
additionnés mécaniquement pour obtenir le cumul académique.

Le comptage doit être recalculé sur l’ensemble de la période retenue.

Cet indicateur ne constitue pas une mesure de présence quotidienne
des élèves.

---

## 7. Confidentialité

La présentation du projet est autorisée.

Cette autorisation est distinguée des conditions de redistribution
des exports individuels et des modèles contenant les données réelles.

La version publique privilégie :

- les analyses agrégées ;
- le code ;
- la documentation ;
- les captures et PDF vérifiés ;
- des exemples fictifs pour les vues individuelles, si nécessaires.

### Informations à ne pas publier dans les données réelles

- Noms et identités des élèves.
- Identifiants permettant de retrouver directement une personne.
- Coordonnées des familles.
- Situations financières nominatives.
- Informations de connexion ou secrets techniques.

Les comptes tiers peuvent eux-mêmes contenir des éléments identifiants.
Ils doivent donc être examinés avant toute diffusion.

### Masquage visuel

Masquer une colonne dans Power BI ne retire pas les données du modèle.

Un rectangle ajouté à un visuel ou à un PDF ne garantit pas que
l’information sous-jacente soit supprimée.

Les supports publics doivent être produits à partir d’une version
préparée pour la diffusion, puis contrôlés.

### Fichiers Power BI

Un fichier PBIX en mode Import peut contenir les données détaillées.

Un fichier PBIT ne contient pas les données importées, mais ses requêtes,
paramètres et chemins doivent également être examinés avant publication.

---

## 8. Données de démonstration éventuelles

Un jeu fictif pourra être préparé pour faciliter la reproduction
des fonctionnalités sans exposer les comptes réels.

Il devra :

- reproduire une structure compatible avec les scripts ;
- utiliser des identifiants et des identités fictifs ;
- conserver la cohérence entre les fichiers ;
- couvrir des cas utiles, notamment les règlements partiels ;
- être explicitement présenté comme fictif.

Les résultats obtenus avec ce jeu pourront différer de ceux du rapport
fondé sur les données réelles.

Ils ne doivent pas être ajustés arbitrairement pour reproduire
les anciens totaux.

---

## 9. Reproductibilité

Pour reproduire une analyse, il faut disposer :

- d’un jeu de données compatible ;
- du format d’export documenté ;
- des paramètres de source ;
- des transformations Power Query ;
- des relations du modèle ;
- des mesures DAX ;
- de la même période et des mêmes filtres ;
- des règles de regroupement scolaire.

Tant qu’aucun jeu compatible diffusable n’est fourni, le dépôt permet
d’examiner le code et la méthode, mais pas de reproduire intégralement
les résultats du rapport réel.

Une capture ou un PDF ne remplace pas les données sources.

---

## 10. Règles de stockage dans le dépôt

Le fichier `.gitignore` exclut par défaut notamment :

- les exports TXT ;
- les fichiers CSV et Excel ;
- les fichiers PBIX et PBIT ;
- les archives ;
- certains fichiers de configuration locale.

Ces règles ne retirent pas les fichiers déjà enregistrés et ne bloquent
pas toutes les méthodes d’ajout.

Les exports réels doivent être conservés hors du dépôt destiné
à devenir public.

Une éventuelle exception pour des données fictives sera ajoutée
uniquement après leur préparation et leur validation.

Les conditions de réutilisation des données seront documentées
séparément de celles du code.

---

## 11. Vérifications avant publication d’une ressource

- [ ] Ressource autorisée à être diffusée publiquement.
- [ ] Absence d’identité réelle d’élève.
- [ ] Absence de compte tiers directement identifiant.
- [ ] Absence de donnée financière nominative.
- [ ] Absence de mot de passe ou de paramètre sensible.
- [ ] Version réelle ou fictive clairement précisée.
- [ ] Période et devise indiquées.
- [ ] Cohérence avec les scripts et le rapport documentés.
- [ ] Métadonnées et contenus masqués vérifiés, si applicables.

Les cases doivent être cochées après vérification effective.

---

## Documentation associée

- [Présentation générale du projet](../README.md)
- [Règles d’exclusion Git](../.gitignore)
