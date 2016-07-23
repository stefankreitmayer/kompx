module FetchFrame exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder,(:=))
import Task exposing (..)

import Model.Page exposing (..)
import Msg exposing (..)


fetchFrame : Cmd Msg
fetchFrame =
  Task.perform FetchFailure FetchSuccess request


request : Task Http.Error Int
request =
  Http.get frameDecoder "http://localhost:4000/api/fetch"


frameDecoder : Decoder Int
frameDecoder =
  "dummy" := Decode.int
