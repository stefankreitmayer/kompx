module Model.Knowledgebase.Aspect exposing (..)

type alias Aspect =
  { name : String
  , position : Int
  , options : List Option }

type alias Option =
  { name : String
  , checked : Bool }

