port module Main exposing (..)

import Html
import Html.App as App
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Json exposing ((:=))
import Json.Encode

type alias Conjugations =
    {
        past: String
    , infinitive: String
    , gerund: String
    , actor: String
    , present: String
    , future: String
    , perfect: String
    , pluperfect: String
    -- TODO curse you object8! i need object9!
--    , future_perfect: String
    }

type NlpResponse =
    Text String
    | Conj Conjugations
    | Empty

type NlpCmd =
    Past
    | Plural
    | Conjugate

type Action =
    FromNlp NlpResponse
    | ToNlp NlpCmd
    | SetText String
    | DammitJS String
    | Noop

type alias Model =
    {
    text : String
    , answer : NlpResponse
    , error : String
    }

port nlpCmd : (String, String) -> Cmd msg

port nlpResp : (Json.Encode.Value -> msg) -> Sub msg

print : NlpResponse -> String
print resp =
    case resp of
        Text s -> s
        Conj c -> toString c
        Empty -> ""

init : (Model, Cmd Action)
init =
    (
     {text = "", answer = Empty, error = ""}
    , Cmd.none
    )

update : Action -> Model -> (Model, Cmd msg)
update action model =
    case action of
        SetText s ->
            ({model | text = s}, Cmd.none)
        ToNlp cmd ->
            (model, nlpCmd ((toString cmd), model.text))
        FromNlp response ->
            ({model | answer = response}, Cmd.none)
        DammitJS error ->
            ({model | error = error}, Cmd.none)
        Noop ->
            (model, Cmd.none)

conjugationJson : Json.Decoder Conjugations
conjugationJson =
    Json.object8 Conjugations
        ("past" := Json.string)
        ("infinitive" := Json.string)
        ("gerund" := Json.string)
        ("actor" := Json.string)
        ("present" := Json.string)
        ("future" := Json.string)
        ("perfect" := Json.string)
        ("pluperfect" := Json.string)

parse : Json.Decoder NlpResponse
parse =
    Json.oneOf
        [
         Json.map Conj conjugationJson
        , Json.map Text Json.string
        ]

-- is this not part of a standard API?
fork onOk onErr result =
    case result of
        Ok val -> onOk val
        Err err -> onErr err

subscriptions : Model -> Sub Action
subscriptions model =
    (Json.decodeValue parse)
    >> (fork
            FromNlp
            DammitJS)
    |> nlpResp

view : Model -> Html.Html Action
view model =
    Html.div
        []
        (
         [
          Html.input
              [Attributes.value model.text
              , Events.onInput SetText
              ]
              []
         , Html.text ("Response: " ++ (print model.answer))
         , Html.text ("Error: " ++ model.error)
         ] ++
  -- buttons for the various questions
        (List.map
             (\command ->
                  Html.button
                  [Events.onClick (ToNlp command)]
                  [Html.text (toString command)])
             [Past, Plural, Conjugate])
            )

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
