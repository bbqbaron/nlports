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

port nlpCmd : (String, String) -> Cmd msg

port nlpResp : (Json.Encode.Value -> msg) -> Sub msg

init : (Model, Cmd Action)
init =
    (
     {text = "", answer = NLPR.empty, error = ""}
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
        []
        (
         [
          Html.input
              [Attributes.value model.text
              , Events.onInput SetText
              ]
              []
         , Html.text ("Response: " ++ (NLPR.print model.answer))
         , Html.text ("Error: " ++ model.error)
         ] ++
  -- buttons for the various questions
        (List.map
             (\command ->
                  Html.button
                  [Events.onClick (ToNlp command)]
                  [Html.text (toString command)])
             NLPC.commands)
            )

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
