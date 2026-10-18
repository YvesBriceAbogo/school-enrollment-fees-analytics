# Déploiement et actualisation du rapport

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Le rapport est déjà publié dans Power BI Service.
Une passerelle de données locale en mode standard a été configurée
par l’auteur pour l’accès aux sources locales.

Ce document décrit le déploiement existant, son fonctionnement
et les opérations nécessaires à sa maintenance.

Les informations propres à la configuration, comme les horaires
d’actualisation et les références de version, sont à compléter
à partir des paramètres réellement utilisés.

---

## 1. État du déploiement

| Élément | Situation |
|---|---|
| Rapport Power BI | Déjà publié dans Power BI Service |
| Modèle sémantique | Publié avec le rapport |
| Passerelle | Mode standard, déjà configurée |
| Sources documentées | Exports TXT locaux de Sage Saari version 15 |
| Contrôles Power Query | Exécutés par l’auteur sur la version testée |
| Mesures DAX révisées du dépôt | Intégration et validation dans la version publiée à consigner |
| Actualisation planifiée | Paramètres effectifs à documenter |
| Dernière actualisation réussie | À renseigner depuis l’historique du Service |
| Publication publique anonyme | « Publish to web » non activé dans l’environnement documenté |
| Partage | Accès contrôlé, selon les autorisations et licences |

La configuration de la passerelle et la publication du rapport
sont des étapes réalisées.

Une actualisation réussie doit néanmoins être attestée séparément
par l’historique du modèle sémantique.

Les réglages non renseignés dans ce document ne doivent pas être
interprétés comme absents de l’environnement.

---

## 2. Architecture en place

### Préparation et publication

```text
Sage Saari version 15
        ↓ Export
G.txt, T.txt et E.txt
        ↓
Power BI Desktop
Power Query → Modèle → DAX → Rapport
        ↓ Publication
Modèle sémantique et rapport dans Power BI Service
```

### Actualisation dans le Service

```text
Power BI Service
        ↓ Demande d’actualisation
Passerelle standard
        ↓ Lecture
Exports TXT accessibles sur l’environnement local
        ↓ Transfert et traitement
Modèle sémantique actualisé
        ↓
Rapport utilisant les dernières données chargées
```

La passerelle assure l’accès aux fichiers.
Elle ne génère pas les exports Sage et ne lance pas automatiquement
l’application comptable.

GitHub conserve le code et la documentation.
Il ne déclenche pas automatiquement les traitements Power BI.

---

## 3. Sources et paramètres

### Fichiers utilisés

| Fichier | Contenu |
|---|---|
| G.txt | Référentiel des comptes généraux |
| T.txt | Référentiel des comptes tiers élèves |
| E.txt | Écritures comptables |

Le paramètre `pDossierSource` centralise l’emplacement des fichiers
dans les scripts documentés.

Exemple non sensible :

```text
C:\PowerBI\school-fees\data
```

Le chemin réel reste configuré dans l’environnement de l’auteur.

### Formats documentés

| Fichier | Lecture prévue |
|---|---|
| G.txt | Virgule ; Windows-1252 pour l’export annoncé ANSI |
| T.txt | Virgule ; UTF-8 |
| E.txt | Virgule ; Windows-1252 ; date source JJMMAA |

Une évolution du format d’export nécessite une vérification
des transformations avant actualisation du modèle publié.

### Préparation des nouveaux exports

Avant une actualisation :

1. Produire les exports nécessaires depuis Sage.
2. Vérifier la cohérence des référentiels et des écritures.
3. Terminer l’enregistrement des trois fichiers.
4. Vérifier leur emplacement et leur nom.
5. Éviter leur modification pendant la lecture par Power BI.

Les scripts lisent des fichiers précis.
Ils ne combinent pas automatiquement plusieurs extractions successives.

Ne pas concaténer des exports couvrant les mêmes opérations sans règle
explicite, au risque de dupliquer les écritures.

---

## 4. Connexions de passerelle

### Configuration existante

La passerelle standard est déjà configurée.
Il n’est pas nécessaire de la recréer pour documenter le projet.

Les requêtes utilisent `File.Contents` pour lire les trois fichiers.

Le paramètre commun de dossier ne transforme pas ces sources
en un connecteur unique de type Dossier.

Les connexions doivent correspondre aux sources détectées :

| Source | Type de connexion attendu |
|---|---|
| Chemin complet de G.txt | Fichier |
| Chemin complet de T.txt | Fichier |
| Chemin complet de E.txt | Fichier |

Les trois connexions peuvent utiliser la même passerelle.

### Vérification de la configuration

Dans Power BI Service :

```text
Paramètres
→ Gérer les connexions et les passerelles
```

Vérifier au besoin :

- l’état de la passerelle ;
- les connexions de fichiers ;
- les chemins configurés ;
- les autorisations de lecture ;
- les droits d’utilisation des connexions.

Dans les paramètres du modèle sémantique :

```text
Connexions de passerelle et connexions cloud
```

Vérifier l’association des sources aux connexions correspondantes.

La présente documentation ne contient aucun identifiant Windows,
mot de passe ni clé de récupération.

### Disponibilité locale

Un chemin commençant par C:\ désigne le disque de la machine
hébergeant la passerelle.

Un fichier lu depuis un dossier OneDrive synchronisé par un chemin
local reste une source locale dans cette configuration.

Il doit être effectivement disponible pour le processus de lecture,
et pas uniquement représenté par un fichier à télécharger à la demande.

---

## 5. Actualisation des données

### Actualisation manuelle

Pour vérifier ou mettre à jour le modèle :

1. Confirmer que les exports Sage ont été enregistrés.
2. Ouvrir le modèle sémantique dans Power BI Service.
3. Sélectionner « Actualiser maintenant ».
4. Consulter l’historique des actualisations.
5. Vérifier le résultat.
6. Examiner les indicateurs attendus dans le rapport.

La vérification doit porter sur le modèle de ce projet,
et non uniquement sur la disponibilité générale de la passerelle.

### Actualisation planifiée

Les réglages effectifs sont à consigner dans la fiche de déploiement :

- fréquence ;
- horaires ;
- fuseau horaire ;
- notifications d’échec.

Pour un environnement situé au Cameroun, le fuseau horaire est UTC+01:00.

Les horaires doivent être compatibles avec :

- la production des exports ;
- la disponibilité du laptop ;
- l’accès aux fichiers ;
- les limites applicables à la licence et à la capacité.

Si la planification fonctionne déjà, il n’est pas nécessaire
de la modifier pour correspondre à un exemple de documentation.

### Limite importante

Une actualisation Power BI réussie peut charger des données inchangées
si les exports Sage n’ont pas été renouvelés.

La date d’extraction des sources doit donc être distinguée
de la date d’actualisation du modèle.

---

## 6. Conditions de fonctionnement

Pour actualiser les sources locales :

- la machine de la passerelle doit être allumée ;
- elle doit disposer d’un accès Internet ;
- elle ne doit pas être en veille ou en veille prolongée ;
- le service de passerelle doit fonctionner ;
- les fichiers doivent rester accessibles ;
- les identifiants configurés doivent être valides.

La passerelle standard fonctionne comme un service Windows.
Power BI Desktop n’a pas besoin de rester ouvert.

Une session interactive n’est normalement pas nécessaire au service.
Les dépendances éventuelles à une synchronisation de fichiers
ou à un accès réseau doivent toutefois être vérifiées.

Lorsque le laptop est éteint, les sources locales ne peuvent pas être
actualisées par cette passerelle.

Un rapport en mode Import peut rester consultable dans le Service
avec les dernières données chargées, sous réserve des autorisations
et de la disponibilité du service.

---

## 7. Gestion des versions

La version publiée et les scripts présents dans GitHub doivent
être rapprochés explicitement.

Un script révisé enregistré dans GitHub ne remplace pas automatiquement
la formule ou la requête du modèle déjà publié.

### Procédure de mise à jour fonctionnelle

1. Conserver une copie de la version de travail.
2. Intégrer les modifications dans Power BI Desktop.
3. Exécuter les contrôles.
4. Tester les mesures et les interactions.
5. Documenter les écarts éventuels.
6. Publier la version validée.
7. Vérifier les connexions et l’actualisation après publication.
8. Mettre à jour le PDF et les captures.
9. Enregistrer la référence du commit associé.

### Nature des modifications

| Modification | Action attendue |
|---|---|
| Nouvelles données, même structure | Renouveler les exports puis actualiser |
| Nouveau format TXT | Adapter et tester les requêtes |
| Changement de chemin | Vérifier les paramètres et les connexions |
| Modification DAX, relations ou visuels dans Desktop | Tester puis republier |
| Modification du référentiel scolaire | Vérifier les classifications et les effets historiques |
| Modification d’un fichier GitHub | Intégrer explicitement le changement dans Power BI si nécessaire |

Les captures et PDF sont statiques.
Ils ne se mettent pas automatiquement à jour avec le modèle sémantique.

---

## 8. Dates et lecture du rapport

Le projet distingue :

- la date d’extraction Sage ;
- la dernière date d’écriture disponible ;
- la date d’actualisation Power BI ;
- le mois sélectionné pour l’analyse.

Ces dates ne sont pas nécessairement identiques.

Le calendrier couvre des cycles académiques complets.
Il peut contenir des dates sans opérations.

Les mesures cumulatives révisées prévoient :

- une seule année académique dans le contexte ;
- un cumul depuis le 1er août ;
- un arrêté à la fin du mois sélectionné ;
- une valeur vide pour un mois postérieur au dernier mois d’écriture.

Une carte vide peut donc provenir du contexte de sélection,
et pas nécessairement d’un échec d’actualisation.

Ces comportements doivent être vérifiés dans la version publiée
après intégration des mesures révisées.

La dernière date disponible ne garantit pas que le dernier mois
soit complet.

---

## 9. Partage et confidentialité

### Rapport opérationnel

Le rapport contenant les données réelles doit être utilisé dans
un environnement autorisé, avec des accès adaptés.

La publication dans Power BI Service n’équivaut pas à une publication
anonyme sur Internet.

### Fonctionnalités de partage

La fonctionnalité « Publish to web » n’est pas activée dans
l’environnement actuellement documenté.

Un partage via « Share » dépend des autorisations et des licences.
La présence d’un lien ne garantit pas l’accès du destinataire.

Le rapport nominatif ne doit pas être rendu public.

### Portfolio GitHub

La présentation publique repose sur :

- les scripts ;
- la documentation ;
- les captures autorisées ;
- le PDF préparé pour diffusion ;
- éventuellement des données fictives compatibles.

Un fichier PBIX en mode Import peut contenir les données réelles,
y compris les colonnes masquées dans les visuels.

Un PBIT ne contient pas les données importées, mais ses requêtes,
paramètres et valeurs inscrites dans les définitions doivent
également être vérifiés.

---

## 10. Suivi des incidents

| Symptôme | Vérifications prioritaires |
|---|---|
| Passerelle hors connexion | Machine, réseau, veille et service |
| Fichier introuvable | Chemin, nom et disponibilité locale |
| Accès refusé | Identifiants et autorisations |
| Accents incorrects | Encodage de l’export |
| Erreur de date | Format source et conversion |
| Erreur de montant | Valeur et format du champ source |
| Niveau manquant | Correspondance du compte tiers et classification |
| Lignes multipliées | Unicité des référentiels et jointures |
| Carte cumulative vide | Cycle, mois sélectionné et période disponible |
| Actualisation réussie mais données anciennes | Date et contenu des exports Sage |

Les contrôles ne doivent pas être désactivés uniquement pour faire
réussir une actualisation.

La cause et la correction doivent être documentées.

---

## 11. Fiche du déploiement existant

| Élément | Situation ou information à compléter |
|---|---|
| Publication Power BI Service | Réalisée, confirmée par l’auteur |
| Passerelle standard | Configurée, confirmée par l’auteur |
| Date de publication | À renseigner |
| Version du modèle actuellement publié | À renseigner |
| Référence du commit correspondant | À renseigner |
| Espace de travail | À renseigner sans information sensible |
| Nom du modèle sémantique | À renseigner |
| Source | Exports locaux G.txt, T.txt et E.txt |
| Dernière extraction Sage utilisée | À renseigner |
| Fréquence d’actualisation | À renseigner |
| Horaires et fuseau horaire | À renseigner |
| Dernière actualisation réussie | À renseigner depuis l’historique |
| Résultat des tests DAX révisés | À consigner |
| Accès au rapport | Contrôlé ; modalités à documenter |

Les informations non renseignées ne doivent pas être inventées.

Ne pas inscrire de mot de passe, clé de récupération, cookie,
jeton ou chaîne de connexion sensible dans cette fiche.

---

## 12. État des vérifications

Les éléments cochés ci-dessous reposent sur les confirmations de l’auteur.

- [x] Rapport publié dans Power BI Service.
- [x] Passerelle standard configurée.
- [x] Contrôles Power Query exécutés sur la version testée.
- [ ] Référence exacte de la version publiée consignée.
- [ ] Correspondance entre le code GitHub et le modèle publié vérifiée.
- [ ] Mesures DAX révisées testées et résultats consignés.
- [ ] Dernière actualisation réussie documentée.
- [ ] Paramètres de planification consignés, si une planification est utilisée.
- [ ] Version publique des captures et du PDF vérifiée.
- [ ] Liens et accès des destinataires testés.

Une case non cochée indique qu’une vérification ou sa documentation
reste à compléter. Elle ne prouve pas que la fonctionnalité est absente.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Méthodologie](methodologie.md)
- [Dictionnaire des données](dictionnaire-donnees.md)
- [Journal de contrôle qualité](controle-qualite.md)
- [Confidentialité](confidentialite.md)
- [Paramètres Power Query](../powerquery/parameters.example.md)
- [Documentation DAX](../dax/README.md)
- [Données et conditions de diffusion](../data/README.md)
