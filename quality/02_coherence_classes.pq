// =====================================================
// PROJET : SUIVI DES EFFECTIFS ET DES FRAIS DE SCOLARITÉ
// AUTEUR : Brice Abogo
//
// REQUÊTE POWER BI : CONTROLE_CoherenceClasses
//
// OBJECTIF
// Comparer la classe de chaque écriture avec la classe
// du compte élève dans le référentiel Comptes T.
//
// DÉPENDANCES
// Ecritures
// Comptes T
//
// CLÉ DE RAPPROCHEMENT
// Compte T, de type Texte dans les deux requêtes.
//
// CONVENTIONS
// La classe de l'écriture reste inchangée.
// La classe du référentiel est ajoutée pour comparaison.
// Les différences doivent être examinées avant correction.
//
// La comparaison neutralise la casse, les espaces
// en début et fin et certains caractères parasites.
// Les accents sont conservés.
// Aucun rapprochement approximatif n'est effectué.
//
// GRANULARITÉ
// Une ligne de contrôle correspond à une ligne d'écriture.
// Le contrôle ne développe pas les correspondances multiples,
// afin de ne pas multiplier les lignes lors de sa propre jointure.
//
// CONFIDENTIALITÉ
// Le résultat peut contenir des comptes élèves identifiants.
// Ne pas publier les résultats individuels réels sur GitHub.
// =====================================================

let
    // 1. Définir une normalisation réservée à la comparaison.
    // Les libellés d'origine restent présents dans le résultat.
    NormaliserClasse =
        (Valeur as nullable text) as nullable text =>
            if Valeur = null then
                null
            else
                let
                    TexteNettoye =
                        Text.Trim(
                            Text.Clean(
                                Text.Replace(
                                    Valeur,
                                    Character.FromNumber(160),
                                    " "
                                )
                            )
                        )
                in
                    if TexteNettoye = "" then
                        null
                    else
                        Text.Upper(
                            TexteNettoye,
                            "fr-FR"
                        ),

    // 2. Utiliser les écritures préparées.
    Source =
        Ecritures,

    // 3. Ne récupérer que les informations nécessaires
    // du référentiel élèves.
    ReferentielClasses =
        Table.SelectColumns(
            #"Comptes T",
            {
                "Compte T",
                "Classe"
            }
        ),

    // 4. Rapprocher chaque écriture du référentiel.
    Rapprochement =
        Table.NestedJoin(
            Source,
            {"Compte T"},
            ReferentielClasses,
            {"Compte T"},
            "ReferenceClasse",
            JoinKind.LeftOuter
        ),

    // 5. Compter les correspondances sans développer
    // la table imbriquée.
    AvecNombreCorrespondances =
        Table.AddColumn(
            Rapprochement,
            "Nombre_Correspondances",
            each Table.RowCount([ReferenceClasse]),
            Int64.Type
        ),

    // 6. Récupérer la classe uniquement si la correspondance
    // est unique. Ne pas choisir arbitrairement une ligne.
    AvecClasseReferentiel =
        Table.AddColumn(
            AvecNombreCorrespondances,
            "Classe_Referentiel",
            each
                if [Nombre_Correspondances] = 1 then
                    [ReferenceClasse]{0}[Classe]
                else
                    null,
            type nullable text
        ),

    // 7. Décrire la situation à examiner.
    AvecDiagnostic =
        Table.AddColumn(
            AvecClasseReferentiel,
            "Motif_Controle",
            each
                let
                    ClasseEcriture =
                        NormaliserClasse([Classe]),

                    ClasseReference =
                        NormaliserClasse([Classe_Referentiel])
                in
                    if
                        [#"Compte T"] = null
                        or Text.Trim([#"Compte T"]) = ""
                    then
                        "Compte tiers manquant"

                    else if [Nombre_Correspondances] = 0 then
                        "Compte tiers absent du référentiel"

                    else if [Nombre_Correspondances] > 1 then
                        "Compte tiers non unique dans le référentiel"

                    else if ClasseEcriture = null then
                        "Classe manquante dans l'écriture"

                    else if ClasseReference = null then
                        "Classe manquante dans le référentiel"

                    else if ClasseEcriture <> ClasseReference then
                        "Classe différente du référentiel"

                    else
                        null,
            type nullable text
        ),

    // 8. Conserver uniquement les situations à examiner.
    Ecarts =
        Table.SelectRows(
            AvecDiagnostic,
            each [Motif_Controle] <> null
        ),

    // 9. Retirer la table imbriquée de rapprochement.
    SansColonneTechnique =
        Table.RemoveColumns(
            Ecarts,
            {"ReferenceClasse"}
        ),

    // 10. Trier les résultats pour faciliter leur examen.
    Resultat =
        Table.Sort(
            SansColonneTechnique,
            {
                {"Date", Order.Ascending},
                {"Compte T", Order.Ascending}
            }
        )
in
    Resultat
