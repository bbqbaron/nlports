port module Main exposing (..)

import Html
import Html.App as App
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Json

type NlpResponse = Sentence String | Empty

type Action =
    FromNlp String
    | ToNlp
    | Text String
    | Noop

type alias Model =
    {
        text : String
        , answer : NlpResponse
    }

port nlpCmd : (String, String) -> Cmd msg

port nlpResp : (String -> msg) -> Sub msg

print : NlpResponse -> String
print resp =
    case resp of
        Sentence s -> s
        Empty -> ""

init : (Model, Cmd Action)
init =
    (
     {text = "", answer = Empty}
    , Cmd.none
    )

update : Action -> Model -> (Model, Cmd msg)
update action model =
    case action of
        Text s -> ({model | text = s}, Cmd.none)
        -- TODO encode union type of NlpCommand to string?
        ToNlp -> (model, nlpCmd ("Past", model.text))
        FromNlp s -> ({model | answer = Sentence s}, Cmd.none)
        Noop -> (model, Cmd.none)

subscriptions : Model -> Sub Action
subscriptions model =
    nlpResp FromNlp

onEnter : Int -> Action
onEnter code =
    if code == 13
    then ToNlp
    else Noop

view : Model -> Html.Html Action
view model =
    Html.div [
         Events.on "keydown" (Json.map onEnter Events.keyCode)
        ] [
         Html.input
             [Attributes.value model.text
             , Events.onInput Text
             ]
             []
         , Html.text ("Response: " ++ (print model.answer))
         , Html.button
             [Events.onClick ToNlp]
             [Html.text "Past tense"]
        ]

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
