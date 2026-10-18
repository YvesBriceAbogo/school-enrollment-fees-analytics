// =====================================================
// PROJET : SUIVI DES EFFECTIFS ET DES FRAIS DE SCOLARITÉ
// AUTEUR : Brice Abogo
//
// REQUÊTE POWER BI : Comptes T
//
// OBJECTIF
// Préparer les comptes élèves et les enrichir avec
// la classe, le niveau et la section.
//
// SOURCE
// Fichier T.txt exporté depuis Sage Saari.
//
// STRUCTURE ATTENDUE
// Colonne 1 : compte tiers.
// Colonne 2 : nom.
// Colonne 3 : compte général de rattachement.
//
// ENCODAGE
// UTF-8.
//
// DÉPENDANCES
// Paramètre pDossierSource.
// Requête Comptes G, avec des comptes uniques de type Texte.
//
// CONVENTIONS
// Un compte tiers correspond à un seul élève.
// Chaque élève est rattaché à une classe précise.
// Aucune ligne de total n'est attendue.
//
// CONFIDENTIALITÉ
// La colonne Nom est destinée au traitement interne.
// Les données nominatives ne sont pas destinées au dépôt public.
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
        ) & "\T.txt",

    // 2. Définir un nettoyage local des textes.
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

    // 3. Lire l'export UTF-8.
    // La première ligne contient des données.
    // Un champ supplémentaire inattendu provoque une erreur.
    Source =
        Csv.Document(
            File.Contents(CheminFichier),
            [
                Delimiter = ",",
                Columns = 3,
                Encoding = 65001,
                QuoteStyle = QuoteStyle.Csv,
                ExtraValues = ExtraValues.Error
            ]
        ),

    // 4. Nommer les colonnes sources.
    ColonnesRenommees =
        Table.RenameColumns(
            Source,
            {
                {"Column1", "Compte T"},
                {"Column2", "Nom"},
                {"Column3", "Compte G"}
            }
        ),

    // 5. Nettoyer les textes et conserver les comptes
    // comme identifiants textuels.
    TextesNettoyes =
        Table.TransformColumns(
            ColonnesRenommees,
            {
                {"Compte T", NettoyerTexte, type nullable text},
                {"Nom", NettoyerTexte, type nullable text},
                {"Compte G", NettoyerTexte, type nullable text}
            }
        ),

    // 6. Retirer uniquement les lignes entièrement vides.
    LignesNonVides =
        Table.SelectRows(
            TextesNettoyes,
            each
                [#"Compte T"] <> null
                or [Nom] <> null
                or [#"Compte G"] <> null
        ),

    // 7. Contrôler les champs obligatoires.
    LignesIncompletes =
        Table.SelectRows(
            LignesNonVides,
            each
                [#"Compte T"] = null
                or [Nom] = null
                or [#"Compte G"] = null
        ),

    ChampsVerifies =
        if Table.IsEmpty(LignesIncompletes) then
            LignesNonVides
        else
            error Error.Record(
                "Champs obligatoires manquants",
                "Certains comptes élèves présentent des informations manquantes.",
                [
                    NombreLignes =
                        Table.RowCount(LignesIncompletes)
                ]
            ),

    // 8. Vérifier l'unicité du compte tiers.
    ComptageTiers =
        Table.Group(
            ChampsVerifies,
            {"Compte T"},
            {
                {
                    "NombreOccurrences",
                    each Table.RowCount(_),
                    Int64.Type
                }
            }
        ),

    TiersDupliques =
        Table.SelectRows(
            ComptageTiers,
            each [NombreOccurrences] > 1
        ),

    TiersVerifies =
        if Table.IsEmpty(TiersDupliques) then
            ChampsVerifies
        else
            error Error.Record(
                "Compte tiers non unique",
                "Des comptes élèves apparaissent plusieurs fois dans le référentiel.",
                [
                    NombreComptes =
                        Table.RowCount(TiersDupliques)
                ]
            ),

    // 9. Rapprocher chaque compte élève de son compte général.
    // La jointure gauche conserve les comptes élèves
    // afin de pouvoir signaler les correspondances absentes.
    RapprochementGeneral =
        Table.NestedJoin(
            TiersVerifies,
            {"Compte G"},
            #"Comptes G",
            {"Compte G"},
            "ReferentielGeneral",
            JoinKind.LeftOuter
        ),

    // 10. Récupérer le libellé de classe.
    AvecClasse =
        Table.ExpandTableColumn(
            RapprochementGeneral,
            "ReferentielGeneral",
            {"Classe"},
            {"Classe"}
        ),

    // 11. Vérifier que chaque compte élève est rapproché.
    CorrespondancesAbsentes =
        Table.SelectRows(
            AvecClasse,
            each [Classe] = null
        ),

    ClassesRapprochees =
        if Table.IsEmpty(CorrespondancesAbsentes) then
            AvecClasse
        else
            error Error.Record(
                "Compte général non rapproché",
                "Certains comptes élèves ne trouvent pas de correspondance dans Comptes G.",
                [
                    NombreLignes =
                        Table.RowCount(CorrespondancesAbsentes)
                ]
            ),

    // 12. Déterminer le niveau selon une liste explicite de classes.
    // La normalisation sert uniquement à la comparaison :
    // le libellé original de Classe est conservé.
    AvecNiveau =
        Table.AddColumn(
            ClassesRapprochees,
            "Niveau+",
            each
                let
                    ClasseCle =
                        Text.Upper(
                            Text.Trim([Classe])
                        )
                in
                    if List.Contains(
                        {
                            "PETITE SECTION",
                            "MOYENNE SECTION",
                            "GRANDE SECTION"
                        },
                        ClasseCle
                    ) then
                        "Maternelle Francophone"

                    else if List.Contains(
                        {
                            "PRE-NURSERY",
                            "NURSERY I",
                            "NURSERY II"
                        },
                        ClasseCle
                    ) then
                        "Maternelle Anglophone"

                    else if List.Contains(
                        {
                            "CLASS I",
                            "CLASS II",
                            "CLASS III",
                            "CLASS IV",
                            "CLASS V",
                            "CLASS VI"
                        },
                        ClasseCle
                    ) then
                        "Primaire Anglophone"

                    else if List.Contains(
                        {
                            "CIL",
                            "CP",
                            "CE1",
                            "CE2",
                            "CM1",
                            "CM2"
                        },
                        ClasseCle
                    ) then
                        "Primaire Francophone"

                    else
                        null,
            type nullable text
        ),

    // 13. Signaler les classes non prévues.
    // Aucune classe inconnue n'est affectée automatiquement
    // au primaire francophone.
    ClassesNonReconnues =
        Table.SelectRows(
            AvecNiveau,
            each [#"Niveau+"] = null
        ),

    NiveauxVerifies =
        if Table.IsEmpty(ClassesNonReconnues) then
            AvecNiveau
        else
            error Error.Record(
                "Classe non reconnue",
                "Un libellé de classe doit être vérifié ou ajouté à la correspondance.",
                [
                    Classes =
                        List.Distinct(
                            ClassesNonReconnues[Classe]
                        )
                ]
            ),

    // 14. Déterminer la section.
    // À ce stade, chaque niveau appartient aux quatre valeurs validées.
    AvecSection =
        Table.AddColumn(
            NiveauxVerifies,
            "Section",
            each
                if List.Contains(
                    {
                        "Maternelle Francophone",
                        "Primaire Francophone"
                    },
                    [#"Niveau+"]
                ) then
                    "Section Francophone"
                else
                    "Section Anglophone",
            type text
        ),

    // 15. Fixer les types de sortie.
    Resultat =
        Table.TransformColumnTypes(
            AvecSection,
            {
                {"Compte T", type text},
                {"Nom", type text},
                {"Compte G", type text},
                {"Classe", type text},
                {"Niveau+", type text},
                {"Section", type text}
            },
            "fr-FR"
        )
in
    Resultat
