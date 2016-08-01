module NLP.Response exposing (..)

import Json.Decode as Json exposing ((:=))
import Json.Decode.Extra as JsonExtra exposing ((|:))

type alias Conjugations = {
    past: String
    , infinitive: String
    , gerund: String
    , actor: String
    , present: String
    , future: String
    , perfect: String
    , pluperfect: String
    , future_perfect: String
}

type NlpResponse =
    Text String
    | Conj Conjugations
    | Empty

-- constructors
empty = Empty

print : NlpResponse -> String
print resp =
    case resp of
        Text s -> s
        Conj c -> toString c
        Empty -> ""

parse : Json.Value -> Result String NlpResponse
parse =
    Json.oneOf
        [
         Json.map Conj conjugationJson
        , Json.map Text Json.string
        ]
        |> Json.decodeValue

conjugationJson : Json.Decoder Conjugations
conjugationJson =
    Json.succeed Conjugations
        |: ("past" := Json.string)
        |: ("infinitive" := Json.string)
        |: ("gerund" := Json.string)
        |: ("actor" := Json.string)
        |: ("present" := Json.string)
        |: ("future" := Json.string)
        |: ("perfect" := Json.string)
        |: ("pluperfect" := Json.string)
        |: ("future_perfect" := Json.string)
