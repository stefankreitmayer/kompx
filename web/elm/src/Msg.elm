module Msg exposing (..)

import Html exposing (Html)

import Model exposing (..)
import Model.Page exposing (..)
import Model.Criterion exposing (..)


type Msg
  = Check Criterion Option
  | Navigate Page

subscriptions : Model -> Sub Msg
subscriptions model =
  [] |> Sub.batch
