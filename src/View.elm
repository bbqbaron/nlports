module View exposing (view)

import Action
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Model
import NLP.Command as NLPC
import NLP.Response as NLPR

view : Model.Model -> Html.Html Action.Action
view model =
    Html.div
        [Attributes.class "pure-g"]
        [
         Html.div [Attributes.class "pure-u-1-3"]
             [
              Html.p [] [Html.text "Text: "]
             , Html.input
                 [Attributes.value model.text
                 , Events.onInput Action.SetText
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
                       [Events.onClick (Action.ToNlp commands)
                       , Attributes.classList [("pure-button", True), ("pure-button-active", True)]]
                       [Html.text (toString commands)])
                  NLPC.commandSets)
        ]
