module Model.Aspect exposing (..)

type alias Aspect =
  { name : String
  , options : List Option }

type alias Option =
  { name : String
  , checked : Bool }

