// =====================================================
// PROJET : SUIVI DES EFFECTIFS ET DES FRAIS DE SCOLARITÉ
// AUTEUR : Brice Abogo
//
// REQUÊTE POWER BI : Comptes G
//
// OBJECTIF
// Préparer le référentiel des comptes généraux utilisé
// pour l'analyse de la scolarité.
//
// SOURCE
// Fichier G.txt exporté depuis Sage Saari.
//
// STRUCTURE ATTENDUE
// Colonne 1 : compte général.
// Colonne 2 : libellé de regroupement.
// Colonne 3 : marqueur d'export, non conservé dans le résultat.
//
// PARAMÈTRE
// pDossierSource : dossier contenant les exports Sage.
//
// ENCODAGE
// Windows-1252 retenu pour cet export ANSI.
// Vérifier les caractères accentués lors du test.
//
// CONVENTIONS
// Conserver les comptes comme identifiants textuels.
// Sélectionner les comptes commençant par 4.
// Exclure explicitement les deux comptes hors périmètre.
// Ne pas supprimer des lignes selon leur position.
//
// CHARGEMENT
// Activer le chargement de cette table dans le modèle.
// =====================================================

let
    // 1. Construire le chemin du fichier.
    // Accepter un dossier saisi avec ou sans séparateur final.
    CheminFichier =
        Text.TrimEnd(
            pDossierSource,
            {"\", "/"}
        ) & "\G.txt",

    // 2. Définir les comptes exclus du périmètre scolaire.
    // Les identifiants sont conservés sous forme de texte.
    ComptesExclus =
        {
            "471100000000",
            "471200000000"
        },

    // 3. Définir un nettoyage local des champs texte.
    NettoyerTexte =
        (Valeur as nullable text) as nullable text =>
            if Valeur = null then
                null
            else
                let
                    Texte =
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
                    if Texte = "" then null else Texte,

    // 4. Lire les trois colonnes de l'export.
    // Aucune promotion d'en-têtes : la première ligne est une donnée.
    // Un champ supplémentaire inattendu provoque une erreur.
    Source =
        Csv.Document(
            File.Contents(CheminFichier),
            [
                Delimiter = ",",
                Columns = 3,
                Encoding = 1252,
                QuoteStyle = QuoteStyle.Csv,
                ExtraValues = ExtraValues.Error
            ]
        ),

    // 5. Nettoyer les textes sans convertir les comptes en nombres.
    TextesNettoyes =
        Table.TransformColumns(
            Source,
            {
                {"Column1", NettoyerTexte, type nullable text},
                {"Column2", NettoyerTexte, type nullable text},
                {"Column3", NettoyerTexte, type nullable text}
            }
        ),

    // 6. Retirer uniquement les lignes entièrement vides.
    LignesNonVides =
        Table.SelectRows(
            TextesNettoyes,
            each
                [Column1] <> null
                or [Column2] <> null
                or [Column3] <> null
        ),

    // 7. Nommer les colonnes utiles.
    ColonnesRenommees =
        Table.RenameColumns(
            LignesNonVides,
            {
                {"Column1", "Compte G"},
                {"Column2", "Classe"}
            }
        ),

    // 8. Signaler les lignes non vides sans compte général.
    ComptesManquants =
        Table.SelectRows(
            ColonnesRenommees,
            each [#"Compte G"] = null
        ),

    IdentifiantsVerifies =
        if Table.IsEmpty(ComptesManquants) then
            ColonnesRenommees
        else
            error Error.Record(
                "Compte général manquant",
                "Des lignes non vides ne possèdent pas de compte général.",
                [
                    NombreLignes =
                        Table.RowCount(ComptesManquants)
                ]
            ),

    // 9. Appliquer le périmètre métier.
    // L'exclusion dépend du compte, pas de sa position dans le fichier.
    PerimetreScolarite =
        Table.SelectRows(
            IdentifiantsVerifies,
            each
                Text.StartsWith([#"Compte G"], "4")
                and not List.Contains(
                    ComptesExclus,
                    [#"Compte G"]
                )
        ),

    // 10. Conserver les colonnes nécessaires au modèle.
    ColonnesUtiles =
        Table.SelectColumns(
            PerimetreScolarite,
            {
                "Compte G",
                "Classe"
            }
        ),

    // 11. Vérifier la présence des libellés dans le périmètre retenu.
    LibellesManquants =
        Table.SelectRows(
            ColonnesUtiles,
            each [Classe] = null
        ),

    LibellesVerifies =
        if Table.IsEmpty(LibellesManquants) then
            ColonnesUtiles
        else
            error Error.Record(
                "Libellé manquant",
                "Certains comptes retenus ne possèdent pas de libellé.",
                [
                    NombreLignes =
                        Table.RowCount(LibellesManquants)
                ]
            ),

    // 12. Contrôler l'unicité du compte général.
    ComptageParCompte =
        Table.Group(
            LibellesVerifies,
            {"Compte G"},
            {
                {
                    "NombreOccurrences",
                    each Table.RowCount(_),
                    Int64.Type
                }
            }
        ),

    ComptesDupliques =
        Table.SelectRows(
            ComptageParCompte,
            each [NombreOccurrences] > 1
        ),

    // 13. Restituer les données ou signaler les doublons.
    Resultat =
        if Table.IsEmpty(ComptesDupliques) then
            LibellesVerifies
        else
            error Error.Record(
                "Compte général non unique",
                "Des comptes apparaissent plusieurs fois dans le référentiel.",
                [
                    NombreComptes =
                        Table.RowCount(ComptesDupliques)
                ]
            )
in
    Resultat
