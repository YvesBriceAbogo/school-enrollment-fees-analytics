// =====================================================
// PROJET : SUIVI DES EFFECTIFS ET DES FRAIS DE SCOLARITÉ
// AUTEUR : Brice Abogo
//
// REQUÊTE POWER BI : Ecritures
//
// OBJECTIF
// Préparer les écritures des comptes élèves en conservant
// la logique de transformation de la requête initiale.
//
// SOURCE
// Fichier E.txt exporté depuis Sage Saari, sans en-tête.
//
// STRUCTURE SOURCE
// Colonne 1 : code du journal.
// Colonne 2 : date au format JJMMAA.
// Colonne 3 : compte général.
// Colonne 4 : classe de l'élève.
// Colonne 5 : compte tiers élève.
// Colonne 6 : montant.
// Colonne 7 : sens D ou C.
//
// DÉPENDANCES
// Paramètre pDossierSource.
// Requête Comptes T.
//
// CONVENTIONS
// D : constatation de la scolarité sur le compte élève.
// C : règlement sur le compte élève.
// La sélection des comptes commençant par 4 reprend
// le périmètre scolaire confirmé.
//
// Les contreparties de produits et de trésorerie sont exclues.
// La classe provient du quatrième champ de l'écriture.
// Seul Niveau+ est ajouté depuis le référentiel Comptes T.
//
// ENCODAGE
// Windows-1252 retenu pour l'export ANSI.
// Vérifier les caractères accentués lors du test.
//
// CONFIDENTIALITÉ
// Les comptes tiers peuvent identifier les élèves.
// Les données réelles ne sont pas destinées au dépôt public.
//
// CHARGEMENT
// Activer le chargement de cette table dans le modèle.
// =====================================================

let
    // 1. Construire le chemin du fichier.
    CheminFichier =
        Text.TrimEnd(
            pDossierSource,
            {"\", "/"}
        ) & "\E.txt",

    // 2. Lire les sept colonnes de l'export.
    // La première ligne contient des données :
    // aucune promotion d'en-têtes n'est effectuée.
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

    // 3. Découper la date en groupes de deux caractères.
    // Exemple : 200825 -> 20, 08, 25.
    // Traitement repris de la requête initiale.
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
    // Exemple : 20, 08, 25 -> 20/08/25.
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

    // 5. Identifier les lignes relatives aux comptes de tiers.
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

    // 6. Conserver uniquement les comptes de tiers.
    // Les contreparties de produits et de trésorerie
    // ne sont pas utilisées dans les indicateurs.
    EcrituresTiers =
        Table.SelectRows(
            IdentificationTiers,
            each [Type_Ligne] = "Tiers"
        ),

    // 7. Retirer la colonne technique de sélection.
    SansColonneTechnique =
        Table.RemoveColumns(
            EcrituresTiers,
            {
                "Type_Ligne"
            }
        ),

    // 8. Nommer les colonnes conformément au modèle initial.
    // Le quatrième champ est bien la classe de l'élève.
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

    // 9. Appliquer les types de données.
    // La date reconstituée est interprétée en français.
    //
    // Compte G reste en texte pour être compatible
    // avec les référentiels préparés.
    //
    // Montants conserve le type entier de la requête initiale.
    TypesDefinis =
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

    // 10. Rapprocher les écritures du référentiel élèves.
    // La jointure gauche conserve toutes les écritures retenues.
    RapprochementTiers =
        Table.NestedJoin(
            TypesDefinis,
            {
                "Compte T"
            },
            #"Comptes T",
            {
                "Compte T"
            },
            "CorrespondanceTiers",
            JoinKind.LeftOuter
        ),

    // 11. Ajouter uniquement le niveau.
    // La classe issue de l'écriture reste inchangée.
    AvecNiveau =
        Table.ExpandTableColumn(
            RapprochementTiers,
            "CorrespondanceTiers",
            {
                "Niveau+"
            },
            {
                "Niveau+"
            }
        ),

    // 12. Organiser les colonnes de sortie.
    Resultat =
        Table.ReorderColumns(
            AvecNiveau,
            {
                "Code_J",
                "Date",
                "Compte G",
                "Classe",
                "Compte T",
                "Montants",
                "Sens",
                "Niveau+"
            }
        )
in
    Resultat
