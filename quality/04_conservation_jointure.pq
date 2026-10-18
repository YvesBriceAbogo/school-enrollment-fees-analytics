// =====================================================
// PROJET : SUIVI DES EFFECTIFS ET DES FRAIS DE SCOLARITÉ
// AUTEUR : Brice Abogo
//
// REQUÊTE POWER BI : CONTROLE_ConservationJointure
//
// OBJECTIF
// Comparer les lignes et montants des écritures scolaires
// avant et après leur enrichissement par Comptes T.
//
// DÉPENDANCES
// Paramètre pDossierSource.
// Requête finale Ecritures.
//
// MÉTHODE
// Reproduire la préparation de E.txt jusqu'à l'étape
// précédant la jointure, puis comparer à Ecritures.
//
// PÉRIMÈTRE
// Toutes les écritures des comptes commençant par 4.
// Aucun filtre limité au mois d'octobre.
//
// RÉSULTAT
// Tableau de cinq indicateurs avec valeurs avant/après,
// écart et statut.
//
// PRÉCAUTIONS
// Utiliser une même version du fichier pendant le test.
// Ne pas modifier E.txt pendant l'exécution.
// Ne pas masquer les erreurs de conversion.
// Maintenir cette préparation alignée sur la requête Ecritures.
//
// Aucune donnée source n'est modifiée.
// =====================================================

let
    // 1. Construire le chemin de l'export.
    CheminFichier =
        Text.TrimEnd(
            pDossierSource,
            {"\", "/"}
        ) & "\E.txt",

    // 2. Reprendre la lecture utilisée dans Ecritures.
    Source =
        Csv.Document(
            File.Contents(CheminFichier),
            [
                Delimiter = ",",
                Columns = 7,
                Encoding = 1252,
                QuoteStyle = QuoteStyle.Csv,
                ExtraValues = ExtraValues.Error
            ]
        ),

    // 3. Reprendre le découpage de la date JJMMAA.
    DateDecoupee =
        Table.SplitColumn(
            Source,
            "Column2",
            Splitter.SplitTextByRepeatedLengths(2),
            {
                "Column2.1",
                "Column2.2",
                "Column2.3"
            }
        ),

    // 4. Recomposer la date avec le séparateur "/".
    DateRecomposee =
        Table.CombineColumns(
            DateDecoupee,
            {
                "Column2.1",
                "Column2.2",
                "Column2.3"
            },
            Combiner.CombineTextByDelimiter(
                "/",
                QuoteStyle.None
            ),
            "Date"
        ),

    // 5. Identifier le même périmètre comptable.
    IdentificationTiers =
        Table.AddColumn(
            DateRecomposee,
            "Type_Ligne",
            each
                if Text.StartsWith([Column3], "4") then
                    "Tiers"
                else
                    "Autres",
            type text
        ),

    EcrituresTiers =
        Table.SelectRows(
            IdentificationTiers,
            each [Type_Ligne] = "Tiers"
        ),

    SansColonneTechnique =
        Table.RemoveColumns(
            EcrituresTiers,
            {"Type_Ligne"}
        ),

    // 6. Reprendre les noms de colonnes de la requête métier.
    ColonnesRenommees =
        Table.RenameColumns(
            SansColonneTechnique,
            {
                {"Column1", "Code_J"},
                {"Column3", "Compte G"},
                {"Column4", "Classe"},
                {"Column5", "Compte T"},
                {"Column6", "Montants"},
                {"Column7", "Sens"}
            }
        ),

    // 7. Obtenir la situation avant enrichissement.
    AvantJointure =
        Table.TransformColumnTypes(
            ColonnesRenommees,
            {
                {"Code_J", type text},
                {"Date", type date},
                {"Compte G", type text},
                {"Classe", type text},
                {"Compte T", type text},
                {"Montants", Int64.Type},
                {"Sens", type text}
            },
            "fr-FR"
        ),

    // 8. Utiliser la requête métier finale pour l'après.
    ApresJointure =
        Ecritures,

    // 9. Définir les statistiques communes aux deux situations.
    Mesurer =
        (Donnees as table) as record =>
            let
                Debits =
                    Table.SelectRows(
                        Donnees,
                        each [Sens] = "D"
                    ),

                Credits =
                    Table.SelectRows(
                        Donnees,
                        each [Sens] = "C"
                    ),

                TotalDebit =
                    if Table.IsEmpty(Debits) then
                        0
                    else
                        List.Sum(
                            Debits[Montants],
                            Precision.Decimal
                        ),

                TotalCredit =
                    if Table.IsEmpty(Credits) then
                        0
                    else
                        List.Sum(
                            Credits[Montants],
                            Precision.Decimal
                        )
            in
                [
                    NombreLignes = Table.RowCount(Donnees),
                    NombreDebits = Table.RowCount(Debits),
                    NombreCredits = Table.RowCount(Credits),
                    MontantDebit = TotalDebit,
                    MontantCredit = TotalCredit
                ],

    BilanAvant =
        Mesurer(AvantJointure),

    BilanApres =
        Mesurer(ApresJointure),

    // 10. Construire le tableau de comparaison.
    Comparaison =
        #table(
            type table
            [
                Indicateur = text,
                Avant = number,
                Apres = number
            ],
            {
                {
                    "Nombre total de lignes",
                    BilanAvant[NombreLignes],
                    BilanApres[NombreLignes]
                },
                {
                    "Nombre de lignes au débit",
                    BilanAvant[NombreDebits],
                    BilanApres[NombreDebits]
                },
                {
                    "Nombre de lignes au crédit",
                    BilanAvant[NombreCredits],
                    BilanApres[NombreCredits]
                },
                {
                    "Total débit - FCFA",
                    BilanAvant[MontantDebit],
                    BilanApres[MontantDebit]
                },
                {
                    "Total crédit - FCFA",
                    BilanAvant[MontantCredit],
                    BilanApres[MontantCredit]
                }
            }
        ),

    // 11. Calculer l'écart.
    AvecEcart =
        Table.AddColumn(
            Comparaison,
            "Ecart",
            each [Apres] - [Avant],
            type number
        ),

    // 12. Qualifier le résultat.
    // Un périmètre source vide n'est pas déclaré conforme.
    Resultat =
        Table.AddColumn(
            AvecEcart,
            "Statut",
            each
                if BilanAvant[NombreLignes] = 0 then
                    "NON ÉVALUABLE - aucune écriture source"
                else if [Ecart] = 0 then
                    "CONFORME"
                else
                    "À EXAMINER",
            type text
        )
in
    Resultat
