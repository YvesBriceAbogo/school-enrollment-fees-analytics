// =====================================================
// PROJET : SUIVI DES EFFECTIFS ET DES FRAIS DE SCOLARITÉ
// AUTEUR : Brice Abogo
//
// REQUÊTE POWER BI : CONTROLE_ValiditeEcritures
//
// OBJECTIF
// Identifier les écritures présentant :
// - un champ obligatoire manquant ;
// - un type de donnée inattendu ;
// - une erreur dans une cellule ;
// - un sens différent de D ou C ;
// - un montant négatif.
//
// DÉPENDANCE
// Requête Ecritures.
//
// CONVENTIONS
// Les comptes sont des identifiants textuels.
// Les montants sont numériques et non négatifs.
// Zéro n'est pas considéré comme une valeur manquante.
//
// TRAITEMENT
// Aucune correction ou suppression dans la source.
// Les colonnes originales sont conservées.
//
// LIMITES
// Le contrôle examine les valeurs après transformation.
// Il ne remplace pas le rapprochement avec les exports Sage.
//
// CONFIDENTIALITÉ
// Le résultat peut contenir des comptes élèves identifiants.
// Ne pas publier les résultats individuels réels sur GitHub.
// =====================================================

let
    // 1. Définir une fonction locale de contrôle.
    VerifierChamp =
        (
            Ligne as record,
            NomColonne as text,
            TypeAttendu as type
        ) as nullable text =>
        let
            Lecture =
                try Record.Field(
                    Ligne,
                    NomColonne
                )
        in
            if Lecture[HasError] then
                NomColonne & " : erreur présente dans la cellule"

            else if Lecture[Value] = null then
                NomColonne & " : valeur obligatoire manquante"

            else if not Value.Is(
                Lecture[Value],
                TypeAttendu
            ) then
                NomColonne & " : type de donnée inattendu"

            else if Value.Is(
                Lecture[Value],
                type text
            ) then
                if Text.Trim(Lecture[Value]) = "" then
                    NomColonne & " : texte vide"

                else if NomColonne = "Sens" then
                    if List.Contains(
                        {"D", "C"},
                        Lecture[Value]
                    ) then
                        null
                    else
                        "Sens : valeur différente de D ou C"

                else
                    null

            else if NomColonne = "Montants" then
                if Lecture[Value] < 0 then
                    "Montants : valeur négative"
                else
                    null

            else
                null,

    // 2. Utiliser les écritures préparées.
    Source =
        Ecritures,

    // 3. Définir les colonnes nécessaires.
    ColonnesAttendues =
        {
            "Code_J",
            "Date",
            "Compte G",
            "Classe",
            "Compte T",
            "Montants",
            "Sens"
        },

    // 4. Vérifier la présence des colonnes.
    ColonnesManquantes =
        List.Difference(
            ColonnesAttendues,
            Table.ColumnNames(Source)
        ),

    StructureVerifiee =
        if List.IsEmpty(ColonnesManquantes) then
            Source
        else
            error Error.Record(
                "Colonnes requises absentes",
                "La structure de Ecritures ne permet pas d'exécuter le contrôle.",
                [
                    Colonnes =
                        ColonnesManquantes
                ]
            ),

    // 5. Ajouter un repère de ligne pour cette exécution.
    // Ce numéro n'est pas un identifiant comptable permanent
    // et ne correspond pas nécessairement à la ligne du fichier TXT.
    AvecNumeroLigne =
        Table.AddIndexColumn(
            StructureVerifiee,
            "Ligne_Controle",
            1,
            1,
            Int64.Type
        ),

    // 6. Examiner chaque champ et regrouper les motifs.
    AvecDiagnostic =
        Table.AddColumn(
            AvecNumeroLigne,
            "Motif_Controle",
            (Ligne as record) =>
                Text.Combine(
                    List.RemoveNulls(
                        {
                            VerifierChamp(
                                Ligne,
                                "Code_J",
                                type text
                            ),
                            VerifierChamp(
                                Ligne,
                                "Date",
                                type date
                            ),
                            VerifierChamp(
                                Ligne,
                                "Compte G",
                                type text
                            ),
                            VerifierChamp(
                                Ligne,
                                "Classe",
                                type text
                            ),
                            VerifierChamp(
                                Ligne,
                                "Compte T",
                                type text
                            ),
                            VerifierChamp(
                                Ligne,
                                "Montants",
                                type number
                            ),
                            VerifierChamp(
                                Ligne,
                                "Sens",
                                type text
                            )
                        }
                    ),
                    " | "
                ),
            type text
        ),

    // 7. Conserver uniquement les lignes à examiner.
    LignesAExaminer =
        Table.SelectRows(
            AvecDiagnostic,
            each [Motif_Controle] <> ""
        ),

    // 8. Restituer les résultats dans l'ordre du contrôle.
    Resultat =
        Table.Sort(
            LignesAExaminer,
            {
                {"Ligne_Controle", Order.Ascending}
            }
        )
in
    Resultat
