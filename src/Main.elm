module Main exposing (..)

import Action
import Html.App as App
import Model
import Subscription
import View

main : Program Never
main =
  App.program
    { init = Model.init
    , view = View.view
    , update = Model.update
    , subscriptions = Subscription.subscriptions
    }
