module Subscription exposing (..)

import Html exposing (Html)

import Model exposing (..)


type Msg
  = Check Filter
  | Navigate Page

subscriptions : Model -> Sub Msg
subscriptions model =
  [] |> Sub.batch
