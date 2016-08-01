module NLP.Command.Text exposing (..)

import NLP.Command exposing (Text)

type Contractions = Expand | Contract

type TextCmd = ToPast | ToPresent | ToFuture | Negate | Tags | Terms | Normal | Contractions | Root

