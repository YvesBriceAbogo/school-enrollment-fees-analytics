// =====================================================
// PROJET : SUIVI DES EFFECTIFS ET DES FRAIS DE SCOLARITÉ
// AUTEUR : Brice Abogo
//
// REQUÊTE POWER BI : CONTROLE_NiveauxManquants
//
// OBJECTIF
// Identifier les écritures dont le niveau scolaire
// n'est pas renseigné après enrichissement.
//
// DÉPENDANCE
// Requête Ecritures.
//
// RÈGLE
// Une valeur null, vide ou composée uniquement d'espaces
// dans Niveau+ est considérée comme manquante.
//
// GRANULARITÉ
// Une ligne retournée correspond à une ligne d'écriture,
// et non nécessairement à un élève distinct.
//
// TRAITEMENT
// Toutes les colonnes de l'écriture sont conservées.
// Aucune correction ni suppression dans la source.
//
// CONFIDENTIALITÉ
// Le résultat peut contenir des comptes élèves identifiants.
// Ne pas publier les résultats individuels réels sur GitHub.
// =====================================================

let
    // 1. Utiliser les écritures préparées.
    Source =
        Ecritures,

    // 2. Vérifier la présence de la colonne à contrôler.
    StructureVerifiee =
        if Table.HasColumns(
            Source,
            {"Niveau+"}
        ) then
            Source
        else
            error Error.Record(
                "Colonne requise absente",
                "La requête Ecritures doit contenir la colonne Niveau+.",
                [
                    Table = "Ecritures",
                    Colonne = "Niveau+"
                ]
            ),

    // 3. Conserver les écritures sans niveau renseigné.
    NiveauxManquants =
        Table.SelectRows(
            StructureVerifiee,
            each
                if [#"Niveau+"] = null then
                    true
                else
                    Text.Trim([#"Niveau+"]) = ""
        ),

    // 4. Trier les résultats pour faciliter leur examen.
    Resultat =
        Table.Sort(
            NiveauxManquants,
            {
                {"Date", Order.Ascending},
                {"Compte T", Order.Ascending}
            }
        )
in
    Resultat
