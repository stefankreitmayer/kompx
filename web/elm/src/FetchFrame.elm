module FetchFrame exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder,(:=),list,string,int,bool)
import Task exposing (..)

import Model.Page exposing (..)
import Model.Frame exposing (..)
import Model.Frame.Activity exposing (..)
import Model.Frame.Aspect exposing (..)
import Msg exposing (..)


fetchFrame : Cmd Msg
fetchFrame =
  Task.perform FetchFailure FetchSuccess request


request : Task Http.Error Frame
request =
  Http.get frameDec "http://localhost:4000/api/frame"


frameDec : Decoder Frame
frameDec =
  "frame" :=
    Decode.object2
      Frame
      ("activities" := (list activityDec))
      ("aspects" := (list aspectDec))


activityDec : Decoder Activity
activityDec =
  Decode.object5
    Activity
    ("id" := int)
    ("title" := string)
    ("summary" := string)
    ("sections" := (list sectionDec))
    ("tagIds" := (list int))


sectionDec : Decoder Section
sectionDec =
  Decode.object2
    Section
    ("title" := string)
    ("body" := string)


aspectDec : Decoder Aspect
aspectDec =
  Decode.object3
    Aspect
    ("name" := string)
    ("position" := int)
    ("options" := (list optionDec))


optionDec : Decoder Option
optionDec =
  let
      createOption = (\name tagId -> Option name tagId False)
  in
      Decode.object2
        createOption
        ("name" := string)
        ("tagId" := int)
