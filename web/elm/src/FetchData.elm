module FetchData exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder,(:=))
import Task exposing (..)

import Model.Page exposing (..)
import Msg exposing (..)


fetchData : Cmd Msg
fetchData =
  Task.perform FetchFailure FetchSuccess request


request : Task Http.Error Int
request =
  Http.get knowledgebaseDecoder "http://localhost:4000/api/fetch"


knowledgebaseDecoder : Decoder Int
knowledgebaseDecoder =
  "dummy" := Decode.int
