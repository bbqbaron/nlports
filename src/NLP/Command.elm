module NLP.Command exposing (commandSets, make, NlpCmd, NlpRequest)

import Char
import String

type NlpCmdToken =
    Sentence
    | SentenceType
    | Terminator
    | ToPast
    | ToPresent
    | ToFuture
    | Negate
    | Tags
    | Normal
    | Text
    | Contractions
      | Contract
      | Expand
    | Root

    | Terms

    | Pluralize
    | Conjugate
    | Verb
    | Adjective
    | Adverb
    | Noun
    | Value
    | Person
    | Date
    | Place
    | Organization

type alias  NlpCmd = List NlpCmdToken

type alias NlpRequest = {
    commands: List String,
    text: String
}

snake : String -> String
snake =
    let add_ char =
            let stringChar = String.cons char ""
            in
                if Char.isUpper char
                then "_" ++ (String.toLower stringChar)
                else stringChar
    in String.foldl
        (\char string ->
             string ++
             if String.isEmpty string
             then (String.cons (Char.toLower char) "")
             else (add_ char)
        )
        ""

makeCommandSet : NlpCmdToken -> List (List NlpCmdToken) -> List (List NlpCmdToken)
makeCommandSet first =
    List.map
        ((++) [first])

sentenceCommands =
    makeCommandSet
        Sentence
        [
         [SentenceType]
        , [Terminator]
        , [ToPast]
        , [ToPresent]
        , [ToFuture]
        , [Negate]
        , [Tags]
        , [Normal]
        , [Text]
        , [Contractions, Expand]
        , [Contractions, Contract]
        , [Root]
        ]

textCommands =
    makeCommandSet
        Text
        [
         [ToPast]
        , [ToPresent]
        , [ToFuture]
        , [Negate]
        , [Tags]
        , [Terms]
        , [Normal]
        , [Contractions, Expand]
        , [Contractions, Contract]
        , [Root]
        ]


commandSets : List NlpCmd
commandSets = [
    [Noun, Pluralize]
    , [Verb, Conjugate]
  ] ++ sentenceCommands
    ++ textCommands

make : NlpCmd -> String -> NlpRequest
make commands text =
    let commands' = (List.map (toString >> snake) commands)
    in {
        commands = commands',
            text = text
    }


