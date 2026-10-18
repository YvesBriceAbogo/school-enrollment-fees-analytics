# Journal de contrôle qualité

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

Ce document consigne les vérifications réalisées sur la préparation
des données et organise leur suivi.

Les résultats ci-dessous reposent sur les tests exécutés par l’auteur
dans son modèle Power BI.

Ils concernent la version et le périmètre testés. Ils ne constituent
pas une validation automatique de toutes les données sources
ni de tous les indicateurs du rapport.

---

## 1. Périmètre des contrôles

Les traitements portent sur les exports Sage Saari suivants :

- G.txt : comptes généraux ;
- T.txt : comptes tiers élèves ;
- E.txt : écritures comptables.

Le périmètre analytique conserve les mouvements des comptes tiers élèves
et exclut les contreparties de produits et de trésorerie.

Dans ce périmètre :

- D représente la constatation de la scolarité ;
- C représente le règlement pour l’élève.

La classe provient du quatrième champ de l’écriture.
Le niveau scolaire est ajouté par rapprochement avec Comptes T.

Les contrôles Power Query portent sur les données chargées,
sans restriction automatique au seul mois d’octobre 2025.

---

## 2. Identification de la campagne de tests

| Élément | Information |
|---|---|
| Responsable | Brice Abogo |
| Date réelle d’exécution | À renseigner |
| Version ou date d’extraction des fichiers | À renseigner |
| Version du modèle Power BI | À renseigner |
| Référence du commit associé | À renseigner |
| Période documentée du jeu de données | Août 2025 à avril 2026 |
| Situation illustrée dans le rapport | Arrêté au 31 octobre 2025 |

La date d’exécution des contrôles est distincte de la date d’arrêté
présentée dans le rapport.

Les résultats doivent être rattachés aux fichiers réellement utilisés
pendant le test.

---

## 3. Synthèse des contrôles exécutés

| Contrôle | Requête Power BI | Résultat communiqué |
|---|---|---|
| Niveau scolaire renseigné | CONTROLE_NiveauxManquants | Exécuté ; aucune anomalie signalée |
| Cohérence des classes | CONTROLE_CoherenceClasses | Exécuté ; aucune anomalie signalée |
| Champs, types, sens et montants | CONTROLE_ValiditeEcritures | Exécuté ; aucune anomalie signalée |
| Conservation des lignes et montants | CONTROLE_ConservationJointure | Conforme selon le résultat d’exécution communiqué |

Les trois premiers contrôles restituent les lignes nécessitant un examen.
Un contrôle sans anomalie détectée doit donc produire un résultat vide.

Le contrôle de conservation restitue au contraire cinq indicateurs,
même lorsque tout est conforme.

Une exécution sans message d’erreur ne suffit pas à qualifier un contrôle
de conforme : son résultat doit également être examiné.

---

## 4. Conservation des lignes et des montants

### Méthode

Le contrôle compare :

1. Les écritures issues de E.txt après sélection du périmètre scolaire
   et application des transformations précédant la jointure.
2. La table finale Ecritures après enrichissement avec Comptes T.

Les deux situations doivent provenir de la même version du fichier source.

### Résultat à consigner

| Indicateur | Avant jointure | Après jointure | Écart communiqué |
|---|---:|---:|---:|
| Nombre total de lignes | À renseigner | À renseigner | 0 |
| Nombre de lignes au débit | À renseigner | À renseigner | 0 |
| Nombre de lignes au crédit | À renseigner | À renseigner | 0 |
| Total débit — FCFA | À renseigner | À renseigner | 0 |
| Total crédit — FCFA | À renseigner | À renseigner | 0 |

Les valeurs Avant et Après doivent être recopiées depuis le résultat
du contrôle, sans les reconstituer à partir des cartes du rapport.

### Conclusion du test

Sur le périmètre testé, l’enrichissement conserve :

- le nombre de lignes ;
- le nombre de lignes au débit et au crédit ;
- les totaux débit et crédit.

Cette conclusion porte sur les agrégats contrôlés.
Elle ne démontre pas, à elle seule, que chaque écriture est correctement
affectée ou que l’export Sage est exhaustif.

### Point comptable important

Il n’est pas attendu que le total débit soit égal au total crédit
dans le périmètre analytique retenu.

Les contreparties ont été exclues.

Le contrôle vérifie que chaque total reste inchangé avant et après
enrichissement, et non que les débits et crédits s’équilibrent entre eux.

---

## 5. Portée et limites des contrôles

### Niveaux manquants

Un résultat vide indique qu’aucun niveau vide n’a été détecté.
Il ne prouve pas qu’un niveau renseigné est toujours correct.

### Cohérence des classes

Le contrôle compare la classe de l’écriture à celle du référentiel.

Une différence doit être examinée avant correction :
elle peut provenir d’une erreur ou d’une évolution justifiée
du rattachement de l’élève.

### Validité des écritures

Le contrôle vérifie les champs obligatoires, les types,
les valeurs D/C et les montants non négatifs.

Une valeur correctement typée peut néanmoins être incorrecte
par rapport à la pièce ou à l’opération d’origine.

### Conservation de la jointure

Des totaux conservés ne remplacent pas les contrôles au niveau
des comptes élèves et des écritures.

Deux anomalies peuvent parfois se compenser dans un total.

### Effectifs

La conformité des contrôles Power Query ne valide pas automatiquement
le nombre d’élèves affiché.

Le comptage distinct des comptes tiers devra être testé dans les
mesures DAX et rapproché du périmètre d’inscription retenu.

---

## 6. Vérifications restant à documenter

Les points suivants feront l’objet de contrôles complémentaires :

- interprétation des dates de 2025 et 2026 ;
- restitution des accents selon l’encodage de chaque export ;
- rapprochement des totaux préparés avec le périmètre extrait de Sage ;
- comptage distinct des élèves ;
- cumul académique sans remise à zéro en janvier ;
- situation à fin octobre 2025 ;
- comportement sur un autre mois, notamment février 2026 ;
- effet des filtres de classe, niveau et section ;
- cohérence entre mouvements mensuels et cumuls ;
- concordance des captures et du PDF avec le modèle validé.

Ces vérifications ne sont pas déclarées réalisées du seul fait
de leur présence dans ce document.

---

## 7. Traitement des anomalies futures

Lorsqu’un contrôle retourne une anomalie :

1. Identifier les lignes concernées dans l’environnement interne.
2. Comparer les données avec les exports et justificatifs disponibles.
3. Rechercher la cause : source, conversion, clé, jointure ou référentiel.
4. Documenter la justification ou la correction proposée.
5. Faire valider la correction selon les responsabilités applicables.
6. Corriger la source ou le traitement approprié.
7. Actualiser et réexécuter les contrôles.
8. Enregistrer la nouvelle conclusion.

Aucune ligne ne doit être supprimée uniquement pour obtenir un résultat
vide ou retrouver un total d’un ancien rapport.

Les écritures similaires ne doivent pas être dédupliquées sans preuve
qu’elles représentent réellement une même opération.

---

## 8. Modèle de fiche pour un prochain test

```text
Nom du contrôle :
Date d’exécution :
Version des exports :
Version du modèle ou référence du commit :

Périmètre :
Résultat attendu :
Résultat observé :

Conclusion :
Justification ou action corrective :
Référence de la preuve conservée :
Date et résultat du nouveau test, si nécessaire :
```

Les preuves peuvent être conservées hors du dépôt public
lorsqu’elles contiennent des informations sensibles.

---

## 9. Confidentialité

Les résultats individuels peuvent contenir des comptes élèves identifiants.

Ils ne doivent pas être publiés dans le portfolio public.

La présentation publique peut se limiter :

- aux règles de contrôle ;
- aux scripts ;
- aux conclusions ;
- aux agrégats autorisés ;
- à des exemples fictifs clairement identifiés.

Une capture de contrôle doit être vérifiée avant diffusion.
Elle ne doit pas exposer de noms, comptes tiers identifiants
ou autres informations personnelles.

---

## Scripts associés

- [Niveaux manquants](../quality/01_niveaux_manquants.pq)
- [Cohérence des classes](../quality/02_coherence_classes.pq)
- [Validité des écritures](../quality/03_validite_ecritures.pq)
- [Conservation de la jointure](../quality/04_conservation_jointure.pq)

## Documentation associée

- [Présentation générale du projet](../README.md)
- [Plan de contrôle qualité](../quality/README.md)
- [Préparation Power Query](../powerquery/README.md)
- [Données sources et conditions de diffusion](../data/README.md)
