module Main exposing (..)

import Html exposing (Html)
import Html.App as Html

import Model exposing (Model,emptyModel,ConnectionStatus)
import Update exposing (update)
import View exposing (view)
import Msg exposing (subscriptions)
import FetchFrame exposing (fetchFrame)

--------------------------------------------------------------------------- MAIN


main : Program Never
main =
  Html.program
  { init = (emptyModel Model.Connecting, fetchFrame)
  , update = update
  , view = view
  , subscriptions = subscriptions }
