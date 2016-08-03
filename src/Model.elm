port module Model exposing (init, Model, update)

import Action
import NLP.Command as NLPC
import NLP.Response as NLPR

port nlpCmd : NLPC.NlpRequest -> Cmd msg

type alias Model =
    {
    text : String
    , answer : NLPR.NlpResponse
    , error : String
    }

init : (Model, Cmd x)
init =
    (
     {text = "She sells seashells.", answer = NLPR.empty, error = ""}
    , Cmd.none
    )

update : Action.Action -> Model -> (Model, Cmd msg)
update action model =
    case action of
        Action.SetText s ->
            ({model | text = s}, Cmd.none)
        Action.ToNlp cmds ->
            ({ model |
                   error = ""
                   , answer = NLPR.empty
             }
             , nlpCmd (NLPC.make cmds model.text))
        Action.FromNlp response ->
            ({model | answer = response}, Cmd.none)
        Action.DammitJS error ->
            ({model | error = error}, Cmd.none)
        Action.Noop ->
            (model, Cmd.none)
