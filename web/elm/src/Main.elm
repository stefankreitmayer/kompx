module Main exposing (..)

import Html exposing (Html)
import Html.App as Html

import Model exposing (Model,emptyModel)
import Update exposing (update)
import View exposing (view)
import Msg exposing (subscriptions)
import FetchData exposing (fetchData)

--------------------------------------------------------------------------- MAIN


main : Program Never
main =
  Html.program
  { init = (emptyModel, fetchData)
  , update = update
  , view = view
  , subscriptions = subscriptions }
