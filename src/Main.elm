port module Main exposing (..)

import Html
import Html.App as App
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Json exposing ((:=))
import Json.Encode
import NLP.Command as NLPC
import NLP.Response as NLPR

type Action =
    FromNlp NLPR.NlpResponse
    | ToNlp NLPC.NlpCmd
    | SetText String
    | DammitJS String
    | Noop

type alias Model =
    {
    text : String
    , answer : NLPR.NlpResponse
    , error : String
    }

port nlpCmd : NLPC.NlpRequest -> Cmd msg

port nlpResp : (Json.Encode.Value -> msg) -> Sub msg

init : (Model, Cmd Action)
init =
    (
     {text = "She sells seashells.", answer = NLPR.empty, error = ""}
    , Cmd.none
    )

update : Action -> Model -> (Model, Cmd msg)
update action model =
    case action of
        SetText s ->
            ({model | text = s}, Cmd.none)
        ToNlp cmds ->
            ({ model |
                   error = ""
                   , answer = NLPR.empty
             }
             , nlpCmd (NLPC.make cmds model.text))
        FromNlp response ->
            ({model | answer = response}, Cmd.none)
        DammitJS error ->
            ({model | error = error}, Cmd.none)
        Noop ->
            (model, Cmd.none)

-- is this not part of a standard API?
fork onOk onErr result =
    case result of
        Ok val -> onOk val
        Err err -> onErr err

subscriptions : Model -> Sub Action
subscriptions model =
    NLPR.parse
    >> (fork
            FromNlp
            DammitJS)
    |> nlpResp

view : Model -> Html.Html Action
view model =
    Html.div
        [Attributes.class "pure-g"]
        [
         Html.div [Attributes.class "pure-u-1-3"]
             [
              Html.p [] [Html.text "Text: "]
             , Html.input
                 [Attributes.value model.text
                 , Events.onInput SetText
                 , Attributes.type' "text"
                 , Attributes.class "pure-input-1"
                 ]
                  []
             ]
         , Html.div [Attributes.class "pure-u-1-3"]
             [
              Html.p [] [Html.text ("Response: " ++ (NLPR.print model.answer))]
             , Html.p [] [Html.text ("Error: " ++ model.error)]
             ]
         , Html.div [Attributes.class "pure-u-1-3"]
             (List.map
                  (\commands ->
                       Html.button
                       [Events.onClick (ToNlp commands)
                       , Attributes.classList [("pure-button", True), ("pure-button-active", True)]]
                       [Html.text (toString commands)])
                  NLPC.commandSets)
        ]

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
