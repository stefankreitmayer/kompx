module Msg exposing (..)

import Html exposing (Html)
import Http

import Model exposing (..)
import Model.Page exposing (..)
import Model.Frame exposing (..)
import Model.Frame.Activity exposing (..)
import Model.Frame.Aspect exposing (..)


type Msg
  = Check Aspect Option
  | Navigate Page
  | ChooseActivity Activity
  | ToggleHelp
  | FetchSuccess Frame
  | FetchFailure Http.Error

subscriptions : Model -> Sub Msg
subscriptions model =
  [] |> Sub.batch
