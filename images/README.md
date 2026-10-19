# Galerie du rapport Power BI

**Projet : Suivi des effectifs et du recouvrement des frais de scolarité**  
**Auteur : Brice Abogo**

[Retour à la présentation du projet](../README.md)

Cette galerie présente les différentes pages du rapport Power BI.

Le rapport comporte cinq dashboards. Dashboard 1 est présenté sous
quatre variantes, correspondant aux quatre indicateurs disponibles
dans le sélecteur « Mesures ».

Les captures sont statiques : les boutons, filtres et interactions
ne sont pas utilisables depuis GitHub.

Cliquez sur une capture pour ouvrir son fichier image.

---

## 1. Contexte des vues de synthèse

Les quatre captures de Dashboard 1 utilisent le même contexte :

| Paramètre | Sélection |
|---|---|
| Année académique | 2025/2026 |
| Year-month | 10-25 — octobre 2025 |
| Niveau / classe | Tous |
| Section | Toutes |
| Début du cumul académique | 1er août 2025 |
| Situation de référence | 31 octobre 2025 |
| Devise | FCFA |

La période disponible dans le rapport couvre août 2025 à avril 2026.
Les vues de synthèse présentées ici illustrent la situation de référence
d’octobre 2025, et non la totalité de cette période.

Le dernier mois disponible peut être incomplet.

---

## 2. Indicateurs affichés

Les cinq cartes de synthèse présentent les mêmes valeurs dans les
quatre captures :

| Indicateur | Valeur affichée |
|---|---:|
| Effectif actuel | 221 |
| Pensions déjà Constatées | 15 220 000 FCFA |
| Règlements déjà perçus | 7 488 000 FCFA |
| Solde restant | 7 732 000 FCFA |
| % Recouvrement Global | 49,20 % |

Le sélecteur « Mesures » permet de changer l’indicateur représenté
dans les graphiques par niveau, section et classe.

Les résultats des contrôles sont consignés séparément dans le
[journal de contrôle qualité](../docs/controle-qualite.md).
La galerie illustre le rendu du rapport ; elle ne remplace pas
les tests du modèle.

---

## 3. Dashboard 1 — Les quatre variantes

### 3.1. Effectif actuel

**Sélection dans « Mesures » : Effectif actuel**

[![Vue de synthèse — Effectif actuel](01-overview.png)](01-overview.png)

Cette vue présente la répartition de l’effectif distinct cumulé :

- par niveau scolaire ;
- par section linguistique ;
- par classe.

Le libellé « Effectif actuel » désigne ici les comptes élèves distincts
ayant une constatation de scolarité entre le 1er août et le
31 octobre 2025.

Les 221 élèves ne constituent pas automatiquement un effectif
administratif vérifié au registre des inscriptions.

Cet indicateur est recalculé sur l’ensemble de la période :
il ne résulte pas de l’addition des effectifs mensuels.

### 3.2. Scolarité constatée

**Sélection dans « Mesures » : Pensions déjà Constatées**

[![Vue de synthèse — Scolarité constatée cumulée](01-overview-scolarite.png)](01-overview-scolarite.png)

Cette vue présente la répartition des frais de scolarité constatés
depuis le début du cycle académique jusqu’à la situation de référence.

Les graphiques permettent de comparer les montants par niveau,
section et classe.

Le montant cumulé affiché est de **15 220 000 FCFA**.

### 3.3. Règlements perçus

**Sélection dans « Mesures » : Règlements déjà perçus**

[![Vue de synthèse — Règlements cumulés](01-overview-reglements.png)](01-overview-reglements.png)

Cette vue présente la répartition des règlements cumulés sur
la même période académique.

Les graphiques permettent d’examiner la contribution de chaque niveau,
section et classe au total des règlements.

Le montant cumulé affiché est de **7 488 000 FCFA**.

### 3.4. Solde restant

**Sélection dans « Mesures » : Solde restant**

[![Vue de synthèse — Solde restant](01-overview-solde.png)](01-overview-solde.png)

Cette vue présente la répartition de la différence entre les frais
de scolarité constatés et les règlements cumulés.

Le solde affiché est de **7 732 000 FCFA**, soit :

**15 220 000 − 7 488 000 = 7 732 000 FCFA**

Les graphiques permettent de comparer la répartition de ce solde
par niveau, section et classe.

Le solde restant, également intitulé « Solde dû » dans certains
graphiques, ne représente pas automatiquement une somme échue
ou un retard de paiement.

L’identification des retards nécessite les échéances applicables.

---

## 4. Conventions de lecture

- Les montants sont exprimés en FCFA.
- Dans les graphiques, « K » représente des milliers et « M »
  des millions.
- Certaines étiquettes graphiques sont arrondies.
- Le taux de recouvrement correspond aux règlements cumulés
  divisés par la scolarité constatée cumulée.
- Les captures montrent un état du rapport avec des filtres précis ;
  elles ne permettent pas de tester ses interactions.

---

## 5. Autres pages du rapport — Captures à ajouter

La galerie sera complétée progressivement avec les pages suivantes :

| Page | Contenu |
|---|---|
| Dashboard 2 | Évolution mensuelle des cumuls de scolarité, des règlements et du solde |
| Dashboard 3 | Détails mensuels par niveau et classe, accompagnés des tendances |
| Dashboard 4 | Situation individuelle — version de démonstration entièrement synthétique |
| Dashboard 5 | Suivi journalier — version de démonstration entièrement synthétique |

Pour les dashboards 4 et 5, les lignes de démonstration sont entièrement
synthétiques, conformément à la confirmation de l’auteur :
elles ne reproduisent aucune situation individuelle réelle.

Cette distinction concerne la version de présentation de ces pages.
Elle ne requalifie pas les données sources décrites dans la
documentation du projet.

---

## Documentation associée

- [Présentation générale](../README.md)
- [Dictionnaire des données](../docs/dictionnaire-donnees.md)
- [Journal de contrôle qualité](../docs/controle-qualite.md)
- [Mesures DAX](../dax/README.md)
- [Confidentialité](../docs/confidentialite.md)
