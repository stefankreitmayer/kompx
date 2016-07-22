module Msg exposing (..)

import Html exposing (Html)

import Model exposing (..)
import Model.Page exposing (..)
import Model.Aspect exposing (..)


type Msg
  = Check Aspect Option
  | Navigate Page

subscriptions : Model -> Sub Msg
subscriptions model =
  [] |> Sub.batch
