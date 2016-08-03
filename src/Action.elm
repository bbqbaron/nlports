module Action exposing (Action(..))

import NLP.Command as NLPC
import NLP.Response as NLPR

type Action =
    FromNlp NLPR.NlpResponse
    | ToNlp NLPC.NlpCmd
    | SetText String
    | DammitJS String
    | Noop
