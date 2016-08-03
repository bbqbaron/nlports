port module Subscription exposing (subscriptions)

import Action
import Json.Encode
import Model
import NLP.Response as NLPR

port nlpResp : (Json.Encode.Value -> msg) -> Sub msg

-- is this not part of a standard API?
fork onOk onErr result =
    case result of
        Ok val -> onOk val
        Err err -> onErr err

subscriptions : a -> Sub Action.Action
subscriptions _ =
    NLPR.parse
    >> (fork
            Action.FromNlp
            Action.DammitJS)
    |> nlpResp
